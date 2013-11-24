# Exports an object that defines
#    all of the paths & globs that the project
#    is concerned with.
#
#   The "configure" task will require this file and
#    then re-initialize the grunt config such that
#    directives like <config:files.js.app> will work
#    regardless of the point you're at in the build
#    lifecycle.
#
#   To see the default definitions for all of Lineman's file paths and globs, look at:
#   https://github.com/testdouble/lineman/blob/master/config/files.coffee
#

lineman = require(process.env["LINEMAN_MAIN"])
grunt = lineman.grunt

module.exports = lineman.config.extend "files",
  js:
    app:
      files: ["app/js/**/*.js"]
      concatenated: "<%= ~process.argv.indexOf('build') ? 'generated/js/app/main.js' : 'generated/coverage/main.js' %>"
      concatenatedDev: "generated/js/bundle.js"
      concatenatedDist: "dist/<%= pkg.name %>.js"
      minifiedDist: "dist/<%= pkg.name %>.min.js"

    testm:
      files: [
        "vendor/components/jasmine.async/lib/jasmine.async.js"
        "vendor/components/blanket/dist/jasmine/blanket_jasmine.js"
      ]
      concatenated: "generated/js/testm.js"

    vendor:
      files: [
        "vendor/components/jquery/jquery.js"
      ]
      concatenated: "generated/js/vendor.js"

    concatenatedHelpers: "generated/js/spec.helpers.js"
