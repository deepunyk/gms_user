<?php
    include 'dbCon.php';
    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    $startTime = $_POST['startTime'];
    
    $conn = OpenCon();
    
    if (!$conn)
    {
        die("Connection failed: " . mysqli_connect_error());
    }
    else
    {
        for($i = 0; $i < count($latitude); $i++){
            $lat = (double)$latitude[$i];
            $lon = (double)$longitude[$i];
            $st = $starttime[$i];
            $sql =  "insert into gms_location (latitude, longitude, upload_time) values($lat, $lon, $st)";
            $result = $conn->query($sql);
        }
        if ($result) 
        {
            echo $conn->insert_id;
        }
        else 
        {
            echo $conn->error;
        }
    }
    CloseCon($conn);
?>