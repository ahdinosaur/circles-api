module.exports = (grunt) ->
  
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    coffee:
      compile:
        files: [
          expand: true
          cwd: 'src'
          src: '**/*.coffee'
          dest: 'target'
          ext: '.js'
        ]
    coffeelint:
      app: 'src/**/*.coffee'
    concurrent:
      dev:
        options:
          logConcurrentOutput: true
        tasks: ['watch', 'nodemon:dev']
    nodemon:
      dev:
        script: 'server.js'
        options:
          args: ['dev']
          nodeArgs: ['--debug']
          cwd: __dirname
          ext: 'js,coffe'
          ignore: ['node_modules/**']
          delay: 1000
          legacyWatch: true
    watch:
      files: ['Gruntfile.coffee', 'src/**/*.coffee']
      tasks: ['coffeelint', 'coffee']
      server: 
        files: ['.rebooted']
        options:
          livereload: true


  grunt.registerTask 'default', ['concurrent:dev']
  grunt.registerTask 'dev', ['build:debug', 'concurrent:dev']
