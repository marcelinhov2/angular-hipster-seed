# Gulp Tools
gulp         = require 'gulp'
es           = require 'event-stream'
browserSync  = require 'browser-sync'
bowerFiles   = require 'main-bower-files'
concat       = require 'gulp-concat'
imagemIn     = require 'gulp-imagemin'
inject       = require 'gulp-inject'
util         = require 'gulp-util'
order        = require 'gulp-order'
using        = require 'gulp-using'
rimraf       = require 'gulp-rimraf'
runSequence  = require 'run-sequence'

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

# ------------------------------------------------------------------------------

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
    js:
      main:         "app/scripts/main.js"
      dependencies: "app/scripts/dependencies.js"
      controllers:  "app/scripts/controllers/*.js"
      directives:   "app/scripts/directives/*.js"
      filters:      "app/scripts/filters/*.js"
      routes:       "app/scripts/routes/*.js"
      services:     "app/scripts/services/*.js"
      
    css:            "app/styles/**/*.css"
    fonts:          "app/fonts"
    images:         "app/images"
    styles:         "app/styles"
    scripts:        "app/scripts"
    partials:       "app/partials"

# ------------------------------------------------------------------------------

# Development Tasks

# Server Tasks

gulp.task "browser_sync", ->
  browserSync.init null,
    server:
      baseDir: "app"

# END of Server Tasks

# ------------------------------------------------------------------------------

# Scripts Tasks

gulp.task "delete_scripts", ->
  gulp.src dirs.app.scripts
    .pipe rimraf force: true

gulp.task "generate_scripts", ["delete_scripts"], ->
  gulp.src dirs.src.scripts
    .pipe do ngClassify
    .pipe coffee bare: yes
    .pipe gulp.dest dirs.app.scripts

gulp.task "scripts", ["generate_scripts"]

# END of Scripts Tasks

# ------------------------------------------------------------------------------

# Styles Tasks

gulp.task "delete_styles", ->
  gulp.src dirs.app.styles
    .pipe rimraf force: true

gulp.task "generate_styles", ["delete_styles"], ->
  gulp.src dirs.src.styles
    .pipe do stylus
    .pipe gulp.dest dirs.app.styles
    .pipe browserSync.reload(
      stream: true
    )

gulp.task "styles", ["generate_styles"]

# END of Styles tasks

# ------------------------------------------------------------------------------

# Partials Tasks
    
gulp.task "delete_partials", ->
  gulp.src dirs.app.partials
    .pipe rimraf force: true

gulp.task "generate_partials", ["delete_partials"], ->
  gulp.src dirs.src.partials
    .pipe jade pretty: yes
    .pipe gulp.dest dirs.app.partials

gulp.task "partials", ["generate_partials"]
    
# END of Partials tasks

# ------------------------------------------------------------------------------

# Images tasks
    
gulp.task "delete_images", ->
  gulp.src dirs.app.images
    .pipe rimraf force: true

gulp.task "generate_images", ["delete_images"], ->
  gulp.src dirs.src.images
    .pipe gulp.dest dirs.app.images

gulp.task "images", ["generate_images"]

# END of Images tasks

# ------------------------------------------------------------------------------

# Fonts tasks
    
gulp.task "delete_fonts", ->
  gulp.src dirs.app.fonts
    .pipe rimraf force: true

gulp.task "generate_fonts", ["delete_fonts"], ->
  gulp.src dirs.src.fonts
    .pipe gulp.dest dirs.app.fonts

gulp.task "fonts", ["generate_fonts"]

# END of Fonts tasks

# ------------------------------------------------------------------------------

# Index task

gulp.task "index", ["concat_bower", "scripts", "styles", "partials", "images", "fonts"], ->
  gulp.src dirs.src.index
    .pipe jade pretty: yes
    .pipe inject(
      gulp.src([
        dirs.app.css, 
        dirs.app.js.dependencies, 
        dirs.app.js.main,
        dirs.app.js.controllers,
        dirs.app.js.directives,
        dirs.app.js.filters,
        dirs.app.js.services,
        dirs.app.js.routes
      ], read: no )
    , ignorePath: ['/app'])
    .pipe gulp.dest 'app/'
    

# END of Index task

# ------------------------------------------------------------------------------

# Compile Tasks

gulp.task "concat_bower", ->
  gulp.src bowerFiles()
    .pipe(concat( 'dependencies.js') )
    .pipe gulp.dest dirs.app.scripts

gulp.task "compile", ["clean", "index"]
  

# END of Compile tasks

# ------------------------------------------------------------------------------

# Clean Task

gulp.task 'clean', ->
  gulp.src ['app/**/*', '!app/bower_components', '!app/bower_components/**'], read: no
    .pipe rimraf force: true

# END of clean task

# ------------------------------------------------------------------------------

# Watch task

gulp.task "watch", ["compile", "browser_sync"], ->
  gulp.watch dirs.src.index, ->
    gulp.start 'compile'

  gulp.watch dirs.src.scripts, ->
    gulp.start 'compile'

  gulp.watch dirs.src.styles, ->
    gulp.start 'styles'

  gulp.watch dirs.src.partials, ->
    gulp.start 'compile'

  gulp.watch dirs.src.images, ->
    gulp.start 'compile'

# END of Watch tasks

# ------------------------------------------------------------------------------