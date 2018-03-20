<?php
/**
 * Created by IntelliJ IDEA.
 * User: Marcus Eicher
 * Date: 07.03.2018
 * Time: 21:36
 *
 * Actual functional PHP setVehicle
 * https://tchallst.create.stedwards.edu/delorean/topics/api.php
 *
 * Usage:   setVehicle.php?vehicleID=1&ownerID=1&capacity=4&inService=1&inUse=1&currentLatitude=-11.11111111&currentLongitude=-11.11111111
 *          All parameters must be given to update vehicle, will not execute otherwise
 *          HTTP 202 & "SUCCESS" : Database was updated, otherwise it does HTTP 404 or 400 and an error message
 *          currentLatitude & currentLongitude is not float, but a decimal(10,8) in the database
 */

/**
 * TODO:    TJ's scrubQuery does not work (syntax error)
 */

$db = new mysqli("localhost", "meicherc_phpUser", "KEvMLTly36", "meicherc_dbs");


//check if ID exists in database
$rs = $db->query("select * from WeGoVehicleDB where vehicleID = " . $_GET['vehicleID'] )->fetch_assoc();

if ($rs['vehicleID'] == null)
{
    http_response_code(404);
    print "ERROR: vehicleID is not in database!";
}
else
{
    $bigquery = "update WeGoVehicleDB
    set ownerID = ". $_GET['ownerID'] .",
    capacity = ". $_GET['capacity'] .",
    inService = ". $_GET['inService'] .",
    inUse = ". $_GET['inUse'] .",
    currentLatitude = ". $_GET['currentLatitude'] .",
    currentLongitude = ". $_GET['currentLongitude'] ."  where vehicleID = " . $_GET['vehicleID'];

    //print $bigquery;

    if ($_GET['ownerID'] != null and $_GET['capacity'] != null and $_GET['inService'] != null and $_GET['inUse'] != null and $_GET['currentLatitude'] != null and $_GET['currentLongitude'] != null)
    {
        $check1 = true;
        $check2 = true;

        if ($_GET['inService'] < 0 or $_GET['inService'] > 1) $check1 = false;
        if ($_GET['inUse'] < 0 or $_GET['inUse'] > 1) $check2 = false;

        if ($check1 == true and $check2 == true)
        {
            $rs = $db->query($bigquery);
            http_response_code(202);
            print "SUCCESS";
        }
        else
        {
            http_response_code(400);
            print "ERROR: inService and/or inUse is not boolean!";
        }
    }
    else
    {
        http_response_code(400);
        print "ERROR: Missing parameters!";
    }
}

$db -> close();
?>