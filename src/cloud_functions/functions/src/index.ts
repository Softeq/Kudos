import { isEqual, sortBy } from 'lodash';
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp(); // must be before any usage

import * as notifications from './services/user_notifications';
import { User } from './models/user';

const db = admin.firestore();
const storage = admin.storage();
const log = console.log;

/**
 * Trigger updates information about Team in achievements collection
 * when team name, access level, team members changes
 */
export const updateTeam = functions.firestore
    .document('teams/{teamId}')
    .onUpdate(async (snapshot, context) => {
        const oldData = snapshot.before.data();
        const newData = snapshot.after.data();

        if (!oldData || !newData) {
            log('Old or New data is null!');
            return;
        }

        const oldName: string = oldData.name;
        const newName: string = newData.name;

        const oldAccessLevel: number = oldData.access_level;
        const newAccessLevel: number = newData.access_level;

        const oldMembers: Array<any> = oldData.members;
        const newMembers: Array<any> = newData.members;

        const isMapsEqual = (a: any, b: any) : boolean => isEqual(sortBy(a, 'id'), sortBy(b, 'id'));

        if (oldName === newName
            && oldAccessLevel === newAccessLevel
            && isMapsEqual(oldMembers, newMembers)) {
                log('The data hasn\'t been modified!');
                return;
            }

        const teamId: string = context.params.teamId;
        const qs = await db.collection('achievements').where('team.id', "==", teamId).get();
        const teamAchievements = qs.docs;

        if (teamAchievements.length === 0) {
            log(`The team (${teamId}) doesn't have any achievements!`);
            return;
        }

        log('Start updating');

        const newAchievementData = {
            team: {
                id: teamId,
                name: newName,
            },
            access_level: newAccessLevel,
            team_members: newMembers
        };

        const batch = db.batch();

        teamAchievements.forEach(x => {
            batch.set(x.ref, newAchievementData, { merge: true });
        });

        await batch.commit();

        log(`Successfully updated ${teamAchievements.length} records.`);
    });

/**
 * Trigger updates information about Achievement in achievement_references collection
 * when Achievement image_url or name changes
 */
export const updateAchievement = functions.firestore
    .document('achievements/{achievementId}')
    .onUpdate(async (snapshot, context) => {
        const oldData = snapshot.before.data();
        const newData = snapshot.after.data();

        if (!oldData || !newData) {
            log('Old or New data is null!');
            return;
        }

        const oldUrl: string = oldData.image_url;
        const newUrl: string = newData.image_url;

        const oldName: string = oldData.name;
        const newName: string = newData.name;

        if (oldUrl === newUrl && oldName === newName) {
            log('The data hasn\'t been modified!');
            return;
        }

        const achievementId: string = context.params.achievementId;
        const qs = await db.collectionGroup('achievement_references')
            .where('achievement.id', "==", achievementId).get();
        const achievementReferences = qs.docs;

        if (achievementReferences.length === 0) {
            log('No assigned achievements found!');
            return;
        }

        log('Start updating');

        const newAchievementData = {
            achievement: {
                id: achievementId,
                name: newName,
                image_url: newUrl,
            },
        };

        const batch = db.batch();

        achievementReferences.forEach(x => {
            batch.set(x.ref, newAchievementData, { merge: true });
        });

        await batch.commit();

        log(`Successfully updated ${achievementReferences.length} records.`);
    });

/**
 * Trigger sends push notification to User when he gets a new achievement
 */
export const createAchievementReferences = functions.firestore
    .document('/users/{userId}/achievement_references/{referenceId}')
    .onCreate(async (snapshot, context) => {
        const documentData = snapshot.data();

        if (!documentData) {
            log('Document data is null!');
            return;
        }

        log('Start handling');

        const userId: string = context.params.userId;
        const achievementName = documentData.achievement.name;
        const senderName = documentData.sender.name;
        const payload = {
            notification: {
                title: 'Congratulations!',
                body: `You received ${achievementName} from ${senderName}`,
                sound: "default",
            }
        };

        await notifications.sendToUser(userId, payload);

        log('Successfully finished');
    });

/**
 * Cleans up unused images from storage
 * Runs every day at 00.00 Minsk time
 */
