// import: web-server
const express = require('express');
const http = require('http');
const app = express();
const server = http.createServer(app);

// import: socket-io
const { Server, Socket } = require("socket.io");
const io = new Server(server);

// import: services
const FirebaseService = require("./app/services/firebaseService");

// import: controllers
const registerChatController = require('./app/controllers/chatController');
const messageController = require('./app/controllers/messageController');

// import: middlewares
const authMiddleware = require('./app/middlewares/authMiddleware');

// section: init-firebase-service
const firebaseService = new FirebaseService();
messageController.setFirebaseService(firebaseService);

// section: socket-io
/**
 * @param {Socket} socket
 */
const onConnection = (socket) => {
    registerChatController(io, socket);
}
io.on('connection', onConnection);

// section: express
app.use(express.json());
app.use(authMiddleware);
app.use(messageController.router);

// section: server
server.listen(3000, () => {
    console.log('listening on *:3000');
});