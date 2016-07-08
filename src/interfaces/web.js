'use strict';

const config = require('config');
const note = require('note-log');
const express = require('express');

module.exports = function(leds) {
    const app = express();

    app.use(express.static('public'));

    app.listen(config.web.port, () => {
        note('server', 'Web server listening on port ' + config.web.port);
    });
};

