module.exports = (grunt) ->
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
    nodemon:
      dev: 
        script: 'server.js'
    watch:
      files: ['Gruntfile.coffee', 'src/**/*.coffee']
      tasks: ['coffeelint', 'coffee']
      server: 
        files: ['.rebooted']
        options:
          livereload: true



  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-nodemon'

  grunt.registerTask 'server', 'start', ->
    grunt.log.writeln 'Started a web server on port 5000'
    require('./server.js').listen(5000)
    return

  grunt.registerTask 'default', ['watch', 'nodemon']
