Dom = require('./dom')

module.exports =
  init: (state) ->

    self = @
    @themeSet = false

    # ONCE PACKAGE IS LOADED
    if self.isLoaded('seti-syntax')

      # WHEN SYNTAX THEME CHANGES
      atom.config.onDidChange 'seti-syntax.themeColor', (value) ->
        self.setTheme value.newValue, value.oldValue, true

      # WHEN DYNAMIC THEME IS ENABLED OR DISABLED
      atom.config.onDidChange 'seti-syntax.dynamicColor', (value) ->
        # IF DYNIMIC IS ALLWOED
        if (value.newValue)
          newColor = atom.config.get('seti-ui.themeColor')
          self.setTheme newColor, false, true
        # IF DYNAMIC IS NOT ALLOWED
        else
          # IF SYNTAX COLOR HAS BEEN SET
          if (atom.config.get('seti-syntax.themeColor'))
            newColor = atom.config.get('seti-syntax.themeColor')
          # FALLBACK TP DEFAULT COLO IF NONE SET
          else
            newColor = 'default'
          self.setTheme newColor, false, true

      # IF SETI UI IS LOADED
      if self.isLoaded('seti-ui')

        # IF DYNAMIC THEM IS ALLOWED
        if atom.config.get('seti-syntax.dynamicColor') and not @themeSet
          # SET SYNTAX THEME TO MATCH UI
          self.setTheme atom.config.get('seti-ui.themeColor'), false, false

        # WHEN UI THEME CHANGES
        atom.config.onDidChange 'seti-ui.themeColor', (value) ->
          # IF DYNAMIC THEM IS ALLOWED
          if atom.config.get('seti-syntax.dynamicColor')
            # SET SYNTAX THEME TO MATCH UI
            self.setTheme value.newValue, value.oldValue, false

        # IF SETI UI IS DEACTIVATED
        self.onDeactivate 'seti-ui', ->
          # IF DYNAMIC THEM WAS ALLOWED
          if atom.config.get('seti-syntax.dynamicColor')
            # SET THEME TO DEFAULT
            self.setTheme 'default', false, false

      # SET USER THEME IS NOT SET DYNAMICALLY
      if (atom.config.get('seti-syntax.themeColor')) and not @themeSet
        self.setTheme atom.config.get('seti-syntax.themeColor'), false, false

      # IF ALL ELSE HAS FAILED, LOAD THE DEFAULT THEME
      else if (not @themeSet)
        self.setTheme 'default', false, false

  # CHECKS IF A PACKAGE IS LOADED
  isLoaded: (which) ->
    return atom.packages.isPackageLoaded(which)

  # WHEN PACKAGE ACTIVATES
  onActivate: (which, cb) ->
    atom.packages.onDidActivatePackage (pkg) ->
      if pkg.name == which
        cb pkg

  # WHEN PACKAGE DEACTIVATES
  onDeactivate: (which, cb) ->
    atom.packages.onDidDeactivatePackage (pkg) ->
      if pkg.name == which
        cb pkg

  # GET INFO ABOUT OUR PACKAGE
  package: atom.packages.getLoadedPackage('seti-syntax')

  # DETERMINE IF A SPECIFIC PACKAGE HAS BEEN LOADED
  packageInfo: (which) ->
    return atom.packages.getLoadedPackage which

  # RELOAD WHEN SETTINGS CHANGE
  refresh: ->
    self = @
    self.package.deactivate()
    setImmediate ->
      return self.package.activate()

  setTheme: (theme, previous, reload) ->
    self = @
    fs = require('fs')
    pkg = @package
    themeData = '@import "themes/' + theme.toLowerCase() + '";'

    # THIS PREVENTS THEME FROM BEING SET TWICE
    @themeSet = true

    # CHECK CURRENT THEME FILE
    fs.readFile pkg.path + '/styles/user-theme.less', 'utf8', (err, fileData) ->
      # IF THEME IS DIFFERENT THAN IS USED TO BE
      if fileData != themeData
        # SAVE A NEW USER THEME FILE
        fs.writeFile pkg.path + '/styles/user-theme.less', themeData, (err) ->
          # IF FILE WAS WRITTEN OK
          if !err
            # RELOAD THE VIEW
            self.refresh()
