import { db } from '../imports'
import axios from 'axios'

export const trySendSlackNotification = async (achievementId: string, userId: string, senderId: string, message: string) => {
    const achievement = await db.collection("achievements").doc(achievementId).get();
    const achievementData = achievement.data();

    if (!achievementData) {
        return;
    }

    const teamId: string = achievementData.team?.id;

    if (!teamId) {
        return;
    }

    const team = await db.collection("teams").doc(teamId).get();
    const teamData = team.data();

    if (!teamData) {
        return;
    }

    const slackChannel: string = teamData.slack_channel;
    const webhook_url: string = teamData.webhook_url;

    if (!slackChannel || !webhook_url) {
        return;
    }

    const data = {
        channel: `#${slackChannel}`,
        blocks: [
            {
                type: "section",
                text: {
                    type: "mrkdwn",
                    text: `@${userId} has received *${achievementData.name}*\n\n${message}\n\nfrom @${senderId}`
                },
                accessory: {
                    type: "image",
                    image_url: achievementData.image_url,
                    alt_text: "kudos thumbnail"
                }
            }
        ]
    };

    await axios.post(webhook_url, data);
};