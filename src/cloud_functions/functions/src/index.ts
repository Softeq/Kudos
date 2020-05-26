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

