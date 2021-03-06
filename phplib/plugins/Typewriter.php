<?php

/**
 * April Fools' joke, 2016. Definitions appear slowly as if from a typewriter.
 * Currently accessible by adding ?typewriter=1 to URLs.
 **/

class Typewriter extends Plugin {

  function htmlHead() {
    print SmartyWrap::fetch('plugins/typewriter/typewriterHead.tpl');
  }
  
  function afterBody() {
    print SmartyWrap::fetch('plugins/typewriter/typewriterBody.tpl');
  }

  function cssJsSmarty() {
    SmartyWrap::addPluginCss('typewriter/run.css');
    SmartyWrap::addPluginJs('typewriter/typewriter.js');
  }
}
