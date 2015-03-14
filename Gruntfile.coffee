module.exports = (grunt) ->

  grunt.initConfig
    meta:
      src: 'src/**/*.js'
      specs: 'spec/**/*.js'

    watch:
        files: '**/*.coffee'
        tasks: ['test']

    jasmine_node:
      options:
        coffee: true
        includeStackTrace: false
      all: ['spec/']

    coffee:
      compile:
        files:
          'src/twitter.js': ['src/*.coffee']
          'spec/twitter_spec.js': ['spec/*.coffee']

  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-jasmine-node')


  grunt.registerTask('test', ['coffee', 'jasmine_node'])
  grunt.registerTask('default', ['test'])
