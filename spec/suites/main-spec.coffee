describe 'Our application:', ->

  it 'will never happen without router.js', ->
    expect(-> new App).not.toThrow()

  describe 'Well.. when it runs,', ->
    app = new App

    it 'will do not without modules', ->
      expect((new App).run).toThrow()

    it 'will expose registered modules', ->
      expect(App.modules()).toEqual { 'Sample': App.Sample }

    it 'will validate all their modules', ->
      expect(app.load).toThrow()
      expect(-> app.load []).toThrow()
      expect(-> app.load Blank).toThrow()
      expect(-> app.load Breaking).toThrow()
      expect(-> app.load Undefined).toThrow()
      expect(-> app.load App.modules()).toThrow()
      expect(-> app.load ['Irregular value']).toThrow()

    it 'will not run over invalid routes', ->
      expect(new App('/x/y/z').load(Other).run).toThrow()

    describe 'Looking at routes:', ->
      async = new AsyncSpec @

      app.load([Home, Other]).run()

      async.it 'should display "Hello world" at /', (done) ->
        delay done, ->
          expect(get()).toEqual 'Hello World'

      async.it 'should display "Hi dude!" at /hi/dude', (done) ->
        app.context.go '/hi/dude', off
        delay done, ->
          expect(get()).toEqual 'Hi dude!'

      async.it 'should display "testing" at /hi/new', (done) ->
        app.context.go '/hi/new', off
        delay done, ->
          expect(get()).toEqual 'new'

      async.it 'should trigger some events, i.e. "testEvent"', (done) ->
        app.context.go 'home'
        delay done, ->
          app.router.trigger 'testEvent'
          expect(get()).toEqual 'testing'

      describe 'By the way:', ->

        async.it 'we can find() HTML-elements through the DOM', (done) ->
          delay done, ->
            expect(app.context.find 'body').toEqual document.body

        it 'we know which modules are loaded with app.modules', ->
          keys = []
          keys.push key for key, module of app.modules

          expect(['Home', 'Other']).toEqual keys

        it 'we can build our application routes with url()', ->
          expect(-> app.context.url 'show').toThrow()
          expect(app.context.url 'make').toEqual '/hi/new'
          expect(app.context.url('show', { name: 'foo' })).toEqual '/hi/foo'

        it 'we can use send() as context mixin (?)', ->
          app.context.globals.foo = 'bar'
          app.context.send ->
            expect(@globals.foo).toEqual 'bar'
            expect(@globals.bar).toBeUndefined()

        it 'we can expose useful functions as helpers', ->
          app.context.helpers.foo = -> 'bar'
          app.context.helpers.url_for = -> app.context.url arguments...
          app.context.helpers.link_to = -> app.context.link arguments...

          app.context.send ->
            expect(@helpers.foo()).toEqual 'bar'
            expect(@helpers.url_for 'make').toEqual '/hi/new'
            expect(@helpers.link_to('make').outerHTML).toEqual '<a href="/hi/new">make</a>'

        describe 'And our links:', ->
          it 'will be html-compliant', ->
            b = app.context.link 'make', innerHTML: 'Hello?'
            expect(b.outerHTML).toEqual '<a href="/hi/new">Hello?</a>'

          async.it 'will trigger redirections', (done) ->
            a = app.context.link 'make'
            a.click()

            delay done, ->
              expect(get()).toEqual 'new'
