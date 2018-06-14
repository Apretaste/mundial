<style type="text/css">
	{include file="../includes/styles.css"}
</style>

{if {$APRETASTE_ENVIRONMENT} eq "app"}
	<table width="100%" cellspacing="10">
		<tr align="center">
			<td>{link href="MUNDIAL" caption="<b>⚽ 2018</b>" style="color:#326295; font-size:40px; font-family:Times; text-decoration: none;"}</td>
			<td>{link href="MUNDIAL CALENDARIO" caption="&#128197;" style="color:#326295; text-decoration: none;"}</td>
			<td>{link href="MUNDIAL JUEGOS" caption="💰" style="color:#326295; text-decoration: none;"}</td>
			<td>{link href="MUNDIAL ESTADISTICAS" caption="📋" style="color:#326295; text-decoration: none;"}</td>
			<td>{link href="MUNDIAL COMENTARIOS" caption="💭" style="color:#326295; text-decoration:none; font-size:18px;"}</td>
			<td>{if $num_notifications}{assign var="bell" value="🔔"}{assign var="color" value="#326295"}{else}{assign var="bell" value="🔕"}{assign var="color" value="grey"}{/if}
				{link href="NOTIFICACIONES" caption="{$bell}" style="color:{$color}; text-decoration: none;"}</td>
		</tr>
	</table>
	{space10}
{/if}
