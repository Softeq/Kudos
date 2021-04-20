import { db } from '../imports'
import axios from 'axios'

export const trySendNotificationToHaloChannel = async (achievementId: string, userId: string, senderId: string, message: string) => {
    const achievement = await db.collection("achievements").doc(achievementId).get();
    const achievementData = achievement.data();

    if (!achievementData) {
        return;
    }

    const haloTeamId = "RFWwHqQY70WRwfgXYRMn";
    const teamId: string = achievementData.team?.id;

    if (haloTeamId != teamId) {
        return;
    }

    const url = "https://hooks.slack.com/services/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";

    const data = {
        blocks: [
            {
                type: "section",
                text: {
                    type: "mrkdwn",
                    text: `@${userId} has received\n*${achievementData.name}*`
                },
                accessory: {
                    type: "image",
                    image_url: achievementData.image_url,
                    alt_text: "kudos thumbnail"
                }
            },
            {
                type: "section",
                text: {
                    type: "mrkdwn",
                    text: `${message}\n\nfrom @${senderId}`
                }
            }
        ]
    };

    await axios.post(url, data);
};