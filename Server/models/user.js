const config = require('config');
const jwt = require('jsonwebtoken');
const Joi = require('joi');
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  fcmToken: {
    type: String,
    required: true
  },
  longtitude: {
    type: String,
    required: true,
    trim: true
  },
  latitude: {
    type: String,
    required: true,
    trim: true
  },
  password: {
    type: String,
    required: true
  },
});

userSchema.methods.generateAuthToken = function () {
  const token = jwt.sign({
    _id: this._id,
    isAdmin: this.isAdmin
  }, config.get('jwtPrivateKey'));
  return token;
}

const User = mongoose.model('User', userSchema);

function validateUser(user) {
  const schema = {
    name: Joi.string().required(),
    password: Joi.string().required()
  };

  return Joi.validate(user, schema);
}

exports.User = User;
exports.validate = validateUser;