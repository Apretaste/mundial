{include file="../includes/appmenu.tpl"}
<center>
<h1 style="margin:0;">Sus Juegos</h1>
<h4 style="margin-top:8px;">Partidos por los que usted ha jugado</h4>
{if isset($bets[0])}
<table width="100%" style="margin-left:auto; margin-right:auto;">
    <thead>
        <th width="50%">Partido</th>
        <th width="15%">Eleccion</th>
        <th width="10%">Cant</th>
        <th width="10%">Activa</th>
        <th width="15%">Estado</th>
    </thead>
    <tbody>
    {foreach $bets as $bet}
        <tr>
            <td align="center">{$bet->home}VS {$bet->visitor}</td>
            <td align="center">{if $bet->team=="HOME"}{$bet->home}{else}{$bet->visitor}{/if}</td>
            <td align="center">{$bet->amount}</td>
            <td align="center">{if $bet->active=="1"}Si{else}No{/if}</td>
            <td align="center">{if $bet->winner=="TIE"}Empate{else if $bet->winner==$bet->team}Ganador{else if $bet->winner==""}Sin terminar{else}Perdedor{/if}</td>
        </tr>
    {/foreach}
    </tbody>
</table>
{else}
<p>Usted no ha jugado credito por el equipo de ningun partido</p>
{/if}
</center>