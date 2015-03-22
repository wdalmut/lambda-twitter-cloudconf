module.exports = (grunt) ->

  grunt.initConfig
    meta:
      src: 'src/**/*.js'
      specs: 'spec/**/*.js'

    watch:
        files: '**/*.coffee'
        tasks: ['test']

    jasmine_nodejs:
      options:
        coffee: true
        reporters:
          console:
            colors: true
            cleanStack: true
            verbose: false
      all:
        specs: [
          "spec/**"
        ]

    coffee:
      compile:
        files:
          'src/twitter.js': ['src/*.coffee']
          'spec/twitter_spec.js': ['spec/*.coffee']

    compress:
      main:
        options:
          archive: "lambda.zip"
        files: [
          {src: ['src/*.js']}
          {src: ['config.json']}
          {src: [
            'node_modules/q/**'
            'node_modules/aws_sdk/**'
            'node_modules/request/**'
            'node_modules/twitter-js-client/**'
          ]}
        ]

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-jasmine-nodejs'
  grunt.loadNpmTasks 'grunt-contrib-compress'


  grunt.registerTask 'test', ['coffee', 'jasmine_nodejs']
  grunt.registerTask 'default', ['test']
  grunt.registerTask 'dist', ['test', 'compress']

