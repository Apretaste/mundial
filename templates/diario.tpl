{include file="../includes/appmenu.tpl"}
<center>
<h1>​Mundial 2018​ </h1>
<h2>Partidos de hoy</h2>
  {if $dayMatches!=false}
  <table width="100%" border="1" style="margin-left:auto; margin-right:auto;">
    <tr>
      <th colspan="3"><h2 style="margin:0;">{$dayMatches['fecha']}</h2></th>
    </tr>
    <tr>
      <th width="50%"><strong>Informacion</strong></th>
      <th width="30%"><strong>Home</strong></th>
      <th width="30%"><strong>Visitante</strong></th>
    </tr>
    {foreach $dayMatches['juegos'] as $juego}
      <tr>
        <td>
          {$juego['hora']}<br>
          {$juego['grupo']}<br>
          {$juego['estadio']}<br>
          {$juego['ciudad']}
        </td>
        <td align="center">
        {$juego['homeTeam']}<br>
        {$juego['homeIcon']} 
        </td>
        <td align="center">
        {$juego['visitorTeam']}<br>
        {$juego['visitorIcon']}
        </td>
      </tr>
    {/foreach}
    </table>
    {space10}
  {/if}
  {button href="MUNDIAL JUEGOS" caption="Juegue y Gane"}
  {button href="MUNDIAL CALENDARIO" caption="Vea el Calendario"}
</center>
