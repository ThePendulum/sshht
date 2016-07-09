'use strict';

require('../css/style.scss');
require('babel-polyfill');

const riot = require('riot');

require('../tags/');

riot.mount('*');
