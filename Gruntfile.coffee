
module.exports = (grunt) ->
	require('load-grunt-tasks')(grunt)
	require('time-grunt')(grunt)
	pkg = require './package.json'

	grunt.initConfig
		settings:
			srcDirectory: 'src'

		less:
			app:
				options:
					paths: [
						'<%= settings.srcDirectory %>/app/assets/less'
					]
				files:
					'<%= settings.srcDirectory %>/app/assets/css/styles.css': '<%= settings.srcDirectory %>/app/assets/less/styles.less'

		connect:
			app:
				options:
					base: '<%= settings.srcDirectory %>'
					hostname: '0.0.0.0' # localhost
					livereload: true
					middleware: (connect, options, defaultMiddleware) ->
						unless Array.isArray options.base
							options.base = [options.base]
						middlewares = [require('grunt-connect-proxy/lib/utils').proxyRequest]

						# serveStatic = require 'serve-static'
						# middlewares.push serveStatic item for item in options.base
						# directory = options.directory or options.base[options.base.length - 1]
						# middlewares.push serveStatic directory
						# console.log middlewares
						# middlewares

						middlewares.concat(defaultMiddleware)
					open: false
					port: 3000

				proxies: [
					context: '/api'
					# host: 'test.dianjinhe.com'
					# port: 8091
					host: 'test2.dianjinhe.com'
					port: 80
				,
					context: '/wapPay'
					host: 'test2.dianjinhe.com'
					port: 80
				,
					context: '/dianjinhe'
					host: 'test2.dianjinhe.com'
					port: 80
				]				

		watch:
			basic:
				files: [
					'<%= settings.srcDirectory %>/app/**'
				]
				options:
					livereload: true
					spawn: false
			less:
				files: [
					'<%= settings.srcDirectory %>/app/assets/less/**/*.less'
				]
				tasks: [
					'less:app'
				]
				options:
					livereload: true
					spawn: false
			none:
				files: 'none'
				options:
					livereload: true


	grunt.registerTask 'build', [
		'less'
	]

	grunt.registerTask 'serve', [
		'configureProxies:app'
		'connect'
	]
	
	grunt.registerTask 'default', [
		'build'
		'serve'
		'watch'
	]

	grunt.registerTask 'dev', [
		'default'
	]
			
