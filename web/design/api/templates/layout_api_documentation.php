<?php
$enterpriseVersions = array( "5.1", "5.0", "4.7", "4.6", "4.5", "4.4" );
$communityVersions = array( "2013.9", "2013.7", "2013.6", "2013.5", "2013.4", "2013.1", "2012.12" );
$oldVersions = array( "4.3.0", "4.2.0", "4.1.4", "4.0.7", "3.10.1", "3.9.5", "3.8.10" );
?>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Exponential : API Documentation : Portal</title>
    <link rel="stylesheet" type="text/css" href="design/api/stylesheets/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="design/api/stylesheets/bootstrap-responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="design/api/stylesheets/main.css" />
</head>
<body data-spy="scroll" data-target=".navbar">
    <div class="row-fluid">
	<a href="https://github.com/se7enxweb/exponential">
	  <img
           class="fork"
	       loading="lazy"
	       width="149"
	       height="149"
	       style="position:absolute; top:0; right:0; border:0;"
	       src="https://aral.github.io/fork-me-on-github-retina-ribbons/right-green@2x.png"
	       alt="Fork me on GitHub">
        </a>
        <header class="main-header" >
            <a href="/">
                <img class="main-logo" src="design/api/images/exponential.png" alt="Exponential API Documentation" />
            </a>
            <!-- 
            <nav class="main-nav navbar">
                <div class="navbar-inner">
                    <ul class="nav nav-main mainnav">
                        <li><a href="#release_history">Release History</a></li>
                        <li><a href="#downloads">Downloads</a></li>
                        <li><a href="#other_resources">Other Resources</a></li>
                    </ul>
                </div>
            </nav>
            -->
        </header>

        <div class="container main">
            <article class="body span12">
                <section id="downloads">
                    <h3>Exponential API Documentation (Downloadable)</h3>
                    <label>Download Format<br />
                        <select class="download-format-select">
                            <option value="format-read">Read Online</option>
                            <option value="format-gz">Gzip</option>
                            <!--option value="format-bz2">Bzip 2</option-->
                            <option value="format-zip">Zip</option>
                        </select>
                    </label>
                    <label>
                        <input type="checkbox" class="toggle-all-formats" value="1" />
                        Show All Download Formats
                    </label>
                    <ul class="nav nav-tabs version-nav">
                        <li class="active"><a href="#Development" data-toggle="tab">Development</a></li>
			<!--
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                Enterprise Edition <b class="caret"></b>
                            </a>
                            <ul class="dropdown-menu">
                                <?php
                                foreach ( $enterpriseVersions as $version )
                                {
                                    echo '<li><a href="#v', str_replace( ".", "", $version ),'" data-toggle="tab">', $version, '</a></li>';
                                }
                                ?>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                Community Edition <b class="caret"></b>
                            </a>
                            <ul class="dropdown-menu">
                                <?php
                                foreach ( $communityVersions as $version )
                                {
                                    echo '<li><a href="#v', str_replace( ".", "", $version ),'" data-toggle="tab">', $version, '</a></li>';
                                }
                                ?>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href="#Older" class="dropdown-toggle" data-toggle="dropdown">
                                Older Releases <b class="caret"></b>
                            </a>
                            <ul class="dropdown-menu">
                                <?php
                                foreach ( $oldVersions as $version )
                                {
                                    echo '<li><a href="#v', str_replace( ".", "", $version ),'" data-toggle="tab">', $version, '</a></li>';
                                }
                                ?>
                            </ul>
			    -->
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div id="Development" class="tab-pane active">
                            <h3>Development</h3>
                            <p class="muted">Automatically updated daily from github master branch.</p>

                            <h4>API Docs</h4>
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th class="stack"></th>
                                        <th class="doxygen">Doxygen</th>
                                        <!--th class="docblox">DocBlox</th-->
                                          <!--th class="sami">Sami</th -->
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th>Exponential (Legacy) kernel</th>
                                        <td>
                                            <a class="download-link format-read" href="/doxygen/trunk/LS/html/index.html">Read Online</a>
                                            <a class="download-link format-gz format-bz2" href="/trunk/exponential-trunk-apidocs-doxygen-LS.tar.gz">Download (gz)</a>
                                            <a class="download-link format-zip" href="/trunk/exponential-trunk-apidocs-doxygen-LS.zip">Download (zip)</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Exponential 5.x kernel</th>
                                        <td>
                                            <a class="download-link format-read" href="/doxygen/trunk/NS/html/index.html">Read Online</a>
                                            <a class="download-link format-gz format-bz2" href="/trunk/exponential-trunk-apidocs-doxygen-NS.tar.gz">Download (gz)</a>
                                            <a class="download-link format-zip" href="/trunk/exponential-trunk-apidocs-doxygen-NS.zip">Download (zip)</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Exponential Basic (2.x) kernel</th>
                                        <td>
                                            <a class="download-link format-read" href="/doxygen/trunk/Basic/html/index.html">Read Online</a>
                                            <a class="download-link format-gz format-bz2" href="/trunk/exponential-trunk-apidocs-doxygen-Basic.tar.gz">Download (gz)</a>
                                            <a class="download-link format-zip" href="/trunk/exponential-trunk-apidocs-doxygen-Basic.zip">Download (zip)</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                            <h4>Source</h4>
                            <table class="table">
                                <tbody>
                                    <tr>
                                        <th class="stack">Exponential (Legacy) kernel</th>
                                        <td class="github">
                                            <a href="https://github.com/se7enxweb/exponential" class="download-link format-all">Available via Github</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="stack">Exponential 5.x kernel</th>
                                        <td class="github">
                                            <a href="https://github.com/se7enxweb/ezpublish-kernel" class="download-link format-all">Available via Github</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="stack">Exponential Basic</th>
                                        <td class="github">
                                            <a href="https://github.com/se7enxweb/exponentialbasic" class="download-link format-all">Available via Github</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="stack">Exponential Platform</th>
                                        <td class="github">
                                            <a href="https://github.com/se7enxweb/exponential-platform" class="download-link format-all">Available via Github</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="stack">Exponential Platform Nexus stack</th>
                                        <td class="github">
                                            <a href="https://github.com/se7enxweb/exponential-platform-nexus" class="download-link format-all">Available via Github</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                        </div>
                        <?php
                        foreach ( $enterpriseVersions as $version ):
                            echo '<div id="v', str_replace( ".", "", $version ), '" class="tab-pane"><h3>', $version, ' Enterprise Edition</h3>';
                            $is5 = version_compare( $version, "5.0", ">=" );
			?>
                            <h4>API Docs</h4>
                            <table class="table">
                                <thead>
                                <tr>
                                    <th class="stack"></th>
                                    <th class="doxygen">Doxygen</th>
                                    <!--th class="dockblox">DocBlox</th-->
                                    <th class="sami">Sami</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <th>Legacy kernel</th>
                                    <td>
                                        <a class="download-link format-read" href="/doxygen/<?= $version ?>.0/<?php if ( $is5 ) echo "LS/"; ?>html/index.html">Read Online</a>
                                        <a class="download-link format-gz format-bz2" href="/doxygen/<?= $version ?>.0/ezpublish-<?= $version ?>-apidocs-doxygen-<?= $is5 ? "LS" : "4X" ?>.tar.gz">Download (gz)</a>
                                        <a class="download-link format-zip" href="/doxygen/<?= $version ?>.0/ezpublish-<?= $version ?>-apidocs-doxygen-<?= $is5 ? "LS" : "4X" ?>.zip">Download (zip)</a>
                                        <!--span class="muted download-link format-bz2">Bz2 not available</span-->

                                    </td>
                                    <!--td>
                                        <p class="muted">Docblox not available</p>
                                    </td-->
                                    <td>
                                        <a class="download-link format-read" href="/sami/<?= $version ?>.0/<?php if ( $is5 ) echo "LS/"; ?>html/index.html">Read Online</a>
                                        <a class="download-link format-gz format-bz2" href="/sami/<?= $version ?>.0/ezpublish-<?= $version ?>-apidocs-sami-<?= $is5 ? "LS" : "4X" ?>.tar.gz">Download (gz)</a>
                                        <a class="download-link format-zip" href="/sami/<?= $version ?>.0/ezpublish-<?= $version ?>-apidocs-sami-<?= $is5 ? "LS" : "4X" ?>.zip">Download (zip)</a>
                                        <!--span class="muted download-link format-bz2">Bz2 not available</span-->
                                    </td>
                                </tr>
                                <?php if ( $is5 ): ?>
                                <tr>
                                    <th>5.x kernel</th>
                                    <td>
                                        <a class="download-link format-read" href="/doxygen/<?= $version ?>.0/NS/html/index.html">Read Online</a>
                                        <a class="download-link format-gz format-bz2" href="/doxygen/<?= $version ?>.0/ezpublish-<?= $version ?>-apidocs-doxygen-NS.tar.gz">Download (gz)</a>
                                        <a class="download-link format-zip" href="/doxygen/<?= $version ?>.0/ezpublish-<?= $version ?>-apidocs-doxygen-NS.zip">Download (zip)</a>
                                        <!--span class="muted download-link format-bz2">Bz2 not available</span-->
                                    </td>
                                    <!--td>
                                        <p class="muted">Docblox not available</p>
                                    </td-->
                                    <td>
                                        <a class="download-link format-read" href="/sami/<?= $version ?>.0/NS/html/index.html">Read Online</a>
                                        <a class="download-link format-gz format-bz2" href="/sami/<?= $version ?>.0/ezpublish-<?= $version ?>-apidocs-sami-NS.tar.gz">Download (gz)</a>
                                        <a class="download-link format-zip" href="/sami/<?= $version ?>.0/ezpublish-<?= $version ?>-apidocs-sami-NS.zip">Download (zip)</a>
                                        <!--span class="muted download-link format-bz2">Bz2 not available</span-->
                                    </td>
                                </tr>
                                <?php endif; ?>
                                </tbody>
                            </table>

                            <h4>Source</h4>
                            <p>Source is available via the <a href="https://support.exponential.earth">Enterprise Portal</a></p>
                        </div>
                        <?php
                        endforeach;
                        ?>

                        <?php
                        foreach ( $communityVersions as $version ):
                            echo '<div id="v', str_replace( ".", "", $version ), '" class="tab-pane"><h3>Community Release ', $version, '</h3>';
			            ?>
                            <h4>API Docs</h4>
                            <table class="table">
                                <thead>
                                <tr>
                                    <th class="stack"></th>
                                    <th class="doxygen">Doxygen</th>
                                    <!--th class="docblox">DocBlox</th-->
                                    <th class="sami">Sami</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <th>Legacy kernel</th>
                                    <td>
                                        <a class="download-link format-read" href="/doxygen/<?= $version ?>/LS/html/index.html">Read Online</a>
                                        <a class="download-link format-gz format-bz2" href="/doxygen/<?= $version ?>/ezpublish-community_project-<?= $version ?>-apidocs-doxygen-LS.tar.gz">Download (gz)</a>
                                        <a class="download-link format-zip" href="/doxygen/<?= $version ?>/ezpublish-community_project-<?= $version ?>-apidocs-doxygen-LS.zip">Download (zip)</a>
                                        <!--span class="muted download-link format-bz2">Bz2 not available</span-->

                                    </td>
                                    <!--td>
                                        <span class="muted download-link format-all">Docblox Not Available</span>
                                    </td-->
                                    <td>
                                        <a class="download-link format-read" href="/sami/<?= $version ?>/LS/html/index.html">Read Online</a>
                                        <a class="download-link format-gz format-bz2" href="/sami/<?= $version ?>/ezpublish-community_project-<?= $version ?>-apidocs-sami-LS.tar.gz">Download (gz)</a>
                                        <a class="download-link format-zip" href="/sami/<?= $version ?>/ezpublish-community_project-<?= $version ?>-apidocs-sami-LS.zip">Download (zip)</a>
                                        <!--span class="muted download-link format-bz2">Bz2 not available</span-->

                                    </td>
                                </tr>
                                <tr>
                                    <th>5.x kernel</th>
                                    <td>
                                        <a class="download-link format-read" href="/doxygen/<?= $version ?>/NS/html/index.html">Read Online</a>
                                        <a class="download-link format-gz format-bz2" href="/doxygen/<?= $version ?>/ezpublish-community_project-<?= $version ?>-apidocs-doxygen-NS.tar.gz">Download (gz)</a>
                                        <a class="download-link format-zip" href="/doxygen/<?= $version ?>/ezpublish-community_project-<?= $version ?>-apidocs-doxygen-NS.zip">Download (zip)</a>
                                        <!--span class="muted download-link format-bz2">Bz2 not available</span-->
                                    </td>
                                    <!--td>
                                        <span class="muted download-link format-all">Docblox Not Available</span>
                                    </td-->
                                    <td>
                                        <a class="download-link format-read" href="/sami/<?= $version ?>/NS/html/index.html">Read Online</a>
                                        <a class="download-link format-gz format-bz2" href="/sami/<?= $version ?>/ezpublish-community_project-<?= $version ?>-apidocs-sami-NS.tar.gz">Download (gz)</a>
                                        <a class="download-link format-zip" href="/sami/<?= $version ?>/ezpublish-community_project-<?= $version ?>-apidocs-sami-NS.zip">Download (zip)</a>
                                        <!--span class="muted download-link format-bz2">Bz2 not available</span-->

                                    </td>
                                </tr>
                                </tbody>
                            </table>

                            <h4>Source</h4>
                            <p>Source is available via the <a href="https://share.exponential.earth/downloads/downloads/">downloads page on share.exponential.earth</a></p>
                        </div>
                        <?php
                        endforeach;
                        ?>

                        <?php
                        foreach ( $oldVersions as $version ):
                            echo '<div id="v', str_replace( ".", "", $version ), '" class="tab-pane"><h3>Version ', $version, '</h3>';
			            ?>

                            <h4>API Docs</h4>
                            <table class="table">
                                <thead>
                                <tr>
                                    <th class="stack"></th>
                                    <th class="doxygen">Doxygen</th>
                                    <!--th class="dockblox">DocBlox</th-->
                                    <th class="sami">Sami</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <th>Legacy kernel</th>
                                    <td>
                                        <a class="download-link format-read format-zip" href="/doxygen/<?= $version ?>/html/index.html">Read Online</a>
                                        <a class="download-link format-gz format-bz2" href="/doxygen/<?= $version ?>/ezpublish-<?= substr( $version, 0, 3) ?>-apidocs-doxygen-4X.tar.gz">Download (gz)</a>
                                        <!--span class="muted download-link format-bz2">Bz2 not available</span-->
                                        <a class="download-link format-zip" href="/doxygen/<?= $version ?>/ezpublish-<?= substr( $version, 0, 3) ?>-apidocs-doxygen-4X.zip">Download (zip)</a>
                                    </td>
                                    <!--td>
                                        <span class="muted download-link format-all">Docblox Not Available</span>
                                    </td-->
                                    <td>
                                        <a class="download-link format-read format-zip" href="/sami/<?= $version ?>/html/index.html">Read Online</a>
                                        <a class="download-link format-gz format-bz2" href="/sami/<?= $version ?>/ezpublish-<?= substr( $version, 0, 3) ?>-apidocs-sami-4X.tar.gz">Download (gz)</a>
                                        <!--span class="muted download-link format-bz2">Bz2 not available</span-->
                                        <a class="download-link format-zip" href="/sami/<?= $version ?>/ezpublish-<?= substr( $version, 0, 3) ?>-apidocs-sami-4X.zip">Download (zip)</a>
                                    </td>
                                </tr>
                                </tbody>
                            </table>

                            <h4>Source</h4>
                            <p>Source is available via the <a href="https://share.exponential.earth/downloads/downloads/">downloads page on share.exponential.earth</a></p>
                        </div>
                        <?php
                        endforeach;
                        ?>
                    </div>
                </section>


                <section id="other_resources">
                    <h3>Other Resources</h3>
                    <div class="tile">
                        <h4>Exponential Project Portal</h4>
                        <p><a href="https://exponential.earth">exponential.earth</a> is the online community dedicated to Exponential (CMS)</p>
                        <a class="btn" href="https://exponential.earth/">Get more information, join the community!</a>
                    </div>
                    <div class="tile">
                        <h4>Share Exponential! Community Portal</h4>
                        <p><a href="https://share.exponential.earth">share.exponential.earth</a> is an online community dedicated to Exponential</p>
                        <a class="btn" href="https://share.exponential.earth/get-involved">Get involved!</a>
                    </div>
                    <div class="tile">
                        <h4>GitHub</h4>
                        <p>All Exponential development is available on Github for public access.</p>
                        <a class="btn" href="https://github.com/se7enxweb">Access Exponential code</a>
                    </div>
                    <div class="tile">
                        <h4>Project Issues</h4>
                        <p>Bugs and new features can be reported at issues.exponential.earth.</p>
                        <a class="btn" href="https://issues.exponential.earth">View Issues</a>
                    </div>
                    <div class="tile">
                        <h4>Exponential Extensions</h4>
                        <p><a href="https://projects.exponential.earth">Projects.exponential.earth</a> maintains a community directory of extensions.</p>
                        <a class="btn" href="https://projects.exponential.earth">Get Extensions</a>
                    </div>
                    <div class="tile">
                        <h4>Basic Project Website</h4>
                        <p>All Exponential Basic development is made available on via our project website.</p>
                        <a class="btn" href="https://basic.exponential.earth">Access Exponential Basic Project Website</a>
                    </div>
                    <div class="tile">
                        <h4>Platform Project Website</h4>
                        <p>All Exponential Platform development is made available on via our project website.</p>
                        <a class="btn" href="https://platform.exponential.earth">Access Exponential Platform Project Website</a>
                    </div>
                    <div class="tile">
                        <h4>eZpedia community wiki</h4>
                        <p>eZpedia is a community-edited repository of Exponential information</p>
                        <a class="btn" href="https://ezpedia.exponential.earth">Read eZpedia</a>
                    </div>
                    <div class="tile">
                        <h4>Feeds</h4>
                        <p>Planet Exponential aggregates posts from a large number of Exponential blogs.</p>
                        <a class="btn" href="https://planet.exponential.earth/">Read Posts</a>
                    </div>
                    <div class="tile">
                        <h4>Support</h4>
                        <p>Get the support for Exponential Family of CMS Products, Extensions and Bundles; Ask 7x.</p>
                        <a class="btn" href="https://support.exponential.earth/">Get Support / Ask 7x</a>
                    </div>
                    <div class="tile">
                        <h4>Composer Packages</h4>
                        <p>Get the Exponential Composer Packages you want today!</p>
                        <a class="btn" href="https://packagist.org/search/?query=se7enxweb">Get Composer Packages</a>
                    </div>
                    <div class="tile">
                        <h4>Documentation</h4>
                        <p>Official Exponential documentation for the current release can be found online.</p>
                        <a class="btn" href="https://doc.exponential.earth/Exponential/">Exponenital (Legacy) Docs</a><br />
                        <a class="btn" href="https://doc.exponential.earth/">5.x Docs</a>
                    </div>
                </section>

                <section id="release_history">
                    <h3>Release history</h3>
                    <p><a href="/ezpublish_version_history/index.php">This graph</a> details the evolution of Exponential over time.</p>
                </section>
            </article>

        </div>
    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-migrate-3.5.2.min.js"></script>
    <script type="text/javascript" src="design/api/javascript/bootstrap.min.js"></script>
    <script type="text/javascript" src="design/api/javascript/main.js"></script>

    <div style="text-align:center;font-weight:bold;font-size:1.15em;padding:1em 0 0.75em;">
        Copyright &copy; 1998 &ndash; 2026 <a href="https://se7enx.com/">7x</a>. All rights reserved.
        Licensed under the <a href="https://www.gnu.org/licenses/old-licenses/gpl-2.0.html" target="_blank">GNU GPLv2+</a>.
    </div>

</body>
</html>
