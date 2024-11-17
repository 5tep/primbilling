#!/usr/bin/php
<?php

$db = mysqli_connect("localhost", "bitfan", "***************", "prim_billing");
function convert2Array($array) {
    $content = '';
    foreach ($array as $line) { $content .= $line . PHP_EOL; }
    return $content;
}

function get_active ( $db, $user ) {
        $result = 0;
        $Row = mysqli_fetch_array(mysqli_query($db, "SELECT id FROM services_used WHERE user = $user AND  datetime_stop ='0000-00-00' LIMIT 1"));
        if( isset($Row['id']))  {
            $result = 1;
        }
        return $result;
}

function get_first_start ( $db, $user ) {
        $result = null;
        $Row = mysqli_fetch_array(mysqli_query($db, "SELECT datetime_start FROM services_used WHERE user = $user ORDER BY id DESC LIMIT 1"));
        if( isset($Row['datetime_start']))  {
            $result = $Row['datetime_start'];
        }
        return $result;
}

$Query = "SELECT c.id, c.fio, c.passport, c.birthday, s.name as street_name, c.house, c.apartment FROM cms_operators c, streets s WHERE c.street = s.id";
$Result = mysqli_query($db, $Query);
while ( $Row = mysqli_fetch_assoc($Result)) {

    extract($Row);

    $active = get_active ($db, $id);
    $first_start = get_first_start ($db, $id);

    $Array[] = $id.";".$REGION_ID."6;".$first_start." 00:00:00;".$id.";".$first_start." 00:00:00;".$ACTUAL_TO."2035-01-01 00:00:00;".$ABONENT_TYPE."42;".$NAME_INFO_TYPE."1;".$FAMILY_NAME.";".$GIVEN_NAME.";".$INITIAL_NAME.";".$fio.";".$birthday." 00:00:00;".$IDENT_CARD_TYPE_ID."1;".$IDENT_CARD_TYPE."1;".$IDENT_CARD_SERIAL.";".$IDENT_CARD_NUMBER.";".$IDENT_CARD_DESCRIPTION.";".$passport.";".$BANK.";".$BANK_ACCOUNT.";".$FULL_NAME.";".$INN.";".$CONTACT.";".$PHONE_FAX.";".$active.";".$first_start." 00:00:00;".$DETACH."2035-01-01 00:00:00;".$NETWORK_TYPE."4;".$INTERNAL_ID1.";".PHP_EOL;
}

file_put_contents('./result/ABONENT_20240926_1622.txt', $Array);

?>
