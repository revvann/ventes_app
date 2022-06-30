const admin = require("firebase-admin");

admin.initializeApp({
    credential: admin.credential.cert(require("./service-account-file.json")),
});

const message = {
    data: {
        type: "warning",
        content: "A new weather warning has been created!",
    },
    topic: "round",
};

admin
    .messaging()
    .send(message)
    .then((response) => {
        console.log("Successfully sent message:", response);
    })
    .catch((error) => {
        console.log("Error sending message:", error);
    });