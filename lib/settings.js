'use babel';
'use strict';

// IMPORT LIBS
import {Dom} from './dom';

// PARSE SETTINGS
const Settings = {

  init: function() {

    var self = this;

    // SET THEME TO DEFAULT IF SETI UI ISN'T LOADED
    if (this.isLoaded('seti-ui')) {
      self.setTheme('default', false, false);

    // IF SETI IS LOADED, TRY & DETERMINE THEME COLOR
    } else {
      // SET THEME COLOR WHEN/IF SETI UI ACTIVATES
      self.onActivate('seti-ui', function() {
        let color = atom.config.get('seti-ui.ui.themeColor');
        // IF THEME COLOR IS SET
        if (typeof color === 'string') {
          self.setTheme(color, false, false);
        }
        // WHEN THEME CHANGES
        atom.config.onDidChange('seti-ui.ui.themeColor', (value) => {
          self.setTheme(value.newValue, value.oldValue, false);
        });
      });

      // IF SETI IS DEACTIVATED, SET THEME TO DEFAULT
      self.onDeactivate('seti-ui', function() {
        self.setTheme('default', false, false);
      });
    }

  },

  // IF A PACKED IS LOADED
  isLoaded: function(which) {
    return atom.packages.isPackageLoaded();
  },

  // WHEN A PACKAGE ACTIVATES
  onActivate: function (which, cb) {
    atom.packages.onDidActivatePackage(function(pkg) {
      if (pkg.name === which) { cb(pkg) }
    });
  },

  // WHEN A PACKAGE DE-ACTIVATES
  onDeactivate: function (which, cb) {
    atom.packages.onDidDeactivatePackage(function(pkg) {
      if (pkg.name === which) { cb(pkg) }
    });
  },

  // INFO ON THIS PACKAGE
  package: atom.packages.getLoadedPackage('seti-ui'),

  // GET INFO ON LOADED PACKAGE
  packageInfo: function(which) {
    atom.packages.getLoadedPackage(which)
  },

  // SAVE SELECTED THEME TO USER THEME FILE
  setTheme: function( theme, previous, reload ) {

    let fs = require('fs'),
        pkg = this.package,
        themeData = '@import "themes/' + theme.toLowerCase() + '";';

    fs.writeFile(pkg.path + '/styles/user-theme.less', themeData);
  }

};

export {Settings};
