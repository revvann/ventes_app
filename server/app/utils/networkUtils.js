const axios = require('axios').default;
const NetworkConstant = require('../constants/networkConstants.js');

class NetworkUtils {
   /**
    * @type {import('axios').AxiosInstance}
    */
   #axios;
   get;
   post;
   put;
   delete;

   /**
    * @param {string} token
    */
   constructor(token = "") {
      this.#axios = axios.create({
         baseURL: NetworkConstant.baseUrl,
         timeout: 10000,
         headers: { 'Authorization': `Bearer ${token}` }
      });

      this.get = this.#axios.get;
      this.post = this.#axios.post;
      this.put = this.#axios.put;
      this.delete = this.#axios.delete;
   }

   /**
    * @param {string} url
    * @param {any} params 
    * @returns {Promise<import('axios').AxiosResponse>} response
    */
   select(url, params) {
      return this.get(url, { params: params });
   }

   /**
    * @param {string} url
    * @param {any} params 
    * @returns {Promise<import('axios').AxiosResponse>} response
    */
   show(url, id) {
      return this.get(`${url}/${id}`);
   }

   /**
    * @param {string} url
    * @param {any} data
    * @returns {Promise<import('axios').AxiosResponse>} response
    */
   store(url, data) {
      return this.post(url, data);
   }

   /**
    * @param {string} url
    * @param {any} data
    * @returns {Promise<import('axios').AxiosResponse>} response
    */
   update(url, data) {
      return this.put(url, data);
   }

   /**
    * @param {string} url
    * @param {any} data
    * @returns {Promise<import('axios').AxiosResponse>} response
    */
   delete(url, data) {
      return this.delete(url, { params: data });
   }
}

module.exports = NetworkUtils;