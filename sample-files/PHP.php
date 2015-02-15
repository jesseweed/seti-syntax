<?php

  class Router {

    function __construct() {

      if (isset($_SERVER['TZ'])) $this->timezone = $_SERVER['TZ'];

      $this->ua = $_SERVER['HTTP_USER_AGENT'];

      $this->root = $_SERVER['DOCUMENT_ROOT'];
      $this->filename = $_SERVER['SCRIPT_FILENAME'];
      $this->uri = $_SERVER['REQUEST_URI'];

      if (isset($_SERVER['PATH_INFO']) && $_SERVER['PATH_INFO'] == '/') :
        $this->path = '/index';
      elseif ( isset($_SERVER['PATH_INFO']) ) :
        $this->path = $_SERVER['PATH_INFO'];
      else :
        $this->path = '/index';
      endif;

      $this->self = $_SERVER['PHP_SELF'];


    }

    function current() {
        return $this->path;
    }

  }


// END OF FILE
