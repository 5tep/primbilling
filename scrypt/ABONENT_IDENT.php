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

$Query = "SELECT c.id, c.login, s.name as street_name, c.house, c.apartment FROM cms_operators c, streets s WHERE c.street = s.id";
$Result = mysqli_query($db, $Query);
while ( $Row = mysqli_fetch_assoc($Result) ) {

    extract($Row);

    $first_start = get_first_start ($db, $id);

    $Array[] = $id.";".$REGION_ID."6;".$IDENT_TYPE."5;".$PHONE.";".$INTERNAL_NUMBER.";".$IMSI.";".$IMEI.";".$ICC.";".$MIN.";".$ESN.";".$EQUIPMENT_TYPE.";".$MAC.";".$VPI.";".$VCI.";".$LOGIN.";".$E_MAIL.";".$PIN.";".$USER_DOMAIN.";".$RESERVED.";".$ORIGINATOR_NAME.";".$IP_TYPE.";".$IPV4.";".$IPV6.";".$IP_MASK_TYPE.";".$IPV4_MASK.";".$IPV6_MASK.";".$IP_RANGE_START.";".$IP_RANGE_END.";".$id.";".$id.";".$first_start." 00:00:00;".$END_TIME."2035-01-01 00:00:00;".$LINE_OBJECT.";".$LINE_CROSS.";".$LINE_BLOCK.";".$LINE_PAIR.";".$LINE_RESERVED.";".$LOC_TYPE.";".$LOC_LAC.";".$LOC_CELL.";".$LOC_TA.";".$LOC_CELL_WIRELESS.";".$LOC_MAC.";".$LOC_LATITUDE.";".$LOC_LONGITUDE.";".$LOC_PROJECTION_TYPE.";".$LOC_IP_TYPE.";".$LOC_IPV4.";".$LOC_IPV6.";".PHP_EOL;
    $Array[] = $id.";".$REGION_ID."6;".$IDENT_TYPE."5;".$PHONE.";".$INTERNAL_NUMBER.";".$IMSI.";".$IMEI.";".$ICC.";".$MIN.";".$ESN.";".$EQUIPMENT_TYPE.";".$MAC.";".$VPI.";".$VCI.";".$login.";".$E_MAIL.";".$PIN.";".$USER_DOMAIN.";".$RESERVED.";".$ORIGINATOR_NAME.";".$IP_TYPE.";".$IPV4.";".$IPV6.";".$IP_MASK_TYPE.";".$IPV4_MASK.";".$IPV6_MASK.";".$IP_RANGE_START.";".$IP_RANGE_END.";".$id.";".$id.";".$first_start." 00:00:00;".$END_TIME."2035-01-01 00:00:00;".$LINE_OBJECT.";".$LINE_CROSS.";".$LINE_BLOCK.";".$LINE_PAIR.";".$LINE_RESERVED.";".$LOC_TYPE.";".$LOC_LAC.";".$LOC_CELL.";".$LOC_TA.";".$LOC_CELL_WIRELESS.";".$LOC_MAC.";".$LOC_LATITUDE.";".$LOC_LONGITUDE.";".$LOC_PROJECTION_TYPE.";".$LOC_IP_TYPE.";".$LOC_IPV4.";".$LOC_IPV6.";".PHP_EOL;
}

file_put_contents('./result/ABONENT_IDENT_20240926_1623.txt', $Array);

?>
