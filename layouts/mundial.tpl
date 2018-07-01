<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<style type="text/css">
			{include file="../includes/styles.css"}
		</style>
	</head>
	<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0" style="font-family: Arial;">
		<center>
			<table id="container" bgcolor="#F2F2F2" cellpadding="0" cellspacing="0" valign="top" align="center" width="600">
				<tr>
					<!--logo-->
					<td valign="middle" style="padding-left:25px;">
						{link href="MUNDIAL" caption="<b>⚽ 2018</b>" style="color:#326295; font-size:40px; font-family:Times; text-decoration: none;"}
					</td>

					<!--notifications & profile-->
					<td align="right" class="emoji" valign="middle" style="padding:10px 25px 0px 0px;">
						{link href="MUNDIAL CALENDARIO" caption="&#128197;" style="color:#326295; text-decoration: none;"}&nbsp;&nbsp;&nbsp;
						{link href="MUNDIAL JUEGOS" caption="💰" style="color:#326295; text-decoration: none;"}&nbsp;&nbsp;&nbsp;
						{link href="MUNDIAL ESTADISTICAS" caption="📋" style="color:#326295; text-decoration: none;"}&nbsp;&nbsp;&nbsp;
						{if $num_notifications}{assign var="bell" value="🔔"}{assign var="color" value="#326295"}{else}{assign var="bell" value="🔕"}{assign var="color" value="grey"}{/if}
						{link href="NOTIFICACIONES" caption="{$bell}" style="color:{$color}; text-decoration: none;"}
					</td>
				</tr>

				<!--main section-->
				<tr>
					<td style="padding: 5px 10px 0px 10px;" colspan="3">
						<div class="rounded">
							{include file="$APRETASTE_USER_TEMPLATE"}
						</div>
					</td>
				</tr>

				<!--footer-->
				<tr>
					<td align="center" colspan="3" bgcolor="#F2F2F2" style="padding: 20px 0px;">
						<small>Copa Mundial de la FIFA Rusia {$smarty.now|date_format:"%Y"} &copy;. All rights reserved</small>
					</td>
				</tr>
			</table>
		</center>
	</body>
</html>
