{extends file="layout.tpl"}

{block name=title}Verificarea acurateței{/block}

{block name=content}
  <h2>Verificarea acurateței</h2>

  {if $projects}
    <div class="panel panel-default">
      <div class="panel-heading">Proiectele mele</div>
      <div class="panel-body">
        <form action="acuratete-eval" method="get">
          <div class="row">
            <div class="col-sm-10">
              {include "bits/dropdown.tpl" name="projectId" data=$projects}
            </div>
            <div class="col-sm-2">
              <button class="btn btn-default" type="submit">deschide</button>
              <button class="btn btn-danger" type="submit" id="deleteButton" name="deleteButton" value="1">șterge</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  {/if}

  <div class="panel panel-default">
    <div class="panel-heading">Creează un proiect nou</div>
    <div class="panel-body">

      <form class="form-horizontal" method="post">
        <div class="form-group">
          <label for="f_name" class="col-sm-2 control-label">Nume</label>
          <div class="col-sm-8">
            <input type="text" id="f_name" class="form-control" name="name" value="{$p->name}" />
          </div>
        </div>
        <div class="form-group">
          <label for="userId" class="col-sm-2 control-label">Utilizator</label>
          <div class="col-sm-8">
            <select id="userId" name="userId" class="form-control">
              <option value="{$p->userId}" selected></option>
            </select>
          </div>
        </div>
        <div class="form-group">
          <label for="sourceDropDown" class="col-sm-2 control-label">sursă (opțional)</label>
          <div class="col-sm-8">
            {include "bits/sourceDropDown.tpl" name="sourceId" src_selected=$p->sourceId}
          </div>
        </div>
        <div class="form-group">
          <label for="f_startDate" class="col-sm-2 control-label">dată de început (opțional)</label>
          <div class="col-sm-8">
            <input type="text" id="f_startDate" name="startDate" value="{$p->startDate}" class="form-control" placeholder="AAAA-LL-ZZ" />
          </div>
        </div>
        <div class="form-group">
          <label for="f_endDate" class="col-sm-2 control-label">dată de sfârșit (opțional)</label>
          <div class="col-sm-8">
            <input type="text" id="f_endDate" name="endDate" value="{$p->endDate}" placeholder="AAAA-LL-ZZ" class="form-control" />
          </div>
        </div>
        <div class="form-group">
          <label class="col-sm-2 control-label">metodă</label>
          <div class="col-sm-8">
            {include "bits/dropdown.tpl" name="method" data=AccuracyProject::getMethodNames() selected=$p->method}
          </div>
        </div>

        <button class="btn btn-primary" type="submit" name="submitButton" value="1">creează</button>

      </form>
    </div>
  </div>
{/block}
