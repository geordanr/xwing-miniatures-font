module.exports = (grunt) ->
  grunt.initConfig
    clean: [ 'src/sass/_*-map.scss']
  
    'compile-handlebars':
        'icons-map':
            files: [
                {
                    src: 'map-scss.handlebars',
                    dest: 'src/sass/_icons-map.scss'
                }
            ]
            templateData: 'src/json/icons-map.json',
            helpers: 'handlebars-helpers/escape.js'
        'ships-map':
            files: [
                {
                    src: 'map-scss.handlebars',
                    dest: 'src/sass/_ships-map.scss'
                }
            ]
            templateData: 'src/json/ships-map.json',
            helpers: 'handlebars-helpers/escape.js'
    
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
  grunt.loadNpmTasks 'grunt-string-replace'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-pug'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-compile-handlebars'
  
  grunt.registerTask 'default', [ 'clean', 'compile-handlebars', 'sass', 'string-replace', 'copy', 'pug' ]
