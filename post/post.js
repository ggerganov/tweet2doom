var argv = process.argv.slice(2);

const { exec } = require('child_process');
const dotenv = require("dotenv")

dotenv.config()

const { auth, postMedia } = require('./config.js');

if (argv.length < 3) {
    console.log("Usage: node post.js id msg movie.mp4 subs.srt");
    return;
}

const id = argv[0];
const msg = argv[1];
const mov = argv[2];
const sub = argv[3];

const client = auth();

(async () => {
    try {
        const mediaIdVideo     = await postMedia(client, id, msg, mov, 'tweet_video');
        const mediaIdSubtitles = await postMedia(client, id, msg, sub, 'subtitles');

        console.log('video     : ', mediaIdVideo);
        console.log('subtitles : ', mediaIdSubtitles);

        const payload = {
            media_id: mediaIdVideo,
            media_category: 'tweet_video',
            subtitle_info: {
                subtitles: [ {
                    media_id: mediaIdSubtitles,
                    language_code: "EN",
                    display_name: "English"
                } ]
            }
        };

        console.log();
        console.log(JSON.stringify(payload));
        console.log();

        exec('twurl --header \'Content-Type: application/json\' -X POST /1.1/media/subtitles/create.json -d \'' + JSON.stringify(payload) + '\'', (err, stdout, stderr) => {
            if (err) {
                return;
            }

            console.log(`stdout: ${stdout}`);
            console.log(`stderr: ${stderr}`);
        });
    } catch (e) {
		console.log(e);
		process.exit(-1);
    }
})();
