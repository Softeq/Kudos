import { functions, db, log } from '../../imports'

/**
 * Trigger add added user to the Softeq team
 */
export const createUser = functions.firestore
    .document('/users/{userId}')
    .onCreate(async (snapshot, context) => {
        const documentData = snapshot.data();

        if (!documentData) {
            log('Document data is null!');
            return;
        }

        const userId: string = context.params.userId;

        const softeqTeamId = '1OXbbvRAI9QL7Vv8aD8B';
        const softeqTeam = await db.collection('teams').doc(softeqTeamId).get();
        const softeqTeamData = softeqTeam.data();

        if (!softeqTeamData) {
            log('Softeq team data is null!');
            return;
        }

        log('Start updating Softeq team');

        const newTeamMember = {
            id: userId,
            name: documentData.name
        };

        const teamMembers = [...softeqTeamData.team_members, newTeamMember];
        const visibleFor = [...softeqTeamData.visible_for, userId];

        const newTeamData = {
            team_members: teamMembers,
            visible_for: visibleFor
        };

        await softeqTeam.ref.set(newTeamData, { merge: true });

        log('Successfully updated');
    });
