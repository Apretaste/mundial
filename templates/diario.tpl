{include file="../includes/appmenu.tpl"}
<center>
<h1 style="margin:0;">​Mundial 2018​ </h1>
{if count($nowGames)>0}
<table width="100%" style="margin-left:auto; margin-right:auto;">
  <tr>
    <th colspan="3"><h2 style="margin:0;">Justo ahora!</h2></th>
  </tr>
{foreach $nowGames as $nowGame}
  <tr>
    <td align="center" colspan="3">{$nowGame['hora']}</td>
  </tr>
  <tr>
    <td align="center" width="40%">
      <h2 style="margin:0;">{$nowGame['homeTeam']}</h2>
      <p style="font-weight: bold;font-size: 3em; margin:0;">{$nowGame['homeIcon']}</p>
    </td>
    <td align="center" width="20%"><h2 style="margin:0;">{$nowGame['minutes']}<br>{$nowGame['results']}</h2></td>
    <td align="center" width="40%">
      <h2 style="margin:0;">{$nowGame['visitorTeam']}</h2>
      <p style="font-weight: bold;font-size: 3em; margin:0;">{$nowGame['visitorIcon']}</p>
    </td>
  </tr>
{/foreach}
</table>
{/if}

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
          {if $juego['results']!=""}
            <br>Resultados: {$juego['results']}
          {/if}
        </td>
        <td align="center">
        {$juego['homeTeam']}<br>
        <p style="font-weight: bold;font-size: 2em; margin:0;">{$juego['homeIcon']}</p>
        </td>
        <td align="center">
        {$juego['visitorTeam']}<br>
        <p style="font-weight: bold;font-size: 2em; margin:0;">{$juego['visitorIcon']}</p>
        </td>
      </tr>
    {/foreach}
    </table>
    {space10}
  {/if}
  {button href="MUNDIAL JUEGOS" caption="Juegue y Gane"}
  {button href="MUNDIAL CALENDARIO" caption="Vea el Calendario"}
</center>
