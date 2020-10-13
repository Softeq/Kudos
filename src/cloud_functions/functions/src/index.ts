import * as functions from 'firebase-functions';
import admin = require('firebase-admin');
import notifications = require('./services/user_notifications');

admin.initializeApp();
const db = admin.firestore();

/**
 * Trigger updates information about Team in achievements collection
 * when Team name changes
 */
export const updateTeam = functions.firestore.document('teams/{teamId}').onUpdate(async (snapshot, context) => {
    const oldData = snapshot.before.data();
    const newData = snapshot.after.data();

    if (!oldData || !newData) {
        return;
    }

    const teamId: string = context.params.teamId;
    const qs = await db.collection('achievements').where('team.id', "==", teamId).get();
    if (qs.docs.length === 0) {
        return;
    }

    const batch = db.batch();

    //update team name in achievements collection
    const oldName: string = oldData.name;
    const newName: string = newData.name;

    //update team members for achievements
    const oldMembers: Array<any> = oldData.members;
    const newMembers: Array<any> = newData.members;

    //update achievement access level
    const oldAccessLevel: number = oldData.access_level;
    const newAccessLevel: number = newData.access_level;

    if ((oldName !== newName)
        || (oldAccessLevel !== newAccessLevel)
        || (!mapArraysEquals(oldMembers, newMembers))) {
        const data = {
            team: {
                id: teamId,
                name: newName,
            },
            team_members: newMembers,
            access_level: newAccessLevel,
        };

        qs.docs.forEach((x) => {
            batch.set(x.ref, data, { merge: true });
        });
    }
    //end update achievement access level

    await batch.commit();
});

/**
 * Trigger updates information about Achievement in achievement_references collection
 * when Achievement image_url or name changes
 */
export const updateAchievement = functions.firestore.document('achievements/{achievementId}').onUpdate(async (snapshot, context) => {
    const oldData = snapshot.before.data();
    const newData = snapshot.after.data();

    if (!oldData || !newData) {
        return;
    }

    const oldUrl: string = oldData.image_url;
    const newUrl: string = newData.image_url;

    const oldName: string = oldData.name;
    const newName: string = newData.name;

    if (oldUrl === newUrl && oldName === newName) {
        return;
    }

    const achievementId: string = context.params.achievementId;

    const qs = await db.collectionGroup('achievement_references').where('achievement.id', "==", achievementId).get();
    if (qs.docs.length === 0) {
        return;
    }

    const data = {
        achievement: {
            id: achievementId,
            name: newName,
            image_url: newUrl,
        },
    };

    const batch = db.batch();

    qs.docs.forEach((x) => {
        batch.set(x.ref, data, { merge: true });
    });

    await batch.commit();
});

/**
 * Trigger sends push notification to User when he gets a new achievement
 */
export const createAchievementReferences = functions.firestore.document('/users/{userId}/achievement_references/{referenceId}').onCreate(async (snapshot, context) => {
    const documentData = snapshot.data();

    if (!documentData) {
        return;
    }

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
});

/**
 * Cleans up unused images from storage
 * Runs every day at 00.00 Minsk time
 */
export const cleanupStorage = functions.pubsub
    .schedule('every 24 hours')
    .timeZone('Europe/Minsk')
    .onRun(async (context) => {
    const images: Array<string> = new Array<string>();

    const achievements = await db.collection('achievements').get();
    achievements.docs.forEach(x => {
        const image_name: string = x.data().image_name;
        if (image_name) {
            images.push(`kudos/${image_name}`);
        }
    });

    const teams = await db.collection('teams').get();
    teams.docs.forEach(x => {
        const image_name: string = x.data().image_name;
        if (image_name) {
            images.push(`kudos/${image_name}`);
        }
    });

    const storage = admin.storage();
    const filesResponse = await storage.bucket().getFiles({ directory: 'kudos' });
    filesResponse[0].forEach(async x => {
        if (!images.some(y => y === x.name)) {
            await x.delete();
        }
    });
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

    const batch = db.batch();

    users.forEach(x => {
        const userId = x.email.split('@')[0];
        const ref = db.collection('users').doc(userId);
        const data = {
            email: x.email,
            name: x.name
        };
        batch.set(ref, data, { merge: true });
    });

    await batch.commit();

    response.status(200).send();
});

/**
 * Trigger add added user to the Softeq team
 */
export const createUser = functions.firestore.document('/users/{userId}').onCreate(async (snapshot, context) => {
    const documentData = snapshot.data();

    if (!documentData) {
        return;
    }

    const userId: string = context.params.userId;
    const softeqTeam = await db.collection('teams').doc('1OXbbvRAI9QL7Vv8aD8B').get();
    const softeqTeamData = softeqTeam.data();

    if (!softeqTeamData) {
        return;
    }

    const members: Array<any> = softeqTeamData.team_members;
    members.push({
        id: userId,
        name: documentData.name
    });

    const visibleFor: Array<any> = softeqTeamData.visible_for;
    visibleFor.push(userId);

    await softeqTeam.ref.set({ team_members: members, visible_for: visibleFor }, { merge: true });
});

/**
 * Trigger updates information about User in achievements/holders subcollection
 * when User image_url or name changes
 */
export const updateUser = functions.firestore.document('users/{userId}').onUpdate(async (snapshot, context) => {
    const oldData = snapshot.before.data();
    const newData = snapshot.after.data();

    if (!oldData || !newData) {
        return;
    }

    const oldUrl: string = oldData.image_url;
    const newUrl: string = newData.image_url;

    const oldName: string = oldData.name;
    const newName: string = newData.name;

    if (oldUrl === newUrl && oldName === newName) {
        return;
    }

    const userId: string = context.params.userId;

    const qs = await db.collectionGroup('holders').where('recipient.id', '==', userId).get();
    if (qs.docs.length === 0) {
        return;
    }

    const data = {
        recipient: {
            id: userId,
            name: newName,
            image_url: newUrl,
        },
    };

    const batch = db.batch();

    qs.docs.forEach(x => {
        batch.set(x.ref, data, { merge: true });
    });

    await batch.commit();
});

function mapArraysEquals(array1: Array<Map<string, any>>, array2: Array<Map<string, any>>): boolean {
    if (array1.length !== array2.length) {
        return false;
    }

    const sortedArray1 = array1.sort(mapComparer);
    const sortedArray2 = array2.sort(mapComparer);

    for (let i = 0; i < sortedArray1.length; i++) {
        if (!mapEquals(sortedArray1[i], sortedArray2[i]))
        {
            return false;
        }
    }

    return true;
}

function mapEquals(map1: Map<string, any>, map2: Map<string, any>): boolean {
    if (map1.size !== map2.size)
    {
        return false;
    }

    for (const key in map1.keys) {
        if (!map2.has(key) || map1.get(key) !== map2.get(key))
        {
            return false;
        }
    }

    return true;
}

function mapComparer(map1: Map<string, any>, map2: Map<string, any>) {
    if (map1.get("id") > map2.get("id")) {
        return 1;
    }

    if (map1.get("id") < map2.get("id")) {
        return -1;
    }

    return 0;
}

class User {
    name: string;
    email: string;

    constructor(name: string, email: string) {
        this.name = name;
        this.email = email;
    }
}