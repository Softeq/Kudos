import { functions, log, sendPushToUser } from '../../imports'

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

        await sendPushToUser(userId, payload);

        log('Successfully finished');
    });
