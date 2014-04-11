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
  scripts: './source/**/*.coffee'
  templates: './source/**/*.jade'
  images: './source/assets/images/**/*.{png,gif,jpeg,jpg}'
  fonts: './source/assets/fonts/**/*.{eot,svg,ttf,woff,otf}'

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
  gulp.watch(paths.images, ['images', 'work'])
  gulp.watch(paths.fonts, ['fonts'])
  gulp.watch(paths.templates, ['templates'])


#-----------------------------------------------------------------
# Clean
#-----------------------------------------------------------------

gulp.task 'clean', () ->
  gulp.src('./build/', force: true )
    .pipe(plugins.clean())


#-----------------------------------------------------------------
# Styles
#-----------------------------------------------------------------

gulp.task 'styles', () ->

  gulp.src([
      './source/assets/styles/base.styl'
      './source/views/**/*.styl'
    ])
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

  gulp.src('./source/main.coffee', read: false )
    .pipe(plugins.browserify(
      transform: ['coffeeify']
      extensions: ['.coffee']
    ))
    .pipe(plugins.concat('main.min.js'))
    .pipe(gulp.dest('./build/assets/scripts/'))

  # LiveReload
  server.changed('./build/assets/scripts/main.min.js') if server


#-----------------------------------------------------------------
# Images
#-----------------------------------------------------------------

gulp.task 'images', () ->

  sprite = require('css-sprite').stream
  files = wrench.readdirSyncRecursive('./source/assets/images/work/')
  folders = files.filter (path) ->
    !!fs.statSync('./source/assets/images/work/' + path).isDirectory()

  for folder in folders
    gulp.src('./source/assets/images/work/' + folder + '/**/*.{png,gif,jpeg,jpg}')
      .pipe(sprite
        name: folder + '-sprite.png'
        style: folder + '-sprite.styl'
        cssPath: '../images/'
        processor: 'stylus'
        prefix: folder + '-sprite'
      )
      .pipe(plugins.if('*.{png,gif,jpeg,jpg}', gulp.dest('./build/assets/images/work/')))
      .pipe(plugins.if('*.styl', gulp.dest('./source/assets/styles/sprites/')))

  gulp.src(paths.images)
    .pipe(plugins.imagemin())
    .pipe(gulp.dest('./build/assets/images/'))

  gulp.src(paths.images)
    .pipe(plugins.imagemin())
    .pipe(plugins.webp())
    .pipe(gulp.dest('./build/assets/images/'))

#-----------------------------------------------------------------
# Fonts
#-----------------------------------------------------------------

gulp.task 'fonts', () ->

  gulp.src(paths.fonts)
    .pipe(gulp.dest('./build/assets/fonts/'))


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

