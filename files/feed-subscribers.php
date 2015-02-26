<?php /* With apologies to Dr. Drang and John Siracusa.

    feed-subscribers.php

    By Marco Arment.
    Released into the public domain with no warranties and no restrictions.

    Usage: Pipe an Apache access log into stdin, e.g.:
        php -f feed-subscribers.php < /var/log/httpd/access_log

    It's up to you whether you want to restrict its input to certain date ranges.
    In theory, it doesn't actually matter very much, and you may need a span of
    a few days to include everyone.

    Output looks something like this:

    28644	TOTAL
    8993	31.40%	+ NewsBlur
    4632	16.17%	= NetNewsWire
    2766	9.66%	+ Feed Wrangler
    1431	5.00%	= Reeder
    1366	4.77%	= Stringer
    1235	4.31%	= Fever
    ...

    Each user-agent is prefixed with a '+' or '=':
        + : This user-agent reports subscribers, so we're using that count instead of IPs.
        = : This user-agent doesn't report subscribers, so unique IPs are counted.

    Note that Google Reader is NOT included by default, since while its crawler is
    still running at the time of writing, nobody is seeing its results.


// -------------- CONFIG ------------------------ */

$feed_uris = array(
    '/atom.xml',
);

$minimum_subscribers_to_display = 3;
$include_google_reader = false;

// ------------- END CONFIG ----------------------
// ...unless you want to add more regexes to this:

