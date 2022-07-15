const { Socket, Server } = require("socket.io");
const ChatServices = require("../services/chatServices.js");
const FormData = require("form-data");

/**
 * @param {Socket} socket
 * @param {Server} io
 * Controlller for socket connection
 */
module.exports = (io, socket) => {
   const chatServices = new ChatServices(socket.handshake.auth.jwtToken);

   const onDisconnect = (reason) => {
      console.log(`Socket disconnect: ${reason}`);
   }

   const getUsersOnline = (...users) => {
      const ids = users.filter((user) => Object.keys(io.sockets.sockets).includes(user));
      socket.emit('usersonline', ids);
   }

   const onMessage = async (data) => {
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
         } else {
            socket.emit('messagefailed', "Cannot Send message");
         }
      } catch (e) {
         console.log(e);
         socket.emit('messageerror', "Send message returned error")
      }
   }

   const onReadMessage = async (data) => {
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
         } else {
            socket.emit("readmessagefailed", "Cannot read message");
         }
      } catch (e) {
         socket.emit("readmessageerror", "Read message returned error");
      }
   }

   socket.on('message', onMessage);
   socket.on('readmessage', onReadMessage);
   socket.on('disconnect', onDisconnect);
   socket.on('usersonline', getUsersOnline);
}