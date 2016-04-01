'use babel';
'use strict';

import {Settings} from './settings';

export default {
  activate() {
    Settings.init();
  }
};
