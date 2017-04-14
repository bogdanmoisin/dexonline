<?php
require_once("../../phplib/util.php"); 
User::require(User::PRIV_EDIT);
util_assertNotMirror();

$lexems = Model::factory('Lexem')
        ->where_not_null('comment')
        ->order_by_asc('formNoAccent')
        ->find_many();

SmartyWrap::assign('lexems', $lexems);
SmartyWrap::addCss('admin');
SmartyWrap::display('admin/viewLexemsWithComments.tpl');

?>
