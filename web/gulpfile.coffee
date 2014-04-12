#-----------------------------------------------------------------
# Setup
#-----------------------------------------------------------------

fs          = require('fs')
wrench      = require('wrench')
server      = false
gulp        = require('gulp')
plugins     = require('gulp-load-plugins')()
paths       =
  styles: './source/**/*.styl'
  scripts: './source/**/*.js'
  templates: './source/**/*.jade'

#-----------------------------------------------------------------
# Defaults
#-----------------------------------------------------------------

gulp.task('default', ['clean', 'images', 'scripts', 'styles', 'templates', 'fonts'])


#-----------------------------------------------------------------
# Watch
#-----------------------------------------------------------------

gulp.task 'watch', () ->
  server = plugins.livereload()
  gulp.watch(paths.styles, ['styles'])
  gulp.watch(paths.scripts, ['scripts'])
  gulp.watch(paths.templates, ['templates'])


#-----------------------------------------------------------------
# Styles
#-----------------------------------------------------------------

gulp.task 'styles', () ->

  gulp.src('./source/assets/styles/base.styl')
    .pipe(plugins.concat('main.min.css'))
    .pipe(plugins.stylus( set: ['compress'], use: ['nib'] ))
    .pipe(gulp.dest('./build/assets/styles/'))

  # LiveReload
  server.changed('./build/assets/styles/main.min.css') if server


#-----------------------------------------------------------------
# Scripts
#-----------------------------------------------------------------

gulp.task 'scripts', () ->

  gulp.src('./source/assets/scripts/**/*.js')
    .pipe(plugins.concat('libs.min.js'))
    .pipe(gulp.dest('./build/assets/scripts/'))

  # LiveReload
  server.changed('./build/assets/scripts/main.min.js') if server


#-----------------------------------------------------------------
# Templates
#-----------------------------------------------------------------

gulp.task 'templates', () ->

  # Build
  templates = JSON.parse(require('./server/templates').compile())
  gulp.src('./source/index.jade')
    .pipe(plugins.jade( locals: templates: templates ))
    .pipe(gulp.dest('./build/'))

  # LiveReload
  server.changed('./build/index.html') if server

