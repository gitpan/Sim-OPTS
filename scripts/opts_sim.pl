#!/usr/bin/perl

# Copyright: Gian Luca Brunetti and Politecnico di Milano, 2008-2014
# email gianluca.brunetti@polimi.it
# This is a part of the Sim::OPTS Perl module.
# OPTS is made to manage parametric explorations through the use of the ESP-r building energy performance simulation platform.  
# This is free software.  You can redistribute it and/or modify it under the terms of the GNU General Public License 
# as published by the Free Software Foundation, version 2.


# HERE FOLLOWS THE "sim" FUNCTION, CALLED FROM THE MAIN PROGRAM FILE.  
#____________________________________________________________________________
# Activate or deactivate the following function calls depending from your needs
sub sim    # This function launch the simulations in ESP-r
{

	my $to = shift;
	my $mypath = shift;
	my $file = shift;
	my $filenew = shift;
	my $swap = shift;
	my @dowhat = @$swap;
	my $swap = shift;
	my @simdata = @$swap;
	my $simnetwork = shift;
	my $swap = shift;
	my @simtitle = @$swap;
	my $preventsim = shift;
	my $exeonfiles = shift;
	my $fileconfig = shift;
	my $swap = shift;
	my @themereports = @$swap;
	my $swap = shift;
	my @reportperiods = @$swap;
	my $swap = shift;
	my @retrievedata = @$swap;
	my $swap = shift;
	my @retrievedatatemps = @$swap;
	my $swap = shift;
	my @retrievedatacomfort = @$swap;
	my $swap = shift;
	my @retrievedataloads = @$swap;
	my $swap = shift;
	my @retrievedatatempsstats = @$swap;

	my $countersimmax = ( ( $#simdata + 1 ) / 4 );
	@dirs_to_simulate = grep -d, <$mypath/$filenew*>;
	print "@dirs_to_simulate\n";
	my $countersim;
	foreach my $dir_to_simulate (@dirs_to_simulate)
	{
		$countersim = 0;
				
		while ( $countersim < $countersimmax )
		{
			
			$dates_to_sim = $simtitle[$countersim];
			$file_res_retrievedb = "$dir_to_simulate-$dates_to_sim.res"; 
			$file_fl_retrievedb = "$dir_to_simulate-$dates_to_sim.fl";
				
			unless (  $preventsim eq "y")
			{
				my $resfile_to_obtain = "$dir_to_simulate-$dates_to_sim.res";
				my $flfile_to_obtain = "$dir_to_simulate-$dates_to_sim.fl";
				if (-e $resfile_to_obtain)
				{
					if ($exeonfiles eq "y") { print `chmod $resfile_to_obtain\n`;}
					print TOSHELL "chmod $resfile_to_obtain\n";
					if ($exeonfiles eq "y") { print `rm $resfile_to_obtain\n`;}
					print TOSHELL "rm $resfile_to_obtain\n";
				}
				if (-e $flfile_to_obtain)
				{
					if ($exeonfiles eq "y") { print `chmod $flfile_to_obtain\n`;}
					print TOSHELL "chmod $flfile_to_obtain\n";
					if ($exeonfiles eq "y") { print `rm $flfile_to_obtain\n`;}
					print TOSHELL "rm $flfile_to_obtain\n";
				}
			if ( $simnetwork eq "y" )
			{
				if ($exeonfiles eq "y") { print
				`bps -file $dir_to_simulate/cfg/$fileconfig -mode script<<XXX

c
$dir_to_simulate-$dates_to_sim.res
$dir_to_simulate-$dates_to_sim.fl
$simdata[0 + (4*$countersim)]
$simdata[1 + (4*$countersim)]
$simdata[2 + (4*$countersim)]
$simdata[3 + (4*$countersim)]
s
$simnetwork
Results for $dir_to_simulate-$dates_to_sim
y
y
-
-
-
-
-
-
-
XXX

`;}
					print TOSHELL
					  "bps -file $dir_to_simulate/cfg/$fileconfig -mode script<<XXX

c
$dir_to_simulate-$dates_to_sim.res
$dir_to_simulate-$dates_to_sim.fl
$simdata[0 + (4*$countersim)]
$simdata[1 + (4*$countersim)]
$simdata[2 + (4*$countersim)]
$simdata[3 + (4*$countersim)]
s
$simnetwork
Results for $dir_to_simulate-$dates_to_sim
y
y
-
-
-
-
-
-
-
XXX

";
			}
			}
				
				unless ($preventsim eq "y")
				{
				if ( $simnetwork eq "n" )
				{
					if ($exeonfiles eq "y") { print
					`bps -file $dir_to_simulate/cfg/$fileconfig -mode script<<XXX

c
$dir_to_simulate-$dates_to_sim.res
$simdata[0 + (4*$countersim)]
$simdata[1 + (4*$countersim)]
$simdata[2 + (4*$countersim)]
$simdata[3 + (4*$countersim)]
s
$simnetwork
Results for $dir_to_simulate-$dates_to_sim
y
y
-
-
-
-
-
-
-
XXX

`;}
					print TOSHELL
					  "bps -file $dir_to_simulate/cfg/$fileconfig -mode script<<XXX

c
$dir_to_simulate-$dates_to_sim.res
$simdata[0 + (4*$countersim)]
$simdata[1 + (4*$countersim)]
$simdata[2 + (4*$countersim)]
$simdata[3 + (4*$countersim)]
s
$simnetwork
Results for $dir_to_simulate-$dates_to_sim
y
y
-
-
-
-
-
-
-
XXX

";
				#}
			}
			}

			if ($dowhat[2] eq "y")
			{
				sub retrieve # This function retrieves the results of the simulations in the res module of ESP-r
				{
					my $themereport = $_[0];
					sub retrieve_temperatures_results
					{
						
						my $existingfile = "$file_res_retrievedb-temperatures.grt";
						if (-e $existingfile) { print `chmod 777 $existingfile\n`;} 
						print TOSHELL "chmod 777 $existingfile\n";
						if (-e $existingfile) { print `rm $existingfile\n` ;}
						print TOSHELL "rm $existingfile\n";
						if ($exeonfiles eq "y") { print `rm -f $existingfile*par\n`; }
						print TOSHELL "rm -f $existingfile*par\n";
						
						if ($exeonfiles eq "y") { print `res -file $file_res_retrievedb -mode script<<YYY

3
$retrievedatatemps[0]
$retrievedatatemps[1]
$retrievedatatemps[2]
c
g
a
a
b
a
b
e
b
f
>
a
$file_res_retrievedb-temperatures.grt
Simulation results $file_res_retrieved-temperatures
!
-
-
-
-
-
-
-
-
YYY

`;}
						print TOSHELL
						  "res -file $file_res_retrievedb -mode script<<YYY

3
$retrievedatatemps[0]
$retrievedatatemps[1]
$retrievedatatemps[2]
c
g
a
a
b
a
b
e
b
f
>
a
$file_res_retrievedb-temperatures.grt
Simulation results $file_res_retrieved-temperatures
!
-
-
-
-
-
-
-
YYY

";

						if (-e $existingfile) { print `rm -f $existingfile*par`;}
						print TOSHELL "rm -f $existingfile*par\n";
					}

					sub retrieve_comfort_results
					{
						my $existingfile = "$file_res_retrievedb-comfort.grt"; 
						if (-e $existingfile) { print `chmod 777 $existingfile\n`;} 
						print TOSHELL "chmod 777 $existingfile\n";
						if (-e $existingfile) { print `rm $existingfile\n` ;}
						print TOSHELL "rm $existingfile\n";
						if ($exeonfiles eq "y") { print `rm -f $existingfile*par\n`;}
						print TOSHELL "rm -f $existingfile*par\n";
						if ($exeonfiles eq "y") { print `res -file $file_res_retrievedb -mode script<<ZZZ

3
$retrievedatacomf[0]
$retrievedatacomf[1]
$retrievedatacomf[2]
c
g
c
a

b


a
>
a
$file_res_retrievedb-comfort.grt
Simulation results $file_res_retrieved-comfort
!
-
-
-
-
-
-
-
-
ZZZ

`;}
						print TOSHELL
						"res -file $file_res_retrievedb -mode script<<ZZZ

3
$retrievedatacomf[0]
$retrievedatacomf[1]
$retrievedatacomf[2]
c
g
c
a

b


a
>
a
$file_res_retrievedb-comfort.grt
Simulation results $file_res_retrieved-comfort
!
-
-
-
-
-
-
-
-
ZZZ

";
						if (-e $existingfile) { `rm -f $existingfile*par\n`;}
						print TOSHELL "rm -f $existingfile*par\n";
			}

					sub retrieve_loads_results
					{
						my $existingfile = "$file_res_retrievedb-loads.grt";
						if (-e $existingfile) { `chmod 777 $existingfile\n`;}
						print TOSHELL "chmod 777 $existingfile\n";
						if (-e $existingfile) { `rm $existingfile\n` ;}
						print TOSHELL "rm $existingfile\n";
						if (-e $existingfile) { `rm -f $existingfile*par\n`;}
						print TOSHELL "rm -f $existingfile*par\n";
						if ($exeonfiles eq "y") { print `res -file $file_res_retrievedb -mode script<<TTT

3
$retrievedataloads[0]
$retrievedataloads[1]
$retrievedataloads[2]
d
>
a
$file_res_retrievedb-loads.grt
Simulation results $file_res_retrieved-loads
l
a

-
-
-
-
-
-
-
TTT
`;}
				print TOSHELL
				  "res -file $file_res_retrievedb -mode script<<TTT

3
$retrievedataloads[0]
$retrievedataloads[1]
$retrievedataloads[2]
d
>
a
$file_res_retrievedb-loads.grt
Simulation results $file_res_retrieved-loads
l
a

-
-
-
-
-
-
-
TTT

";
					`rm -f $existingfile*par`;
			}

					sub retrieve_temps_stats
					{
						my $existingfile = "$file_res_retrievedb-tempsstats.grt";
						if (-e $existingfile) { `chmod 777 $existingfile\n`; }
						print TOSHELL "chmod 777 $existingfile\n";
						if (-e $existingfile) { `rm $existingfile\n` ;}
						print TOSHELL "rm $existingfile\n";
						if (-e $existingfile) { `rm -f $existingfile*par\n`;}
						print TOSHELL "rm -f $existingfile*par\n";
						if ($exeonfiles eq "y") { print `res -file $file_res_retrievedb -mode script<<TTT

3
$retrievedatatempsstats[0]
$retrievedatatempsstats[1]
$retrievedatatempsstats[2]
d
>
a
$file_res_retrievedb-tempsstats.grt
Simulation results $file_res_retrieved-tempsstats.grt
m
-
-
-
-
-
TTT
`;}
						print TOSHELL
						  "res -file $file_res_retrievedb -mode script<<TTT

3
$retrievedatatempsstats[0]
$retrievedatatempsstats[1]
$retrievedatatempsstats[2]
d
>
a
$file_res_retrievedb-tempsstats.grt
Simulation results $file_res_retrieved-tempsstats.grt
m
-
-
-
-
-
TTT

";
					if ($exeonfiles eq "y") { print `rm -f $existingfile*par\n`;}
					print TOSHELL "rm -f $existingfile*par\n";
						}
						
						if ( $themereport eq "temps" ) { retrieve_temperatures_results(); }
						if ( $themereport eq "comfort"  ) { retrieve_comfort_results(); }
						if ( $themereport eq "loads" ) 	{ retrieve_loads_results(); }
						if ( $themereport eq "tempsstats"  ) { retrieve_temps_stats(); }

					} # END SUB retrieve;
					
					foreach my $themereport (@themereports)
					{
						retrieve ($themereport, );
					}
				}    

				if ($dowhat[3] eq "y")
				{ 
					if ($exeonfiles eq "y") { print `rm $file_res_retrievedb\n`; }
					print TOSHELL "rm $file_res_retrievedb\n";
					if ($exeonfiles eq "y") { `rm $file_fl_retrievedb\n`;}
					print TOSHELL "rm $file_fl_retrievedb\n";
					# erase res and fl files
				}
			$countersim++;
		}
	}
}    # END SUB sim;

1;
