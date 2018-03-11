module.exports = (grunt) ->
  grunt.initConfig
    
    # Delete files that will be used by compile-handlebars because it appends to the end of a file rather than re-writing it.
    clean: [ 'src/sass/_*-map.scss', 'index.html']
    
    'compile-handlebars':
        # Generate map SCSS files
        'maps':
            files: [
                {
                    src: 'handlebars/templates/map-scss.handlebars',
                    dest: [
                        'src/sass/_icons-map.scss', 'src/sass/_ships-map.scss'
                    ]
                }
            ]
            templateData: [
                'src/json/icons-map.json',
                'src/json/ships-map.json'
            ]
            helpers: 'handlebars/helpers/*.js'
            
        # Generate index.html from merged json
        'index':
            files: [
                {
                    src: 'handlebars/templates/index.handlebars',
                    dest: 'index.html'
                }
            ]
            globals: [
                'src/json/ships-map.json', 
                'src/json/icons-map.json'
            ]
            partials: 'handlebars/templates/index-icon-set.handlebars'
        
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
