
  // constructor
  var create = function () {
    var app,
        tmp = {};

    // instance
    return app = {
      // router.js
      router: new Router(),

      // setup
      history: [],
      modules: [],

      // context
      helpers: {},
      classes: {},
      handlers: {},


      // templating
      render: function (path, vars) {
        return partial(path, vars, app.helpers);
      },


      // registry
      set: function (key, value) {
        return store.call(tmp, key, value);
      },

      get: function (key) {
        return lookup.apply(tmp, key.split('.'));
      },


      // assembly urls
      url: function (name, params) {
        return error(app, function () {
          return app.router.recognizer.generate(name, params);
        });
      },


      // redirections
      go: function (path, params, update) {
        var args = url_params(path, params, update);

        params = args[1] || {};
        update = args[2];
        path = args[0];

        return error(app, function () {
          if (path.charAt(0) === '/') {
            if (! app.router.recognizer.recognize(path)) {
              throw new Error('<' + path + '> route not found!');
            }

            return app.router.redirectURL(path, update);
          } else {
            return update ? app.router.redirectURL(app.url(path, params), true)
              : ! count(params) ? app.router.replaceWith(path)
              : app.router.replaceWith(path, params);
          }
        }, RSVP.reject()).then(null, debug);
      },


      // start
      run: function (block) {
        var ns = {},
            klass, module;

        // initialize
        while (module = modules.shift()) {
          module.call(app, ns);
        }


        // main module loader
        for (klass in ns) {
          if ('_' !== klass.charAt(0) && klass.charAt(0) === klass.charAt(0).toUpperCase()) {
            if ('function' !== typeof ns[klass]) {
              throw new Error('<' + ns[klass] + '> is not a module!');
            }

            app.modules.push(new ns[klass]());
          } else {
            app.classes[klass] = ns[klass];
          }
        }


        if ('function' === typeof block) {
          block(app);
        }

        return app;
      }

    };

  };
