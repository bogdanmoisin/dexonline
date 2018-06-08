<?php

/**
 * Structure definitions from DEX '98.
 **/

require_once __DIR__ . '/../phplib/Core.php';
require_once __DIR__ . '/../phplib/third-party/PHP-parsing-tool/Parser.php';

define('SOURCE_ID', 53);
define('BATCH_SIZE', 10000);
define('START_AT', 'cr');
define('DEBUG', false);
$offset = 0;

$PARTS_OF_SPEECH = [
  'a', 'ad', 'af', 'afi', 'afp', 'afpt', 'afs', 'ai', 'ain', 'am', 'amp', 'an', 'anh', 'apr',
  'ard', 'arh', 'arp', 'art', 'arti', 'av', 'avi', 'avr', 'c', 'ec', 'i', 'la', 'lav',
  'lc', 'ls', 'nc', 'ncv', 'nf', 'no', 'pd', 'pdf', 'pdm', 'pin', 'pir', 'pî', 'pnh', 'pnhi',
  'pp', 'ppl', 'ppr', 'prl', 'prli', 'prn', 's', 'sa',
  'sf', 'sfa', 'sfi', 'sfm', 'sfn', 'sfp', 'sfpa', 'sfs', 'sfsa', 'si', 'sm', 'sma',
  'smf', 'smi', 'smn', 'smnf', 'smp', 'sms', 'smsa', 'sn', 'sna', 'snf', 'sni', 'snm', 'snp',
  'sns', 'ssg', 'ssga', 'ssp', 'v', 'va', 'vi', 'vi(a)', 'vif', 'vim', 'vir',
  'virp', 'virt', 'vit', 'vit(a)', 'vitr', 'viu', 'vp', 'vr', 'vr(a)', 'vra', 'vri',
  'vrim', 'vrp', 'vrr', 'vrt', 'vru', 'vt', 'vt(a)', 'vta', 'vt(f)', 'vtf', 'vtfr', 'vti',
  'vti(a)', 'vtir', 'vtr', 'vtr(a)', 'vtra', 'vtrf', 'vtri', 'vtrp', 'vtrr', 'vu',
];
$PARTS_OF_SPEECH = array_map(function($s) {
  return '"' . $s . '"';
}, $PARTS_OF_SPEECH);

$GRAMMAR = [
  'start' => [
    'definition',
    'reference',
  ],
  'definition' => [
    'entryWithInflectedForms (ws formattedPosList)? ws bracket ws ignored',
  ],
  'bracket' => [
    '/[$@]*/ "[" attestation (morphology formattedSlash ws?)* etymology "]" /[$@]*/',
  ],
  'attestation' => [
    '"#At:#" ws /.+?\/(?! ?[\d\w\/])/s ws?',
  ],
  'morphology' => [
    'abbreviation',
    'accent',
    'alsoWritten',
    'cases',
    'plural',
    'tenses',
    'pronunciation',
    'variants',
  ],
  'formattedSlash' => [
    '/[$@]*\/[$@]*/',
  ],
  'abbreviation' => [
    '"#Abr#:" /[^\/]+/s',
  ],
  'accent' => [
    '"A:" /[^\/]+/s',
    '"#A:#" /[^\/]+/s',
    '"#A și:#" /[^\/]+/s',
    '"A și (#înv#):" /[^\/]+/s',
  ],
  'alsoWritten' => [
    '"S:" /[^\/]+/s',
    '"#S:#" /[^\/]+/s',
    '"#S și:#" /[^\/]+/s',
  ],
  'cases' => [
    '"#G-D#:" /[^\/]+/s',
  ],
  'plural' => [
    '"#Pl:#" /[^\/]+/s',
    '"#Pl#:" /[^\/]+/s',
    '"#Pl# și:" /[^\/]+/s',
  ],
  'pronunciation' => [
    '"#P:#" /[^\/]+/s',
    '"#P și:#" /[^\/]+/s',
  ],
  'tenses' => [
    '"#Pzi:#" /[^\/]+/s',
    '"#Ps:#" /[^\/]+/s',
    '"#Par#:" /[^\/]+/s',
  ],
  'variants' => [
    '"#V:#" /[^\/]+/s',
  ],
  'etymology' => [
    '"#E:#" /[^\]]+/',
  ],
  'reference' => [
    'entryWithInflectedForms ws formattedPosList ws formattedVz ws formattedForm',
  ],
  'entryWithInflectedForms' => [
    '(/[$@]*/ form /[$@]*/ homonym? /[$@]*/)+/,[$@]* /',
  ],
  'homonym' => [
    '/\^\d-?/',
    '/\^\{\d\}-?/', // if there is a dash, the number comes before it, e.g. aer^3-
  ],
  'formattedPosList' => [
    'formattedPos+", "',
  ],
  'formattedPos' => [
    '/[$@]*/ posHash /[$@]*/',
  ],
  'posHash' => [
    '"#" pos "#"',
    'pos',
  ],
  'pos' => $PARTS_OF_SPEECH,
  'formattedForm' => [
    '/[$@]*/ form homonym? /[$@]*/',
  ],
  'formattedVz' => [
    '/[$@]*/ "#vz#" /[$@]*/',
  ],
  'form' => [
    'fragment+/[- ]/',
    'fragment "-"', // prefixes
    '"-" fragment', // suffixes
  ],
  'fragment' => [
    "/[A-ZĂÂÎȘȚ]?([~a-zăâçîșțüáắấéíî́óúý()']|##)+/u", // accept capitalized forms
  ],
  'ws' => [
    '/(\s|\n)+/',
  ],
  'ignored' => [
    '/.*/s',
  ],
];

$parser = makeParser($GRAMMAR);

do {
  $defs = Model::factory('Definition')
        ->where('sourceId', SOURCE_ID)
        ->where('status', Definition::ST_ACTIVE)
        ->where_gte('lexicon', START_AT)
        ->order_by_asc('lexicon')
        ->order_by_asc('id')
        ->limit(BATCH_SIZE)
        ->offset($offset)
        ->find_many();

  foreach ($defs as $d) {
    // for now remove footnotes and invisible comments
    $rep = preg_replace("/\{\{.*\}\}/U", '', $d->internalRep);
    $rep = preg_replace("/▶.*◀/U", '', $rep);

    $parsed = $parser->parse($rep);
    if (!$parsed) {
      $errorPos = $parser->getError()['index'];
      $markedRep = substr_replace($rep, red('***'), $errorPos, 0);
      printf("%s [%s]\n", defUrl($d), $markedRep);
    } else {
      if (DEBUG) {
        printf("Parsed %s %s [%s]\n", $d->lexicon, $d->id, mb_substr($d->internalRep, 0, 120));
        var_dump($parsed->findFirst('definition'));
      }
    }
    if (DEBUG) {
      exit;
    }
  }

  $offset += count($defs);
  Log::info("Processed $offset definitions.");
} while (count($defs));

Log::info('ended');

/*************************************************************************/

function makeParser($grammar) {
  $s = '';
  foreach ($grammar as $name => $productions) {
    $s .= "{$name} ";
    foreach ($productions as $p) {
      $s .= " :=> {$p}";
    }
    $s .= ".\n";
  }

  return new \ParserGenerator\Parser($s);
}

function defUrl($d) {
  return "https://dexonline.ro/admin/definitionEdit.php?definitionId={$d->id}";
}

function red($s) {
  return "\033[01;31m{$s}\033[0m";
}