export const cleanupStorage = functions.pubsub
    .schedule('0 0 * * *') // every day at midnight
    .timeZone('Europe/Minsk')
    .onRun(async _ => {
        const imageNames: Array<string> = new Array<string>();

        log('Get images from achievements');

        const achievements = await db.collection('achievements').get();
        achievements.docs.forEach(x => {
            const image_name: string = x.data().image_name;
            if (image_name) {
                imageNames.push(`kudos/${image_name}`);
            }
        });

        log('Get images from teams');

        const teams = await db.collection('teams').get();
        teams.docs.forEach(x => {
            const image_name: string = x.data().image_name;
            if (image_name) {
                imageNames.push(`kudos/${image_name}`);
            }
        });

        log(`Found ${imageNames.length} images in database`);

        const filesResponse = await storage.bucket().getFiles({ directory: 'kudos' });
        const files = filesResponse[0];

        log(`Found ${files.length} images in storage`);

        log('Delete unused images from storage');

        const tasksForDelete = files
            .filter(file => !imageNames.some(imageName => imageName === file.name))
            .map(file => file.delete());

        await Promise.all(tasksForDelete);

        log(`Successfully deleted ${tasksForDelete.length} images`);
    });

/**
 * Automatically add users to the system
 * request sample:
 *
 * curl --location --request POST '[url]' \
 * --header 'Content-Type: application/json' \
 * --data-raw '{
 *     "users": [
 *         {
 *             "email": "test.user1@softeq.com",
 *             "name": "Test User1"
 *         },
 *         {
 *             "email": "test.user2@softeq.com",
 *             "name": "Test User2"
 *         }
 *     ]
 * }'
 */
export const addUsers = functions.https.onRequest(async (request, response) => {
    const json = JSON.parse(JSON.stringify(request.body));
    const users: Array<User> = json.users;

    log(`Start importing ${users.length} users`);

    const batch = db.batch();

    users.forEach(user => {
        const userId = user.email.split('@')[0];
        const userDocumentRef = db.collection('users').doc(userId);
        const newUserData = {
            email: user.email,
            name: user.name
        };
        batch.set(userDocumentRef, newUserData, { merge: true });
    });

    await batch.commit();

    log(`Successfully imported`);

    response.status(200).send();
});

/**
 * Trigger add added user to the Softeq team
 */
export const createUser = functions.firestore
    .document('/users/{userId}')
    .onCreate(async (snapshot, context) => {
        const documentData = snapshot.data();

        if (!documentData) {
            log('Document data is null!');
            return;
        }

        const userId: string = context.params.userId;

        const softeqTeamId = '1OXbbvRAI9QL7Vv8aD8B';
        const softeqTeam = await db.collection('teams').doc(softeqTeamId).get();
        const softeqTeamData = softeqTeam.data();

        if (!softeqTeamData) {
            log('Softeq team data is null!');
            return;
        }

        log('Start updating Softeq team');

        const newTeamMember = {
            id: userId,
            name: documentData.name
        };

        const teamMembers = [...softeqTeamData.team_members, newTeamMember];
        const visibleFor = [...softeqTeamData.visible_for, userId];

        const newTeamData = {
            team_members: teamMembers,
            visible_for: visibleFor
        };

        await softeqTeam.ref.set(newTeamData, { merge: true });

        log('Successfully updated');
    });

/**
 * Trigger updates information about User in achievements/holders sub-collection
 * when User image_url or name changes
 */
export const updateUser = functions.firestore
    .document('users/{userId}')
    .onUpdate(async (snapshot, context) => {
        const oldData = snapshot.before.data();
        const newData = snapshot.after.data();

        if (!oldData || !newData) {
            log('Old or New data is null!');
            return;
        }

        const oldUrl: string = oldData.image_url;
        const newUrl: string = newData.image_url;

        const oldName: string = oldData.name;
        const newName: string = newData.name;

        if (oldUrl === newUrl && oldName === newName) {
            log('The data hasn\'t been modified!');
            return;
        }

        const userId: string = context.params.userId;
        const qs = await db.collectionGroup('holders').where('recipient.id', '==', userId).get();
        const holders = qs.docs;

        if (holders.length === 0) {
            log('Holders group is empty!');
            return;
        }

        log('Start updating');

        const newHolderData = {
            recipient: {
                id: userId,
                name: newName,
                image_url: newUrl,
            },
        };

        const batch = db.batch();

        holders.forEach(x => {
            batch.set(x.ref, newHolderData, { merge: true });
        });

        await batch.commit();

        log(`Successfully updated ${holders.length} records.`);
    });
