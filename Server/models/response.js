const Joi = require('joi');
const mongoose = require('mongoose');
const {userSchema} = require('./user');

const Response = mongoose.model('Response', new mongoose.Schema({
  reponseType: {
    type: Boolean,
    required: true,
    trim: true
  },
  user: { 
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required:true
  },   
  fire: { 
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Fire',
    required:true
  },   
   dateCreated: {
    type: Date,
    default: Date.now
  },
  image:{ 
    data: Buffer, 
    contentType: String 
  }
}));

function validateResponse(response) {
  const schema = {
    dateCreated:Joi.date()
  };

  return Joi.validate(post, schema);
}

exports.Response = Response; 
exports.validate = validateResponse;