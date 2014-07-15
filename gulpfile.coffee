# Gulp Tools
gulp        = require 'gulp' 
es          = require 'event-stream' 
browserSync = require 'browser-sync' 
bowerFiles  = require 'gulp-bower-files'
clean       = require 'gulp-clean' 
concat      = require 'gulp-concat' 
imagemIn    = require 'gulp-imagemin' 
inject      = require 'gulp-inject' 
util        = require 'gulp-util' 

# Pre-processors Tools
coffee      = require 'gulp-coffee'
jade        = require 'gulp-jade'
stylus      = require 'gulp-stylus'
sourceMaps  = require 'gulp-sourcemaps'

# AngularJS Tools
ngClassify  = require 'gulp-ng-classify'
ngMin       = require 'gulp-ngmin'
ngHtmlify   = require 'gulp-angular-htmlify'

# Minification Tools
uglify      = require 'gulp-uglify'
minifyCss   = require 'gulp-minify-css'
minifyHtml  = require 'gulp-minify-html'

# --------------------------------------------------------------

# Directories

dirs =
  src: 
    index:    "src/index.jade"
    fonts:    "src/fonts/**/*"
    images:   "src/images/**/*"
    styles:   "src/styles/**/*.styl"
    scripts:  "src/scripts/**/*.coffee"
    partials: "src/partials/**/*.jade"

  app:
    fonts:    "app/fonts"
    images:   "app/images"
    styles:   "app/styles"
    scripts:  "app/scripts"
    partials: "app/partials"

# --------------------------------------------------------------

# Development Tasks

gulp.task "browser-sync", ->
  browserSync.init null,
    server:
      baseDir: "app"

gulp.task "scripts", ->
  gulp.src dirs.src.scripts
    .pipe do sourceMaps.init
    .pipe do ngClassify
    .pipe coffee bare: yes
    .pipe do sourceMaps.write
    .pipe gulp.dest dirs.app.scripts
    .pipe browserSync.reload(
      stream: true
      once: true
    )

gulp.task "styles", ->
  gulp.src dirs.src.styles
    .pipe do stylus
    .pipe gulp.dest dirs.app.styles
    .pipe browserSync.reload(
      stream: true
    )

gulp.task "partials", ->
  gulp.src dirs.src.partials
    .pipe jade pretty: yes
    .pipe gulp.dest dirs.app.partials
    .pipe browserSync.reload(
      stream: true
      once: true
    )

gulp.task "images", ->
  gulp.src dirs.src.images
    .pipe gulp.dest dirs.app.images
    .pipe browserSync.reload(
      stream: true
      once: true
    )

gulp.task "fonts", ->
  gulp.src dirs.src.fonts
    .pipe gulp.dest dirs.app.fonts

# gulp.task "watch", ["browser-sync"], ->