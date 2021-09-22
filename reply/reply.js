var argv = process.argv.slice(2);

const dotenv = require("dotenv")

if (argv.length == 2) {
    dotenv.config({path:'.env-info'})
} else {
    dotenv.config()
}

const { auth, postReplyWithMedia, postReply  } = require('./config.js');

if (argv.length < 2) {
    console.log("Usage: node reply.js id msg [movie.mp4]");
    return;
}

const id = argv[0];
const msg = argv[1];
var mov = "";

var sendMovie = false;
if (argv.length > 2) {
    sendMovie = true;
    mov = argv[2];
}

const client = auth();

if (sendMovie) {
    postReplyWithMedia(client, msg, mov, id);
} else {
    postReply(client, msg, id);
}
