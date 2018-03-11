module.exports = (grunt) ->
  grunt.initConfig
    
    # Delete files that will be used by compile-handlebars because it appends to the end of a file rather than re-writing it.
    clean: [ 'src/sass/_*-map.scss', 'index.html']
    
    'compile-handlebars':
        # Generate icons map SCSS file
        'icons-map':
            files: [
                {
                    src: 'handlebars/templates/map-scss.handlebars',
                    dest: 'src/sass/_icons-map.scss'
                }
            ]
            templateData: 'src/json/icons-map.json',
            helpers: 'handlebars/helpers/*.js'
            
        # Generate ships map SCSS file
        'ships-map':
            files: [
                {
                    src: 'handlebars/templates/map-scss.handlebars',
                    dest: 'src/sass/_ships-map.scss'
                }
            ]
            templateData: 'src/json/ships-map.json',
            helpers: 'handlebars/helpers/*.js'
            
        # Generate index.html from merged json
        'index':
            files: [
                {
                    src: 'handlebars/templates/index.handlebars',
                    dest: 'index.html'
                }
            ]
            partials: 'handlebars/templates/index-icon-set.handlebars'
            globals: ['src/json/ships-map.json', 'src/json/icons-map.json']
        
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

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-compile-handlebars'
  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks 'grunt-string-replace'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  
  grunt.registerTask 'default', [ 'clean', 'compile-handlebars', 'sass', 'string-replace', 'copy' ]
