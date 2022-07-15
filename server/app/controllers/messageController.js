const express = require('express');
const FirebaseService = require('../services/firebaseService');
const router = express.Router();

/**
 * @type {FirebaseService}
 */
let firebaseService;

router.post('/send-message', async function (req, res) {
   try {
      const response = await firebaseService.messaging.send(req.body);
      res.status(200);
      res.json({
         message: "message successfully sent",
      });
   } catch (e) {
      res.status(400);
      res.json({
         error: e
      });
   }
});

/**
 * @param {FirebaseService} service
 */
const setFirebaseService = (service) => firebaseService = service;

module.exports = { router, setFirebaseService };