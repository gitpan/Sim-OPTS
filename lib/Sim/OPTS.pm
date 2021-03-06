package Sim::OPTS;
# Copyright (C) 2008-2014 by Gian Luca Brunetti and Politecnico di Milano.
# This is OPTS, a program for detailed metadesign managing parametric explorations through the ESP-r building performance simulation platform and performing optimization by block coordinate descent.
# This is free software.  You can redistribute it and/or modify it under the terms of the GNU General Public License 
# as published by the Free Software Foundation, version 2.

use v5.14; # use v5.20;
use Exporter;
use vars qw( $VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS );
use Math::Trig;
use List::Util qw[ min max reduce shuffle];
use List::MoreUtils;
use List::AllUtils qw(sum);
use Statistics::Basic qw(:all);
use Set::Intersection;
use List::Compare;
use Data::Dumper;
$Data::Dumper::Indent = 0;
$Data::Dumper::Useqq  = 1;
$Data::Dumper::Terse  = 1;

#use feature qw(postderef); # no warnings qw(experimental::postderef);
use feature 'say';
no strict; 
no warnings;

@ISA = qw(Exporter); # our @adamkISA = qw(Exporter);
%EXPORT_TAGS = ( DEFAULT => [qw( &opts &prepare )]); # our %EXPORT_TAGS = ( 'all' => [ qw( ) ] );
@EXPORT_OK   = qw(); # our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
@EXPORT = qw( opts prepare ); # our @EXPORT = qw( );
$VERSION = '0.36.16.13'; # our $VERSION = '';
$ABSTRACT = 'Sim::OPTS it a tool for detailed metadesign. It manages parametric explorations through the ESP-r building performance simulation platform and performs optimization by block coordinate descent.';

#################################################################################
#################################################################################
# BEGINNING OF OPTS 
	
sub opts 
{ 
	my ( $filenew, $winnerline, $loserline, $configfile, $morphfile, $simlistfile, $sortmerged, @totvarnumbers, @uplift, @downlift, $fileuplift, $filedownlift, @varnumbers, @newvarnumbers, @newblockelts, $countvar, @seedfiles );
	sub start
	{
###########################################
print "THIS IS OPTS.
Copyright by Gian Luca Brunetti and Politecnico di Milano, 2008-14.
DAStU Department, Polytechnic of Milan

-------------------

To use OPTS, an OPTS configuration file and a target ESP-r model should have been prepared.
Please insert the name of a configuration file (Unix path):\n";
###########################################
		$configfile = <STDIN>;
		chomp $configfile;
		if (-e $configfile ) { ; }
		else { &start; }
	}
	&start;

	# eval `cat $configfile`; # The file where the program data are
	require $configfile; # The file where the program data are ZZZ# PROBLEM HERE, MISSING
	if (-e $casegroupfile) { require $casegroupfile; }

	# use Sim::OPTS::morph; # use Sim::OPTS::sim; # HERE THE FUNCTIONS "sim" and "retrieve" are. # use Sim::OPTS::report; # use Sim::OPTS::format;

	###########################################################################################
	# BEGINNING OF THE OPTS PROGRAM.

	print "OPTS - IS - RUNNING.
-------------------\n";
	if ($outfile) { open ( OUTFILE, ">$outfile" ) or die "Can't open $outfile: $!"; }
	if ($toshell) { open ( TOSHELL, ">$toshell" ) or die "Can't open $toshell: $!"; }	
	if ($reportfile) { open ( REPORTFILE, ">./$reportfile" ) or die "Can't open $reportfile: $!" };
 	if ($outfilewrite) { open ( OUTFILEWRITE, ">./$outfilewrite" ) or die "Can't open $outfilewrite: $!" };
	unless (-e "$mypath/models") { `mkdir $mypath/models`; }
	unless (-e "$mypath/models") { print TOSHELL "mkdir $mypath/models\n\n"; }
	
	if (-e "./SIM/OPTS/prepare.pm")
	{
		eval `cat ./SIM/OPTS/prepare.pm`; 
	}

	#################################################################################
	#################################################################################
	sub exec
	{
		my $swap = shift;
		my @varnumbers = @$swap;
		my $countblock = shift;
		my $countcase = shift;
		my $swap = shift;
		my @newvarnumbers = @$swap;
		my $swap = shift;
		my @uplift = @$swap;
		my $swap = shift;
		my @downlift = @$swap;
		my $swap = shift;
		my @blocks = @$swap;
		my $swap = shift;
		my @blockelts = @$swap;
		my $swap = shift;
		my @newblockelts = @$swap;
		my $swap = shift;
		my @overlap = @$swap;
		
		$morphfile = "$mypath/$file-morphfile-$countcase-$countblock";
		$simlistfile = "$mypath/$file-simlist-$countcase-$countblock";
		
		open (MORPHFILE, ">$morphfile") or die;
								
		@totvarnumbers = (@totvarnumbers, @varnumbers);
		@totvarnumbers = uniq(@totvarnumbers);
		@totvarnumbers = sort(@totvarnumbers);

		sub morph
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
			my @simtitles = @$swap;
			my $preventsim = shift;
			my $exeonfiles = shift;
			my $fileconfig = shift;
			my $swap = shift;
			my @themereports = @$swap;
			my $swap = shift;
			my @reporttitles = @$swap;
			my $swap = shift;
			my @retrievedata = @$swap;
			my $swap = shift;
			my @varnumbers = @$swap;
			my $countblock = shift;
			my $countcase = shift;
		
			say OUTFILE "\nHERE 2 ";
			$countvar = 0;
			foreach $varnumber (@varnumbers)
			{
				my @casemorphed;
				say OUTFILE "\nHERE 3 ";
					
				if ( $countvar == $#varnumbers )
				{
					$$general_variables[0] = "n";
				} # THIS TELLS THAT IF THE SEARCH IS ENDING (LAST SUBSEARCH CYCLE) GENERATION OF CASES HAS TO BE TURNED OFF
				
				$stepsvar = ${ "stepsvar" . "$varnumber" };
				@applytype = @{ "applytype" . "$varnumber" };
				@generic_change = @{ "generic_change" . "$varnumber" };
				$rotate = ${ "rotate" . "$varnumber" };
				$rotatez = ${ "rotatez" . "$varnumber" };
				$general_variables = ${ "general_variables" . "$varnumber" };
				$translate = ${ "translate" . "$varnumber" };
				$translate_surface_simple = ${ "translate_surface_simple" . "$varnumber" };
				$translate_surface = ${ "translate_surface" . "$varnumber" };
				$keep_obstructions = ${ "keep_obstructions" . "$varnumber" };
				$shift_vertexes = ${ "shift_vertexes" . "$varnumber" };
				$construction_reassignment = ${ "construction_reassignment" . "$varnumber" };
				$thickness_change = ${ "thickness_change" . "$varnumber" };
				$recalculateish = ${ "recalculateish" . "$varnumber" };
				@recalculatenet = @{ "recalculatenet" . "$varnumber" };
				$obs_modify = ${ "obs_modify" . "$varnumber" };
				$netcomponentchange = ${ "netcomponentchang" . "$varnumber" };
				$changecontrol = ${ "changecontrol" . "$varnumber" };
				@apply_constraints = @{ "apply_constraints" . "$varnumber" }; # NOW SUPERSEDED BY @constrain_geometry
				$rotate_surface = ${ "rotate_surface" . "$varnumber" };
				@reshape_windows = @{ "reshape_windows" . "$varnumber" };
				@apply_netconstraints = @{ "apply_netconstraints" . "$varnumber" };
				@apply_windowconstraints = @{ "apply_windowconstraints" . "$varnumber" };
				@translate_vertexes = @{ "translate_vertexes" . "$varnumber" };
				$warp = ${ "warp" . "$varnumber" };
				@daylightcalc = @{ "daylightcalc" . "$varnumber" };
				@change_config = @{ "change_config" . "$varnumber" };
				@constrain_geometry = @{ "constrain_geometry" . "$varnumber" };
				@vary_controls = @{ "vary_controls" . "$varnumber" };
				@constrain_controls =  @{ "constrain_controls" . "$varnumber" };
				@constrain_geometry = @{ "constrain_geometry" . "$varnumber" };
				@constrain_obstructions = @{ "constrain_obstructions" . "$varnumber" };
				@get_obstructions = @{ "get_obstructions" . "$varnumber" };
				@pin_obstructions = @{ "pin_obstructions" . "$varnumber" };
				$checkfile = ${ "checkfile" . "$varnumber" };
				@vary_net = @{ "vary_net" . "$varnumber" };
				@constrain_net = @{ "constrain_net" . "$varnumber" };
				@propagate_constraints = @{ "propagate_constraints" . "$varnumber" };
				@change_climate = @{ "change_climate" . "$varnumber" };
				$skip = ${ "skip" . "$varnumber" };
				$constrain = ${ "constrain" . "$varnumber" };
				my @cases_to_sim;
				my @files_to_convert;
				my (@v, @obs, @node, @component, @loopcontrol, @flowcontrol); # THINGS GLOBAL AS REGARDS COUNTER ZONE CYCLES
				my (@myv, @myobs, @mynode, @mycomponent, @myloopcontrol, @myflowcontrol); # THINGS LOCAL AS REGARDS COUNTER ZONE CYCLES
				my (@tempv, @tempobs, @tempnode, @tempcomponent, @temploopcontrol, @tempflowcontrol); # THINGS LOCAL AS REGARDS COUNTER ZONE CYCLES
				my (@dov, @doobs, @donode, @docomponent, @doloopcontrol, @doflowcontrol); # THINGS LOCAL AS REGARDS COUNTER ZONE CYCLES
				
				my $generate  = $$general_variables[0];
				my $sequencer = $$general_variables[1];
				my $dffile = "df-$file.txt";	
				if ( eval $skip) { $skipask = "yes"; }
				
				if ( ( $countvar == 0 ) and ( $countblock == 1 ) and ( $countcase == 0 ) )
				{
					if ($exeonfiles eq "y") { `cp -r $mypath/$file $filenew`; }
					print TOSHELL "cp -r $mypath/$file $filenew\n\n";
				}

				@cases_to_sim = grep -d, <$mypath/models/$file*_>;

				foreach $case_to_sim (@cases_to_sim)
				{
					say OUTFILE "\nHERE 4 ";
				
					$counterstep = 1;
				
					while ( $counterstep <= $stepsvar )
					{
						my $from = "$case_to_sim";
						my $almost_to = $from;
						$almost_to =~ s/$varnumber-\d+/$varnumber-$counterstep/ ;
						
						if (     ( $generate eq "n" )
							 and ( ( $sequencer eq "y" ) or ( $sequencer eq "last" ) ) )
						{
							if ( $almost_to =~ m/§$/ ) { $to = "$almost_to" ; }
							else
							{
								#$to = "$case_to_sim$varnumber-$counterstep§";
								$to = "$almost_to" . "§";
							}
						} 
						elsif ( ( $generate eq "y" ) and ( $sequencer eq "n" ) )
						{
							if ( $almost_to =~ m/_$/ ) { $to = "$almost_to" ; }
							else
							{
								#$to = "$case_to_sim$varnumber-$counterstep" . "_";
								$to = "$almost_to" . "_";
								#if ( $counterstep == $stepsvar )
								#{
								#	if ($exeonfiles eq "y") { print `chmod -R 777 $from\n`; }
								#	print TOSHELL "chmod -R 777 $from\n\n";
								#}
							}
						} 
						elsif ( ( $generate eq "y" ) and ( $sequencer eq "y" ) )
						{
							#$to = "$case_to_sim$varnumber-$counterstep" . "£";
							$to = "$almost_to" . "£";
						} 
						elsif ( ( $generate eq "y" ) and ( $sequencer eq "last" ) )
						{
							if ( $almost_to =~ m/£$/ ) { $to = "$almost_to" ; }
							else
							{
								#$to = "$case_to_sim$varnumber-$counterstep" . "£";
								$to = "$almost_to" . "£";
								#if ( $counterstep == $stepsvar )
								#{
								#	if ($exeonfiles eq "y") { print `chmod -R 777 $from\n`; }
								#	print TOSHELL "chmod -R 777 $from\n\n";
								#}
							}
						} 
						elsif ( ( $generate eq "n" ) and ( $sequencer eq "n" ) )
						{
							 $almost_to =~ s/[_|£]$// ;
							#$to = "$case_to_sim$varnumber-$counterstep";
							$to = "$almost_to";
						}
						
						if ( ($countvar == $#varnumbers) and ( ($skip ne "")  and ($skipask ne "yes") ) )
						{
							$to =~ s/_$//;
							print MORPHFILE "$to\n";
						}
						
						# say OUTFILE "\nHERE AFTER ";
			
						{ # BLOCK
							if (     ( $generate eq "y" )
								 and ( $counterstep == $stepsvar )
								 and ( ( $sequencer eq "n" ) or ( $sequencer eq "last" ) ) 
							 	 and ( ($skip ne "")  and ($skipask ne "yes") )
							   )
							{
								unless (-e $to)
								{
									if ($exeonfiles eq "y") { `cp -R $from $to\n`; }
									print TOSHELL "cp -R $from $to\n\n";
									#if ($exeonfiles eq "y") { print `chmod -R 777 $to\n`; }
									#print TOSHELL "chmod -R 777 $to\n\n";
								}
							} 
							else
							{
								unless (-e $to)
								{
									
									if ($exeonfiles eq "y") { `cp -R $from $to\n`; }
									print TOSHELL "cp -R $from $to\n\n";
									#if ($exeonfiles eq "y") { print `chmod -R 777 $to\n`; }
									#print TOSHELL "chmod -R 777 $to\n\n";
								}
							}
						}
						
						push(@morphed, $to);
			
						$counterzone = 0;
						
						foreach my $zone (@applytype)
						{
							my $modification_type = $applytype[$counterzone][0];
							if ( ( $applytype[$counterzone][1] ne $applytype[$counterzone][2] )
								 and ( $modification_type ne "changeconfig" ) )
							{
								if ($exeonfiles eq "y") 
								{  
									`cp -f $to/zones/$applytype[$counterzone][1] $to/zones/$applytype[$counterzone][2]\n`; 
								}
								print TOSHELL 
								"cp -f $to/zones/$applytype[$counterzone][1] $to/zones/$applytype[$counterzone][2]\n\n";
								if ($exeonfiles eq "y") 
								{  
									`cp -f $to/cfg/$applytype[$counterzone][1] $to/cfg/$applytype[$counterzone][2]\n`; 
								}    # ORDINARILY, YOU MAY REMOVE THIS PART
								print TOSHELL
								"cp -f $to/cfg/$applytype[$counterzone][1] $to/cfg/$applytype[$counterzone][2]\n\n";
								# ORDINARILY, YOU MAY REMOVE THIS PART
							}
							if (
								 (
								   $applytype[$counterzone][1] ne $applytype[$counterzone][2]
								 )
								 and ( $modification_type eq "changeconfig" )
							  )
							{
								if ($exeonfiles eq "y") 
								{ 
									`cp -f $to/cfg/$applytype[$counterzone][1] $to/cfg/$applytype[$counterzone][2]\n`; 
								}
								print TOSHELL 
								"cp -f $to/cfg/$applytype[$counterzone][1] $to/cfg/$applytype[$counterzone][2]\n\n"; 
								# ORDINARILY, REMOVE THIS LINE
							}
							print CASELIST "$to\n";
												
							
							#########################################################################################
#########################################################################################
#########################################################################################

# HERE FOLLOWS THE CONTENT OF THE FILE "morph.pm", which has been merged here
# TO AVOID COMPLICATIONS WITH THE PERL MODULE INSTALLATION.

##############################################################################
sub translate
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $translate = shift;

	if ( $stepsvar > 1 )
	{
		my $yes_or_no_translation = "$$translate[$counterzone][0]";
		my $yes_or_no_translate_obstructions = "$$translate[$counterzone][1]";
		my $yes_or_no_update_radiation =  $$translate[$counterzone][3];
		my $configfile =  $$translate[$counterzone][4];
		if ( $yes_or_no_update_radiation eq "y" )
		{
			$yes_or_no_update_radiation = "a";
		} elsif ( $yes_or_no_update_radiation eq "n" )
		{
			$yes_or_no_update_radiation = "c";
		}
		if ( $yes_or_no_translation eq "y" )
		{
			my @coordinates_for_movement = @{ $$translate[$counterzone][2] };
			my $x_end = $coordinates_for_movement[0];
			my $y_end = $coordinates_for_movement[1];
			my $z_end = $coordinates_for_movement[2];
			my $x_swingtranslate = ( 2 * $x_end );
			my $y_swingtranslate = ( 2 * $y_end );
			my $z_swingtranslate = ( 2 * $z_end );
			my $x_pace = ( $x_swingtranslate / ( $stepsvar - 1 ) );
			my $x_movement = (- ( $x_end - ( $x_pace * ( $counterstep - 1 ) ) ));
			my $y_pace = ( $y_swingtranslate / ( $stepsvar - 1 ) );
			my $y_movement = (- ( $y_end - ( $y_pace * ( $counterstep - 1 ) ) ));
			my $z_pace = ( $z_swingtranslate / ( $stepsvar - 1 ) );
			my $z_movement = (- ( $z_end - ( $z_pace * ( $counterstep - 1 ) ) ));

			my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
i
e
$x_movement $y_movement $z_movement
y
$yes_or_no_translate_obstructions
-
y
c
-
-
-
-
-
-
-
-
-
YYY
";

			if ($exeonfiles eq "y") 
			{
				print `$printthis`;
			}
			print TOSHELL $printthis;
		}
	}
}    # end sub translate


my $countercycles_transl_surfs = 0;					
#############################################################################


#############################################################################				
sub translate_surfaces_simple # THIS IS VERSION 1, THE OLD ONE. DISMISSED? IN DOUBT, DO NOT USE IT. 
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $translate_surface_simple = shift;


	my $yes_or_no_transl_surfs =
	  $$translate_surface_simple[$counterzone][0];
	my @surfs_to_transl =
	  @{ $translate_surface_simple->[$counterzone][1] };
	my @ends_movs =
	  @{ $translate_surface_simple->[$counterzone][2]
	  };    # end points of the movements.
	my $yes_or_no_update_radiation =
	  $$translate_surface_simple[$counterzone][3];
	my $firstedge_constrainedarea = $$translate_surface_simple[$counterzone][4][0];
	my $secondedge_constrainedarea = $$translate_surface_simple[$counterzone][4][1];
	my $constrainedarea = ($firstedge_constrainedarea * $secondedge_constrainedarea);
	my @swings_surfs = map { $_ * 2 } @ends_movs;
	my @surfs_to_transl_constrainedarea =
	  @{ $translate_surface_simple->[$counterzone][5] };
	my $countersurface = 0;
	my $end_mov;
	my $mov_surf;
	my $pace;
	my $movement;
	my $surface_letter_constrainedarea;
	my $movement_constrainedarea;

	if ( $yes_or_no_transl_surfs eq "y" )
	{
		foreach my $surface_letter (@surfs_to_transl)
		{
			if ( $stepsvar > 1 )
			{
				$end_mov = $ends_movs[$countersurface];
				$swing_surf = $end_mov * 2;
				$pace = ( $swing_surf / ( $stepsvar - 1 ) );
				$movement =
				  ( - ( ($end_mov) -
					( $pace * ( $counterstep - 1 ) ) ) );
				$surface_letter_constrainedarea = $surfs_to_transl_constrainedarea[$countersurface];
				$movement_constrainedarea = 
				( ( ( $constrainedarea / ( $firstedge_constrainedarea + ( 2 * $movement ) ) ) - $secondedge_constrainedarea) /2);

				my $printthis = 
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
e
>
$surface_letter
a
$movement
y
-
-
y
c
-
-
-
-
-
-
-
-
YYY\n\n";
				if ($exeonfiles eq "y") 
				{ 
					print `$printthis`;
				}
				print TOSHELL $printthis;

				my $printthis = 
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
e
>
$surface_letter_constrainedarea
a
$movement_constrainedarea
y
-
-
y
c
-
-
-
-
-
-
-
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{ 
					print `$printthis`;
				}
				print TOSHELL $printthis;

				$countersurface++;
				$countercycles_transl_surfs++;
			}
		}
	}
}    # end sub translate_surfaces_simple								
######################################################################					


######################################################################
sub translate_surfaces
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $translate_surface = shift;

	my $yes_or_no_transl_surfs = $$translate_surface[$counterzone][0];
	my $transform_type = $$translate_surface[$counterzone][1];
	my @surfs_to_transl = @{ $translate_surface->[$counterzone][2] };
	my @ends_movs = @{ $translate_surface->[$counterzone][3] };    # end points of the movements.
	my $yes_or_no_update_radiation = $$translate_surface[$counterzone][4];
	my @transform_coordinates = @{ $translate_surface->[$counterzone][5] };
	my $countersurface = 0;
	my $end_mov;
	my $mov_surf;
	my $pace;
	my $movement;
	my $surface_letter_constrainedarea;
	my $movement_constrainedarea;

	if ( $yes_or_no_transl_surfs eq "y" )
	{
		foreach my $surface_letter (@surfs_to_transl)
			{
				if ( $stepsvar > 1 )
				{
					if ($transform_type eq "a")
					{
						$end_mov = $ends_movs[$countersurface];
						$swing_surf = $end_mov * 2;
						$pace = ( $swing_surf / ( $stepsvar - 1 ) );
						$movement = ( - ( ($end_mov) -( $pace * ( $counterstep - 1 ) ) ) );
						
						my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
e
>
$surface_letter
$transform_type
$movement
y
-
-
y
c
-
-
-
-
-
-
-
-
YYY
";

						if ($exeonfiles eq "y") { 
						print `$printthis`;
					}
					print TOSHELL $printthis;

					$countersurface++;
					$countercycles_transl_surfs++;
				}
				elsif ($transform_type eq "b")
				{
					my @coordinates_for_movement = 
					@{ $transform_coordinates[$countersurface] };
					my $x_end = $coordinates_for_movement[0];
					my $y_end = $coordinates_for_movement[1];
					my $z_end = $coordinates_for_movement[2];
					my $x_swingtranslate = ( 2 * $x_end );
					my $y_swingtranslate = ( 2 * $y_end );
					my $z_swingtranslate = ( 2 * $z_end );
					my $x_pace = ( $x_swingtranslate / ( $stepsvar - 1 ) );
					my $x_movement = (- ( $x_end - ( $x_pace * ( $counterstep - 1 ) ) ));
					my $y_pace = ( $y_swingtranslate / ( $stepsvar - 1 ) );
					my $y_movement = (- ( $y_end - ( $y_pace * ( $counterstep - 1 ) ) ));
					my $z_pace = ( $z_swingtranslate / ( $stepsvar - 1 ) );
					my $z_movement = (- ( $z_end - ( $z_pace * ( $counterstep - 1 ) ) ));

					my $printthis = 
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
e
>
$surface_letter
$transform_type
$x_movement $y_movement $z_movement
y
-
-
y
c
-
-
-
-
-
-
-
-
YYY
";

					if ($exeonfiles eq "y") 
					{ 
						print `$printthis`;
					}

					print TOSHELL $printthis;

					$countersurface++;
					$countercycles_transl_surfs++;
				}
			}
		}
	}								
}    # END SUB translate_surfaces
##############################################################################


##############################################################################
sub rotate_surface
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $rotate_surface = shift;

	my $yes_or_no_rotate_surfs =  $$rotate_surface[$counterzone][0];
	my @surfs_to_rotate =  @{ $rotate_surface->[$counterzone][1] };
	my @vertexes_numbers =  @{ $rotate_surface->[$counterzone][2] };   
	my @swingrotations = @{ $rotate_surface->[$counterzone][3] };
	my @yes_or_no_apply_to_others = @{ $rotate_surface->[$counterzone][4] };
	my $configfile = $$rotate_surface[$counterzone][5];

	if ( $yes_or_no_rotate_surfs eq "y" )
	{
		my $counterrotate = 0;
		foreach my $surface_letter (@surfs_to_rotate)
		{
			$swingrotate = $swingrotations[$counterrotate];
			$pacerotate = ( $swingrotate / ( $stepsvar - 1 ) );
			$rotation_degrees = 
			( ( $swingrotate / 2 ) - ( $pacerotate * ( $counterstep - 1 ) )) ;
			$vertex_number = $vertexes_numbers[$counterrotate];
			$yes_or_no_apply = $yes_or_no_apply_to_others[$counterrotate];
			if (  ( $swingrotate != 0 ) and ( $stepsvar > 1 )  and ( $yes_or_no_rotate_surfs eq "y" ) )
			{
				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
e
>
$surface_letter
c
$vertex_number
$rotation_degrees
$yes_or_no_apply
-
-
y
c
-
-
-
-
-
-
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{ 
					print `$printthis`;
				}

				print  TOSHELL $printthis;
			}
			$counterrotate++;
		}
	}
}    # END SUB rotate_surface
##############################################################################



##############################################################################
sub translate_vertexes #STILL UNFINISHED, NOT WORKING. PROBABLY ALMOST FINISHED. The reference to @base_coordinates is not working.
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap2 = shift;
	my @translate_vertexes = @$swap2;





	my @v;
	my @verts_to_transl = @{ $translate_vertexes[$counterzone][0] };
	my @transform_coordinates = @{ $translate_vertexes[$counterzone][1] };
	my @sourcefiles = @{ $translate_vertexes[$counterzone][2] };
	my @targetfiles = @{ $translate_vertexes[$counterzone][3] };
	my @configfiles = @{ $translate_vertexes[$counterzone][4] };
	my @longmenus = @{ $translate_vertexes[$counterzone][5] };
	$counteroperations = 0;
	foreach my $sourcefile ( @sourcefiles)
	{
		my $targetfile = $targetfiles[ $counteroperations ];
		my $configfile = $configfiles[ $counteroperations ];
		my $longmenu = $longmenus[ $counteroperations ];
		my $sourceaddress = "$mypath/$file$sourcefile";
		my $targetaddress = "$mypath/$file$targetfile";
		my $configaddress = "$to/opts/$configfile";
		checkfile($sourceaddress, $targetaddress);

		open( SOURCEFILE, $sourceaddress ) or die "Can't open $sourcefile 2: $!\n";
		my @lines = <SOURCEFILE>;
		close SOURCEFILE;
			
		my $counterlines = 0;
		my $countervert = 0;

		my @vertex_letters;
			if ($longmenu eq "y")
			{
				@vertex_letters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
				"n", "o", "p", "0\nb\nq", "0\nb\nr", "0\nb\ns", "0\nb\nt", "0\nb\nu", "0\nb\nv", 
				"0\nb\nw", "0\nb\nx", "0\nb\ny", "0\nb\nz", "0\nb\na", "0\nb\nb","0\nb\nc","0\nb\nd",
				"0\nb\ne","0\nb\n0\nb\nf","0\nb\n0\nb\ng","0\nb\n0\nb\nh","0\nb\n0\nb\ni",
				"0\nb\n0\nb\nj","0\nb\n0\nb\nk","0\nb\n0\nb\nl","0\nb\n0\nb\nm","0\nb\n0\nb\nn",
				"0\nb\n0\nb\no","0\nb\n0\nb\np","0\nb\n0\nb\nq","0\nb\n0\nb\nr","0\nb\n0\nb\ns",
				"0\nb\n0\nb\nt");
			}
			else
			{
				@vertex_letters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
				"n", "o", "p", "0\nq", "0\nr", "0\ns", "0\nt", "0\nu", "0\nv", "0\nw", "0\nx", 
				"0\ny", "0\nz", "0\na", "0\nb","0\n0\nc","0\n0\nd","0\n0\ne","0\n0\nf","0\n0\ng",
				"0\n0\nh","0\n0\ni","0\n0\nj","0\n0\nk","0\n0\nl","0\n0\nm","0\n0\nn","0\n0\no",
				"0\n0\np","0\n0\nq","0\n0\nr","0\n0\ns","0\n0\nt");
			}

			foreach my $line (@lines)
			{
				$line =~ s/^\s+//; 
				my @rowelements = split(/\s+|,/, $line);
				if   ($rowelements[0] eq "*vertex" ) 
				{
					if ($countervert == 0) 
					{
						push (@v, [ "vertexes of  $sourceaddress" ]);
						push (@v, [ $rowelements[1], $rowelements[2], $rowelements[3] ], $vertexletters[$countervert] );
					}

					if ($countervert > 0) 
					{
						push (@v, [ $rowelements[1], $rowelements[2], $rowelements[3], $vertexletters[$countervert] ] );
					}
					$countervert++;
				}
				$counterlines++;
			}

			if (-e $configaddress) 
			{				
				eval `cat $configaddress`; # HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS 
				# IS EVALUATED, AND HERE BELOW CONSTRAINTS ARE PROPAGATED.

			my $countervertex = 0;
							
			foreach my $vertex_letter (@vertex_letters)
			{
				if ($countervertex > 0)
				{
					if ($vertex_letter eq $v[$countervertex][3])
					{
						my @base_coordinates = @{ $transform_coordinates[$countervertex] };
						my $x_end = $base_coordinates[0];
						my $y_end = $base_coordinates[1];
						my $z_end = $base_coordinates[2];
						my $x_swingtranslate = ( 2 * $x_end );
						my $y_swingtranslate = ( 2 * $y_end );
						my $z_swingtranslate = ( 2 * $z_end );
						my $x_pace = ( $x_swingtranslate / ( $stepsvar - 1 ) );
						my $x_movement = (- ( $x_end - ( $x_pace * ( $counterstep - 1 ) ) ));
						my $y_pace = ( $y_swingtranslate / ( $stepsvar - 1 ) );
						my $y_movement = (- ( $y_end - ( $y_pace * ( $counterstep - 1 ) ) ));
						my $z_pace = ( $z_swingtranslate / ( $stepsvar - 1 ) );
						my $z_movement = (- ( $z_end - ( $z_pace * ( $counterstep - 1 ) ) ));
						my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
d
$vertex_letter
$x_movement $y_movement $z_movement
-
y
-
y
c
-
-
-
-
-
-
-
-
-
YYY
";
						if ($exeonfiles eq "y") 
						{ 
							print `$printthis`;
						}

						print TOSHELL $printthis;
					}
				}
				$countervertex++;
			}
		}
		$counteroperations++;
	}
} # END SUB translate_vertexes


##############################################################################
sub shift_vertexes
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $shift_vertexes = shift;


	my $pace;
	my $movement;
	my $yes_or_no_shift_vertexes = $$shift_vertexes[$counterzone][0];
	my $movementtype = $$shift_vertexes[$counterzone][1];
	my @pairs_of_vertexes = @{ $$shift_vertexes[$counterzone][2] };
	my @shift_swings = @{ $$shift_vertexes[$counterzone][3] };
	my $yes_or_no_radiation_update = $$shift_vertexes[$counterzone][4];
	my $configfile = $$shift_vertexes[$counterzone][5];

	if ( $stepsvar > 1 )
	{
		if ( $yes_or_no_shift_vertexes eq "y" )
		{

			my $counterthis = 0;
			if ($movementtype eq "j")
			{
			foreach my $shift_swing (@shift_swings)
				{
					$pace = ( $shift_swing / ( $stepsvar - 1 ) );
					$movement_or_vertex = 
					( ( ($shift_swing) / 2 ) - ( $pace * ( $counterstep - 1 ) ) );
					$vertex1 = $pairs_of_vertexes[ 0 + ( 2 * $counterthis ) ];
					$vertex2 = $pairs_of_vertexes[ 1 + ( 2 * $counterthis ) ];
					
					my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
d
^
$movementtype
$vertex1
$vertex2
-
$movement_or_vertex
y
-
y
-
y
-
-
-
-
-
-
-
-
YYY
";
					if ($exeonfiles eq "y") 
					{ 
						print `$printthis`;
					}
					print TOSHELL $printthis;

					$counterthis++;
				}
			}
			elsif ($movementtype eq "h")
			{
				foreach my $shift_swing (@shift_swings)
				{
					my $printthis = 
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
d
^
$movementtype
$vertex1
$vertex2
-
$movement_or_vertex
-
y
n
n
n
-
y
-
y
-
-
-
-
-
-
-
-
YYY
";
					if ($exeonfiles eq "y") 
					{ 
						print `$printthis`;
					}
					print TOSHELL $printthis;
				}
			}
		}
	}
}    # END SUB shift_vertexes


sub rotate    # generic zone rotation
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $rotate = shift; 


	my $rotation_degrees; 
	my $yes_or_no_rotation = "$$rotate[$counterzone][0]";
	my $yes_or_no_rotate_obstructions =
	  "$$rotate[$counterzone][1]";
	my $swingrotate = $$rotate[$counterzone][2];
	my $yes_or_no_update_radiation =
	  $$rotate[$counterzone][3];
	my $base_vertex = $$rotate[$counterzone][4];
	my $configfile = $$rotate[$counterzone][5];						  
	my $pacerotate; 
	my $counter_rotate = 0;
	if (     ( $swingrotate != 0 )
		 and ( $stepsvar > 1 )
		 and ( $yes_or_no_rotation eq "y" ) )
	{
		$pacerotate = ( $swingrotate / ( $stepsvar - 1 ) );
		$rotation_degrees =
		  ( ( $swingrotate / 2 ) -
			 ( $pacerotate * ( $counterstep - 1 ) ) );

		my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY


m
c
a
$zone_letter
i
b
$rotation_degrees
$base_vertex
-
$yes_or_no_rotate_obstructions
-
y
c
-
y
-
-
-
-
-
-
-
-
YYY
";
		if ($exeonfiles eq "y") 
		{ 
			print `$printthis`;
		}
		print TOSHELL $printthis;
	}
}    # END SUB rotate
##############################################################################


