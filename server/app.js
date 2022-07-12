const admin = require("firebase-admin");
const createMessaging = require('./app/utils/firebase/messaging.js');
const express = require('express');
const http = require('http');
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);

const io = new Server(server);
const socketController = require('./app/controllers/socketController.js')

admin.initializeApp({
    credential: admin.credential.cert(require("./service-account-file.json")),
});
const firebaseMessaging = createMessaging(admin);

io.on('connection', (socket) => socketController(socket, io));
io.on('message', (data) => {
    console.log("tes");
});

server.listen(3000, () => {
    console.log('listening on *:3000');
});