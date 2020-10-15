import { functions, db, log } from '../../imports'

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
