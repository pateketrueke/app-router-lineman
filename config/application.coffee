# Exports an object that defines
#  all of the configuration needed by the projects'
#  depended-on grunt tasks.
#
# You can familiarize yourself with all of Lineman's defaults by checking out the parent file:
# https://github.com/testdouble/lineman/blob/master/config/application.coffee
#

# lineman-lib-template config options:

includeVendorInDistribution = false #set to true if you want your distribution to contain JS files in vendor/js

lineman = require(process.env["LINEMAN_MAIN"])
grunt = lineman.grunt
_ = grunt.util._

module.exports = lineman.config.extend "application",
  loadNpmTasks: [
    "grunt-contrib-copy"
    "grunt-bower-task"
    "grunt-blanket"
  ]

  prependTasks:
    common: ["bower:install"]

  appendTasks:
    dist: ["concat:dist", "uglify:js", "copy"]
    common: ["concat:vendor", "concat:testm", "concat:spec", "concat:app"]

  removeTasks:
    common: ["less", "handlebars", "jst", "images:dev", "webfonts:dev", "pages:dev", "concat"]
    dev: ["server"]
    dist: ["cssmin", "images:dist", "webfonts:dist", "pages:dist", "uglify"]

  watch:
    coffee:
      tasks: ["coffee"]

    lint:
      files: ["<%= files.js.app.files %>"]

    js:
      files: ["<%= files.js.app.files %>"]
      tasks: ["concat:app"]

  clean:
    js:
      src: [
        "dist"
        "coverage"
        "vendor/components"
        "<%= files.coffee.generated %>"
        "<%= files.coffee.generatedSpec %>"
        "<%= files.js.vendor.concatenated %>"
        "<%= files.js.app.concatenated %>"
        "<%= files.js.concatenatedSpec %>"
      ]

  jshint:
    files: ["<%= files.js.app.files %>"]

  blanket:
    compile:
      options: {}
      files:
        "coverage/": "generated/js/app/"

  coffee:
    options:
      bare: on

  bower:
    options:
      copy: off
      targetDir: "vendor/components"
    install: {}

  concat:
    vendor:
      src: "<%= files.js.vendor.files %>"
      dest: "<%= files.js.vendor.concatenated %>"

    testm:
      src: "<%= files.js.testm.files %>"
      dest: "<%= files.js.testm.concatenated %>"

    dist:
      options:
        banner: "/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today(\"yyyy-mm-dd\") %> */\n"
        process: (src, filepath) ->
          src.replace /["']use strict['"]\s*;?/g, ''
      files:
        "<%= files.js.app.concatenatedDist %>": _([
          ("<%= files.js.vendor.concatenated %>" if includeVendorInDistribution)
          "<%= files.js.app.concatenated %>"
        ]).compact()

    app:
      options:
        process: (src, filepath) ->
          _(src.split "\n").map((line) -> line.replace(/^\/\/!/, '')).join "\n"
      files:
        "<%= files.js.app.concatenated %>": "<%= files.js.app.files %>"

  copy:
    vendor:
      files: [
        { expand: true, flatten: true, src: [
          "<%= files.js.vendor.files %>"
        ], dest: "<%= files.js.vendorDistDest %>", filter: "isFile" }
      ]

  uglify:
    js:
      src: "<%= files.js.app.concatenatedDist %>"
      dest: "<%= files.js.app.minifiedDist %>"
