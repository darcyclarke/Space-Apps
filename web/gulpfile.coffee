#-----------------------------------------------------------------
# Setup
#-----------------------------------------------------------------

server      = false
gulp        = require('gulp')
plugins     = require('gulp-load-plugins')()
paths       =
  styles: './source/**/*.styl'
  scripts: './source/**/*.coffee'
  templates: './source/**/*.jade'

#-----------------------------------------------------------------
# Defaults
#-----------------------------------------------------------------

gulp.task('default', ['clean', 'images', 'scripts', 'styles', 'templates', 'fonts'])


#-----------------------------------------------------------------
# Clean
#-----------------------------------------------------------------

gulp.task 'clean', () ->
  gulp.src('./build/', force: true )
    .pipe(plugins.clean())


#-----------------------------------------------------------------
# Watch
#-----------------------------------------------------------------

gulp.task 'watch', () ->
  server = plugins.livereload()
  gulp.watch(paths.styles, ['styles'])
  gulp.watch(paths.scripts, ['scripts'])
  gulp.watch(paths.templates, ['templates'])

#-----------------------------------------------------------------
# Fonts
#-----------------------------------------------------------------

gulp.task 'fonts', () ->
  gulp.src('./source/assets/fonts/**/*.{ttf,svg,otf,woff,eot}')
    .pipe(gulp.dest('./build/assets/fonts/'))


#-----------------------------------------------------------------
# Images
#-----------------------------------------------------------------

gulp.task 'images', () ->
  gulp.src('./source/assets/images/**/*.{png,gif,jpg,jpeg}')
    .pipe(gulp.dest('./build/assets/images/'))


#-----------------------------------------------------------------
# Styles
#-----------------------------------------------------------------

gulp.task 'styles', () ->

  gulp.src('./source/assets/styles/base.styl')
    .pipe(plugins.stylus( set: ['compress'], use: ['nib'] ))
    .pipe(plugins.rename('main.min.css'))
    .pipe(gulp.dest('./build/assets/styles/'))

  # LiveReload
  server.changed('./build/assets/styles/main.min.css') if server


#-----------------------------------------------------------------
# Scripts
#-----------------------------------------------------------------

gulp.task 'scripts', () ->

  # Game
  gulp.src('./source/assets/scripts/**/*.coffee')
    .pipe(plugins.coffee('main.js'))
    .pipe(gulp.dest('./build/assets/scripts/'))

  # Libraries
  gulp.src('./source/assets/scripts/libs/**/*.js')
    .pipe(plugins.concat('libs.js'))
    .pipe(gulp.dest('./build/assets/scripts/'))

  # Server
  gulp.src('./source/server.coffee')
    .pipe(plugins.coffee('server.js'))
    .pipe(gulp.dest('./build/'))

  # LiveReload
  server.changed('./build/assets/scripts/main.js') if server


#-----------------------------------------------------------------
# Templates
#-----------------------------------------------------------------

gulp.task 'templates', () ->

  # Build
  gulp.src('./source/**/*.jade')
    .pipe(plugins.jade())
    .pipe(gulp.dest('./build/'))

  # LiveReload
  server.changed('./build/index.html') if server
