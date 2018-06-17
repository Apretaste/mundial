{include file="../includes/appmenu.tpl"}
<center>
<h1 style="margin:0;">Estadisticas de Grupos</h1>
{foreach $grupos as $grupo}
<table width="100%" style="margin-left:auto; margin-right:auto;">
    <thead>
        <tr><th colspan="9">{$grupo['grupo']}</th></tr>
        <tr>
        {foreach $grupo['headers'] as $header}
            <th>{$header}</th>
        {/foreach}
        </tr>
    </thead>
    <tbody>
        {foreach $grupo['rows'] as $row}
        <tr>
            {$col=0}
            {foreach $row as $colum}
            {if $col==0}
            <td align="center" width="20%">
                {$colum}<span style="font-weight: bold;font-size: 1.5em; margin:0;">{$this->icon($colum)}</span>
                {$col=$col+1}
            </td>
            {else}
            <td align="center" width="10%">
                {$colum}
            </td>
            {/if}
            {/foreach}
        </tr>
        {/foreach}
    </tbody>
</table>
{space10}
{/foreach}
</center>