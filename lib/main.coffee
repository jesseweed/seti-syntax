module.exports =
  activate: () ->
    require( atom.packages.getLoadedPackage('seti-syntax').path + '/lib/settings').init()
