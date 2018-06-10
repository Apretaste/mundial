<p>Usted tiene actualmente <b>&sect;{$credit|money_format}</b> de cr&eacute;dito, lo cual no es suficiente para apostar <b>&sect;{$amount|money_format}</b></p>

{if $credit gt 0}
	{space10}
	<center>
		{button href="MUNDIAL APUESTAS APOSTAR {$match} {$team} {$credit}" caption="Apostar &sect;{$credit|money_format}"}
	</center>
{/if}