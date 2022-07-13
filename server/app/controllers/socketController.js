const { Socket, Server } = require("socket.io");
const ChatServices = require("../services/chatServices.js");
const FormData = require("form-data");
const fs = require("fs");

/**
 * @param {Socket} socket
 * @param {Server} io
 * Controlller for socket connection
 */
function socketController(socket, io) {
   const chatServices = new ChatServices(socket.handshake.auth.jwtToken);
   socket.on('message', onMessage);
   socket.on('readmessage', onReadMessage);
   socket.on('disconnect', onDisconnect);
   socket.on('usersonline', getUsersOnline);

   function onDisconnect(reason) {
      console.log(`Socket disconnect: ${reason}`);
   }

   function getUsersOnline(users = []) {
      console.log(users);
      const ids = users.filter((user) => Object.keys(io.sockets.sockets).includes(user));
      socket.emit('usersonline', ids);
   }

   async function onMessage(data) {
      try {
         const chatData = new FormData();
         Object.entries(data.chat).filter(([key, value]) => value !== null && value != undefined).forEach(([key, value]) => chatData.append(key, value));

         const response = await chatServices.storeChat(chatData);
         if (response.status == 200) {
            const messageData = {
               chats: response.data,
               from: socket.id,
            };
            socket.emit('message', messageData);
            socket.broadcast.to(data.to).emit('message', messageData);
            return;
         }
         socket.emit('messagefailed', "Cannot Send message");
      } catch (e) {
         console.log(e);
         socket.emit('messageerror', "Send message returned error")
      }
   }

   async function onReadMessage(data) {
      const userId = data.userid;
      try {
         const response = await chatServices.readChats(userId);
         if (response.status == 200) {
            const messageData = {
               chats: response.data,
               from: socket.id,
            }
            socket.emit('message', messageData);
            socket.broadcast.to(data.to).emit('message', messageData);
            return;
         }
         socket.emit("readmessagefailed", "Cannot read message");
      } catch (e) {
         console.log(e);
         socket.emit("readmessageerror", "Read message returned error");
      }
   }
}

module.exports = socketController;