##############################################################################
sub rotatez # PUT THE ROTATION POINT AT POINT 0, 0, 0. I HAVE NOT YET MADE THE FUNCTION GENERIC ENOUGH.
{	
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $rotatez = shift;


	my $yes_or_no_rotation = "$$rotatez[0]";
	my @centerpoints = @{$$rotatez[1]};
	my $centerpointsx = $centerpoints[0];
	my $centerpointsy = $centerpoints[1];
	my $centerpointsz = $centerpoints[2];
	my $plane_of_rotation = "$$rotatez[2]";
 	my $infile = "$to/zones/$applytype[$counterzone][2]";
	my $infile2 = "$to/cfg/$applytype[$counterzone][2]";
	my $outfile = "erase";
	my $outfile2 = "$to/zones/$applytype[$counterzone][2]eraseobtained";
	open(INFILE,  "$infile")   or die "Can't open infile $infile: $!\n";
	open(OUTFILE2, ">>$outfile2") or die "Can't open outfile2 $outfile2: $!\n";
	my @lines = <INFILE>;
	close(INFILE);
	my $counterline = 0;
	my $countercases=0;
	my @vertexes;
	my $swingrotate = $$rotatez[3];
	my $alreadyrotation = $$rotatez[4];
	my $rotatexy = $$rotatez[5];
	my $swingrotatexy = $$rotatez[6];
	my $pacerotate;
	my $counter_rotate = 0;
	my $linenew;
	my $linenew2;
	my @rowprovv;
	my @rowprovv2;
	my @row;
	my @row2;
	if ( $stepsvar > 1 and ( $yes_or_no_rotation eq "y" ) )
	{
		foreach $line (@lines) 
		{#
			{
				$linenew = $line;
				$linenew =~ s/\:\s/\:/g ;
				@rowprovv = split(/\s+/, $linenew);
				$rowprovv[0] =~ s/\:\,/\:/g ;
				@row = split(/\,/, $rowprovv[0]);
				if ($row[0] eq "*vertex") 
				{ push (@vertexes, [$row[1], $row[2], $row[3]] ) }
			}
			$counterline = $counterline +1;
		}

		foreach $vertex (@vertexes)
		{
			print OUTFILE "vanilla ${$vertex}[0], ${$vertex}[1], ${$vertex}[2]\n";
		}
		foreach $vertex (@vertexes)
		{
			${$vertex}[0] = (${$vertex}[0] - $centerpointsx); 
			${$vertex}[0] = sprintf("%.5f", ${$vertex}[0]);
			${$vertex}[1] = (${$vertex}[1] - $centerpointsy); 
			${$vertex}[1] = sprintf("%.5f", ${$vertex}[1]);
			${$vertex}[2] = (${$vertex}[2] - $centerpointsz); 
			${$vertex}[2] = sprintf("%.5f", ${$vertex}[2]);
			print OUTFILE "aftersum ${$vertex}[0], ${$vertex}[1], ${$vertex}[2]\n";
		}

		my $anglealready = deg2rad(-$alreadyrotation);
		foreach $vertex (@vertexes)
		{
			my $x_new = cos($anglealready)*${$vertex}[0] - sin($anglealready)*${$vertex}[1]; 
			my $y_new = sin($anglealready)*${$vertex}[0] + cos($anglealready)*${$vertex}[1];
			${$vertex}[0] = $x_new; ${$vertex}[0] = sprintf("%.5f", ${$vertex}[0]);
			${$vertex}[1] = $y_new; ${$vertex}[1] = sprintf("%.5f", ${$vertex}[1]);
			print OUTFILE "afterfirstrotation ${$vertex}[0], ${$vertex}[1], ${$vertex}[2]\n";
		}

		$pacerotate = ( $swingrotate / ( $stepsvar - 1) );
		$rotation_degrees = - ( ($swingrotate / 2) - ($pacerotate * ($counterstep -1) ) );
		my $angle = deg2rad($rotation_degrees);
		foreach $vertex (@vertexes)
		{
			my $y_new = cos($angle)*${$vertex}[1] - sin($angle)*${$vertex}[2]; 
			my $z_new = sin($angle)*${$vertex}[1] + cos($angle)*${$vertex}[2];
			${$vertex}[1] = $y_new; ${$vertex}[1] = sprintf("%.5f", ${$vertex}[1]);
			${$vertex}[2] = $z_new; ${$vertex}[2] = sprintf("%.5f", ${$vertex}[2]);
			${$vertex}[0] = sprintf("%.5f", ${$vertex}[0]);
			print OUTFILE "aftersincos ${$vertex}[0], ${$vertex}[1], ${$vertex}[2]\n";
		}

		my $angleback = deg2rad($alreadyrotation);
		foreach $vertex (@vertexes)
			{
			my $x_new = cos($angleback)*${$vertex}[0] - sin($angleback)*${$vertex}[1]; 
			my $y_new = sin($angleback)*${$vertex}[0] + cos($angleback)*${$vertex}[1];
			${$vertex}[0] = $x_new; ${$vertex}[0] = sprintf("%.5f", ${$vertex}[0]);
			${$vertex}[1] = $y_new; ${$vertex}[1] = sprintf("%.5f", ${$vertex}[1]);
			print OUTFILE "afterrotationback ${$vertex}[0], ${$vertex}[1], ${$vertex}[2]\n";ctl type
		}

		foreach $vertex (@vertexes)
		{
			${$vertex}[0] = ${$vertex}[0] + $centerpointsx; ${$vertex}[0] = sprintf("%.5f", ${$vertex}[0]);
			${$vertex}[1] = ${$vertex}[1] + $centerpointsy; ${$vertex}[1] = sprintf("%.5f", ${$vertex}[1]);
			${$vertex}[2] = ${$vertex}[2] + $centerpointsz; ${$vertex}[2] = sprintf("%.5f", ${$vertex}[2]);
			print OUTFILE "after final substraction ${$vertex}[0], ${$vertex}[1], ${$vertex}[2]\n";
		}

		my $counterwrite = -1;
		my $counterwriteand1;
		foreach $line (@lines) 
		{#	

				$linenew2 = $line;
				$linenew2 =~ s/\:\s/\:/g ;
				my @rowprovv2 = split(/\s+/, $linenew2);
				$rowprovv2[0] =~ s/\:\,/\:/g ;
				@row2 = split(/\,/, $rowprovv2[0]);
				$counterwriteright = ($counterwrite - 5);
				$counterwriteand1 = ($counterwrite + 1);			
				if ($row2[0] eq "*vertex")		
				{
					if ( $counterwrite == - 1) { $counterwrite = 0 }	
					print OUTFILE2 
					"*vertex"."\,"."${$vertexes[$counterwrite]}[0]"."\,"."${$vertexes[$counterwrite]}[1]"."\,"."${$vertexes[$counterwrite]}[2]"."  #   "."$counterwriteand1\n";
				}
				else 
				{
					print OUTFILE2 "$line";
				}
				if ( $counterwrite > ( - 1 ) ) { $counterwrite++; }
		}

		close(OUTFILE);
		if ($exeonfiles eq "y") { print `chmod 777 $infile`; }
		print TOSHELL "chmod -R 777 $infile\n";
		if ($exeonfiles eq "y") { print `chmod 777 $infile2`; }
		print TOSHELL "chmod -R 777 $infile2\n";
		if ($exeonfiles eq "y") { print `rm $infile`; }
		print TOSHELL "rm $infile\n";
		if ($exeonfiles eq "y") { print `chmod 777 $outfile2`; }
		print TOSHELL "chmod 777 $outfile2\n";
		if ($exeonfiles eq "y") { print `cp $outfile2 $infile`; }
		print TOSHELL "cp $outfile2 $infile\n";
		if ($exeonfiles eq "y") { print `cp $outfile2 $infile2`; }
		print TOSHELL "cp $outfile2 $infile2\n";
	}
} # END SUB rotatez
##############################################################################


##############################################################################
sub make_generic_change # WITH THIS FUNCTION YOU TARGET PORTIONS OF A FILE AND YOU CHANGE THEM.
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap2 = shift;
	my @generic_change = @$swap2;


	my $infile = "$to/zones/$applytype[$counterzone][2]";
	my $outfile = "$to/zones/$applytype[$counterzone][2]provv";
	open( INFILE, "$infile" ) or die "Can't open $infile 2: $!\n";
	open( OUTFILE, ">$outfile" ) or die "Can't open $outfile: $!\n";
	my @lines = <INFILE>;
	close(INFILE);
	my $counterline  = 0;
	my $countercases = 0;

	foreach $line (@lines)
	{    #
		$linetochange = ( $generic_change[$counterzone][$countercases][1] );
		if ( $counterline == ( $linetochange - 1 ) )
		{    #
			$linetochange = ( $generic_change[$counterzone][$counter_conditions][$countercases][1] );
			$cases = $#{ generic_change->[$counterzone][$counter_conditions] };
			$swing1 = $generic_change[$counterzone][$countercases][2][2];
			$swing2 = $generic_change[$counterzone][$countercases][3][2];
			$swing3 = $generic_change[$counterzone][$countercases][4][2];
			if (     ( $stepsvar > 1 )
				 and ( $tiepacestofirst eq "n" ) )
			{
				$pace1 = ( $swing1 / ( $stepsvar - 1 ) );
				$pace2 = ( $swing2 / ( $stepsvar - 1 ) );
				$pace3 = ( $swing3 / ( $stepsvar - 1 ) );
			} elsif (     ( $stepsvar > 1 )
					  and ( $tiepacestofirst eq "y" ) )
			{
				$pace1 = ( $swing1 / ( $stepsvar - 1 ) );
				$pace2 = ( $swing2 / ( $stepsvar - 1 ) );
				$pace3 = ( $swing3 / ( $stepsvar - 1 ) );
			} elsif ( $stepsvar == 1 )
			{
				$pace1 = 0;
				$pace2 = 0;
				$pace3 = 0;
			}
			$digits1 = $generic_change[$counterzone][$countercases][2][3];
			$digits2 = $generic_change[$counterzone][$countercases][3][3];
			$digits3 = $generic_change[$counterzone][$countercases][4][3];
			$begin_read_column1 = $generic_change[$counterzone][$countercases][2][0] - 1;
			$begin_read_column2 = $generic_change[$counterzone][$countercases][3][0] - 1;
			$begin_read_column3 = $generic_change[$counterzone][$countercases][4][0] - 1;
			$length_read_string1 = $generic_change[$counterzone][$countercases][2][1] + 1;
			$length_read_string2 = $generic_change[$counterzone][$countercases][3][1] + 1;
			$length_read_string3 = $generic_change[$counterzone][$countercases][4][1] + 1;
			########## COMPLETE HERE ->
			$numbertype = "f";    #floating
			$to_substitute1 =
			  substr( $line, $begin_read_column1, $length_read_string1 );
			$substitute_provv1 = ( $to_substitute1 - ( $swing1 / 2 ) + ( $pace1 * $counterstep ) );
			$substitute1 = sprintf( "%.$digits1$numbertype", $substitute_provv1 );
			$to_substitute2 = substr( $line, $begin_read_column2, $length_read_string2 );
			$substitute_provv2 = ( $to_substitute2 - ( $swing2 / 2 ) + ( $pace2 * $counterstep ) );
			$substitute2 = sprintf( "%.$digits2$numbertype", $substitute_provv2 );
			$to_substitute3 = substr( $line, $begin_read_column3, $length_read_string3 );
			$substitute_provv3 = ( $to_substitute3 - ( $swing3 / 2 ) + ( $pace3 * $counterstep ) );
			$substitute3 = sprintf( "%.$digits3$numbertype", $substitute_provv3 );

			if ( $substitute1 >= 0 )
			{
				$begin_write_column1 = $generic_change[$counterzone][$countercases][2][0];
				$length_write_string1 = $generic_change[$counterzone][$countercases][2][1];
			} else
			{
				$begin_write_column1 = $generic_change[$counterzone][$countercases][2][0] - 1;
				$length_write_string1 = $generic_change[$counterzone][$countercases][2][1] + 1;
			}
			if ( $substitute2 >= 0 )
			{
				$begin_write_column2 = $generic_change[$counterzone][$countercases][3][0];
				$length_write_string2 = $generic_change[$counterzone][$countercases][3][1];
			} else
			{
				$begin_write_column2 =$generic_change[$counterzone][$countercases][3][0] - 1;
				$length_write_string2 = $generic_change[$counterzone][$countercases][3][1] + 1;
			}
			if ( $substitute3 >= 0 )
			{
				$begin_write_column3 = $generic_change[$counterzone][$countercases][4][0];
				$length_write_string3 = $generic_change[$counterzone][$countercases][4][1];
			} else
			{
				$begin_write_column3 = $generic_change[$counterzone][$countercases][4][0] - 1;
				$length_write_string3 = $generic_change[$counterzone][$countercases][4][1] + 1;
			}
			substr( $line, $begin_write_column1, $length_write_string1, $substitute1 );
			substr( $line, $begin_write_column2, $length_write_string2, $substitute2 );
			substr( $line, $begin_write_column3, $length_write_string3, $substitute3 );
			print OUTFILE "$line";
			$countercases = $countercases + 1;
		} else
		{
			print OUTFILE "$line";
		}
		$counterline = $counterline + 1;
	}
	close(OUTFILE);
	if ($exeonfiles eq "y") { print `chmod -R 755 $infile`; }
	print TOSHELL "chmod -R 755 $infile\n";
	if ($exeonfiles eq "y") { print `chmod -R 755 $outfile`; }
	print TOSHELL
	  "chmod -R 755 $outfile\n";
	if ($exeonfiles eq "y") { print `cp -f $outfile $infile`; }
	print TOSHELL
	  "cp -f $outfile $infile\n";
}    # END SUB generic_change
##############################################################################


##############################################################################
sub reassign_construction
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $construction_reassignment = shift;


	my $yes_or_no_reassign_construction = $$construction_reassignment[$counterzone][0];
	if ( $yes_or_no_reassign_construction eq "y" )
	{
		my @surfaces_to_reassign =
		  @{ $construction_reassignment->[$counterzone][1]
		  };
		my @constructions_to_choose =
		  @{ $construction_reassignment->[$counterzone][2] };
		my $configfile = $$construction_reassignment[$counterzone][3];
		my $surface_letter;
		my $counter = 0;
		my @reassign_constructions;

		foreach $surface_to_reassign (@surfaces_to_reassign)
		{
			$construction_to_choose =  $constructions_to_choose[$counter][$counterstep];
			
			my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
f
$surface_to_reassign
e
n
y
$construction_to_choose
-
-
-
-
y
y
-
-
-
-
-
-
-
-
YYY
";
			if ($exeonfiles eq "y") 
			{ 
				print `$printthis`;
			}

			print TOSHELL $printthis;
			$counter++;
		}
	}
}    # END SUB reassign_construction
##############################################################################


##############################################################################					
sub change_thickness
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $thickness_change = shift;


	my $yes_or_no_change_thickness = $$thickness_change[$counterzone][0];
	my @entries_to_change = @{ $$thickness_change[$counterzone][1] };
	my @groups_of_strata_to_change = @{ $$thickness_change[$counterzone][2] };
	my @groups_of_couples_of_min_max_values = @{ $$thickness_change[$counterzone][3] };
	my $configfile = $$thickness_change[$counterzone][4];
	my $thiscounter = 0;
	my $entry_to_change;
	my $counterstrata;
	my @strata_to_change;
	my $stratum_to_change;
	my @min_max_values;
	my $min;
	my $max;
	my $change_stratum;
	my @change_strata;
	my $enter_change_entry;
	my @change_entries;
	my $swing;
	my $pace;
	my $thickness;
	my @change_entries_with_thicknesses;

	if ( $stepsvar > 1 )
	{
		foreach $entry_to_change (@entries_to_change)
		{
			@strata_to_change =
			  @{ $groups_of_strata_to_change[$thiscounter]
			  };
			$counterstrata = 0;
			foreach $stratum_to_change (@strata_to_change)
			{
				@min_max_values =
				  @{ $groups_of_couples_of_min_max_values[$thiscounter][$counterstrata] };
				$min   = $min_max_values[0];
				$max   = $min_max_values[1];
				$swing = $max - $min;
				$pace  = ( $swing / ( $stepsvar - 1 ) );
				$thickness = $min + ( $pace * ( $counterstep - 1 ) );

				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY
b
e
a
$entry_to_change
$stratum_to_change
n
$thickness
-
-
y
y
-
y
y
-
-
-
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{ 
					print `$printthis`;
				}
				print TOSHELL $printthis;
				$counterstrata++;
			}
			$thiscounter++;
		}
		$" = " ";
		if ($exeonfiles eq "y") { print `$enter_esp$go_to_construction_database@change_entries_with_thicknesses$exit_construction_database_and_esp`; }
		print TOSHELL "$enter_esp$go_to_construction_database@change_entries_with_thicknesses$exit_construction_database_and_esp\n";
	}
} # END sub change_thickness
##############################################################################		


##############################################################################					
sub obs_modify
{
	if ( $stepsvar > 1 )
	{
		my $to = shift;
		my $fileconfig = shift;
		my $stepsvar = shift;
		my $counterzone = shift;
		my $counterstep = shift;
		my $exeonfiles = shift;
		my $swap = shift;
		my @applytype = @$swap;
		my $zone_letter = $applytype[$counterzone][3];
		my $obs_modify = shift;


		my @obs_letters = @{ $$obs_modify[$counterzone][0] };
		my $modification_type = $$obs_modify[$counterzone][1];
		my @values = @{ $$obs_modify[$counterzone][2] };
		my @base = @{ $$obs_modify[$counterzone][3] };
		my $configfile = $$obs_modify[$counterzone][4];
		my $xz_resolution = $$obs_modify[$counterzone][5];
		my $countobs = 0;							  
		my $x_end;
		my $y_end;
		my $z_end;
		my $x_base;
		my $y_base;
		my $z_base;
		my $end_value;
		my $base_value;
		my $x_swingtranslate;
		my $y_swingtranslate;
		my $z_swingtranslate;
		my $x_pace;
		my $x_value;
		my $y_pace;
		my $y_value;
		my $z_pace;
		my $z_value;
		if ( ($modification_type eq "a") or ($modification_type eq "b"))
		{      							  
			$x_end = $values[0];
			$y_end = $values[1];
			$z_end = $values[2];
			$x_base = $base[0];
			$y_base = $base[1];
			$z_base = $base[2];
			$x_swingtranslate = ( 2 * $x_end );
			$y_swingtranslate = ( 2 * $y_end );
			$z_swingtranslate = ( 2 * $z_end );
			$x_pace = ( $x_swingtranslate / ( $stepsvar - 1 ) );
			$x_value = ($x_base + ( $x_end - ( $x_pace * ( $counterstep - 1 ) ) ));
			$y_pace = ( $y_swingtranslate / ( $stepsvar - 1 ) );
			$y_value = ($y_base + ( $y_end - ( $y_pace * ( $counterstep - 1 ) ) ));
			$z_pace = ( $z_swingtranslate / ( $stepsvar - 1 ) );
			$z_value = ($z_base + ( $z_end - ( $z_pace * ( $counterstep - 1 ) ) ));

			my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
h
a
$obs_letter
$modification_type
a
$x_value $y_value $z_value
-
-
c
-
c
-
-
-
-
-
-
-
-
YYY
";
			foreach my $obs_letter (@obs_letters)
			{
				if ($exeonfiles eq "y") 
				{ 
					print `$printthis`;
				}
				print TOSHELL $printthis;
				$countobs++;
				}
			}

			if ( ($modification_type eq "c") or ($modification_type eq "d"))
			{      							  
				$x_end = $values[0];
				$x_base = $base[0];
				$x_swingtranslate = ( 2 * $x_end );
				$x_pace = ( $x_swingtranslate / ( $stepsvar - 1 ) );
				$x_value = ($x_base + ( $x_end - ( $x_pace * ( $counterstep - 1 ) ) ));

				foreach my $obs_letter (@obs_letters)
				{
					my $printthis = 
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
h
a
$obs_letter
$modification_type
$x_value
-
-
c
-
c
-
-
-
-
-
-
-
-
YYY
";
					if ($exeonfiles eq "y") 
					{ 
						print `$printthis`;
					}
					print TOSHELL $printthis;
					$countobs++;
				}
			}

			if ($modification_type eq "g")
			{      							  
				foreach my $obs_letter (@obs_letters)
				{
					my $count = 0;
					foreach my $x_value (@values)
					{
						if ($count < $stepsvar)
						{
							my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
h
a
$obs_letter
$modification_type
$x_value
-
-
-
-
-
-
-
-
-
-
-
-
-
-
YYY
";
							if ($exeonfiles eq "y") 
							{ 
								print `$printthis`;
							}
							print TOSHELL $printthis;
						$countobs++;
						$count++;
					}
				}
			}
		}

		if ($modification_type eq "h")
		{      							  
			$x_end = $values[0];
			$x_base = $base[0];
			$x_swingtranslate = (  $x_base - $x_end );
			$x_pace = ( $x_swingtranslate / ( $stepsvar - 1 ) );
			$x_value = ($x_base - ( $x_pace * ( $counterstep - 1 ) ));

			foreach my $obs_letter (@obs_letters)
			{
				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
h
a
$obs_letter
$modification_type
$x_value
-
-
-
-
-
-
-
-
-
-
-
-
-
-
YYY
";
				if ($exeonfiles eq "y")
				{ 
					print `$printthis`;
				}
				print TOSHELL $printthis;
				$countobs++;
			}
		}

		if ($modification_type eq "t")
		{      							  
			my $modification_type = "~";
			my $what_todo = $base[0];
			$x_end = $values[0];
			$y_end = $values[1];
			$z_end = $values[2];
			$x_swingtranslate = ( 2 * $x_end );
			$y_swingtranslate = ( 2 * $y_end );
			$z_swingtranslate = ( 2 * $z_end );
			$x_pace = ( $x_swingtranslate / ( $stepsvar - 1 ) );
			$x_value = ( $x_end - ( $x_pace * ( $counterstep - 1 ) ) );
			$y_pace = ( $y_swingtranslate / ( $stepsvar - 1 ) );
			$y_value = ( $y_end - ( $y_pace * ( $counterstep - 1 ) ) );
			$z_pace = ( $z_swingtranslate / ( $stepsvar - 1 ) );
			$z_value = ( $z_end - ( $z_pace * ( $counterstep - 1 ) ) );

			foreach my $obs_letter (@obs_letters)
			{
				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
h
a
$modification_type
$what_todo
$obs_letter
-
$x_value $y_value $z_value
-
c
-
c
-
-
-
-
-
-
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{ 
					print `$printthis`;
				}
				print TOSHELL $printthis;
				$countobs++;
				}
			}

			#NOW THE XZ GRID RESOLUTION WILL BE PUT TO THE SPECIFIED VALUE				 						
			my $printthis = #THIS IS WHAT HAPPEN INSIDE SUB KEEP_SOME_OBSTRUCTIONS
"prj -file $to/cfg/$fileconfig -mode script<<YYY


m
c
a
$zone_letter
h
a
a
$xz_resolution
-
c
-
c
-
-
-
-
-
-
-
YYY
";
			if ($exeonfiles eq "y") 
			{ 
				print `$printthis`;
			}
			print TOSHELL $printthis;
	}
}    # END SUB obs_modify. FIX THE INDENTATION.
##############################################################################


##############################################################################
sub bring_obstructions_back # TO BE REWRITTEN BETTER
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $keep_obstructions = shift;


	my $yes_or_no_keep_some_obstructions = $$keep_obstructions[$counterzone][0];
	my $yes_or_no_update_radiation_provv = $$keep_obstructions[$counterzone][2];
	my $yes_or_no_update_radiation;
	my $configfile = $$keep_obstructions[$counterzone][3];
	my $xz_resolution = $$keep_obstructions[$counterzone][4];
	if ( $yes_or_no_update_radiation_provv eq "y" )
	{
		$yes_or_no_update_radiation = "a";
	} else
	{
		$yes_or_no_update_radiation = "c";
	}
	if ( $yes_or_no_keep_some_obstructions eq "y" )
	{
		my @group_of_obstructions_to_keep = @{ $$keep_obstructions[$counterzone][1] };
		my $keep_obs_counter = 0;
		my @obstruction_to_keep;
		foreach (@group_of_obstructions_to_keep)
		{
			@obstruction_to_keep =
			  @{ $group_of_obstructions_to_keep[$keep_obs_counter] };
			my $obstruction_letter =
			  "$obstruction_to_keep[0]";
			my $rotation_z = "$obstruction_to_keep[1]";
			my $rotation_y = "$obstruction_to_keep[2]"; # NOT YET IMPLEMENTED 
			my $x_origin   = "$obstruction_to_keep[3]";
			my $y_origin   = "$obstruction_to_keep[4]";
			my $z_origin   = "$obstruction_to_keep[5]";
			# $rotation_degrees used here is absolute, not local. 
			# This is dangerous and it has to change.

			my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY


m
c
a
$zone_letter
h
a
$obstruction_letter
a
a
$x_origin $y_origin $z_origin
c
$rotation_z
-
-
c
-
c
-
-
-
-
-
-
-
YYY
";
			if ($exeonfiles eq "y") 
			{ 
				print `$printthis`;
			}
			print TOSHELL $printthis;
			$keep_obs_counter++;
		}

		# NOW THE XZ GRID RESOLUTION WILL BE PUT TO THE SPECIFIED VALUE	
		my $printthis =
"
";			 
		if ($exeonfiles eq "y") 
		{ 
			print `$printthis`;
		}
		print TOSHELL $printthis;
	}
}    # END SUB bring_obstructions_back
##################################################################					


