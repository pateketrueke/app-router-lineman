global = this

ctx = []

get = -> ctx.pop()
set = (args...) -> ctx.push args.join ''
