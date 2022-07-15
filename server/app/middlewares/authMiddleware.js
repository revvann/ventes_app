const express = require('express');
const router = express.Router();
const AuthService = require("./../services/authServices");

router.use('/send-message', async (req, res, next) => {
   try {
      const authService = new AuthService(req.headers.authorization.replace('Bearer ', ''));
      const response = await authService.verify();
      if (response.status == 200) {
         next();
      } else {
         res.status(401).send("not authorized");
      }
   } catch (e) {
      res.status(401).send("not authorized");
   }
});

module.exports = router;