const admin = require("firebase-admin");
const createMessaging = require('./app/utils/firebase/messaging.js');
const serviceAccount = require('./service-account.json')

admin.initializeApp({
   credential: admin.credential.cert(serviceAccount)
});

/**
 * @type {import("firebase-admin/lib/messaging/messaging-api.js").Message}
 */
const message = {
   data: {
      menu: '0',
      route: '/chathome',
      title: "This is me",
      body: "and we are who we are, not someone else",
   },
   topic: "terabithians",
};

admin.messaging().send(message)
   .then((response) => {
      console.log('Successfully sent message:', response);
   })
   .catch((error) => {
      console.log('Error sending message:', error);
   });