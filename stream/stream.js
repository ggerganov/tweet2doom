// Open a realtime stream of Tweets, filtered according to rules
// https://developer.twitter.com/en/docs/twitter-api/tweets/filtered-stream/quick-start

const fs     = require('fs');
const dotenv = require("dotenv")
const needle = require('needle');

const rulesURL = 'https://api.twitter.com/2/tweets/search/stream/rules';
const streamURL = 'https://api.twitter.com/2/tweets/search/stream';

const dirTmp = './tmp';
const dirRequests = './requests';
const idBot = 'tweet2doom';
const rootConversationId = '';

dotenv.config()
const token = process.env.BEARER_TOKEN;

if (!fs.existsSync(dirRequests)){
    console.log('Creating folder "' + dirRequests + '"');
    fs.mkdirSync(dirRequests);
}

// Edit rules as desired below
const rules = [
    {
        'value': '("/play" OR "/replay") to:' + idBot + ' -from:' + idBot + ' -is:quote -is:retweet conversation_id:' + rootConversationId,
        'tag': 'tpd testing'
    },
];

async function getAllRules() {

    const response = await needle('get', rulesURL, {
        headers: {
            "authorization": `Bearer ${token}`
        }
    })

    if (response.statusCode !== 200) {
        console.log("Error:", response.statusMessage, response.statusCode)
        throw new Error(response.body);
    }

    return (response.body);
}

async function deleteAllRules(rules) {

    if (!Array.isArray(rules.data)) {
        return null;
    }

    const ids = rules.data.map(rule => rule.id);

    const data = {
        "delete": {
            "ids": ids
        }
    }

    const response = await needle('post', rulesURL, data, {
        headers: {
            "content-type": "application/json",
            "authorization": `Bearer ${token}`
        }
    })

    if (response.statusCode !== 200) {
        throw new Error(response.body);
    }

    return (response.body);

}

async function setRules() {

    const data = {
        "add": rules
    }

    const response = await needle('post', rulesURL, data, {
        headers: {
            "content-type": "application/json",
            "authorization": `Bearer ${token}`
        }
    })

    if (response.statusCode !== 201) {
        console.log(response.body);
        throw new Error(response.body);
    }

    return (response.body);

}

function streamConnect(retryAttempt) {
    if (retryAttempt > 4) {
        retryAttempt = 4;
    }
    console.log('streamConnect: retryAttempt = ' + retryAttempt);

    const params = {
        'expansions': 'author_id',
        'user.fields': 'username',
        'tweet.fields': 'author_id,referenced_tweets,conversation_id',
    }

    const stream = needle.request('get', streamURL, params, {
        headers: {
            "User-Agent": "v2FilterStreamJS",
            "Authorization": `Bearer ${token}`
        },
        timeout: 20000
    });

    stream.on('response', response => {
        console.log('Connection has been established');
        retryAttempt = 0;
    }).on('data', data => {
        try {
            const json = JSON.parse(data);

            console.log(JSON.stringify(json, null, '\t'));

            var isValid = 
                (typeof json != "undefined") &&
                (typeof json.data != "undefined") &&
                (typeof json.data.author_id != "undefined") &&
                (typeof json.data.referenced_tweets != "undefined") &&
                (typeof json.includes.users != "undefined");

            if (isValid == false) {
                if (typeof json.errors != "undefined") {
                    console.log('Reconnecting stream ...');

                    setTimeout(() => {
                        console.warn("A connection error occurred. Reconnecting...")
                        streamConnect(++retryAttempt);
                    }, 2 ** retryAttempt)

                    return;
                }
                console.log('Invalid request');
                return;
            }

            var el;

            // username

            el = json.includes.users.find(x => x.id == json.data.author_id)

            if (typeof el == "undefined") {
                console.log('Missing username');
                return;
            }

            const username = el.username;

            // parent_id

            el = json.data.referenced_tweets.find(x => x.type == 'replied_to');

            if (typeof el == "undefined") {
                console.log('Missing "replied_to" referenced tweet');
                return;
            }

            const parent_id = el.id;

            const id      = json.data.id;
            const pathTmp = dirTmp      + '/' + id;
            const pathDst = dirRequests + '/' + id;

            // generate request data
            fs.mkdirSync(pathTmp);
            fs.writeFile(pathTmp + '/payload.json', JSON.stringify(json, null, 4), (err) => {
                if (err) { console.error(err); return; };
            });
            fs.writeFile(pathTmp + '/parent_id', parent_id, (err) => {
                if (err) { console.error(err); return; };
            });
            fs.writeFile(pathTmp + '/username', username, (err) => {
                if (err) { console.error(err); return; };
            });

            // atomic move
            fs.rename(pathTmp, pathDst, function (err) {
                if (err) { console.error(err); return; };
                console.log('Request ' + id + ' has been saved');
            })

            // A successful connection resets retry count.
            retryAttempt = 0;
        } catch (e) {
            if (data.detail === "This stream is currently at the maximum allowed connection limit.") {
                console.log(data.detail)
                process.exit(1)
            } else {
                // Keep alive signal received. Do nothing.
            }
        }
    }).on('err', error => {
        console.log('Received error: code = ' + error.code);

        if (error.code !== 'ECONNRESET') {
            console.log(error.code);
            process.exit(1);
        } else {
            // This reconnection logic will attempt to reconnect when a disconnection is detected.
            // To avoid rate limits, this logic implements exponential backoff, so the wait time
            // will increase if the client cannot reconnect to the stream.
            console.log('Reconnecting stream ...');
            setTimeout(() => {
                console.warn("A connection error occurred. Reconnecting...")
                streamConnect(++retryAttempt);
            }, 2 ** retryAttempt)
        }
    });

    return stream;

}


(async () => {
    let currentRules;

    try {
        // Gets the complete list of rules currently applied to the stream
        currentRules = await getAllRules();

        if (false) {
            console.log('Installing new filters ...');
            // Delete all rules. Comment the line below if you want to keep your existing rules.
            await deleteAllRules(currentRules);

            // Add rules to the stream. Comment the line below if you don't want to add new rules.
            await setRules();
        } else {
            console.log('Using existing filters');
        }

    } catch (e) {
        console.error(e);
        process.exit(1);
    }

    // Listen to the stream.
    streamConnect(0);
})();
