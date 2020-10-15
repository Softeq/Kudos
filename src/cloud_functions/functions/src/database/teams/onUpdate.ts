import { isEqual, sortBy } from 'lodash';
import { functions, db, log } from '../../imports'

/**
 * Trigger updates information about Team in achievements collection
 * when team name, access level, team members changes
 */
export const updateTeam = functions.firestore
    .document('teams/{teamId}')
    .onUpdate(async (snapshot, context) => {
        const oldData = snapshot.before.data();
        const newData = snapshot.after.data();

        if (!oldData || !newData) {
            log('Old or New data is null!');
            return;
        }

        const oldName: string = oldData.name;
        const newName: string = newData.name;

        const oldAccessLevel: number = oldData.access_level;
        const newAccessLevel: number = newData.access_level;

        const oldMembers: Array<any> = oldData.members;
        const newMembers: Array<any> = newData.members;

        const isMapsEqual = (a: any, b: any) : boolean => isEqual(sortBy(a, 'id'), sortBy(b, 'id'));

        if (oldName === newName
            && oldAccessLevel === newAccessLevel
            && isMapsEqual(oldMembers, newMembers)) {
                log('The data hasn\'t been modified!');
                return;
            }

        const teamId: string = context.params.teamId;
        const qs = await db.collection('achievements').where('team.id', "==", teamId).get();
        const teamAchievements = qs.docs;

        if (teamAchievements.length === 0) {
            log(`The team (${teamId}) doesn't have any achievements!`);
            return;
        }

        log('Start updating');

        const newAchievementData = {
            team: {
                id: teamId,
                name: newName,
            },
            access_level: newAccessLevel,
            team_members: newMembers
        };

        const batch = db.batch();

        teamAchievements.forEach(x => {
            batch.set(x.ref, newAchievementData, { merge: true });
        });

        await batch.commit();

        log(`Successfully updated ${teamAchievements.length} records.`);
    });
