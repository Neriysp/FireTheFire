const auth = require('../middleware/auth');
const validateObjectId = require('../middleware/validateObjectId');
const _ = require('lodash');
const {
    Fire,
    validate
} = require('../models/fire');
const {
    Response
}=require("../models/response")
const {
    User
}=require("../models/user")
const express = require('express');
const router = express.Router();
const https = require('https');
const request = require('request');
const GeoPoint = require('geopoint');

router.get('/', auth, async (req, res) => {

    const fires = await Fire.find();

    res.send(fires);
});

router.post('/', auth, async (req, res) => {
    // const {
    //     error
    // } = validate(req.body);
    // if (error) return res.status(400).send(error.details[0].message);

    let fire = new Fire({
        longtitude: req.body.longtitude,
        latitude: req.body.latitude,
        user: req.user._id
    });
    await fire.save();
    let currentUser= await User.findById(req.user._id);
    let currentUserPoint = new GeoPoint(37.4219983, -122.084);
    //Send fire as notif to all persons nearby

    var usersNearby= await User.find();
    var notifUserTokens=[];

    for(let u of usersNearby){
       
        let uNearbyPoint = new GeoPoint(37.4219983, -122.084);
        let distance = currentUserPoint.distanceTo(uNearbyPoint, true);

        if(distance<=1){
            notifUserTokens.push(u.fcmToken);
        }
    }

    let authKey="key=AAAAAc1GFbE:APA91bFh3iVBIf01zb0X2dlOAttDPlYhN0iWosD06v5_zD5MiQ_jKq_kPjm5fAVGigy-EKbNFQg4KSO9EZvdaXbFOkjRAm1QMz7YBgNBnUZfQpMIedvKBItm2el6GFsGbug7gRTklId5";
    
    console.log(notifUserTokens);

    let data = { 
    "priority":"high",
        "notification": {
            "title": "Fire Alert",
            "body": "There might be a fire near you please confirm it and stay safe!"
        },
    "data" : {
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
    },
    "registration_ids": notifUserTokens
    };

    request({
        url: "https://fcm.googleapis.com/fcm/send",
        method: "POST",
        json: true, 
        headers:{
            "Authorization": authKey,
            "Content-Type":"application/json"
        },
        body: data
    }, function (error, response, body){
        console.log(response);
    });

    res.send(fire);
});

router.post('/:id', [auth, validateObjectId], async (req, res) => {

    let fire=await Fire.findById(req.params.id);

    if(!fire) 
        return res.status(404).send('The fire with the given ID was not found.');

    let response = new Response({
        reponseType: req.body.reponseType,
        image: req.body.image,
        user: req.user._id,
        fire:fire._id
    });

    await response.save();
    // Response sent to firefighters

    res.send(response);
});

module.exports = router;
