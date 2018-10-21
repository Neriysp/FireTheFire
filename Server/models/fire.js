const Joi = require('joi');
const mongoose = require('mongoose');
const {userSchema} = require('./user');

const Fire = mongoose.model('Fire', new mongoose.Schema({
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
  user: { 
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required:true
  },       
   dateCreated: {
    type: Date,
    default: Date.now
}
}));

function validateFire(fire) {
  const schema = {
    dateCreated:Joi.date()
  };

  return Joi.validate(fire, schema);
}

exports.Fire = Fire; 
exports.validate = validateFire;