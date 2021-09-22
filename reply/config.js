const Twitter = require('twitter');
const fs = require('fs');
const Promise = require('bluebird')

// auth methods
const auth = () => {
    let secret = {
        consumer_key: process.env.API_KEY,
        consumer_secret: process.env.SECRET_KEY,
        access_token_key: process.env.ACCESS_TOKEN,
        access_token_secret: process.env.ACCESS_TOKEN_SECRET
    }

    var client = new Twitter(secret);
    return client;
}

// media upload methods

const initMediaUpload = (client, pathToFile) => {
    const mediaType = "video/mp4";
    const mediaSize = fs.statSync(pathToFile).size
    return new Promise((resolve, reject) => {
        client.post("media/upload", {
            command: "INIT",
            total_bytes: mediaSize,
            media_type: mediaType
        }, (error, data, response) => {
            if (error) {
                console.log(error)
                reject(error)
            } else {
                resolve(data.media_id_string)
            }
        })
    })
}

const appendMedia = (client, mediaId, pathToFile) => {
    const mediaData = fs.readFileSync(pathToFile)
    return new Promise((resolve, reject) => {
        client.post("media/upload", {
            command: "APPEND",
            media_id: mediaId,
            media: mediaData,
            segment_index: 0
        }, (error, data, response) => {
            if (error) {
                console.log(error)
                reject(error)
            } else {
                resolve(mediaId)
            }
        })
    })
}

const finalizeMediaUpload = (client, mediaId) => {
    return new Promise((resolve, reject) =>  {
        client.post("media/upload", {
            command: "FINALIZE",
            media_id: mediaId
        }, (error, data, response) => {
            if (error) {
                console.log(error)
                reject(error)
            } else {
                resolve(mediaId)
            }
        })
    })
}

const postReplyWithMedia = (client, message, mediaFilePath, id_str) => {

    initMediaUpload(client, mediaFilePath)
        .then((mediaId) => appendMedia(client, mediaId, mediaFilePath))
        .then((mediaId) => finalizeMediaUpload(client, mediaId))
        .then((mediaId) => {
            let statusObj = {
                status: message,
                in_reply_to_status_id: id_str,
                media_ids: mediaId
            }
            client.post('statuses/update', statusObj, (error, tweetReply, response) => {
                //if we get an error print it out
                if (error) {
                    console.log(error);
                }

                //print the text of the tweet we sent out
                //console.log(tweetReply.text);
                console.log(response.body);
            });
        })
}

const postReply = (client, message, id_str) => {
    let statusObj = {
        status: message,
        in_reply_to_status_id: id_str,
    }

    client.post('statuses/update', statusObj, (error, tweetReply, response) => {
        //if we get an error print it out
        if (error) {
            console.log(error);
        }

        //print the text of the tweet we sent out
        //console.log(tweetReply.text);
        console.log(response.body);
    });
}

module.exports = { auth, postReplyWithMedia, postReply };
