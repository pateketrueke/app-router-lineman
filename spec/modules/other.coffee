class Other
  initialize_module: (mapper) ->
    mapper.draw (match) ->
      match('/foo').to 'test'

      test:
        events:
          testEvent: (handler) -> set 'thing'
