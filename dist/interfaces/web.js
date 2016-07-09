'use strict';

var config = require('config');
var note = require('note-log');
var express = require('express');

module.exports = function (leds) {
    var app = express();

    app.use(express.static('public'));

    app.get('*', function (req, res) {
        res.sendFile('/home/niels/projects/sshht/public/index.html');
    });

    app.listen(config.web.port, function () {
        note('server', 'Web server listening on port ' + config.web.port);
    });
};