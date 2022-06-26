const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

let messages = [];

io.on('connection', (socket) => {
    let auth = socket.handshake.auth;
    console.log(`${auth.user.userfullname} connected`);

    socket.on('message', (data) => {
        data.date = Date.now();
        messages.push(data);
        console.log(messages);
        io.emit('message', messages);
    });
});

server.listen(3000, () => {
    console.log('listening on *:3000');
});