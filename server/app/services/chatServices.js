const NetworkUtils = require('../utils/networkUtils.js');
module.exports = class ChatServices {
   /**
    * @type {NetworkUtils}
    */
   #networkUtils;

   /**
    * @type {string}
    */
   url = "/chat";

   /**
    * @param {string} token
    */
   constructor(token) {
      this.#networkUtils = new NetworkUtils(token);
   }

   /**
    * @param {object} data
    * @return {Promise<import('axios').AxiosResponse>} response
    */
   storeChat(data) {
      return this.#networkUtils.store(this.url, data);
   }

   /**
    * @param {object} params
    * @return {Promise<import('axios').AxiosResponse>} response
    */
   fetchChats(params) {
      return this.#networkUtils.select(`${this.url}/conversation`, params);
   }
}