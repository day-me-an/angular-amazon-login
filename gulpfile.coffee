gulp = require 'gulp'
gulp_sourcemaps = require 'gulp-sourcemaps'
gulp_coffee = require 'gulp-coffee'
gulp_concat = require 'gulp-concat'

gulp.task 'coffee', ->
	gulp.src './src/**/*.coffee'
	.pipe gulp_sourcemaps.init()
	.pipe gulp_coffee(bare: true)
	.pipe gulp_concat 'angular-amazon-login.js'
	.pipe gulp_sourcemaps.write './'
	.pipe gulp.dest './build'

gulp.task 'default', ['coffee']