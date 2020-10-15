import { functions, db, storage, log } from '../imports'

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
