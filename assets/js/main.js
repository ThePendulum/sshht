'use strict';

require('../css/style.scss');

const promisify = require('es6-promisify');

const riot = require('riot');
require('babel-polyfill');

require('../tags/');

riot.mount('*');
