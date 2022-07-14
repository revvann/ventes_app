const NetworkUtils = require('../utils/networkUtils.js');
module.exports = class AuthServices {
   /**
    * @type {NetworkUtils}
    */
   #networkUtils;

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
   verify() {
      return this.#networkUtils.get('/RJXvksjS')
   }
}