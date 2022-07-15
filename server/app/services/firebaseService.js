const admin = require("firebase-admin");
const serviceAccount = require('./../../service-account.json');

module.exports = class FirebaseService {

   /**
    * @type {import("firebase-admin/lib/messaging/messaging").Messaging}
    */
   messaging;

   constructor() {
      admin.initializeApp({
         credential: admin.credential.cert(serviceAccount)
      });
      this.messaging = admin.messaging();
   }

   /**
    * @param {import("firebase-admin/lib/messaging/messaging-api").Message} message
    * @return {Promise<string>}
    */
   sendMessage = (message) => this.messaging.send(message);

}