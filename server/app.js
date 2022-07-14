const express = require('express');
const http = require('http');
const { Server } = require("socket.io");

const app = express();
app.use(express.json());
const server = http.createServer(app);

const io = new Server(server);
const socketController = require('./app/controllers/socketController.js');

const admin = require("firebase-admin");
const serviceAccount = require('./service-account.json');

const AuthService = require("./app/services/authServices");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

io.on('connection', (socket) => socketController(socket, io));

app.use('/', async (req, res, next) => {
    const authService = new AuthService(req.headers.authorization.replace('Bearer ', ''));
    try {
        const response = await authService.verify();
        if (response.status == 200) {
            next();
        } else {
            res.status(401).send("not authorized");
        }
    } catch (e) {
        res.status(401).send("not authorized");
    }
});

app.post('/send-message', async (req, res) => {
    try {
        const response = await admin.messaging().send(req.body);
        res.status(200);
        res.json({
            "message": "message successfully sent",
        });
    } catch (e) {
        res.status(400);
        res.json({
            "error": e
        });
    }
});

server.listen(3000, () => {
    console.log('listening on *:3000');
});