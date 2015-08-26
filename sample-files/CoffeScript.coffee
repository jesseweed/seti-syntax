module.exports = Router.extend(
  routes:
    '': 'home'
    'users/:id': 'userDetail'
    'info': 'info'

  home: ->
    @trigger 'newPage', new HomePage
    return
  userDetail: (id) ->
    user = app.users.get(id)

    if user
      @trigger 'newPage', new HomePage
    else
      @redirectTo 'users'

    return
)


# Assignment:
number  = 42
string  = 'bar'
truthy  = true
falsy   = false
object =
  key1 : 'value1',
  key2 : 'value2',
  key3 : 'value3'

# Conditions:
number = -42 if opposite

# Functions:
square = (x) -> x * x

# Arrays:
list = [1, 2, 3, 4, 5]

# Objects:
math =
  root:   Math.sqrt
  square: square
  cube:   (x) -> x * square x

# Splats:
race = (winner, runners...) ->
  print winner, runners

# Existence:
alert "I knew it!" if elvis?

# Array comprehensions:
cubes = (math.cube num for num in list)
