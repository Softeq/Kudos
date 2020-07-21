import * as functions from 'firebase-functions';
import admin = require('firebase-admin');

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

    //begin update team name in achievements collection
    const oldName: string = oldData.name;
    const newName: string = newData.name;

    if (oldName !== newName) {
        const data = {
            team: {
                id: teamId,
                name: newName,
            },
        };

        qs.docs.forEach((x) => {
            batch.set(x.ref, data, { merge: true });
        });
    }
    //end update team name in achievements collection

    //begin update edit rights for achievements
    const oldOwners: Array<any> = oldData.team_owners;
    const newOwners: Array<any> = newData.team_owners;
    if (oldOwners && newOwners) {
        const oldIds = oldOwners.map<String>(x => x.id);
        const newIds = newOwners.map<String>(x => x.id);

        if (!arraysEquals(oldIds, newIds)) {
            const data = {
                owners: newIds,
            };

            qs.docs.forEach((x) => {
                batch.set(x.ref, data, { merge: true });
            });
        }
    }
    //end update edit rights for achievements

    //begin update send rights for achievements
    const oldMembers: Array<any> = oldData.team_members;
    const newMembers: Array<any> = newData.team_members;
    if (oldMembers && newMembers) {
        const oldIds = oldMembers.map<String>(x => x.id);
        const newIds = newMembers.map<String>(x => x.id);

        if (!arraysEquals(oldIds, newIds)) {
            const data = {
                members: newIds,
            };

            qs.docs.forEach((x) => {
                batch.set(x.ref, data, { merge: true });
            });
        }
    }
    //end update send rights for achievements

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

    const qs = await db.collectionGroup('holders').where('recipient.id', "==", userId).get();
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

    qs.docs.forEach((x) => {
        batch.set(x.ref, data, { merge: true });
    });

    await batch.commit();
});

/**
 * Trigger updates received Achievements count in users collection
 * and sends push notification to User when he gets a new achievement
 */
export const onCreateAchievementReferences = functions.firestore.document('/users/{userId}/achievement_references/{referenceId}').onCreate(async (snapshot, context) => {
    const documentData = snapshot.data();

    if (!documentData) {
        return;
    }

    const userId: string = context.params.userId;

    // start update received achievements count in users collection
    await db.collection('users').doc(userId).
        update({ received_achievements_count: admin.firestore.FieldValue.increment(1) });
    // end update received achievements count in users collection

    const qs = await db.collection(`/users/${userId}/push_tokens`).get();
    if (qs.docs.length === 0) {
        return;
    }

    const tokens: Array<string> = new Array<string>();

    qs.docs.forEach(x => {
        const token: string = x.data().token;
        tokens.push(token);
    });

    if (tokens.length === 0) {
        return;
    }

    const achievementName = documentData.achievement.name;
    const senderName = documentData.sender.name;

    const payload = {
        notification: {
            title: 'Congratulations!',
            body: `You received ${achievementName} from ${senderName}`,
            sound: "default",
        }
    };

    const response = await admin.messaging().sendToDevice(tokens, payload);

    const invalidTokens: Array<number> = new Array<number>();

    for (let index = 0; index < response.results.length; index++) {
        const x = response.results[index];
        if (x.error && x.error.code === 'messaging/registration-token-not-registered') {
            invalidTokens.push(index);
        }
    }

    if (invalidTokens.length === 0) {
        return;
    }

    const batch = db.batch();

    invalidTokens.forEach(x => {
        batch.delete(qs.docs[x].ref);
    });

    await batch.commit();
});

/**
 * Cleans up unused images from storage
 */
export const cleanupStorage = functions.https.onRequest(async (request, response) => {
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
    const deletedFiles: Array<string> = new Array<string>();
    filesResponse[0].forEach(async x => {
        if (!images.some(y => y === x.name)) {
            deletedFiles.push(x.name);
            await x.delete();
        }
    });

    response.send({ deleted_files: deletedFiles });
});

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

export const onCreateUser = functions.firestore.document('/users/{userId}').onCreate(async (snapshot, context) => {
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

function arraysEquals(array1: Array<String>, array2: Array<String>): boolean {
    if (array1.length !== array2.length) {
        return false;
    }

    const sortedArray1 = array1.sort(stringComparer);
    const sortedArray2 = array2.sort(stringComparer);

    for (let i = 0; i < sortedArray1.length; i++) {
        if (sortedArray1[i] !== sortedArray2[i]) {
            return false;
        }
    }

    return true;
}

function stringComparer(value1: String, value2: String) {
    if (value1 > value2) {
        return 1;
    }

    if (value1 < value2) {
        return -1;
    }

    return 0;
}

class User {
    name: String;
    email: String;

    constructor(name: String, email: String) {
        this.name = name;
        this.email = email;
    }
}