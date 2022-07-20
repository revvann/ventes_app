const express = require('express');
const FirebaseService = require('../services/firebaseService');
const router = express.Router();

/**
 * @type {FirebaseService}
 */
let firebaseService;

router.post('/send-message', async function (req, res) {
   try {
      const data = req.body;
      data['data']['type'] = 'create';
      await firebaseService.messaging.send(data);

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

router.post('/delete-message', async function (req, res) {
   try {
      const data = req.body;
      data['data']['type'] = 'delete';
      await firebaseService.messaging.send(data);

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

router.post('/update-message', async function (req, res) {
   try {
      const data = req.body;
      data['data']['type'] = 'update';
      await firebaseService.messaging.send(data);

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