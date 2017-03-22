module.exports = (grunt) ->
  grunt.initConfig
    sass:
      compile:
        expand: true
        cwd: 'src/sass/'
        src: ['*.scss']
        dest: 'dist/'
        ext: '.css'

    'string-replace':
      inline:
        files: [
          expand: true,
          cwd: 'dist/',
          src: '*.css',
          dest: 'dist/'
        ]
        options:
          replacements: [
            {
              pattern: /\.\.\/fonts\//g,
              replacement: ''
            }
          ]

    copy:
        main:
            files: [ {
                expand: true,
                cwd: 'src/fonts/',
                src: '**',
                dest: 'dist/',
                filter: 'isFile'
                }
            ]

    pug:
      compile:
        files:
          "index.html": "index.pug"

  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks 'grunt-string-replace';
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-pug'

  grunt.registerTask 'default', [ 'sass', 'string-replace', 'copy', 'pug' ]
