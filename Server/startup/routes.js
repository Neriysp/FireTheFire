const express = require('express');
const users = require('../routes/users');
const response = require('../routes/response');
const auth = require('../routes/auth');
const fire = require('../routes/fire');

module.exports = function(app) {
  app.use(express.json());
  app.use('/api/fire', fire);
  //app.use('/api/response', response);
  app.use('/api/users', users);
  app.use('/api/auth', auth);
}