function normalize_user_agent_string($user_agent)
{
    static $user_agent_replacements = array(
        // regex  =>  replacement        
        '/^Feedfetcher-Google.*$/' => 'Google Reader',
        '/^NewsBlur .*$/' => 'NewsBlur',
        '/^Feedly.*$/' => 'Feedly',
        '/^Feed Wrangler.*$/' => 'Feed Wrangler',
        '/^Fever.*$/' => 'Fever',
        '/^AolReader.*$/' => 'AOL Reader',
        '/^FeedHQ.*$/' => 'FeedHQ',
        '/^BulletinFetcher.*$/' => 'Bulletin',
        '/^Digg (Feed )?Fetcher.*$/' => 'Digg',
        '/^Bloglovin.*$/' => 'Bloglovin',
        '/^InoReader.*$/' => 'InoReader',
        '/^Xianguo.*$/' => 'Xianguo',
        '/^HanRSS.*$/' => 'HanRSS',
        '/^FeedBlitz.*$/' => 'FeedBlitz',
        '/^Feedshow.*$/' => 'Feedshow',
        '/^FeedSync.*$/' => 'FeedSync',
        '/^Slickreader Feed Fetcher.*$/' => 'Slickreader',
        '/^NetNewsWire.*$/' => 'NetNewsWire',
        '/^NewsGatorOnline.*$/' => 'NewsGator',
        '/^FeedDemon\/.*$/' => 'FeedDemon',
        '/^Netvibes.*$/' => 'Netvibes',
        '/^livedoor FeedFetcher.*$/' => 'livedoor',
        '/^Superfeedr.*$/' => 'Superfeedr',
        '/^g2reader-bot.*$/' => 'g2reader',
        '/^Feedbin - .*$/' => 'Feedbin',
        '/^CurataRSS.*$/' => 'CurataRSS',
        '/^Reeder.*$/' => 'Reeder',
        '/^Sleipnir.*$/' => 'Sleipnir',
        '/^BlogshelfII.*$/' => 'BlogshelfII',
        '/^Caffeinated.*$/' => 'Caffeinated',
        '/^RSSOwl\/.*$/' => 'RSSOwl',
        '/^NewsFire\/.*$/' => 'NewsFire',
        '/^NewsLife\/.*$/' => 'NewsLife',
        '/^Vienna.*$/' => 'Vienna',
        '/^Lector;.*$/' => 'Lector',
        '/^Sylfeed.*$/' => 'Sylfeed',
        '/^Status(%20)?Board.*$/' => 'StatusBoard',
        '/^curl\/.*$/' => 'curl',
        '/^Wget\/.*$/' => 'wget',
        '/^rss2email\/.*$/' => 'rss2email',
        '/^Python-urllib\/.*$/' => 'Python',
        '/^feedzirra .*$/' => 'feedzira',
        '/^newsbeuter.*$/' => 'newsbeuter',
        '/^Leselys.*$/' => 'Leselys',
        '/^Java\/.*$/' => 'Java',
        '/^Jakarta.*$/' => 'Java',
        '/^Apache-HttpClient\/.*[Jj]ava.*$/' => 'Java',
        '/^Ruby\/.*$/' => 'Ruby',
        '/^PHP\/.*$/' => 'PHP',
        '/^Zend.*Http.*$/' => 'PHP',
        '/^Leaf\/.*$/' => 'Leaf',
        '/^lire\/.*$/' => 'lire',
        '/^SimplePie.*$/' => 'SimplePie',
        '/^ReadKit.*$/' => 'ReadKit',
        '/^NewsRack.*$/' => 'NewsRack',
        '/^Pulp\/.*$/' => 'Pulp',
        '/^Liferea\/.*$/' => 'Liferea',
        '/^TBRSS\/.*$/' => 'TBRSS',
        '/^SushiReader\/.*$/' => 'SushiReader',
        '/^Akregator\/.*$/' => 'Akregator',
        '/^Mozilla\/5\.0 \(Sage\)$/' => 'Sage',
        '/^Tiny Tiny RSS.*$/' => 'Tiny Tiny RSS',
        '/^FreeRSSReader.*$/' => 'FreeRSSReader',
        '/^Yahoo Pipes.*$/' => 'Yahoo Pipes',
        '/^WordPress.*$/' => 'WordPress',
        '/^FeedBurner\/.*$/' => 'FeedBurner',
        '/^Dreamwith Studios.*$/' => 'Dreamwith Studios',
        '/^LiveJournal.*$/' => 'LiveJournal',
        '/^Apple-PubSub.*$/' => 'Apple PubSub',
        '/^Multiplexer\.me.*$/' => 'Multiplexer.me',
        '/^Microsoft Office.*$/' => 'Microsoft Office',
        '/^Windows-RSS-Platform.*$/' => 'Windows RSS',
        '/^.*FriendFeedBot\/.*$/' => 'FriendFeed',
        '/^.*Yahoo! Slurp.*$/' => 'Yahoo! Slurp',
        '/^.*YahooFeedSeekerJp.*$/' => 'YahooFeedSeekerJp',
        '/^.*YoudaoFeedFetcher\/.*$/' => 'Youdao',
        '/^.*PushBot\/.*$/' => 'PushBot',
        '/^.*FeedBooster\/.*$/' => 'FeedBooster',
        '/^.*Squider\/.*$/' => 'Squider',
        '/^.*Downcast\/.*$/' => 'Downcast',
        '/^.*Instapaper\/.*$/' => 'Instapaper',
        '/^.*Thunderbird\/.*$/' => 'Mozilla Thunderbird',
        '/^.*Flipboard(Proxy|RSS).*$/' => 'Flipboard',
        '/^.*Genieo.*$/' => 'Genieo',
        '/^.*Hivemined.*$/' => 'Hivemined',
        '/^.*theoldreader.com.*$/' => 'The Old Reader',
        '/^.*AppEngine-Google.*appid: s~(.*?)\)$/' => '\1 (Google App Engine)',
        '/^.*Googlebot\/.*$/' => 'Googlebot',
        '/^.*UniversalFeedParser\/.*$/' => 'UniversalFeedParser',
        '/^.*Opera.*$/' => 'Opera',
        '#^Mozilla/.* AppleWebKit.*? \(KHTML, like Gecko\) Version/.*? Safari/[^ ]*$#' => 'Safari',
        '#^Mozilla/.* AppleWebKit.*? \(KHTML, like Gecko\)$#' => 'Safari',
        '#^Mozilla/.* AppleWebKit.*? \(KHTML, like Gecko\) AdobeAIR/[^ ]*$#' => 'Adobe AIR',
        '#^Mozilla/.* Gecko/[^ ]* Firefox/[^ ]* Firefox/[^ ]*$#' => 'Firefox',
        '#^Mozilla/.* Gecko/[^ ]* Firefox/[^ ]*$#' => 'Firefox',
        '#^Mozilla/.* Gecko/[^ ]* Firefox/[^ ]* \(\.NET.*?\)$#' => 'Firefox',
        '#^Mozilla/.* AppleWebKit/.*? \(KHTML, like Gecko\) Chrome/.*? Safari/[^ ]*$#' => 'Chrome',
        '#^Mozilla/.* \(compatible; MSIE.*?\)$#' => 'MSIE',
        '/^([^\/]+)\/[\.0-9]+ CFNetwork[^ ]* Darwin[^ ]*$/' => '\1',
        '/^([^\/]+)\/[\.0-9]+$/' => '\1',
    );
    
    $user_agent = preg_replace(array_keys($user_agent_replacements), array_values($user_agent_replacements), $user_agent);
    return $user_agent;
}


