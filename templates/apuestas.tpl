{include file="../includes/appmenu.tpl"}
<center>
<h1 style="margin:0;">Partidos planificados</h1>
<h2 style="margin-top:8px;">Juegue por el equipo de su preferencia</h2>
<small>Gana: %de inversion respecto al total de su equipo * total del equipo contrario</small><br>
<small>Pierde: pierde su inversion</small><br>
<small>Empata: le devolvemos el 50% de su inversion</small><br>
<small><strong>No nos hacemos responsables por sus perdidas</strong></small><br>
{space5}
{button href="MUNDIAL JUEGOS MIOS" caption="Sus elecciones" size="small"}
{space10}
{if isset($matches[0])}
    <table>
        <tr>
            <th>Fecha</th>
            <th>Home</th>
            <th>Visitante</th>
        </tr>
        {foreach $matches as $match}
        <tr>
            <td align="center">
                {$match->start_date} <br>
                {$match->start_hour}
            </td>
            <td align="center">
                {$match->home_team} <br>
                1 = {$match->home_bets} <br>
                {button href="MUNDIAL JUEGOS JUGAR {$match->timestamp} HOME" caption="Jugar" size="small" desc="a:Escriba la cantidad de credito*" popup="true" wait="true"}
            </td>
            <td align="center">
                {$match->visitor_team} <br>
                1 = {$match->visitor_bets} <br>
                {button href="MUNDIAL JUEGOS JUGAR {$match->timestamp} VISITOR" caption="Jugar" size="small" desc="a:Escriba la cantidad de credito*" popup="true" wait="true"}
            </td>
        </tr>
        <tr><td colspan="3" style="border-left: 0;border-right: 0;"><br></td></tr>
        {/foreach}
    </table>
{else}
    <p>No hay ningun partido cercano, recargue en los proximos dias</p>
{/if}