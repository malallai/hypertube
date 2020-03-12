const ffmpeg = require('fluent-ffmpeg');
const fs = require('fs');
const express = require('express');

var app = express();

app.get("/stream", (req, res) => {
    var path = decodeURI(req.query.path);
    try {
        if (fs.existsSync(path)) {
            var stream = fs.createReadStream(path);
            ffmpeg()
                .input(stream)
                .outputOptions('-movflags frag_keyframe+empty_moov')
                .outputFormat('mp4')
                .on('error', ignored => {})
                .audioCodec('aac')
                .videoCodec('libx264')
                .pipe(res)
            res.on('close', () => {
                stream.destroy();
            })
        } else {
            res.status(404).send();
        }
    } catch (err) {
		console.log("Error: " + path);
    }
})

app.listen(8080);
