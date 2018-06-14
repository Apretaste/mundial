{include file="../includes/appmenu.tpl"}
<center>
<h1>​ Calendario del Mundial 2018​ </h1>
<h2>Fase de Grupos</h2>
  {foreach $faseGrupos as $day}
  <table width="100%" border="1" style="margin-left:auto; margin-right:auto;">
    <tr>
      <th colspan="3"><h2 style="margin:0;">{$day['fecha']}</h2></th>
    </tr>
    <tr>
      <th width="50%"><strong>Informacion</strong></th>
      <th width="30%"><strong>Home</strong></th>
      <th width="30%"><strong>Visitante</strong></th>
    </tr>
    {foreach $day['juegos'] as $juego}
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
  {/foreach}

  <h2>Fase Eliminatoria</h2>
  {foreach $faseEliminatorias as $day}
  <table width="100%" border="1" style="margin-left:auto; margin-right:auto;">
    <tr>
      <th colspan="3"><h2 style="margin:0;">{$day['fase']}</h2></th>
    </tr>
    <tr>
      <th width="50%"><strong>Informacion</strong></th>
      <th width="30%"><strong>Home</strong></th>
      <th width="30%"><strong>Visitante</strong></th>
    </tr>
    {foreach $day['juegos'] as $juego}
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
  {/foreach}
</center>
