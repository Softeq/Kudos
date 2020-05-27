import * as functions from 'firebase-functions';
import admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

/**
 * Trigger updates information about team in achievements collection
 * when team name changes
 */
export const updateTeam = functions.firestore.document('teams/{teamId}').onUpdate(async (snapshot, context) => {
    const oldData = snapshot.before.data();
    const newData = snapshot.after.data();

    if (!oldData || !newData) {
        return;
    }

    const oldName: string = oldData.name;
    const newName: string = newData.name;

    if (oldName === newName) {
        return;
    }

    const teamId: string = context.params.teamId;

    const qs = await db.collection('achievements').where('team.id', "==", teamId).get();
    if (qs.docs.length === 0) {
        return;
    }

    const data = {
        team: {
            id: teamId,
            name: newName,
        },
    };

    const batch = db.batch();

    qs.docs.forEach((x) => {
        batch.set(x.ref, data, { merge: true });
    });

    await batch.commit();
});

/**
 * Trigger updates information about achievement in achievement_references collection
 * when achievement image_url changes
 */
export const updateAchievement = functions.firestore.document('achievements/{achievementId}').onUpdate(async (snapshot, context) => {
    const oldData = snapshot.before.data();
    const newData = snapshot.after.data();

    if (!oldData || !newData) {
        return;
    }

    const oldValue: string = oldData.image_url;
    const newValue: string = newData.image_url;

    if (oldValue === newValue) {
        return;
    }

    const achievementId: string = context.params.achievementId;

    const qs = await db.collectionGroup('achievement_references').where('achievement.id', "==", achievementId).get();
    if (qs.docs.length === 0) {
        return;
    }

    const achievementName = newData.name;

    const data = {
        achievement: {
            id: achievementId,
            name: achievementName,
            imageUrl: newValue,
        },
    };

    const batch = db.batch();

    qs.docs.forEach((x) => {
        batch.set(x.ref, data, { merge: true });
    });

    await batch.commit();
});

/**
 * Trigger sends push notification to user when he gets a new achievement 
 */
export const onCreateAchievementReferences = functions.firestore.document('/users/{userId}/achievement_references/{referenceId}').onCreate(async (snapshot, context) => {
    const documentData = snapshot.data();

    if (!documentData) {
        return;
    }

    const userId: string = context.params.userId;

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

export const testFunc = functions.https.onRequest(async (request, response) => {
    const qs = await db.collection('/users/vadim.pylsky/push_tokens').get();
    if (qs.docs.length === 0) {
        return;
    }

    const tokens: Array<string> = new Array<string>();

    qs.docs.forEach(x => {
        const token: string = x.data().token;
        if (token) {
            tokens.push(token);
        }
    });

    if (tokens.length === 0) {
        return;
    }

    const payload = {
        notification: {
            title: 'Congratulations!',
            body: 'You recieved',
        }
    };

    const messagingResponse = await admin.messaging().sendToDevice(tokens, payload);

    const invalidTokens: Array<string> = new Array<string>();

    messagingResponse.results.forEach(x => {
        if (x.error) {
            invalidTokens.push(x.error.code);
        } else {
            invalidTokens.push("ololol");
        }

        if (x.canonicalRegistrationToken) {
            invalidTokens.push(x.canonicalRegistrationToken);
        } else {
            invalidTokens.push("fffffff");
        }
    });

    response.send({ invalidTokens: invalidTokens });
});

/**
 * Cleans up unused images from storage
 */
export const cleanupStorage = functions.https.onRequest(async (request, response) => {
    const achievementImages: Array<string> = new Array<string>();
    const qs = await db.collection('achievements').get();
    qs.docs.forEach(x => {
        const image_name: string = x.data().image_name;
        if (image_name) {
            achievementImages.push(`kudos/${image_name}`);
        }
    });

    const storage = admin.storage();
    const filesResponse = await storage.bucket().getFiles({ directory: 'kudos' });
    const deletedFiles: Array<string> = new Array<string>();
    filesResponse[0].forEach(async x => {
        if (!achievementImages.some(y => y === x.name)) {
            deletedFiles.push(x.name);
            await x.delete();
        }
    });

    response.send({ deleted_files: deletedFiles });
});