##################################################################
sub recalculateish
{ 
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;


	my $zone_letter = $applytype[$counterzone][3];

	my $printthis =
"
";
	if ($exeonfiles eq "y") 
	{ 
		print `$printthis`;
	}

	print TOSHELL $printthis;
} #END SUB RECALCULATEISH
##############################################################################				



##############################################################################										
sub daylightcalc # IT WORKS ONLY IF THE RAD DIRECTORY IS EMPTY
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $filedf = shift;
	my $swap = shift;
	my @daylightcalc = @$swap;


	my $yes_or_no_daylightcalc = $daylightcalc[0];
	my $zone = $daylightcalc[1];
	my $surface = $daylightcalc[2];
	my $where = $daylightcalc[3];
	my $edge = $daylightcalc[4];
	my $distance = $daylightcalc[5];
	my $density = $daylightcalc[6];
	my $accuracy = $daylightcalc[7];
	my $filedf = $daylightcalc[8];
	my $pathdf = "$to/rad/$filedf";

	my $printthis =
"
cd $to/cfg/
e2r -file $to/cfg/$fileconfig -mode script<<YYY

a

a
d
$zone
-
$surface
$distance
$where
$edge
-
$density
y
$accuracy
a
-
-
-
-
-
YYY
\n\n
cd $mypath
";
	if ($exeonfiles eq "y") 
	{ 
		print `$printthis`;
	}

	print TOSHELL $printthis;

	open( RADFILE, $pathdf) or die "Can't open $pathdf: $!\n";
	my @linesrad = <RADFILE>;
	close RADFILE;											
	my @dfs;
	my $dfaverage;
	my $sum = 0;
	foreach my $linerad (@linesrad)
	{
		$linerad =~ s/^\s+//; 
		my @rowelements = split(/\s+|,/, $linerad);
		push (@dfs, $rowelements[-1]);
	}
	foreach my $df (@dfs)
	{
		$sum = ($sum + $df);
	}
	$dfaverage = ( $sum / scalar(@dfs) );

	open( DFFILE,  ">>$dffile" )   or die "Can't open $dffile: $!";
	print DFFILE "$dfaverage\n";
	close DFFILE;

} # END SUB dayligjtcalc 
##############################################################################


##############################################################################	
sub daylightcalc_other # NOT USED. THE DIFFERENCE WITH THE ABOVE IS THAT IS WORKS IF THE RAD DIRECTORY IS NOT EMPTY. 
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $filedf = shift;
	my $swap = shift;
	my @daylightcalc = @$swap;


	my $yes_or_no_daylightcalc = $daylightcalc[0];
	my $zone = $daylightcalc[1];
	my $surface = $daylightcalc[2];
	my $where = $daylightcalc[3];
	my $edge = $daylightcalc[4];
	my $distance = $daylightcalc[5];
	my $density = $daylightcalc[6];
	my $accuracy = $daylightcalc[7];
	my $filedf = $daylightcalc[8];
	my $pathdf = "$to/rad/$filedf";
	
	my $printthis =
"
cd $to/cfg/
e2r -file $to/cfg/$fileconfig -mode script<<YYY
a

d

g
-
e
d



y
-
g
y
$zone
-
$surface
$distance
$where
$edge
-
$density

i
$accuracy
y
a
a
-
-
YYY
\n\n
cd $mypath
";	
	if ($exeonfiles eq "y") 
	{ 
		print `$printthis`;
	}

	print TOSHELL $printthis;

	open( RADFILE, $pathdf) or die "Can't open $pathdf: $!\n";
	my @linesrad = <RADFILE>;
	close RADFILE;											
	my @dfs;
	my $dfaverage;
	my $sum = 0;
	foreach my $linerad (@linesrad)
	{
		$linerad =~ s/^\s+//; 
		my @rowelements = split(/\s+|,/, $linerad);
		push (@dfs, $rowelements[-1]);
	}
	foreach my $df (@dfs)
	{
		$sum = ($sum + $df);
	}
	$dfaverage = ( $sum / scalar(@dfs) );

	open( DFFILE,  ">>$dffile" )   or die "Can't open $dffile: $!";
	print DFFILE "$dfaverage\n";
	close DFFILE;

} # END SUB daylightcalc 
##############################################################################


sub change_config
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap2 = shift;
	my @change_config = @$swap2;


	my @change_conf = @{$change_config[$countezone]};
	my @original_configfiles = @{$change_conf[0]};
	my @new_configfiles = @{$change_conf[1]};
	my $counterconfig = 0;
	my $original_configfile = $original_configfiles[$counterstep-1];
	my $new_configfile = $new_configfiles[$counterstep-1];
	if (  $new_configfile ne $original_configfile )
	{
		if ($exeonfiles eq "y") { `cp -f $to/$new_configfile $to/$original_configfile\n`; }
		print TOSHELL "cp -f $to/$new_configfile $to/$original_configfile\n";
	}
$counterconfig++;
} # END SUB copy_config


sub checkfile # THIS FUNCTION DOES WHAT IS DONE BY THE PREVIOUS ONE, BUT BETTER.
{
	# THIS CHECKS IF A SOURCE FILE MUST BE SUBSTITUTED BY ANOTHER ONE BEFORE THE TRANSFORMATIONS BEGIN.
	# IT HAS TO BE CALLED WITH: checkfile($sourceaddress, $targetaddress);
	my $sourceaddress = shift;
	my $targetaddress = shift;


	unless ( ($sourceaddress eq "" ) or ( $targetaddress eq "" ))
	{
		print OUTFILE "TARGETFILE IN FUNCTION: $targetaddress\n";
		if ( $sourceaddress ne $targetaddress )
		{
			if ($exeonfiles eq "y") 
			{ 
				print 
				`cp -f $sourceaddress $targetaddress\n`; 
			}
			print TOSHELL 
			"cp -f $sourceaddress $targetaddress\n\n";
		}
	}
} # END SUB checkfile	


sub change_climate ### THIS SIMPLE SCRIPT HAS TO BE DEBUGGED. WHY DOES IT BLOCK ITSELF IF PRINTED TO THE SHELL?
{	# THIS FUNCTION CHANGES THE CLIMATE FILES. 
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap = shift;
	my @change_climate = @$swap;


	my @climates = @{$change_climate[$counterzone]};
	my $climate = $climates[$counterstep-1];

	my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<ZZZ

b
a
b
$climate
a
-
-
y
n
-
-
ZZZ
\n
";
	if ($exeonfiles eq "y")
	{
		print `$printthis`;
	}
	print TOSHELL $printthis;
}	


##############################################################################	
# THIS FUNCTION HAS BEEN OUTDATED BY THOSE FOR CONSTRAINING THE NETS, BELOW				
sub recalculatenet
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap2 = shift;
	my @recalculatenet = @$swap2;


	my $filenet = $recalculatenet[1];
	my $infilenet = "$mypath/$file/nets/$filenet";
	my @nodezone_data = @{$recalculatenet[2]};
	my @nodesdata = @{$recalculatenet[3]};
	my $geosourcefile = $recalculatenet[4];
	my $configfile = $recalculatenet[5];
	my $y_or_n_reassign_cp = $recalculatenet[6];
	my $y_or_n_detect_obs = $recalculatenet[7];
	my @crackwidths = @{$recalculatenet[9]};

	my @obstaclesdata;
	my $counterlines = 0;
	my $counternode = 0;
	my @differences;
	my @ratios;
	my $sourceaddress = "$to$geosourcefile";
	my $configaddress = "$to/opts/$configfile";
	open( SOURCEFILE, $sourceaddress ) or die "Can't open $geosourcefile 2: $!\n";
	my @linesgeo = <SOURCEFILE>;
	close SOURCEFILE;
	my $countervert = 0;
	my $counterobs = 0;
	my $zone;
	my @rowelements;
	my $line;
	my @node;
	my @component;
	my @v;
	my @obs;
	my @obspoints;
	my @obstructionpoint;
	my $xlenght;
	my $ylenght;
	my $truedistance;
	my $heightdifference;

	foreach my $line (@linesgeo)
	{
		$line =~ s/^\s+//; 

		my @rowelements = split(/\s+|,/, $line);
		if   ($rowelements[0] eq "*vertex" ) 
		{
			if ($countervert == 0) 
			{
				push (@v, [ "vertexes of  $sourceaddress" ]);
				push (@v, [ $rowelements[1], $rowelements[2], $rowelements[3] ] );
			}

			if ($countervert > 0) 
			{
				push (@v, [ $rowelements[1], $rowelements[2], $rowelements[3] ] );
			}
			$countervert++;
		}
		elsif   ($rowelements[0] eq "*obs" ) 
		{
			push (@obs, [ $rowelements[1], $rowelements[2], $rowelements[3], $rowelements[4], 
			$rowelements[5], $rowelements[6], $rowelements[7], $rowelements[8], $rowelements[9], $rowelements[10] ] );
			$counterobs++;
		}
		$counterlines++;
	}

	if ( $y_or_n_detect_obs eq "y") ### THIS HAS YET TO BE DONE AND WORK.
	{
		foreach my $ob (@obs)
		{
			push (@obspoints , [ $$ob[0], $$ob[1],$$ob[5] ] );
			push (@obspoints , [ ($$ob[0] + ( $$ob[3] / 2) ), ( $$ob[1] + ( $$ob[4] / 2 ) ) , $$ob[5] ] );
			push (@obspoints , [ ($$ob[0] + $$ob[3]), ( $$ob[1] + $$ob[4] ) , $$ob[5] ] );
		}
	}

	else {@obspoints = @{$recalculatenet[8]};}
	my @winpoints;
	my @windowpoints;
	my @windimsfront;
	my @windimseast;
	my @windimsback;
	my @windimswest;
	my $jointfront,
	my $jointeast;
	my $jointback;
	my $jointwest;
	my @windsims;
	my @windareas;
	my @jointlenghts;
	my $windimxfront;
	my $windimyfront;
	my $windimxback;
	my $windimyback;
	my $windimxeast; 
	my $windimyeast;
	my $windimxwest; 
	my $windimywest;

	if (-e $constrain) { eval "$constrain"; } # HERE THE INSTRUCTION WRITTEN IN THE OPTS CONFIGURATION FILE CAN BE SPEFICIED
	# FOR PROPAGATION OF CONSTRAINTS

	if ($y_or_n_reassign_cp == "y")
	{										
		eval `cat $configaddress`; # HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS 
		# IS EVALUATED, AND HERE BELOW CONSTRAINTS ARE PROPAGATED. 
	}



	open( INFILENET, $infilenet ) or die "Can't open $infilenet 2: $!\n";
	my @linesnet = <INFILENET>;
	close INFILENET;

	my @letters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", 
	"t", "u", "v", "w", "x", "y", "z");
	my $counternode = 0;
	my $interfaceletter;
	my $calcpressurecoefficient;
	my $nodetype;
	my $nodeletter;
	my $mode;
	my $counterlines = 0;
	my $counteropening = 0;
	my $countercrack = 0;
	my $counterthing = 0;
	my $counterjoint = 0;
	foreach my $line (@linesnet)
	{
		$line =~ s/^\s+//;
		@rowelements = split(/\s+/, $line);

		if ($rowelements[0] eq "Node") { $mode = "nodemode"; }
		if ($rowelements[0] eq "Component") { $mode = "componentmode"; }
		if ( ( $mode eq "nodemode" ) and ($counterlines > 1) and ($counterlines < (2 + scalar(@nodesdata) ) ) )
		{
			$counternode = ($counterlines - 2); 
			$zone = $nodesdata[$counternode][0];
			$interfaceletter = $nodesdata[$counternode][1];
			$calcpressurecoefficient = $nodesdata[$counternode][2];
			$nodetype = $rowelements[2];
			$nodeletter = $letters[$counternode];

			if ( $nodetype eq "0")
			{
				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY


m
e
c

n
c
$nodeletter

a
a
y
$zone


a

-
-
y

y
-
-
-
-
-
-
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{ 
					print `$printthis`;
				}

				print TOSHELL $printthis;
				$counternode++;
			}
			elsif ( $nodetype eq "3")							
			{	
				if ($y_or_n_reassign_cp == "y")
				{
					my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY


m
e
c

n
c
$nodeletter

a
e
$zone
$interfaceletter
$calcpressurecoefficient
y


-
-
y

y
-
-
-
-
-
-
-
-
YYY
";
					if ($exeonfiles eq "y") 
					{ 
						print `printthis`;
					}

					print TOSHELL $printthis;
					$counternode++;
				}
			}
		}

		my @node_letters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", 
		"q", "r", "s", "t", "u", "v", "w", "x", "y", "z");
		if ( ($mode eq "componentmode") and ( $line =~ "opening"))
		{
			my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY


m
e
c

n
d
$node_letters[$counterthing]

k
-
$windareas[$counteropening]
-
-
y

y
-
-
-
-
-
-
-
YYY
";
			if ($exeonfiles eq "y") 
			{ 
				print `$printthis`;
			}

			print TOSHELL $printthis;

			$counteropening++;
			$counterthing++;
		}
		elsif ( ($mode eq "componentmode") and ( $line =~ "crack "))
		{
			MY $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY


m
e
c

n
d
$node_letters[$counterthing]

l
-
$crackwidths[$counterjoint] $jointlenghts[$counterjoint]
-
-
y

y
-
-
-
-
-
-
-
YYY
";
			if ($exeonfiles eq "y") 
			{ 
				print `$printthis`;
			}

			print TOSHELL $printthis;

			$countercrack++;
			$counterthing++;
			$counterjoint++;
		}
		$counterlines++;
	}
} # END SUB recalculatenet
##############################################################################


##############################################################################
sub apply_constraints
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap2 = shift;
	my @apply_constraints = @$swap2;


	my $value_reshape;
	my $ybasewall; 
	my $ybasewindow;
	my @v;

	foreach my $group_operations ( @apply_constraints )
	{
		my @group = @{$group_operations};
		my $yes_or_no_apply_constraints = $group[0];

		my @sourcefiles = @{$group[1]};
		my @targetfiles = @{$group[2]};
		my @configfiles = @{$group[3]};
		my @basevalues = @{$group[4]};
		my @swingvalues = @{$group[5]}; 
		my @work_values = @{$group[6]}; 
		my $longmenu =  $group[7]; 
		my $basevalue;		
		my $targetfile;	
		my $configfile;		
		my $swingvalue;	
		my $sourceaddress;	
		my $targetaddress;
		my $configaddress;
		my $countoperations = 0;

		foreach $sourcefile ( @sourcefiles )
		{ 
			$basevalue = $basevalues[$countoperations];
			$sourcefile = $sourcefiles[$countoperations];
			$targetfile = $targetfiles[$countoperations];
			$configfile = $configfiles[$countoperations];
			$swingvalue = $swingvalues[$countoperations];
			$sourceaddress = "$to$sourcefile";
			$targetaddress = "$to$targetfile";
			$configaddress = "$to/opts/$configfile";
			$longmenu = $longmenus[$countoperations];
			checkfile($sourceaddress, $targetaddress);

			open( SOURCEFILE, $sourceaddress ) or die "Can't open $sourcefile 2: $!\n";
			my @lines = <SOURCEFILE>;
			close SOURCEFILE;
			my $counterlines = 0;
			my $countervert = 0;
			foreach my $line (@lines)
			{
				$line =~ s/^\s+//; 
				my @rowelements = split(/\s+|,/, $line);
				if   ($rowelements[0] eq "*vertex" ) 
				{
					if ($countervert == 0) 
					{
						push (@v, [ "vertexes of  $sourceaddress" ]);
						push (@v, [ $rowelements[1], $rowelements[2], $rowelements[3] ] );
					}

					if ($countervert > 0) 
					{
						push (@v, [ $rowelements[1], $rowelements[2], $rowelements[3] ] );
					}
					$countervert++;
				}
				$counterlines++;
			}

			my @vertexletters;
			if ($longmenu eq "y")
			{
				@vertexletters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", 
				"o", "p", "0\nb\nq", "0\nb\nr", "0\nb\ns", "0\nb\nt", "0\nb\nu", "0\nb\nv", "0\nb\nw", 
				"0\nb\nx", "0\nb\ny", "0\nb\nz", "0\nb\na", "0\nb\nb","0\nb\nc","0\nb\nd","0\nb\ne",
				"0\nb\n0\nb\nf","0\nb\n0\nb\ng","0\nb\n0\nb\nh","0\nb\n0\nb\ni","0\nb\n0\nb\nj",
				"0\nb\n0\nb\nk","0\nb\n0\nb\nl","0\nb\n0\nb\nm","0\nb\n0\nb\nn","0\nb\n0\nb\no",
				"0\nb\n0\nb\np","0\nb\n0\nb\nq","0\nb\n0\nb\nr","0\nb\n0\nb\ns","0\nb\n0\nb\nt");
			}
			else
			{
				@vertexletters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
				"n", "o", "p", "0\nq", "0\nr", "0\ns", "0\nt", "0\nu", "0\nv", "0\nw", "0\nx", 
				"0\ny", "0\nz", "0\na", "0\nb","0\n0\nc","0\n0\nd","0\n0\ne","0\n0\nf","0\n0\ng",
				"0\n0\nh","0\n0\ni","0\n0\nj","0\n0\nk","0\n0\nl","0\n0\nm","0\n0\nn","0\n0\no",
				"0\n0\np","0\n0\nq","0\n0\nr","0\n0\ns","0\n0\nt");
			}

			if (-e $constrain) { eval "$constrain"; } # HERE THE INSTRUCTION WRITTEN IN THE OPTS CONFIGURATION FILE CAN BE SPEFICIED
			# FOR PROPAGATION OF CONSTRAINTS

			if (-e $configaddress) 
			{	
				eval `cat $configaddress`; # HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS 
				# IS EVALUATED, AND HERE BELOW CONSTRAINTS ARE PROPAGATED.

				if (-e $constrain) { eval "$constrain"; } # HERE THE INSTRUCTION WRITTEN IN THE OPTS CONFIGURATION FILE CAN BE SPEFICIED
				# FOR PROPAGATION OF CONSTRAINTS


				my $countervertex = 0;
				foreach (@v)
				{
					if ($countervertex > 0)
					{			
						my $vertexletter = $vertexletters[$countervertex-1];
						if ($vertexletter ~~ @work_values)
						{
							my $printthis = 
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
d
$vertexletter
$v[$countervertex][0] $v[$countervertex][1] $v[$countervertex][2]
-
y
-
y
c
-
-
-
-
-
-
-
-
-
YYY
";
							if ($exeonfiles eq "y") 
							{ 
								print `$printthis`;
							}

							print TOSHELL $printthis;
						}
					}
					$countervertex++;
				}
			}
			$countoperations++;
		}
	}
} # END SUB apply_constraints
##############################################################################


##############################################################################
sub reshape_windows # IT APPLIES CONSTRAINTS
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap2 = shift;
	my @reshape_windows = @$swap2;


	my @work_letters ;
	my @v;						

	foreach my $group_operations ( @{$reshape_windows[$counterzone]} )
	{
		my @group = @{$group_operations};
		my @sourcefiles = @{$group[0]};
		my @targetfiles = @{$group[1]};
		my @configfiles = @{$group[2]};
		my @basevalues = @{$group[3]};
		my @swingvalues = @{$group[4]};
		my @work_letters = @{$group[5]}; 
		my @longmenus = @{$group[6]}; 

		my $countoperations = 0;
		foreach $sourcefile ( @sourcefiles )
		{ 
			my $basevalue = $basevalues[$countoperations];
			my $sourcefile = $sourcefiles[$countoperations];
			my $targetfile = $targetfiles[$countoperations];
			my $configfile = $configfiles[$countoperations];
			my $swingvalue = $swingvalues[$countoperations];
			my $longmenu = $longmenus[$countoperations];
			my $sourceaddress = "$to$sourcefile";
			my $targetaddress = "$to$targetfile";
			my $configaddress = "$to/opts/$configfile";
			my $totalswing = ( 2 * $swingvalue );			
			my $pace = ( $totalswing / ( $stepsvar - 1 ) );
			checkfile($sourceaddress, $targetaddress);
			
			open( SOURCEFILE, $sourceaddress ) or die "Can't open $sourcefile 2: $!\n";
			my @lines = <SOURCEFILE>;
			close SOURCEFILE;

			my $counterlines = 0;
			my $countervert = 0;
			foreach my $line (@lines)
			{
				$line =~ s/^\s+//; 

				my @rowelements = split(/\s+|,/, $line);
				if   ($rowelements[0] eq "*vertex" ) 
				{
					if ($countervert == 0) 
					{
						push (@v, [ "vertexes of  $sourceaddress", [], [] ]);
						push (@v, [ $rowelements[1], $rowelements[2], $rowelements[3] ] );
					}

					if ($countervert > 0) 
					{
						push (@v, [ $rowelements[1], $rowelements[2], $rowelements[3] ] );
					}

					$countervert++;
				}
				$counterlines++;
			}

			my @vertexletters;
			if ($longmenu eq "y")
			{																
				@vertexletters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
				"n", "o", "p", "0\nb\nq", "0\nb\nr", "0\nb\ns", "0\nb\nt", "0\nb\nu", "0\nb\nv", 
				"0\nb\nw", "0\nb\nx", "0\nb\ny", "0\nb\nz", "0\nb\na", "0\nb\nb","0\nb\nc","0\nb\nd",
				"0\nb\ne","0\nb\n0\nb\nf","0\nb\n0\nb\ng","0\nb\n0\nb\nh","0\nb\n0\nb\ni",
				"0\nb\n0\nb\nj","0\nb\n0\nb\nk","0\nb\n0\nb\nl","0\nb\n0\nb\nm","0\nb\n0\nb\nn",
				"0\nb\n0\nb\no","0\nb\n0\nb\np","0\nb\n0\nb\nq","0\nb\n0\nb\nr","0\nb\n0\nb\ns",
				"0\nb\n0\nb\nt");
			}
			else
			{
				@vertexletters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
				"n", "o", "p", "0\nq", "0\nr", "0\ns", "0\nt", "0\nu", "0\nv", "0\nw", "0\nx", 
				"0\ny", "0\nz", "0\na", "0\nb","0\n0\nc","0\n0\nd","0\n0\ne","0\n0\nf","0\n0\ng",
				"0\n0\nh","0\n0\ni","0\n0\nj","0\n0\nk","0\n0\nl","0\n0\nm","0\n0\nn","0\n0\no",
				"0\n0\np","0\n0\nq","0\n0\nr","0\n0\ns","0\n0\nt");
			}

			$value_reshape_window =  ( ( $basevalue - $swingvalue) + ( $pace * ( $counterstep - 1 )) );

			if (-e $configaddress)
			{				

				eval `cat $configaddress`;	# HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS 
				# IS EVALUATED, AND HERE BELOW CONSTRAINTS ARE PROPAGATED.

				if (-e $constrain) { eval "$constrain"; } # HERE THE INSTRUCTION WRITTEN IN THE OPTS CONFIGURATION FILE CAN BE SPEFICIED
				# FOR PROPAGATION OF CONSTRAINTS					

				my $countervertex = 0;

				foreach (@v)
				{
					if ($countervertex > 0)
					{
						my $vertexletter = $vertexletters[$countervertex];
						if ($vertexletter  ~~ @work_letters)
						{
							my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
d
$vertexletter
$v[$countervertex+1][0] $v[$countervertex+1][1] $v[$countervertex+1][2]
-
y
-
y
c
-
-
-
-
-
-
-
-
-
YYY
";
							if ($exeonfiles eq "y") 
							{ 
								print `$printthis`;
							}

							print TOSHELL $printthis;
						}
					}
					$countervertex++;
				}
			}
			$countoperations++;
		}

	}
} # END SUB reshape_windows
##############################################################################


sub warp #
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $warp = shift;


	my $yes_or_no_warp =  $$warp[$counterzone][0];
	my @surfs_to_warp =  @{ $warp->[$counterzone][1] };
	my @vertexes_numbers =  @{ $warp->[$counterzone][2] };   
	my @swingrotations = @{ $warp->[$counterzone][3] };
	my @yes_or_no_apply_to_others = @{ $warp->[$counterzone][4] };
	my $configfilename = $$warp[$counterzone][5];
	my $configfile = $to."/opts/".$configfilename;
	my @pairs_of_vertexes = @{ $warp->[$counterzone][6] }; # @pairs_of_vertexes defining axes
	my @windows_to_reallign = @{ $warp->[$counterzone][7] };
	my $sourcefilename = $$warp[$counterzone][8];
	my $sourcefile = $to.$sourcefilename;
	my $longmenu = $$warp[$counterzone][9];
	if ( $yes_or_no_warp eq "y" )
	{
		my $counterrotate = 0;
		foreach my $surface_letter (@surfs_to_warp)
		{
			$swingrotate = $swingrotations[$counterrotate];
			$pacerotate = ( $swingrotate / ( $stepsvar - 1 ) );
			$rotation_degrees = ( ( $swingrotate / 2 ) - ( $pacerotate * ( $counterstep - 1 ) )) ;
			$vertex_number = $vertexes_numbers[$counterrotate];
			$yes_or_no_apply = $yes_or_no_apply_to_others[$counterrotate];
			if (  ( $swingrotate != 0 ) and ( $stepsvar > 1 ) and ( $yes_or_no_warp eq "y" ) )
			{
				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
e
>
$surface_letter
c
$vertex_number
$rotation_degrees
$yes_or_no_apply
-
-
y
c
-
-
-
-
-
-
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{ 
					print `$printthis`;
				}
				print  TOSHELL $printthis;
			}
			$counterrotate++;
		}

		# THIS SECTION READS THE CONFIG FILE FOR DIMENSIONS
		open( SOURCEFILE, $sourcefile ) or die "Can't open $sourcefile: $!\n";
		my @lines = <SOURCEFILE>;
		close SOURCEFILE;
		my $counterlines = 0;
		my $countervert = 0;
		foreach my $line (@lines)
		{
			$line =~ s/^\s+//; 
				
			my @rowelements = split(/\s+|,/, $line);
			if   ($rowelements[0] eq "*vertex" ) 
			{
				if ($countervert == 0) 
				{
					push (@v, [ "vertexes of  $sourceaddress" ]);
					push (@v, [ $rowelements[1], $rowelements[2], $rowelements[3] ] );
				}

				if ($countervert > 0) 
				{
					push (@v, [ $rowelements[1], $rowelements[2], $rowelements[3] ] );
				}
				$countervert++;
			}
			$counterlines++;
		}


		my @vertexletters;
			if ($longmenu eq "y")
			{
				@vertexletters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", 
				"o", "p", "0\nb\nq", "0\nb\nr", "0\nb\ns", "0\nb\nt", "0\nb\nu", "0\nb\nv", "0\nb\nw", 
				"0\nb\nx", "0\nb\ny", "0\nb\nz", "0\nb\na", "0\nb\nb","0\nb\nc","0\nb\nd","0\nb\ne",
				"0\nb\n0\nb\nf","0\nb\n0\nb\ng","0\nb\n0\nb\nh","0\nb\n0\nb\ni","0\nb\n0\nb\nj",
				"0\nb\n0\nb\nk","0\nb\n0\nb\nl","0\nb\n0\nb\nm","0\nb\n0\nb\nn","0\nb\n0\nb\no",
				"0\nb\n0\nb\np","0\nb\n0\nb\nq","0\nb\n0\nb\nr","0\nb\n0\nb\ns","0\nb\n0\nb\nt");
			}
			else
			{
				@vertexletters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", 
				"o", "p", "0\nq", "0\nr", "0\ns", "0\nt", "0\nu", "0\nv", "0\nw", "0\nx", "0\ny", 
				"0\nz", "0\na", "0\nb","0\n0\nc","0\n0\nd","0\n0\ne","0\n0\nf","0\n0\ng","0\n0\nh",
				"0\n0\ni","0\n0\nj","0\n0\nk","0\n0\nl","0\n0\nm","0\n0\nn","0\n0\no","0\n0\np",
				"0\n0\nq","0\n0\nr","0\n0\ns","0\n0\nt");
			}


		if (-e $configfile)
		{				
			eval `cat $configfile`; # HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS IS EVALUATED 
			# AND PROPAGATED.

			if (-e $constrain) { eval "$constrain"; } # HERE THE INSTRUCTION WRITTEN IN THE OPTS CONFIGURATION FILE CAN BE SPEFICIED
			# FOR PROPAGATION OF CONSTRAINTS

		}
		# THIS SECTION SHIFTS THE VERTEX TO LET THE BASE SURFACE AREA UNCHANGED AFTER THE WARPING.

		my $counterthis = 0;
		$number_of_moves = ( (scalar(@pairs_of_vertexes)) /2 ) ;
		foreach my $pair_of_vertexes (@pairs_of_vertexes)
		{
			if ($counterthis < $number_of_moves)
			{
				$vertex1 = $pairs_of_vertexes[ 0 + ( 2 * $counterthis ) ];
				$vertex2 = $pairs_of_vertexes[ 1 + ( 2 * $counterthis ) ];

				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
d
^
j
$vertex1
$vertex2
-
$addedlength
y
-
y
-
y
-
-
-
-
-
-
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{ 
					print `$printthis`;
				}
				print TOSHELL $printthis;
			}
			$counterthis++;
		}
	}
}    # END SUB warp
##############################################################################


