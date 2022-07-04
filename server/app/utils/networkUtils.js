const axios = require('axios').default;
const NetworkConstant = require('../constants/networkConstants.js');

class NetworkUtils {
   /**
    * @type {import('axios').AxiosInstance}
    */
   #axios;

   /**
    * @param {string} token
    */
   constructor(token = "") {
      this.#axios = axios.create({
         baseURL: NetworkConstant.baseUrl,
         timeout: 1000,
         headers: { 'Authorization': `Bearer ${token}` }
      });
   }

   /**
    * @param {string} url
    * @param {any} params 
    * @returns {Promise<import('axios').AxiosResponse>} response
    */
   select(url, params) {
      return this.#axios.get(url, { params: params });
   }

   /**
    * @param {string} url
    * @param {any} params 
    * @returns {Promise<import('axios').AxiosResponse>} response
    */
   show(url, id) {
      return this.#axios.get(`${url}/${id}`);
   }

   /**
    * @param {string} url
    * @param {any} data
    * @returns {Promise<import('axios').AxiosResponse>} response
    */
   store(url, data) {
      return this.#axios.post(url, data);
   }

   /**
    * @param {string} url
    * @param {any} data
    * @returns {Promise<import('axios').AxiosResponse>} response
    */
   update(url, data) {
      return this.#axios.put(url, data);
   }

   /**
    * @param {string} url
    * @param {any} data
    * @returns {Promise<import('axios').AxiosResponse>} response
    */
   delete(url, data) {
      return this.#axios.delete(url, { params: data });
   }
}

module.exports = NetworkUtils;