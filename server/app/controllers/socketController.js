const { Socket } = require("socket.io");
const ChatServices = require("../services/chatServices.js");
const ChatModel = require("../models/chatModel.js");
const FormData = require("form-data");

/**
 * @param {Socket} socket
 * Controlller for socket connection
 */
function socketController(socket) {
   const chatServices = new ChatServices(socket.handshake.auth.jwtToken);

   socket.on('message', onMessage);
   socket.on('readmessage', onReadMessage);
   socket.on('disconnect', onDisconnect);

   function onDisconnect(reason) {
      console.log(`Socket disconnect: ${reason}`);
   }

   async function onMessage(data) {
      try {
         const chatData = new FormData();
         for (let [key, value] of Object.entries(data.chat)) {
            if (value != null && value != undefined) {
               chatData.append(key, value);
            }
         }
         console.log(chatData);
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