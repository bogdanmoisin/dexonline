<div class="defWrapper">
  <p class="def" title="Clic pentru a naviga la acest cuvânt">
    {$row->definition->htmlRep}
    {foreach $row->tags as $t}
      <label class="label label-info">{$t->value}</label>
    {/foreach}
  </p>

  <small class="defDetails text-muted">
    <ul class="list-inline dropup">
      <li>
        sursa:
        <a class="ref"
           href="{$wwwRoot}surse"
           title="{$row->source->name|escape}, {$row->source->year|escape}"
           >{$row->source->shortName|escape}
          {if $row->source->year}
            ({$row->source->year|regex_replace:"/ .*$/":""})
          {/if}
        </a>
      </li>

      {if $row->source->courtesyLink}
        <li>
          furnizată de
          <a class="ref" href="{$wwwRoot}spre/{$row->source->courtesyLink}">
            {$row->source->courtesyText}
          </a>
        </li>
      {/if}

      {if $row->user->id}
        <li>
          adăugată de
          <a href="{$wwwRoot}utilizator/{$row->user->nick|escape:"url"}">
            {$row->user->nick|escape}
          </a>
        </li>
      {/if}

      {if $sUser && ($sUser->moderator & $smarty.const.PRIV_EDIT)}
        <li>
          ID: {$row->definition->id}
        </li>
      {/if}

      {if $sUser && ($sUser->moderator & $smarty.const.PRIV_EDIT) && !$cfg.global.mirror}
        <li>
          <a href="{$wwwRoot}admin/definitionEdit.php?definitionId={$row->definition->id}">
            editează
          </a>
        </li>
      {/if}

      <li class="dropdown pull-right">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
          alte acțiuni
          <span class="caret"></span>
        </a>

        <ul class="dropdown-menu">
          {if $skinVariables.typo && !$cfg.global.mirror}
            <li>
              <a href="#"
                 data-definition-id="{$row->definition->id}"
                 data-toggle="modal"
                 data-target="#typoModal">
                <i class="glyphicon glyphicon-flag"></i>
                semnalează o greșeală
              </a>
            </li>
          {/if}

          {if $sUser}
            {if $row->bookmark}
              <li class="disabled">
                <a href="#">
                  <i class="glyphicon glyphicon-heart"></i>
                  adăugat la favorite
                </a>
              </li>
            {else}
              <li>
                <a class="bookmarkAddButton"
                   href="{$wwwRoot}ajax/bookmarkAdd.php?definitionId={$row->definition->id}">
                  <i class="glyphicon glyphicon-heart"></i>
                  <span>adaugă la favorite</span>
                </a>
              </li>
            {/if}
          {/if}

          {if $skinVariables.permalink}
            <li>
              <a href="{$wwwRoot}definitie/{$row->definition->lexicon}/{$row->definition->id}"
                 title="link direct către această definiție">
                <i class="glyphicon glyphicon-link"></i>
                permalink
              </a>
            </li>
          {/if}

          {if $sUser && ($sUser->moderator & $smarty.const.PRIV_EDIT) && !$cfg.global.mirror}
            <li>
              <a href="{$wwwRoot}istoria-definitiei?id={$row->definition->id}">
                <i class="glyphicon glyphicon-time"></i>
                istoria definiției
              </a>
            </li>
          {/if}

          {if $sUser && ($sUser->moderator & $smarty.const.PRIV_WOTD) && !$cfg.global.mirror}
            {if $row->definition->status == 0}
              {if $row->wotd}
                <li class="disabled">
                  <a href="#">
                    <i class="glyphicon glyphicon-education"></i>
                    în lista de WotD {if $row->wotd!==true}({$row->wotd}){/if}
                  </a>
                </li>
              {else}
                <li>
                  <a href="{$wwwRoot}wotdAdd.php?defId={$row->definition->id}">
                    <i class="glyphicon glyphicon-education"></i>
                    adaugă WotD
                  </a>
                </li>
              {/if}
            {else}
              <li class="disabled">
                <a href="#">
                  <i class="glyphicon glyphicon-education"></i>
                  definiție ascunsă
                </a>
              </li>
            {/if}
          {/if}

        </ul>
      </li>

    </ul>
  </small>

  {if $row->comment}
    <div class="panel panel-default panel-comment">
      <div class="panel-body">
        <i class="glyphicon glyphicon-comment"></i>
        {$row->comment->htmlContents} -
        <a href="{$wwwRoot}utilizator/{$row->commentAuthor->nick|escape:"url"}"
           >{$row->commentAuthor->nick|escape}</a>
      </div>
    </div>
  {/if}
</div>
