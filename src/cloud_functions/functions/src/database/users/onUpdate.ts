import { functions, db, log } from '../../imports'

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
