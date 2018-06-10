<center>
    <h1>Partidos planificados</h1>
    <h2>Apueste por el equipo de su preferencia</h2>
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
            {$match->home_bets}% <br>
            {button href="MUNDIAL APUESTAS APOSTAR {$match->timestamp} HOME" caption="Apostar" size="small" desc="a:Escriba la cantidad de credito*" popup="true" wait="true"}
        </td>
        <td align="center">
            {$match->visitor_team} <br>
            {$match->visitor_bets}% <br>
            {button href="MUNDIAL APUESTAS APOSTAR {$match->timestamp} VISITOR" caption="Apostar" size="small" desc="a:Escriba la cantidad de credito*" popup="true" wait="true"}
        </td>
    </tr>
    <tr><td colspan="3" style="border-left: 0;border-right: 0;"><br></td></tr>
    {/foreach}
</table>