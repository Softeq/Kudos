import * as admin from 'firebase-admin';

const db = admin.firestore();
const fcm = admin.messaging();
const log = console.log;

export const sendPushToUser = async (userId: string, payload: admin.messaging.MessagingPayload) => {

    // get user's push tokens
    const pushTokensSnapshot = await db.collection(`/users/${userId}/push_tokens`).get();
    const pushTokensDocuments = pushTokensSnapshot.docs;

    if (pushTokensDocuments.length === 0) {
        log(`User ${userId} doesn't have any push tokens!`);
        return;
    }

    const tokens = pushTokensDocuments.map(x => x.data().token);

    if (tokens.length === 0) {
        log(`User ${userId} doesn't have any push tokens!`);
        return;
    }

    log(`User ${userId} found push tokens: ${tokens.length}!`);

    // send push notifications to all user's devices
    const response = await fcm.sendToDevice(tokens, payload);

    log(`Message to user ${userId} successfully sent`);

    // https://firebase.google.com/docs/cloud-messaging/send-message#admin
    const errorCodes : Array<string> = [
        'messaging/invalid-registration-token',
        'messaging/registration-token-not-registered'
    ];

    // https://github.com/firebase/functions-samples/blob/077952f5dd4a368e031600b36ae43f5385687350/fcm-notifications/functions/index.js#L77
    const invalidTokenIndexes = response.results
        .filter(result => result.error && errorCodes.includes(result.error.code))
        .map((_, index) => index);

    if (invalidTokenIndexes.length === 0) {
        return;
    }

    log(`User ${userId} found invalid push tokens: ${invalidTokenIndexes.length}!`);

    const batch = db.batch();

    invalidTokenIndexes.forEach(invalidTokenIndex => {
        batch.delete(pushTokensDocuments[invalidTokenIndex].ref);
    });

    await batch.commit();

    log(`User ${userId} invalid push tokens removed!`);
};