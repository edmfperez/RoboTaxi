<?php
/**
 * Created by IntelliJ IDEA.
 * User: Marcus Eicher
 * Date: 24.02.2018
 * Time: 16:10
 *
 * Actual functional PHP getVehicle
 * https://tchallst.create.stedwards.edu/delorean/topics/api.php
 */

$db = new mysqli("localhost", "meicherc_WeGo", "erQ6340efSCf", "meicherc_WeGo");
$rs = $db->query("select * from WeGoVehicleDB where vehicleID = " . $_GET['vehicleID'] )->fetch_assoc();

$vehicle = new stdClass();

$vehicle -> vehicleID           = $rs['vehicleID'];
$vehicle -> ownerID             = $rs['ownerID'];
$vehicle -> capacity            = $rs['capacity'];
$vehicle -> inService           = $rs['inService'];
$vehicle -> inUse               = $rs['inUse'];
$vehicle -> currentLatitude     = $rs['currentLatitude'];
$vehicle -> currentLongitude    = $rs['currentLongitude'];

$json = json_encode($vehicle);


if ($vehicle -> vehicleID == null)
{
    http_response_code(404);
    print "ERROR: vehicleID not in database!";
}
else
{
    http_response_code(202);
    print $json;
}

$db -> close();
?>