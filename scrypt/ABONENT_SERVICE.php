#!/usr/bin/php
<?php

$db = mysqli_connect("localhost", "bitfan", "***************", "prim_billing");

function convert2Array($array) {

    $content = '';
    foreach ($array as $line) { $content .= $line . PHP_EOL; }
    return $content;
}

function get_first_start ( $db, $user ) {
        $result = null;
        $Row = mysqli_fetch_array(mysqli_query($db, "SELECT datetime_start FROM services_used WHERE user = $user ORDER BY id DESC LIMIT 1"));
        if( isset($Row['datetime_start']))  {
            $result = $Row['datetime_start'];
        }
        return $result;
}

$Query = "SELECT c.id, s.name as street_name, c.house, c.apartment FROM cms_operators c, streets s WHERE c.street = s.id";
$Result = mysqli_query($db, $Query);
while ( $Row = mysqli_fetch_assoc($Result)) {

   extract($Row);

   $first_start = get_first_start ($db, $id);
   $Array[] = $id.";".$REGION_ID."6;".$id.";".$first_start." 00:00:00;".$END_TIME."2035-01-01 00:00:00;".$PARAMETER.";".$id.";".$id."".PHP_EOL;
}

file_put_contents('./result/ABONENT_SERVICE_20240926_1624.txt', $Array);

?>
