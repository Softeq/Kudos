import { User } from '../models/user';
import { functions, db, log } from '../imports'

/**
 * Automatically add users to the system
 * request sample:
 *
 * curl --location --request POST '[url]' \
 * --header 'Content-Type: application/json' \
 * --data-raw '{
 *     "users": [
 *         {
 *             "email": "test.user1@softeq.com",
 *             "name": "Test User1"
 *         },
 *         {
 *             "email": "test.user2@softeq.com",
 *             "name": "Test User2"
 *         }
 *     ]
 * }'
 */
export const addUsers = functions.https.onRequest(async (request, response) => {
    const json = JSON.parse(JSON.stringify(request.body));
    const users: Array<User> = json.users;

    if (!users) {
        response.status(400).send('Incorrect body. Property `users` is null!');
        return;
    }

    log(`Start importing ${users.length} users`);

    const batch = db.batch();

    users.forEach(user => {
        const userId = user.email.split('@')[0];
        const userDocumentRef = db.collection('users').doc(userId);
        const newUserData = {
            email: user.email,
            name: user.name
        };
        batch.set(userDocumentRef, newUserData, { merge: true });
    });

    await batch.commit();

    log(`Successfully imported`);

    response.status(200).send();
});