##############################################################################
##############################################################################
# BEGINNING OF SECTION DEDICATED TO FUNCTIONS FOR CONSTRAINING GEOMETRY

sub constrain_geometry # IT APPLIES CONSTRAINTS TO ZONE GEOMETRY
{
	# IT CONSTRAIN GEOMETRY FILES. IT HAS TO BE CALLED FROM THE MAIN FILE WITH:
	# constrain_geometry($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $exeonfiles, \@applytype, \@constrain_geometry);
	# constrain_geometry($to, $fileconfig, $stepsvar, $counterzone, 
	# $counterstep, $exeonfiles, \@applytype, \@constrain_geometry, $to_do);
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap = shift;
	my @constrain_geometry = @$swap;
	my $to_do = shift;


	# print OUTFILE "YOUCALLED!\n\n";
	# print OUTFILE "HERE: \@constrain_geometry:" . Dumper(@constrain_geometry) . "\n\n";
	if ($longmenu eq "y")
	{																
		@vertexletters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", 
		"o", "p", "0\nb\nq", "0\nb\nr", "0\nb\ns", "0\nb\nt", "0\nb\nu", "0\nb\nv", "0\nb\nw", 
		"0\nb\nx", "0\nb\ny", "0\nb\nz", "0\nb\na", "0\nb\nb","0\nb\nc","0\nb\nd","0\nb\ne",
		"0\nb\n0\nb\nf","0\nb\n0\nb\ng","0\nb\n0\nb\nh","0\nb\n0\nb\ni","0\nb\n0\nb\nj",
		"0\nb\n0\nb\nk","0\nb\n0\nb\nl","0\nb\n0\nb\nm","0\nb\n0\nb\nn","0\nb\n0\nb\no",
		"0\nb\n0\nb\np","0\nb\n0\nb\nq","0\nb\n0\nb\nr","0\nb\n0\nb\ns","0\nb\n0\nb\nt");
	}
	else
	{
		@vertexletters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
		"n", "o", "p", "0\nq", "0\nr", "0\ns", "0\nt", "0\nu", "0\nv", "0\nw", "0\nx", 
		"0\ny", "0\nz", "0\na", "0\nb","0\n0\nc","0\n0\nd","0\n0\ne","0\n0\nf","0\n0\ng",
		"0\n0\nh","0\n0\ni","0\n0\nj","0\n0\nk","0\n0\nl","0\n0\nm","0\n0\nn","0\n0\no",
		"0\n0\np","0\n0\nq","0\n0\nr","0\n0\ns","0\n0\nt");
	}

	foreach my $elm (@constrain_geometry)
	{
		my @group = @{$elm};
		# print OUTFILE "INSIDE: \@constrain_geometry:" . Dumper(@constrain_geometry) . "\n\n";
		# print OUTFILE "INSIDE: \@group:" . Dumper(@group) . "\n\n";
		my $zone_letter = $group[1];
		my $sourcefile = $group[2];
		my $targetfile = $group[3];
		my $configfile = $group[4];
		my $sourceaddress = "$to$sourcefile";
		my $targetaddress = "$to$targetfile";
		my @work_letters = @{$group[5]}; 
		my $longmenus = $group[6]; 

		# print OUTFILE "VARIABLES: \$to:$to, \$fileconfig:$fileconfig, \$stepsvar:$stepsvar, \$counterzone:$counterzone, \$counterstep:$counterstep, \$exeonfiles:$exeonfiles, 
		# \$zone_letter:$zone_letter, \$sourceaddress:$sourceaddress, \$targetaddress:$targetaddress, \$longmenus:$longmenus, \@work_letters, " . Dumper(@work_letters) . "\n\n";

		unless ($to_do eq "justwrite")
		{
			checkfile($sourceaddress, $targetaddress);
			read_geometry($to, $sourcefile, $targetfile, $configfile, \@work_letters, $longmenus);
			read_geo_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $configaddress, \@v, \@tempv);
		}

		unless ($to_do eq "justread")
		{
			apply_geo_constraints(\@dov, \@vertexletters, \@work_letters, $exeonfiles, $zone_letter, $toshell, $outfile, $configfile, \@tempv);
		}
		# print OUTFILE "\@v: " . Dumper(@v) . "\n\n";
	}
} # END SUB constrain_geometry


sub read_geometry
{
	# THIS READS GEOMETRY FILES. # IT HAS TO BE CALLED WITH:
	# read_geometry($to, $sourcefile, $targetfile, $configfiles, \@work_letters, $longmenus);
	my $to = shift;
	my $sourcefile = shift;
	my $targetfile = shift;
	my $configfile = shift;
	my $swap = shift;
	my @work_letters = @$swap;
	my $longmenus = shift;
	my $sourceaddress = "$to$sourcefile";
	my $targetaddress = "$to$targetfile";
	my $configaddress = "$to$configfile";
				
	open( SOURCEFILE, $sourceaddress ) or die "Can't open $sourcefile 2: $!\n";
	my @lines = <SOURCEFILE>;
	close SOURCEFILE;

	my $counterlines = 0;
	my $countervert = 0;
	foreach my $line (@lines)
	{
		$line =~ s/^\s+//; 

		my @rowelements = split(/\s+|,/, $line);
		if   ($rowelements[0] eq "*vertex" ) 
		{
			push (@v, [ $rowelements[1], $rowelements[2], $rowelements[3] ] );
			$countervert++;
		}
		$counterlines++;
	}
	@dov = @v;
} # END SUB read_geometry


sub read_geo_constraints
{	
	# THIS FILE IS FOR OPTS TO READ GEOMETRY USER-IMPOSED CONSTRAINTS.
	# IT IS CALLED WITH: read_geo_constraints($configaddress);
	# THIS MAKES AVAILABLE THE VERTEXES IN THE GEOMETRY FILES TO THE USER FOR MANIPULATION, IN THE FOLLOWING FORM:
	# $v[$counterzone][$number][$x], $v[$counterzone][$number][$y], $v[$counterzone][$number][$z]. EXAMPLE: $v[0][4][$x] = 1. 
	# OR: @v[0][4][$x] =  @v[0][4][$y]. OR EVEN: @v[1][4][$x] =  @v[0][3][$z].
	# The $counterzone that is actuated is always the last, the one which is active. 
	# It would have therefore no sense writing $v[0][4][$x] =  $v[1][2][$y].
	# Differentent $counterzones can be referred to the same zone. Different $counterzones just number mutations in series.
	# ALSO, IT MAKES AVAILABLE TO THE USER INFORMATIONS ABOUT THE MORPHING STEP OF THE MODELS 
	# AND THE STEPS THE MODEL HAVE TO FOLLOW. 
	# THIS ALLOWS TO IMPOSE EQUALITY CONSTRAINTS TO THESE VARIABLES, 
	# WHICH COULD ALSO BE COMBINED WITH THE FOLLOWING ONES: 
	# $stepsvar, WHICH TELLS THE PROGRAM HOW MANY ITERATION STEPS IT HAS TO DO IN THE CURRENT MORPHING PHASE.
	# $counterzone, WHICH TELLS THE PROGRAM WHAT OPERATION IS BEING EXECUTED IN THE CHAIN OF OPERATIONS 
	# THAT MAY BE EXECUTES AT EACH MORPHING PHASE. EACH $counterzone WILL CONTAIN ONE OR MORE ITERATION STEPS.
	# TYPICALLY, IT WILL BE USED FOR A ZONE, BUT NOTHING PREVENTS THAT SEVERAL OF THEM CHAINED ONE AFTER 
	# THE OTHER ARE APPLIED TO THE SAME ZONE.
	# $counterstep, WHICH TELLS THE PROGRAM WHAT THE CURRENT ITERATION STEP IS.
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $configaddress = shift;
	my $swap = shift;
	my @myv = @$swap;
	@tempv = @myv;

	my $x = 0;
	my $y = 1;
	my $z = 2;
	unshift (@myv, [ "vertexes of  $sourceaddress. \$counterzone: $counterzone ", [], [] ]);

	if (-e $configaddress)
	{	
		push (@v, [@myv]); #
		eval `cat $configaddress`; # HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS IS EVALUATED.

		if (-e $constrain) { eval "$constrain"; } # HERE THE INSTRUCTION WRITTEN IN THE OPTS CONFIGURATION FILE CAN BE SPEFICIED
		# FOR PROPAGATION OF CONSTRAINTS

		@dov = @{$v[$#v]}; #
		shift (@dov); #
	}
} # END SUB read_geo_constraints


sub apply_geo_constraints
{
	# IT APPLY USER-IMPOSED CONSTRAINTS TO A GEOMETRY FILES VIA SHELL
	# IT HAS TO BE CALLED WITH: 
	# apply_geo_constraints(\@v, \@vertexletters, \@work_letters, \$exeonfiles, \$zone_letter);
	my $swap = shift;
	my @v = @$swap;
	my $swap = shift;
	my @vertexletters = @$swap;

	my $swap = shift;
	my @work_letters = @$swap;

	my $exeonfiles = shift;
	my $zone_letter = shift;
	my $toshell = shift;
	my $outfile = shift;
	my $configfile = shift;
	my $swap = shift;
	my @tempv = @$swap;


	my $countervertex = 0;

	foreach my $v (@v)
	{
		my $vertexletter = $vertexletters[$countervertex];
		if 
		( 
			( 
				(@work_letters eq "") or ($vertexletter  ~~ @work_letters) 
			)
			and 
			( 
				not ( @{$v[$countervertex]} ~~ @{$tempv[$countervertex]} ) 
			)
		)
		{ 
			my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
d
$vertexletter
$v[$countervertex+1][0] $v[$countervertex+1][1] $v[$countervertex+1][2]
-
y
-
y
c
-
-
-
-
-
-
-
-
-
YYY
";
			if ($exeonfiles eq "y") 
			{
				print `$printthis`;
			}

			print TOSHELL $printthis;
		}
		$countervertex++;
	}

} # END SUB apply_geo_constraints

# END OF SECTION DEDICATED TO FUNCTIONS FOR CONSTRAINING GEOMETRY
##############################################################################
##############################################################################



##############################################################################
##############################################################################
# BEGINNING OF SECTION DEDICATED TO FUNCTIONS FOR CONSTRAINING CONTROLS

sub vary_controls
{  	# IT IS CALLED FROM THE MAIN FILE
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap = shift;
	my @vary_controls = @$swap;


	my $semaphore_zone;
	my $semaphore_dataloop;
	my $semaphore_massflow;
	my $counter_controlmass = -1;
	my $semaphore_setpoint;
	my $counterline = 0;
	my $doline;
	my @letters = ("e", "f", "g", "h", "i", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "z"); # CHECK IF THE LAST LETTERS ARE CORRECT, ZZZ
	my @period_letters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "l", "m", "n", "o", "p", "q", "r", "s"); # CHECK IF THE LAST LETTERS ARE CORRECT, ZZZ
	my $loop_hour = 2; # NOTE: THE FOLLOWING VARIABLE NAMES ARE SHADOWED IN THE FOREACH LOOP BELOW, 
	# BUT ARE THE ONES USED IN THE OPTS CONSTRAINTS FILES.
	my $max_heating_power = 3;
	my $min_heating_power = 4;
	my $max_cooling_power = 5,
	my $min_cooling_power = 6;
	my $heating_setpoint = 7;
	my $cooling_setpoint = 8;
	my $flow_hour = 2;
	my $flow_setpoint = 3;
	my $flow_onoff = 4;
	my $flow_fraction = 5;
	my $loop_letter;
	my $loopcontrol_letter;

	my @group = @{$vary_controls[$counterzone]};
	my $sourcefile = $group[0];
	my $targetfile = $group[1];
	my $configfile = $group[2];
	my @buildbulk = @{$group[3]};
	my @flowbulk = @{$group[4]};
	my $countbuild = 0;
	my $countflow = 0;

	my $countcontrol = 0;
	my $sourceaddress = "$to$sourcefile";
	my $targetaddress = "$to$targetfile";
	my $configaddress = "$to$configfile";	

	#@loopcontrol; # DON'T PUT "my" HERE.
	#@flowcontrol; # DON'T PUT "my" HERE.
	#@new_loopcontrols; # DON'T PUT "my" HERE.
	#@new_flowcontrols; # DON'T PUT "my" HERE.
	my @groupzone_letters;
	my @zone_period_letters;
	my @flow_letters;
	my @fileloopbulk;
	my @fileflowbulk;

	checkfile($sourceaddress, $targetaddress);

	if ($counterstep == 1)
	{
		read_controls($sourceaddress, $targetaddress, \@letters, \@period_letters);
	}


	calc_newctl($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@buildbulk, 
	\@flowbulk, \@loopcontrol, \@flowcontrol);



	sub calc_newctl
	{	# TO BE CALLED WITH: calc_newcontrols($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@buildbulk, \@flowbulk, \@loopcontrol, \@flowcontrol);
		# THIS COMPUTES CHANGES TO BE MADE TO CONTROLS BEFORE PROPAGATION OF CONSTRAINTS
		my $to = shift;
		my $fileconfig = shift;
		my $stepsvar = shift;
		my $counterzone = shift;
		my $counterstep = shift;
		my $swap = shift;
		my @buildbulk = @$swap;
		my $swap = shift;
		my @flowbulk = @$swap;
		my $swap = shift;
		my @loopcontrol = @$swap;
		my $swap = shift;
		my @flowcontrol = @$swap;

		my @new_loop_hours;
		my @new_max_heating_powers;
		my @new_min_heating_powers;
		my @new_max_cooling_powers;
		my @new_min_cooling_powers;
		my @new_heating_setpoints;
		my @new_cooling_setpoints;
		my @new_flow_hours;
		my @new_flow_setpoints;
		my @new_flow_onoffs;
		my @new_flow_fractions;

		# HERE THE MODIFICATIONS TO BE EXECUTED ON EACH PARAMETERS ARE CALCULATED.
		if ($stepsvar == 0) {$stepsvar = 1;}
		if ($stepsvar > 1) 
		{
			foreach $each_buildbulk (@buildbulk)
			{
				my @askloop = @{$each_buildbulk};
				my $new_loop_letter = $askloop[0];
				my $new_loopcontrol_letter = $askloop[1];
				my $swing_loop_hour = $askloop[2];
				my $swing_max_heating_power = $askloop[3];
				my $swing_min_heating_power = $askloop[4];
				my $swing_max_cooling_power = $askloop[5];
				my $swing_min_cooling_power = $askloop[6];
				my $swing_heating_setpoint = $askloop[7];
				my $swing_cooling_setpoint = $askloop[8];

				my $countloop = 0; #IT IS FOR THE FOLLOWING FOREACH. LEAVE IT ATTACHED TO IT.
				foreach $each_loop (@loopcontrol) # THIS DISTRIBUTES THIS NESTED DATA STRUCTURES IN A FLAT MODE TO PAIR THE INPUT FILE, USER DEFINED ONE.
				{
					my $countcontrol = 0;
					@thisloop = @{$each_loop};
					# my $letterfile = $letters[$countloop];
					foreach $lp (@thisloop)
					{
						my @control = @{$lp};
						# my $letterfilecontrol = $period_letters[$countcontrol];
						$loop_letter = $loopcontrol[$countloop][$countcontrol][0];
						$loopcontrol_letter = $loopcontrol[$countloop][$countcontrol][1];
						if ( ( $new_loop_letter eq $loop_letter ) and ($new_loopcontrol_letter eq $loopcontrol_letter ) )
						{
							# print OUTFILE "YES!: \n\n\n";
							$loop_hour__ = $loopcontrol[$countloop][$countcontrol][$loop_hour];
							$max_heating_power__ = $loopcontrol[$countloop][$countcontrol][$max_heating_power];
							$min_heating_power__ = $loopcontrol[$countloop][$countcontrol][$min_heating_power];
							$max_cooling_power__ = $loopcontrol[$countloop][$countcontrol][$max_cooling_power];
							$min_cooling_power__ = $loopcontrol[$countloop][$countcontrol][$min_cooling_power];
							$heating_setpoint__ = $loopcontrol[$countloop][$countcontrol][$heating_setpoint];
							$cooling_setpoint__ = $loopcontrol[$countloop][$countcontrol][$cooling_setpoint];
						}
						$countcontrol++;
					}
					$countloop++;
				}

				my $pace_loop_hour =  ( $swing_loop_hour / ($stepsvar - 1) );
				my $floorvalue_loop_hour = ($loop_hour__ - ($swing_loop_hour / 2) );
				my $new_loop_hour = $floorvalue_loop_hour + ($counterstep * $pace_loop_hour);

				my $pace_max_heating_power =  ( $swing_max_heating_power / ($stepsvar - 1) );
				my $floorvalue_max_heating_power = ($max_heating_power__ - ($swing_max_heating_power / 2) );
				my $new_max_heating_power = $floorvalue_max_heating_power + ($counterstep * $pace_max_heating_power);

				my $pace_min_heating_power =  ( $swing_min_heating_power / ($stepsvar - 1) );
				my $floorvalue_min_heating_power = ($min_heating_power__ - ($swing_min_heating_power / 2) );
				my $new_min_heating_power = $floorvalue_min_heating_power + ($counterstep * $pace_min_heating_power);

				my $pace_max_cooling_power =  ( $swing_max_cooling_power / ($stepsvar - 1) );
				my $floorvalue_max_cooling_power = ($max_cooling_power__ - ($swing_max_cooling_power / 2) );
				my $new_max_cooling_power = $floorvalue_max_cooling_power + ($counterstep * $pace_max_cooling_power);

				my $pace_min_cooling_power =  ( $swing_min_cooling_power / ($stepsvar - 1) );
				my $floorvalue_min_cooling_power = ($min_cooling_power__ - ($swing_min_cooling_power / 2) );
				my $new_min_cooling_power = $floorvalue_min_cooling_power + ($counterstep * $pace_min_cooling_power);

				my $pace_heating_setpoint =  ( $swing_heating_setpoint / ($stepsvar - 1) );
				my $floorvalue_heating_setpoint = ($heating_setpoint__ - ($swing_heating_setpoint / 2) );
				my $new_heating_setpoint = $floorvalue_heating_setpoint + ($counterstep * $pace_heating_setpoint);

				my $pace_cooling_setpoint =  ( $swing_cooling_setpoint / ($stepsvar - 1) );
				my $floorvalue_cooling_setpoint = ($cooling_setpoint__ - ($swing_cooling_setpoint / 2) );
				my $new_cooling_setpoint = $floorvalue_cooling_setpoint + ($counterstep * $pace_cooling_setpoint);

				$new_loop_hour = sprintf("%.2f", $new_loop_hour);
				$new_max_heating_power = sprintf("%.2f", $new_max_heating_power);
				$new_min_heating_power = sprintf("%.2f", $new_min_heating_power);
				$new_max_cooling_power = sprintf("%.2f", $new_max_cooling_power);
				$new_min_cooling_power = sprintf("%.2f", $new_min_cooling_power);
				$new_heating_setpoint = sprintf("%.2f", $new_heating_setpoint);
				$new_cooling_setpoint = sprintf("%.2f", $new_cooling_setpoint);

				push(@new_loopcontrols, 
				[ $new_loop_letter, $new_loopcontrol_letter, $new_loop_hour, 
				$new_max_heating_power, $new_min_heating_power, $new_max_cooling_power, 
				$new_min_cooling_power, $new_heating_setpoint, $new_cooling_setpoint ] );
			}

			my $countflow = 0;

			foreach my $elm (@flowbulk)
			{
				my @askflow = @{$elm};
				my $new_flow_letter = $askflow[0];
				my $new_flowcontrol_letter = $askflow[1];
				my $swing_flow_hour = $askflow[2];
				my $swing_flow_setpoint = $askflow[3];
				my $swing_flow_onoff = $askflow[4];
				if ( $swing_flow_onoff eq "ON") { $swing_flow_onoff = 1; }
				elsif ( $swing_flow_onoff eq "OFF") { $swing_flow_onoff = -1; }
				my $swing_flow_fraction = $askflow[5];

				my $countflow = 0; # IT IS FOR THE FOLLOWING FOREACH. LEAVE IT ATTACHED TO IT.
				foreach $each_flow (@flowcontrol) # THIS DISTRIBUTES THOSE NESTED DATA STRUCTURES IN A FLAT MODE TO PAIR THE INPUT FILE, USER DEFINED ONE.
				{
					my $countcontrol = 0;
					@thisflow = @{$each_flow};
					# my $letterfile = $letters[$countflow];
					foreach $elm (@thisflow)
					{
						my @control = @{$elm};
						# my $letterfilecontrol = $period_letters[$countcontrol];
						$flow_letter = $flowcontrol[$countflow][$countcontrol][0];
						$flowcontrol_letter = $flowcontrol[$countflow][$countcontrol][1];
						if ( ( $new_flow_letter eq $flow_letter ) and ($new_flowcontrol_letter eq $flowcontrol_letter ) )
						{
							$flow_hour__ = $flowcontrol[$countflow][$countcontrol][$flow_hour];
							$flow_setpoint__ = $flowcontrol[$countflow][$countcontrol][$flow_setpoint];
							$flow_onoff__ = $flowcontrol[$countflow][$countcontrol][$flow_onoff];
							if ( $flow_onoff__ eq "ON") { $flow_onoff__ = 1; }
							elsif ( $flow_onoff__ eq "OFF") { $flow_onoff__ = -1; }
							$flow_fraction__ = $flowcontrol[$countflow][$countcontrol][$flow_fraction];
						}
						$countcontrol++;
					}
					$countflow++;
				}
	
				my $pace_flow_hour =  ( $swing_flow_hour / ($stepsvar - 1) );
				my $floorvalue_flow_hour = ($flow_hour__ - ($swing_flow_hour / 2) );
				my $new_flow_hour = $floorvalue_flow_hour + ($counterstep * $pace_flow_hour);

				my $pace_flow_setpoint =  ( $swing_flow_setpoint / ($stepsvar - 1) );
				my $floorvalue_flow_setpoint = ($flow_setpoint__ - ($swing_flow_setpoint / 2) );
				my $new_flow_setpoint = $floorvalue_flow_setpoint + ($counterstep * $pace_flow_setpoint);

				my $pace_flow_onoff =  ( $swing_flow_onoff / ($stepsvar - 1) );
				my $floorvalue_flow_onoff = ($flow_onoff__ - ($swing_flow_onoff / 2) );
				my $new_flow_onoff = $floorvalue_flow_onoff + ($counterstep * $pace_flow_onoff);

				my $pace_flow_fraction =  ( $swing_flow_fraction / ($stepsvar - 1) );
				my $floorvalue_flow_fraction = ($flow_fraction__ - ($swing_flow_fraction / 2) );
				my $new_flow_fraction = $floorvalue_flow_fraction + ($counterstep * $pace_flow_fraction);

				$new_flow_hour = sprintf("%.2f", $new_flow_hour);
				$new_flow_setpoint = sprintf("%.2f", $new_flow_setpoint);
				$new_flow_onoff = sprintf("%.2f", $new_flow_onoff);
				$new_flow_fraction = sprintf("%.2f", $new_flow_fraction);

				push(@new_flowcontrols, 
				[ $new_flow_letter, $new_flowcontrol_letter, $new_flow_hour,  $new_flow_setpoint, $new_flow_onoff, $new_flow_fraction ] );
			}
			# HERE THE MODIFICATIONS TO BE EXECUTED ON EACH PARAMETERS ARE APPLIED TO THE MODELS THROUGH ESP-r.
			# FIRST, HERE THEY ARE APPLIED TO THE ZONE CONTROLS, THEN TO THE FLOW CONTROLS
		}
	} # END SUB calc_newcontrols

	print OUTFILE "\@new_loopcontrols: " . Dumper(@new_loopcontrols) . "\n\n";

	apply_loopcontrol_changes($exeonfiles, \@new_loopcontrols);
	apply_flowcontrol_changes($exeonfiles, \@new_flowcontrols);

} # END SUB vary_controls.


sub constrain_controls 
{	# IT READS CONTROL USER-IMPOSED CONSTRAINTS
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap = shift;
	my @constrain_controls = @$swap;
	my $to_do = shift;


	my $elm = $constrain_controls[$counterzone];
	my @group = @{$elm};
	my $sourcefile = $group[2];
	my $targetfile = $group[3];
	my $configfile = $group[4];
	my $sourceaddress = "$to$sourcefile";
	my $targetaddress = "$to$targetfile";
	my $configaddress = "$to$configfile";
	#@loopcontrol; @flowcontrol; @new_loopcontrols; @new_flowcontrols; # DON'T PUT "my" HERE. THEY ARE GLOBAL!!!
	my $semaphore_zone;
	my $semaphore_dataloop;
	my $semaphore_massflow;
	my $counter_controlmass = -1;
	my $semaphore_setpoint;
	my $counterline = 0;
	my $doline;
	my @letters = ("e", "f", "g", "h", "i", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "z"); # CHECK IF THE LAST LETTERS ARE CORRECT, ZZZ
	my @period_letters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "l", "m", "n", "o", "p", "q", "r", "s"); # CHECK IF THE LAST LETTERS ARE CORRECT, ZZZ
	my $loop_hour = 2; # NOTE: THE FOLLOWING VARIABLE NAMES ARE SHADOWED IN THE FOREACH LOOP BELOW, 
	# BUT ARE THE ONES USED IN THE OPTS CONSTRAINTS FILES.
	my $max_heating_power = 3;
	my $min_heating_power = 4;
	my $max_cooling_power = 5,
	my $min_cooling_power = 6;
	my $heating_setpoint = 7;
	my $cooling_setpoint = 8;
	my $flow_hour = 2;
	my $flow_setpoint = 3;
	my $flow_onoff = 4;
	my $flow_fraction = 5;
	my $loop_letter;
	my $loopcontrol_letter;
	my $countbuild = 0;
	my $countflow = 0;
	my $countcontrol = 0;	

	my @groupzone_letters;
	my @zone_period_letters;
	my @flow_letters;
	my @fileloopbulk;
	my @fileflowbulk;

	unless ($to_do eq "justwrite")
	{
		if ($counterstep == 1)
		{
			print OUTFILE "THIS\n";
			checkfile($sourceaddress, $targetaddress);
			read_controls($sourceaddress, $targetaddress, \@letters, \@period_letters);
			read_control_constraints($to, $fileconfig, $stepsvar, 
			$counterzone, $counterstep, $configaddress, \@loopcontrol, \@flowcontrol, \@temploopcontrol, \@tempflowcontrol);
		}
	}

	unless ($to_do eq "justread")
	{
		print OUTFILE "THAT\n";
		apply_loopcontrol_changes($exeonfiles, \@new_loopcontrol, \@temploopcontrol);
		apply_flowcontrol_changes($exeonfiles, \@new_flowcontrol, \@tempflowcontrol);
	}

} # END SUB constrain_controls.


