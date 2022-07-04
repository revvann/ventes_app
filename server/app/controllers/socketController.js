const { Socket } = require("socket.io");
const ChatServices = require("../services/chatServices.js");
const ChatModel = require("../models/chatModel.js");

/**
 * @param {Socket} socket
 * Controlller for socket connection
 */
function socketController(socket) {
   const chatServices = new ChatServices(socket.handshake.auth.jwtToken);

   socket.on('message', async (data) => {
      try {
         const chat = ChatModel.fromJson(data.chat);
         const response = await chatServices.storeChat(data.chat);

         if (response.status == 200) {
            const chats = await chatServices.fetchChats({
               user1: chat.createdby,
               user2: chat.chatreceiverid,
            });

            if (chats.status == 200) {
               socket.broadcast.to(data.to).emit('message', chats.data);
               socket.emit('message', chats.data);
               return;
            }
         }
         socket.emit('messagefailed', "Cannot Send message");
      } catch (e) {
         console.log(e);
         socket.emit('messageerror', "Send message returned error")
      }
   });

   socket.on('disconnect', reason => {
      console.log(`Socket disconnect: ${reason}`);
   });
}

module.exports = socketController;