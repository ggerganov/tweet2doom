var argv = process.argv.slice(2);

const dotenv = require("dotenv")

dotenv.config()

const { auth, postMedia } = require('./config.js');

if (argv.length < 2) {
    console.log("Usage: node post.js msg movie.mp4");
    return;
}

const msg = argv[0];
const mov = argv[1];

const client = auth();

postMedia(client, msg, mov);
