gulp = require 'gulp'
gulp_sourcemaps = require 'gulp-sourcemaps'
gulp_coffee = require 'gulp-coffee'

gulp.task 'coffee', ->
	gulp.src 'src/**/*.coffee'
	.pipe gulp_sourcemaps.init()
	.pipe gulp_coffee(bare: true)
	.pipe gulp.dest 'build'

gulp.task 'default', ['coffee']