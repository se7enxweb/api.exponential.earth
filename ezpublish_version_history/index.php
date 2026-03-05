<?php
/**
 * Page displaying the complete release history of eZ Publish using pure html + css, images
 *
 * @version $Id$
 * @copyright (C) G. Giunta 2011-2012
 * @author G. Giunta
 */

$startdate = strtotime( '2003/01/01' );
$enddate = strtotime( '2014/01/01' );
$grapwidth = 2048;
$series = false;

if ( isset( $_GET['3_x'] ) )
{
	$enddate = strtotime( '2009/01/01' );
	$series = '3.';
}
elseif ( isset( $_GET['4_x'] ) )
{
	$startdate = strtotime( '2007/12/01' );
	$series = '4.';
}

$scale = $grapwidth / ( $enddate - $startdate ) ;

// for csv format, see sample ODS file
$branches = loadCSV( 'ez_history.csv', $series );

$height = count( $branches ) * 19 + 17 /* self height */ + 13; /* 1 line title splits on 2 lines */

?>
<html>
<title>eZ Publish Version History</title>
<style type="text/css">
body { font-family: arial; color: #646464;}
h1 { color: #2A84B7; }
th { color: #F36F21; }
#branchgraph { border: none; }
#branchgraph td { border: none; margin: 0; padding: 0; font-size: small; height: 17px; }

ul.months, ul.years { position: relative; background-color: #939598; list-style-type: none; height: 17px; border: none; margin: 0; padding: 0; color: black;}
ul.years li { position: absolute; display: inline; top: 0; witdh: 13px; font-size: 11px; border: none; margin-top: 2px; padding-left: 2px; border-left: 1px solid #939598; }
ul.months li { position: absolute; display: inline; top: 0; witdh: 13px; font-size: 11px; border: none; margin-top: 2px; padding-left: 2px; border-left: 1px solid #939598; height: <?php echo $height; ?>px; }

ul.branch, ul.cpbranch { position: relative; background-color: #2A84B7; list-style-type: none; height: 13px; border: none; margin: 0; padding: 0;}
ul.maintenancebranch{ background-color: silver; }
ul.cpbranch { background-color: #F36F21; }
ul.branch li, ul.cpbranch li { position: absolute; display: inline-block; top: 0; width: 13px; height: 13px; font-size: 11px; border: none; margin: 0; padding: 0; background: url('dot.png')}
ul.branch li a, ul.cpbranch li a { position: relative; width: 13px; height: 13px;  display: inline-block; text-decoration: none; color: black; }
ul.branch li a span, ul.cpbranch li a span { margin-left: -999em; position: absolute; border: 1px solid gray;  font-size: 13px; padding: 0.5em; }
ul.branch li a span { background-color: #F36F21; }
ul.cpbranch li a span { background-color: #2A84B7; }
ul.branch li a:hover span, ul.cpbranch li a:hover span {
position: absolute;
left: 1em;
top: -4em;
     z-index: 99;
     margin-left: 0;
width: 100px;
       border-radius: 5px 5px;
       -moz-border-radius: 5px;
       -webkit-border-radius: 5px;
       box-shadow: 5px 5px 5px rgba(0, 0, 0, 0.1);
       -webkit-box-shadow: 5px 5px rgba(0, 0, 0, 0.1);
       -moz-box-shadow: 5px 5px rgba(0, 0, 0, 0.1);
}
</style>
<body>
<h1>eZ Publish Version History</h1>
<table id="branchgraph">
<tr><th>Branch</th><th>Releases</th></tr>
<?php

//$cp = array_pop( $branches );

// Calendar bar

$years = array();
$date = new DateTime();
$date = $date->setTimestamp( $startdate );
while ( $date->getTimestamp() < $enddate )
{
	$months[$date->getTimestamp()] = $date->format('m');
	//$date = $date + 60 * 60 * 24 * 365.25;
	$date->add( new DateInterval('P1M') );
}
$width = round( ( $enddate - $startdate ) * $scale );
echo "<tr><td></td><td><ul class=\"years\" style=\"width: {$width}px;\">";
foreach( $months as $date => $label )
{
	if ( $label == '01' )
	{
		$label = strftime( '%Y', $date );
		$pos = round( ( $date - $startdate ) * $scale );
		echo "<li class=\"year\" style=\"left: {$pos}px;\">$label</li>";
	}
}
echo "</ul></td></tr>\n";
echo "<tr><td></td><td><ul class=\"months\" style=\"width: {$width}px;\">";
foreach( $months as $date => $label )
{
	$pos = round( ( $date - $startdate ) * $scale );
	echo "<li class=\"month\" style=\"left: {$pos}px;\">$label</li>";
}
echo "</ul></td></tr>\n";

// EZP branches

foreach ( $branches as $branchname => $branchdata )
{
	$branched = strtotime( array_shift( $branchdata ) );
	// date of branch creation unknown: use date of 1st release
	if ( $branched == 0 )
	{
		$branched = strtotime( reset( $branchdata ) );
	}
	// not released yet: draw no line
	if ( $branched == 0 )
	{
		continue;
	}
	// should not happen: "open" branch
	$lastdate = strtotime( end( $branchdata ) );
	if ( $lastdate == 0 )
	{
		$lastdate = $enddate;
	}

	$branchstart = round( ( $branched - $startdate ) * $scale );
	$branchwidth = round( ( $lastdate - $branched ) * $scale );
	// rounding off errors
	if ( $branchwidth < 0 )
	{
		$branchwidth = 0;
	}

	if ( strtolower( $branchname ) == "community project" )
	{
		$class = "cpbranch";
	}
	else
	{
		$class = "branch";
	}
	echo "<tr><td>$branchname</td><td><ul class=\"{$class}\" style=\"left: {$branchstart}px; width: {$branchwidth}px;\" title=\"Branch: {$branchname}\">";
	foreach ( $branchdata as $releasename => $releasedate )
	{
		$releasestart = round( ( strtotime( $releasedate ) - $startdate ) * $scale ) - $branchstart;
		$releasestart = $releasestart - 6; // correction for dot image
		echo "<li style=\"left: {$releasestart}px;\"><a href=\"#\"><span>Release: {$releasename} ({$releasedate})</span></a></li>";
	}
	echo "</ul></td></tr>\n";
}

?>
</table>

<!-- Piwik -->
<script type="text/javascript">
var pkBaseURL = (("https:" == document.location.protocol) ? "https://piwik.share.ez.no/" : "http://piwik.share.ez.no/");
document.write(unescape("%3Cscript src='" + pkBaseURL + "piwik.js' type='text/javascript'%3E%3C/script%3E"));
</script><script type="text/javascript">
try {
var piwikTracker = Piwik.getTracker(pkBaseURL + "piwik.php", 1);
piwikTracker.trackPageView();
piwikTracker.enableLinkTracking();
} catch( err ) {}
</script><noscript><p><img src="http://piwik.share.ez.no/piwik.php?idsite=1" style="border:0" alt="" /></p></noscript>
<!-- End Piwik Tracking Tag -->

</body>
</html>
<?php

function loadCSV( $filename, $series = false )
{

	$branches = array();
	foreach( file( $filename ) as $i => $line )
	{
		$line = explode( ',', trim( $line ) );
		if ( $line[0] != '' )
		{
			$branchname = trim( array_shift( $line ) );
			array_shift( $line );
			$releasenames = array( 'branched' ); // branch creation
			foreach( $line as $release )
			{
				$releasenames[] = trim( $release );
			}
		}
		else
		{
			array_shift( $line );
			$releasedates = array( trim( array_shift( $line ) ) );
			foreach( $line as $date )
			{
				$releasedates[] = trim( $date );
			}

			$branches[$branchname] = array_combine( $releasenames, $releasedates );
		}
	}

	foreach( $branches as $name => $array )
	{
		//echo strtolower( $name );
		//echo$series;
		if ( $series && ( strpos( $name, $series ) !== 0 && ( $series != '4.' || strtolower( $name ) != 'community project' ) ) )
		{
			unset( $branches[$name] );
			continue;
		}
		foreach ( $array as $key => $val )
		{
			if ( $key == '' )
			{
				unset( $branches[$name][$key] );
			}
			else
			{
				$time = strtotime( $val );
				if ( $time )
				{
					//$branches[$name][$key] = $time;
				}
				else
				{
					if ( $key == 'branched' )
					{
						$branches[$name][$key] = null;
					}
					else
					{
						unset( $branches[$name][$key] );
					}
				}
			}
		}
	}

	return $branches;
}

?>
