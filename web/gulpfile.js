require('coffee-script/register');

var util = require('gulp-util');
var gulpfile = 'Gulpfile.coffee';

util.log('Using file', util.colors.magenta(gulpfile));
require('./' + gulpfile);
