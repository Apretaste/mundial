<?php
use Goutte\Client;
use Symfony\Component\DomCrawler\Crawler;

class Mundial extends Service{

  /**
  *@param Request
  *@return Response
  *
  **/
  public function _main(Request $request){
    $data=$this->getGamesDataFromCache();
    $dayMatches=false;
    foreach ($data['faseGrupos'] as $dia) {
      if (substr($dia['fecha'],-37,2)==date('d')) {
        $dayMatches=$dia;
      }
    }
    $response=new Response();
    $response->setEmailLayout('mundial.tpl');
    $response->createFromTemplate("diario.tpl",array('dayMatches' => $dayMatches));
    $response->setCache(6);
    return $response;
  }

  /**
   *
   * @param Request
   * @return Response
   */
  public function _calendario(Request $request){
    $data=$this->getGamesDataFromCache();

    $response=new Response();
    $response->setEmailLayout('mundial.tpl');
    $response->createFromTemplate("calendario.tpl",$data);
    $response->setCache(12);
    return $response;
  }

  /**
   * @param Request
   * @return Response
   *
   */

  public function _juegos(Request $request){
    $query=explode(" ",$request->query);
    if ($query[0]=="JUGAR") {
      $match=$query[1];
      $team=$query[2];
      $amount=abs(floatval($query[3]));
      $profile = $this->utils->getPerson($request->email);
      if ($profile->credit < $amount)
      {
        $responseContent = ["amount"=>$amount, "credit"=>$profile->credit, "match"=>$match, "team"=>$team];
        $response = new Response();
        $response->subject = "Usted no tiene suficiente credito";
        $response->createFromTemplate("nocredit.tpl", $responseContent);
        return $response;
      }
      $q=Connection::query("SELECT home_team,visitor_team FROM _mundial_matches WHERE `start_date`='".date("Y-m-d H:i:s",$match)."' AND `start_date`>CURRENT_TIMESTAMP");

      if(!isset($q[0])){
        $response=new Response();
        $response->subject="Error al jugar";
        $response->createFromText("El partido por el que usted intenta jugar no existe o ya comenzo");
        return $response;
      }

      $confirmationHash = $this->utils->generateRandomHash();
      Connection::query("INSERT INTO transfer(sender,receiver,amount,confirmation_hash,inventory_code) VALUES ('{$request->email}', 'salvi@apretaste.com', '$amount', '$confirmationHash', 'BET ".$match." ".substr($team,0,4)."')");
      $team=($team=="HOME")?$q[0]->home_team:$q[0]->visitor_team;
      $response = new Response();
      $response->subject = "Confirmar juego";
      $response->createFromTemplate("confirmBet.tpl", array('amount' => $amount, 'hash' => $confirmationHash, 'team' => $team));
    }
    else {
      $this->updateMatches();
      $matches=Connection::query("SELECT * FROM _mundial_matches WHERE
      UNIX_TIMESTAMP(start_date)-UNIX_TIMESTAMP(CURRENT_TIMESTAMP)<172800
      AND start_date>CURRENT_TIMESTAMP"); //Proximos 2 dias 172800
      $dtz = new DateTimeZone("America/Havana"); //Your timezone
      foreach ($matches as $match) {
        $timestamp=strtotime($match->start_date);
        $date = ((new DateTime('@' . $timestamp))->setTimezone($dtz))->format('d/m/Y H:i');
        $match->start_date=substr($date,0,10);
        $match->start_hour=substr($date,11,5);
        $match->timestamp=$timestamp;
        $percents=Connection::query("SELECT t1.q AS home_bets,t2.q AS visitor_bets,t3.q As total_bets FROM
          (SELECT COUNT(*) AS q FROM _mundial_bets WHERE `match`='".date("Y-m-d H:i:s",$timestamp)."' AND team='HOME') as t1,
          (SELECT COUNT(*) AS q FROM _mundial_bets WHERE `match`='".date("Y-m-d H:i:s",$timestamp)."' AND team='VISITOR') as t2,
          (SELECT COUNT(*) AS q FROM _mundial_bets WHERE `match`='".date("Y-m-d H:i:s",$timestamp)."') as t3");
        $total_bets= ($percents[0]->total_bets>0) ? $percents[0]->total_bets : 1;
        $match->home_bets=round(($percents[0]->home_bets/$total_bets)*100,2);
        $match->visitor_bets=round(($percents[0]->visitor_bets/$total_bets)*100,2);
      }
      $response=new Response();
      $response->setEmailLayout('mundial.tpl');
      $response->createFromTemplate("apuestas.tpl",array('matches' => $matches));
    }
    return $response;
  }

  /**
   *
   * @return Array
   */

  public function getGames(){
    $client = new Client();
    $crawler=$client->request('GET','https://es.fifa.com/worldcup/matches/');
    $faseGrupos=array();
    $crawler->filter('div.container-fluid > div.fi-matchlist > div.fi-mu-list')->each(function($item,$i) use (&$faseGrupos){
      $fecha=$item->filter('div.fi-mu-list__head > span')->text();
      $juegos=array();
      $item->filter('div.fi-mu.fixture')->each(function($item,$i) use (&$juegos){
        $hora=$item->filter('div.fi-mu__info__datetime')->text();
        $hora=str_replace(' Hora Local','',$hora);
        $horautc=substr($item->filter('div.fi-s__score.fi-s__date-HHmm')->attr('data-timeutc'),0,2);
        $dmutc=$item->filter('div.fi-s__score.fi-s__date-HHmm')->attr('data-daymonthutc');
        $nuevahora=(strlen(strval(intval($horautc)-4))==1 ? '0'.strval(intval($horautc)-4):strval(intval($horautc)-4));
        $hora=str_replace(substr($hora,23,3),$nuevahora.':',$hora);
        $grupo=$item->filter('div.fi__info__group')->text();
        $estadio=$item->filter('div.fi__info__location > div.fi__info__stadium')->text();
        $ciudad=$item->filter('div.fi__info__location > div.fi__info__venue')->text();
        //$estado=$item->filter('div.fi-mu__status > div.fi-s__status')->text();
        $homeTeam=$item->filter('div.fi-mu__m div.home > div.fi-t__n > span.fi-t__nText')->text();
        $homeIcon=$this->icon($item->filter('div.fi-mu__m div.home > div.fi-t__n > span.fi-t__nTri')->text());
        $visitorTeam=$item->filter('div.fi-mu__m div.away > div.fi-t__n> span.fi-t__nText')->text();
        $visitorIcon=$this->icon($item->filter('div.fi-mu__m div.away > div.fi-t__n> span.fi-t__nTri')->text());
        //$detalles=$item->filter('div.fi-mu__m > div.fi-mu__details')->text();

        $juegos[]=['hora' => $hora,
                  'dmutc' => $dmutc,
                  'grupo' => $grupo,
                  'estadio' => $estadio,
                  'ciudad' => $ciudad,
                  'homeTeam' => $homeTeam,
                  'homeIcon' => $homeIcon,
                  'visitorTeam' => $visitorTeam,
                  'visitorIcon' => $visitorIcon];
      });
      $faseGrupos[]=['fecha' => $fecha,
                    'juegos' => $juegos];
    });

    $faseEliminatorias=array();
    $crawler=$client->request('GET','https://es.fifa.com/worldcup/matches/#knockoutphase');
    $crawler->filter('div#fi-list-view > div.fi-matchlist > div.fi-mu-list')->each(function($item,$i) use (&$faseEliminatorias){
      $fase=$item->filter('div.fi-mu-list__head > span')->text();
      $juegos=array();
      $item->filter('div.fi-mu.fixture')->each(function($item,$i) use (&$juegos){
        $hora=$item->filter('div.fi-mu__info__datetime')->text();
        $hora=str_replace(' Hora Local','',$hora);
        $horautc=substr($item->filter('div.fi-s__score.fi-s__date-HHmm')->attr('data-timeutc'),0,2);
        $dmutc=$item->filter('div.fi-s__score.fi-s__date-HHmm')->attr('data-daymonthutc');
        $nuevahora=(strlen(strval(intval($horautc)-4))==1 ? '0'.strval(intval($horautc)-4):strval(intval($horautc)-4));
        $hora=str_replace(substr($hora,23,3),$nuevahora.':',$hora);
        $grupo=$item->filter('div.fi__info__group')->text();
        if ($grupo==null) $grupo="Grupo";
        $estadio=$item->filter('div.fi__info__location > div.fi__info__stadium')->text();
        $ciudad=$item->filter('div.fi__info__location > div.fi__info__venue')->text();
        //$estado=$item->filter('div.fi-mu__status > div.fi-s__status')->text();
        $homeTeam=$item->filter('div.fi-mu__m div.home > div.fi-t__n > span.fi-t__nText')->text();
        $homeIcon="";//$this->icon($item->filter('div.fi-mu__m div.home > div.fi-t__n > span.fi-t__nTri')->text());
        $visitorTeam=$item->filter('div.fi-mu__m div.away > div.fi-t__n> span.fi-t__nText')->text();
        $visitorIcon="";//$this->icon($item->filter('div.fi-mu__m div.away > div.fi-t__n> span.fi-t__nTri')->text());
        //$detalles=$item->filter('div.fi-mu__m > div.fi-mu__details')->text();

        $juegos[]=['hora' => $hora,
                  'dmutc' => $dmutc,
                  'grupo' => $grupo,
                  'estadio' => $estadio,
                  'ciudad' => $ciudad,
                  'homeTeam' => $homeTeam,
                  'homeIcon' => $homeIcon,
                  'visitorTeam' => $visitorTeam,
                  'visitorIcon' => $visitorIcon];
      });
      $faseEliminatorias[]=['fase' => $fase,
                            'juegos' => $juegos];
    });
    $data=array('faseGrupos' => $faseGrupos,'faseEliminatorias' => $faseEliminatorias,'date' => strval(time()));
    return $data;
  }

  /**
   * @return Array
   */

  public function getGamesDataFromCache(){
    $cacheFile = $this->utils->getTempDir() . date("Ymd") . "_calendario_mundial.tmp";
    $cacheInMinutes=1; //For the results in the bets every minute
		if(file_exists($cacheFile)){
      $data = json_decode(file_get_contents($cacheFile),true); //Load the data in json format
      if (time()-intval(($data['date']))>(60*$cacheInMinutes)) {
        //Request the data
        $data=$this->getGames();
        // save cache file for today
        file_put_contents($cacheFile, json_encode($data));
        $this->payBets();
      }
    }
		else
		{
      $data=$this->getGames(); //Request the data
			// save cache file for today
			file_put_contents($cacheFile, json_encode($data));
    }
    return $data;
  }

  /**
   *
   * @param String
   * @return String
   */

  public function icon(String $img){
   $flags=['RUS' => '&#127479;&#127482;',
           'KSA' => '&#127480;&#127462;',
           'ARG' => '&#127462;&#127479;',
           'AUS' => '&#127462;&#127482;',
           'BEL' => '&#127463;&#127466;',
           'BRA' => '&#127463;&#127479;',
           'COL' => '&#127464;&#127476;',
           'CRC' => '&#127464;&#127479;',
           'CRO' => '&#127469;&#127479;',
           'DEN' => '&#127465;&#127472;',
           'EGY' => '&#127466;&#127468;',
           'ENG' => '&#127468;&#127463;',
           'ESP' => '&#127466;&#127480;',
           'FRA' => '&#127467;&#127479;',
           'GER' => '&#127465;&#127466;',
           'IRN' => '&#127470;&#127479;',
           'ISL' => '&#127470;&#127480;',
           'JPN' => '&#x1F1EF;&#x1F1F5;',
           'KOR' => '&#127472;&#127479;',
           'MAR' => '&#127474;&#127462;',
           'MEX' => '&#127474;&#127485;',
           'NGA' => '&#127475;&#127468;',
           'PAN' => '&#127477;&#127462;',
           'PER' => '&#127477;&#127466;',
           'POL' => '&#127477;&#127473;',
           'POR' => '&#127477;&#127481;',
           'SEN' => '&#127480;&#127475;',
           'SRB' => '&#127479;&#127480;',
           'SUI' => '&#127464;&#127469;',
           'SWE' => '&#127480;&#127466;',
           'TUN' => '&#127481;&#127475;',
           'URU' => '&#127482;&#127486;'
          ];
    return $flags[$img];
  }

  /**
   * @param Array
   * @return Integer
   */
  public function matchTimestamp(Array $juego){
    $_month=[1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 => 'Apr',
             5 => 'May', 6 => 'Jun', 7 => 'Jul', 8 => 'Aug',
             9 => 'Sep', 10 => 'Oct', 11 => 'Nov', 12 => 'Dec'];

    $d=substr($juego['dmutc'],0,2);
    $m=substr($juego['dmutc'],2,2);
    $h=substr($juego['hora'],23,5);
    $date=$d.'/'.$_month[intval($m)].'/2018:'.$h.':00 -0400';
    $start_date=strtotime($date);
    return $start_date;
  }

  public function updateMatches(){
    $data=$this->getGamesDataFromCache();

    foreach ($data['faseGrupos'] as $day) {
      foreach ($day['juegos'] as $juego) {
        $start_date=$this->matchTimestamp($juego);
        $end_date=$start_date+6000; //1:40 hours
        $cacheFile = $this->utils->getTempDir() . $start_date . "_match_mundial.tmp";
        if ($end_date>time()) {
          if (!file_exists($cacheFile)) {
            Connection::query("INSERT IGNORE INTO _mundial_matches(home_team,visitor_team,start_date,end_date)
            VALUES('".$juego['homeTeam']."','".$juego['visitorTeam']."','".date("Y-m-d H:i:s",$start_date)."','".date("Y-m-d H:i:s",$end_date)."')");
            file_put_contents($cacheFile,json_encode(array('lastUpdate' => time(),'results' => '0-0')));
          }
          $matchData=json_decode(file_get_contents($cacheFile),true);
        }

        if ($start_date<time() and $end_date>time() ) {
          if (time()-filemtime($cacheFile)>60) { //Cada minuto
            $matchData=['lastUpdate' => time(),'results' => '0-0']; //Aqui modificamos los resultados del partido;
            file_put_contents($cacheFile,json_encode($matchData));
            Connection::query("UPDATE _mundial_matches SET results='".$matchData['results']."' WHERE start_date=".date("Y-m-d H:i:s",$start_date));
          }
        }
      }
    }
  }
  public function payBets()
  {
    //Query para los pagos de las apuestas
    $finishedMatches=Connection::query("SELECT * FROM _mundial_matches WHERE
    UNIX_TIMESTAMP(CURRENT_TIMESTAMP)-UNIX_TIMESTAMP(end_date)>3600 AND payed=0 AND winner IS NOT NULL");
    foreach ($finishedMatches as $finishMatch) {
      $percents=Connection::query("SELECT t1.q AS home_bets,t2.q AS visitor_bets,t3.q As total_bets FROM
      (SELECT COUNT(*) AS q FROM _mundial_bets WHERE `match`='{$finishMatch->start_date}' AND team='HOME') as t1,
      (SELECT COUNT(*) AS q FROM _mundial_bets WHERE `match`='{$finishMatch->start_date}' AND team='VISITOR') as t2,
      (SELECT COUNT(*) AS q FROM _mundial_bets WHERE `match`='{$finishMatch->start_date}') as t3");
      $total_bets= ($percents[0]->total_bets>0) ? $percents[0]->total_bets : 1;
      $home_bets=($percents[0]->home_bets/$total_bets);
      $visitor_bets=($percents[0]->visitor_bets/$total_bets);
      $loserTeam=($finishMatch->winner=="HOME")?"VISITOR":"HOME";
      $winners=Connection::query("SELECT * FROM _mundial_bets WHERE
      `match`='{$finishMatch->start_date}' AND `team`='{$finishMatch->winner}' AND active=1");
      $losers=Connection::query("SELECT * FROM _mundial_bets WHERE
      `match`='{$finishMatch->start_date}' AND `team`='{$loserTeam}' AND active=1");
      foreach ($winners as $winner) {
        $ganancia=($winner->team=="HOME")?$home_bets:$visitor_bets;
        $ganancia=$winner->amount*(1+$ganancia);
        Connection::query("START TRANSACTION;
        UPDATE person SET credit=credit+$ganancia WHERE `email`='{$winner->user}';
        UPDATE _mundial_bets SET active=0 WHERE `user`='{$winner->user}' AND `match`='{$finishMatch->start_date}';
        COMMIT;");
        $this->utils->addNotification($winner->user, 'Mundial',"El equipo al que jugo gano el partido, usted gano $ganancia", 'CREDITO', 'IMPORTANT');
      }
      foreach ($losers as $loser) {
        Connection::query("UPDATE _mundial_bets SET active=0 WHERE `user`='{$winner->user}' AND `match`='{$finishMatch->start_date}'");
        $this->utils->addNotification($loser->user, 'Mundial',"El equipo al que jugo perdio el partido, usted no gano nada", 'MUNDIAL JUEGOS', 'IMPORTANT');
      }
      Connection::query("UPDATE _mundial_matches SET payed=1 WHERE `start_date`='{$finishMatch->start_date}'");
    }
  }
}
