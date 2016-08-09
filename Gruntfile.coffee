module.exports = (grunt) ->
  grunt.initConfig
    sass:
      compile:
        expand: true
        cwd: 'sass/'
        src: ['*.sass']
        dest: 'dist/'
        ext: '.css'

    pug:
      compile:
        files:
          "index.html": "index.pug"

  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks 'grunt-contrib-pug'

  grunt.registerTask 'default', [ 'sass', 'pug' ]
