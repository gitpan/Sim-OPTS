# BEGIN CONFIGFILE AMOEBA 6
print OUTFILEFEEDBACK "BOOV!\n\n";

$edge_x = sqrt ( ( abs($v[2][0] - $v[1][0]) **2 ) + ( abs($v[2][1] - $v[1][1]) **2 ) );
$height = $v[5][2] - $v[1][2];
$edge_y = $v[4][1] - $v[1][1];
$present_volume = ($edge_x * $edge_y * $edge_z);






$edge_new_y = ($basevalue * ( 1 / ( $height * $edge_x ) ) ); 
$center_edge_new_y = ( $v[1][1] + ( $edge_new_y /2) ); $center_edge_new_y = sprintf("%.5f", $center_edge_new_y );
$difference_centers = ($center_edge_old_y - $center_edge_new_y) ; $difference_centers = sprintf("%.5f", $difference_centers );

$new_y = ( $v[1][1] + $edge_new_y ); $new_y = sprintf("%.5f", $new_y );



$v[3][1] = $new_y;
$v[4][1] = $new_y;
$v[7][1] = $new_y;
$v[8][1] = $new_y;
$v[19][1] = $new_y;
$v[20][1] = $new_y;
$v[21][1] = $new_y;
$v[22][1] = $new_y;
$v[9][1] = $center_edge_new_y;
$v[10][1] = $center_edge_new_y;
$v[15][1] = $v[15][1] - $difference_centers;
$v[16][1] = $v[16][1] - $difference_centers;
$v[17][1] = $v[17][1] - $difference_centers;
$v[18][1] = $v[18][1] - $difference_centers;
$v[23][1] = $v[23][1] - $difference_centers;
$v[24][1] = $v[24][1] - $difference_centers;
$v[25][1] = $v[25][1] - $difference_centers;
$v[26][1] = $v[26][1] - $difference_centers;


# END CONFIGFILE AMOEBA 6

1;
