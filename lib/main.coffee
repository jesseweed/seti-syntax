module.exports =
  activate: (state) ->
    require( atom.packages.getLoadedPackage('seti-syntax').path + '/lib/settings').init(state)
