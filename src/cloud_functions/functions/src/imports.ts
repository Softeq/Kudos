import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

const db = admin.firestore()
const storage = admin.storage()
const log = console.log

export {
    functions,
    db,
    storage,
    log
}