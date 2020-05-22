import * as functions from 'firebase-functions';
import admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

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

    const qs = await db.collection('achievements').where('team_id', "==", teamId).get();
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
