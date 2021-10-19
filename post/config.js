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

const delay = ms => new Promise(resolve => setTimeout(resolve, ms))

// media upload methods

const initMediaUpload = (client, pathToFile, mediaType) => {
    var mediaTypeStr     = "video/mp4";
    var mediaCategoryStr = "tweet_video";

    if (mediaType == "subtitles") {
        mediaTypeStr     = "text/plain";
        mediaCategoryStr = "subtitles";
    }

    const mediaSize = fs.statSync(pathToFile).size
    return new Promise((resolve, reject) => {
        client.post("media/upload", {
            command: "INIT",
            media_category: mediaCategoryStr,
            total_bytes: mediaSize,
            media_type: mediaTypeStr
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

const appendMediaChunk = (client, mediaId, segmentId, ib, ie, mediaData) => {
    return new Promise((resolve, reject) => {
        client.post("media/upload", {
            command: "APPEND",
            media_id: mediaId,
            media: mediaData.slice(ib, ie),
            segment_index: segmentId
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

const checkMediaStatus = (client, mediaId) => {
    return new Promise((resolve, reject) => {
        client.get("media/upload", {
            command: "STATUS",
            media_id: mediaId
        }, (error, data, response) => {
            resolve(data)
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

async function postMedia (client, id_str, message, mediaFilePath, mediaType) {
    const mediaData = fs.readFileSync(mediaFilePath);

    const chunk = 4*1024*1024;
    var n = Math.floor(mediaData.length/chunk);
    if (n*chunk < mediaData.length) ++n;

    var mediaId = await initMediaUpload(client, mediaFilePath, mediaType);
    console.log('media_id     = ' + mediaId);
    console.log('num segments = ' + n);

    for (var i = 0; i < n; ++i) {
        var ib = i*chunk;
        var ie = Math.min(i*chunk + chunk, mediaData.length);
        console.log('  - segment ' + i, ib, ie);

        await appendMediaChunk(client, mediaId, i, ib, ie, mediaData);
    }

    await finalizeMediaUpload(client, mediaId);

    if (mediaType != 'subtitles') {
        console.log('Waiting for video to be processed ...');
        var success = false;
        for (var i = 0; i < 20; ++i) {
            await delay(1000);
            console.log('Waiting ', i, ' seconds ...');
            var status = await checkMediaStatus(client, mediaId);
            if (status.processing_info.state == 'succeeded') {
                success = true;
                break;
            }
        }

        if (success == false) {
            throw "Failed to upload video";
        }

        let statusObj = {
            status: message,
            media_ids: mediaId
        }

        if (id_str != '0') {
            statusObj = {
                status: message,
                in_reply_to_status_id: id_str,
                media_ids: mediaId
            }
        }

        await client.post('statuses/update', statusObj, (error, tweetReply, response) => {
            //print the text of the tweet we sent out
            console.log(response.body);

            //if we get an error print it out
            if (error) {
                console.log(error);
                throw "Failed to post";
            }
        });
    }

    return mediaId;
}

module.exports = { auth, postMedia };