// PROCESSING:
$feed_uris = array_flip($feed_uris);
$user_agents = array();
while (false !== ($line = fgets(STDIN)) ) {

    // Parse IP, URI, User-Agent from Apache common log line
    //                  IP         GET     /uri       UA
    if (preg_match('/([.0-9]+) .*?"[A-Z]+ ([^ ]+) .*"(.*?)"$/', $line, $matches)) {
        $ip = $matches[1];
        $uri = $matches[2];
        $user_agent = $matches[3];
    } else continue;
    
    // Skip requests for URIs we don't care about
    if (! isset($feed_uris[$uri])) continue;

    // Parse "X subscriber[s]", "X reader[s]"
    $subscribers = false;
    if (preg_match('/([0-9]+) subscribers?/i', $user_agent, $matches) ||
        preg_match('/([0-9]+) readers?/i', $user_agent, $matches)
    ) {
        $subscribers = $matches[1];
        $user_agent = str_replace($matches[0], '$SUBS$', $user_agent);
    }

    // Parse "feed-id=X", "feedid: X"
    $feed_id = false;
    if (preg_match('/feed-id=([0-9]+)/i', $user_agent, $matches) ||
        preg_match('/feedid: ([0-9]+)/i', $user_agent, $matches)
    ) {
        $feed_id = $matches[1];
        $user_agent = str_replace($matches[0], '$ID$', $user_agent);
    }
    
    if (! isset($user_agents[$user_agent])) $user_agents[$user_agent] = array('_direct' => array());
    
    if ($subscribers === false) {
        $user_agents[$user_agent]['_direct'][$ip] = 1;
    } else {
        $user_agents[$user_agent][$feed_id === false ? '-' : $feed_id] = intval($subscribers);
    }    
}

// NORMALIZING AND COALESCING:
$output_uas = array();
foreach ($user_agents as $user_agent => $feed_ids) {
    $total_subs = count($feed_ids['_direct']);
    unset($feed_ids['_direct']);
    $is_reporting_multiple_subs = count($feed_ids) > 0;
    $total_subs += array_sum($feed_ids);
    $feed_ids = $total_subs;

    // Prefix UA with whether this feed represents multiple subscribers (+) or direct IPs (=)
    if (false !== strpos($user_agent, '$SUBS$')) {
        $prefix = '+ ';
    } else {
        $prefix = '= ';
    }

    $output_ua = $prefix . normalize_user_agent_string($user_agent);
    
    if (isset($output_uas[$output_ua])) $output_uas[$output_ua] += $total_subs;
    else $output_uas[$output_ua] = $total_subs;
}

// SORTING AND DISPLAYING:
arsort($output_uas);

if (! $include_google_reader) unset($output_uas['+ Google Reader']);

$total = array_sum($output_uas);
echo "$total\tTOTAL\n";

if ($total > 0) {
    foreach ($output_uas as $ua => $ua_total) {
        if ($ua_total < $minimum_subscribers_to_display) break;
        $display_pct = number_format(100 * $ua_total / $total, 2) . '%';
        echo "$ua_total\t$display_pct\t$ua\n";
    }
}
