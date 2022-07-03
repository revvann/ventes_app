const admin = require("firebase-admin");
const createMessaging = require('./firebase/messaging.js');
const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

admin.initializeApp({
    credential: admin.credential.cert(require("./service-account-file.json")),
});
const firebaseMessaging = createMessaging(admin);

let messages = [];

io.on('connection', (socket) => {
    console.log(`${socket.handshake.auth.username}`);

    socket.on('message', (data) => {
        socket.broadcast.to(socket.id).emit('message', "testes");
        console.log(data);
    });

    socket.on('disconnect', reason => {
        console.log(reason);
        console.log("you are about to disconnect from socket.io");
    });
});

server.listen(3000, () => {
    console.log('listening on *:3000');
});