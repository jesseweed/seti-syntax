Dom = require('./dom')
Utility = require('./utility')

module.exports =
  init: () ->

    self = @

    # SET THEME TO DEFAULT IF SETI UI ISN'T LOADED
    if (atom.config.get('seti-syntax.themeColor'))
      self.setTheme atom.config.get('seti-syntax.themeColor'), false, false
    else
      self.setTheme 'default', false, false

    # WHEN SYNTAX THEME CHANGES
    atom.config.onDidChange 'seti-syntax.themeColor', (value) ->
      self.setTheme value.newValue, value.oldValue, true

    # WHEN AUTO THEME IS UPDATED
    atom.config.onDidChange 'seti-syntax.dynamicColor', (value) ->

      if (value.newValue)
        newColor = atom.config.get('seti-ui.themeColor')
        self.setTheme newColor, false, true
      else
        if (atom.config.get('seti-syntax.themeColor'))
          newColor = atom.config.get('seti-syntax.themeColor')
        else
          newColor = 'default'
        self.setTheme newColor, false, true

    if atom.config.get('seti-syntax.dynamicColor') and self.isLoaded('seti-ui')
      color = atom.config.get('seti-syntax.themeColor')

      # IF THEME COLOR IS SET
      if typeof color == 'string'
        self.setTheme color, false, false

      # WHEN UI THEME CHANGES
      atom.config.onDidChange 'seti-ui.themeColor', (value) ->
        self.setTheme value.newValue, value.oldValue, false

      # IF SETI IS DEACTIVATED, SET THEME TO DEFAULT
      self.onDeactivate 'seti-ui', ->
        self.setTheme 'default', false, false

  isLoaded: (which) ->
    atom.packages.isPackageLoaded()



  onActivate: (which, cb) ->
    atom.packages.onDidActivatePackage (pkg) ->
      if pkg.name == which
        cb pkg

  onDeactivate: (which, cb) ->
    atom.packages.onDidDeactivatePackage (pkg) ->
      if pkg.name == which
        cb pkg

  package: atom.packages.getLoadedPackage('seti-syntax')

  packageInfo: (which) ->
    return atom.packages.getLoadedPackage which

  setTheme: (theme, previous, reload) ->
    fs = require('fs')
    pkg = @package
    themeData = '@import "themes/' + theme.toLowerCase() + '";'
    fs.writeFile pkg.path + '/styles/user-theme.less', themeData