sub read_controls
{	# TO BE CALLED WITH: read_controls($sourceaddress, $targetaddress, \@letters, \@period_letters);
	# THIS MAKES THE CONTROL CONFIGURATION FILE BE READ AND THE NEEDED VALUES ACQUIRED.
	# NOTICE THAT CURRENTLY ONLY THE "basic control law" IS SUPPORTED.

	my $sourceaddress = shift;
	my $targetaddress = shift;
	# checkfile($sourceaddress, $targetaddress); # THIS HAS TO BE _FIXED!_
	my $swap = shift;
	my @letters = @$swap;
	my $swap = shift;
	my @period_letters = @$swap;


	open( SOURCEFILE, $sourceaddress ) or die "Can't open $sourceaddress: $!\n";
	my @lines = <SOURCEFILE>;
	close SOURCEFILE;
	my $counterlines = 0;
	my $countloop = -1;
	my $countloopcontrol;
	my $countflow = -1;
	my $countflowcontrol = -1;
	my $semaphore_building;
	my $semaphore_loop;
	my $loop_hour;
	my $semaphore_loopcontrol;
	my $semaphore_massflow;
	my $flow_hour;
	my $semaphore_flow;
	my $semaphore_flowcontrol;
	my $loop_letter;
	my $loopcontrol_letter;
	my $flow_letter;
	my $flowcontrol_letter;

	foreach my $line (@lines)
	{
		if ( $line =~ /Control function/ )
		{
			$semaphore_loop = "yes";
			$countloopcontrol = -1;
			$countloop++;
			$loop_letter = $letters[$countloop];
		}
		if ( ($line =~ /ctl type, law/ ) )
		{
			$countloopcontrol++;
			my @row = split(/\s+/, $line);
			$loop_hour = $row[3];
			$semaphore_loopcontrol = "yes";
			$loopcontrol_letter = $period_letters[$countloopcontrol];
		}

		if ( ($semaphore_loop eq "yes") and ($semaphore_loopcontrol eq "yes") and ($line =~ /No. of data items/ ) ) 
		{  
			$doline = $counterlines + 1;
		}

		if ( ($semaphore_loop eq "yes" ) and ($semaphore_loopcontrol eq "yes") and ($counterlines == $doline) ) 
		{
			my @row = split(/\s+/, $line);
			my $max_heating_power = $row[1];
			my $min_heating_power = $row[2];
			my $max_cooling_power = $row[3];
			my $min_cooling_power = $row[4];
			my $heating_setpoint = $row[5];
			my $cooling_setpoint = $row[6];

			push(@{$loopcontrol[$countloop][$countloopcontrol]}, 
			$loop_letter, $loopcontrol_letter, $loop_hour, 
			$max_heating_power, $min_heating_power, $max_cooling_power, 
			$min_cooling_power, $heating_setpoint, $cooling_setpoint );

			$semaphore_loopcontrol = "no";
			$doline = "";
		}

		if ($line =~ /Control mass/ )
		{
			$semaphore_flow = "yes";
			$countflowcontrol = -1;
			$countflow++;
			$flow_letter = $letters[$countflow];
		}
		if ( ($line =~ /ctl type \(/ ) )
		{
			$countflowcontrol++;
			my @row = split(/\s+/, $line);
			$flow_hour = $row[3];
			$semaphore_flowcontrol = "yes";
			$flowcontrol_letter = $period_letters[$countflowcontrol];
		}

		if ( ($semaphore_flow eq "yes") and ($semaphore_flowcontrol eq "yes") and ($line =~ /No. of data items/ ) ) 
		{  
			$doline = $counterlines + 1;
		}

		if ( ($semaphore_flow eq "yes" ) and ($semaphore_flowcontrol eq "yes") and ($counterlines == $doline) ) 
		{
			my @row = split(/\s+/, $line);
			my $flow_setpoint = $row[1];
			my $flow_onoff = $row[2];
			my $flow_fraction = $row[3];
			push(@{$flowcontrol[$countflow][$countflowcontrol]}, 
			$flow_letter, $flowcontrol_letter, $flow_hour, $flow_setpoint, $flow_onoff, $flow_fraction);
			$semaphore_flowcontrol = "no";
			$doline = "";
		}
		$counterlines++;
	}			
} # END SUB read_controls.


sub read_control_constraints
{
	#  #!/usr/bin/perl
	# THIS FILE CAN CONTAIN USER-IMPOSED CONSTRAINTS FOR CONTROLS TO BE READ BY OPTS.
	# THE FOLLOWING VALUES CAN BE ADDRESSED IN THE OPTS CONSTRAINTS CONFIGURATION FILE, 
	# SET BY THE PRESENT FUNCTION:
	# 1) $loopcontrol[$counterzone][$countloop][$countloopcontrol][$loop_hour] 
	# Where $countloop and  $countloopcontrol has to be set to a specified number in the OPTS file for constraints.
	# 2) $loopcontrol[$counterzone][$countloop][$countloopcontrol][$max_heating_power] # Same as above.
	# 3) $loopcontrol[$counterzone][$countloop][$countloopcontrol][$min_heating_power] # Same as above.
	# 4) $loopcontrol[$counterzone][$countloop][$countloopcontrol][$max_cooling_power] # Same as above.
	# 5) $loopcontrol[$counterzone][$countloop][$countloopcontrol][$min_cooling_power] # Same as above.
	# 6) $loopcontrol[$counterzone][$countloop][$countloopcontrol][heating_setpoint] # Same as above.
	# 7) $loopcontrol[$counterzone][$countloop][$countloopcontrol][cooling_setpoint] # Same as above.
	# 8) $flowcontrol[$counterzone][$countflow][$countflowcontrol][$flow_hour] 
	# Where $countflow and  $countflowcontrol has to be set to a specified number in the OPTS file for constraints.
	# 9) $flowcontrol[$counterzone][$countflow][$countflowcontrol][$flow_setpoint] # Same as above.
	# 10) $flowcontrol[$counterzone][$countflow][$countflowcontrol][$flow_onoff] # Same as above.
	# 11) $flowcontrol[$counterzone][$countflow][$countflowcontrol][$flow_fraction] # Same as above.
	# EXAMPLE : $flowcontrol[0][1][2][$flow_fraction] = 0.7
	# OTHER EXAMPLE: $flowcontrol[2][1][2][$flow_fraction] = $flowcontrol[0][2][1][$flow_fraction]
	# The $counterzone that is actuated is always the last, the one which is active. 
	# It would have therefore no sense writing $flowcontrol[1][1][2][$flow_fraction] = $flowcontrol[3][2][1][$flow_fraction].
	# Differentent $counterzones can be referred to the same zone. Different $counterzones just number mutations in series.
	# ALSO, THIS MAKES AVAILABLE TO THE USER INFORMATIONS ABOUT THE MORPHING STEP OF THE MODELS 
	# AND THE STEPS THE MODEL HAS TO FOLLOW. 
	# THIS ALLOWS TO IMPOSE EQUALITY CONSTRAINTS TO THESE VARIABLES, 
	# WHICH COULD ALSO BE COMBINED WITH THE FOLLOWING ONES: 
	# $stepsvar, WHICH TELLS THE PROGRAM HOW MANY ITERATION STEPS IT HAS TO DO IN THE CURRENT MORPHING PHASE.
	# $counterzone, WHICH TELLS THE PROGRAM WHAT OPERATION IS BEING EXECUTED IN THE CHAIN OF OPERATIONS 
	# THAT MAY BE EXECUTES AT EACH MORPHING PHASE. EACH $counterzone WILL CONTAIN ONE OR MORE ITERATION STEPS.
	# TYPICALLY, IT WILL BE USED FOR A ZONE, BUT NOTHING PREVENTS THAT SEVERAL OF THEM CHAINED ONE AFTER 
	# THE OTHER ARE APPLIED TO THE SAME ZONE.
	# $counterstep, WHICH TELLS THE PROGRAM WHAT THE CURRENT ITERATION STEP IS.
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $configaddress = shift;
	my $swap = shift;
	@loopcontrol = @$swap;
	my $swap = shift;
	@flowcontrol = @$swap;
	my $swap = shift;
	@temploopcontrol = @$swap;
	my $swap = shift;
	@tempflowcontrol = @$swap;

	if (-e $configaddress) # TEST THIS, DDD
	{	# THIS APPLIES CONSTRAINST, THE FLATTEN THE HIERARCHICAL STRUCTURE OF THE RESULTS,
		# TO BE PREPARED THEN FOR BEING APPLIED TO CHANGE PROCEDURES. IT HAS TO BE TESTED.
		push (@loopcontrol, [@myloopcontrol]); #
		push (@flowcontrol, [@myflowcontrol]); #

		eval `cat $configaddress`;	# HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS 
		# IS EVALUATED, AND HERE BELOW CONSTRAINTS ARE PROPAGATED.	

		if (-e $constrain) { eval "$constrain"; } # HERE THE INSTRUCTION WRITTEN IN THE OPTS CONFIGURATION FILE CAN BE SPEFICIED
		# FOR PROPAGATION OF CONSTRAINTS

		@doloopcontrol = @{$loopcontrol[$#loopcontrol]}; #
		@doflowcontrol = @{$flowcontrol[$#flowcontrol]}; #

		shift (@doloopcontrol);
		shift (@doflowcontrol);

		sub flatten_loopcontrol_constraints
		{
			my @looptemp = @doloopcontrol;
			@new_loopcontrol = "";
			foreach my $elm (@looptemp)
			{
				my @loop = @{$elm};
				foreach my $elm (@loop)
				{
					my @loop = @{$elm};
					push (@new_loopcontrol, [@loop]);
				}
			}
		}
		flatten_loopcontrol_constraints;

		sub flatten_flowcontrol_constraints
		{
			my @flowtemp = @doflowcontrol;
			@new_flowcontrol = "";
			foreach my $elm (@flowtemp)
			{
				my @flow = @{$elm};
				foreach my $elm (@flow)
				{
					my @loop = @{$elm};
					push (@new_flowcontrol, [@flow]);
				}
			}
		}
		flatten_flowcontrol_constraints;

		shift @new_loopcontrol;
		shift @new_flowcontrol;
	}
} # END SUB read_control_constraints


sub apply_loopcontrol_changes
{ 	# TO BE CALLED WITH: apply_loopcontrol_changes($exeonfiles, \@new_loopcontrol);
	# THIS APPLIES CHANGES TO LOOPS IN CONTROLS (ZONES)
	my $exeonfiles = shift;
	my $swap = shift;
	my @new_loop_ctls = @$swap;
	my $swap = shift;
	my @temploopcontrol = @$swap;
	my $counterloop = 0;

	foreach my $elm (@new_loop_ctls)
	{
		my @loop = @{$elm};
		$new_loop_letter = $loop[0];
		$new_loopcontrol_letter = $loop[1];
		$new_loop_hour = $loop[2];
		$new_max_heating_power = $loop[3];
		$new_min_heating_power = $loop[4];
		$new_max_cooling_power = $loop[5];
		$new_min_cooling_power = $loop[6];
		$new_heating_setpoint = $loop[7];
		$new_cooling_setpoint = $loop[8];
		unless ( @{$new_loop_ctls[$counterloop]} ~~ @{$temploopcontrol[$counterloop]} )
		{
			my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
j

$new_loop_letter
c
$new_loopcontrol_letter
1
$new_loop_hour
b
$new_max_heating_power
c
$new_min_heating_power
d
$new_max_cooling_power
e
$new_min_cooling_power
f
$new_heating_setpoint
g
$new_cooling_setpoint
-
y
-
-
-
n
d

-
y
y
-
-
YYY
";
			if ($exeonfiles eq "y") 
			{
				print `$printthis`;
			}
			print TOSHELL $printthis;
		}
		$counterloop++;
	}
} # END SUB apply_loopcontrol_changes();




sub apply_flowcontrol_changes
{	# THIS HAS TO BE CALLED WITH: apply_flowcontrol_changes($exeonfiles, \@new_flowcontrols);
	# # THIS APPLIES CHANGES TO NETS IN CONTROLS
	my $exeonfiles = shift;
	my $swap = shift;
	my @new_flowcontrols = @$swap;
	my $swap = shift;
	my @tempflowcontrol = @$swap;
	my $counterflow = 0;

	foreach my $elm (@new_flowcontrols)
	{
		my @flow = @{$elm};
		$flow_letter = $flow[0];
		$flowcontrol_letter = $flow[1];
		$new_flow_hour = $flow[2];
		$new_flow_setpoint = $flow[3];
		$new_flow_onoff = $flow[4];
		$new_flow_fraction = $flow[5];
		unless ( @{$new_flowcontrols[$counterflow]} ~~ @{$tempflowcontrol[$counterflow]} )
		{
			my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
l

$flow_letter
c
$flowcontrol_letter
a
$new_flow_hour
$new_flow_setpoint $new_flow_onoff $new_flow_fraction
-
-
-
y
y
-
-
YYY
";
			if ($exeonfiles eq "y") # if ($exeonfiles eq "y") 
			{ 
				print `$printthis`;
			}

			print TOSHELL $printthis;
		}
		$counterflow++;
	}
} # END SUB apply_flowcontrol_changes;

# END OF SECTION DEDICATED TO FUNCTIONS FOR CONSTRAINING CONTROLS
##############################################################################
##############################################################################





##############################################################################
##############################################################################
# BEGINNING OF SECTION DEDICATED TO FUNCTIONS FOR CONSTRAINING OBSTRUCTIONS	

sub constrain_obstructions # IT APPLIES CONSTRAINTS TO OBSTRUCTIONS
{
	# THIS CONSTRAINS OBSTRUCTION FILES. IT HAS TO BE CALLED FROM THE MAIN FILE WITH:
	# constrain_obstruction($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $exeonfiles, \@applytype, \@constrain_obstructions);
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap2 = shift;
	my @constrain_obstructions = @$swap2;
	my $to_do = shift;


	my @work_letters;
	#@obs;	# GLOBAL!

	foreach my $elm (@constrain_obstructions)
	{
		my @group = @{$elm};
		my $zone_letter = $group[1];
		my $sourcefile = $group[2];
		my $targetfile = $group[3];
		my $configfile = $group[4];
		my $sourceaddress = "$to$sourcefile";
		my $targetaddress = "$to$targetfile";
		my $configaddress = "$to$configfile";
		my @work_letters = @{$group[5]}; 
		my $actonmaterials = $group[6];

		unless ($to_do eq "justwrite")
		{
			checkfile($sourceaddress, $targetaddress);
			read_obstructions($to, $sourceaddress, $targetaddress, $configaddress, \@work_letters, $actonmaterials, $exeonfiles);
			read_obs_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $configaddress, $actonmaterials, $exeonfiles, \@tempobs); # IT WORKS ON THE VARIABLE @obs, WHICH IS GLOBAL.
		}

		unless ($to_do eq "justread")
		{
			apply_obs_constraints(\@doobs, \@obs_letters, \@work_letters, $exeonfiles, $zone_letter, $actonmaterials, $exeonfiles, \@tempobs);
		}
	}
} # END SUB constrain_obstructions


sub read_obstructions
{
	# THIS READS GEOMETRY FILES. # IT HAS TO BE CALLED WITH:
	# read_geometry($to, $sourcefile, $targetfile, $configfiles, \@work_letters, $longmenus);
	my $to = shift;
	my $sourceaddress = shift;
	my $targetaddress = shift;
	my $configaddress = shift;
	my $swap = shift;
	@work_letters = @$swap;
	my $actonmaterials = shift;
	my $exeonfiles = shift;

				
	open( SOURCEFILE, $sourceaddress) or die "Can't open $sourceaddress: $!\n";
	my @lines = <SOURCEFILE>;
	close SOURCEFILE;

	my $counter = 0;
	foreach my $line (@lines)
	{
		#$line =~ s/^\s+//; 
		if  ( $line =~ m/\*obs/ ) 
		{
			unless ( $line =~ m/\*obs =/ ) 
			{
				$counter++;
			}
		}
	}

	if ( $counter > 21 )
	{																
		@obs_letters = ("e", "f", "g", "h", "i", "j", "k", "l", "m", "n", 
		"o", "0\nb\nf", "0\nb\ng", "0\nb\nh", "0\nb\ni", "0\nb\nj", "0\nb\nk", "0\nb\nm", 
		"0\nb\nn", "0\nb\no", "0\nb\n0\nb\nf","0\nb\n0\nb\ng",
		"0\nb\n0\nb\nh","0\nb\n0\nb\ni","0\nb\n0\nb\nj","0\nb\n0\nb\nk","0\nb\n0\nb\nl",
		"0\nb\n0\nb\nm","0\nb\n0\nb\nn","0\nb\n0\nb\no","0\nb\n0\nb\n0\nb\nf",
		"0\nb\n0\nb\n0\nb\ng","0\nb\n0\nb\n0\nb\nh","0\nb\n0\nb\n0\nb\ni","0\nb\n0\nb\n0\nb\nj",
		"0\nb\n0\nb\n0\nb\nk","0\nb\n0\nb\n0\nb\nl","0\nb\n0\nb\n0\nb\nm","0\nb\n0\nb\n0\nb\nn",
		"0\nb\n0\nb\n0\nb\no");
	}
	else
	{	
		@obs_letters = ("e", "f", "g", "h", "i", "j", "k", "l", "m", 
		"n", "o", "0\nf", "0\ng", "0\nh", "0\ni", "0\nj", "0\nk", "0\nl", 
		"0\nm", "0\nn", "0\no");
	}

	my $counter = 0;
	foreach my $line (@lines)
	{
		if  ( $line =~ m/\*obs/ ) 
		{
			unless ( $line =~ m/\*obs =/ ) 
			{
				#$line =~ s/^\s+//; 
				my @rowelements = split(/,/, $line);	
				push (@obs, [ $rowelements[1], $rowelements[2], $rowelements[3], 
				$rowelements[4], $rowelements[5], $rowelements[6], 
				$rowelements[7], $rowelements[8], $rowelements[9], 
				$rowelements[10], $rowelements[11], $rowelements[12], $obs_letters[$counter] ] );
				$counter++;
			}
		}
	}
} # END SUB read_obstructions


sub read_obs_constraints
{	
	# THE VARIABLE @obs REGARDS OBSTRUCTION USER-IMPOSED CONSTRAINTS
	# THIS CONSTRAINT CONFIGURATION FILE MAKES AVAILABLE TO THE USER THE FOLLOWING VARIABLES:
	# $obs[$counterzone][$obs_number][$x], $obs[$counterzone][$obs_number][$y], $obs[$counterzone][$obs_number][$y]
	# $obs[$counterzone][$obs_number][$width], $obs[$counterzone][$obs_number][$depth], $obs[$counterzone][$obs_number][$height]
	# $obs[$counterzone][$obs_number][$z_rotation], $obs[$counterzone][$obs_number][$y_rotation], 
	# $obs[$counterzone][$obs_number][$tilt], $obs[$counterzone][$obs_number][$opacity], $obs[$counterzone][$obs_number][$material], 
	# EXAMPLE: $obs[0][2][$x] = 2. THIS MEANS: AT COUNTERZONE 0, COORDINATE x OF OBSTRUCTION HAS TO BE SET TO 2.
	# OTHER EXAMPLE: $obs[0][2][$x] = $obs[2][2][$y].
	# The $counterzone that is actuated is always the last, the one which is active. 
	# There would be therefore no sense in writing $obs[0][4][$x] =  $obs[1][2][$y].
	# Differentent $counterzones can be referred to the same zone. Different $counterzones just number mutations in series.
	# NOTE THAT THE MATERIAL TO BE SPECIFIED IS A MATERIAL LETTER, BETWEEN QUOTES. EXAMPLE: $obs[1][$material] = "a".
	#  $tilt IS PRESENTLY UNUSED.
	# ALSO, THIS MAKES AVAILABLE TO THE USER INFORMATIONS ABOUT THE MORPHING STEP OF THE MODELS 
	# AND THE STEPS THE MODEL HAVE TO FOLLOW.
	# THIS ALLOWS TO IMPOSE EQUALITY CONSTRAINTS TO THESE VARIABLES, 
	# WHICH COULD ALSO BE COMBINED WITH THE FOLLOWING ONES: 
	# $stepsvar, WHICH TELLS THE PROGRAM HOW MANY ITERATION STEPS IT HAS TO DO IN THE CURRENT MORPHING PHASE.
	# $counterzone, WHICH TELLS THE PROGRAM WHAT OPERATION IS BEING EXECUTED IN THE CHAIN OF OPERATIONS 
	# THAT MAY BE EXECUTES AT EACH MORPHING PHASE. EACH $counterzone WILL CONTAIN ONE OR MORE ITERATION STEPS.
	# TYPICALLY, IT WILL BE USED FOR A ZONE, BUT NOTHING PREVENTS THAT SEVERAL OF THEM CHAINED ONE AFTER 
	# THE OTHER ARE APPLIED TO THE SAME ZONE.
	# $counterstep, WHICH TELLS THE PROGRAM WHAT THE CURRENT ITERATION STEP IS.
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $configaddress = shift;
	my $actonmaterials = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	@tempobs = @$swap;

	my $obs_letter = 13;
	my $x = 1;
	my $y = 2;
	my $z = 3;
	my $width = 4;
	my $depth = 5;
	my $height = 6;
	my $z_rotation = 7;
	my $y_rotation = 8;
	my $tilt = 9; # UNUSED
	my $opacity = 10;
	my $name = 11; # NOT TO BE CHANGED
	my $material = 12;
	if (-e $configaddress)
	{	
		unshift (@obs, []);	
		push (@obs, [@myobs]); #	
		eval `cat $configaddress`; # HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS IS EVALUATED.

		if (-e $constrain) { eval "$constrain"; } # HERE THE INSTRUCTION WRITTEN IN THE OPTS CONFIGURATION FILE CAN BE SPEFICIED
		# FOR PROPAGATION OF CONSTRAINTS

		@doobs = @{$obs[$#obs]}; #
		shift @doobs;
	}
} # END SUB read_geo_constraints


sub apply_obs_constraints
{
	# IT APPLY USER-IMPOSED CONSTRAINTS TO A GEOMETRY FILES VIA SHELL
	# IT HAS TO BE CALLED WITH: 
	# apply_geo_constraints(\@obs, \@obsletters, \@work_letters, \$exeonfiles, \$zone_letter, $actonmaterials);
	my $swap = shift;
	my @obs = @$swap;
	my $swap = shift;
	my @obs_letters = @$swap;
	my $swap = shift;
	my @work_letters = @$swap;
	my $exeonfiles = shift;
	my $zone_letter = shift;
	#print OUTFILE "ZONE LETTER: $zone_letter\n\n";
	my $actonmaterials = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @tempobs = @$swap;


	my $counterobs = 0;
	print OUTFILE "OBS_LETTERS IN APPLY" . Dumper(@obs_letters) . "\n\n";
	foreach my $ob (@obs)
	{
		my $obs_letter = $obs_letters[$counterobs];
		if ( ( @work_letters eq "") or ($obs_letter  ~~ @work_letters))
		{
			my @obstr = @{$ob};
			my $x = $obstr[0];
			my $y = $obstr[1];
			my $z = $obstr[2];
			my $width = $obs[3];
			my $depth = $obs[4];
			my $height = $obs[5];
			my $z_rotation = $obs[6];
			my $y_rotation = $obs[7];
			my $tilt = $obs[8];
			my $opacity = $obs[9];
			my $name = $obs[10];
			my $material = $obs[11];
			unless
			( 
				( @{$obs[$counterobs]} ~~ @{$tempobs[$counterobs]} ) 
			)
			{
				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
h
a
$obs_letter
a
a
$x $y $z
b
$width $depth $height
c
$z_rotation
d
$y_rotation
e # HERE THE DATUM IS STILL UNUSED. WHEN IT WILL, A LINE MUST BE ADDED WITH THE VARIABLE $tilt.
h
$opacity
-
-
c
-
c
-
-
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{
					print `$printthis`;
				}

				print TOSHELL $printthis;
			}

			my $obs_letter = $obs_letters[$counterobs];
			if ($obs_letter  ~~ @work_letters)
			{
				if ($actonmaterials eq "y")
				{	
					my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
h
a
$obs_letter
g
$material
-
-
-
c
-
c
-
-
-
-
YYY
";		
					if ($exeonfiles eq "y") 
					{
						print `$printthis`;
					}

					print TOSHELL $printthis;
				}
			}
		}
		$counterobs++;
	}
} # END SUB apply_obs_constraints


############################################################## BEGINNING OF GROUP GET AND PIN OBSTRUCTIONS
sub get_obstructions # IT APPLIES CONSTRAINTS TO ZONE GEOMETRY. TO DO. STILL UNUSED. 
# THE SAME FUNCTIONALITIES CAN BE OBTAINED, WITH MORE WORK, BY SPECIFYING APPROPRIATE SETTINGS IN THE OPTS CONFIG FILE.
{
	# THIS CONSTRAINS OBSTRUCTION FILES. IT HAS TO BE CALLED FROM THE MAIN FILE WITH:
	# constrain_obstruction($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $exeonfiles, \@applytype, \@constrain_obstructions);
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap2 = shift;
	my @get_obstructions = @$swap2;


	my @work_letters ;
	@obs;	# GLOBAL!
	foreach my $elm (@constrain_obstructions)
	{
		my @group = @{$elm};
		my $zone_letter = $group[1];
		my $sourcefile = $group[2];
		my $targetfile = $group[3];
		my $sourceaddress = "$to$sourcefile";
		my $targetaddress = "$to$targetfile";
		my $temp = $group[4];
		my @work_letters = @{$group[5]}; 
		my @obs_letters;
		checkfile($sourceaddress, $targetaddress);
		read_obstructions($to, $sourceaddress, $targetaddress, $configaddress, \@work_letters);
		write_temporary(\@obs, \@obs_letters, \@work_letters, $exeonfiles, $zone_letter, $temp);
	}
} # END SUB constrain_obstructions


sub write_temporary
{
	# IT APPLY USER-IMPOSED CONSTRAINTS TO A GEOMETRY FILES VIA SHELL. TO DO. STILL UNUSED. ZZZ
	# IT HAS TO BE CALLED WITH: 
	# apply_geo_constraints(\obs, \@obsletters, \@work_letters, \$exeonfiles, \$zone_letter, $actonmaterials);
	my $swap = shift;
	my @obs = @$swap;
	my $swap = shift;
	my @obs_letters = @$swap;
	my $swap = shift;
	my @work_letters = @$swap;
	my $exeonfiles = shift;
	my $zone_letter = shift;
	my $temp = shift;
	my $toshell = shift;
	my $outfile = shift;
	my $configfile = shift;




	open( SOURCEFILE, ">$temp" ) or die "Can't open $temp: $!\n";
	my $counterobs = 0;

	foreach my $ob (@obs)
	{
		my $obs_letter = $obs_letters[$counterobs];
		if ($obs_letter  ~~ @work_letters)
		{
			my @obs = @{$ob};
			print SOURCEFILE . "*obs $obs[1] $obs[2] $obs[3] $obs[4] $obs[5] $obs[6] $obs[7] $obs[8] $obs[10] $obs[11] $obs[12] $obs_letter\n";
		}
		$counterobs++;
		close SOURCEFILE;
	}
} # END SUB write_temporary


sub pin_obstructions  # TO DO. ZZZ
{
	# THIS CONSTRAINS OBSTRUCTION FILES. TO DO. STILL UNUSED. ZZZ
	# IT HAS TO BE CALLED FROM THE MAIN FILE WITH:
	# constrain_obstruction($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $exeonfiles, \@applytype, \@pin_obstructions);
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap = shift;
	my @pin_obstructions = @$swap;


	my @work_letters ;
	my @obs;	
	my @newobs;
	foreach my $elm (@pin_obstructions)
	{
		my @group = @{$elm};
		my $zone_letter = $group[1];
		my $sourcefile = $group[2];
		my $targetfile = $group[3];
		my $sourceaddress = "$to$sourcefile";
		my $targetaddress = "$to$targetfile";
		my $temp = $group[4];
		my @obs_letters;
		checkfile($sourceaddress, $targetaddress);

		open( SOURCEFILE, $temp ) or die "Can't open $temp: $!\n";
		my @rows = < SOURCEFILE >;
		foreach my $line (@rows)
		{
			my @elts = split(/\s+|,/, $line);
			push (@newobs, [ $elts[1],  $elts[2], $elts[3], $elts[4], $elts[5], $elts[6], $elts[7], $elts[8], $elts[9], $elts[10], $elts[11], $elts[12], $elts[13] ] );
		}
		apply_pin_obstructions($to, $fileconfig,$stepsvar, $counterzone, $counterstep, $exeonfiles, \@newobs );
	}
} # END SUB pin_obstructions


sub apply_pin_obstructions # TO DO. STILL UNUSED. ZZZ
{
	# IT APPLY USER-IMPOSED CONSTRAINTS TO A GEOMETRY FILES VIA SHELL
	# IT HAS TO BE CALLED WITH: 
	# apply_pin_obstructions( $to, $fileconfig,$stepsvar, $counterzone, $counterstep, $exeonfiles, \@obs );
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @obs = @$swap;


	my $counterobs = 0;
	foreach my $ob (@obs)
	{
		my @obs = @{$ob};
		my $x = $obs[1];
		my $y = $obs[2];
		my $z = $obs[3];
		my $width = $obs[4];
		my $depth = $obs[5];
		my $height = $obs[6];
		my $z_rotation = $obs[7];
		my $y_rotation = $obs[8];
		my $tilt = $obs[9];
		my $opacity = $obs[10];
		my $name = $obs[11];
		my $material = $obs[12];
		my $obs_letter = $obs[13];

		my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
h
a
$obs_letter
a
a
$x $y $z
b
$width $depth $height
c
$z_rotation
d
$y_rotation
e # HERE THE DATUM IS STILL UNUSED. WHEN IT WILL, A LINE MUST BE ADDED WITH THE VARIABLE $tilt.
h
$opacity
-
-
c
-
c
-
-
-
-
YYY
";
		if ($exeonfiles eq "y") 
		{
			print `$printthis`;
		}

		print TOSHELL $printthis;
	}
	$countervertex++;
} # END SUB apply_pin_obstructions
############################################################## END OF GROUP GET AND PIN OBSTRUCTIONS


##############################################################################
##############################################################################
# END OF SECTION DEDICATED TO FUNCTIONS FOR CONSTRAINING OBSTRUCTIONS



##############################################################################
##############################################################################
# BEGINNING OF SECTION DEDICATED TO FUNCTIONS FOR CONSTRAINING THE MASS-FLOW NETWORKS

sub vary_net
{  	# IT IS CALLED FROM THE MAIN FILE
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap = shift;
	my @vary_net = @$swap;

	my $activezone = $applytype[$counterzone][3];
	my ($semaphore_node, $semaphore_component, $node_letter);
	my $counter_component = -1;
	my $counterline = 0;
	my @node_letters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "l", "m", "n", "o", "p", "q", "r", "s"); # CHECK IF THE LAST LETTERS ARE CORRECT, ZZZ
	my @component_letters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "l", "m", "n", "o", "p", "q", "r", "s"); # CHECK IF THE LAST LETTERS ARE CORRECT, ZZZ
	# NOTE: THE FOLLOWING VARIABLE NAMES ARE SHADOWED IN THE FOREACH LOOP BELOW, 
	# BUT ARE THE ONES USED IN THE OPTS CONSTRAINTS FILES.

	my @group = @{$vary_net[$counterzone]};
	my $sourcefile = $group[0];
	my $targetfile = $group[1];
	my $configfile = $group[2];
	my @nodebulk = @{$group[3]};
	my @componentbulk = @{$group[4]};
	my $countnode = 0;
	my $countcomponent = 0;

	my $sourceaddress = "$to$sourcefile";
	my $targetaddress = "$to$targetfile";
	my $configaddress = "$to$configfile";	

	#@node; @component; # PLURAL. DON'T PUT "my" HERE!
	#@new_nodes; @new_components; # DON'T PUT "my" HERE.

	my @flow_letters;

	checkfile($sourceaddress, $targetaddress);

	if ($counterstep == 1)
	{
		read_net($sourceaddress, $targetaddress, \@node_letters, \@component_letters);
	}

	sub calc_newnet
	{	# TO BE CALLED WITH: calc_newnet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@nodebulk, \@componentbulk, \@node_, \@component);
		# THIS COMPUTES CHANGES TO BE MADE TO CONTROLS BEFORE PROPAGATION OF CONSTRAINTS
		my $to = shift;
		my $fileconfig = shift;
		my $stepsvar = shift;
		my $counterzone = shift;
		my $counterstep = shift;
		my $swap = shift;
		my @nodebulk = @$swap;
		my $swap = shift;
		my @componentbulk = @$swap;
		my $swap = shift;
		my @node = @$swap; # PLURAL
		my $swap = shift;
		my @component = @$swap; # PLURAL
		my $toshell = shift;
		my $outfile = shift;
		my $configfile = shift;

		my @new_volumes_or_surfaces;
		my @node_heights_or_cps;
		my @new_azimuths;
		my @boundary_heights;

		# HERE THE MODIFICATIONS TO BE EXECUTED ON EACH PARAMETERS ARE CALCULATED.
		if ($stepsvar == 0) {$stepsvar = 1;}
		if ($stepsvar > 1) 
		{
			foreach $each_nodebulk (@nodebulk)
			{
				my @asknode = @{$each_nodebulk};
				my $new_node_letter = $asknode[0];
				my $new_fluid = $asknode[1];
				my $new_type = $asknode[2];
				my $new_zone = $activezone;
				my $swing_height = $asknode[3];
				my $swing_data_2 = $asknode[4];
				my $new_surface = $asknode[5];
				my @askcp = @{$asknode[6]};
				my ($height__, $data_2__, $data_1__, $new_cp);					
				my $countnode = 0; #IT IS FOR THE FOLLOWING FOREACH. LEAVE IT ATTACHED TO IT.
				foreach $each_node (@node)
				{
					@node_ = @{$each_node};
					my $node_letter = $node_[0]; 
					if ( $new_node_letter eq $node_letter ) 
					{
						$height__ = $node_[3];
						$data_2__ = $node_[4];
						$data_1__ = $node_[5];
						$new_cp = $askcp[$counterstep-1];
					}
					$countnode++;
				}
				my $height = ( $swing_height / ($stepsvar - 1) );
				my $floorvalue_height = ($height__ - ($swing_height / 2) );
				my $new_height = $floorvalue_height + ($counterstep * $pace_height);
				$new_height = sprintf("%.3f", $height);
				if ($swing_height == 0) { $new_height = ""; }

				my $pace_data_2 =  ( $swing_data_2 / ($stepsvar - 1) );
				my $floorvalue_data_2 = ($data_2__ - ($swing_data_2 / 2) );
				my $new_data_2 = $floorvalue_data_2 + ($counterstep * $pace_data_2);
				$new_data_2 = sprintf("%.3f", $new_data_2);
				if ($swing_data_2 == 0) { $new_data_2 = ""; }

				my $pace_data_1 =  ( $swing_data_1 / ($stepsvar - 1) ); # UNUSED
				my $floorvalue_data_1 = ($data_1__ - ($swing_data_1 / 2) );
				my $new_data_1 = $floorvalue_data_1 + ($counterstep * $pace_data_1);
				$new_data_1  = sprintf("%.3f", $new_data_1);
				if ($swing_data_1 == 0) { $new_data_1 = ""; }

				push(@new_nodes, 
				[ $new_node_letter, $new_fluid, $new_type, $new_zone, $new_height, $new_data_2, $new_surface, $new_cp ] );
			}

			foreach $each_componentbulk (@componentbulk)
			{
				my @askcomponent = @{$each_componentbulk};
				my $new_component_letter = $askcomponent[0];

				my $new_type = $askcomponent[1];
				my $swing_data_1 = $askcomponent[2];
				my $swing_data_2 = $askcomponent[3];
				my $swing_data_3 = $askcomponent[4];	
				my $swing_data_4 = $askcomponent[5];
				my $component_letter;				
				my $countcomponent = 0;    #IT IS FOR THE FOLLOWING FOREACH.
				my ($new_type, $data_1__, $data_2__, $data_3__, $data_4__ );
				foreach $each_component (@component) # PLURAL
				{
					@component_ = @{$each_component};
					$component_letter = $component_letters[$countcomponent]; 
					if ( $new_component_letter eq $component_letter ) 
					{
						$new_component_letter = $component_[0];
						$new_fluid = $component_[1];
						$new_type = $component_[2];
						$data_1__ = $component_[3];
						$data_2__ = $component_[4];
						$data_3__ = $component_[5];
						$data_4__ = $component_[6];
					}
					$countcomponent++;
				}

				my $pace_data_1 =  ( $swing_data_1 / ($stepsvar - 1) ); 
				my $floorvalue_data_1 = ($data_1__ - ($swing_data_1 / 2) );
				my $new_data_1 = $floorvalue_data_1 + ($counterstep * $pace_data_1);
				if ($swing_data_1 == 0) { $new_data_1 = ""; }

				my $pace_data_2 =  ( $swing_data_2 / ($stepsvar - 1) );
				my $floorvalue_data_2 = ($data_2__ - ($swing_data_2 / 2) );
				my $new_data_2 = $floorvalue_data_2 + ($counterstep * $pace_data_2);
				if ($swing_data_2 == 0) { $new_data_2 = ""; }

				my $pace_data_3 =  ( $swing_data_3 / ($stepsvar - 1) ); 
				my $floorvalue_data_3 = ($data_3__ - ($swing_data_3 / 2) );
				my $new_data_3 = $floorvalue_data_3 + ($counterstep * $pace_data_3 );
				if ($swing_data_3 == 0) { $new_data_3 = ""; }

				my $pace_data_4 =  ( $swing_data_4 / ($stepsvar - 1) ); 
				my $floorvalue_data_4 = ($data_4__ - ($swing_data_4 / 2) );
				my $new_data_4 = $floorvalue_data_4 + ($counterstep * $pace_data_4 );
				if ($swing_data_4 == 0) { $new_data_4 = ""; }

				$new_data_1 = sprintf("%.3f", $new_data_1);
				$new_data_2 = sprintf("%.3f", $new_data_2);
				$new_data_3 = sprintf("%.3f", $new_data_3);
				$new_data_4 = sprintf("%.3f", $new_data_4);
				$new_data_4 = sprintf("%.3f", $new_data_4);

				push(@new_components, [ $new_component_letter, $new_fluid, $new_type, $new_data_1, $new_data_2, $new_data_3, $new_data_4 ] );
			}
		}
	} # END SUB calc_newnet

	calc_newnet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@nodebulk, \@componentbulk, \@node, \@component);	# PLURAL

	apply_node_changes($exeonfiles, \@new_nodes);
	apply_component_changes($exeonfiles, \@new_components);

} # END SUB vary_net.


sub read_net
{
	my $sourceaddress = shift;
	my $targetaddress = shift;
	# checkfile($sourceaddress, $targetaddress); # THIS HAS TO BE _FIXED!_
	my $swap = shift;
	my @node_letters = @$swap;
	my $swap = shift;
	my @component_letters = @$swap;

	open( SOURCEFILE, $sourceaddress ) or die "Can't open $sourcefile : $!\n";
	my @lines = <SOURCEFILE>;
	close SOURCEFILE;
	my $counterlines = 0;
	my $countnode = -1;
	my $countcomponent = -1;
	my $countcomp = 0;
	my $semaphore_node = "no";
	my $semaphore_component = "no";
	my $semaphore_connection = "no";
	my ($component_letter, $type, $data_1, $data_2, $data_3, $data_4);
	foreach my $line (@lines)
	{
		if ( $line =~ m/Fld. Type/ )
		{
			$semaphore_node = "yes";
		}
		if ( $semaphore_node eq "yes" )
		{
			$countnode++;
		}
		if ( $line =~ m/Type C\+ L\+/ )
		{
			$semaphore_component = "yes";
			$semaphore_node = "no";
		}



		if ( ($semaphore_node eq "yes") and ( $semaphore_component eq "no" ) and ( $countnode >= 0))
		{
			$line =~ s/^\s+//; 
			my @row = split(/\s+/, $line);
			my $node_letter = $node_letters[$countnode];
			my $fluid = $row[1];
			my $type = $row[2];
			my $height = $row[3];
			my $data_2 = $row[6]; # volume or azimuth
			my $data_1 = $row[5]; #surface
			push(@node, [ $node_letter, $fluid, $type, $height, $data_2, $data_1 ] ); # PLURAL
		}

		if ( $semaphore_component eq "yes" )
		{
			$countcomponent++;
		}

		if ( $line =~ m/\+Node/ )
		{
			$semaphore_connection = "yes";
			$semaphore_component = "no";
			$semaphore_node = "no";
		}

		if ( ($semaphore_component eq "yes") and ( $semaphore_connection eq "no" ) and ( $countcomponent > 0))
		{
			$line =~ s/^\s+//; 
			my @row = split(/\s+/, $line);
			if ($countcomponent % 2 == 1) # $number is odd 
			{ 
				$component_letter = $component_letters[$countcomp];
				$fluid = $row[0];
				$type = $row[1];
				if ($type eq "110") { $type = "k";}
				if ($type eq "120") { $type = "l";}
				if ($type eq "130") { $type = "m";}
				$countcomp++;
			}
			else # $number is even 
			{ 
				$data_1 = $row[1];
				$data_2 = $row[2];
				$data_3 = $row[3];
				$data_4 = $row[4];
				push( @component, [ $component_letter, $fluid, $type, $data_1, $data_2, $data_3, $data_4 ] ); # PLURAL
			}

		}

		$counterlines++;
	}
} # END SUB read_controls.


sub apply_node_changes
{ 	# TO BE CALLED WITH: apply_node_changes($exeonfiles, \@new_nodes);
	# THIS APPLIES CHANGES TO NODES IN NETS
	my $exeonfiles = shift;
	my $swap = shift;
	my @new_nodes = @$swap;
	my $swap = shift;
	my @tempnodes = @$swap;


	my $counternode = 0;
	foreach my $elm (@new_nodes)
	{
		my @node_ = @{$elm};
		my $new_node_letter = $node_[0];
		my $new_fluid = $node_[1];
		my $new_type = $node_[2];
		my $new_zone = $node_[3];
		my $new_height = $node_[4];
		my $new_data_2 = $node_[5];
		my $new_surface = $node_[6];
		my $new_cp = $node_[7];

		unless ( @{$new_nodes[$counternode]} ~~ @{$tempnodes[$counternode]} )
		{
			if ($new_type eq "a" ) # IF NODES ARE INTERNAL
			{
				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
e
c

n
c
$new_node_letter

$new_fluid
$new_type
y
$new_zone
$new_data_2
$new_height
a

-
-
y

y
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{
					print `$printthis`;
				}
				print TOSHELL $printthis;
			}

			if ($new_type eq "e" ) # IF NODES ARE BOUNDARY ONES, WIND-INDUCED
			{
				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
e
c

n
c
$new_node_letter

$new_fluid
$new_type
$new_zone
$new_surface
$new_cp
y
$new_data_2
$new_height
-
-
y

y
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{
					print `$printthis`;
				}
				print TOSHELL $printthis;
			}
		}
		$counternode++;
	}
} # END SUB apply_node_changes;



sub apply_component_changes
{ 	# TO BE CALLED WITH: apply_component_changes($exeonfiles, \@new_components);
	# THIS APPLIES CHANGES TO COMPONENTS IN NETS
	my $exeonfiles = shift;
	my $swap = shift;
	my @new_components = @$swap; # [ $new_component_letter, $new_type, $new_data_1, $new_data_2, $new_data_3, $new_data_4 ] 
	my $swap = shift;
	my @tempcomponents = @$swap;

	my $countercomponent = 0;
	foreach my $elm (@new_components)
	{
		my @component_ = @{$elm};
		my $new_component_letter = $component_[0];
		my $new_fluid = $component_[1];
		my $new_type = $component_[2];
		my $new_data_1 = $component_[3];
		my $new_data_2 = $component_[4];
		my $new_data_3 = $component_[5];
		my $new_data_4 = $component_[6];

		unless
		( @{$new_components[$countercomponents]} ~~ @{$tempcomponents[$countercomponents]} )
		{
			if ($new_type eq "k" ) # IF THE COMPONENT IS A GENERIC OPENING
			{
				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
e
c

n
d
$new_component_letter
$new_fluid
$new_type
-
$new_data_1
-
-
y

y
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{
					print `$printthis`;
				}
				print TOSHELL $printthis;
			}

			if ($new_type eq "l" ) # IF THE COMPONENT IS A CRACK
			{
				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
e
c

n
d
$new_component_letter
$new_fluid
$new_type
-
$new_data_1 $new_data_2
-
-
y

y
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{
					print `$printthis`;
				}
				print TOSHELL $printthis;
			}

			if ($new_type eq "m" ) # IF THE COMPONENT IS A DOOR
			{
				my $printthis =
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
e
c

n
d
$new_component_letter
$new_fluid
$new_type
-
$new_data_1 $new_data_2 $new_data_3 $new_data_4
-
-
y

y
-
-
YYY
";
				if ($exeonfiles eq "y") 
				{
					print `$printthis`;
				}
				print TOSHELL $printthis;
			}
		}
		$countercomponent++;
	}
} # END SUB apply_component_changes;


sub constrain_net 
{	# IT ALLOWS TO MANIPULATE USER-IMPOSED CONSTRAINTS REGARDING NETS
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap = shift;
	my @constrain_net = @$swap;
	my $to_do = shift;


	my $elm = $constrain_net[$counterzone];
	my @group = @{$elm};
	my $sourcefile = $group[2];
	my $targetfile = $group[3];
	my $configfile = $group[4];
	my $sourceaddress = "$to$sourcefile";
	my $targetaddress = "$to$targetfile";
	my $configaddress = "$to$configfile";

	my $node = 0;
	my $fluid = 1;
	my $type = 2;
	my $height = 3;
	my $volume = 4;
	my $volume = 4;
	my $azimuth = 4;
	my $component = 0;
	my $area = 3;
	my $width = 4;
	my $length = 5;
	my $door_width = 4;
	my $door_height = 5;
	my $door_nodeheight = 6;
	my $door_discharge = 7;

	my $activezone = $applytype[$counterzone][3];
	my ($semaphore_node, $semaphore_component, $node_letter);
	my $counter_component = -1;
	my $counterline = 0;
	my @node_letters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "l", "m", "n", "o", "p", "q", "r", "s"); # CHECK IF THE LAST LETTERS ARE CORRECT, ZZZ
	my @component_letters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "l", "m", "n", "o", "p", "q", "r", "s"); # CHECK IF THE LAST LETTERS ARE CORRECT, ZZZ
	my $countnode = 0;
	my $countcomponent = 0;

	#@node; @component; # PLURAL! DON'T PUT "MY" HERE. GLOBAL.
	#@new_nodes; @new_components; # DON'T PUT "my" HERE. THEY ARE GLOBAL!!!

	unless ($to_do eq "justwrite")
	{
		checkfile($sourceaddress, $targetaddress);
		if ($counterstep == 1)
		{
			read_net($sourceaddress, $targetaddress, \@node_letters, \@component_letters);
			read_net_constraints
			($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $configaddress, \@node, \@component, \@tempnode, \@tempcomponent); # PLURAL
		}
	}

	unless ($to_do eq "justread")
	{
		apply_node_changes($exeonfiles, \@donode, \@tempnode); #PLURAL
		apply_component_changes($exeonfiles, \@docomponent, \@tempcomponent);
	}
} # END SUB constrain_net.

sub read_net_constraints
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $configaddress = shift;
	my $swap = shift;
	@node = @$swap; # PLURAL
	my $swap = shift;
	@component = @$swap;
	my $swap = shift;
	@tempnode = @$swap;
	my $swap = shift;
	@tempcomponent = @$swap;


	unshift (@node, []); # PLURAL
	unshift (@component, []);
	if (-e $configaddress) # TEST THIS
	{	# THIS APPLIES CONSTRAINST, THE FLATTEN THE HIERARCHICAL STRUCTURE OF THE RESULTS,
		# TO BE PREPARED THEN FOR BEING APPLIED TO CHANGE PROCEDURES. IT IS TO BE TESTED.

		push (@node, [@mynode]); #
		push (@component, [@mycomponent]); #

		eval `cat $configaddress`;	# HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS 
		# IS EVALUATED, AND HERE BELOW CONSTRAINTS ARE PROPAGATED.
		# THIS FILE CAN CONTAIN USER-IMPOSED CONSTRAINTS FOR MASS-FLOW NETWORKS TO BE READ BY OPTS.
		# IT MAKES AVAILABLE VARIABLES REGARDING THE SETTING OF NODES IN A NETWORK.
		# CURRENTLY: INTERNAL UNKNOWN AIR NODES AND BOUNDARY WIND-CONCERNED NODES.
		# IT MAKES AVAILABLE VARIABLES REGARDING COMPONENTS
		# CURRENTLY: WINDOWS, CRACKS, DOORS.
		# ALSO, THIS MAKES AVAILABLE TO THE USER INFORMATIONS ABOUT THE MORPHING STEP OF THE MODELS.
		# SPECIFICALLY, THE FOLLOWING VARIABLES WHICH REGARD BOTH INTERNAL AND BOUNDARY NODES.
		# NOTE THAT "node_number" IS THE NUMBER OF THE NODE IN THE ".afn" ESP-r FILE. 
		# $node[$counterzone][node_number][$node]. # EXAMPLE: $node[0][3][$node]. THIS IS THE LETTER OF THE THIRD NODE, 
		# AT THE FIRST CONTERZONE (NUMBERING STARTS FROM 0)
		# $node[$counterzone][node_number][$type]
		# $node[$counterzone][node_number][$height]. # EXAMPLE: $node[0][3][$node]. THIS IS THE HEIGHT OF THE 3RD NODE AT THE FIRST COUNTERZONE
		# THEN IT MAKES AVAILABLE THE FOLLOWING VARIABLES REGARDING NODES:
		# $node[$counterzone][node_number][$volume] # REGARDING INTERNAL NODES
		# $node[$counterzone][node_number][$azimut] # REGARDING BOUNDARY NODES
		# THEN IT MAKE AVAILABLE THE FOLLOWING VARIABLES REGARDING COMPONENTS:
		# $node[$counterzone][node_number][$area] # REGARDING SIMPLE OPENINGS
		# $node[$counterzone][node_number][$width] # REGARDING CRACKS
		# $node[$counterzone][node_number][$length] # REGARDING CRACKS
		# $node[$counterzone][node_number][$door_width] # REGARDING DOORS
		# $node[$counterzone][node_number][$door_height] # REGARDING DOORS
		# $node[$counterzone][node_number][$door_nodeheight] # REGARDING DOORS
		# $node[$counterzone][node_number][$door_discharge] # REGARDING DOORS (DISCHARGE FACTOR)
		# ALSO, THIS MAKES AVAILABLE TO THE USER INFORMATIONS ABOUT THE MORPHING STEP OF THE MODELS 
		# AND THE STEPS THE MODEL HAVE TO FOLLOW.
		# THIS ALLOWS TO IMPOSE EQUALITY CONSTRAINTS TO THESE VARIABLES, 
		# WHICH COULD ALSO BE COMBINED WITH THE FOLLOWING ONES: 
		# $stepsvar, WHICH TELLS THE PROGRAM HOW MANY ITERATION STEPS IT HAS TO DO IN THE CURRENT MORPHING PHASE.
		# $counterzone, WHICH TELLS THE PROGRAM WHAT OPERATION IS BEING EXECUTED IN THE CHAIN OF OPERATIONS 
		# THAT MAY BE EXECUTES AT EACH MORPHING PHASE. EACH $counterzone WILL CONTAIN ONE OR MORE ITERATION STEPS.
		# TYPICALLY, IT WILL BE USED FOR A ZONE, BUT NOTHING PREVENTS THAT SEVERAL OF THEM CHAINED ONE AFTER 
		# THE OTHER ARE APPLIED TO THE SAME ZONE.
		# $counterstep, WHICH TELLS THE PROGRAM WHAT THE CURRENT ITERATION STEP IS.
		# The $counterzone that is actuated is always the last, the one which is active. 
		# It would have therefore no sense writing $node[0][3][$node] =  $node[1][3][$node].
		# Differentent $counterzones can be referred to the same zone. Different $counterzones just number mutations in series.

		if (-e $constrain) { eval "$constrain"; } # HERE THE INSTRUCTION WRITTEN IN THE OPTS CONFIGURATION FILE CAN BE SPEFICIED
		# FOR PROPAGATION OF CONSTRAINTS

		@donode = @{$node[$#node]}; #
		@docomponent = @{$component[$#component]}; #

		shift (@donode);
		shift (@docomponent);
	}
} # END SUB read_net_constraints

##############################################################################
##############################################################################
# END OF SECTION DEDICATED TO FUNCTIONS FOR CONSTRAINING MASS-FLOW NETWORKS



##############################################################################
##############################################################################
# BEGINNING OF SECTION DEDICATED TO GENERIC FUNCTIONS FOR PROPAGATING CONSTRAINTS

sub propagate_constraints
{
	# THIS FUNCTION ALLOWS TO MANIPULATE COMPOUND USER-IMPOSED CONSTRAINTS.
	# IT COMPOUNDS ALL FOUR PRINCIPAL PROPAGATION TYPES. THAT MEANS THAT ONE COULD DO
	# ANY TYPE OF THE AVAILABLE PROPAGATIONS JUST USING THIS FUNCTION.
	# IT MAKES AVAILABLE TO THE USER THE FOLLOWING VARIABLES FOR MANIPULATION.

	# REGARDING GEOMETRY:
	# $v[$counterzone][$number][$x], $v[$counterzone][$number][$y], $v[$counterzone][$number][$z]. EXAMPLE: $v[0][4][$x] = 1. 
	# OR: @v[0][4][$x] =  @v[0][4][$y]. OR EVEN: @v[1][4][$x] =  @v[0][3][$z].

	# REGARDING OBSTRUCTIONS:
	# $obs[$counterzone][$obs_number][$x], $obs[$counterzone][$obs_number][$y], $obs[$counterzone][$obs_number][$y]
	# $obs[$counterzone][$obs_number][$width], $obs[$counterzone][$obs_number][$depth], $obs[$counterzone][$obs_number][$height]
	# $obs[$counterzone][$obs_number][$z_rotation], $obs[$counterzone][$obs_number][$y_rotation], 
	# $obs[$counterzone][$obs_number][$tilt], $obs[$counterzone][$obs_number][$opacity], $obs[$counterzone][$obs_number][$material], 
	# EXAMPLE: $obs[0][2][$x] = 2. THIS MEANS: AT COUNTERZONE 0, COORDINATE x OF OBSTRUCTION HAS TO BE SET TO 2.
	# OTHER EXAMPLE: $obs[0][2][$x] = $obs[2][2][$y].
	# NOTE THAT THE MATERIAL TO BE SPECIFIED IS A MATERIAL LETTER, BETWEEN QUOTES! EXAMPLE: $obs[1][$material] = "a".
	#  $tilt IS PRESENTLY UNUSED.

	# REGARDING MASS-FLOW NETWORKS:
	# @node and @component.
	# CURRENTLY: INTERNAL UNKNOWN AIR NODES AND BOUNDARY WIND-CONCERNED NODES.
	# IT MAKES AVAILABLE VARIABLES REGARDING COMPONENTS
	# CURRENTLY: WINDOWS, CRACKS, DOORS.
	# ALSO, THIS MAKES AVAILABLE TO THE USER INFORMATIONS ABOUT THE MORPHING STEP OF THE MODELS.
	# SPECIFICALLY, THE FOLLOWING VARIABLES WHICH REGARD BOTH INTERNAL AND BOUNDARY NODES.
	# NOTE THAT "node_number" IS THE NUMBER OF THE NODE IN THE ".afn" ESP-r FILE. 
	# 1) $loopcontrol[$counterzone][$countloop][$countloopcontrol][$loop_hour] 
	# Where $countloop and  $countloopcontrol has to be set to a specified number in the OPTS file for constraints.
	# 2) $loopcontrol[$counterzone][$countloop][$countloopcontrol][$max_heating_power] # Same as above.
	# 3) $loopcontrol[$counterzone][$countloop][$countloopcontrol][$min_heating_power] # Same as above.
	# 4) $loopcontrol[$counterzone][$countloop][$countloopcontrol][$max_cooling_power] # Same as above.
	# 5) $loopcontrol[$counterzone][$countloop][$countloopcontrol][$min_cooling_power] # Same as above.
	# 6) $loopcontrol[$counterzone][$countloop][$countloopcontrol][heating_setpoint] # Same as above.
	# 7) $loopcontrol[$counterzone][$countloop][$countloopcontrol][cooling_setpoint] # Same as above.
	# 8) $flowcontrol[$counterzone][$countflow][$countflowcontrol][$flow_hour] 
	# Where $countflow and  $countflowcontrol has to be set to a specified number in the OPTS file for constraints.
	# 9) $flowcontrol[$counterzone][$countflow][$countflowcontrol][$flow_setpoint] # Same as above.
	# 10) $flowcontrol[$counterzone][$countflow][$countflowcontrol][$flow_onoff] # Same as above.
	# 11) $flowcontrol[$counterzone][$countflow][$countflowcontrol][$flow_fraction] # Same as above.
	# EXAMPLE : $flowcontrol[0][1][2][$flow_fraction] = 0.7
	# OTHER EXAMPLE: $flowcontrol[2][1][2][$flow_fraction] = $flowcontrol[0][2][1][$flow_fraction]

	# REGARDING CONTROLS:
	# IT MAKES AVAILABLE VARIABLES REGARDING COMPONENTS
	# CURRENTLY: WINDOWS, CRACKS, DOORS.
	# ALSO, THIS MAKES AVAILABLE TO THE USER INFORMATIONS ABOUT THE MORPHING STEP OF THE MODELS.
	# SPECIFICALLY, THE FOLLOWING VARIABLES WHICH REGARD BOTH INTERNAL AND BOUNDARY NODES.
	# NOTE THAT "node_number" IS THE NUMBER OF THE NODE IN THE ".afn" ESP-r FILE. 
	# $node[$counterzone][node_number][$node]. # EXAMPLE: $node[0][3][$node]. THIS IS THE LETTER OF THE THIRD NODE, 
	# AT THE FIRST CONTERZONE (NUMBERING STARTS FROM 0)
	# $node[$counterzone][node_number][$type]
	# $node[$counterzone][node_number][$height]. # EXAMPLE: $node[0][3][$node]. THIS IS THE HEIGHT OF THE 3RD NODE AT THE FIRST COUNTERZONE
	# THEN IT MAKES AVAILABLE THE FOLLOWING VARIABLES REGARDING NODES:
	# $node[$counterzone][node_number][$volume] # REGARDING INTERNAL NODES
	# $node[$counterzone][node_number][$azimut] # REGARDING BOUNDARY NODES
	# THEN IT MAKE AVAILABLE THE FOLLOWING VARIABLES REGARDING COMPONENTS:
	# $node[$counterzone][node_number][$area] # REGARDING SIMPLE OPENINGS
	# $node[$counterzone][node_number][$width] # REGARDING CRACKS
	# $node[$counterzone][node_number][$length] # REGARDING CRACKS
	# $node[$counterzone][node_number][$door_width] # REGARDING DOORS
	# $node[$counterzone][node_number][$door_height] # REGARDING DOORS
	# $node[$counterzone][node_number][$door_nodeheight] # REGARDING DOORS
	# $node[$counterzone][node_number][$door_discharge] # REGARDING DOORS (DISCHARGE FACTOR)

	# ALSO, THIS KIND OF FILE MAKES INFORMATION AVAILABLE ABOUT 
	# THE MORPHING STEP OF THE MODELS AND THE STEPS THE MODEL HAVE TO FOLLOW.
	# THIS ALLOWS TO IMPOSE EQUALITY CONSTRAINTS TO THESE VARIABLES, 
	# WHICH COULD ALSO BE COMBINED WITH THE FOLLOWING ONES: 
	# $stepsvar, WHICH TELLS THE PROGRAM HOW MANY ITERATION STEPS IT HAS TO DO IN THE CURRENT MORPHING PHASE.
	# $counterzone, WHICH TELLS THE PROGRAM WHAT OPERATION IS BEING EXECUTED IN THE CHAIN OF OPERATIONS 
	# THAT MAY BE EXECUTES AT EACH MORPHING PHASE. EACH $counterzone WILL CONTAIN ONE OR MORE ITERATION STEPS.
	# TYPICALLY, IT WILL BE USED FOR A ZONE, BUT NOTHING PREVENTS THAT SEVERAL OF THEM CHAINED ONE AFTER 
	# THE OTHER ARE APPLIED TO THE SAME ZONE.
	# $counterstep, WHICH TELLS THE PROGRAM WHAT THE CURRENT ITERATION STEP IS.

	# The $counterzone that is actuated is always the last, the one which is active. 
	# It would have therefore no sense writing for example @v[0][4][$x] =  @v[1][2][$y], because $counterzone 0 is before than $counterzone 1.
	# Also, it would not have sense setting $counterzone 1 if the current $counterzone is already 2.
	# Differentent $counterzones can be referred to the same zone. Different $counterzones just number mutations in series.

	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my ($justread, $justwrite);
	my @applytype = @$swap;
	my $zone_letter = $applytype[$counterzone][3];
	my $swap = shift;
	my @propagate_constraints = @$swap;


	my $zone = $applytype[$counterzone][3];
	my $counter = 0;
	my @group = @{$propagate_constraints[$counterzone]};
	foreach my $elm (@group)
	{
		if ($counter > 0)
		{
			my @items = @{$elm};
			my $what_to_do = $items[0];
			my $sourcefile = $items[1];
			my $targetfile = $items[2];
			my $configfile = $items[3];
			if ($what_to_do eq "read_geo")
			{
				$to_do = "justread";
				my @vertex_letters = @{$items[4]};
				my $long_menus = $items[5];
				my @constrain_geometry = ( [ "", $zone,  $sourcefile, $targetfile, $configfile , \@vertex_letters, $long_menus ] );
				constrain_geometry($to, $fileconfig, $stepsvar, $counterzone, 
				$counterstep, $exeonfiles, \@applytype, \@constrain_geometry, $to_do);

			}
			if ($what_to_do eq "read_obs")
			{
				$to_do = "justread";
				my @obs_letters = @{$items[4]};
				my $act_on_materials = $items[5];
				my @constrain_obstructions = ( [ "", $applytype[$counterzone][3], $sourcefile, $targetfile, $configfile , \@obs_letters, $act_on_materials ] );
				constrain_obstructions($to, $fileconfig, $stepsvar, $counterzone, 
				$counterstep, $exeonfiles, \@applytype, \@constrain_obstructions, $to_do);
			}
			if ($what_to_do eq "read_ctl")
			{
				$to_do = "justread";
				my @constrain_controls = ( [ "", $zone, $sourcefile, $targetfile, $configfile ] );
				constrain_controls($to, $fileconfig, $stepsvar, $counterzone, 
				$counterstep, $exeonfiles, \@applytype, \@constrain_controls, $to_do);
			}
			if ($what_to_do eq "read_net")
			{
				$to_do = "justread";
				my @surfaces = @{$items[4]};
				my @cps = @{$items[5]};
				my @constrain_net = ( [ "", $zone, $sourcefile, $targetfile, $configfile , \@surfaces, \@cps ] );
				constrain_net($to, $fileconfig, $stepsvar, $counterzone, 
				$counterstep, $exeonfiles, \@applytype, \@constrain_net, $to_do);
			}

			if ($what_to_do eq "write_geo")
			{
				$to_do = "justwrite";
				my @vertex_letters = @{$items[4]};
				my $long_menus = $items[5];
				my @constrain_geometry = ( [ "", $zone,  $sourcefile, $targetfile, $configfile , \@vertex_letters, $long_menus ] );
				constrain_geometry($to, $fileconfig, $stepsvar, $counterzone, 
				$counterstep, $exeonfiles, \@applytype, \@constrain_geometry, $to_do);
			}
			if ($what_to_do eq "write_obs")
			{
				$to_do = "justwrite";
				my @obs_letters = @{$items[4]};
				my $act_on_materials = $items[5];
				my @constrain_obstructions = ( [ "", $zone, $sourcefile, $targetfile, $configfile , \@obs_letters, $act_on_materials] );
				constrain_obstructions($to, $fileconfig, $stepsvar, $counterzone, 
				$counterstep, $exeonfiles, \@applytype, \@constrain_obstructions, $to_do);
			}
			if ($what_to_do eq "write_ctl")
			{
				$to_do = "justwrite";
				my @constrain_controls = ( [ "", $zone, $sourcefile, $targetfile, $configfile ] );
				constrain_controls($to, $fileconfig, $stepsvar, $counterzone, 
				$counterstep, $exeonfiles, \@applytype, \@constrain_controls, $to_do);
			}
			if ($what_to_do eq "write_net")
			{
				$to_do = "justwrite";
				my @surfaces = @{$items[4]};
				my @cps = @{$items[5]};
				my @constrain_net = ( [ "", $zone, $sourcefile, $targetfile, $configfile , \@surfaces, \@cps ] );
				constrain_net($to, $fileconfig, $stepsvar, $counterzone, 
				$counterstep, $exeonfiles, \@applytype, \@constrain_net, $to_do);
			}		
		}
		$counter++;
	}
}

##############################################################################
##############################################################################
# END OF SECTION DEDICATED TO GENERIC FUNCTIONS FOR PROPAGATING CONSTRAINTS



# END OF THE CONTENT OF THE "opts_morph.pl" FILE.
#########################################################################################
#########################################################################################
							#########################################################################################
												
								my $yes_or_no_rotate_obstructions = "$$rotate[$counterzone][1]" ; 
								# WHY $BRING_CONSTRUCTION_BACK DOES NOT WORK IF THESE TWO VARIABLES ARE PRIVATE?
								my $yes_or_no_keep_some_obstructions = "$$keep_obstructions[$counterzone][0]";    
								print `cd $to`;
								print TOSHELL "cd $to\n\n";

								my $countercycles_transl_surfs = 0;				
	
								eval `cat /home/luca/Sim-OPTS/stuff1.pl`; # ZZZZ HERE stuff1.pl
								if ( $stepsvar > 1)
								{	
									sub dothings
									{	# THIS CONTAINS FUNCTIONS THAT APPLY CONSTRAINTS AND UPDATE CALCULATIONS.							
										#if ( $get_obstructions[$counterzone][0] eq "y" )
										#{ 
										#	get_obstructions # THIS IS TO MEMORIZE OBSTRUCTIONS.
										#	# THEY WILL BE SAVED IN A TEMPORARY FILE.
										#	($to, $fileconfig, $stepsvar, $counterzone, 
										#	$counterstep, $exeonfiles, \@applytype, \@get_obstructions); 
										#}
										if ($propagate_constraints[$counterzone][0] eq "y") 
										{ 
											&propagate_constraints
											($to, $fileconfig, $stepsvar, $counterzone, 
											$counterstep, $exeonfiles, \@applytype, \@propagate_constraints); 
										}
										if ($apply_constraints[$counterzone][0] eq "y") 
										{ 
											&apply_constraints
											($to, $fileconfig, $stepsvar, $counterzone, 
											$counterstep, $exeonfiles, \@applytype, \@constrain_geometry); 
										}
										if ($constrain_geometry[$counterzone][0] eq "y") 
										{ 
											&constrain_geometry
											($to, $fileconfig, $stepsvar, $counterzone, 
											$counterstep, $exeonfiles, \@applytype, \@constrain_geometry); 
										}
										if ($constrain_controls[$counterzone][0] eq "y") 
										{ 
											&constrain_controls
											($to, $fileconfig, $stepsvar, $counterzone, 
											$counterstep, $exeonfiles, \@applytype, \@constrain_controls); 
										}
										if ($$keep_obstructions[$counterzone][0] eq "y") # TO BE SUPERSEDED BY get_obstructions AND pin_obstructions
										{ 
											&bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, 
											$counterstep, $exeonfiles, \@applytype, $keep_obstructions); 
										}
										if ($constrain_net[$counterzone][0] eq "y")
										{ 
											&constrain_net($to, $fileconfig, $stepsvar, $counterzone, 
											$counterstep, $exeonfiles, \@applytype, \@constrain_net, $to_do); 
										}
										if ($recalculatenet[0] eq "y") 
										{ 
											&recalculatenet
											($to, $fileconfig, $stepsvar, $counterzone, 
											$counterstep, $exeonfiles, \@applytype, \@recalculatenet); 
										}
										if ($constrain_obstructions[$counterzone][0] eq "y") 
										{ 
											&constrain_obstructions
											($to, $fileconfig, $stepsvar, $counterzone, 
											$counterstep, $exeonfiles, \@applytype, \@constrain_obstructions, $to_do); 
										}
										#if ( $pin_obstructions[$counterzone][0] eq "y" ) 
										#{ 
										#	pin_obstructions ($to, $fileconfig, $stepsvar, $counterzone, 
										#	$counterstep, $exeonfiles, \@applytype, $zone_letter, \@pin_obstructions); 
										#}
										if ($recalculateish eq "y") 
										{ 
											&recalculateish
											($to, $fileconfig, $stepsvar, $counterzone, 
											$counterstep, $exeonfiles, \@applytype, \@recalculateish); 
										}
										if ($daylightcalc[0] eq "y") 
										{ 
											&daylightcalc
											($to, $fileconfig, $stepsvar, $counterzone,  
											$counterstep, $exeonfiles, \@applytype, $filedf, \@daylightcalc); 
										}
									} # END SUB DOTHINGS
		
									if ( $modification_type eq "generic_change" )#
									{
										&make_generic_change
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $exeonfiles,
										\@applytype, $generic_change);
										&dothings;
									} #
									elsif ( $modification_type eq "surface_translation_simple" )
									{
										&translate_surfaces_simple
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, $translate_surface_simple);
										&dothings;
									} 
									elsif ( $modification_type eq "surface_translation" )
									{
										&translate_surfaces
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, $translate_surface);
										&dothings;
									} 
									elsif ( $modification_type eq "surface_rotation" )              #
									{
										&rotate_surface
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, $rotate_surface);
										&dothings;
									} 
									elsif ( $modification_type eq "vertexes_shift" )
									{
										&shift_vertexes
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, $shift_vertexes);
										&dothings;
									}
									elsif ( $modification_type eq "vertex_translation" )
									{
										&translate_vertexes
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, \@translate_vertexes);                         
										&dothings;
									}  
									elsif ( $modification_type eq "construction_reassignment" )
									{
										&reassign_construction
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, $construction_reassignment);
										&dothings;
									} 
									elsif ( $modification_type eq "rotation" )
									{
										&rotate
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, $rotate);
										&dothings;
									} 
									elsif ( $modification_type eq "translation" )
									{
										&translate
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, $translate, $toshell, $outfile, $configfile);
										&dothings;
									} 
									elsif ( $modification_type eq "thickness_change" )
									{
										&change_thickness
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, $thickness_change);
										&dothings;
									} 
									elsif ( $modification_type eq "rotationz" )
									{
										&rotatez
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, $rotatez);
										&dothings;
									} 
									elsif ( $modification_type eq "change_config" )
									{
										&change_config
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, \@change_config);
										&dothings;
									}
									elsif ( $modification_type eq "window_reshapement" ) 
									{
										&reshape_windows
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, \@reshape_windows);					
										&dothings;
									}
									elsif ( $modification_type eq "obs_modification" )  # REWRITE FOR NEW GEO FILE?
									{
										&obs_modify
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, $obs_modify);
										&dothings;
									}
									elsif ( $modification_type eq "warping" )
									{
										&warp
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, $warp);
										&dothings;
									}
									elsif ( $modification_type eq "vary_controls" )
									{
										&vary_controls
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, \@vary_controls);
										&dothings;
									}
									elsif ( $modification_type eq "vary_net" )
									{
										&vary_net
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, \@vary_net);
										&dothings;
									}
									elsif ( $modification_type eq "change_climate" )
									{
										&change_climate
										($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
										$exeonfiles, \@applytype, \@change_climate);
										&dothings;
									} 
									elsif ( $modification_type eq "constrain_controls" )
									{
										&dothings;
									}
									#elsif ( $modification_type eq "get_obstructions" )
									#{
									#	dothings;
									#}
									#elsif ( $modification_type eq "pin_obstructions" )
									#{
									#	dothings;
									#}
									elsif ( $modification_type eq "constrain_geometry" )
									{
										&dothings;
									}
									elsif ( $modification_type eq "apply_constraints" )
									{
										&dothings;
									}
									elsif ( $modification_type eq "constrain_net" )
									{
										&dothings;
									}
									elsif ( $modification_type eq "propagate_net" )
									{
										&dothings;
									}
									elsif ( $modification_type eq "recalculatenet" )
									{
										&dothings;
									}
									elsif ( $modification_type eq "constrain_obstructions" )
									{
										&dothings;
									}
									elsif ( $modification_type eq "propagate_constraints" )
									{
										&dothings;
									}
								}
								$counterzone++;
								print `cd $mypath`;
								print TOSHELL "cd $mypath\n\n";
							}	
							$counterstep++ ; 
						}
					}
					if ($countvar == $#varnumbers)
					{
						my @files_to_erase = grep -d, <$mypath/models/$file*_>;
						foreach my $file (@files_to_erase)
						{
							if ($exeonfiles = "y") { print `rm -R $file`; }
							print TOSHELL "rm -R $file";
						}
					}
					$countvar++;
				}
				close MORPHFILE;

				close CASELIST;
			}    # END SUB morph
			##############################################################################
			##############################################################################
			##############################################################################	

			# BEGINNING OF SUB SIM
			##############################################################################
			##############################################################################
			##############################################################################

			# HERE FOLLOWES THE CONTENT OF THE "sim.pm" FILE, WHICH HAS BEEN MERGED HERE
			# TO AVOID COMPLICATIONS WITH THE PERL MODULE INSTALLATION.

			# HERE FOLLOWS THE "sim" FUNCTION, CALLED FROM THE MAIN PROGRAM FILE.
			# IT ALSO RETRIEVES RESULTS. THE TWO OPERATIONS ARE CONTROLLED SEPARATELY 
			# FROM THE OPTS CONFIGURATION FILE.

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
				my @simtitles = @$swap;
				my $preventsim = shift;
				my $exeonfiles = shift;
				my $fileconfig = shift;
				my $swap = shift;
				my @themereports = @$swap;
				my $swap = shift;
				my @reporttitles = @$swap;
				my $swap = shift;
				my @retrievedata = @$swap;

				my $countersimmax = ( ( $#simdata + 1 ) / 4 );
				open(MORPHFILE, $morphfile) or die "Can't open  $morphfile $!";
				#@dirs_to_simulate = grep -d, <$mypath/$filenew*>;
				@dirs_to_simulate = <MORPHFILE>;
				close MORPHFILE;
				print OUTFILE "\$morphfile: $morphfile. \@dirs_to_simulate: " . Dumper(@dirs_to_simulate) . "\n";
				my @ress;
				my @flfs;

				open (SIMLIST, ">$simlistfile") or die;

				my $countdir = 0;
				foreach my $dir_to_simulate (@dirs_to_simulate)
				{
					chomp($dir_to_simulate);
					my $countersim = 0;	
					foreach my $date_to_sim (@simtitles)
					{
						my $simdataref = $simdata[$countersim];
						my @simdata = @{$simdataref};
						
						unless (  $preventsim eq "y")
						{
							my $resfile = "$dir_to_simulate-$date_to_sim.res";
							my $flfile = "$dir_to_simulate-$date_to_sim.fl";
							push (@ress, $resfile); 
							push (@flfs, $flfile);
	
							unless (-e $resfile )
							{
								if ( $simnetwork eq "n" )
								{
									my $printthis =
"bps -file $dir_to_simulate/cfg/$fileconfig -mode script<<XXX

c
$resfile
$simdata[0 + (4*$countersim)]
$simdata[1 + (4*$countersim)]
$simdata[2 + (4*$countersim)]
$simdata[3 + (4*$countersim)]
s
$simnetwork
Results for $dir_to_simulate-$date_to_sim
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
									if ($exeonfiles eq "y") 
									{
										print `$printthis`;
									}
									print TOSHELL $printthis;
									print SIMLIST "$resfile\n";
								}
							
								if ( $simnetwork eq "y" )
								{
									my $printthis =
"bps -file $dir_to_simulate/cfg/$fileconfig -mode script<<XXX

c
$resfile
$flfile
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
									if ($exeonfiles eq "y") 
									{
										print `$printthis`;
									}
									print TOSHELL $printthis;
									print SIMLIST "$resfile\n";
									print OUTFILE "TWO, $resfile\n";
								}						
							}			
						}
						$countersim++;
					}
					$countdir++;
				}

				close SIMLIST;
			}    # END SUB sim;				

			# END OF THE CONTENT OF THE "opts_sim.pl" FILE.
			##############################################################################
			##############################################################################
			##############################################################################



			# BEGINNING OF SUB RETRIEVE	
			##############################################################################
			##############################################################################
			##############################################################################
			sub retrieve
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
				my @simtitles = @$swap;
				my $preventsim = shift;
				my $exeonfiles = shift;
				my $fileconfig = shift;
				my $swap = shift;
				my @themereports = @$swap;
				my $swap = shift;
				my @reporttitles = @$swap;
				my $swap = shift;
				my @retrievedata = @$swap;

				unless (-e "$mypath/results") 
				{ 
					print  `mkdir $mypath/results`; 
					print TOSHELL "mkdir $mypath/results\n\n"; 
				}

				sub retrieve_temperatures_results 
				{
					my $result = shift;
					my $resfile = shift;
					my $swap = shift;
					my @retrievedatatemps = @$swap;
					my $reporttitle = shift;
					my $stripcheck = shift;
					my $theme = shift;
					#my $existingfile = "$resfile-$theme.grt";
					#if (-e $existingfile) { print `chmod 777 $existingfile\n`;} 
					#print TOSHELL "chmod 777 $existingfile\n";
					#if (-e $existingfile) { print `rm $existingfile\n` ;}
					#print TOSHELL "rm $existingfile\n";
					#if ($exeonfiles eq "y") { print `rm -f $existingfile*par\n`; }
					#print TOSHELL "rm -f $existingfile*par\n";

					unless (-e "$result-$reporttitle-$theme.grt-")
					{
						my $printthis =
"res -file $resfile -mode script<<YYY

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
$result-$reporttitle-$theme.grt
Simulation results $result-$reporttitle-$theme
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
";
					if ($exeonfiles eq "y")
					{ 
						print `$printthis`;
					}
					print TOSHELL $printthis;
				#if (-e $existingfile) { print `rm -f $existingfile*par`;}
				#print TOSHELL "rm -f $existingfile*par\n";
				}
			}

			sub retrieve_comfort_results
			{
				my $result = shift;
				my $resfile = shift;
				my $swap = shift;
				my @retrievedatacomf = @$swap;
				my $reporttitle = shift;
				my $stripcheck = shift;
				my $theme = shift;
				#my $existingfile = "$resfile-$theme.grt"; 
				#if (-e $existingfile) { print `chmod 777 $existingfile\n`;} 
				#print TOSHELL "chmod 777 $existingfile\n";
				#if (-e $existingfile) { print `rm $existingfile\n` ;}
				#print TOSHELL "rm $existingfile\n";
				#if ($exeonfiles eq "y") { print `rm -f $existingfile*par\n`;}
				#print TOSHELL "rm -f $existingfile*par\n";

				unless (-e "$result-$reporttitle-$theme.grt-")
				{
					my $printthis =
"res -file $resfile -mode script<<ZZZ

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
$result-$reporttitle-$theme.grt
Simulation results $result-$reporttitle-$theme
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
				if ($exeonfiles eq "y") 
				{ 
					print `$printthis`;
				}
				print TOSHELL $printthis;
				#if (-e $existingfile) { `rm -f $existingfile*par\n`;}
				#print TOSHELL "rm -f $existingfile*par\n";
			}
		}

		sub retrieve_loads_results
		{
			my $result = shift;
			my $resfile = shift;
			my $swap = shift;
			my @retrievedataloads = @$swap;
			my $reporttitle = shift;
			my $stripcheck = shift;
			my $theme = shift;
			#my $existingfile = "$resfile-$theme.grt";
			#if (-e $existingfile) { `chmod 777 $existingfile\n`;}
			#print TOSHELL "chmod 777 $existingfile\n";
			#if (-e $existingfile) { `rm $existingfile\n` ;}
			#print TOSHELL "rm $existingfile\n";

			unless (-e "$result-$reporttitle-$theme.grt-")
			{
				my $printthis =
"res -file $resfile -mode script<<TTT

3
$retrievedataloads[0]
$retrievedataloads[1]
$retrievedataloads[2]
d
>
a
$result-$reporttitle-$theme.grt
Simulation results $result-$reporttitle-$theme
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
				if ($exeonfiles eq "y") 
				{
					print `$printthis`;
				}
				print TOSHELL $printthis;

				print RETRIEVELIST "$result-$reporttitle-$theme.grt ";
				if ($stripcheck)
				{
					open (CHECKDATUM, "$result-$reporttitle-$theme.grt") or die;
					open (STRIPPED, ">$result-$reporttitle-$theme.grt-") or die;
					my @lines = <CHECKDATUM>;
					foreach my $line (@lines)
					{
						$line =~ s/^\s+//;
						@lineelms = split(/\s+|,/, $line);
						if ($lineelms[0] eq $stripcheck) 
						{
							print STRIPPED "$line";
						}
					}
					close STRIPPED;
					close CHECKDATUM;
				}
			}
		}

		sub retrieve_temps_stats
		{
			my $result = shift;
			my $resfile = shift;
			my $swap = shift;
			my @retrievedatatempsstats = @$swap;
			my $reporttitle = shift;
			my $stripcheck = shift;
			my $theme = shift;
			#my $existingfile = "$resfile-$theme.grt";
			#if (-e $existingfile) { `chmod 777 $existingfile\n`; }
			#print TOSHELL "chmod 777 $existingfile\n";
			#if (-e $existingfile) { `rm $existingfile\n` ;}
			#print TOSHELL "rm $existingfile\n";
			#if (-e $existingfile) { `rm -f $existingfile*par\n`;}
			#print TOSHELL "rm -f $existingfile*par\n";

			unless (-e "$result-$reporttitle-$theme.grt-")
			{
				my $printthis =
"res -file $resfile -mode script<<TTT

3
$retrievedatatempsstats[0]
$retrievedatatempsstats[1]
$retrievedatatempsstats[2]
d
>
a
$result-$reporttitle-$theme.grt
Simulation results $result-$reporttitle-$theme.grt
m
-
-
-
-
-
TTT
";

											if ($exeonfiles eq "y") 
											{ 
												print `$printthis`;
						print OUTFILE "CALLED RETRIEVE TEMPS STATS\n";
						print OUTFILE "\$resfile: $resfile, \$retrievedataloads[0]: $retrievedataloads[0], \$retrievedataloads[1]: $retrievedataloads[1], \$retrievedataloads[2]:$retrievedataloads[2]\n";
						print OUTFILE "\$reporttitle: $reporttitle, \$theme: $theme\n";
						print OUTFILE "\$resfile-\$reporttitle-\$theme: $resfile-$reporttitle-$theme";
					}
					print TOSHELL $printthis;

					#if ($exeonfiles eq "y") { print `rm -f $existingfile*par\n`;}
					#print TOSHELL "rm -f $existingfile*par\n";
					print RETRIEVELIST "$resfile-$reporttitle-$theme.grt ";
					if ($stripcheck)
					{
						open (CHECKDATUM, "$result-$reporttitle-$theme.grt") or die;
						open (STRIPPED, ">$result-$reporttitle-$theme.grt-") or die;
						my @lines = <CHECKDATUM>;
						foreach my $line (@lines)
						{
							$line =~ s/^\s+//;
							@lineelms = split(/\s+|,/, $line);
							if ($lineelms[0] eq $stripcheck) 
							{
								print STRIPPED "$line";
							}
						}
						close STRIPPED;
						close CHECKDATUM;
					}
				}
			}

			open (OPENSIMS, "$simlistfile") or die;
			my @sims = <OPENSIMS>;
			# print OUTFILE "SIMS: " . Dumper(@sims) . "\n";
			close OPENSIMS;
						
			my $countertheme = 0;
			foreach my $themereportref (@themereports)
			{
				# print OUTFILE "SIMS: \n";
				my @themereports = @{$themereportref};
				my $reporttitlesref = $reporttitles[$countertheme];
				my @reporttitles = @{$reporttitlesref};
				my $retrievedatarefsdeep = $retrievedata[$countertheme];
				my @retrievedatarefs = @{$retrievedatarefsdeep};
				my $stripcheckref = $stripchecks[$countertheme];
				my @stripckecks = @{$stripcheckref};
			
				my $countreport = 0;
				foreach my $reporttitle (@reporttitles)
				{
					# print OUTFILE "SIMS: \n";
					my $theme = $themereports[$countreport];
					my $retrieveref = $retrievedatarefs[$countreport];
					my $stripcheck = $stripckecks[$countreport];
					my @retrievedata = @{$retrieveref};
					my $countersim = 0;
					foreach my $sim (@sims)
					{
						chomp($sim);
						my $targetprov = $sim;
						$targetprov =~ s/$mypath\/models\///;
						my $result = "$mypath" . "/results/$targetprov";

						if ( $theme eq "temps" ) { &retrieve_temperatures_results($result, $sim, \@retrievedata, $reporttitle, $stripcheck, $theme); }
						if ( $theme eq "comfort"  ) { &retrieve_comfort_results($result, $sim, \@retrievedata, $reporttitle, $stripcheck, $theme); }
						if ( $theme eq "loads" ) 	{ &retrieve_loads_results($result, $sim, \@retrievedata, $reporttitle, $stripcheck, $theme); }
						if ( $theme eq "tempsstats"  ) { &retrieve_temps_stats($result, $sim, \@retrievedata, $reporttitle, $stripcheck, $theme); }
						print OUTFILE "\$sim: $sim, \$result: $result, \@retrievedata: @retrievedata, \$reporttitle: $reporttitle, \$stripcheck: $stripcheck, \$theme: $theme\n";
						$countersim++;
					}
					$countreport++;
				}
				$countertheme++;
			}
			print `rm -f ./results/*.grt`;
			print TOSHELL "rm -f ./results/*.grt\n";
			print `rm -f ./results/*.par`;
			print TOSHELL "rm -f ./results/*.par\n";
		}	# END SUB RETRIEVE
			
		##############################################################################
		##############################################################################
		##############################################################################
		# END SUB RETRIEVE

		sub report { ; } # NO MORE USED # This function retrieved the results of interest from the text file created by the "retrieve" function

		# BEGINNING OF SUB MERGE_REPORTS
		##############################################################################
		##############################################################################
		##############################################################################
		sub merge_reports    # Self-explaining
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
			my @simtitles = @$swap;
			my $preventsim = shift;
			my $exeonfiles = shift;
			my $fileconfig = shift;
			my $swap = shift;
			my @themereports = @$swap;
			my $swap = shift;
			my @reporttitles = @$swap;
			my $swap = shift;
			my @retrievedata = @$swap;
			my $toshell = shift;
			my $outfile = shift;
			my $configfile = shift;
			my $swap = shift;
			my @rankdata = @$swap;
			my $swap = shift;
			my @rankcolumn = @$swap;
			my $swap = shift;
			my @reporttempsdata = @$swap;
			my $swap = shift;
			my @reportcomfortdata = @$swap;
			my $swap = shift;
			my @reportradiationenteringdata = @$swap;
			my $stripcheck = shift;
			my @columns_to_report           = @{ $reporttempsdata[1] };
			my $number_of_columns_to_report = scalar(@columns_to_report);
			my $counterlines;
			my $number_of_dates_to_merge = scalar(@simtitles);
			my @dates                    = @simtitles;
			my $mergefile = "$mypath/$file-merge-$countcase-$countblock";

			sub merge
			{
				open (MERGEFILE, ">$mergefile") or die;
				open (FILECASELIST, "$simlistfile") or die;
				my @lines = <FILECASELIST>;
				close FILECASELIST;
				my $counterline = 1;
				foreach my $line (@lines)
				{
					chomp($line);
					my $morphcase = "$line";
					my $reportcase = $morphcase;
					$reportcase =~ s/\/models/\/results/;
					print MERGEFILE "CASE$counterline ";
					my $counterouter = 0;
					foreach my $themeref (@themereports)
					{
						my $counterinner = 0;
						my @themes = @{$themeref};
						foreach my $theme (@themes)
						{
							my $simtitle = $simtitles[$counterouter];
							my $reporttitle = $reporttitles[$counterouter][$counterinner];
							#print OUTFILE "FILE: $file, SIMTITLE: $simtitle, REPORTTITLE!: $reporttitle, THEME: $theme\n";
							my $case = "$reportcase-$reporttitle-$theme.grt-";
							#print OUTFILE "\$case $case\n";
							#if (-e $case) { print OUTFILE "IT EXISTS!\n"; }
							#print OUTFILE "$case\n";
							open(OPENTEMP, $case) or die;
							my @linez = <OPENTEMP>;
							close OPENTEMP;
							chomp($linez[0]);
							print MERGEFILE "$case $linez[0] ";
							$counterinner++;
						}
						$counterouter++;
					}
					print MERGEFILE "\n";
					$counterline++;
				}
				close MERGEFILE;
			}
			&merge();

			my $cleanfile = "$mergefile-clean";
			my $selectmerged = "$cleanfile-select";
			sub cleanselect
			{ # CLEANS THE MERGED FILE AND SELECTS SOME COLUMNS AND COPIES THEM IN ANOTHER FILE
				open ( MERGEFILE, $mergefile) or die;
				my @lines = <MERGEFILE>;
				close MERGEFILE;
				open ( CLEANMERGED, ">$cleanfile") or die;
				foreach my $line (@lines)
				{
					$line =~ s/\n/°/g;
					$line =~ s/\s+/,/g;
					$line =~ s/°/\n/g;
					print CLEANMERGED "$line";
				}
				close CLEANMERGED;
				# END. CLEANS THE MERGED FILE
			
				#SELECTS SOME COLUMNS AND COPIES THEM IN ANOTHER FILE
				open (CLEANMERGED, $cleanfile) or die;
				my @lines = <CLEANMERGED>;
				close CLEANMERGED;
				open (SELECTMERGED, ">$selectmerged") or die;
				
				
				foreach my $line (@lines)
				{
					my @elts = split(/\s+|,/, $line);
					my $counterouter = 0;
					foreach my $elmref (@keepcolumns)
					{
						my @cols = @{$elmref};
						my $counterinner = 0;
						foreach my $elm (@cols)
						{
							print  SELECTMERGED "$elts[$elm]";
							if ( ( $counterouter < $#keepcolumns  ) or ( $counterinner < $#cols) )
							{
								print  SELECTMERGED ",";
							}
							else {print  SELECTMERGED "\n";}
							$counterinner++;
						}
						$counterouter++;
					}
				}
				close SELECTMERGED;
			} # END. CLEANS THE MERGED FILE AND SELECTS SOME COLUMNS AND COPIES THEM IN ANOTHER FILE
			&cleanselect();
			
			my $weight = "$selectmerged-weight"; # THIS WILL HOST PARTIALLY SCALED VALUES, MADE POSITIVE AND WITH A CELING OF 1
			sub weight
			{
				open (SELECTMERGED, $selectmerged) or die;
				my @lines = <SELECTMERGED>;
				close SELECTMERGED;
				# print OUTFILE "FIRST LINE: $lines[0]\n";
				my $counterline = 0;
				open (WEIGHT, ">$weight") or die;
				
				my @containerone;
				foreach my $line (@lines)
				{
					$line =~ s/^[\n]//;
					#print OUTFILE "I SPLIT\n";
					my @elts = split(/\s+|,/, $line);
					my $countcol = 0;
					my $countel = 0;
					foreach my $elt (@elts)
					{
						#print OUTFILE "I CHECK\n";
						if ( odd($countel) )
						{
							# print OUTFILE "I PUSH\n";
							push ( @{$containerone[$countcol]}, $elt);
							#print OUTFILE "ELT: $elt\n";
							$countcol++;
						}
						$countel++;
					}
				}
				#print OUTFILE "CONTAINERONE " . Dumper(@containerone) . "\n";
					
				my @containertwo;
				my @containerthree;
				$countcolm = 0;
				my @optimals;
				foreach my $colref (@containerone)
				{
					my @column = @{$colref}; # DEREFERENCE
					
					if ( $weights[$countcolm] < 0 ) # TURNS EVERYTHING POSITIVE
					{
						foreach $el (@column)
						{
							$el = ($el * -1);
						}
					}
					
					if ( max(@column) != 0) # FILLS THE UNTRACTABLE VALUES
					{
						push (@maxes, max(@column));
					}
					else
					{
						push (@maxes, "NOTHING1");
					}
							
					#print OUTFILE "MAXES: " . Dumper(@maxes) . "\n";
					#print OUTFILE "DUMPCOLUMN: " . Dumper(@column) . "\n";
					
					foreach my $el (@column)
					{
						my $eltrans;
						if ( $maxes[$countcolm] != 0 )
						{
							#print OUTFILE "\$weights[\$countcolm]: $weights[$countcolm]\n";
							$eltrans = ( $el / $maxes[$countcolm] ) ;
						}
						else
						{
							$eltrans = "NOTHING2" ;
						}
						push ( @{$containertwo[$countcolm]}, $eltrans) ;
						#print OUTFILE "ELTRANS: $eltrans\n";
					}
					$countcolm++;
				}
				#print OUTFILE "CONTAINERTWO " . Dumper(@containertwo) . "\n";
						
				my $countline = 0;
				foreach my $line (@lines)
				{
					$line =~ s/^[\n]//;
					my @elts = split(/\s+|,/, $line);		
					my $countcolm = 0;
					foreach $eltref (@containertwo)
					{
						my @col =  @{$eltref};
						my $max = max(@col);
						#print OUTFILE "MAX: $max\n";
						my $min = min(@col);
						#print OUTFILE "MIN: $min\n";
						my $floordistance = ($max - $min);
						my $range = ( $min / $max);
						my $el = $col[$countline];
						my $rescaledel;
						if ( $floordistance != 0 )
						{
							$rescaledel = ( ( $el - $min ) / $floordistance ) ;
						}
						else
						{
							$rescaledel = 1;
						}
						if ( $weightsaim[$countcolm] < 0)
						{
							$rescaledel = ( 1 - $rescaledel);
						}
						push (@elts, $rescaledel);
						$countcolm++;
					}
					
					$countline++;
					
					my $counter = 0;
					foreach my $el (@elts)
					{		
						print WEIGHT "$el";
						if ($counter < $#elts)
						{ 
							print WEIGHT ",";
						}
						else
						{
							print WEIGHT "\n";
						}
						$containerthree[$counterline][$counter] = $el;
						$counter++;
					}
					$counterline++;
				}
				close WEIGHT;
				#print OUTFILE "CONTAINERTHREE: " . Dumper(@containerthree) . "\n";
			}
			&weight(); #
			
			my $weighttwo = "$selectmerged-weighttwo"; # THIS WILL HOST PARTIALLY SCALED VALUES, MADE POSITIVE AND WITH A CELING OF 1
			sub weighttwo
			{
				open (WEIGHT, $weight) or die;
				my @lines = <WEIGHT>;
				close WEIGHT;
				open (WEIGHTTWO, ">$weighttwo") or die;		
				my $counterline;
				foreach my $line (@lines)
				{
					$line =~ s/^[\n]//;
					my @elts = split(/\s+|,/, $line);
					my $counterelt = 0;
					my $counterin = 0;
					my $sum = 0;
					my $avg;
					my $numberels = scalar(@keepcolumns);
					foreach my $elt (@elts)
					{
						my $newelt;
						if ($counterelt > ( $#elts - $numberels ))
						{
							#print OUTFILE "ELT: $elt\n";
							$newelt = ( $elt * abs($weights[$counterin]) );
							# print OUTFILE "ABS" . abs($weights[$counterin]) . "\n";
							# print OUTFILE "NEWELT: $newelt\n";
							$sum = ( $sum + $newelt ) ;
							# print OUTFILE "SUM: $sum\n";
							$counterin++;
						}
						$counterelt++;
					}
					$avg = ($sum / scalar(@keepcolumns) );
					push ( @elts, $avg);
					
					my $counter = 0;
					foreach my $elt (@elts)
					{		
						print WEIGHTTWO "$elt";
						if ($counter < $#elts)
						{ 
							print WEIGHTTWO ",";
						}
						else
						{
							print WEIGHTTWO "\n";
						}
						$counter++;
					}
					$counterline++
				}
			}
			&weighttwo();	

			$sortmerged = "$mergefile-sortmerged";
			sub sortmerged
			{
				open (WEIGHTTWO, $weighttwo) or die;
				open (SORTMERGED, ">$sortmerged") or die;
				my @lines = <WEIGHTTWO>;
				close WEIGHTTWO;
				my $line = $lines[0];
				$line =~ s/^[\n]//;
				my @eltstemp = split(/\s+|,/, $line);
				my $numberelts = scalar(@eltstemp);
				if ($numberelts > 0) { print SORTMERGED `sort -n -k$numberelts,$numberelts -t , $weighttwo`; }
				# print SORTMERGED `sort -n -k$numberelts -n $weighttwo`; 
				close SORTMERGED;
			}
			&sortmerged();
		}    # END SUB merge_reports

		#################################################################
		#################################################################
		#################################################################
		# END OF SUB MERGE_REPORTS
		
		if (-e "./SIM/OPTS/convertandfilter.pl")
		{
			eval `cat ./SIM/OPTS/convertandfilter.pl`; 
		}

		if (-e "./SIM/OPTS/maketable.pl")
		{
			eval `cat ./SIM/OPTS/maketable.pl`; 
		}
		
		# END OF THE CONTENT OF THE "opts_format.pl" FILE.
		##############################################################################
		##############################################################################
		##############################################################################
		
		
		# BEGINNING OF SUB TAKEOPTIMA
		#################################################################
		#################################################################
		#################################################################
		sub takeoptima
		{
			$fileuplift = "$file-uplift-$countcase-$countblock";
			open(UPLIFT, ">$fileuplift") or die;
			my $to = shift;
			my $mypath = shift;
			my $file = shift;
			my $filenew = shift;
			my $sortmerged = shift;
			my (@winnerarray_tested, @winnerarray_nontested, @winnerarray, @nontested, @provcontainer);
			@uplift = ();
			@downlift = ();
			
			open (SORTMERGED, $sortmerged) or die;
			say OUTFILE "\$sortmerged: $sortmerged";
			my @lines = <SORTMERGED>;
			close SORTMERGED;
			
			my $winnerentry = $lines[0];
			chomp $winnerentry;
			say OUTFILE "\$winnerentry: $winnerentry";
			my @winnerelts = split(/\s+|,/, $winnerentry);
			my $winnerline = $winnerelts[0];
			
			say OUTFILE "YESHERE TAKEOPTIMA 1 ";
				
			foreach my $var (@totvarnumbers)
			{	
				if ( $winnerline =~ /($var-\d+)/ )
				{	
					my $fragment = $1; 
					say OUTFILE "\$fragment: $fragment";
					push (@winnerarray_tested, $fragment);
				}
			}	
			
			foreach my $elt (@varn)
			{
				unless ( $elt ~~ @totvarnumbers)
				{
					push (@nontested, $elt);
				}
			}
			@nontested = uniq(@nontested);
			@nontested = sort(@nontested);
			
			foreach my $el ( @nontested )
			{	
				my $item = "$el-" . "$midvalues[$el]";
				push(@winnerarray_nontested, $item);
			}
			@winnerarray = (@winnerarray_tested, @winnerarray_nontested);
			@winnerarray = uniq(@winnerarray);
			@winnerarray = sort(@winnerarray);
			
			$winnermodel = "$filenew"; #BEGINNING
			$count = 0;
			foreach $elt (@winnerarray)
			{
				unless ($count == $#winnerarray)
				{
					$winnermodel = "$winnermodel" . "$elt" . "_";
				}
				else
				{
					$winnermodel = "$winnermodel" . "$elt";
				}
				$count++;
			}
				
			unless ( ($countvar == $#varnumbers) and ($countblock == $#blocks) )
			{		
				if (@overlap)
				{			
					my @nonoverlap;
					foreach my $elm (@varn)
					{
						unless (  $elm ~~ @overlap)
						{
							push ( @nonoverlap, $elm);
						}
					}
					
					my @present;
					foreach my $elt (@nonoverlap)
					{
						if ( $winnermodel =~ /($elt-\d+)/ )
						{
							push(@present, $1);
						}
					}
					
					my @extraneous;
					foreach my $el (@nonoverlap)
					{
						my $stepsvarthat = ${ "stepsvar" . "$el" };
						my $step = 1;
						while ( $step <= $stepsvarthat )
						{					
							my $item = "$el" . "-" . "$step";
							unless ( $item ~~ @present )
							{	
								push(@extraneous, $item);
							}
							$step++;
						}
					}
					
					open(MORPHFILE, "$morphfile") or die;
					my @models = <MORPHFILE>;
					close MORPHFILE;
						
					foreach my $model (@models)
					{
						chomp($model);
						my $counter = 0;
						foreach my $elt (@extraneous)
						{	
							if( $model =~ /$elt/ )
							{
								$counter++;
							}
						}
						if ($counter == 0)
						{
							push(@seedfiles, $model);
						}
					}
				}
				else
				{	
					push(@seedfiles, $winnermodel);
				}
			}
			
			@seedfiles = uniq(@seedfiles);
			@seedfiles = sort(@seedfiles);
			foreach my $seed (@seedfiles)
			{	
				my $touchfile = $seed;
				$touchfile =~ s/_+$//; 
				$touchfile = "$touchfile" . "_";
				push(@uplift, $touchfile);
				unless (-e "$touchfile")
				{
					if ( $exeonfiles eq "y" ) { print `cp -r $seed $touchfile` ; }
					print TOSHELL "cp -r $seed $touchfile\n\n";
					#if ( $exeonfiles eq "y" ) { print `mv -f $seed $touchfile` ; }
					#print TOSHELL "mv -f $seed $touchfile\n\n";
				}
				else
				{
					#if ( $exeonfiles eq "y" ) { print `rm -R $seed` ; }
					#print TOSHELL "rm -R $seed\n\n";
				}
			}
				
			foreach my $elt ( @uplift )
			{
				print UPLIFT "$elt\n";
			}
			close UPLIFT;
		}

		###################################################################
		#################################################################
		#################################################################
		# END OF SUB TAKEOPTIMA
		

		sub rank_reports  { ; }  # ERASED

		if ( $dowhat[0] eq "y" ) 
		{ 
			{ &morph( $to, $mypath, $file, $filenew, \@dowhat, \@simdata, $simnetwork,
			\@simtitles, $preventsim, $exeonfiles, $fileconfig, 
			\@themereports, \@reporttitles, \@retrievedata, \@varnumbers, $countblock, $countcase); } 
		}

		if ( $dowhat[1] eq "y" )
		{ 
			&sim( $to, $mypath, $file, $filenew, \@dowhat, \@simdata, $simnetwork,
			\@simtitles, $preventsim, $exeonfiles, $fileconfig, 
			\@themereports, \@reporttitles, \@retrievedata);
		}
		
		if ( $dowhat[2] eq "y" )
		{ 
			&retrieve( $to, $mypath, $file, $filenew, \@dowhat, \@simdata, $simnetwork,
			\@simtitles, $preventsim, $exeonfiles, $fileconfig, 
			\@themereports, \@reporttitles, \@retrievedata );
		}
		
		if ( $dowhat[4] eq "y" ) 
		{ 
			&report( $to, $mypath, $file, $filenew, \@dowhat, \@simdata, $simnetwork,
			\@simtitles, $preventsim, $exeonfiles, $fileconfig, \@themereports, \@reporttitles, \@retrievedata,
			\@rankdata, \@rankcolumn, \@reporttempsdata,
			\@reportcomfortdata, \@reportradiationenteringdata, $stripcheck ); }

		if ( $dowhat[5] eq "y" )
		{ &merge_reports( $to, $mypath, $file, $filenew, \@dowhat, \@simdata, $simnetwork,
			\@simtitles, $preventsim, $exeonfiles, $fileconfig, \@themereports, \@reporttitles, \@retrievedata,
			\@rankdata, \@rankcolumn, \@reporttempsdata, 
			\@reportcomfortdata, \@reportradiationenteringdata, $stripcheck ); 
		}

		if ( $dowhat[6] eq "y" )
		{
			&convert_report( \@varthemes_variations, \@varthemes_steps, $to, $mypath, $file, $filenew, \@dowhat, \@simdata, $simnetwork,
			\@simtitles, $preventsim, $exeonfiles, $fileconfig, \@themereports, \@reporttitles, \@retrievedata,
			\@rankdata, \@rankcolumn, \@reporttempsdata, 
			\@reportcomfortdata, \@reportradiationenteringdata, $stripcheck  ); # NAMES VARIABLES IN REPORTS
		}
		if ( $dowhat[10] eq "y" )
		{
			&takeoptima( $to, $mypath, $file, $filenew, $sortmerged); # CHECK THE WINNING CASE AND USES IT FOR BLOCK SEARCH IF POSSIBLE
		}
		if ( $dowhat[7] eq "y" )
		{
			&filter_reports( $to, $mypath, $file, $filenew, \@dowhat, \@simdata, $simnetwork,
			\@simtitles, $preventsim, $exeonfiles, $fileconfig, \@themereports, \@reporttitles, \@retrievedata,
			\@rankdata, \@rankcolumn, \@reporttempsdata, \@reportcomfortdata,
			\@reportradiationenteringdata, $stripcheck ); # FILTERS ALREADY CONVERTED REPORTS
		}
		if ( $dowhat[8] eq "y" )
		{
			&convert_filtered_reports( $to, $mypath, $file, $filenew, \@dowhat, \@simdata, $simnetwork,
			\@simtitles, $preventsim, $exeonfiles, $fileconfig, \@themereports, \@reporttitles, \@retrievedata,
			\@rankdata, \@rankcolumn, \@reporttempsdata, \@reportcomfortdata,
			\@reportradiationenteringdata, $stripcheck ); # CONVERTS ALREADY FILTERED REPORTS
		}
		if ( $dowhat[9] eq "y" )
		{
			&maketable( $to, $mypath, $file, $filenew, \@dowhat, \@simdata, $simnetwork,
			\@simtitles, $preventsim, $exeonfiles, $fileconfig, \@themereports, \@reporttitles, \@retrievedata,
			\@rankdata, \@rankcolumn, \@reporttempsdata,
			\@reportcomfortdata, \@reportradiationenteringdata, $stripcheck ); # CONVERTS TO TABLE ALREADY FILTERED REPORTS
		}
	} # END SUB exec
	###########################################################################################
	###########################################################################################
	###########################################################################################

	###########################################################################################
	###########################################################################################
	# BELOW IS THE PART OF THE PROGRAM THAT LAUNCHES OPTS.
	
	
	# HERE IS A SPACE FOR GENERAL FUNCTIONS USED BY THE PROGRAM
	###########################################################
	###########################################################

	sub odd 
	{
	    my $number = shift;
	    return !even ($number);
	}

	sub even 
	{
	    my $number = abs shift;
	    return 1 if $number == 0;
	    return odd ($number - 1);
	}

	sub _mean_ { return @_ ? sum(@_) / @_ : 0 }

	###########################################################
	###########################################################
	# END OF THE SPACE FOR GENERAL FUNCTIONS
	

	
	##########################################################################################
	##########################################################################################
	# BEGINNING OF THE INSTRUCTIONS THAT LAUNCH OPTS AT EACH SUBSPACE SEARCH CYCLE.
	
	if ( ( (-e $casefile) and (-e $chancefile) ) or ( (-e $caseseed) and (-e $chanceseed) ) )
	{
		eval "$casefile"; # THIS BRINGS @casedata AND MAYBE @casegroup (OR PRODUCES IT). 
		eval "$chancefile"; # THIS BRINGS @chanceseries.
		my @cancelineelms;
		my $countcase = 0;
		if ( $generatechance eq "n" )
		{
			my $countcase = 0;
			foreach my $case (@casegroup) # in $casefile there may be a @casegroup. If not, it is fabricated from @casedescription and @chancefile
			{
				my @blockrefs = @{$case};
				my $countblock = 1;
				my (@varnumbers, @newvarnumbers, @chance, @newchance);
								
				foreach my $blockref (@blockrefs)
				{
					my @overlap;
					@varnumbers = @{$varn[$countcase][$countblock-1]};
					my $number_of_variables = scalar(@varnumbers);	$parameters = $number_of_variables; 
					my @blockelts = @{$blockref};
					$blockelts[0] = ( $blockelts[0] + $number_of_variables );
					my @newblockelts = @{$blockref[$countblock]};		
					$newblockelts[0] = ( $newblockelts[0] + $number_of_variables );

					sub def_filenew
					{
						$filenew = "$mypath/models/$file" . "_";
						my $counterfn = 0;
						foreach my $el (@varn)
						{
							$filenew = "$filenew" . "$varn[$counterfn]" . "-" . "$midvalues[$countblock]" . "_" ;
							$counterfn++;
						}
					}
					if ($countblock == 1) 
					{ 
						&def_filenew;
						@uplift = ($filenew); 
						@downlift = ($filenew);
					}
		
					foreach my $el (@varnumbers)
					{
						foreach my $elt (@newvarnumbers)
						{
							if ( $el eq $elt)
							{
								push (@overlap, $el);
							}
						}
					}
					@overlap = sort(@overlap);
					&exec(\@varnumbers, $countblock, $countcase, \@newvarnumbers, \@uplift, \@downlift, \@blocks, \@blockelts, \@newblockelts, \@overlap);	
					$countblock++;
				}
				$countcase++;
			}
			
			
			
			
			
			
			
			
			elsif ( $generatechance eq "y" )
			{
				my $countcase = 0;
				foreach my $case (@caseseed) # in $casefile there may be a @casegroup. If not, it is fabricated from @casedescription and @chancefile
				{
					my @blockrefs = @{$case};
					
					my $countblock = 1;
					my (@varnumbers, @newvarnumbers, @chance, @newchance);
				
					foreach my $blockref (@blockrefs)
					{
						my @overlap;
						@varnumbers = @{$varn[$countcase][$countblock-1]};
						push (@chancelineelms, [ @varnumbers, @varnumbers, @varnumbers ]); # THIS SHOULD BE USEFUL SOONER OR LATER
						my $number_of_variables = scalar(@varnumbers);	$parameters = $number_of_variables; 
						my @blockelts = @{$blockref};
						foreach (@blockelts)
						{
							$blockelts[0] = ( $blockelts[0] + $number_of_variables );
						}
						
						my $countertwo = 1;
						while ($countertwo <= 3)
						{
							
							my $counterone = 1;
							my @pos;
							while ($counterone <= $number_of_variables)
							{
								push (@pos, $counterone);
								$counterone++;
							}
							$countertwo++;
						}
						
						my @current_chanceseedgroup = @{$chancedata[$countcase]};
						my @current_chanceseed = @{$current_chanceseedgroup[0]}:
						
						my @current_chancedata = @{$chancedata[$countcase]};
						my $number_ofseedblocks = scalar(@blockelts);
						my $block_length = $current_chancedata[0];
						my $block_overlap = $current_chancedata[1];
						my $number_ofsweeps = $current_chancedata[2];

						my $totalblock_num = ( $number_ofblocks * $number_of_sweeps );
						my $number_ofblockstobuild = ( $totalblock_num - $number_ofseedblocks );
						
						my @wasteblockelts = @blockelts;
						my $countbuild = 1;
						while ($countbuild <= $number_ofblockstobuild)
						{
							my @chanceproduct = shuffle(@current_chanceseed)
							my $beginning = int(rand(@$block_length) + $number_of_variables);
							my @candidateblock_toadd = ($beginninng, $block_length);
							my @blockelts_totest = push ( @wasteblockelts, [ @candidateblock_toadd ] );
							my @iters = scalar(@blockelts_totest);						
							$countbuild++;
						}
						
						
						my @blockelts = @{$blockref};
						$blockelts[0] = ( $blockelts[0] + $number_of_variables );
						my @newblockelts = @{$blocks[$countblock]};		
						$newblockelts[0] = ( $newblockelts[0] + $number_of_variables );
						
						sub def_filenew
						{
							$filenew = "$mypath/models/$file" . "_";
							my $counterfn = 0;
							foreach my $el (@varn)
							{
								$filenew = "$filenew" . "$varn[$counterfn]" . "-" . "$midvalues[$countblock]" . "_" ;
								$counterfn++;
							}
						}
						if ($countblock == 1) 
						{ 
							&def_filenew;
							@uplift = ($filenew); 
							@downlift = ($filenew);
						}
			
						foreach my $el (@varnumbers)
						{
							foreach my $elt (@newvarnumbers)
							{
								if ( $el eq $elt)
								{
									push (@overlap, $el);
								}
							}
						}
						@overlap = sort(@overlap);
						&exec(\@varnumbers, $countblock, $countcase, \@newvarnumbers, \@uplift, \@downlift, \@blocks, \@blockelts, \@newblockelts, \@overlap);	
						$countblock++;
					}
					$countcase++;
				}
			}
			
			
			
			
			
			
			
		}
		else
		{
			die;
		}
	}
	else
	{  
		die; # &exec; 
		#print OUTFILE "I CALL EXEC AND \@VARNUMBERS IS: " . Dumper(@varnumbers) . "\n";
	}

	# END OF THE INSTRUCTIONS LAUNCHING OPTS.
	##########################################################################################
	##########################################################################################

	close(OUTFILE);
	close(TOSHELL);
	close (OUTFILEWRITE);
	close ( REPORTFILE);
	exit;

} # END OF SUB OPTS
#############################################################################
#############################################################################
#############################################################################

1;
__END__

=head1 NAME

Sim::OPTS is a tool for detailed metadesign managing parametric explorations through the ESP-r building performance simulation platform and performing optimization by block coordinate descent.

=head1 SYNOPSIS

  use Sim::OPTS;
  opts;

=head1 DESCRIPTION

Sim::OPTS it a tool for detailed metadesign. It morphs models by propagation of constraints through the ESP-r building performance simulation platform and performs optimization by overlapping block coordinate descent.

A working knowledge of ESP-r is necessary to use OPTS. Information about ESP-r can be found at http://www.esru.strath.ac.uk/Programs/ESP-r.htm.

To install OPTS, the command <cpanm Sim::OPTS> has to be issued. Perl will take care to install all dependencies. OPTS can be loaded through the command <use Sim::OPTS> in Perl. For that purpose, the "Devel::REPL" module can be used. As an alternative, the batch file "opt" (which can be found in the "example" folder in this distribution) may be copied in a work directory and the command <opt> may be issued. That command will activate the OPTS functions, following the settings specified in a previously prepared configuration file. When launched, OPTS will ask the path to that file. Its activity will start after receiving that information. 
The OPTS configuration file has to contain a suitable description of the operations to be accomplished pointing to an existing ESP-r model. The OPTS configuration file is extended by other files in which the search structures to be searched into or to be generated are specified. Those files are designated with the "$casefile", "$chancefile", "$caseed" and "$chanceseed" variables. But if wanted the variables contained in those files can be written directly in the main configuration file.

In this distribution there is a set of commented template files and an example of OPTS configuration file. The example has been written for a previous version of OPTS and will probably not work with the present one due to minor changes in the header variables. The complete set of files linked to that configuration file may be downloaded athttp://figshare.com/articles/Dataset_of_a_computational_research_on_block_coordinate_search_based_on_building_performance_simulations/1158993 .

To run OPTS without making it act on model files, the setting <$exeonfiles = "n";> should be specified in the configuration file. By setting the variable "$toshell" to the chosen path, the path for the text file that will receive the commands in place of the shell should be specified.

OPTS will give instruction to ESP-r via shell to make it modify the building model in different copies. Then, if asked, it will run simulations, retrieve the results, extract some information from them and order it as requested.

Besides an OPTS configuration file, also configuration files for propagation of constraints may be created. This will give to the morphing operations much greater flexibility. Propagation of constraints can regard the geometry of a model, solar shadings, mass/flow network, and/or controls; and also, how those pieces of information affect each other and daylighting (calculated through the Radiance lighting simulation program). Example of configuration files for propagation of constraints are included in this distribution.

The ESP-r model folders and the result files that will be created in a parametric search will be named as the root model, followed by a "_" character, followed by a variable number referred to the first morphing phase, followed by a "-" character, followed by an iteration number for the variable in question, and so on for all morphing phases. For example, the model instance produced in the first iteration for a root model named "model" in a search constituted by 3 morphing phases and 5 iteration steps each will be named "model_1-1_2-1_3-1"; and the last one "model_1-5_2-5_3-5".

To describe a block search, the most important variables to be taken into account in a configuration file are "@varn" - which represents the sequence of design variables - and "@casegroup" - which represent the sequence of decompositions to be taken into account. After joining "@varn" with two copies of itself, OPTS will work in the middle of the so-obtained sequence, but the user is not required to be aware of that. How "@varn" and "@casegroup" should be specified is more quickly described with a couple of examples.

1) If brute force optimization is sought for a case composed by 4 parameters, the following settings should be specified: <@varn = (1, 2, 3, 4);> and <@casegroup = ( [ [0, 4] ] ) ;>.

2) If optimization is sought for two cases (brute force, again, for instance, with a different set of parameters), the two sets of parameters in questions has to be specificied as sublists of the general parameter list: <@varn = (1, 2, 3, 4, 6, 7, 8);> and <@casegroup = ( [ [0, 4] , [5, 8] ] ) ;>.

3) If a block search is sought on the basis of 5 parameters, with 4 overlapping active blocks composed by 3 parameters each having the leftmost parameters in position 0, 1, 2 and 4, and two search sweeps have to be performed, with the second sweep having the parameters in inverted order and the leftmost parameters in position 2, 4, 3 and 1, the following settings should be specified: <@varn = ( [ [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [5, 4, 3, 2, 1], [5, 4, 3, 2, 1], [5, 4, 3, 2, 1], [5, 4, 3, 2, 1]] );> and <@casegroup = ( [ [0, 3], [1, 3], [2, 3], [4, 3] ], [2, 3], [4, 3], [3, 3], [1, 3] ] );>.

4) By playing with the order of the parameters' sequence, blocks with non-contiguous parameters can be modelled. Example: <@varn = ( [ [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [5, 2, 4, 1, 3], [2, 4, 1, 5, 2], [5, 1, 4, 2, 3], [5, 1, 4, 2, 3] ] );> and <@casegroup = ( [ [0, 3], [1, 3], [2, 3], [4, 3] ], [2, 3], [4, 3], [3, 3], [1, 3] ] );>.

5) Nothing prevents that the blocks are of different size (i.e. each composed by a different number of parameters). Example: <@varn = ( [ [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [5, 2, 4, 1, 3], [2, 4, 1, 5, 2], [5, 1, 4, 2, 3], [5, 1, 4, 2, 3] ] );> and <@casegroup = ( [ [0, 3], [1, 3], [2, 3], [4, 3] ], [2, 2], [4, 2], [3, 4], [1, 4] ] );>.

OPTS is a program I have written as a side project since 2008 with no funding. It was the first real program I attempted to write. From time to time I add some parts to it. The parts of it that have been written earlier are the ones that are coded in the strangest manner.

=head2 EXPORT

"opts".

=head1 SEE ALSO

The available examples are collected in the "example" directory in this distribution and at the figshare address specified above.

=head1 AUTHOR

Gian Luca Brunetti, E<lt>gianluca.brunetti@polimi.itE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008-2014 by Gian Luca Brunetti and Politecnico di Milano. This is free software.  You can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 2 or later.


=cut
