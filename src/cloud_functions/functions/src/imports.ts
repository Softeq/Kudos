export * as functions from 'firebase-functions'

import * as admin from 'firebase-admin'

export const db = admin.firestore()
export const storage = admin.storage()

export const log = console.log

export { sendPushToUser } from './services/user_notifications'
