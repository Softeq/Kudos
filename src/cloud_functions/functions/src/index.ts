import * as admin from 'firebase-admin'

admin.initializeApp();

export { addUsers } from './http/addUsers'
export { cleanupStorage } from './storage/cleanup'
export { createAchievementReferences } from './database/achievement_references/onCreate'
export { createUser } from './database/users/onCreate'
export { updateAchievement } from './database/achievements/onUpdate'
export { updateTeam } from './database/teams/onUpdate'
export { updateUser } from './database/users/onUpdate'
