{extends file="admin/layout.tpl"}

{block name=title}Pagina moderatorului{/block}

{block name=headerTitle}Pagina moderatorului{/block}

{block name=content}
  <h3>Rapoarte</h3>

  <ul>
    {foreach from=$reports item=r}
      {if ($r.count != '0') && ($sUser->moderator & $r.privilege)}
        <li>{$r.text}: <a href="{$wwwRoot}{$r.url}">{$r.count}</a></li>
      {/if}
    {/foreach}
  </ul>

  <h3>Căutări</h3>

  Navigare rapidă:

  <form class="inline" action="lexemEdit.php" method="get">
    <input id="lexemId" type="text" name="lexemId"/>
  </form>

  sau

  <form class="inline" action="definitionEdit.php" method="get">
    <input id="definitionId" type="text" name="definitionId"/>
  </form>
  <br/><br/>

  <form action="definitionLookup.php" method="post">
    Definiții:
    <input type="text" name="name" size="10" value="*"/>
    &nbsp; &nbsp; starea:
    {include file="statusDropDown.tpl"
    name="status"
    statuses=$allStatuses
    selectedStatus=1}
    &nbsp; &nbsp; trimise de:
    <input type="text" name="nick" size="10" value=""/>
    &nbsp; &nbsp; sursa:
    {include file="sourceDropDown.tpl" name="sourceId"}
    <br/>
    &nbsp; &nbsp; &nbsp; &nbsp; între
    {assign var="nextYear" value=$currentYear+1}
    {include file="bits/numericDropDown.tpl"
    name="yr1" start=2001 end=$nextYear}
    {include file="bits/numericDropDown.tpl"
    name="mo1" start=1 end=13}
    {include file="bits/numericDropDown.tpl"
    name="da1" start=1 end=32}
    &nbsp; &nbsp; și
    {include file="bits/numericDropDown.tpl"
    name="yr2" start=2001 end=$nextYear selected=$currentYear}
    {include file="bits/numericDropDown.tpl"
    name="mo2" start=1 end=13 selected=12}
    {include file="bits/numericDropDown.tpl"
    name="da2" start=1 end=32 selected=31}
    &nbsp; &nbsp; 
    <input type="submit" name="searchButton" value="Caută"/>
  </form>
  <br/>

  <form action="lexemSearch.php" method="get">
    Caută lexeme:
    <input type="text" name="form" size="10" value="*">
    sursa: {include file="sourceDropDown.tpl"}
    <select name="loc">
      <option value="2">indiferent de LOC</option>
      <option value="1">incluse în LOC</option>
      <option value="0">neincluse în LOC</option>
    </select>
    <select name="paradigm">
      <option value="2">indiferent de paradigmă</option>
      <option value="1">cu paradigmă</option>
      <option value="0">fără paradigmă</option>
    </select>
    <br/>
    &nbsp; &nbsp; &nbsp; &nbsp;
    structurare: {include file="bits/structStatus.tpl" canEdit=true anyOption=true}
    &nbsp;
    trimise de: <input type="text" name="nick" size="10" value=""/>
    <input type="submit" name="searchButton" value="Caută">
  </form>
  <br/>

  {if $sUser->moderator & $smarty.const.PRIV_LOC}
    <form action="../admin/dispatchModelAction.php" method="get">
      <span data-model-dropdown>
        Modelul:
        <input type="hidden" name="locVersion" value="6.0" data-loc-version>
        <select name="modelType" data-model-type data-canonical="1"></select>
        <select name="modelNumber" data-model-number></select>
      </span>
      <input type="submit" name="showLexems" value="Arată toate lexemele"/>
      <input type="submit" name="editModel" value="Editează"/>
      <input type="submit" name="cloneModel" value="Clonează"/>

      <span class="tooltip2" title="În loc să permitem crearea de la zero a unui model nou, care probabil nu ar fi prea utilă, permitem clonarea unui
                                    model deja existent. Noul model va avea aceleași flexiuni, același exponent și (în cazul verbelor) același tip de participiu cu modelul
                                    original. Trebuie să indicați doar un nou număr de model. Opțional, puteți alege lexemele etichetate cu modelul original pe care doriți să le
                                    migrați la modelul-clonă.">&nbsp;</span>

      <input type="submit" name="deleteModel" value="Șterge"/>

      <span class="tooltip2" title="Când ștergeți un model, toate lexemele etichetate cu acel model vor fi reetichetate cu modelul T1. (Vă va fi
                                    prezentat un ecran de confirmare cu lista acestor lexeme). Probabil este de dorit să reetichetați din timp aceste lexeme cu modelele
                                    corespunzătoare, astfel ca în momentul ștergerii modelul să nu mai aibă niciun lexem.">&nbsp;</span>

    </form>
  {/if}

  <h3>Unelte</h3>

  {if $sUser->moderator & $smarty.const.PRIV_ADMIN}
    <form action="bulkReplace.php" method="get">
      Înlocuiește în definiții: <input type="text" name="search" size="25"/>
      cu <input type="text" name="replace" size="25"/>
      în sursa: {include file="sourceDropDown.tpl"}
      <input type="submit" name="previewButton" value="Previzualizează" onclick="return hideSubmitButton(this)"/>
    </form>
    <div class="flexExplanation">
      Folosiți cu precauție această unealtă. Ea înlocuiește primul text cu al doilea în toate definițiile, făcând diferența între litere mari și mici (case-sensitive) și fără expresii regulate
      (textul este căutat ca atare). Vor fi modificate maximum 1.000 de definiții. Veți putea vedea lista de modificări propuse și să o acceptați. Din păcate, nu avem posibilitatea să subliniem
      exact porțiunile din text modificate.
    </div>
    <br/>
  {/if}

  {if $sUser->moderator & $smarty.const.PRIV_STRUCT}
    Pentru a găsi cuvinte ușor de structurat, <a href="structChooseLexem">click aici</a>.
    <div class="flexExplanation">
      Veți primi 100 de cuvinte din DEX cu definiții cât mai scurte.
    </div>
    <br/>
  {/if}

  {if $sUser->moderator & $smarty.const.PRIV_EDIT}
    Pentru a încerca etichetarea asistată a cuvintelor,
    <a href="../admin/bulkLabelSelectSuffix.php">clic aici</a>.

    <div class="flexExplanation">
      Rostul acestei pagini este de a facilita etichetarea în masă a
      lexemelor care există în <i>dexonline</i>, dar nu și în LOC, pe baza
      sufixelor. De exemplu, există sute de lexeme neetichetate
      terminate în „-tate”. Există și 900 de lexeme din LOC terminate
      în „-tate” și absolut toate au modelul F117, deci aproape sigur
      și cele noi vor fi etichetate cu același model. Rolul
      operatorului uman este să identifice excepțiile și să indice
      eventualele restricții de flexionare.
    </div>
    <br/>

    Pentru a încerca plasarea asistată a accentelor,
    <a href="../admin/placeAccents.php">clic aici</a>.

    <div class="flexExplanation">
      Veți primi o pagină cu 10 lexeme alese la întâmplare (deocamdată
      avem de unde alege...) pentru care puteți indica unde pică accentul.
    </div>
    <br/>

    Pentru a încerca identificarea substantivelor proprii,
    <a href="properNouns.php">clic aici</a>.

    <div class="flexExplanation">
      Veți primi grupuri de lexeme asociate cu definiții din Dicționarul Enciclopedic.
    </div>
    <br/>
  {/if}

  {if $sUser->moderator & $smarty.const.PRIV_LOC}
    Pentru a încerca unificarea lexemelor la plural cu cele la
    singular, <a href="../admin/mergeLexems.php">clic aici</a>.

    <div class="flexExplanation">
      Această unificare se pretează în special la familiile de plante
      și animale, dar și la alte lexeme care apar cu restricția „P”
      într-o sursă, dar fără restricții în altă sursă.
    </div>
    <br/>
  {/if}

  <h3>Legături</h3>

  {if $sUser->moderator & $smarty.const.PRIV_ADMIN}
    <a href="{$wwwRoot}moderatori">moderatori</a> |
    <a href="{$wwwRoot}surse">surse</a> |
    <a href="{$wwwRoot}etichete-sensuri">etichete pentru sensuri</a> |
    <a href="{$wwwRoot}tipuri-modele">tipuri de modele</a> |
    <a href="{$wwwRoot}flexiuni">flexiuni</a> |
  {/if}
  {if $sUser->moderator & $smarty.const.PRIV_VISUAL}
    <a href="{$wwwRoot}admin/visual.php">dicționarul vizual</a> |
  {/if}
  {if $sUser->moderator & $smarty.const.PRIV_WOTD}
    <a href="wotd.php">cuvântul zilei</a> |
    <a href="wotdImages.php">imaginea zilei</a> |
  {/if}
  {if $sUser->moderator & $smarty.const.PRIV_SUPER}
    <a href="{$wwwRoot}admin/ocrInput.php">adaugă definiții OCR</a>
  {/if}

  <script>
   $(adminIndexInit);
  </script>
{/block}
