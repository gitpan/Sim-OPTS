# TO DO: CHECK THE VICINITY of  windows' centres TO @obstacledata

my @centerfront = ( ( $v[11][0] + ($v[12][0] - $v[11][0] ) / 2) , ( $v[11][1] + ($v[12][1] - $v[11][1] ) / 2) , ($v[14][2] / 2) );
my @centereast = ( ( $v[15][0] + ($v[16][0] - $v[15][0] ) / 2) , ( $v[15][1] + ($v[16][1] - $v[15][1] ) / 2) , ($v[18][2] / 2) );
my @centerback = ( ( $v[20][0] + ($v[19][0] - $v[20][0] ) / 2) , ( $v[20][1] + ($v[19][1] - $v[20][1] ) / 2) , ($v[22][2] / 2) );
my @centerwest = ( ( $v[24][0] + ($v[23][0] - $v[24][0] ) / 2) , ( $v[24][1] + ($v[23][1] - $v[24][1] ) / 2) , ($v[25][2] / 2) );

my @winpoints = push ( @winpoint , [@centerfront], [@centereast], [@centerback], [@centerwest] );

foreach my $winpoint (@winpoints)
{
	my @windowpoint = @{$winpoint};
	foreach my $obspoint (@obspoints)
	{
		@obstructionpoint = @{$obspoint);
		my $xlenght = ( $obstructionpoint[0] - $windowpoint[0] );
		my $ylenght = ( $obstructionpoint[1] - $windowpoint[1] );
		my $truedistance = sqrt ( ( $xlenght ** 2 ) + ( $ylenght ** 2 ) );
		my $heightdifference = ($obstructionpoint[2 ] - $windowpoint[2] );
		@differences = push( @differences, [ $truedistance ], [ $heightdifference ] );
		
	}
	
}

foreach my $difference ( @differences)
{
	@diff = @{$difference};
	my $ratio = ( $diff[0] / $diff[1} );
	@ratios = push (@ratios, $ratio);
}

if ( min(@ratio) > 6 ){ $nodesdata[$counternode][2] = "c"; } 
elsif ( ( min(@ratio) >= 3 ) and ( min(@ratio) <= 6 ) )  { $nodesdata[$counternode][2] = "g"; } 
elsif ( ( min(@ratio) < 3 ) )  { $nodesdata[$counternode][2] = "k"; } 





