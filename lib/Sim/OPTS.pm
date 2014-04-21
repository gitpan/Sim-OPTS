package Sim::OPTS;
# Copyright (C) 2008-2014 by Gian Luca Brunetti and Politecnico di Milano.
# This is OPTS, a program conceived to manage parametric esplorations through the use of the ESP-r building performance simulation platform.
# This is free software.  You can redistribute it and/or modify it under the terms of the GNU General Public License 
# as published by the Free Software Foundation, version 2.

use 5.014002;
use Exporter; # require Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
use Devel::REPL;
no warnings; # use warnings;
no strict; # use strict: THIS CAN'T BE DONE SINCE THE PROGRAM USES SYMBOLIC REFERENCES

@ISA = qw(Exporter); # our @ISA = qw(Exporter);


# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use opts ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.

%EXPORT_TAGS = ( DEFAULT => [qw(&opts &prepare)]); # our %EXPORT_TAGS = ( 'all' => [ qw( ) ] );
@EXPORT_OK   = qw(); # our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
@EXPORT = qw(); # our @EXPORT = qw( );
$VERSION = '0.21'; # our $VERSION = '';
$ABSTRACT = 'OPTS is a program conceived to manage parametric explorations through the use of the ESP-r building performance simulation platform.';

#require "./PREPARE.pl"; # HERE IS THE FUNCTION "launch", a text interface to the function "opts".

sub opts { # UNCOMMENT HERE AND AT THE END IF THIS PROGRAM IS A MODULE.
print "THIS IS OPTS.
Copyright by Gian Luca Brunetti and Politecnico di Milano, 2008-14.
Dipartimento DAStU, Politecnico di Milano.
Copyright license: GPL.
-------------------

To use OPTS, an OPTS configuration file and a target ESP-r model should have been prepared.
This OPTS version is for UNIX systems and UNIX-like systems.
Insert the name of a configuration file (local path):\n";
$configfile = <STDIN>;
chomp $configfile;
print "You wrote $configfile, is this correct? 
If it is, OPTS will run. (y or n).\n";
$response1 = <STDIN>;
chomp $response1;
if ( $response1 eq "y" )
{ ; }
else { die; }
eval `cat $configfile`; # The file where the program data are
# require $configfile; # The file where the program data are

# THE MAIN FUNCTION, "morph", FROM THIS FILE (MAIN).
#require "./MORPH.pl";
#require "./SIM.pl"; # HERE THERE IS THE FUNCTION "sim" CALLED
# FROM THIS FILE (MAIN).
# STILL CALLED BY EVAL IN THE ENVIRONMENT WHERE THE CALL HAPPENS, WITHOUT
# PARAMETERS (SEE BELOW).
#require "./REPORT.pl"; 
# STILL CALLED BY EVAL IN THE ENVIRONMENT WHERE THE CALL HAPPENS, WITHOUT
# PARAMETERS (SEE BELOW).
#require "./FORMAT.pl";
# use strict; # THIS CAN'T BE DONE SINCE THE PROGRAM USES SYMBOLIC REFERENCES

if ($exeonfiles == undef) { $exeonfiles = "y";}
use Math::Trig;
use Data::Dumper;
use List::Util qw[min max];
$Data::Dumper::Indent = 0;
$Data::Dumper::Useqq  = 1;
$Data::Dumper::Terse  = 1;

my $varprov;
my $countprov = 1;
my $maxstepsvar = 100; # HERE PUT A NUMBER OF YOUR CHOICE SETTING A LIMIT TO
# THE NUMBER OF TRASFORMATION PHASES TO BE TAKEN INTO ACCOUNT.
my $casenumber = 1;
while ($countprov <= $maxstepsvar) # THIS IS BECAUSE A $stepsvar MUST NEVER BE 0.
{
	$varprov = ${ "stepsvar" . "$countprov" };
	if ( $varprov == undef )  { $varprov  = 1; }
	if ( $varprov == 0 )  { $varprov  = 1; } # HERE THE $stepsvar VARIABLE
	# IS SET UP ON THE FLY (that's why Perl's symbolic references have been
	# used) FOR ALL CASES.
	$casenumber = ( $casenumber * $countprov ); # HERE THE NUMBER OF TEST
	# INSTANCES IS CALCULATED.
	$countprov++;
}

print "OPTS IS RUNNING.
-------------------\n";

#The number of cases set in the configuration file on the whole is $casenumbers.
#If they are too many, stop OPTS with CONTROL+C.
if ($outfile ne "" ) 
{ open( OUTFILE, ">$outfile" ) or die "Can't open $outfile: $!"; }

if ($toshell ne "" ) 
{ open( TOSHELL, ">$toshell" ) or die "Can't open $toshell: $!" };

sub morph    # This function generates the test case variables 
# and modifies them.
# HERE THE VARIABLES ARE ASSIGNED A 
# NUMBERED NAME ON THE FLY AT EACH SEARCH ITERATION (PHASE).
# THE VARIABLE $countervar COUNTS THE MORPHING PHASE.
# THE VARIABLE DESIGNING THE MORHING PHASE IS $stepsvar.
# THE VARIABLE $counterzone DOES NOT EXACTLY COUNT A ZONE (IT 
# JUST MAY. IT COUNTS A MORPHING PHASE NESTED INTO ANOTHER
# ONE: A MORPHING SUB-PHASE.
{
	my $counter_countervar = 0;

	foreach $countervar (@varnumbers)
	{
		$stepsvar = ${ "stepsvar" . "$countervar" };
		@applytype = @{ "applytype" . "$countervar" };
		@generic_change = @{ "generic_change" . "$countervar" };
		$rotate = ${ "rotate" . "$countervar" };
		$rotatez = ${ "rotatez" . "$countervar" };
		$general_variables = ${ "general_variables" . "$countervar" };
		$translate = ${ "translate" . "$countervar" };
		$translate_surface_simple = ${ "translate_surface_simple" . "$countervar" };
		$translate_surface = ${ "translate_surface" . "$countervar" };
		$keep_obstructions = ${ "keep_obstructions" . "$countervar" };
		$shift_vertexes = ${ "shift_vertexes" . "$countervar" };
		$construction_reassignment = ${ "construction_reassignment" . "$countervar" };
		$thickness_change = ${ "thickness_change" . "$countervar" };
		$recalculateish = ${ "recalculateish" . "$countervar" };
		@recalculatenet = @{ "recalculatenet" . "$countervar" };
		$obs_modify = ${ "obs_modify" . "$countervar" };
		$netcomponentchange = ${ "netcomponentchang" . "$countervar" };
		$changecontrol = ${ "changecontrol" . "$countervar" };
		@apply_constraints = @{ "apply_constraints" . "$countervar" }; # NOW SUPERSEDED BY @constrain_geometry
		$rotate_surface = ${ "rotate_surface" . "$countervar" };
		@reshape_windows = @{ "reshape_windows" . "$countervar" };
		@apply_netconstraints = @{ "apply_netconstraints" . "$countervar" };
		@apply_windowconstraints = @{ "apply_windowconstraints" . "$countervar" };
		@translate_vertexes = @{ "translate_vertexes" . "$countervar" };
		$warp = ${ "warp" . "$countervar" };
		@daylightcalc = @{ "daylightcalc" . "$countervar" };
		@change_config = @{ "change_config" . "$countervar" };
		@constrain_geometry = @{ "constrain_geometry" . "$countervar" };
		@vary_controls = @{ "vary_controls" . "$countervar" };
		@constrain_controls =  @{ "constrain_controls" . "$countervar" };
		@constrain_geometry = @{ "constrain_geometry" . "$countervar" };
		@constrain_obstructions = @{ "constrain_obstructions" . "$countervar" };
		@get_obstructions = @{ "get_obstructions" . "$countervar" };
		@pin_obstructions = @{ "pin_obstructions" . "$countervar" };
		$checkfile = ${ "checkfile" . "$countervar" };
		@vary_net = @{ "vary_net" . "$countervar" };
		@constrain_net = @{ "constrain_net" . "$countervar" };
		@propagate_constraints = @{ "propagate_constraints" . "$countervar" };
		@change_climate = @{ "change_climate" . "$countervar" };

		my @cases_to_sim;
		my @files_to_convert;
		my $generate  = $$general_variables[0];
		my $sequencer = $$general_variables[1];
		my $dffile = "df-$file.txt";

		if ( $counter_countervar == 0 )
		{
			if ($exeonfiles eq "y") { print `cp -r $mypath/$file $mypath/$filenew`; }
			print TOSHELL
			  "cp -r $mypath/$file $mypath/$filenew\n\n";
		}
		if ( ( $sequencer eq "n" ) and not( $counter_countervar == 0 ) )
		{
			my @files_to_convert = grep -d, <$mypath/$file*£>;
			foreach $file_to_convert (@files_to_convert)
			{
				$file_converted = "$file_to_convert" . "_";
				if ($exeonfiles eq "y") { print `mv $file_to_convert $file_converted\n`; }
				print TOSHELL "mv $file_to_convert $file_converted\n\n";
			}
		}
		#eval `cat $configfileinsert`;
		
		@cases_to_sim = grep -d, <$mypath/$file*_>;
		foreach $case_to_sim (@cases_to_sim)
		{
			$counterstep = 1;
			while ( $counterstep <= $stepsvar )
			{
				my $from = "$case_to_sim";
				if (     ( $generate eq "n" )
					 and ( ( $sequencer eq "y" ) or ( $sequencer eq "last" ) ) )
				{
					$to = "$case_to_sim$countervar-$counterstep§";
				} elsif ( ( $generate eq "y" ) and ( $sequencer eq "n" ) )
				{
					$to = "$case_to_sim$countervar-$counterstep" . "_";
					if ( $counterstep == $stepsvar )
					{
						if ($exeonfiles eq "y") { print `chmod -R 777 $from\n`; }
						print TOSHELL "chmod -R 777 $from\n\n";
					}
				} elsif ( ( $generate eq "y" ) and ( $sequencer eq "y" ) )
				{
					$to = "$case_to_sim$countervar-$counterstep" . "£";
				} elsif ( ( $generate eq "y" ) and ( $sequencer eq "last" ) )
				{
					$to = "$case_to_sim$countervar-$counterstep" . "£";
					if ( $counterstep == $stepsvar )
					{
						if ($exeonfiles eq "y") { print `chmod -R 777 $from\n`; }
						print TOSHELL "chmod -R 777 $from\n\n";
					}
				} elsif ( ( $generate eq "n" ) and ( $sequencer eq "n" ) )
				{
					$to = "$case_to_sim$countervar-$counterstep";
				}
				if (     ( $generate eq "y" )
					 and ( $counterstep == $stepsvar )
					 and ( ( $sequencer eq "n" ) or ( $sequencer eq "last" ) ) )
				{
					if ($exeonfiles eq "y") { print `mv $from $to\n`; }
					print TOSHELL "mv $from $to\n\n";
					if ($exeonfiles eq "y") { print `chmod -R 777 $to\n`; }
					print TOSHELL "chmod -R 777 $to\n\n";
				} else
				{
					if ($exeonfiles eq "y") { print `cp -R $from $to\n`; }
					print TOSHELL "cp -R $from $to\n\n";
					if ($exeonfiles eq "y") { print `chmod -R 777 $to\n`; }
					print TOSHELL "chmod -R 777 $to\n\n";
				}
				$counterzone = 0;
				foreach my $zone (@applytype)
				{
					my $modification_type = $applytype[$counterzone][0];
					my $zone_letter = $applytype[$counterzone][3];
					if ( ( $applytype[$counterzone][1] ne $applytype[$counterzone][2] )
						 and ( $modification_type ne "changeconfig" ) )
					{
						if ($exeonfiles eq "y") 
						{ 
							print 
							`cp -f $to/zones/$applytype[$counterzone][1] $to/zones/$applytype[$counterzone][2]\n`; 
						}
						print TOSHELL 
						"cp -f $to/zones/$applytype[$counterzone][1] $to/zones/$applytype[$counterzone][2]\n\n";
						if ($exeonfiles eq "y") 
						{ 
							print 
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
							print 
							`cp -f $to/cfg/$applytype[$counterzone][1] $to/cfg/$applytype[$counterzone][2]\n`; 
						}
						print TOSHELL 
						"cp -f $to/cfg/$applytype[$counterzone][1] $to/cfg/$applytype[$counterzone][2]\n\n"; 
						# ORDINARILY, REMOVE THIS LINE
					}

					my $yes_or_no_rotate_obstructions = "$$rotate[$counterzone][1]" ; 
					# WHY $BRING_CONSTRUCTION_BACK DOES NOT WORK IF THESE TWO VARIABLES ARE PRIVATE?
					my $yes_or_no_keep_some_obstructions = "$$keep_obstructions[$counterzone][0]";    
					# WHY?

					my $countercycles_transl_surfs = 0;				
					
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
								propagate_constraints
								($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, $zone_letter, \@propagate_constraints); 
							}
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ 
								apply_constraints
								($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, $zone_letter, \@constrain_geometry); 
							}
							if ($constrain_geometry[$counterzone][0] eq "y") 
							{ 
								constrain_geometry
								($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, \@constrain_geometry, $to_do); 
							}
							if ($constrain_controls[$counterzone][0] eq "y") 
							{ 
								constrain_controls
								($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, $zone_letter, \@constrain_controls, $to_do); 
							}
							if ($$keep_obstructions[$counterzone][0] eq "y") # TO BE SUPERSEDED BY get_obstructions AND pin_obstructions
							{ 
								bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, $zone_letter, $keep_obstructions); 
							}
							if ($constrain_net[$counterzone][0] eq "y")
							{ 
								constrain_net($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, $zone_letter, \@constrain_net, $to_do); 
							}
							if ($recalculatenet[0] eq "y") 
							{ 
								recalculatenet
								($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, $zone_letter, \@recalculatenet); 
							}
							if ($constrain_obstructions[$counterzone][0] eq "y") 
							{ 
								constrain_obstructions
								($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, $zone_letter, \@constrain_obstructions, $to_do); 
							}
							#if ( $pin_obstructions[$counterzone][0] eq "y" ) 
							#{ 
							#	pin_obstructions ($to, $fileconfig, $stepsvar, $counterzone, 
							#	$counterstep, $exeonfiles, \@applytype, $zone_letter, \@pin_obstructions); 
							#}
							if ($recalculateish eq "y") 
							{ 
								recalculateish
								($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, $zone_letter, \@recalculateish); 
							}
							if ($daylightcalc[0] eq "y") 
							{ 
								daylightcalc
								($to, $fileconfig, $stepsvar, $counterzone,  
								$counterstep, $exeonfiles, \@applytype, $zone_letter, $filedf, \@daylightcalc); 
							}
						} # END SUB DOTHINGS
						
						if ( $modification_type eq "generic_change" )#
						{
							make_generic_change
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $exeonfiles,
							\@applytype, $zone_letter, $generic_change);
							dothings;
						} #
						elsif ( $modification_type eq "surface_translation_simple" )
						{
							translate_surfaces_simple
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, $translate_surface_simple);
							dothings;
						} 
						elsif ( $modification_type eq "surface_translation" )
						{
							translate_surfaces
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, $translate_surface);
							dothings;
						} 
						elsif ( $modification_type eq "surface_rotation" )              #
						{
							rotate_surface
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, $rotate_surface);
							dothings;
						} 
						elsif ( $modification_type eq "vertexes_shift" )
						{
							shift_vertexes
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, $shift_vertexes);
							dothings;
						}
						elsif ( $modification_type eq "vertex_translation" )
						{
							translate_vertexes
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, \@translate_vertexes);                         
							dothings;
						}  
						elsif ( $modification_type eq "construction_reassignment" )
						{
							reassign_construction
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, $construction_reassignment);
							dothings;
						} 
						elsif ( $modification_type eq "rotation" )
						{
							rotate
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, $rotate);
							dothings;
						} 
						elsif ( $modification_type eq "translation" )
						{
							translate
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, $translate);
							dothings;
						} 
						elsif ( $modification_type eq "thickness_change" )
						{
							change_thickness
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, $thickness_change);
							dothings;
						} 
						elsif ( $modification_type eq "rotationz" )
						{
							rotatez
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, $rotatez);
							dothings;
						} 
						elsif ( $modification_type eq "change_config" )
						{
							change_config
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, \@change_config);
							dothings;
						}
						elsif ( $modification_type eq "window_reshapement" ) 
						{
							reshape_windows
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, \@reshape_windows);					
							dothings;
						}
						elsif ( $modification_type eq "obs_modification" )  # REWRITE FOR NEW GEO FILE?
						{
							obs_modify
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, $obs_modify);
							dothings;
						}
						elsif ( $modification_type eq "warping" )
						{
							warp
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, $warp);
							dothings;
						}
						elsif ( $modification_type eq "vary_controls" )
						{
							vary_controls
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, \@vary_controls);
							dothings;
						}
						elsif ( $modification_type eq "vary_net" )
						{
							vary_net
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, \@vary_net);
							dothings;
						}
						elsif ( $modification_type eq "change_climate" )
						{
							change_climate
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $zone_letter, \@change_climate);
							dothings;
						} 
						elsif ( $modification_type eq "constrain_controls" )
						{
							dothings;
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
							dothings;
						}
						elsif ( $modification_type eq "apply_constraints" )
						{
							dothings;
						}
						elsif ( $modification_type eq "constrain_net" )
						{
							dothings;
						}
						elsif ( $modification_type eq "propagate_net" )
						{
							dothings;
						}
						elsif ( $modification_type eq "recalculatenet" )
						{
							dothings;
						}
						elsif ( $modification_type eq "constrain_obstructions" )
						{
							dothings;
						}
						elsif ( $modification_type eq "propagate_constraints" )
						{
							dothings;
						}
					}
					$counterzone++;
				}
				$counterstep++ ; 
			}
		}
		$counter_countervar++;
	}
	my @files_to_clean = grep -d, <$mypath/$file*_>;
	foreach my $file_to_clean (@files_to_clean)
	{
		if ($exeonfiles eq "y") { `rm -rf $file_to_clean`; }
		print TOSHELL
		  "rm -rf $file_to_clean\n";
	}
}    # END SUB morph



#########################################################################################
#########################################################################################
#########################################################################################
# HERE FOLLOWS THE CONTENT OF THE FILE "opts_morph.pl", which has been merged here
# TO AVOID COMPLICATION WITH THE PERL MODULE INSTALLATION.

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
	my $zone_letter = shift;
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

			if ($exeonfiles eq "y") 
			{
				print
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
YYY

`;
#################################
			}
			print TOSHELL
#########################
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
\n\n";
#########################
		}
	}
}    # end sub translate
					
					
my $countercycles_transl_surfs = 0;					
##############################################################################


##############################################################################					
sub translate_surfaces_simple # THIS IS VERSION 1: THE OLD ONE. DISMISSED? IN DOUBT, DO NOT USE IT. 
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = shift;
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
				if ($exeonfiles eq "y") 
				{ 
					print 
#########################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
YYY

`;
#########################################
				}
				print TOSHELL
#################################
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
#################################

				if ($exeonfiles eq "y") 
				{ 
					print
#########################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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

`;
#########################################
				}
				print TOSHELL
#################################
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
YYY\n\n";
#################################
				$countersurface++;
				$countercycles_transl_surfs++;
			}
		}
	}
}    # end sub translate_surfaces_simple
##############################################################################					


##############################################################################
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
	my $zone_letter = shift;
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
						if ($exeonfiles eq "y") { 
						print 
#################################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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

`;
#################################################
					}
					print TOSHELL
#########################################
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
YYY\n\n";
#########################################
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
					
					if ($exeonfiles eq "y") 
					{ 
						print 
#################################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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

`;
#########################################
					}
					print TOSHELL
#########################################
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
YYY\n\n";
#########################################
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
	my $zone_letter = shift;
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
				if ($exeonfiles eq "y") 
				{ 
					print
#########################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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

`;
#########################################
				}

				print  TOSHELL
#################################
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
#################################
			}
			$counterrotate++;
		}
	}
}    # END SUB rotate_surface
##############################################################################


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
	my $zone_letter = shift;
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
					
					if ($exeonfiles eq "y") 
					{ 
						print 
#################################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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

`;
#################################################
					}
					print TOSHELL
#########################################
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
\n\n";
#########################################
					$counterthis++;
				}
			}
			elsif ($movementtype eq "h")
			{
				foreach my $shift_swing (@shift_swings)
				{
					if ($exeonfiles eq "y") 
					{ 
						print 
#################################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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

`;
#################################################
					}
					print TOSHELL
#########################################
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
#########################################
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
	my $zone_letter = shift;
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
		if ($exeonfiles eq "y") 
		{ 
			print
#########################
`prj -file $to/cfg/$fileconfig -mode script<<YYY


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

`;
#########################
		}
		print TOSHELL
#################
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
-
-
-
-
-
-
-
YYY\n\n";
#################
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
	my $zone_letter = shift;
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
	my $zone_letter = shift;
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
	my $zone_letter = shift;
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
			
			if ($exeonfiles eq "y") 
			{ 
				print 
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
`;
#################################
			}

			print TOSHELL 
#########################
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
#########################
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
	my $zone_letter = shift;
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
				if ($exeonfiles eq "y") 
				{ 
					print
#########################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY
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

`;
#########################################
				}
				print TOSHELL
#################################
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
#################################
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
		my $zone_letter = shift;
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
					
			foreach my $obs_letter (@obs_letters)
			{
				if ($exeonfiles eq "y") 
				{ 
					print
#########################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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

`; 
#########################################
				}
				print TOSHELL
#################################
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
\n\n";
#################################
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
					if ($exeonfiles eq "y") 
					{ 
						print
#################################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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

`; 
#################################################
					}
					print TOSHELL
#########################################
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
\n\n";
#########################################
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
							if ($exeonfiles eq "y") 
							{ 
								print
#################################################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
`; 
#################################################################
							}
							print TOSHELL
#########################################################
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
\n\n";
#################################################
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
				if ($exeonfiles eq "y")
				{ 
					print
#########################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
`;
#########################################
				}
				print TOSHELL
#################################
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
\n\n";
#################################
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
				if ($exeonfiles eq "y") 
				{ 
					print
#########################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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

`;
#########################################
				}
				print TOSHELL
#################################
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
\n";
#################################
				$countobs++;
				}
			}
		
			#NOW THE XZ GRID RESOLUTION WILL BE PUT TO THE SPECIFIED VALUE				 
			if ($exeonfiles eq "y") 
			{ 
				print
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY


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
`;
#################################
			}
			print TOSHELL
#########################
"
#THIS IS WHAT HAPPEN INSIDE SUB KEEP_SOME_OBSTRUCTIONS
prj -file $to/cfg/$fileconfig -mode script<<YYY


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
\n";
#########################
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
	my $zone_letter = shift;
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
			my $rotation_y = "$obstruction_to_keep[2]"; #NOT IMPLEMENTED YET
			my $x_origin   = "$obstruction_to_keep[3]";
			my $y_origin   = "$obstruction_to_keep[4]";
			my $z_origin   = "$obstruction_to_keep[5]";
			# KEEP IN MIND THAT $rotation_degrees used here is absolute, not local. 
			# This is dangerous and it has to change.
			 
			if ($exeonfiles eq "y") 
			{ 
				print
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY


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

`; 
#########################
			}
			print TOSHELL
#########################
"
#THIS IS WHAT HAPPEN INSIDE SUB KEEP_SOME_OBSTRUCTIONS
prj -file $to/cfg/$fileconfig -mode script<<YYY


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

\n";
#########################
			$keep_obs_counter++;
		}

		#NOW THE XZ GRID RESOLUTION WILL BE PUT TO THE SPECIFIED VALUE				 
		if ($exeonfiles eq "y") 
		{ 
			print
#########################
`prj -file $to/cfg/$fileconfig -mode script<<YYY


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
`;
#########################
		}
		print TOSHELL
#################
"
#THIS IS WHAT HAPPEN INSIDE SUB KEEP_SOME_OBSTRUCTIONS
prj -file $to/cfg/$fileconfig -mode script<<YYY


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
\n";
#################
	}
}    # END SUB bring_obstructions_back
##############################################################################					


##############################################################################
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
	my $zone_letter = shift;
	my $zone_letter = $applytype[$counterzone][3];
	
	if ($exeonfiles eq "y") 
	{ 
		print 
#################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
h
a
e
a
a

-
-
a
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

\n`; 
#########
	}

	print TOSHELL 
#########
"# THIS IS WHAT HAPPENS INSIDE RECALCULATEISH
prj -file $to/cfg/$fileconfig -mode script<<YYY

m
c
a
$zone_letter
h
a
e
a
a

-
-
a
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

\n";
#########
} #END SUB RECALCULATEISH
##############################################################################					


##############################################################################					
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
	my $zone_letter = shift;
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
	
	if ($y_or_n_reassign_cp == "y")
	{										
		eval `cat $configaddress`; # HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS 
		# IS EVALUATED, AND HERE BELOW CONSTRAINTS ARE PROPAGATED. 
		# THE USE OF "eval" HERE ALLOWS TO WRITE CONDITIONS IN THE FILE 
		# AS THEY WERE DIRECTLY WRITTEN IN THE CALLING FILE.
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
				if ($exeonfiles eq "y") 
				{ 
					print 
#########################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY


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
`; 
#########################################
				}

				print TOSHELL 
#################################
"#THIS IS WHAT HAPPENS INSIDE RECALCULATENET
prj -file $to/cfg/$fileconfig -mode script<<YYY


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
#################################
				$counternode++;
			}
			elsif ( $nodetype eq "3")							
			{	
				if ($y_or_n_reassign_cp == "y")
				{
					if ($exeonfiles eq "y") 
					{ 
						print 
#################################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY


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
`; 
#################################################
					}

					print TOSHELL 
#########################################
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
#########################################
					$counternode++;
				}
			}
		}

		my @node_letters = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", 
		"q", "r", "s", "t", "u", "v", "w", "x", "y", "z");
		if ( ($mode eq "componentmode") and ( $line =~ "opening"))
		{
			if ($exeonfiles eq "y") 
			{ 
				print 
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY


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
`; 
#################################
			}

			print TOSHELL 
#########################
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
#########################
			$counteropening++;
			$counterthing++;
		}
		elsif ( ($mode eq "componentmode") and ( $line =~ "crack "))
		{
			if ($exeonfiles eq "y") 
			{ 
				print 
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY


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
`; 
#################################	
			}

			print TOSHELL 
#########################
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
#########################
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
	my $zone_letter = shift;
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

			if (-e $configaddress) 
			{	
				eval `cat $configaddress`; # HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS 
				# IS EVALUATED, AND HERE BELOW CONSTRAINTS ARE PROPAGATED.
				# THE USE OF "eval" HERE ALLOWS TO WRITE CONDITIONS IN THE FILE AS THEY WERE 
				# DIRECTLY WRITTEN IN THE CALLING FILE.
				my $countervertex = 0;
				foreach (@v)
				{
					if ($countervertex > 0)
					{			
						my $vertexletter = $vertexletters[$countervertex-1];
						if ($vertexletter ~~ @work_values)
						{
							if ($exeonfiles eq "y") 
							{ 
								print 
#################################################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
\n`; 
#################################################################
							}

							print TOSHELL 
#########################################################
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
\n";
#########################################################
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
	my $zone_letter = shift;
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
				# THE USE OF "eval" HERE ALLOWS TO WRITE CONDITIONS IN THE FILE AS THEY WERE DIRECTLY 
				# WRITTEN IN THE CALLING FILE.							
			
				my $countervertex = 0;
				
				foreach (@v)
				{
					if ($countervertex > 0)
					{
						my $vertexletter = $vertexletters[$countervertex];
						if ($vertexletter  ~~ @work_letters)
						{
							if ($exeonfiles eq "y") 
							{ 
								print 
#################################################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
\n`; 
#################################################################
							}

							print TOSHELL 
#########################################################
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
\n";
#################################################
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


##############################################################################
sub translate_vertexes #STILL UNFINISHED, NOT WORKING. PROBABLY ALMOST FINISHED. ON THE BRINK OF IT. The reference to @base_coordinates is not working
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = shift;
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
				# THE USE OF "eval" HERE ALLOWS TO WRITE CONDITIONS IN THE FILE AS THEY WERE DIRECTLY
				# WRITTEN IN THE CALLING FILE.

			my $countervertex = 0;
														
			foreach my $vertex_letter (@vertexletters)
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
									
						if ($exeonfiles eq "y") 
						{ 
							print 
#########################################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
YYY\n`; 
#########################################################
						}

						print TOSHELL
#################################################
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
YYY\n\n";
#################################################
					}
				}
				$countervertex++;
			}
		}
		$counteroperations++;
	}
} # END SUB translate_vertexes
					

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
	my $zone_letter = shift;
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
				if ($exeonfiles eq "y") 
				{ 
					print
#########################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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

`; 
#########################################
				}
				print  TOSHELL
#################################
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
#################################
			}
			$counterrotate++;
		}
	
		# THIS SECTION READS THE CONFIGFILE FOR DIMENSIONS
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
			# AND PROPAGATED. THE USE OF "eval" HERE ALLOWS TO WRITE CONDITIONS IN THE FILE AS THEY WERE 
			# DIRECTLY WRITTEN IN THE CALLING FILE.
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
		
				if ($exeonfiles eq "y") 
				{ 
					print 
#########################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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

`; 
#########################################
				}
				print TOSHELL
#################################
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
\n\n";
#################################
			}
			$counterthis++;
		}
	}
}    # END SUB warp
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
	my $zone_letter = shift;
	my $filedf = shift;
	my $swap2 = shift;
	my @daylightcalc = @$swap2;
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
	
	if ($exeonfiles eq "y") 
	{ 
		print 
#################
`
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
`; 
#################
	}

	print TOSHELL 
#########
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
-
YYY
\n\n
cd $mypath
";
#########

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
sub daylightcalc_new_proposed # NOT USED. THE DIFFERENCE WITH THE ABOVE IS THAT IS WORKS IF THE RAD DIRECTORY IS NOT EMTY. 
{
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = shift;
	my $filedf = shift;
	my $swap2 = shift;
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
	
	if ($exeonfiles eq "y") 
	{ 
		print 
#################
`
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
`; 
#################
	}

	print TOSHELL 
#########
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
#########
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
	my $zone_letter = shift;
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


sub checkfile # THIS FUNCTION DOES BETTER WHAT IS ALSO DONE BY THE PREVIOUS ONE.
{
	# THIS CHECKS IF A SOURCE FILE MUST BE SUBSTITUTED BY ANOTHER BEFORE THE TRANSFORMATIONS BEGIN.
	# IT HAS TO BE CALLED WITH: checkfile($sourceaddress, $targetaddress);
	my $sourceaddress = shift;
	my $targetaddress = shift;
	unless ( ($sourceaddress eq "" ) or ( $targetaddress eq "" ))
	{
		print "TARGETFILE IN FUNCTION: $targetaddress\n";
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


sub change_climate ### IT HAS TO BE DEBUGGED. WHY IT BLOCKS IF PRINTED TO THE SHELL?
{	# THIS FUNCTION CHANGES THE CLIMATE FILES. 
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my @applytype = @$swap;
	my $zone_letter = shift;
	my $swap = shift;
	my @change_climate = @$swap;
	my @climates = @{$change_climate[$counterzone]};
	my $climate = $climates[$counterstep-1];
	
	if ($exeonfiles eq "y")
	{
		print
#################
`prj -file $to/cfg/$fileconfig -mode script<<ZZZ

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
`;
#################
	}
	print TOSHELL
#########
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
#########
}


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
	my $zone_letter = shift;
	my $swap = shift;
	my @constrain_geometry = @$swap;
	my $to_do = shift;

	# print "YOUCALLED!\n\n";
	# print "HERE: \@constrain_geometry:" . Dumper(@constrain_geometry) . "\n\n";
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
		# print "INSIDE: \@constrain_geometry:" . Dumper(@constrain_geometry) . "\n\n";
		# print "INSIDE: \@group:" . Dumper(@group) . "\n\n";
		my $zone_letter = $group[1];
		my $sourcefile = $group[2];
		my $targetfile = $group[3];
		my $configfile = $group[4];
		my $sourceaddress = "$to$sourcefile";
		my $targetaddress = "$to$targetfile";
		my @work_letters = @{$group[5]}; 
		my $longmenus = $group[6]; 
		
		# print "VARIABLES: \$to:$to, \$fileconfig:$fileconfig, \$stepsvar:$stepsvar, \$counterzone:$counterzone, \$counterstep:$counterstep, \$exeonfiles:$exeonfiles, 
		# \$zone_letter:$zone_letter, \$sourceaddress:$sourceaddress, \$targetaddress:$targetaddress, \$longmenus:$longmenus, \@work_letters, " . Dumper(@work_letters) . "\n\n";

		unless ($to_do eq "justwrite")
		{
			checkfile($sourceaddress, $targetaddress);
			read_geometry($to, $sourcefile, $targetfile, $configfile, \@work_letters, $longmenus);
			read_geo_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $configaddress, \@v);
		}
		
		unless ($to_do eq "justread")
		{
			apply_geo_constraints(\@v, \@vertexletters, \@work_letters, $exeonfiles, $zone_letter);
		}
		# print "\@v: " . Dumper(@v) . "\n\n";
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
} # END SUB read_geometry


sub read_geo_constraints
{	
	# THIS FILE IS FOR OPTS TO READ GEOMETRY USER-IMPOSED CONSTRAINTS
	# IT IS CALLED WITH: read_geo_constraints($configaddress);
	# THIS MAKES AVAILABLE TO THE USER FOR MANIPULATION THE VERTEXES IN THE GEOMETRY FILES, IN THE FOLLOWING FORM:
	# @v[$number][$x], @v[$number][$y], @v[$number][$z]. EXAMPLE: @v[4][$x] = 1. OR: @v[4][$x] =  @v[4][$y].
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
	my @v = @$swap;
	my $x = 0;
	my $y = 1;
	my $z = 2;
	unshift (@v, [ "vertexes of  $sourceaddress", [], [] ]);
	if (-e $configaddress)
	{				

		eval `cat $configaddress`; # HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS IS EVALUATED.
		# THE USE OF "eval" HERE ALLOWS TO WRITE CONDITIONS IN THE FILE AS THEY WERE DIRECTLY 
		# WRITTEN IN THE CALLING FILE.
		shift (@v);
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
	# print "\@vertexletters: " . Dumper(@vertexletters) . "\n\n";
	
	my $swap = shift;
	my @work_letters = @$swap;
	# print "\@work_letters" . Dumper(@work_letters) . "\n\n";
	
	my $exeonfiles = shift;
	# print "exeonfiles: $exeonfiles\n\n";
	my $zone_letter = shift;
	my $countervertex = 0;
	
	# print "\@v: " . Dumper(@v) . "\n\n";
	foreach my $v (@v)
	{
		my $vertexletter = $vertexletters[$countervertex];
		if ( ( @work_letters eq "") or ($vertexletter  ~~ @work_letters) )
		{ 
			if ($exeonfiles eq "y") 
			{
				# print "YES. \$v:" . Dumper($v) . "\n\n";
				print
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
\n`; 
#################################
				}

				print TOSHELL 
#########################
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
\n";
##########################
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
	my $zone_letter = shift;
	my $swap = shift;
	my @vary_controls = @$swap;
	# print "FIRST: \$to:$to, \$fileconfig:$fileconfig, \$stepsvar:$stepsvar, \$counterzone:$counterzone, \$counterstep:$counterstep, \@applytype:@applytype, \@vary_controls:@vary_controls\n\n";
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
	my $loop_control_letter;
	
	my @group = @{$vary_controls[$counterzone]};
	# print "SECOND: \@group: " . Dumper(@group) . "\n\n";
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
	# print "Dumper\@vary_controls\: " . Dumper(@vary_controls) ."\n\@\{\$vary_controls\[0\]\} : @{$vary_controls[0]}\n"
	#. "Dumper\@applytype\: " . Dumper(@applytype) . 
	# print "THIRD: \$sourcefile:$sourcefile, \$targetfile:$targetfile, \$configfile:$configfile, \@swing_zone_hours:@swing_zone_hours, \@swing_max_heating_powers:@swing_max_heating_powers, \@swing_max_cooling_powers:@swing_max_cooling_powers, \@swing_min_cooling_powers:@swing_min_cooling_powers, \@swing_heating_setpoints:@swing_heating_setpoints, \@swing_cooling_setpoints:@swing_cooling_setpoints, \@swing_zone_hours:@swing_zone_hours, \@swing_zone_setpoints:@swing_zone_setpoints, \$sourceaddress:$sourceaddress, \$targetaddress:$targetaddress, \$configaddress:$configaddress."  .
	# "\n\n"; 

	#@loop_control; # DON'T PUT "my" HERE.
	#@flow_control; # DON'T PUT "my" HERE.
	#@new_loop_controls; # DON'T PUT "my" HERE.
	#@new_flow_controls; # DON'T PUT "my" HERE.
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
				
	# print "RESULT. ZONE CONTROLS: " . Dumper( @loop_control) . "\nFLOW CONTROLS: " . Dumper(@flow_control) . "\n\n";
	
	calc_newctl($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@buildbulk, 
	\@flowbulk, \@loop_control, \@flow_control);
	
	# print OUTFILE "NEW LOOP CONTROLS OUTSIDE " . Dumper(@new_loop_controls) . "\n\n";
	
	
	sub calc_newctl
	{	# TO BE CALLED WITH: calc_newcontrols($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@buildbulk, \@flowbulk, \@loop_control, \@flow_control);
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
		my @loop_control = @$swap;
		my $swap = shift;
		my @flow_control = @$swap;
		# print OUTFILE "RESULT. ZONE CONTROLS: " . Dumper( @loop_control) . "\nFLOW CONTROLS: " . Dumper(@flow_control) . "\n\n";
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
				my $new_loop_control_letter = $askloop[1];
				my $swing_loop_hour = $askloop[2];
				my $swing_max_heating_power = $askloop[3];
				my $swing_min_heating_power = $askloop[4];
				my $swing_max_cooling_power = $askloop[5];
				my $swing_min_cooling_power = $askloop[6];
				my $swing_heating_setpoint = $askloop[7];
				my $swing_cooling_setpoint = $askloop[8];
				#print "NOW: \$swing_loop_hour:$swing_loop_hour, \$swing_max_heating_power:$swing_max_heating_power, \$swing_min_heating_power:$swing_min_heating_power, \$swing_max_cooling_power:$swing_max_cooling_power, \$swing_min_cooling_power:$swing_min_cooling_power,  \$swing_heating_setpoint:$swing_heating_setpoint, \$swing_cooling_setpoint:$swing_cooling_setpoint\n\n";
				
				my $countloop = 0; #IT IS FOR THE FOLLOWING FOREACH. LEAVE IT ATTACHED TO IT.
				foreach $each_loop (@loop_control) # THIS DISTRIBUTES THIS NESTED DATA STRUCTURES IN A FLAT MODE TO PAIR THE INPUT FILE, USER DEFINED ONE.
				{
					my $countcontrol = 0;
					@thisloop = @{$each_loop};
					# print "\@thisloop:@thisloop\n\n";
					# my $letterfile = $letters[$countloop];
					foreach $lp (@thisloop)
					{
						my @control = @{$lp};
						# print OUTFILE "\@control:@control\n";
						#print "\$countcontrol:$countcontrol\n";
						# my $letterfilecontrol = $period_letters[$countcontrol];
						$loop_letter = $loop_control[$countloop][$countcontrol][0];
						$loop_control_letter = $loop_control[$countloop][$countcontrol][1];
						#print "\$new_loop_letter:$new_loop_letter, \$loop_letter:$loop_letter, \$new_loop_control_letter:$new_loop_control_letter, \$loop_control_letter:$loop_control_letter\n";
						if ( ( $new_loop_letter eq $loop_letter ) and ($new_loop_control_letter eq $loop_control_letter ) )
						{
							# print "YES!: \n\n\n";
							$loop_hour__ = $loop_control[$countloop][$countcontrol][$loop_hour];
							$max_heating_power__ = $loop_control[$countloop][$countcontrol][$max_heating_power];
							$min_heating_power__ = $loop_control[$countloop][$countcontrol][$min_heating_power];
							$max_cooling_power__ = $loop_control[$countloop][$countcontrol][$max_cooling_power];
							$min_cooling_power__ = $loop_control[$countloop][$countcontrol][$min_cooling_power];
							$heating_setpoint__ = $loop_control[$countloop][$countcontrol][$heating_setpoint];
							$cooling_setpoint__ = $loop_control[$countloop][$countcontrol][$cooling_setpoint];
							# print OUTFILE "NOW: \$new_loop_letter:$new_loop_letter, \$new_loop_control_letter:$new_loop_control_letter, \$loop_hour__:$loop_hour__, \$max_heating_power__:$max_heating_power__,  \$min_heating_power__:$min_heating_power__, \$max_cooling_power__:$max_cooling_power__, \$min_cooling_power__:$min_cooling_power__, \$heating_setpoint__:$heating_setpoint__, \$cooling_setpoint__:$cooling_setpoint__\n\n";
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
				# print "NOWNEW: \$new_loop_hour:$new_loop_hour, \$new_max_heating_power:$new_max_heating_power, \$new_min_heating_power:$new_min_heating_power, \$new_max_cooling_power:$new_max_cooling_power, \$new_min_cooling_power:$new_min_cooling_power, \$new_heating_setpoint:$new_heating_setpoint, \$new_cooling_setpoint:$new_cooling_setpoint. \n\n";
				
				$new_loop_hour = sprintf("%.2f", $new_loop_hour);
				$new_max_heating_power = sprintf("%.2f", $new_max_heating_power);
				$new_min_heating_power = sprintf("%.2f", $new_min_heating_power);
				$new_max_cooling_power = sprintf("%.2f", $new_max_cooling_power);
				$new_min_cooling_power = sprintf("%.2f", $new_min_cooling_power);
				$new_heating_setpoint = sprintf("%.2f", $new_heating_setpoint);
				$new_cooling_setpoint = sprintf("%.2f", $new_cooling_setpoint);
				
				push(@new_loop_controls, 
				[ $new_loop_letter, $new_loop_control_letter, $new_loop_hour, 
				$new_max_heating_power, $new_min_heating_power, $new_max_cooling_power, 
				$new_min_cooling_power, $new_heating_setpoint, $new_cooling_setpoint ] );
			}

			# print OUTFILE "NEW LOOP CONTROLS INSIDE: " . Dumper(@new_loop_controls) . "\n\n";

			my $countflow = 0;
			# print "\@buildbulk: " . Dumper(@buildbulk) . "\n\n"; print "\@flowbulk: " . Dumper(@flowbulk) . "\n\n";
			foreach my $elm (@flowbulk)
			{
				my @askflow = @{$elm};
				my $new_flow_letter = $askflow[0];
				my $new_flow_control_letter = $askflow[1];
				my $swing_flow_hour = $askflow[2];
				my $swing_flow_setpoint = $askflow[3];
				my $swing_flow_onoff = $askflow[4];
				if ( $swing_flow_onoff eq "ON") { $swing_flow_onoff = 1; }
				elsif ( $swing_flow_onoff eq "OFF") { $swing_flow_onoff = -1; }
				my $swing_flow_fraction = $askflow[5];
				#print "\$new_flow_letter:$new_flow_letter, \$new_flow_control_letter:$new_flow_control_letter, \$swing_flow_hour:$swing_flow_hour, \$swing_flow_setpoint:$swing_flow_setpoint, \$swing_flow_onoff:$swing_flow_onoff, \$swing_flow_fraction:$swing_flow_fraction. \n\n";
				
				my $countflow = 0; #IT IS FOR THE FOLLOWING FOREACH. LEAVE IT ATTACHED TO IT.
				foreach $each_flow (@flow_control) # THIS DISTRIBUTES THIS NESTED DATA STRUCTURES IN A FLAT MODE TO PAIR THE INPUT FILE, USER DEFINED ONE.
				{
					my $countcontrol = 0;
					@thisflow = @{$each_flow};
					# print "\@thisflow:@thisflow\n\n";
					# my $letterfile = $letters[$countflow];
					foreach $elm (@thisflow)
					{
						my @control = @{$elm};
						# print "\@control:@control\n";
						#print "\$countcontrol:$countcontrol\n";
						# my $letterfilecontrol = $period_letters[$countcontrol];
						$flow_letter = $flow_control[$countflow][$countcontrol][0];
						$flow_control_letter = $flow_control[$countflow][$countcontrol][1];
						if ( ( $new_flow_letter eq $flow_letter ) and ($new_flow_control_letter eq $flow_control_letter ) )
						{
							$flow_hour__ = $flow_control[$countflow][$countcontrol][$flow_hour];
							$flow_setpoint__ = $flow_control[$countflow][$countcontrol][$flow_setpoint];
							$flow_onoff__ = $flow_control[$countflow][$countcontrol][$flow_onoff];
							if ( $flow_onoff__ eq "ON") { $flow_onoff__ = 1; }
							elsif ( $flow_onoff__ eq "OFF") { $flow_onoff__ = -1; }
							$flow_fraction__ = $flow_control[$countflow][$countcontrol][$flow_fraction];
							#print "\$flow_letter:$flow_letter, \$flow_control_letter:$flow_control_letter, \$flow_hour__:$flow_hour__, \$flow_setpoint__:$flow_setpoint__, \$flow_onoff__:$flow_onoff__, \$flow_fraction__:$flow_fraction__. \n\n";
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
				
				# print "THIS: \$flow_letter:$flow_letter, \$new_flow_hour:$new_flow_hour,  \$new_flow_setpoint:$new_flow_setpoint, \$new_flow_onoff:$new_flow_onoff, \$new_flow_fraction:$new_flow_fraction \n\n";
				push(@new_flow_controls, 
				[ $new_flow_letter, $new_flow_control_letter, $new_flow_hour,  $new_flow_setpoint, $new_flow_onoff, $new_flow_fraction ] );
				# print "IN1: \@new_flow_controls: " . Dumper(@new_flow_controls) . "\n\n";
			}
			# HERE THE MODIFICATIONS TO BE EXECUTED ON EACH PARAMETERS ARE APPLIED TO THE MODELS THROUGH ESP-r.
			# FIRST, HERE THEY ARE APPLIED TO THE ZONE CONTROLS, THEN TO THE FLOW CONTROLS
			#print "IN2: \@new_flow_controls: " . Dumper(@new_flow_controls) . "\n\n";
		}
		#print "IN3: \@new_flow_controls: " . Dumper(@new_flow_controls) . "\n\n";
	} # END SUB calc_newcontrols
	# print "OUT4: \@new_loop_controls: " . Dumper(@new_loop_controls) . "\n\n";
	# print "OUT4: \@new_flow_controls: " . Dumper(@new_flow_controls) . "\n\n";
	# print "OUT4: \@loop_control: " . Dumper(@loop_control) . "\n\n";
	# print "OUT4: \@flow_control: " . Dumper(@flow_control) . "\n\n";
	
	print OUTFILE "\@new_loop_controls: " . Dumper(@new_loop_controls) . "\n\n";

	apply_loopcontrol_changes($exeonfiles, \@new_loop_controls);
	apply_flowcontrol_changes($exeonfiles, \@new_flow_controls);
	
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
	my $zone_letter = shift;
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
	# print "\$sourcefile:$sourcefile, \$targetfile:$targetfile, \$configfile:$configfile. \n\n";
	# print "FIRST: \$to:$to, \$fileconfig:$fileconfig, \$stepsvar:$stepsvar, \$counterzone:$counterzone, \$counterstep:$counterstep, \@applytype:@applytype, \@group:@group\n\n";
	#@loop_control; @flow_control; @new_loop_controls; @new_flow_controls; # DON'T PUT "my" HERE. THEY ARE GLOBAL!!!
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
	my $loop_control_letter;
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
			print "THIS\n";
			checkfile($sourceaddress, $targetaddress);
			read_controls($sourceaddress, $targetaddress, \@letters, \@period_letters);
			read_control_constraints($to, $fileconfig, $stepsvar, 
			$counterzone, $counterstep, $configaddress, \@loop_control, \@flow_control);
		}
	}
	
	unless ($to_do eq "justread")
	{
		print "THAT\n";
		apply_loopcontrol_changes($exeonfiles, \@new_loop_control);
		apply_flowcontrol_changes($exeonfiles, \@new_flow_control);
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
	my $loop_control_letter;
	my $flow_letter;
	my $flow_control_letter;
	
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
			# print "\nHERE\n",
			$countloopcontrol++;
			my @row = split(/\s+/, $line);
			$loop_hour = $row[3];
			$semaphore_loopcontrol = "yes";
			$loop_control_letter = $period_letters[$countloopcontrol];
			#print "HEREINSIDE PUSH $count: \$countloop:$countloop, \$countloopcontrol:$countloopcontrol, \$loop_control_letter:$loop_control_letter. \n";
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

			push(@{$loop_control[$countloop][$countloopcontrol]}, 
			$loop_letter, $loop_control_letter, $loop_hour, 
			$max_heating_power, $min_heating_power, $max_cooling_power, 
			$min_cooling_power, $heating_setpoint, $cooling_setpoint );

			$semaphore_loopcontrol = "no";
			$doline = "";
		}

		if ($line =~ /Control mass/ )
		{
			# print "CON\n\n";
			$semaphore_flow = "yes";
			$countflowcontrol = -1;
			$countflow++;
			$flow_letter = $letters[$countflow];
		}
		if ( ($line =~ /ctl type \(/ ) )
		{
			# print "CTL\n\n";
			$countflowcontrol++;
			my @row = split(/\s+/, $line);
			$flow_hour = $row[3];
			$semaphore_flowcontrol = "yes";
			$flow_control_letter = $period_letters[$countflowcontrol];
			# print "HEREINSIDE PUSH $count: \$countflow:$countflow, \$countflowcontrol:$countflowcontrol, \$flow_control_letter:$flow_control_letter. \n";
		}

		if ( ($semaphore_flow eq "yes") and ($semaphore_flowcontrol eq "yes") and ($line =~ /No. of data items/ ) ) 
		{  
			#print "DOLINE\n\n";
			$doline = $counterlines + 1;
		}
		
		if ( ($semaphore_flow eq "yes" ) and ($semaphore_flowcontrol eq "yes") and ($counterlines == $doline) ) 
		{
			my @row = split(/\s+/, $line);
			my $flow_setpoint = $row[1];
			my $flow_onoff = $row[2];
			my $flow_fraction = $row[3];
			push(@{$flow_control[$countflow][$countflowcontrol]}, 
			$flow_letter, $flow_control_letter, $flow_hour, $flow_setpoint, $flow_onoff, $flow_fraction);
			$semaphore_flowcontrol = "no";
			# print "DOTHIS: " . Dumper(@flow_control) . "\n\n";
			$doline = "";
		}
		$counterlines++;
	}
	
	# print "LOOP_CONTROL: " . Dumper(@loop_control) . "\n\n!";
	# print "FLOW_CONTROL: " . Dumper(@flow_control) . "\n\n!";			
} # END SUB read_controls.


sub read_control_constraints
{
	#  #!/usr/bin/perl
	# THIS FILE CAN CONTAIN USER-IMPOSED CONSTRAINTS FOR CONTROLS TO BE READ BY OPTS.
	# THE FOLLOWING VALUES CAN BE ADDRESSED IN THE OPTS CONSTRAINTS CONFIGURATION FILE, 
	# SET BY THE PRESENT FUNCTION:
	# 1) $loop_control[$countloop][$countloopcontrol][$loop_hour] 
	# Where $countloop and  $countloopcontrol has to be set to a specified number in the OPTS file for constraints.
	# 2) $loop_control[$countloop][$countloopcontrol][$max_heating_power] # Same as above.
	# 3) $loop_control[$countloop][$countloopcontrol][$min_heating_power] # Same as above.
	# 4) $loop_control[$countloop][$countloopcontrol][$max_cooling_power] # Same as above.
	# 5) $loop_control[$countloop][$countloopcontrol][$min_cooling_power] # Same as above.
	# 6) $loop_control[$countloop][$countloopcontrol][heating_setpoint] # Same as above.
	# 7) $loop_control[$countloop][$countloopcontrol][cooling_setpoint] # Same as above.
	# 8) $flow_control[$countflow][$countflowcontrol][$flow_hour] 
	# Where $countflow and  $countflowcontrol has to be set to a specified number in the OPTS file for constraints.
	# 9) $flow_control[$countflow][$countflowcontrol][$flow_setpoint] # Same as above.
	# 10) $flow_control[$countflow][$countflowcontrol][$flow_onoff] # Same as above.
	# 11) $flow_control[$countflow][$countflowcontrol][$flow_fraction] # Same as above.
	# EXAMPLE : $flow_control[1][2][$flow_fraction] = 0.7
	# OTHER EXAMPLE: $flow_control[1][2][$flow_fraction] = $flow_control[2][1][$flow_fraction]
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
	# print "\nCONFIGADDRESS: $configaddress\n\n";
	my $swap = shift;
	@loop_control = @$swap;
	my $swap = shift;
	@flow_control = @$swap;
	unshift (@loop_controls, []);
	unshift (@flow_controls, []);
	if (-e $configaddress) # TEST THIS, DDD
	{	# THIS APPLIES CONSTRAINST, THE FLATTEN THE HIERARCHICAL STRUCTURE OF THE RESULTS,
		# TO BE PREPARED THEN FOR BEING APPLIED TO CHANGE PROCEDURES. IT IS TO BE TESTED.
		eval `cat $configaddress`;	# HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS 
		# IS EVALUATED, AND HERE BELOW CONSTRAINTS ARE PROPAGATED.
		# THE USE OF "eval" HERE ALLOWS TO WRITE CONDITIONS IN THE FILE AS THEY WERE DIRECTLY 
		# WRITTEN IN THE CALLING FILE.		
		
		# print "BEFORE loop_control: " . Dumper(@loop_control) . "\n\n";
		# print "BEFORE flow_control: " . Dumper(@flow_control) . "\n\n";
		shift (@loop_controls);
		shift (@flow_controls);
		
		sub flatten_loopcontrol_constraints
		{
			my @looptemp = @loop_control;
			@new_loop_control = "";
			foreach my $elm (@looptemp)
			{
				my @loop = @{$elm};
				foreach my $elm (@loop)
				{
					my @loop = @{$elm};
					push (@new_loop_control, [@loop]);
				}
			}
		}
		flatten_loopcontrol_constraints;
				
		sub flatten_flowcontrol_constraints
		{
			my @flowtemp = @flow_control;
			@new_flow_control = "";
			foreach my $elm (@flowtemp)
			{
				my @flow = @{$elm};
				foreach my $elm (@flow)
				{
					my @loop = @{$elm};
					push (@new_flow_control, [@flow]);
				}
			}
		}
		flatten_flowcontrol_constraints;
		
		shift @new_loop_control;
		shift @new_flow_control;
		
		# print "AFTER loop_control: " . Dumper(@new_loop_control) . "\n\n";
		# print "AFTER flow_control: " . Dumper(@new_flow_control) . "\n\n";
	}
} # END SUB read_control_constraints


sub apply_loopcontrol_changes
{ 	# TO BE CALLED WITH: apply_loopcontrol_changes($exeonfiles, \@new_loop_control);
	# THIS APPLIES CHANGES TO LOOPS IN CONTROLS (ZONES)
	my $exeonfiles = shift;
	# print OUTFILE "\$exeonfileshere:$exeonfiles\n\n";
	my $swap = shift;
	my @new_loop_ctls = @$swap;
	# print OUTFILE "\@new_loop_ctls at \$counterstep $counterstep:" . Dumper(@new_loop_ctls) . "\n\n";
	my $counter = 0;
	
	foreach my $elm (@new_loop_ctls)
	{
		my @loop = @{$elm};
		# print OUTFILE "PASSED2: \@loop: @loop \n\n";
		$new_loop_letter = $loop[0];
		$new_loop_control_letter = $loop[1];
		$new_loop_hour = $loop[2];
		$new_max_heating_power = $loop[3];
		$new_min_heating_power = $loop[4];
		$new_max_cooling_power = $loop[5];
		$new_min_cooling_power = $loop[6];
		$new_heating_setpoint = $loop[7];
		$new_cooling_setpoint = $loop[8];
		#print "PRINTONE\n";
		if ($exeonfiles eq "y") 
		{
			print 
#########################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

m
j

$new_loop_letter
c
$new_loop_control_letter
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
\n`;

#########################
		}
		print TOSHELL 
#################
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
j

$new_loop_letter
c
$new_loop_control_letter
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
-
-
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
\n";
#################
	}
} # END SUB apply_loopcontrol_changes();
	
	


sub apply_flowcontrol_changes
{	# THIS HAS TO BE CALLED WITH: apply_flowcontrol_changes($exeonfiles, \@new_flow_controls);
	# # THIS APPLIES CHANGES TO NETS IN CONTROLS
	my $exeonfiles = shift;
	my $swap = shift;
	my @new_flow_controls = @$swap;
	# print "\@new_flow_controls at \$counterstep $counterstep:" . Dumper(@new_flow_controls) . "\n\n";
	my $counter = 0;
	
	foreach my $elm (@new_flow_controls)
	{
		my @flow = @{$elm};
		$flow_letter = $flow[0];
		$flow_control_letter = $flow[1];
		$new_flow_hour = $flow[2];
		$new_flow_setpoint = $flow[3];
		$new_flow_onoff = $flow[4];
		$new_flow_fraction = $flow[5];
		if ($exeonfiles eq "y") # if ($exeonfiles eq "y") 
		{ 
			print 
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

m
l

$flow_letter
c
$flow_control_letter
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
\n`; 
#################################
		}

		print TOSHELL 
#########################
"prj -file $to/cfg/$fileconfig -mode script<<YYY

m
l

$flow_letter
c
$flow_control_letter
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
\n";
#########################
	}
} # END SUB apply_flowcontrol_changes;

# END OF SECTION DEDICATED TO FUNCTIONS FOR CONSTRAINING CONTROLS
##############################################################################
##############################################################################





##############################################################################
##############################################################################
# BEGINNING OF SECTION DEDICATED TO FUNCTIONS FOR CONSTRAINING OBSTRUCTIONS	

sub constrain_obstructions # IT APPLIES CONSTRAINTS TO ZONE GEOMETRY
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
	my $zone_letter = shift;
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
		#my @obs;
		#my @obs_letters;
		
		unless ($to_do eq "justwrite")
		{
			checkfile($sourceaddress, $targetaddress);
			read_obstructions($to, $sourceaddress, $targetaddress, $configaddress, \@work_letters, $actonmaterials, $exeonfiles);
			read_obs_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $configaddress, $actonmaterials, $exeonfiles); # IT WORKS ON THE VARIABLE @obs, WHICH IS GLOBAL.
		}
		
		unless ($to_do eq "justread")
		{
			apply_obs_constraints(\@obs, \@obs_letters, \@work_letters, $exeonfiles, $zone_letter, $actonmaterials, $exeonfiles);
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
	# print "\$sourceaddress:$sourceaddress, \$targetaddress:$targetaddress\n\n";
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
				#print $counter;
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
	#print "OBS_LETTERS IN READ" . Dumper(@obs_letters) . "\n\n";
	
	my $counter = 0;
	foreach my $line (@lines)
	{
		#print OUTFILE "$line\n";
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
	# print "OBS IN READ" . Dumper(@obs) . "\n\n";
} # END SUB read_obstructions


sub read_obs_constraints
{	
	# THE VARIABLE @obs REGARDS OBSTRUCTION USER-IMPOSED CONSTRAINTS
	# THIS CONSTRAINT CONFIGURATION FILE MAKES AVAILABLE TO THE USER THE FOLLOWING VARIABLES:
	# $obs[$obs_number][$x], $obs[$obs_number][$y], $obs[$obs_number][$y]
	# $obs[$obs_number][$width], $obs[$obs_number][$depth], $obs[$obs_number][$height]
	# $obs[$obs_number][$z_rotation], $obs[$obs_number][$y_rotation], 
	# $obs[$obs_number][$tilt], $obs[$obs_number][$opacity], $obs[$obs_number][$material], 
	# EXAMPLE: $obs[2][$x] = 2. THIS MEANS: COORDINATE x OF OBSTRUCTION HAS TO BE SET TO 2.
	# OTHER EXAMPLE: $obs[2][$x] = $obs[2][$y]. THIS MEANS: 
	# NOTE THAT THE MATERIAL TO BE SPECIFIED IS A MATERIAL LETTER, BETWEEN QUOTES! EXAMPLE: $obs[1][$material] = "a".
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
		eval `cat $configaddress`; # HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS IS EVALUATED.
		# THE USE OF "eval" HERE ALLOWS TO WRITE CONDITIONS IN THE FILE AS THEY WERE DIRECTLY 
		# WRITTEN IN THE CALLING FILE.
		shift @obs;
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
	#print "ZONE LETTER: $zone_letter\n\n";
	my $actonmaterials = shift;
	my $exeonfiles = shift;
	my $counterobs = 0;
	#print "WORK LETTERS BEFORE: " . Dumper(@work_letters) . "\n\n";
	#print "OBS IN APPLY " . Dumper(@obs) . "\n\n";
	print "OBS_LETTERS IN APPLY" . Dumper(@obs_letters) . "\n\n";
	foreach my $ob (@obs)
	{
		my $obs_letter = $obs_letters[$counterobs];
		#print "WORK LETTERS: " . Dumper(@work_letters) . "\n\n";
		#print "OBS_LETTERS " . Dumper(@obs_letters) . "\n\n";
		#print "OBS_LETTER " . Dumper($obs_letter) . "\n\n";
		if ( ( @work_letters eq "") or ($obs_letter  ~~ @work_letters) )
		{
			#print "WORK LETTERS IN " . Dumper(@work_letters) . "\n\n";
			#print "OBS_LETTERS IN " . Dumper(@obs_letters) . "\n\n";
			my @obs = @{$ob};
			my $x = $obs[0];
			my $y = $obs[1];
			my $z = $obs[2];
			my $width = $obs[3];
			my $depth = $obs[4];
			my $height = $obs[5];
			my $z_rotation = $obs[6];
			my $y_rotation = $obs[7];
			my $tilt = $obs[8];
			my $opacity = $obs[9];
			my $name = $obs[10];
			my $material = $obs[11];
			if ($exeonfiles eq "y") 
			{
				print
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
\n`; 
#################################
			}

			print TOSHELL 
#########################
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
\n";
#########################
		}
			
		my $obs_letter = $obs_letters[$counterobs];
		if ($obs_letter  ~~ @work_letters)
		{
			if ($actonmaterials eq "y")
			{			
				if ($exeonfiles eq "y") 
				{
					print
#########################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
\n`; 
#########################################
				}

				print TOSHELL 
#################################
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
\n";
#################################
			}
		}
		$counterobs++;
	}
} # END SUB apply_obs_constraints


sub get_obstructions # IT APPLIES CONSTRAINTS TO ZONE GEOMETRY. TO DO. STILL UNUSED. ZZZ
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
	my $zone_letter = shift;
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
	my $zone_letter = shift;
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
		if ($exeonfiles eq "y") 
		{
			print
#########################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
\n`; 
########################
		}

		print TOSHELL 
#################
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
\n";
##################
	}
	$countervertex++;
} # END SUB apply_pin_obstructions



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
	my $zone_letter = shift;
	my $swap = shift;
	my @vary_net = @$swap;
	#print OUTFILE "VARYNET: \$to:$to, \$fileconfig:$fileconfig, \$stepsvar:$stepsvar, \$counterzone:$counterzone, \$counterstep:$counterstep, \@applytype:@applytype, \@vary_net:@vary_net\n\n";
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
	# print "NODEBULK: " . Dumper(@nodebulk) . "\n\n";
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
	# print "NODES: " . Dumper(@node) . "\n\n";
	calc_newnet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@nodebulk, \@componentbulk, \@node, \@component);	# PLURAL
	
	
	sub calc_newnet
	{	# TO BE CALLED WITH: calc_newnet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@nodebulk, \@componentbulk, \@node_, \@component);
		# THIS COMPUTES CHANGES TO BE MADE TO CONTROLS BEFORE PROPAGATION OF CONSTRAINTS
		my $to = shift;
		my $fileconfig = shift;
		my $stepsvar = shift;
		my $counterzone = shift;
		my $counterstep = shift;
		#print "\$counterstep:$counterstep\n";
		my $swap = shift;
		my @nodebulk = @$swap;
		my $swap = shift;
		my @componentbulk = @$swap;
		my $swap = shift;
		my @node = @$swap; # PLURAL
		my $swap = shift;
		my @component = @$swap; # PLURAL
		# print "NODES: " . Dumper(@node) . "\n\n";
		# print "NODEBULK: " . Dumper(@nodebulk) . "\n\n";
		# print "COMPONENTS " . Dumper(@component) . "\n\n";
		# print "COMPONENTBULK: " . Dumper(@componentbulk) . "\n\n";
		
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
				# print "EACH NODEBULK: $each_nodebulk\n\n";
				my @asknode = @{$each_nodebulk};
				#print "ASKNODE: @asknode\n\n";
				my $new_node_letter = $asknode[0];
				my $new_fluid = $asknode[1];
				my $new_type = $asknode[2];
				my $new_zone = $activezone;
				my $swing_height = $asknode[3];
				my $swing_data_2 = $asknode[4];
				my $new_surface = $asknode[5];
				my @askcp = @{$asknode[6]};
				#print "ASKCP: @askcp\n\n";
				########print "\@askcp:@askcp\n\n";
				my ($height__, $data_2__, $data_1__, $new_cp);					
				my $countnode = 0; #IT IS FOR THE FOLLOWING FOREACH. LEAVE IT ATTACHED TO IT.
				########print "NODES: @node\n\n";
				foreach $each_node (@node)
				{
					@node_ = @{$each_node};
					my $node_letter = $node_[0]; 
					#print "\$new_node_letter: $new_node_letter\n";
					#print "\$node_letter: $node_letter\n";
					if ( $new_node_letter eq $node_letter ) 
					{
						$height__ = $node_[3];
						$data_2__ = $node_[4];
						$data_1__ = $node_[5];
						$new_cp = $askcp[$counterstep-1];
						#print "IN\$new_cp:$new_cp\n";
					}
					$countnode++;
				}
				######print "OUT\$new_cp:$new_cp\n\n";
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
				# print "EACH componentBULK: $each_componentbulk\n\n";
				my @askcomponent = @{$each_componentbulk};
				# print "ASKcomponent: @askcomponent\n\n";
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
					# print "\@component_: @component_\n\n";
					$component_letter = $component_letters[$countcomponent]; 
					#print "\$new_component_letter: $new_component_letter; \$component_letter; $component_letter\n";
					if ( $new_component_letter eq $component_letter ) 
					{
						#print "HEY!\n";
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
		# print  "IN3: \@new_nodes: " . Dumper(@new_nodes) . "\n\n";
		#print "IN3: \@new_components: " . Dumper(@new_components) . "\n\n";
	} # END SUB calc_newnet

	# print  "OUT: \@new_nodes: " . Dumper(@new_nodes) . "\n\n";
	# print OUTFILE "OUT: \@new_components: " . Dumper(@new_components) . "\n\n";
	
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
	# print "CALLED WITH: read_net, \$sourceaddress:$sourceaddress, \$targetaddress:$targetaddress, \@node_letters:@node_letters, \@component_letters:@component_letters)\n\n";
	open( SOURCEFILE, $sourceaddress ) or die "Can't open $sourcefile : $!\n";
	my @lines = <SOURCEFILE>;
	close SOURCEFILE;
	# print "lines: @lines\n";
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
		#print "line: $line\n";
		if ( $line =~ m/Fld. Type/ )
		{
			$semaphore_node = "yes";
			#print "SEMAPHORENODE YES\n";
		}
		if ( $semaphore_node eq "yes" )
		{
			$countnode++;
		}
		if ( $line =~ m/Type C\+ L\+/ )
		{
			$semaphore_component = "yes";
			$semaphore_node = "no";
			#print "SEMAPHORENODE YES\n";
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
				#print "TYPE!: $type\n\n";
				if ($type eq "110") { $type = "k";}
				if ($type eq "120") { $type = "l";}
				if ($type eq "130") { $type = "m";}
				#print "TYPEC!: $type\n\n";
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
	#print "NODES " . Dumper(@node) . "\n\n"; # PLURAL

	#print "COMPONENTS " . Dumper(@component) . "\n\n";		
} # END SUB read_controls.


sub apply_node_changes
{ 	# TO BE CALLED WITH: apply_node_changes($exeonfiles, \@new_nodes);
	# THIS APPLIES CHANGES TO NODES IN NETS
	my $exeonfiles = shift;
	# print OUTFILE "\$exeonfileshere:$exeonfiles\n\n";
	my $swap = shift;
	my @new_nodes = @$swap;
	# print  "\@new_nodes at \$counterstep $counterstep:" . Dumper(@new_nodes) . "\n\n";
	my $counter = 0;
	
	foreach my $elm (@new_nodes)
	{
		my @node_ = @{$elm};
		#print "NODE: @node_\n";
		my $new_node_letter = $node_[0];
		my $new_fluid = $node_[1];
		my $new_type = $node_[2];
		my $new_zone = $node_[3];
		my $new_height = $node_[4];
		my $new_data_2 = $node_[5];
		my $new_surface = $node_[6];
		my $new_cp = $node_[7];
		
		# print "\$new_node_letter:$new_node_letter, \$new_fluid:$new_fluid, \$new_type:$new_type, \$new_zone:$new_zone, \$new_height:$new_height, \$new_data_2:$new_data_2, \$new_surface:$new_surface, \$new_cp:$new_cp\n\n";
		# print "NEW_TYPE: $new_type\n\n";
		
		if ($new_type eq "a" ) # IF NODES ARE INTERNAL
		{
			if ($exeonfiles eq "y") 
			{
				print 
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
\n`;

################################
			}
			print TOSHELL
#########################
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
\n";
#########################
		}
		
		if ($new_type eq "e" ) # IF NODES ARE BOUNDARY ONES, WIND-INDUCED
		{
			if ($exeonfiles eq "y") 
			{
				#print "HERE!\n\n";
				print 
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
\n`;

################################
			}
			#print "HERE2!\n\n";
			print TOSHELL 
#########################
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
\n";
#########################
		}
	}
} # END SUB apply_node_changes;
	
	

sub apply_component_changes
{ 	# TO BE CALLED WITH: apply_component_changes($exeonfiles, \@new_components);
	# THIS APPLIES CHANGES TO COMPONENTS IN NETS
	my $exeonfiles = shift;
	# print OUTFILE "\$exeonfileshere:$exeonfiles\n\n";
	my $swap = shift;
	my @new_components = @$swap; # [ $new_component_letter, $new_type, $new_data_1, $new_data_2, $new_data_3, $new_data_4 ] 
	# print  "\@new_components at \$counterstep $counterstep:" . Dumper(@new_components) . "\n\n";
	# my $counter = 0;
	
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
		# print  "\@new_components at \$counterstep $counterstep:" . Dumper(@new_components) . "\n\n";
		if ($new_type eq "k" ) # IF THE COMPONENT IS A GENERIC OPENING
		{
			if ($exeonfiles eq "y") 
			{
				print 
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
\n`;

################################
			}
			print TOSHELL 
#########################
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
\n";
#########################
		}
		
		if ($new_type eq "l" ) # IF THE COMPONENT IS A CRACK
		{
			if ($exeonfiles eq "y") 
			{
				print 
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
\n`;

################################
			}
			print TOSHELL 
#########################
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
\n";
#########################
		}
		
		if ($new_type eq "m" ) # IF THE COMPONENT IS A DOOR
		{
			if ($exeonfiles eq "y") 
			{
				print 
#################################
`prj -file $to/cfg/$fileconfig -mode script<<YYY

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
\n`;

################################
			}
			print TOSHELL 
#########################
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
\n";
#########################
		}
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
	my $zone_letter = shift;
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
			($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $configaddress, \@node, \@component); # PLURAL
		}
	}
		
	unless ($to_do eq "justread")
	{
		apply_node_changes($exeonfiles, \@node); #PLURAL
		apply_component_changes($exeonfiles, \@component);
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
	# print "\nCONFIGADDRESS: $configaddress\n\n";
	my $swap = shift;
	@node = @$swap; # PLURAL
	my $swap = shift;
	@component = @$swap;
	unshift (@node, []); # PLURAL
	unshift (@component, []);
	if (-e $configaddress) # TEST THIS, DDD
	{	# THIS APPLIES CONSTRAINST, THE FLATTEN THE HIERARCHICAL STRUCTURE OF THE RESULTS,
		# TO BE PREPARED THEN FOR BEING APPLIED TO CHANGE PROCEDURES. IT IS TO BE TESTED.
		eval `cat $configaddress`;	# HERE AN EXTERNAL FILE FOR PROPAGATION OF CONSTRAINTS 
		# IS EVALUATED, AND HERE BELOW CONSTRAINTS ARE PROPAGATED.
		# THE USE OF "eval" HERE ALLOWS TO WRITE CONDITIONS IN THE FILE AS THEY WERE DIRECTLY 
		# WRITTEN IN THE CALLING FILE.	
		# THIS FILE CAN CONTAIN USER-IMPOSED CONSTRAINTS FOR MASS-FLOW NETWORKS TO BE READ BY OPTS.
		# IT MAKES AVAILABLE VARIABLES REGARDING THE SETTING OF NODES IN A NETWORK.
		# CURRENTLY: INTERNAL UNKNOWN AIR NODES AND BOUNDARY WIND-CONCERNED NODES.
		# IT MAKES AVAILABLE VARIABLES REGARDING COMPONENTS
		# CURRENTLY: WINDOWS, CRACKS, DOORS.
		# ALSO, THIS MAKES AVAILABLE TO THE USER INFORMATIONS ABOUT THE MORPHING STEP OF THE MODELS.
		# SPECIFICALLY, THE FOLLOWING VARIABLES WHICH REGARD BOTH INTERNAL AND BOUNDARY NODES.
		# NOTE THAT "node_number" IS THE NUMBER OF THE NODE IN THE ".afn" ESP-r FILE. 
		# $node[node_number][$node]. # EXAMPLE: $node[3][$node]. THIS IS THE LETTER OF THE THIRD NODE.
		# $node[node_number][$type]
		# $node[node_number][$height]. # EXAMPLE: $node[3][$node]. THIS IS THE HEIGHT OF THE 3RD NODE.
		# THEN IT MAKES AVAILABLE THE FOLLOWING VARIABLES REGARDING NODES:
		# $node[node_number][$volume] # REGARDING INTERNAL NODES
		# $node[node_number][$azimut] # REGARDING BOUNDARY NODES
		# THEN IT MAKE AVAILABLE THE FOLLOWING VARIABLES REGARDING COMPONENTS:
		# $node[node_number][$area] # REGARDING SIMPLE OPENINGS
		# $node[node_number][$width] # REGARDING CRACKS
		# $node[node_number][$length] # REGARDING CRACKS
		# $node[node_number][$door_width] # REGARDING DOORS
		# $node[node_number][$door_height] # REGARDING DOORS
		# $node[node_number][$door_nodeheight] # REGARDING DOORS
		# $node[node_number][$door_discharge] # REGARDING DOORS (DISCHARGE FACTOR)
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
		# print "THIS FILE IS READ.\n\n";	
		
		# print "BEFORE nodes: " . Dumper(@nodes) . "\n\n";
		# print "BEFORE components " . Dumper(@components) . "\n\n";
		shift (@node);
		shift (@component);
		
		# print "AFTER loop_control: " . Dumper(@new_loop_control) . "\n\n";
		# print "AFTER flow_control: " . Dumper(@new_flow_control) . "\n\n";
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
	# IT MAKES AVAILABLE TO THE USER THE FOLLOWING VARIABLES FOR MANIPULATION.
	# REGARDING GEOMETRY:
	# @v[$number][$x], @v[$number][$y], @v[$number][$z]. EXAMPLE: @v[4][$x] = 1. OR: @v[4][$x] =  @v[4][$y].
	# REGARDING OBSTRUCTIONS:
	# $obs[$obs_number][$x], $obs[$obs_number][$y], $obs[$obs_number][$y]
	# $obs[$obs_number][$width], $obs[$obs_number][$depth], $obs[$obs_number][$height]
	# $obs[$obs_number][$z_rotation], $obs[$obs_number][$y_rotation], 
	# $obs[$obs_number][$tilt], $obs[$obs_number][$opacity], $obs[$obs_number][$material], 
	# EXAMPLE: $obs[2][$x] = 2. THIS MEANS: COORDINATE x OF OBSTRUCTION HAS TO BE SET TO 2.
	# OTHER EXAMPLE: $obs[2][$x] = $obs[2][$y]. THIS MEANS: 
	# NOTE THAT THE MATERIAL TO BE SPECIFIED IS A MATERIAL LETTER, BETWEEN QUOTES! EXAMPLE: $obs[1][$material] = "a".
	#  $tilt IS PRESENTLY UNUSED.
	# REGARDING MASS-FLOW NETWORKS:
	# @nodes and @components.
	# CURRENTLY: INTERNAL UNKNOWN AIR NODES AND BOUNDARY WIND-CONCERNED NODES.
	# IT MAKES AVAILABLE VARIABLES REGARDING COMPONENTS
	# CURRENTLY: WINDOWS, CRACKS, DOORS.
	# ALSO, THIS MAKES AVAILABLE TO THE USER INFORMATIONS ABOUT THE MORPHING STEP OF THE MODELS.
	# SPECIFICALLY, THE FOLLOWING VARIABLES WHICH REGARD BOTH INTERNAL AND BOUNDARY NODES.
	# NOTE THAT "node_number" IS THE NUMBER OF THE NODE IN THE ".afn" ESP-r FILE. 
	# $node[node_number][$node]. # EXAMPLE: $node[3][$node]. THIS IS THE LETTER OF THE THIRD NODE.
	# $node[node_number][$type]
	# $node[node_number][$height]. # EXAMPLE: $node[3][$height]. THIS IS THE HEIGHT OF THE 3RD NODE.
	# THEN IT MAKES AVAILABLE THE FOLLOWING VARIABLES REGARDING NODES:
	# $node[node_number][$volume] # REGARDING INTERNAL NODES
	# $node[node_number][$azimut] # REGARDING BOUNDARY NODES
	# THEN IT MAKE AVAILABLE THE FOLLOWING VARIABLES REGARDING COMPONENTS:
	# $component[node_number][$area] # REGARDING SIMPLE OPENINGS
	# $component[node_number][$width] # REGARDING CRACKS
	# $component[node_number][$length] # REGARDING CRACKS
	# $component[node_number][$door_width] # REGARDING DOORS
	# $component[node_number][$door_height] # REGARDING DOORS
	# $component[node_number][$door_nodeheight] # REGARDING DOORS
	# $component[node_number][$door_discharge] # REGARDING DOORS (DISCHARGE FACTOR)
	# REGARDING CONTROLS:
	# 1) $loop_control[$countloop][$countloopcontrol][$loop_hour] 
	# Where $countloop and  $countloopcontrol has to be set to a specified number in the OPTS file for constraints.
	# 2) $loop_control[$countloop][$countloopcontrol][$max_heating_power] # Same as above.
	# 3) $loop_control[$countloop][$countloopcontrol][$min_heating_power] # Same as above.
	# 4) $loop_control[$countloop][$countloopcontrol][$max_cooling_power] # Same as above.
	# 5) $loop_control[$countloop][$countloopcontrol][$min_cooling_power] # Same as above.
	# 6) $loop_control[$countloop][$countloopcontrol][heating_setpoint] # Same as above.
	# 7) $loop_control[$countloop][$countloopcontrol][cooling_setpoint] # Same as above.
	# 8) $flow_control[$countflow][$countflowcontrol][$flow_hour] 
	# Where $countflow and  $countflowcontrol has to be set to a specified number in the OPTS file for constraints.
	# 9) $flow_control[$countflow][$countflowcontrol][$flow_setpoint] # Same as above.
	# 10) $flow_control[$countflow][$countflowcontrol][$flow_onoff] # Same as above.
	# 11) $flow_control[$countflow][$countflowcontrol][$flow_fraction] # Same as above.
	# EXAMPLE : $flow_control[1][2][$flow_fraction] = 0.7
	# OTHER EXAMPLE: $flow_control[1][2][$flow_fraction] = $flow_control[2][1][$flow_fraction]
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
	my $to = shift;
	my $fileconfig = shift;
	my $stepsvar = shift;
	my $counterzone = shift;
	my $counterstep = shift;
	my $exeonfiles = shift;
	my $swap = shift;
	my ($justread, $justwrite);
	my @applytype = @$swap;
	my $zone_letter = shift;
	my $swap = shift;
	my @propagate_constraints = @$swap;
	my $zone = $applytype[$counterzone][3];
	# print "ZONE: $zone\n";
	my $counter = 0;
	my @group = @{$propagate_constraints[$counterzone]};
	#print "YUP\n";
	foreach my $elm (@group)
	{
		if ($counter > 0)
		{
			#print "YEP\n";
			my @items = @{$elm};
			my $what_to_do = $items[0];
			my $sourcefile = $items[1];
			my $targetfile = $items[2];
			my $configfile = $items[3];
			if ($what_to_do eq "read_geo")
			{
				#print "READGEO\n\n";
				$to_do = "justread";
				my @vertex_letters = @{$items[4]};
				#print "VERTEX_LETTERS: @vertex_letters\n";
				my $long_menus = $items[5];
				my @constrain_geometry = ( [ "", $zone,  $sourcefile, $targetfile, $configfile , \@vertex_letters, $long_menus ] );
				# print "\@constrain_geometry:" . Dumper(@constrain_geometry) . "\n\n";
				constrain_geometry($to, $fileconfig, $stepsvar, $counterzone, 
				$counterstep, $exeonfiles, \@applytype, \@constrain_geometry, $to_do);
				
			}
			if ($what_to_do eq "read_obs")
			{
				$to_do = "justread";
				my @obs_letters = @{$items[4]};
				# print "OBS_LETTERS: @obs_letters\n";
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
				# print Dumper(@constrain_geometry);
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


##############################################################################
##############################################################################
##############################################################################
# HERE FOLLOWES THE CONTENT OF THE "opts_sim.pl" FILE, WHICH HAS BEEN MERGED HERE
# TO AVOID COMPLICATIONS WITH THE PERL MODULE INSTALLATION.

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

# END OF THE CONTENT OF THE "opts_sim.pl" FILE.
##############################################################################
##############################################################################
##############################################################################


##############################################################################
##############################################################################
##############################################################################
# HERE FOLLOWES THE CONTENT OF THE "opts_report.pl" FILE, WHICH HAS BEEN MERGED HERE
# TO AVOID COMPLICATION WITH THE PERL MODULE INSTALLATION.

## HERE THE "report", "retrieve" and "merge" FUNCTIONS FOLLOW, CALLED FROM THE MAIN PROGRAM FILE.

no strict; 

sub report # This function retrieves the results of interest from the text file created by the "retrieve" function
{
	$" = "";

	sub strip_files_temps
	{
		my $themereport = $_[0];
		my @measurements_to_report      = @{ $reporttempsdata[0] };
		my @columns_to_report           = @{ $reporttempsdata[1] };
		my $number_of_columns_to_report = $#{ $reporttempsdata[1] };
		my $counterreport               = 0;
		my $dates_to_report             = $simtitle[$counterreport];
		my @files_to_report             = <$mypath/$filenew*temperatures.grt>;

		#
		foreach my $file_to_report (@files_to_report)
		{    #
			$file_to_report =~ s/\.\/$file\///;
			my $counterline    = 0;
			my @countercolumns = undef;
			my $infile         = "$file_to_report";
			my $outfile        = "$file_to_report-stripped";
			open( INFILEREPORT,  "$infile" )   or die "Can't open infile $infile 3: $!";
			open( OUTFILEREPORT, ">$outfile" ) or die "Can't open outfile $outfile: $!";
			my @lines_to_report = <INFILEREPORT>;

			foreach $line_to_report (@lines_to_report)
			{
				my @roww = split( /\s+/, $line_to_report );

				#
				if ( $counterline == 1 )
				{
					$file_and_period = $roww[5];
				} elsif ( $counterline == 3 )
				{

					#
					my $countercolumn = 0;
					foreach $element_of_row (@roww)
					{    #
						foreach $column (@columns_to_report)
						{
							if ( $element_of_row eq $column )
							{
								push @countercolumns, $countercolumn;
								if ( $element_of_row eq $columns_to_report[0] )
								{
									$title_of_column = "$element_of_row";
								} else
								{
									$title_of_column =
									  "$element_of_row-" . "$file_and_period";
								}
								print OUTFILEREPORT "$title_of_column\t";
							}
						}
						$countercolumn = $countercolumn + 1;
					}
					print OUTFILEREPORT "\n";
				} elsif ( $counterline > 3 )
				{
					foreach $columnumber (@countercolumns)
					{
						if ( $columnumber =~ /\d/ )
						{
							print OUTFILEREPORT "$roww[$columnumber]\t";
						}
					}
					print OUTFILEREPORT "\n";
				}
				$counterline++;
			}
			$counterreport++;
		}

		#
		close(INFILEREPORT);
		close(OUTFILEREPORT);
	}

	sub strip_files_comfort
	{
		my $themereport = $_[0];
		my @measurements_to_report      = @{ reportcomfortdata->[0] };
		my @columns_to_report           = @{ reportcomfortdata->[1] };
		my $number_of_columns_to_report = $#{ reportcomfortdata->[1] };
		my $counterreport               = 0;

		#
		my $dates_to_report = $simtitle[$counterreport];
		my @files_to_report = <$mypath/$filenew*comfort.grt>;
		my $file_to_report;
		foreach $file_to_report (@files_to_report)
		{    #
			$file_to_report =~ s/\.\/$file\///;
			my $counterline = 0;
			my @countercolumns;
			my $infile  = "$file_to_report";
			my $outfile = "$file_to_report-stripped";
			open( INFILEREPORT,  "$infile" )   or die "Can't open infile $infile 4: $!";
			open( OUTFILEREPORT, ">$outfile" ) or die "Can't open outfile $outfile: $!";
			my @lines_to_report = <INFILEREPORT>;

			foreach $line_to_report (@lines_to_report)
			{
				my @roww = split( /\s+/, $line_to_report );

				#
				if ( $counterline == 1 )
				{
					$file_and_period = $roww[5];
				} elsif ( $counterline == 3 )
				{

					#
					my $countercolumn = 0;
					foreach $element_of_row (@roww)
					{    #
						foreach $column (@columns_to_report)
						{
							if ( $element_of_row eq $column )
							{
								push @countercolumns, $countercolumn;
								if ( $element_of_row eq $columns_to_report[0] )
								{
									$title_of_column = "$element_of_row";
								} else
								{
									$title_of_column =
									  "$element_of_row-" . "$file_and_period";
								}
								print OUTFILEREPORT "$title_of_column\t";
							}
						}
						$countercolumn = $countercolumn + 1;
					}
					print OUTFILEREPORT "\n";
				} elsif ( $counterline > 3 )
				{
					foreach $columnumber (@countercolumns)
					{
						if ( $columnumber =~ /\d/ )
						{
							print OUTFILEREPORT "$roww[$columnumber]\t";
						}
					}
					print OUTFILEREPORT "\n";
				}
				$counterline++;
			}
		}

		#
		close(INFILEREPORT);
		close(OUTFILEREPORT);
	}

	sub strip_files_loads_no_transpose
	{
		my $themereport = $_[0];
		my @measurements_to_report = @{ reportloadsdata->[0] };
		my @rows_to_report =
		  @{ reportloadsdata->[1] };    # in this case, they are rows
		my $number_of_rows_to_report =
		  ( 1 + $#{ reportloadsdata->[1] } );    # see above: rows
		                                         #
		my $dates_to_report = $simtitle[$counterreport];
		my @files_to_report = <$mypath/$filenew*loads.grt>;
		my $tofilter = $$reportloadsdata[1];
		foreach my $file_to_report (@files_to_report)
		{                                        #
			$file_to_report =~ s/\.\/$file\///;
			my $infile           = "$file_to_report";
			my $outfile          = "$file_to_report-";
			my $fullpath_outfile = "$outfile";
			my $fullpath_infile  = "$infile";
			open( INFILEREPORT,  "$infile" )   or die "Can't open $infile: $!";
			open( OUTFILEREPORT, ">$outfile" ) or die "Can't open $outfile: $!";
			my @lines_to_report = <INFILEREPORT>;
			
			$" = " ";
			foreach my $line_to_report (@lines_to_report)
			{
				my @roww = split( /\s+/, $line_to_report );
				foreach my $roww (@roww)
				{
					if ($roww eq $tofilter )
					{
						print OUTFILEREPORT  "$file_to_report @roww\n";
					}
				}
			}

			close(INFILEREPORT);
			close(OUTFILEREPORT);
		}
	}

	sub transposefileloads
	{
		my $themereport = $_[0];
		my @files_to_transpose = <$mypath/$filenew*loads.grt->;
		foreach $file_to_transpose (@files_to_transpose)
		{
			print `chmod -R 755 $file_to_transpose`;
			print TOSHELL "chmod -R 755 $file_to_transpose\n";
			open( INPUT_FILE, "$file_to_transpose" )
			  or die
			  "Something's wrong with the input file $file_to_transpose: !\n";
			my $line = <INPUT_FILE>;

			#$line =~ s/All zones/All_zones/;
			my @AoA;
			while ( defined $line )
			{
				chomp $line;
				push @AoA, [ split /\s+/, $line ];
				$line = <INPUT_FILE>;
			}
			close(INPUT_FILE);
			my $outfiletranspose = "$file_to_transpose" . "stripped";
			open RESULT, ">$outfiletranspose"
			  or die "Can't open $outfiletranspose: $!\n";
			my $countthis = 0;
			$" = "";
			for $i ( 0 ... $#{ $AoA[0] } )
			{

				for $j ( 0 ... $#AoA )
				{
					if ( $j == $#AoA )
					{
						print RESULT
						  "$loads_resulted[$countthis]  $AoA[$j][$i]\n";
					} elsif ( $AoA[$j][$i] eq "" )
					{
						print RESULT " \n";
						last;
					} else
					{
						print RESULT "$AoA[$j][$i] \t ";
					}
				}
				if ( $AoA[$j][$i] eq "" ) { last; }
				$countthis++;
			}
		}
		close(RESULT);
	}

	sub strip_files_tempsstats_no_transpose
	{
		my $themereport = $_[0];
		my @measurements_to_report = @{ reporttempsstats->[0] };
		my @rows_to_report =
		  @{ reporttempsstats->[1] };    # in this case, they are rows
		my $number_of_rows_to_report =
		  ( 1 + $#{ reporttempsstats->[1] } );    # see above: rows
		my $tofilter = $reporttempsstats[1];
		my $dates_to_report = $simtitle[$counterreport];
		my @files_to_report = <$mypath/$filenew*tempsstats.grt>;
		foreach my $file_to_report (@files_to_report)
		{
			$file_to_report =~ s/\.\/$file\///;
			my $infile           = "$file_to_report";
			my $outfile          = "$file_to_report-";
			my $fullpath_outfile = "$outfile";
			my $fullpath_infile  = "$infile";
			open( INFILEREPORT,  "$infile" )   or die "Can't open $infile 6: $!";
			open( OUTFILEREPORT, ">$outfile" ) or die "Can't open $outfile: $!";
			my $counterzones    = 0;
			my @lines_to_report = <INFILEREPORT>;

			foreach $line_to_report (@lines_to_report)
			{
				$line_to_report =~ s/\:\s/\:/g;
				my @roww = split( /\s+/, $line_to_report );
				if (    $roww[1] eq "1"
					 or "2"
					 or "3"
					 or "4"
					 or "5"
					 or "6"
					 or "6"
					 or "7"
					 or "8"
					 or "9" )
				{
					$counterzones = $counterzones + 1;
				}
				if ( $roww[1] eq $tofilter
				  )
				{
					$" = " ";
					print OUTFILEREPORT
					  "$file_to_report\t @roww\n";
				}
			}
			close(INFILEREPORT);
			close(OUTFILEREPORT);
			
		}
	}
			
			
			
			
			


	sub transposefiletempsstats
	{
		my $themereport = $_[0];
		my @files_to_transpose = <$mypath/$filenew*tempsstats.grt->;
		foreach $file_to_transpose (@files_to_transpose)
		{
			print `chmod -R 755 $file_to_transpose`;
			print TOSHELL "chmod -R 755 $file_to_transpose\n";
			open( INPUT_FILE, "$file_to_transpose" )
			  or die
			  "Something's wrong with the input file $file_to_transpose: !\n";
			my $line = <INPUT_FILE>;

			my @AoA;
			while ( defined $line )
			{
				chomp $line;
				push @AoA, [ split /\s+/, $line ];
				$line = <INPUT_FILE>;
			}
			close(INPUT_FILE);
			my $outfiletranspose = "$file_to_transpose" . "stripped";
			open RESULT, ">$outfiletranspose"
			  or die "Can't open $outfiletranspose: $!\n";
			my $countthis = 0;
			for $i ( 0 ... $#{ $AoA[0] } )
			{
				for $j ( 0 ... $#AoA )
				{
					if ( $j == $#AoA )
					{
						print RESULT
						  "$tempsstats_resulted[$countthis]  $AoA[$j][$i]\n";
					} elsif ( $AoA[$j][$i] eq "" )
					{
						print RESULT "\n";
						last;
					} else
					{
						print RESULT "$AoA[$j][$i]\t";
					}
				}
				if ( $AoA[$j][$i] eq "" ) { last; }
				$countthis++;
			}
		}
		close(RESULT);
	}

	sub strip_files_loads
	{
		my $themereport = $_[0];
		strip_files_loads_no_transpose($themereport);
	}

	sub strip_files_tempsstats
	{
		my $themereport = $_[0];
		strip_files_tempsstats_no_transpose($themereport);
	}
	
	foreach my $themereport (@themereports)
	{
		if ( $themereport eq "temps" ) { strip_files_temps($themereport); }
		if ( $themereport eq "comfort" ) { strip_files_comfort($themereport); }
		if ( $themereport eq "loads" ) 
		{
			strip_files_loads($themereport);
		}
		if ( $themereport eq "tempsstats" ) { strip_files_tempsstats($themereport); }
	}
}    # END SUB report;

sub merge_reports    # Self-explaining
{
	my @columns_to_report           = @{ reporttempsdata->[1] };
	my $number_of_columns_to_report = $#{ reporttempsdata->[1] };
	my $counterlines;
	my $number_of_dates_to_merge = $#simtitle;
	my @dates                    = @simtitle;

	sub merge_reports_temps
	{       
		my $themereport = $_[0];       
		my $counterdate = 0;
		foreach my $date (@dates)
		{
			my @return_lines;
			my @resultingfile;
			my @lines_to_merge;
			my $date_to_merge  = $simtitle[$counterdate];
			my @files_to_merge = <$mypath/$filenew*$date*temperatures.grt->;
			my $counterfiles   = 0;
			foreach my $file_to_merge (@files_to_merge)
			{          #
				open( INFILEMERGE, "$file_to_merge" )
				  or die "Can't open $file_to_merge: $!";
				my @lines_to_merge = <INFILEMERGE>;
				my $counterlines   = 0;
				foreach $line_to_merge (@lines_to_merge)
				{      #
					my @roww = split( /\s+/, $line_to_merge );
					my $counterelements = 0;
					foreach $element (@roww)
					{    #
						unless (
								( $counterfiles != 0 )
								and (    ( $counterelements == 0 )
									  or ( $counterelements == 1 ) )
								or ( ( $element eq "" ) or ( $element eq " " ) )
						  )
						{
							push @{ $resultingfile[$counterlines] },
							  "$element\t";
						}
						$counterelements = $counterelements + 1;
					}
					$counterlines = $counterlines + 1;
				}
				$counterfiles = $counterfiles + 1;
				close(INFILEMERGE);
			}

			my $outfile = "$mypath/$filenew-$date-temperatures-sum-up.txt";
			if (-e $outfile) { `chmod 777 $outfile\n`; `mv -b $outfile-bak\n`;};
			print TOSHELL "chmod 777 $outfile\n"; print TOSHELL "mv -b $outfile-bak\n";
			open( OUTFILEMERGE, ">$outfile" ) or die "Can't open $outfile: $!";
			my $newcounterlines = 0;
			my $numberrow       = $#resultingfile;
			while ( $newcounterlines <= $numberrow )
			{
				$" = " ";
				print OUTFILEMERGE "@{$resultingfile[$newcounterlines]}\n";
				$newcounterlines++;
			}
			close(OUTFILEMERGE);
			my @files_to_erase = <$mypath/$filenew*$date*temperatures.grt->;
			foreach my $file_to_erase (@files_to_erase)
			{
				print "rm -r $file_to_erase";
			}
			my @files_to_erase = <$mypath/$filenew*$date*temperatures.grt.par>;
			foreach my $file_to_erase (@files_to_erase)
			{
				print "rm -r $file_to_erase";
			}
			$counterdate++;
		}
	}

	sub merge_reports_comfort
	{    #
		my $themereport = $_[0];
		my $counterdate = 0;
		foreach my $date (@dates)
		{
			my @return_lines;
			my @resultingfile;
			my @lines_to_merge;
			my $date_to_merge  = $simtitle[$counterdate];
			my @files_to_merge = <$mypath/$filenew*$date*comfort.grt->;
			my $counterfiles   = 0;
			foreach my $file_to_merge (@files_to_merge)
			{    #
				open( INFILEMERGE, "$file_to_merge" )
				  or die "Can't open file_to_merge $file_to_merge: $!";
				my @lines_to_merge = <INFILEMERGE>;
				my $counterlines   = 0;
				foreach $line_to_merge (@lines_to_merge)  #if ($roww[0] eq 1)  #
				{                                         #
					my @roww = split( /\s+/, $line_to_merge );
					my $counterelements = 0;
					foreach $element (@roww)
					{                                     #
						unless (     ( $counterfiles != 0 )
								 and ( $counterelements == 0 ) )
						{
							push @{ $resultingfile[$counterlines] },
							  "$element\t";
						}
						$counterelements = $counterelements + 1;
					}
					$counterlines = $counterlines + 1;
				}
				$counterfiles = $counterfiles + 1;
				close(INFILEMERGE);
			}

			my $outfile = "$mypath/$filenew-$date-comfort-sum-up.txt";
			if (-e $outfile) { `chmod 777 $outfile\n`; `mv -b $outfile-bak\n`;}
			print TOSHELL "chmod 777 $outfile\n"; print TOSHELL "mv -b $outfile-bak\n"; 
			open( OUTFILEMERGE, ">$outfile" ) or die "Can't open $outfile: $!";
			my $newcounterlines = 0;
			my $numberrow       = $#resultingfile;
			while ( $newcounterlines <= $numberrow )
			{
				$" = " ";
				print OUTFILEMERGE "@{$resultingfile[$newcounterlines]}\n";
				$newcounterlines = $newcounterlines + 1;

			}
			close(OUTFILEMERGE);
			my @files_to_erase = <$mypath/$filenew*$date*comfort.grt->;
			foreach my $file_to_erase (@files_to_erase)
			{
				print "rm -r $file_to_erase";
			}
			my @files_to_erase = <$mypath/$filenew*$date*comfort.grt.par>;
			foreach my $file_to_erase (@files_to_erase)
			{
				print "rm -r $file_to_erase";
			}
			$counterdate++;

			#
		}
	}

	sub merge_reports_loads
	{    #
		my $themereport = $_[0];
		my $counterdate = 0;
		foreach my $date (@dates)
		{
			my @return_lines;
			my @resultingfile;
			my @lines_to_merge;
			my $date_to_merge  = $simtitle[$counterdate];
			my @files_to_merge = <$mypath/$filenew*$date*loads.grt->;
			my $counterfiles = 0;
			foreach my $file_to_merge (@files_to_merge)
			{    #
				open( INFILEMERGE, "$file_to_merge" )
				  or die "Can't open file_to_merge $file_to_merge: $!";
				my @lines_to_merge = <INFILEMERGE>;
				my $counterlines   = 0;
				foreach $line_to_merge (@lines_to_merge)
				{    #
					my @roww = split( /\s+/, $line_to_merge );
					my $counterelements = 0;
					foreach $element (@roww)
					{    #
						unless ( ( ( $element eq "" ) or ( $element eq " " ) ) )
						{
							push @{ $resultingfile[$counterlines] },
							  "$element\t";
						}
						$counterelements = $counterelements + 1;
					}
					push @{ $resultingfile[$counterlines] }, "\n";
					$counterlines = $counterlines + 1;
				}
				$counterfiles = $counterfiles + 1;
				close(INFILEMERGE);
			}

			#
			my $outfile0 = "$mypath/$filenew-$date-loads-sum-up-transient.txt";
			if (-e $outfile) { `chmod 777 $outfile\n`; `mv -b $outfile-bak\n`;};
			print TOSHELL "chmod 777 $outfile\n"; print TOSHELL "mv -b $outfile-bak\n";
			open( OUTFILEMERGE0, ">$outfile0" )
			  or die "Can't open outfile0 $outfile0: $!";
			my $newcounterlines = 0;
			my $numberrow       = $#resultingfile;
			while ( $newcounterlines <= $numberrow )
			{
				print OUTFILEMERGE0 "@{$resultingfile[$newcounterlines]}";
				$newcounterlines++;
			}
			close(OUTFILEMERGE0);
			my $infile0 = "$mypath/$filenew-$date-loads-sum-up-transient.txt";
			my $outfile = "$mypath/$filenew-$date-loads-sum-up.txt";
			open( INFILEMERGE0, "$infile0" )  or die "Can't open infile0 $infile0: $!";
			open( OUTFILEMERGE, ">$outfile" ) or die "Can't open $outfile: $!";
			my @lines_to_merge = <INFILEMERGE0>;
			foreach my $line_to_merge (@lines_to_merge)
			{
				$line_to_merge =~ s/^\s*//;      #remove leading whitespace
				$line_to_merge =~ s/\s*$//;      #remove trailing whitespace
				$line_to_merge =~ s/\ {2,}/ /g;  #remove multiple literal spaces
				$line_to_merge =~
				  s/\t{2,}/\t/g;   #remove excess tabs (is this what you meant?)
				 #$line_to_merge =~ s/(?<=\t)\ *//g; #remove any spaces after a tab
				push @return_lines, $line_to_merge
				  unless $line_to_merge =~ /^\s*$/;    #remove empty lines
			}
			my $return_txt = join( "\n", @return_lines ) . "\n";
			print OUTFILEMERGE "$return_txt";
			close(INFILEMERGE0);
			if (-e $outfile) { print `rm $infile0\n`;}
			print TOSHELL "rm $infile0\n";
			close(OUTFILEMERGE);
			my @files_to_erase = <$mypath/$filenew*$date*loads.grt->;

			foreach my $file_to_erase (@files_to_erase)
			{
				print "rm -r $file_to_erase";
			}
			my @files_to_erase = <$mypath/$filenew*$date*loads.grt.par>;
			foreach my $file_to_erase (@files_to_erase)
			{
				print "rm -r $file_to_erase";
			}
			$counterdate++;
		}
	}

	sub merge_reports_tempsstats
	{
		my $themereport = $_[0];
		my $counterdate = 0;
		foreach my $date (@dates)
		{
			my @return_lines;
			my @resultingfile;
			my @lines_to_merge;
			my $date_to_merge  = $simtitle[$counterdate];
			my @files_to_merge = <$mypath/$filenew*$date*tempsstats.grt-> ; # my @files_to_merge = <./$file*$date*loads.grt-stripped.reversed.txt>;
			my $counterfiles = 0;
			foreach my $file_to_merge (@files_to_merge)
			{    #
				open( INFILEMERGE, "$file_to_merge" )
				  or die "Can't open file_to_merge $file_to_merge: $!";
				my @lines_to_merge = <INFILEMERGE>;
				my $counterlines   = 0;
				foreach $line_to_merge (@lines_to_merge)
				{    #
					my @roww = split( /\s+/, $line_to_merge );
					my $counterelements = 0;
					foreach $element (@roww)
					{    #
						unless ( ( ( $element eq "" ) or ( $element eq " " ) ) )
						{
							push @{ $resultingfile[$counterlines] },
							  "$element\t";
						}
						$counterelements = $counterelements + 1;
					}
					push @{ $resultingfile[$counterlines] }, "\n";
					$counterlines = $counterlines + 1;
				}
				$counterfiles = $counterfiles + 1;
				close(INFILEMERGE);
			}

			#
			my $outfile0 = "$mypath/$filenew-$date-tempsstats-sum-up-transient.txt";
			if (-e $outfile) { `chmod 777 $outfile\n`; `mv -b $outfile-bak\n`;};
			print TOSHELL "chmod 777 $outfile\n"; print TOSHELL "mv -b $outfile-bak\n";
			open( OUTFILEMERGE0, ">$outfile0" ) or die "Can't open $outfile: $!";
			my $newcounterlines = 0;
			my $numberrow = $#resultingfile;
			while ( $newcounterlines <= $numberrow )
			{
				print OUTFILEMERGE0 "@{$resultingfile[$newcounterlines]}";
				$newcounterlines++;
			}
			close(OUTFILEMERGE0);
			my $infile0 =
			  "$mypath/$filenew-$date-tempsstats-sum-up-transient.txt";
			my $outfile = "$mypath/$filenew-$date-tempsstats-sum-up.txt";
			open( INFILEMERGE0, "$infile0" )  or die "Can't open infile0 $infile0: $!";
			open( OUTFILEMERGE, ">$outfile" ) or die "Can't open $outfile: $!";
			my @lines_to_merge = <INFILEMERGE0>;
			foreach my $line_to_merge (@lines_to_merge)
			{
				$line_to_merge =~ s/^\s*//;      #remove leading whitespace
				$line_to_merge =~ s/\s*$//;      #remove trailing whitespace
				$line_to_merge =~ s/\ {2,}/ /g;  #remove multiple literal spaces
				$line_to_merge =~
				  s/\t{2,}/\t/g;   #remove excess tabs (is this what you meant?)
				 #$line_to_merge =~ s/(?<=\t)\ *//g; #remove any spaces after a tab
				push @return_lines, $line_to_merge
				  unless $line_to_merge =~ /^\s*$/;    #remove empty lines
			}
			my $return_txt = join( "\n", @return_lines ) . "\n";
			print OUTFILEMERGE "$return_txt";
			close(INFILEMERGE0);
			if (-e $outfile) { print `rm $infile0\n`;}
			print TOSHELL "rm $infile0\n";
			close(OUTFILEMERGE);
			my @files_to_erase = <$mypath/$filenew*$date*tempsloads.grt->;

			foreach my $file_to_erase (@files_to_erase)
			{
				print "rm -r $file_to_erase";
			}
			my @files_to_erase = <$mypath/$filenew*$date*tempsloads.grt.par>;
			foreach my $file_to_erase (@files_to_erase)
			{
				print "rm -r $file_to_erase";
			}
			$counterdate++;
		}
	}
	
	foreach my $themereport (@themereports)
	{
	if ( $themereport eq "temps" ) { merge_reports_temps($themereport); }
		if ( $themereport eq "comfort" ) { merge_reports_comfort($themereport); }
		if ( $themereport eq "loads" )
		{
			merge_reports_loads($themereport);
		}
		if ( $themereport eq "tempsstats" ) { merge_reports_tempsstats($themereport); }
	}
}    # END SUB merge_reports

sub enrich_reports
{ ; } # TO DO.

# END OF THE CONTENT OF THE "opts_report.pl" FILE.
##############################################################################
##############################################################################
##############################################################################


##############################################################################
##############################################################################
##############################################################################
# HERE FOLLOWS THE CONTENT OF THE "opts_format.pl" FILE, WHICH HAS BEEN MERGED HERE
# TO AVOID COMPLICATIONS WITH PERL MODULE INSTALLATION.

# HERE FOLLOW THE "rank_reports", "convert_report" , "filter_reports" and "maketable" FUNCTIONS, CALLED FROM THE MAIN PROGRAM FILE.



sub rank_reports    # STILL UNUSED. Self-explaining. 
{

	my @dates = @simtitle;

	sub rank_reports_temps
	{
		my $themereport = $_[0];
		my $counterdate = 0;
		foreach my $date (@dates)
		{
			$date = $simtitle[$counterdate];
			my @files_to_rank =
			  <$mypath/$filenew-$date-temperatures-sum-up.txt>;
			$file_to_rank = $files_to_rank[0];
			open( INFILERANK, "$file_to_rank" )
			  or die "Can't open file_to_rank $file_to_rank: $!";
			@lines_to_rank = <INFILERANK>;
			close INFILERANK;
			my $counterlines = 0;
			my $counterelement;
			my @table;
			my $line_to_rank;

			foreach $line_to_rank (@lines_to_rank)
			{
				my @roww = split( /\s+/, $line_to_rank );
				{
					my $counterelement = 0;
					foreach $element (@roww)
					{
						if ( $counterlines == 0 )
						{
							push @table, [];
						}
						push @{ table->[$counterelement] }, $element;
						$counterelement++;
					}
				}
				$counterlines++;
			}
			$outfilerank = ">$file_to_rank.ranked.txt";
			if (-e $outfilerank) { `chmod 777 $outfilerank\n`; `mv -b $outfilerank-bak\n`;};
			print TOSHELL "chmod 777 $outfilerank\n"; print TOSHELL "mv -b $outfilerank-bak\n";
			open( OUTFILERANK, ">$outfilerank" ) or die "Can't open $outfilerank: $!";
			my $countercases = 0;
			my $case;
			my %rankaverage;
			my %rankmin;
			my %rankmax;
			my %rankdiff_minmax;
			my @syntesis;
			my $number_of_cases = $#{table};           #
			my $number_of_items = $#{ table->[0] };    #

			while ( $countercases <= $number_of_cases )
			{
				my @timeseries =
				  @{ table->[$countercases] }[ 1 .. $#{ table->[0] } ]
				  ;   # # print OUTFILE "\n\@timeseries: @timeseries\n";
				if ( @{ table->[$countercases] }[0] ne "Time" )
				{
					if ( $countercases == 0 )
					{
						print OUTFILERANK "SYNTESYS OF RESULTS\n";
						$countercases = $countercases + 1;
					} else
					{
						my $title = ${ table->[$countercases] }->[0];    # MODIFIED, BECAUSE IT WAS DEPRECATED: my $title = @{ table->[$countercases] }->[0];
						&average(@timeseries);
						&max(@timeseries);
						&min(@timeseries);
						&diff_minmax(@timeseries);
						push @syntesis,
						  [ $title, $average, $max, $min, $diff_minmax ];    #
						$rankaverage{$title} = $average ;   # print OUTFILE "\n\$average: $average\n";
						$rankmin{$title} = $min;    # print OUTFILE "\n\$min: $min\n";
						$rankmax{$title} = $max;    # print OUTFILE "\n\$max: $max\n";
						$rankdiff_minmax{$title} = $diff_minmax ; # print OUTFILE "\n\$diff_minmax: $diff_minmax\n";
						$countercases++;
					}
				} else
				{
					$countercases = $countercases + 1;
				}
			}
			print OUTFILERANK "\nORDERED BY AVERAGE\n";
			foreach $value (
							 sort { $rankaverage{$a} cmp $rankaverage{$b} }
							 keys %rankaverage
			  )
			{
				print OUTFILERANK "$value\t\t $rankaverage{$value}\n";
			}
			print OUTFILERANK "\nORDERED BY MAXIMUM\n";
			foreach $value (
							 sort { $rankmax{$a} cmp $rankmax{$b} }
							 keys %rankmax
			  )
			{
				print OUTFILERANK "$value\t\t $rankmax{$value}\n";
			}
			print OUTFILERANK "\nORDERED BY MINIMUM\n";
			foreach $value (
							 sort { $rankmin{$a} cmp $rankmin{$b} }
							 keys %rankmin
			  )
			{
				print OUTFILERANK "$value\t\t $rankmin{$value}\n";
			}
			print OUTFILERANK "\nORDERED BY DIFF_MINMAX\n";
			foreach $value (
				sort {
					$rankdiff_minmax{$a} cmp $rankdiff_minmax{$b}
				} keys %rankdiff_minmax
			  )
			{
				print OUTFILERANK "$value\t\t $rankdiff_minmax{$value}\n";
			}
			close OUTFILERANK;
			$counterdate++;
		}
	}

	sub rank_reports_comfort
	{
		my $themereport = $_[0];
		my $counterdate = 0;
		foreach my $date (@dates)
		{
			$date = $simtitle[$counterdate];
			my @files_to_rank = <$mypath/$filenew*$date*comfort-sum-up.txt>;
			$file_to_rank = $files_to_rank[0];
			open( INFILERANK, "$file_to_rank" )
			  or die "Can't open file_to_rank $file_to_rank: $!";
			@lines_to_rank = <INFILERANK>;
			close INFILERANK;
			my $counterlines = 0;
			my $counterelement;
			my @table;
			my $line_to_rank;

			foreach $line_to_rank (@lines_to_rank)
			{
				my @roww = split( /\s+/, $line_to_rank );
				{
					my $counterelement = 0;
					foreach $element (@roww)
					{
						if ( $counterlines == 0 )
						{
							push @table, [];
						}
						push @{ table->[$counterelement] }, $element;
						$counterelement++;
					}
				}
				$counterlines = $counterlines + 1;
			}
			$outfilerank = ">$file_to_rank.ranked.txt";
			if (-e $outfilerank) { `chmod 777 $outfilerank\n`; `mv -b $outfilerank-bak\n`;};
			print TOSHELL "chmod 777 $outfilerank\n"; print TOSHELL "mv -b $outfilerank-bak\n";
			open( OUTFILERANK, ">$outfilerank" )
			  or die "Can't open $outfilerank: $!";
			my $countercases = 0;
			my $case;
			my %rankaverage;
			my %rankmin;
			my %rankmax;
			my %rankdiff_minmax;
			my @syntesis;
			my $number_of_cases =
			  $#{table}; # print OUTFILE "\n2 \$number_of_cases: $number_of_cases\n";
			my $number_of_items =
			  $#{ table->[0] }; # print OUTFILE "\n3 \$number_of_items: $number_of_items\n";

			while ( $countercases <= $number_of_cases )
			{
				my @timeseries =
				  @{ table->[$countercases] }[ 1 .. $#{ table->[0] } ];
				if ( @{ table->[$countercases] }[0] ne "Time" )
				{
					if ( $countercases == 0 )
					{
						print OUTFILERANK "SYNTESYS OF RESULTS\n";
						$countercases = $countercases + 1;
					} else
					{
						my $title = ${ table->[$countercases] }->[0];     # MODIFIED, BECAUSE IT WAS DEPRECATED: ${ table->[$countercases] }->[0];

						&average(@timeseries);
						&max(@timeseries);
						&min(@timeseries);
						&diff_minmax(@timeseries);
						push @syntesis,
						  [ $title, $average, $max, $min, $diff_minmax ] ; # print OUTFILE "\nHERE I LIST: $title, $average, $max, $min, $diff_minmax\n";
						$rankaverage{$title} = $average ;   # print OUTFILE "\n\$average: $average\n";
						$rankmin{$title} = $min;    # print OUTFILE "\n\$min: $min\n";
						$rankmax{$title} = $max;    # print OUTFILE "\n\$max: $max\n";
						$rankdiff_minmax{$title} = $diff_minmax ; # print OUTFILE "\n\$diff_minmax: $diff_minmax\n";
						$countercases++;
					}
				} else
				{
					$countercases = $countercases + 1;
				}
			}
			print OUTFILERANK "\nORDERED BY AVERAGE\n";
			foreach $value (
							 sort { $rankaverage{$a} cmp $rankaverage{$b} }
							 keys %rankaverage
			  )
			{
				print OUTFILERANK "$value\t\t $rankaverage{$value}\n";
			}
			print OUTFILERANK "\nORDERED BY MAXIMUM\n";
			foreach $value (
							 sort { $rankmax{$a} cmp $rankmax{$b} }
							 keys %rankmax
			  )
			{
				print OUTFILERANK "$value\t\t $rankmax{$value}\n";
			}
			print OUTFILERANK "\nORDERED BY MINIMUM\n";
			foreach $value (
							 sort { $rankmin{$a} cmp $rankmin{$b} }
							 keys %rankmin
			  )
			{
				print OUTFILERANK "$value\t\t $rankmin{$value}\n";
			}
			print OUTFILERANK "\nORDERED BY DIFF_MINMAX\n";
			foreach $value (
				sort {
					$rankdiff_minmax{$a} cmp $rankdiff_minmax{$b}
				} keys %rankdiff_minmax
			  )
			{
				print OUTFILERANK "$value\t\t $rankdiff_minmax{$value}\n";
			}
			close OUTFILERANK;
			$counterdate++;
		}
	}

	sub rank_reports_loads    #
	{
		my $themereport = $_[0];
		my $counterdate = 0;
		foreach my $date (@dates)
		{
			$date = $simtitle[$counterdate];
			my @files_to_rank = <$mypath/$filenew*$date*loads-sum-up.txt>;
			$file_to_rank = $files_to_rank[0];
			open( INFILERANK, "$file_to_rank" )
			  or die "Can't open file_to_rank $file_to_rank: $!";
			@lines_to_rank = <INFILERANK>;
			close INFILERANK;
			my $outfilerank = ">$file_to_rank-ranked-for-loads.txt";
			if (-e $outfilerank) { `chmod 777 $outfilerank\n`; `mv -b $outfilerank-bak\n`;};
			print TOSHELL "chmod 777 $outfilerank\n"; print TOSHELL "mv -b $outfilerank-bak\n";
			open( OUTFILERANK, ">$outfilerank" ) or die "Can't open $outfilerank: $!";
			my $counterlines = 0;
			my $counterelement;
			my @table;
			my $line_to_rank;

			foreach $line_to_rank (@lines_to_rank)
			{
				my @roww = split( /\s+/, $line_to_rank );
				{
					push @table, [@roww];
				}
			}
			@table =
			  sort { $a->[ $rankdata[2] ] <=> $b->[ $rankdata[2] ] } @table;
			foreach $element (@table)
			{
				$" = " ";
				print OUTFILERANK "@{$element}\n";
			}
			close OUTFILERANK;
			$counterdate++;
		}
	}

	sub rank_reports_tempsstats    #
	{
		my $themereport = $_[0];
		my $counterdate = 0;
		foreach my $date (@dates)
		{
			$date = $simtitle[$counterdate];
			my @files_to_rank = <$mypath/$filenew*$date*tempsstats-sum-up.txt>;
			$file_to_rank = $files_to_rank[0];
			if (-e $file_to_rank) { `chmod 777 $file_to_rank\n`; `mv -b $file_to_rank-bak\n`;}
			print TOSHELL "chmod 777 $file_to_rank\n"; print TOSHELL "mv -b $file_to_rank-bak\n"; 
			open( INFILERANK, "$file_to_rank" )
			  or die "Can't open file_to_rank $file_to_rank: $!";
			@lines_to_rank = <INFILERANK>;
			close INFILERANK;
			$outfilerank = ">$file_to_rank-ranked-for-tempsstats.txt";
			open( OUTFILERANK, ">$outfilerank" )
			  or die "Can't open $outfilerank: $!";
			my $counterlines = 0;
			my $counterelement;
			my @table;
			my $line_to_rank;

			foreach $line_to_rank (@lines_to_rank)
			{
				my @roww = split( /\s+/, $line_to_rank );
				{
					push @table, [@roww];
				}
			}
			@table =
			  sort { $a->[ $rankdata[$rankcolumn[3]] ] <=> $b->[ $rankdata[$rankcolumn[3]] ] }
			  @table;    # THIS INDEX HAS TO BE FIXED!
			foreach $element (@table)
			{
				$" = " ";
				print OUTFILERANK "@{$element}\n";
			}
			close OUTFILERANK;
			$counterdate++;
		}
	}
	
	foreach my $themereport (@themereports)
	{
		if ( $themereport eq "temps" ) { rank_reports_temps($themereport); }
		if ( $themereport eq "comfort" ) { rank_reports_comfort($themereport); }
		if ( $themereport eq "loads" ) { rank_reports_loads($themereport); }
		if ( $themereport eq "tempsstats" ) { rank_reports_tempsstats($themereport); }
	}

}    # END SUB rank_reports. UNUSED



sub convert_report # ZZZ THIS HAS TO BE PUT IN ORDER BECAUSE JUST ONE ITEM WORKS.
{

	sub do_convert_report
	{
		my $themereport = $_[0];
	my $convertcriterium = $themereport;
	my $count = 0;
	my @varthemes_values;
	my @files_to_convert;
	foreach $date (@simtitle)
	{
		$file_to_convert = "$mypath/$filenew-$date-$convertcriterium-sum-up.txt";
		push @files_to_convert, $file_to_convert;
	}

	foreach my $countervar (@varnumbers)
	{
		$basevalue       = $varthemes_variations[$count][0];
		$roofvalue       = $varthemes_variations[$count][1];
		$number_of_steps = $varthemes_steps[$count];
		$range           = ( $roofvalue - $basevalue );
		my @values;
		my $step = 0;

		if ( $number_of_steps > 1 )
		{

			until ( $step > ( $number_of_steps - 1 ) )
			{
				my $value;
				$value = ( $basevalue + ( ( $range / ( $number_of_steps - 1 ) ) * $step ) );
				$value = sprintf( "%.2f", $value );
				push( @values, $value );
				$step++;
			}
		}
		push( @varthemes_values, [@values] );
		$write = Dumper(@varthemes_values);
		$count++;
	}
			
	foreach my $file_to_convert (@files_to_convert)
	{
		open( INFILECONVERT, "$file_to_convert" ) or die "Can't open file_to_convert $file_to_convert: $!";
		my @lines_to_convert = <INFILECONVERT>;
		close INFILECONVERT;
		$outfileconvert = "$file_to_convert" . "-converted.txt";
		if (-e $outfileconvert) { `chmod 777 $outfileconvert\n`; `mv -b $outfileconvert-bak\n`;}
		print TOSHELL "chmod 777 $outfileconvert\n"; print TOSHELL "mv -b $outfileconvert-bak\n"; 
		open( OUTFILECONVERT, ">$outfileconvert" ) or die "Can't open $outfileconvert: $!";
		
		foreach my $line_to_convert (@lines_to_convert)
		{
			my $counter = 0;
			foreach my $countervar (@varnumbers)
			{
				my $stepper         = 1;
				my $number_of_steps = $varthemes_steps[$counter];
				foreach my $value ( @{ $varthemes_values[$counter] } )
				{
					$line_to_convert =~ s/_\+$countervar\-$stepper/$value /;
					$stepper++;
				}
				$line_to_convert =~ s/$mypath\/$file//;
				#$line_to_convert =~ s/_\+$countervar/ $varthemes_report[$counter]/;
				$line_to_convert =~ s/[§£]/ /;
				$line_to_convert =~ s/loads-sum-up.txt-filtered.txt//;
				$counter++;
			}
			print OUTFILECONVERT "$line_to_convert";
		}
		close OUTFILECONVERT;
		open(INFILEPUTCOMMAS, "$outfileconvert") or die "Can't open infileputcommas $outfileconvert: $!";
		my @new_lines_to_convert = <INFILEPUTCOMMAS>;
		close INFILEPUTCOMMAS;
		my $outfileputcommas = "$outfileconvert".".csv";
		if (-e $outfileputcommas) { `chmod 777 $outfileputcommas\n`; `mv -b $outfileputcommas-bak\n`;}
		print TOSHELL "chmod 777 $outfileputcommas\n"; print TOSHELL "mv -b $outfileputcommas-bak\n"; 
		open( OUTFILEPUTCOMMAS, ">$outfileputcommas" ) or die "Can't open outfileputcommas $outfileputcommas: $!";
		foreach my $new_line_to_convert (@new_lines_to_convert)
		{
			$new_line_to_convert =~ s/\t/ /g;
			$new_line_to_convert =~ s/  / /g;
			$new_line_to_convert =~ s/  / /g;
			$new_line_to_convert =~ s/ /,/g;

			my @roww = split( /,/, $new_line_to_convert );
			my $number_of_items = ( scalar(@roww) -1);
			my $count = 0;
			foreach my $row (@roww)
			{
				foreach my $filter_column (@filter_columns)
				{
					if ( $count == $filter_column  )
					{
						if ( $count < $number_of_items )
						{
							print OUTFILEPUTCOMMAS "$row,";	
						}
						else {print OUTFILEPUTCOMMAS "$row";}
					}
				}
				$count++;
			}
			print OUTFILEPUTCOMMAS "\n";
		}
		close OUTFILEPUTCOMMAS;
	}
	} # END SUB DO_CONVERT_REPORT
	
		foreach my $themereport (@themereports)
	{	
		do_convert_report($themereport);
	}
	
		
} # END sub convert_report



sub filter_reports
{
	
	sub do_filter_reports
	{
		my $themereport = $_[0];
	my $counterdate = 0;
	my $countfiles  = 0;
	my $filtercriterium = $themereport;

	foreach $date (@simtitle)
	{
		$file_source = "$mypath/$filenew-$date-$filtercriterium-sum-up.txt";
		open( INFILEFILTER, "$file_source" ) or die "Can't open file_source $file_source: $!";
		my @lines_to_filter = <INFILEFILTER>;
		close INFILEFILTER;
		my $counterfilter = 0;	
		foreach my $theme_report (@files_to_filter)	
		{
			if ($counterfilter > 0)
			{
				my @cases_to_filter     = @{ $filter_reports[$counterfilter][0] };
				my @cases_not_to_filter = @{ $filter_reports[$counterfilter][1] };
				my @fixed_values        = @{ $filter_reports[$counterfilter][2] };
				my $filtered_filetitle = $files_to_filter[$counterfilter];
				$outfilefilter = "$file_source-$filtered_filetitle"."-filtered.txt";
				if (-e $outfilefilter) { `chmod 777 $outfilefilter\n`; `mv -b $outfilefilter-bak\n`;}
				print TOSHELL "chmod 777 $outfilefilter\n"; print TOSHELL "mv -b $outfilefilter-bak\n"; 
				open( OUTFILEFILTER, ">$outfilefilter" ) or die "Can't open $outfilefilter: $!";
				foreach my $line_to_filter (@lines_to_filter)
				{
					my $counter = 0;
					my $accum   = 0;
					if ( @cases_not_to_filter )
					{
						foreach my $case_not_to_filter (@cases_not_to_filter)
						{
							if ( $line_to_filter =~ m/_\$case_not_to_filter\-$fixed_values[$counter]/ )
							{
								$accum++;
								if ( $accum >= scalar(@fixed_values) )
								{
									$line_to_filter =~ s/\t/ /g;
									$line_to_filter =~ s/  / /g;
									$line_to_filter =~ s/  / /g;
									print OUTFILEFILTER "$line_to_filter";					
									$accum = 0;
								}
							}
							$counter++;
						}
					}
					else
					{
						print OUTFILEFILTER "$line_to_filter";
					}
				}
			}
			close OUTFILEFILTER;
			$counterfilter++;
		}
		$countfiles++;
	}
	}
	
	
	
	foreach my $themereport (@themereports)
	{
		do_filter_reports($themereport);
	}
	
} # END sub filter_reports


sub convert_filtered_reports
{
	sub do_convert_filtered_reports
	{
		my $themereport = $_[0];
	my $convertcriterium = $themereport;
	my $count = 0;
	my $counter = 0;
	my $counterfile = 0;
	my @varthemes_values;
	my @files_to_convert;
	my $write;
	foreach $date (@simtitle)
	{
		foreach my $theme_to_filter (@files_to_filter)
		{
			if ($counter > 0)
			{			    
				$file_to_convert = "$mypath/$filenew-$date-$convertcriterium-sum-up.txt-$theme_to_filter-filtered.txt";
				push @files_to_convert, $file_to_convert;
			}
			$counter++;
		}
	}

	foreach my $countervar (@varnumbers)
	{
		my $basevalue       = $varthemes_variations[$count][0];
		my $roofvalue       = $varthemes_variations[$count][1];
		my $number_of_steps = $varthemes_steps[$count];
		my $range           = ( $roofvalue - $basevalue );
		my @values;
		my $step = 0;
		if ( $number_of_steps > 1 )
		{

			until ( $step > ( $number_of_steps - 1 ) )
			{
				my $value;
				$value = ( $basevalue + ( ( $range / ( $number_of_steps - 1 ) ) * $step ) );
				$value = sprintf( "%.2f", $value );
				push( @values, $value );
				$step++;
			}
		}
		push( @varthemes_values, [@values] );
		$write = Dumper(@varthemes_values);
		$count++;
	}
			
	foreach my $file_to_convert (@files_to_convert)
	{
		open( INFILECONVERT, "$file_to_convert" ) or die "Can't open file_to_convert $file_to_convert: $!";
		my @lines_to_convert = <INFILECONVERT>;
		close INFILECONVERT;
		my $outfileconvert = "$file_to_convert" . "-converted.txt";
		if (-e $outfileconvert) { `chmod 777 $outfileconvert\n`; `mv -b $outfileconvert-bak\n`;}
		print TOSHELL "chmod 777 $outfileconvert\n"; print TOSHELL "mv -b $outfileconvert-bak\n"; 
		open( OUTFILECONVERT, ">$outfileconvert" ) or die "Can't open $outfileconvert: $!";
		
		foreach my $line_to_convert (@lines_to_convert)
		{
			my $counter = 0;
			foreach my $countervar (@varnumbers)
			{
				my $stepper         = 1;
				my $number_of_steps = $varthemes_steps[$counter];
				foreach my $value ( @{ $varthemes_values[$counter] } )
				{
					$line_to_convert =~ s/_\+$countervar\-$stepper/$value /;
					$stepper++;
				}
				$line_to_convert =~ s/$mypath\/$file//;
				$line_to_convert =~ s/_\+$countervar/ $varthemes_report[$counter]/;
				$line_to_convert =~ s/[§£]/ /;
				$line_to_convert =~ s/loads-sum-up.txt-filtered.txt//;
				$counter++;
			}
			print OUTFILECONVERT "$line_to_convert";
		}
		close OUTFILECONVERT;
		

		open(INFILE2PUTCOMMAS, "$outfileconvert") or die "Can't open infile2putcommas $outfileconvert: $!";
		my @new_lines_to_convert = <INFILE2PUTCOMMAS>;
		close INFILE2PUTCOMMAS;
		my $outfile2putcommas = "$outfileconvert".".csv";
		if (-e $outfile2putcommas) { `chmod 777 $outfile2putcommas\n`; `mv -b $outfile2putcommas-bak\n`;}
		print TOSHELL "chmod 777 $outfile2putcommas\n"; print TOSHELL "mv -b $outfile2putcommas-bak\n"; 
		open( OUTFILE2PUTCOMMAS, ">$outfile2putcommas" ) or die "Can't open outfile2putcommas $outfile2putcommas: $!";
		foreach my $new_line_to_convert (@new_lines_to_convert)
		{
			$new_line_to_convert =~ s/ /,/g;

			my @roww = split( /,/, $new_line_to_convert );
			my $number_of_items = ( scalar(@roww) -1);
			my $count = 0;
			foreach my $row (@roww)
			{
				foreach my $filter_column (@filter_columns)
				{
					if ( $count == $filter_column  )
					{
						if ( $count < $number_of_items )
						{
							print OUTFILE2PUTCOMMAS "$row,";	
						}
						else {print OUTFILE2PUTCOMMAS "$row";}
					}
				}
				$count++;
			}
			print OUTFILE2PUTCOMMAS "\n";
		}
		close OUTFILE2PUTCOMMAS;
	}
	}
	
	foreach my $themereport (@themereports)
	{
		do_convert_filtered_reports($themereport);
	}
	
}### END SUB convert_reports. THIS IS NOT WORKING. IT IS NOT MODIFYING THE FILTERED FILES.


sub maketable
{
	sub do_maketable
	{
		$themereport = $_;
		my $convertcriterium = $themereport;
				
	foreach $date (@simtitle)
	{
		my $countmaketable = 0;
		my @rowelements;
		foreach my $theme_to_filter (@files_to_filter)
		{
			my @gatherarray;
			if ($countmaketable > 0)		
			{
				$file_to_maketable = "$mypath/$filenew-$date-$convertcriterium-sum-up.txt-$theme_to_filter-filtered.txt-converted.txt";
				open(INFILE,  "$file_to_maketable")   or die "Can't open file_to_maketable $file_to_maketable: $!\n";
				my @lines = <INFILE>;
				close(INFILE);
				my $number_of_rows = $maketabledata[$countmaketable][0];
				my $number_of_columns = $maketabledata[$countmaketable][1];
				my $x_column = $base_columns[$countmaketable][0];
				my $y_column = $base_columns[$countmaketable][1];
				my $report_column = $base_columns[$countmaketable][2];			
				my $countline = 0;
				my @temparray;
				
				foreach my $line (@lines) 
				{
					@rowelements = split(/\s+/, $line);
					push @gatherarray, [@rowelements];
				#}
				print OUTFILE "\nGATHERARRAY: \n"; print OUTFILE Dumper(@gatherarray); print OUTFILE "\n\n";

					if ($countline < $number_of_columns)
					{
						push @temparray, " $rowelements[$y_column]";
					}
					$countline++;
				}
				my $countline = 0;
				push my @array, ["\" \"", @temparray ];
				my $countrow = 0;
				until ($countrow >= $number_of_rows)
				{
					push @array, [];
				$countrow++;
				}
				print OUTFILE "THIS 1\n" ; print OUTFILE Dumper(@array);
				my $countlinearray = 0;
				
				foreach my $linearray (@array)
				{
					if ($countlinearray > 0)
					{
						for ( $i = 0 ; $i <  $number_of_columns ; $i++)
						{
							if ($i == 0)
							{
								push @{$array[$countlinearray]}, $gatherarray[$countline][$x_column], $gatherarray[$countline][$report_column];
							}
							elsif ($i > 0)
							{
								push @{$array[$countlinearray]}, $gatherarray[$countline][$report_column];

							}
							$countline++;
						}
					}
					$countlinearray++;
				}
				
				my $outfile = "$file_to_maketable"."-madetable.txt";
				if (-e $outfile) { `chmod 777 $outfile\n`; `mv -b $outfile-bak\n`;}
				print TOSHELL "chmod 777 $outfile\n"; print TOSHELL "mv -b $outfile-bak\n"; 
				open(OUTFILE, ">$outfile") or die "Can't open $outfile: $!\n";
				foreach my $line (@array)
				{
					print OUTFILE "@{$line}\n";
				}
				close OUTFILE;
			}
			$countmaketable++;
		}
	}
	}
	
	foreach my $themereport (@themereports)
	{
		do_maketable($themereport);
	}
}

# END OF THE CONTENT OF THE "opts_format.pl" FILE.
##############################################################################
##############################################################################
##############################################################################


##############################################################################
##############################################################################
##############################################################################
# HERE FOLLOWS THE CONTENT OF THE "opts_prepare.pl" FILE, WHICH HAS BEEN MERGED HERE
# TO AVOID COMPLICATIONS WITH THE PERL MODULE INSTALLATION

# This program launched a text interface for creating OPTS configuration files. 
# It has not been updated after a lot of changes to OPTS, so it is currently not usable.

no strict; 
no warnings;

sub prepare 
{ 

print "This is OPTS-launch, a program written to prepare configuration files for OPTS.
OPTS is a program written to manage parametric explorations through the ESP-r building performance simulation program.
Copyright: Gian Luca Brunetti and Politecnico di Milano, 2008-2014
(gianluca.brunetti\@polimi.it)
";

no warnings;
use Data::Dumper;
$Data::Dumper::Indent = 0;
$Data::Dumper::Useqq  = 1;
$Data::Dumper::Terse  = 1;
require "./optdatadefaults.pl";
my $presentloop       = "mainloop";
my $yn_operationsloop = "n";
my $yn_morphingloop   = "n";
my $yn_simulationloop = "n";
my $yn_resultsloop    = "n";
my $yn_filteringloop  = "n";
my $yn_help           = "n";
my $yn_ovverride      = "n";
my $configfile        = "./optdatadefaults.pl";
my $changenumber      = 0;
my $var_number        = 1;
my $casenumber        = 1;
my $numberofcases     = 1;

sub variables
{
	$stepsvar                  = ${ "stepsvar" . "$var_number" };
	@applytype                 = @{ "applytype" . "$var_number" };
	@generic_change            = @{ "generic_change" . "$var_number" };
	$rotate                    = ${ "rotate" . "$var_number" };
	$rotatez                   = ${ "rotatez" . "$var_number" };
	$general_variables         = ${ "general_variables" . "$var_number" };
	$translate                 = ${ "translate" . "$var_number" };
	$translate_surface         = ${ "translate_surface" . "$var_number" };
	$keep_obstructions         = ${ "keep_obstructions" . "$var_number" };
	$shift_vertexes            = ${ "shift_vertexes" . "$var_number" };
	$construction_reassignment = ${ "construction_reassignment" . "$var_number" };
	$thickness_change          = ${ "thickness_change" . "$var_number" };
}

	
sub mainloop
{
	print "
______________________________________________________

OPTs - MAIN - Please follow, one step at a time. Advice: put the shell window full-size. 
______________________________________________________

a - execute ready-made tests on a scene to be built? =>  (Go to page.) If not, skip this.
b - set the OPTs' configuration file. Current: $configfile. This is the file where OPTs gets the defaults.
c - specify your UNIX home directory. Current: $mypath. The test model has to be there.
d - set model path. Current: $file. This is the folder name of you model.
e - set the config file (\".cfg\") name to work on. Current: $fileconfig
f - set operations chain => (Go to page)
g - set variables sequence. Current: @varnumbers
h - set test strategies => (Go to page)
i - set simulation data => (Go to page)
l - set results retrieval criteria => (Go to page)
m - set results filtering criteria => (Go to page)
n - save as
o - about
? - help
-   quit
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		simpletestsloop();
	} elsif ( $mainchoice eq "b" )
	{
		choose(
			$configfile,
"Please insert the name of the configuration file you want to load (Unix path):\n",
			"mainloop"
		);
	} elsif ( $mainchoice eq "c" )
	{
		choose( $mypath, "Please insert the path of your UNIX home directory\n",
				"mainloop" );
	} elsif ( $mainchoice eq "d" )
	{
		choose(
			$file,
			"Please insert the name of the model directory (Unix path):
(Note: the model has to be ready for simulation.)\n",
			"mainloop"
		);
	} elsif ( $mainchoice eq "e" )
	{
		choose( $fileconfig, "Please insert the name of your config file\n",
				"mainloop" );
	} elsif ( $mainchoice eq "f" )
	{
		quickchoose( $yn_operationsloop,
					 "Do you want to specify the operations sequence?\n",
					 "operationsloop" );
	} elsif ( $mainchoice eq "g" )
	{
		multichoose(
			\@varnumbers,
"Please insert the sequence of parameter numbers to be morphed (separated by commas):\n",
			"mainloop"
		);
	} elsif ( $mainchoice eq "h" )
	{
		morphingloop( $var_number, $casenumber );
	} elsif ( $mainchoice eq "i" )
	{
		simulationloop();
	} elsif ( $mainchoice eq "l" )
	{
		resultsloop();
	} elsif ( $mainchoice eq "m" )
	{
		 gotoloop("filteringloop", $var_number, $casenumber);
	} elsif ( $mainchoice eq "n" )
	{
		print "Please specify a name for the file:\n";
		my $outfile = <STDIN>;
		chomp $outfile;
		savefile($outfile);
	} elsif ( $mainchoice eq "o" )
	{
		print
"This is OPTS-launch, a program written to prepare configuration files for OPTS.
OPTS is a program written to manage parametric explorations through the ESP-r building performance simulation program.
Copyright: Gian Luca Brunetti and Politecnico di Milano, 2008-2014
(gianluca.brunetti\@polimi.it)
";
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		print mainloop();
	} elsif ( $mainchoice eq "\-" )
	{
		print "Exiting.\n" and return;
	} else
	{
		mainloop();
	}
}


sub simpletestsloop
{
	print "
______________________________________________________

OPTs - PRE-MADE TESTS
______________________________________________________

a - test the position of a flat solar collector in space
b - test the position and form of a free-standing greenhouse
c - test the position and form of an attached sunspace
d - test the orientation of a directional ventilative system
e - test the form of a shading device for a window
f - test the composition of a building envelope
? - help
-   go to \"main\" page when done
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		testcollectorloop();
	} elsif ( $mainchoice eq "b" )
	{
		testfreestandingloop();
	} elsif ( $mainchoice eq "c" )
	{
		testattachedloop();
	} elsif ( $mainchoice eq "d" )
	{
		testventilationloop();
	} elsif ( $mainchoice eq "e" )
	{
		testwindowshadingloop();
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		operationsloop();
	} elsif ( $mainchoice eq "\-" )
	{
		mainloop();
	} else
	{
		simpletestsloop();
	}
}


sub testcollectorloop
{
	$configfile = "./optdatadefaults-collector.pl";
	require $configfile;
	print "
______________________________________________________

OPTs - TEST COLLECTOR (PRE-MADE TEST)
______________________________________________________

Now the configuration file for OPTs has been set to \"$configfile\". 
Please follow each step from \"a\" to \"c\" to configure the test case.
a - Insert a new one (ending with \".pl\") to edit the values.
b - Insert the name of the model directory you want to create. Now it is 
c - Update the test value to the new settings.
? - help
-   go to \"main\" page when done
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		choose(
			$configfile,
"Please insert the name of the OPTs configuration file you want to load (Unix path):\n",
			"testcollectorloop"
		);
	} elsif ( $mainchoice eq "b" )
	{
		choose(
			$file,
"Now the name of the model directory is $file. You have to change it from \"basetest-collector\". Please input a new directory:\n",
			"testcollectorloop"
		);
		
	} elsif ( $mainchoice eq "c" )
	{
		`cp ./optdatadefaults-collector.pl $configfile`;
		require $configfile;
		$step1 = ($$rotatez1[0][3] / ($stepsvar1 -1));
		$step2 = ($$rotate2[0][2] / ($stepsvar2 -1));
		@coordinates_for_movement3 = @{ $$translate3[0][2] };
		$x_end3 = $coordinates_for_movement3[0];
		$x_swingtranslate3 = ( 2 * $x_end3 );
		if ($stepsvar3 > 1 ) { $x_pace3 = ( $x_swingtranslate3 / ( $stepsvar3 - 1 ) ); } else {$x_pace3 = 1 }
		@coordinates_for_movement4 = @{ $$translate4[0][2] };
		$y_end4 = $coordinates_for_movement4[1];
		$y_swingtranslate4 = ( 2 * $y_end4 );
		if ($stepsvar4 > 1 ) { $y_pace4 = ( $y_swingtranslate4 / ( $stepsvar4 - 1 ) ); } else {$y_pace4 = 1 }
		@coordinates_for_movement5 = @{ $$translate5[0][2] };
		$z_end5 = $coordinates_for_movement5[2];
		$z_swingtranslate5 = ( 2 * $z_end5 );
		if ($stepsvar5 > 1 ) { $z_pace5 = ( $z_swingtranslate5 / ( $stepsvar5 - 1 ) ); } else {$z_pace5 = 1 }
		print "Now the collector is a square panel 2 mq wide, each edges 1.41 m long.
It is closed on all side save one. Its tilt is 45° and its orientation is towards south. It is 1 cm thick.
Some of its present values will be changed to verify the influence of each change over the quantity of radiation collected by it.
Please now open Esp-r in parallel with OPT, in another window, and create the obstructions you want in the scene.
This could be done by entering esp-r though the shell with the command \"esp-r\" or \"prj\", then choosing the following options:
-> d -> \"other\" -> model directory (default: \"basetest-collector\") -> \"basetest.cfg\" (this is the default. You may have changed it). ->
-> - -> m -> c -> a -> a -> h -> \"dimensional input\" -> add/etc -> add. Then follow instructions. The obstructions in ESP-r are created as boxes.
While exiting, if asked accept that the shading and insolation values are recalculated silently.
You can also change the place of the collector in the scene, its size, tilt, compositions etc.
To do so, you have to follow the following steps in ESP-r: -> m -> c -> a -> a.
You can also change the value of the exposure and the albedo of the soil surrounding the building. To do so: 
- > m -> c -> c; and -> m -> c -> d.
Or you can choose a new climate file: -> b -> a.  When done, exit ESP-r.

Your model is now ready to be tested with the following variations:
The tilt angle will be changed through $stepsvar1 steps around its present value. Each step will change $step1 °.
The azimuth angle will be changed through $stepsvar2 steps around its present value. Each step will change $step2 °.
The x position will be changed through $stepsvar3 steps around its present value. Each step will change $x_pace3 m.
The y position will be changed through $stepsvar4 steps around its present value. Each step will change $y_pace4 m.
The z position will be changed through $stepsvar5 steps around its present value. Each step will change $z_pace5 m.
The transparent surface of the collector will be tested as beeing made of each of the following materials:
- fictitious transparent (using the $applytype6[0][1] config file);
- 1 sheet clear glass (using the $applytype7[0][1] config file);
- 1 sheet low-e glass (using the $applytype8[0][1] config file);
- 2 sheets clear glass (using the $applytype9[0][1] config file);
- 1 sheet clear + 1 sheet low-e glass  (using the $applytype10[0][1] config file).
To change one or more of the values above, go back to the main page, then go to \"set metamorphing strategies\".
"; 
	testcollectorloop();
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		testcollectorloop();
	} elsif ( $mainchoice eq "\-" )
	{
		mainloop();
	} else
	{
		testcollectorloop();
	}
}



sub operationsloop
{
	print "
______________________________________________________

OPTs - OPERATIONS
______________________________________________________

a - create cases for simulations\? Current\: $dowhat[0]
b - simulate\? Current\: $dowhat[1];
c - retrieve results?\ Current\: $dowhat[2]
d - build single reports\? Current\: $dowhat[3]
e - merge reports\? Current\: $dowhat[4]
f - rank reports\? Current\: $dowhat[5]
g - filter reports\? Current\: $dowhat[6]
h - convert reports\? Current\: $dowhat[7]
i - go to the data manipulation page ->
j - launch the execution of planned operations by OPTs
? - help
-   go to \"main\" page
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		quickchoose( $dowhat[0], "Do you want to create new test cases?\n",
					 "operationsloop" );
	} elsif ( $mainchoice eq "b" )
	{
		quickchoose( $dowhat[1], "Do you want to launch simulations?\n",
					 "operationsloop" );
	} elsif ( $mainchoice eq "c" )
	{
		quickchoose( $dowhat[2], "Do you want to retrieve results?\n",
					 "operationsloop" );
	} elsif ( $mainchoice eq "d" )
	{
		quickchoose( $dowhat[3], "Do you want to extract results?\n",
					 "operationsloop" );
	} elsif ( $mainchoice eq "e" )
	{
		quickchoose( $dowhat[4], "Do you want to merge the reports?\n",
					 "operationsloop" );
	} elsif ( $mainchoice eq "f" )
	{
		quickchoose(
			$dowhat[5],
			"Do you want to rank the merged results?
(Advice: don't do this if you want to filter or rearrange them.)\n",
			"operationsloop"
		);
	} elsif ( $mainchoice eq "g" )
	{
		quickchoose( $dowhat[6],
					 "Do you want to filter the results to with respects to some variables?\n",
					 "operationsloop" );
	} 
	elsif ( $mainchoice eq "h" )
	{
		quickchoose( $dowhat[7],
					 "Do you want to rearrange the filtered data, for instance in order to chart them?\n",
					 "operationsloop" );
	} 
	elsif ( $mainchoice eq "i" )
	{
					 gotoloop("filteringloop", $var_number, $casenumber);
	} 
	elsif ( $mainchoice eq "j" )
	{
		print "Input \"run\" if you want to launch the execution of the planned operations by OPTs. No other input will launch the program. If you lauch it, OPTs will you your home directory to make ESP-r create new models, launch simulations and write report files. It is advisable that you understand well how it works before launching large and complex sequences of operations.\n";
		my $inputtext = <>;
		chomp $inputtext;
		if ($inputtext eq "run"){`./opt.run`;}
		else {operationsloop();}
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		operationsloop();
	} elsif ( $mainchoice eq "\-" )
	{
		mainloop();
	} else
	{
		operationsloop();
	}
}

sub morphingloop
{
	&variables;
	my $thingtoprint = ${ "stepsvar" . "$stepsvar" };
	print "
______________________________________________________

OPTs - EDITING - variable: $var_number, iteration number: $casenumber
______________________________________________________

a - set the variable number you want to define now. Current: $var_number
b - set the number_of_steps_for_this_variable. Current: $thingtoprint
c - set the times do you want to iterate the steps on the model. Current: $numberofcases
d - what is the iteration number you are going to set now? Current: $casenumber
e - set the geometry file name you are working on now. Current: $applytype[$casenumber-1][1]
f - override the geometry file with another one? $yn_ovverride - Current: $applytype[$casenumber-1][2]
g - generate families of cases. Current: $general_variables[0]
h - append to other families of cases. Current: $general_variables[1] 
i - input modificaton type. Current: $applytype[$casenumber-1][0]
? - help
-   go to \"main\" page
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		quickchoose( $var_number,
					 "Please insert variable number you want to define now:\n",
					 "morphingloop", $var_number, $casenumber );
	} elsif ( $mainchoice eq "b" )
	{
		quickchoose(
			$stepsvar,
"Please insert the number of steps through which you want to repeat the change:\n",
			"morphingloop",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "c" )
	{
		quickchoose(
			$numberofcases,
"How many times do you want to iterate the steps to make changes in parallel?
(Advice: if in doubt, leave 1. For simple cases - one-zone models, leave 1. Leave 1.):\n",
			"morphingloop",
			$var_number,
			$casenumber
		);
		if ( scalar(@applytype) < $numberofcases )
		{
			until ( scalar(@applytype) == $numberofcases )
			{
				push( @applytype, [""] );
			}
			until ( scalar( @{$translate} ) == $numberofcases )
			{
				push( @{$translate}, [""] );
			}
			until ( scalar( @{$rotate} ) == $numberofcases )
			{
				push( @{$rotate}, [""] );
			}
			until ( scalar( @{$rotatez} ) == $numberofcases )
			{
				push( @{$rotatez}, [""] );
			}
			until ( scalar( @{$translate_surface} ) == $numberofcases )
			{
				push( @{$translate_surface}, [""] );
			}
			until ( scalar( @{$shift_vertexes} ) == $numberofcases )
			{
				push( @{$shift_vertexes}, [""] );
			}
			until ( scalar( @{$construction_reassignment} ) == $numberofcases )
			{
				push( @{$construction_reassignment}, [""] );
			}
			until ( scalar( @{$thickness_change} ) == $numberofcases )
			{
				push( @{$thickness_change}, [""] );
			}
			until ( scalar( @{$keep_obstructions} ) == $numberofcases )
			{
				push( @{$keep_obstructions}, [""] );
			}
		} elsif ( scalar(@applytype) > $numberofcases )
		{
			until ( scalar(@applytype) == $numberofcases )
			{
				pop(@applytype);
			}
			until ( scalar( @{$translate} ) == $numberofcases )
			{
				pop( @{$translate} );
			}
			until ( scalar( @{$rotate} ) == $numberofcases )
			{
				pop( @{$rotate} );
			}
			until ( scalar( @{$rotatez} ) == $numberofcases )
			{
				pop( @{$rotatez} );
			}
			until ( scalar( @{$translate_surface} ) == $numberofcases )
			{
				pop( @{$translate_surface} );
			}
			until ( scalar( @{$shift_vertexes} ) == $numberofcases )
			{
				pop( @{$shift_vertexes} );
			}
			until ( scalar( @{$construction_reassignment} ) == $numberofcases )
			{
				pop( @{$construction_reassignment} );
			}
			until ( scalar( @{$thickness_change} ) == $numberofcases )
			{
				pop( @{$thickness_change} );
			}
			until ( scalar( @{$keep_obstructions} ) == $numberofcases )
			{
				pop( @{$keep_obstructions} );
			}
		}
	} elsif ( $mainchoice eq "d" )
	{
		quickchoose( $casenumber,
			   "Please input the iteration number you want to deal with now:\n",
			   "morphingloop", $var_number, $casenumber );
	} elsif ( $mainchoice eq "e" )
	{
		choose(
			$applytype[$casenumber][1],
			"Please write the name of the geometry file for the zone, 
or else a name of a model file you want to substitute with another:\n",
			"morphingloop",
			$var_number,
			$casenumber
		);
		$var_number[$casenumber][2] = $var_number[$casenumber][1];
	} elsif ( $mainchoice eq "f" )
	{
		print "Do you want to overwrite the file above with another one?
If not, type \"n\". If yes, write the name of the file that will substitute the old.n\"
Advice: if in doubt, don't overwrite the file. \n";
		my $inputtext = <STDIN>;
		chomp $inputtext;
		if ( $inputtext eq "n" )
		{
			( $applytype[$casenumber][2] = $applytype[$casenumber][1] );
			morphingloop();
		} else
		{
			$applytype[$casenumber][2] = $inputtext;
			$presentloop = $nextloop;
			morphingloop();
		}
	} elsif ( $mainchoice eq "g" )
	{
		quickchoose( $$general_variables[0], "Generate families of cases?\n",
					 "morphingloop", $var_number, $casenumber );
	} elsif ( $mainchoice eq "h" )
	{
		quickchoose(
			$general_variables[1],
"Append to other families of cases? Current: $$general_variables[1] ",
			"morphingloop",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "i" )
	{
		variables();
		inputtype();

		sub inputtype()
		{
			printscreen();

			sub printscreen()
			{
				print "
______________________________________________________

OPTs - EDITING CHOICE - variable: $var_number, iteration number: $casenumber
______________________________________________________

Please input the modification type.
m - translate zone
n - rotate zone horizontal plane
o - rotate zone on vertical plane
p - translate surface
q - translate vertexes
r - construction reassignment
s - change thickness in construction
t - bring obstructions still
u - refresh radiation calculations (NOT YET IMPLEMENTED)
v - refresh mass-flow network data (NOT YET IMPLEMENTED)
-   return to the editing page
The Current setting is $applytype[$casenumber-1][0].\n";
			}
			my $inputtext = <STDIN>;
			chomp $inputtext;
			if ( $inputtext eq "m" )
			{
				$applytype[ $casenumber - 1 ][0] = "translation";
			} elsif ( $inputtext eq "n" )
			{
				$applytype[ $casenumber - 1 ][0] = "rotation";
			} elsif ( $inputtext eq "o" )
			{
				$applytype[ $casenumber - 1 ][0] = "rotationz";
			} elsif ( $inputtext eq "p" )
			{
				$applytype[ $casenumber - 1 ][0] = "surface_translation";
			} elsif ( $inputtext eq "q" )
			{
				$applytype[ $casenumber - 1 ][0] = "vertex_translation";
			} elsif ( $inputtext eq "r" )
			{
				$applytype[ $casenumber - 1 ][0] = "construction_reassignment";
			} elsif ( $inputtext eq "s" )
			{
				$applytype[ $casenumber - 1 ][0] = "thickness_change";
			} elsif ( $inputtext eq "t" )
			{
				$applytype[ $casenumber - 1 ][0] = "keep_obstructions_back";
			} elsif ( $inputtext eq "-" )
			{
				morphingloop();
			}
			print "The current setting is $applytype[$casenumber-1][0].
Do you want to go to the editing page?\n";
			my $response = <>;
			chomp $response;
			if ( $response eq "y" )
			{
				gotoedit( $applytype[ $casenumber - 1 ][0],
						  $var_number, $casenumber );
			} else
			{
				morphingloop();
			}
		}
	} elsif ( $mainchoice eq "?", $var_number, )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		print mainloop();
	} elsif ( $mainchoice eq "\-" )
	{
		mainloop();
	} else
	{
		morphingloop ( $_[0] );
	}
}


sub gotoedit
{
	if ( $applytype[ $casenumber - 1 ][0] eq "translation" )
	{
		translation( $var_number, $casenumber );
	} elsif ( $applytype[ $casenumber - 1 ][0] eq "rotation" )
	{
		rotation( $var_number, $casenumber );
	} elsif ( $applytype[ $casenumber - 1 ][0] eq "rotationz" )
	{
		rotationz( $var_number, $casenumber );
	} elsif ( $applytype[ $casenumber - 1 ][0] eq "surface_translation" )
	{
		surface_translation( $var_number, $casenumber );
	} elsif ( $applytype[ $casenumber - 1 ][0] eq "vertex_translation" )
	{
		vertex_translation( $var_number, $casenumber );
	} elsif ( $applytype[ $casenumber - 1 ][0] eq "construction_reassignment" )
	{
		construction_reassignment( $var_number, $casenumber );
	} elsif ( $applytype[ $casenumber - 1 ][0] eq "thickness_change" )
	{
		thickness_change( $var_number, $casenumber );
	} elsif ( $_[0] eq "keep_obstructions_back" )
	{
		keep_obstructions_back( $var_number, $casenumber );
	}
}

sub translation
{
	my $var_number = $_[0];
	my $casenumber = $_[1];
	print "
______________________________________________________

OPTs - ZONE TRANSLATION - variable: $var_number, iteration number: $casenumber
______________________________________________________

a - translate? Current: $$translate[$casenumber-1][0]
b - translate obstructions too? Current: $$translate[$casenumber-1][1]
c - specify the coordinates for translation. Current: @{$$translate[$casenumber-1][2]}
d - update radiation data with the \"ish\" module. Current. $$translate[$casenumber-1][3]
? - help
-   go to \"metamorphing\" page
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		quickchoose(
					 $$translate[ $casenumber - 1 ][0],
					 "Do you want to translate the zone (y/n):\n",
					 "translation",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "b" )
	{
		quickchoose(
			$$translate[ $casenumber - 1 ][1],
"Do you want to translate the obstruction together with the zone? (y/n):\n",
			"translation",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "c" )
	{
		multichoose(
			\@{ $$translate[ $casenumber - 1 ][2] },
"Please specify the x y z coordinates for the translation (separated by commas):\n",
			"translation",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "d" )
	{
		quickchoose(
					 $$translate[ $casenumber - 1 ][3],
					 "Do you want the insolation data to be updated?:\n",
					 "translation",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		translation();
	} elsif ( $mainchoice eq "\-" )
	{
		morphingloop();
	} else
	{
		translation();
	}
}

sub rotation
{
	my $var_number = $_[0];
	my $casenumber = $_[1];
	print "
______________________________________________________

OPTs - ZONE ROTATION - variable: $var_number, iteration number: $casenumber
______________________________________________________

a - rotate zone? Current: $$rotate[$casenumber-1][0]
b - rotate obstructions too? Current: $$rotate[$casenumber-1][1]
c - specify angle for the rotation swing. Current: $$rotate[$casenumber-1][2]
d - update radiation data with the \"ish\" module. Current. $$rotate[$casenumber-1][3]
? - help
-   go to \"metamorphing\" page
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		quickchoose( $$rotate[ $casenumber - 1 ][0],
					 "Do you want to rotate the zone (y/n):\n",
					 "rotation", $var_number, $casenumber );
	} elsif ( $mainchoice eq "b" )
	{
		quickchoose(
			$$rotate[ $casenumber - 1 ][1],
"Do you want to rotate the obstruction together with the zone? (y/n):\n",
			"rotation",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "c" )
	{
		quickchoose(
					 $$rotate[ $casenumber - 1 ][2],
					 "Please specify the rotation swing for the translation:\n",
					 "rotation",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "d" )
	{
		quickchoose(
					 $$rotate[ $casenumber - 1 ][3],
					 "Do you want the insolation data to be updated?:\n",
					 "rotation",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		rotation();
	} elsif ( $mainchoice eq "\-" )
	{
		morphingloop();
	} else
	{
		rotation();
	}
}

sub rotationz
{
	my $var_number = $_[0];
	my $casenumber = $_[1];
	print "
______________________________________________________

OPTs - ZONE ROTATION ON A VERTICAL PLANE - variable: $var_number, iteration number: $casenumber
______________________________________________________

a - rotate zone on a vertical plane? Current: $$rotatez[$casenumber-1][0]
b - plane of rotation? Current: $$rotatez[2]
c - coordinates of the centre of rotation? Current: @{$$rotatez[$casenumber-1][1]}
d - specify the angle for the rotation swing. Current: $$rotatez[$casenumber-1][3]
e - rotation already had by the zone with respect to the x axis. Current: $$rotatez[$casenumber-1][4]
f - rotation on plane yz - NOT YET IMPLEMENTED. $$rotatez[$casenumber-1][5] 
g - swing for the rotation on the vertical plane - $$rotatez[$casenumber-1][6]
? - help
-   go to \"metamorphing\" page
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		quickchoose(
					 $$rotatez[ $casenumber - 1 ][0],
					 "rotate the zone on a vertical plane?(y/n)\n",
					 "rotationz",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "b" )
	{
		quickchoose(
					 $$rotatez[ $casenumber - 1 ][2],
					 "rotate the obstruction together with the zone? (y/n):\n",
					 "rotationz",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "c" )
	{
		multichoose(
			\@{ $$rotatez[ $casenumber - 1 ][1] },
"Please input the coordinates for the centre of the rotation (separated by commas):\n",
			"rotationz",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "d" )
	{
		quickchoose(
					 $$rotatez[ $casenumber - 1 ][3],
					 "Specify the angle for the rotation swing.?\n",
					 "rotationz",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "e" )
	{
		quickchoose(
			   $alreadyrotation = $$rotatez[ $casenumber - 1 ][4],
			   "rotation already had by the zone with respect to the x axis?\n",
			   "rotationz",
			   $var_number,
			   $casenumber
		);
	} elsif ( $mainchoice eq "f" )
	{
		quickchoose(
					 $rotatexy = $$rotatez[ $casenumber - 1 ][5],
					 "input the rotation on the vertical plane.\n",
					 "rotationz",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "g" )
	{
		quickchoose(
					 $rotatexy = $$rotatez[ $casenumber - 1 ][6],
					 "swing for the rotation on the vertical plane.\n",
					 "rotationz",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		rotationz();
	} elsif ( $mainchoice eq "\-" )
	{
		morphingloop();
	} else
	{
		rotationz();
	}
}

sub surface_translation
{
	my $var_number = $_[0];
	my $casenumber = $_[1];
	print "
______________________________________________________

OPTs - SURFACE TRANSLATION - variable: $var_number, iteration number: $casenumber
______________________________________________________

a - translate surfaces? Current: $$translate_surface[$casenumber-1][0]
b - surfaces to translate? Current: @{$translate_surface->[$casenumber-1][1]}
c - translation lenght? Current: @{$translate_surface->[$casenumber-1][2]}
d - update radiation data (y/n). Current: $$translate_surface[$casenumber-1][3]
? - help
-   go to \"metamorphing\" page
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		quickchoose(
					 $$translate_surface[ $casenumber - 1 ][0],
					 "Do you want to translate some surfaces? (y/n)\n",
					 "surface_translation",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "b" )
	{
		multichoose(
			\@{ $translate_surface->[ $casenumber - 1 ][1] },
"please specify the surfaces to translate, using the letters used in the esp-r dialog (separated by commas):\n",
			"surface_translation",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "c" )
	{
		multichoose(
			\@{ $translate_surface->[ $casenumber - 1 ][2] },
"please specify the lenght of the move of each traslation, keeping the order above (separated by commas):\n",
			"surface_translation",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "d" )
	{
		quickchoose(
					 $$translate_surface[ $casenumber - 1 ][3],
					 "Do you want to update the radiation data?\n",
					 "surface_translation",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		surface_translation();
	} elsif ( $mainchoice eq "\-" )
	{
		morphingloop();
	} else
	{
		surface_translation();
	}
}

sub vertex_translation
{
	my $var_number = $_[0];
	my $casenumber = $_[1];
	print "
______________________________________________________

OPTs - VERTEX TRANSLATION - variable: $var_number, iteration number: $casenumber
______________________________________________________

a - translate vertexes? Current: $$shift_vertexes[$casenumber -1][0]
b - vertexes to translate? Current: @{$$shift_vertexes[$casenumber -1][1]}
c - translation lenght? Current: @{$$shift_vertexes[$casenumber -1][2]}
d - update radiation data (y/n). Current: $$shift_vertexes[$casenumber -1][3]
? - help
-   go to \"metamorphing\" page
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		quickchoose(
					 $$shift_vertexes[ $casenumber - 1 ][0],
					 "Do you want to translate some vertexes? (y/n)\n",
					 "vertex_translation",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "b" )
	{
		multichoose(
			\@{ $$shift_vertexes[ $casenumber - 1 ][1] },
"please specify the vertexes to translate, using the letters used in the esp-r dialog (separated by commas):\n",
			"vertex_translation",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "c" )
	{
		multichoose(
			\@{ $$shift_vertexes[ $casenumber - 1 ][2] },
"please specify the lenght of the move of each traslation, keeping the order above (separated by commas):\n",
			"vertex_translation",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "d" )
	{
		quickchoose(
					 $$shift_vertexes[ $casenumber - 1 ][3],
					 "Do you want to update the radiation data?\n",
					 "vertex_translation",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		vertex_translation();
	} elsif ( $mainchoice eq "\-" )
	{
		morphingloop();
	} else
	{
		vertex_translation();
	}
}

sub construction_reassignment
{
	my $var_number = $_[0];
	my $casenumber = $_[1];
	print "
______________________________________________________

OPTs - CONSTRUCTION REASSIGNMENT - variable: $var_number, iteration number: $casenumber
______________________________________________________

a - reassign construction? Current: $$construction_reassignment[$casenumber -1][0]
b - surfaces to reassign? Current: @{$construction_reassignment->[$casenumber -1][1]}
c - constructions to be put in place of the previous. Current: @{$$shift_vertexes[$casenumber -1][2]}
? - help
-   go to \"metamorphing\" page
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		quickchoose(
					$$construction_reassignment[ $casenumber - 1 ][0],
					"Do you want to reassign some construction choice? (y/n)\n",
					"construction_reassignment",
					$var_number,
					$casenumber
		);
	} elsif ( $mainchoice eq "b" )
	{
		multichoose(
			\@{ $construction_reassignment->[ $casenumber - 1 ][1] },
"input the surfaces whose constructions have to change, using the letters used in the ESP-r zone dialog, separated by commas:\n",
			"construction_reassignment",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "c" )
	{
		multichoose(
			\@{ $$shift_vertexes[ $casenumber - 1 ][2] },
"input the constructions (separated by commas) to be put in place of the old ones, using the letters used in the ESP-r dialog for the construction database and keeping the order above:\n",
			"construction_reassignment",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		construction_reassignment();
	} elsif ( $mainchoice eq "\-" )
	{
		morphingloop();
	} else
	{
		construction_reassignment();
	}
}

sub thickness_change
{
	my $var_number  = $_[0];
	my $casenumber  = $_[1];
	my $stratagroup = $_[2];
	my $pairsgroup  = $_[3];
	my $test        = $_[4];
	my $stratagroupprovv =
	  Dumper( @{ $$thickness_change[ $casenumber - 1 ][2] } );
	if ( $test ne "following_calls" ) { $stratagroup = "$stratagroupprovv"; }
	my $pairsgroupprovv =
	  Dumper( @{ $$thickness_change[ $casenumber - 1 ][3] } );
	if ( $test ne "following_calls" ) { $pairsgroup = "$pairsgroupprovv"; }
	print "
______________________________________________________

OPTs - THICKNESS CHANGE - variable: $var_number, iteration number: $casenumber
______________________________________________________

a - change thickness of some strata? Current: $$thickness_change[$casenumber -1][0]
b - construction entries to be edited. Current: @{$$thickness_change[$casenumber -1][1]}
c - groups of strata to be edited for each entry. Current: $stratagroup
d - groups of pairs of min and max values. Current: $pairsgroup
? - help
-   go to \"metamorphing\" page
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;

	if ( $mainchoice eq "a" )
	{
		quickchoose(
					$$thickness_change[ $casenumber - 1 ][0],
					"Do you want to reassign some construction choice? (y/n)\n",
					"thickness_change",
					$var_number,
					$casenumber
		);
	} elsif ( $mainchoice eq "b" )
	{
		multichoose(
			\@{ $$thickness_change[ $casenumber - 1 ][1] },
"input the construction database entries that have to be edited, using the letters used in the ESP-r construction dialog, all separated by commas:\n",
			"thickness_change",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "c" )
	{
		print
"input the groups of strata to be changed, grouped with square bracket \"\[\]\" and all separated by commas, keeping the order above, and using the letters used in the ESP-r zone construction dialog, like in the following example: [[i, j], [a, b], [k] ]:\n";
		my $input = <>;
		chomp $input;
		print "you wrote $input. Are those values right? (y/n)\n";
		my $newinput = <>;
		chomp $newinput;
		if ( $newinput eq "y" )
		{
			thickness_change (
							   $var_number, $casenumber, $input, $pairsgroup,
							   "following_calls"
			);
		}
	} elsif ( $mainchoice eq "d" )
	{
		print
"input the groups of pairs of minimum and maximum values related with the groups above. Keep them too grouped with square bracket \"\[\]\" and separated by commas, following the order above,
and using the letters used in the ESP-r zone construction dialog. Each pair will be included in square bracket and each grop of pair will be included in square brackets, like in the following example: [[[10, 20] , [20, 50]], [[20, 60] , [10, 40]], [[20, 50 ]]]]:\n";
		my $input = <>;
		chomp $input;
		print "you wrote $input. Are those values right? (y/n)\n";
		my $newinput = <>;
		chomp $newinput;
		if ( $newinput eq "y" )
		{
			thickness_change (
							   $var_number, $casenumber, $stratagroup, $input,
							   "following_calls"
			);
		}
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		thickness_change();
	} elsif ( $mainchoice eq "\-" )
	{
		morphingloop();
	} else
	{
		&thickness_change;
	}
}

sub keep_obstructions_back ##THIS HAS TO BE REMADE TO BE SIMPLER AND NEATER: TAKING THE ESP-r CONFIGURATION FILES
{
	my $var_number         = $_[0];
	my $casenumber         = $_[1];
	my $obstructionsnumber = $_[2];
	my $obstructionsdata   = $_[3];
	my $obstructionsnumberprovv =
	  scalar( @{ $$keep_obstructions[ $casenumber - 1 ][1] } );
	if ( $obstructionsnumber eq "" )
	{
		$obstructionsnumber = "$obstructionsnumberprovv";
	}
	my $obstructionsdataprovv =
	  Dumper( @{ $$keep_obstructions[ $casenumber - 1 ][1] } );
	if ( $obstructionsdata eq "" )
	{
		$obstructionsdata = "$obstructionsdataprovv";
	}
	print "
______________________________________________________

OPTs - KEEP OBSTRUCTIONS - variable: $var_number, iteration number: $casenumber
______________________________________________________

a - keep some obstructions still(y/n)? Current: $$keep_obstructions[$casenumber -1][0]
b - number of obstructions to keep? Current: $obstructionsnumber
c - specify still obstruction data. Current: $obstructionsdata
d - update radiation data (y/n). Current: $$keep_obstructions[$casenumber -1][2]
? - help
-   go to \"metamorphing\" page
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		quickchoose(
			$$keep_obstructions[ $casenumber - 1 ][0],
"Do you want to keep some obstructions still while the others are moving? They have to be the firsts on the list (y/n)\n",
			"keep_obstructions_back",
			$var_number,
			$casenumber
		);
	} elsif ( $mainchoice eq "b" )
	{
		print "input the number of obstructions you want to keep still:\n";
		my $input = <>;
		chomp $input;
		keep_obstructions_back ( $var_number, $casenumber, $input,
								 $obstructionsdata );
	} elsif ( $mainchoice eq "c" )
	{
		print
"input the data relative to the obstructions you want to keep still, in groups of square brackets as in this example: [[\"e\", \"0\", \"0\", \"-7\", \"-20\", \"0\"],[\"f\", \"0\", \"90\", \"32\", \"-8\", \"0\"]]\n\n";
		my $input = <>;
		chomp $input;
		print "you wrote $input. Are those values right? (y/n)\n";
		my $newinput = <>;
		chomp $newinput;
		if ( $newinput eq "y" )
		{
			keep_obstructions_back ( $var_number, $casenumber,
									 $obstructionsnumber, $newinput );
		}
	} elsif ( $mainchoice eq "d" )
	{
		quickchoose(
					 $$keep_obstructions[ $casenumber - 1 ][2],
					 "Do you want to update the radiation data?\n",
					 "keep_obstructions_back",
					 $var_number,
					 $casenumber
		);
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		keep_obstructions_back();
	} elsif ( $mainchoice eq "\-" )
	{
		morphingloop();
	} else
	{
		keep_obstructions_back();
	}
}

sub simulationloop
{
	print "
______________________________________________________

OPTs - SIMULATION
______________________________________________________

a - simulation periods titles. Current: @simtitle
b - simulation periods. Current: @simdata
c - mass/flow network existence. Current:$simnetwork
? - help
-   quit
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		multichoose(
			\@simtitle,
"input the titles of the simulation period(s) to be set. They will be used in the reports. Example: jan01-dec31:\n",
			"simulationloop"
		);
	} elsif ( $mainchoice eq "b" )
	{
		multichoose(
			\@simdata,
"input the the simulation period(s) to be taken, one after the other separated by commas, specifying: \"starting-month_1 starting-day_1\", \"ending-month_1 ending-day_1\", \"start-up-period-duration_1\", \"time/steps-hour_1\". Example: \"01 1\", \"31 01\", \"20\", \"1\", \"01 07\", \"31 07\", \"20\", \"1\".\n",
			"simulationloop"
		);
	} elsif ( $mainchoice eq "c" )
	{
		quickchoose( $simnetwork, "is there is a mass/flow network? (y/n)\n",
					 "simulationloop" );
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		simulationloop();
	} elsif ( $mainchoice eq "\-" )
	{
		morphingloop();
	} else
	{
		simulationloop();
	}
}

sub ask_stratagroups   #IT HAS TO BE FIXED OR DELETED. IT IS UNUSED AS IS NOW.
{
	my @mygroups         = @{ $_[0] };
	my $number_of_groups = scalar(@mygroups);
	my $text             = $_[1];
	my $nextloop         = $_[2];
	my $var_number       = $_[3];
	my $casenumber       = $_[4];
	my @myconstructions  = @{ $_[5] };
	print
"how many strata do you want to change in the construction database? Currently: $number_of_groups\n";
	my $itemsnumber = <>;
	chomp $itemsnumber;

	if ( scalar(@mygroups) < $itemsnumber )
	{
		until ( scalar(@mygroups) == $itemsnumber )
		{
			push( @mygroups, [] );
		}
	} elsif ( scalar(@mygroups) > $itemsnumber )
	{
		until ( scalar(@mygroups) == $itemsnumber ) { pop(@mygroups); }
	}
	my $counter      = 0;
	my $counterplus1 = $counter++;
	until ( $counter < $itemsnumber )
	{
		print
"change number $counterplus1 of $itemsnumber: input the first of groups of strata to be changed (separated by commas). Use the letters used in the ESP-r zone construction dialog. Currently: @{$item}\n";
		my $response = <>;
		chomp $response;
		my @thisgroup = split( /,/, $response );
		@{ $$thickness_change[ $casenumber - 1 ][2][$counter] } = @thisgroup;
		print "@thisgroup\n";
		$counter++;
	}
	thickness_change();
}

sub resultsloop
{
	$tempdata = Dumper( @{ $reporttempsdata[0] } );
	print "
______________________________________________________

OPTs - RESULTS RETRIEVAL
______________________________________________________

a - results to be retrieved? Current: @retrievedata
b - do some results have to be ranked? Current: @rankdata
c - which periods do you want to report about? Current: @periods
d - column titles of the timeseries temperature to be retrieved. Current: @{$reporttempsdata[1]}
e - column titles of the comfort timeseries to be retrieved. Current: @{$reportcomfortdata->[1]}
f - column titles of the temps stats to be retrieved. Current: @{$reporttempsstats->[1]}
g - column number(s) to be filtered from the energy stats. Current: @{$reportloadsdata->[1]}
h - column number(s) to be filtered in the load stats report file. Current: @{$reportloadsdata->[2]}
i - column units in the load stats report file. Current: @{$reportloadsdata->[3]}
? - help
-   quit
";
	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		multichoose(
			\@retrievedata,
"say yes or no to the results retrieval that has to be made, in the following order, separated by commas: temperatures results, comfort results, loads results, tempstats results. Example: y, n, y, n. Current: @retrievedata\n",
			"resultsloop"
		);
	} elsif ( $mainchoice eq "b" )
	{
		multichoose(
			\@rankdata,
"say yes or no to the ranking of the data, following the order above, separating with commas.\n",
			"resultsloop"
		);
	} elsif ( $mainchoice eq "c" )
	{
		multichoose( \@periods,
			   "column titles of the timeseries temperature to be retrieved:\n",
			   "resultsloop" );
	} elsif ( $mainchoice eq "d" )
	{
		multichoose(
			\@{ $reporttempsdata[1] },
"input the column titles of the timeseries temperature to be retrieved:\n",
			"resultsloop"
		);
	} elsif ( $mainchoice eq "e" )
	{
		multichoose(
			\@{ $reportcomfortdata->[1] },
"input the column titles of the comfort timeseries to be retrieved:\n",
			"resultsloop"
		);
	} elsif ( $mainchoice eq "f" )
	{
		multichoose(
			\@{ $reporttempsstats->[1] },
"column titles of the temps stats to be retrieved. Current: @{$reporttempsstats->[1]}\n",
			"resultsloop"
		);
	} elsif ( $mainchoice eq "g" )
	{
		multichoose(
			\@{ $reportloadsdata->[1] },
"input the column number(s) to be filtered from the energy stats. @{$reporttempsstats->[2]}\n",
			"resultsloop"
		);
	} elsif ( $mainchoice eq "h" )
	{
		multichoose(
			\@{ $reportloadsdata->[2] },
"input the number of columns that will be filtered in the report file. Current: @{$reporttempsstats->[3]}\n",
			"resultsloop"
		);
	} elsif ( $mainchoice eq "i" )
	{
		multichoose(
			\@{ $reportloadsdata->[3] },
"specify the column units in the load stats report file. Current: @{$reporttempsstats->[3]}\n",
			"resultsloop"
		);
	} elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		resultsloop();
	} elsif ( $mainchoice eq "\-" )
	{
		morphingloop();
	} else
	{
		resultsloop();
	}
}

sub filteringloop
{
	$varnumbersprint = Dumper(@varnumbers);
	$filter_reports_print = Dumper(@filter_reports);
	$varthemes_report_print = Dumper(@varthemes_report);
	$varthemes_variations_print = Dumper(@varthemes_variations);
$filtered_files_nums = scalar(@filter_reports);
	if ( scalar(@filter_reports) < $filtered_files_numbers )
		{
			until ( scalar(@filter_reports) == $filtered_files_numbers )
			{
				push( @filter_reports, [[""], [""], [""]] );
			}
		}
	elsif (  scalar(@filter_reports) > $filtered_files_numbers )
	{
		until ( scalar(@filter_reports) == $filtered_files_numbers )
		{
			pop(@filter_reports);
		}
	}
	print "
______________________________________________________

OPTs - REPORT FILTERING   variables sequence: $varnumbersprint
______________________________________________________

a - files to filter? Current: @files_to_filter
b - set the number of filtered files. Current: $filtered_files_nums
c - go to filtering strategies ->
d - files to convert? @files_to_convert
e - set the names to be given to the variables. Current: @varthemes_report
f - choose the variable you are setting. Current: $hold
g - set max and min values to be given to the variable above. Current: @{$varthemes_variations[$hold-1]}
Current max and min values: $varthemes_variations_print
h - set the number of steps for each variable. Current: @varthemes_steps
i - set the general contents of the reports. Current: @themereports 
? - help
-   go to main page
";

	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		multichoose(
			\@files_to_filter,
"Please input the files names to be filtered, separated bt commas. (If nothing is specified, the names will be given by default):\n",
			"filteringloop"
		);
	} elsif ( $mainchoice eq "b" )
	{
		quickchoose(
			$filtered_files_numbers,
			"Please input the number of filtered files you want to generate from each report file:\n",
			"filteringloop"
		);
	} elsif ( $mainchoice eq "c" )
	{
		filteringstrategies($filtered_files_numbers);
	} 
	elsif ( $mainchoice eq "d" )
	{
		multichoose(
			\@files_to_convert,
			"Please input the files that have to be refined starting from the filtered ones. (If nothing is specified, the names will be given by default):\n",
			"filteringloop"
		);
	}
	elsif ( $mainchoice eq "e" )
	{
		multichoose(
			\@varthemes_report,
			"Please input the names that will be given to the variables, in substitution of the numbers of the variables sequence (separated by commas):\n",
			"filteringloop"
		);
	}
	elsif ( $mainchoice eq "f" )
	{
		quickchoose(
			$hold,
			"Please input the variable to be worked on now, by number (see variables sequence):\n",
			"filteringloop"
		);
	}
	elsif ( $mainchoice eq "g" )
	{
		multichoose(
			\@{$varthemes_variations[$hold]},
			"Please input the max and min values to be given to the variable @{$varthemes_variations[$hold]} (see above):\n",
			"filteringloop"
		);
	}
	elsif ( $mainchoice eq "h" )
	{
		multichoose(
			\@varthemes_steps,
			"Please input the number of steps to be reported for each variable (in the order of the variables sequence):\n",
			"filteringloop"
		);
	}
	elsif ( $mainchoice eq "i" )
	{
		multichoose(
			\@themereports,
			"Please input the general theme of the reports (Currently: \"loads\" or \"temperatures\":\n",
			"filteringloop"
		);
	}
	elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		print filteringloop();
	} elsif ( $mainchoice eq "\-" )
		{
		mainloop();
	}
	else{filteringloop();}
}

sub filteringstrategies
{
	#$filtered_files_numbers = $_[0];
	if ( scalar(@filter_reports) < $filtered_files_numbers )
		{
			until ( scalar(@filter_reports) == $filtered_files_numbers )
			{
				push( @filter_reports, [""] );
			}
		}
	elsif (  scalar(@filter_reports) > $filtered_files_numbers )
	{
		until ( scalar(@filter_reports) == $filtered_files_numbers )
		{
			pop(@filter_reports);
		}
	}
	print "
______________________________________________________

OPTs - FILTERING STRATEGIES  variables sequence: $varnumbersprint
______________________________________________________

a - number of files to be generated. Current: $filtered_files_numbers
b - set the file number you are working on now. Current: $filenumber
c - Regarding file $filenumber: variables to be analised. Current: @{$filter_reports[$filenumber][0]}
d - Regarding file $filenumber: variables to be kept still. Current: @{$filter_reports[$filenumber][1]}
e - Regarding file $filenumber: number of step to which the fixed variables have be hold. Current: @{$filter_reports[$filenumber][2]}
? - help
-   return to filtering page
";

	my $mainchoice = <STDIN>;
	chomp $mainchoice;
	if ( $mainchoice eq "a" )
	{
		quickchoose(
			$filtered_files_numbers,
"Please input the number of filterd files to be generated:\n",
			"filteringstrategies"
		);
	} elsif ( $mainchoice eq "b" )
	{
		quickchoose(
			$filenumber,
			"Please input the number of filtered files you want to generate from each report file:\n",
			"filteringstrategies"
		);
	} elsif ( $mainchoice eq "c" )
	{
		multichoose(
		\@{$filter_reports[$filenumber][0]}),
		"Please input the variables numbers to be analised, separated by commas:\n",
		"filteringstrategies"
	} 
	elsif ( $mainchoice eq "d" )
	{
		multichoose(
		\@{$filter_reports[$filenumber][1]}).
		"Please input the variables numbers to be kept fixed in the files, separated by commas:\n",
		"filteringstrategies"
	}
	elsif ( $mainchoice eq "e" )
	{
		multichoose(
		\@{$filter_reports[$filenumber][2]}),
		"Please input the step number at which the still variables have to be kept still, in the same order above:\n",
		"filteringstrategies"
	} 
	elsif ( $mainchoice eq "\?" )
	{
		print "\n\nSorry, there is no help page yet about this topic.\n";
		filteringstrategies();
	} elsif ( $mainchoice eq "\-" )
	{
		filteringloop();
	}
	else {filteringstrategies();}
}

sub choose
{
	my $theme      = $_[0];
	my $text       = $_[1];
	my $nextloop   = $_[2];
	my $var_number = $_[3];
	my $casenumber = $_[4];
	print "$text";
	my $inputtext = <STDIN>;
	chomp $inputtext;
	if ( $inputtext eq "y" ) { gotoloop($nextloop) }
	else
	{
		( $_[0] = $inputtext )
		and ( $presentloop = $nextloop )
		and gotoloop( $nextloop, $var_number, $casenumber );
	}
}

sub longchoose
{
	my $theme      = $_[0];
	my $text       = $_[1];
	my $nextloop   = $_[2];
	my $var_number = $_[3];
	my $casenumber = $_[4];
	print "$text";
	my $inputtext = <STDIN>;
	chomp $inputtext;
	if ( $inputtext eq "y" ) { gotoloop($nextloop) }
	else
	{
		( $_[0] = $inputtext )
		and ( $presentloop = $nextloop )
		and gotoloop( $nextloop, $var_number, $casenumber );
	}
}



sub multichoose
{
	my @theme      = @{ $_[0] };
	my $text       = $_[1];
	my $nextloop   = $_[2];
	my $var_number = $_[3];
	my $casenumber = $_[4];
	print "$text";
	my $inputtext = <STDIN>;
	chomp $inputtext;
	if ( $inputtext eq "y" ) { gotoloop($nextloop) }
	else
	{
		@items = split( /,/, $inputtext ); 
		@items = split( / /, $inputtext );
	  	( @{ $_[0] } = @items )
		and ( $presentloop = $nextloop )
		and gotoloop( $nextloop, $var_number, $casenumber );
	}
}

sub quickchoose
{
	my $theme      = $_[0];
	my $text       = $_[1];
	my $nextloop   = $_[2];
	my $var_number = $_[3];
	my $casenumber = $_[4];
	print "$text";
	my $inputtext = <STDIN>;
	chomp $inputtext;
	( $_[0] = $inputtext )
	  and gotoloop( $nextloop, $var_number, $casenumber, $inputtext );
}

sub obstructionloop() { morphingloop(); }

sub opt
{
	my $theme                = $_[0];
	my $text                 = $_[1];
	my $nextloop             = $_[2];
	my $var_number           = $_[3];
	my $casenumber           = $_[4];
	my $nextloop_alternative = $_[5];
	print "$text";
	my $inputtext = <STDIN>;
	chomp $inputtext;

	if ( $inputtext eq "y" )
	{
		( $_[0] = $inputtext )
		  and gotoloop( $nextloop, $var_number, $casenumber );
	} else
	{
		gotoloop( $nextloop_alternative, $var_number, $casenumber );
	}
}

sub gotoloop
{
	my $frame      = $_[0];
	my $var_number = $_[1];
	my $casenumber = $_[2];
	if    ( $frame eq "mainloop" )               { mainloop(); }
	elsif ( $frame eq "operationsloop" )         { operationsloop(); }
	elsif ( $frame eq "morphingloop" )           { morphingloop(); }
	elsif ( $frame eq "simulationloop" )         { simulationloop(); }
	elsif ( $frame eq "resultsloop" )            { resultsloop(); }
	elsif ( $frame eq "filteringstrategies" )    { filteringstrategies(); }
	elsif ( $frame eq "filteringloop" )          { filteringloop(); }
	elsif ( $frame eq "keep_obstructions_back" ) { keep_obstructions_back(); }
	elsif ( $frame eq "translation" )            { translation(); }
	elsif ( $frame eq "rotation" )               { rotation(); }
	elsif ( $frame eq "rotationz" )              { rotationz(); }
	elsif ( $frame eq "surface_translation" )    { surface_translation(); }
	elsif ( $frame eq "vertex_translation" )     { vertex_translation(); }
	elsif ( $frame eq "thickness_change" )       { thickness_change(); }
	elsif ( $frame eq "launch" )       			{ launch(); }
	elsif ( $frame eq "simpletestsloop" ) { simpletestsloop(); }
	elsif ( $frame eq "testcollectorloop" ) { testcollectorloop(); }
	#elsif ( $frame eq "newloop" ) { newloop(); }
	elsif ( $frame eq "construction_reassignment" )
	{
		construction_reassignment();
	} elsif ( $frame eq "simulationloop" )
	{
		simulationloop();
	}
}

sub launch
{
	`.\run.opt`;	
}

sub savefile
{
	my $outfile = $_[0];
	open( OUTFILE, ">$outfile" ) or die "Can't open $outfile\: $!\n";
	print OUTFILE "\$file = \"$file\";	# Write here the root model directory.  This will remain unchanged. THIS NOW IS DONE VIA KEYBOARD THROUGH THE EXECUTABLE.
\$filenew = \"$file\"\.\"_\"; 		# Write here the work model directory.  The program will copy the root model directory into this one.  Afterwards changes may be made to it.
\@dowhat = ("; foreach my $thing (@dowhat) { print OUTFILE "\"$thing\", "}; print OUTFILE ");		# This variables tell to the program what to do.  1) Create cases for simulation; 2) simulate; 3) retrieve data; 4) report; 5) merge reports; 6) rank reports; 7) filter reports
\$mypath = \"$mypath\"; 	# Write here the path of the directory in which the OPT executable is.
\$fileconfig = \"$fileconfig\"; 	# Write here the name of the configuration file of you model
\@varnumbers = ("; foreach my $thing (@varnumbers) { print OUTFILE "$thing, "}; 	print OUTFILE ");  # (8, 9, 10, 1, 2, 3, 4, 5, 6, 7)\;  THESE ARE DATA OF THE GREATEST IMPORTANCE
\@varthemes_report = ("; foreach my $thing (@varthemes_report) { print OUTFILE "$thing, "}; 	print OUTFILE "); # Definitions of the variables that are going to substitute the variables' numbers in the tables
\@varthemes_variations = ("; foreach my $thing (@varthemes_variations) { print OUTFILE "[ "; foreach my $thingy (@{$thing}) {print OUTFILE "\"$thingy\", "; } print OUTFILE "]"; }; print OUTFILE "); #Maximum and minumum values regarding the variables, in the same order above.
\@varthemes_steps = ("; foreach my $thing (@varthemes_steps) { print OUTFILE "$thing, "}; 	print OUTFILE "); # The number of steps allowed for each variables. In the same order above.
\@themereports = ("; foreach my $thing (@varthemes_steps) { print OUTFILE "$thing, "}; 	print OUTFILE ");  General themes regarding the simulation.  This piece of information go to compose the result name files.
\@simtitle = ("; foreach my $thing (@simtitle) { print OUTFILE "\"$thing\", "}; 	print OUTFILE ");  # write here the name of the time periods will be taken into account in the simulations.
\@periods = ("; foreach my $thing (@periods) { print OUTFILE "\"$thing\", "}; print OUTFILE "); # write here the name of the time periods will be taken into account in the reports.
\@simdata = ("; foreach my $thing (@simdata) { print OUTFILE "\"$thing\", "}; print OUTFILE "); # Here put the data this way: \"starting-month_1 starting-day_1\", \"ending-month_1 ending-day_1\", \"start-up-period-duration_1\", \"time/steps-hour_1\", \"starting-month_2 starting-day_2\", \"ending-month_2 ending-day_2\", \"start-up-period-duration_2\", \"time/steps-hour_2\", ..., \"starting-month_n starting-day_n\", \"ending-month_n ending-day_n\", \"start-up-period-duration_n\", \"time/steps-hour_n\"
\$simnetwork = \"$simnetwork\"; # \"n\" is there is no mass\/flow network. This information regards the simulation settings.
\@retrievedata = ("; foreach my $thing (@retrievedata) { print OUTFILE "\"$thing\", "}; print OUTFILE "); # retrieve_temperatures_results, retrieve_comfort_results, retrieve_loads_results, retrieve tempstats results
\@rankdata = ("; foreach my $thing (@rankdata) { print OUTFILE "\"$thing\", "}; print OUTFILE "); # THIS DATA ARE POINT-TO- POINT RELATIVE TO THE ARRAY ABOVE AND TELL WHAT FIELD THE RANKING HAS TO BE BASED ON 
\@reporttempsdata = ("; foreach my $thing (@reporttempsdata) { print OUTFILE "[ "; foreach my $thingy (@{$thing}) {print OUTFILE "\"$thingy\", "; } print OUTFILE "]"; }; print OUTFILE "); # This is for temperatures.  [\$simtitle[0] refers to the first \@simtitle, [\$simtitle[1] refers to the second \@simtitle.  If you have more or less \$simtitle(s), you'll have to add or subtract them to this line.  In the last set of square parentheses (\"[]\") the names of the columns in the report files have to be specified. In the following fields, the units that will be plot on the the reference x y axes have to be specified.
\@reportcomfortdata = ("; foreach my $thing (@reportcomfortdata) { print OUTFILE "[ "; foreach my $thingy (@{$thing}) {print OUTFILE "\"$thingy\", "; } print OUTFILE "]"; }; print OUTFILE "); # This is for comfort.  Here in the last set of square parentheses (\"[]\") the names of the columns in the report files have to be specified.
\@filter_reports = ("; foreach my $thing (@filter_reports) { print OUTFILE "[ "; foreach my $thingy (@{$thing}) {print OUTFILE "\"$thingy\", "; } print OUTFILE "]"; }; print OUTFILE "); # varnumbers to report, varnumbers not to report, casenumber to report among varnumbers not to report
\@files_to_filter = ("; foreach my $thing (@files_to_filter) { print OUTFILE "$thing, "}; 	print OUTFILE "); # files names to be filtered. You may leave it blank if you want default values.
\@files_to_convert = ("; foreach my $thing (@files_to_convert) { print OUTFILE "$thing, "}; 	print OUTFILE "); ########## files names to be filtered. You may leave it blank if you want defaults.
\@reportloadsdata = ("; foreach my $thing (@reportloadsdata) { print OUTFILE "[ "; foreach my $thingy (@{$thing}) {print OUTFILE "\"$thingy\", "; } print OUTFILE "]"; }; print OUTFILE "); # This is for loads.  Here in the last set of square parentheses (\"[]\") the number of columns that will be filtered in the report file have to be speciied.
\@reporttempsstats = ("; foreach my $thing (@reporttempsstats) { print OUTFILE "[ "; foreach my $thingy (@{$thing}) {print OUTFILE "\"$thingy\", "; } print OUTFILE "]"; }; print OUTFILE "); # This is for temperatures statistics. Put the zones' number in this array.\n";
# print OUTFILE "\$filterfield = $filterfield; #column that will be filtered in the report file. UNUSED
#\@filterunitslenghts = @filterunitslenghts; \@filterunitsvalues = (\\@{\$reportloadsdata->[3]}, \\@{\$reportloadsdata->[4]}); #units that will be plot on the the reference x y axes. TO ADD: \@filterunits = (1, 2);"\n
print OUTFILE "\$counterstep = 1;\n";
	foreach $var_number (@varnumbers)
	{ 
		print OUTFILE "
\$stepsvar";
		print OUTFILE
"$var_number = $stepsvar; # \$stepsvar(n) = numer_of_steps_for_this_variable.  This must always be an odd number since one number is the central one, the default one supplied;
\@applytype";
		print OUTFILE			
"$var_number = ("; foreach my $thing (@applytype) { print OUTFILE "[ "; foreach my $thingy (@{$thing}) {print OUTFILE "\"$thingy\", "; } print OUTFILE "], "; }; print OUTFILE "); #  \@applytype(n) = ([\"type_of_change\", \"your_test_file\", \"file_name_to_which_the_former_will_be_copied_to\", \"zone_letter\"]), ES: \@applytype1 = ([\"generic_change\", \"zona1.geo\", \"zona1.geo\", \"a\"]).  The possibilities regarding changes are: \"generic_change\", \"surface_translation\", \"vertexes_shift\", \"construction_reassignment\", \"rotation\", \"translation\",  \"thickness_change\",  \"climate_change\".
\$translate";
		my $printtranslate = Dumper($translate);			
		print OUTFILE
"$var_number = $printtranslate; # yes_or_no_translate # $yes_or_no_translate_obstructions # give the coordinates for one extreme of the swing.  The other one will be simmetrical along the line. # update radiation calculation with the ish module?  y for yes and n for no, continue.
\$rotate";
		my $printrotate = Dumper($rotate);
		print OUTFILE
"$var_number = $printrotate; # yes or no rotate, # $yes_or_no_rotate_obstruction: 	y or n, # swingrotate, # update radiation calculation with the ish module?  y for yes and n for no, continue.
\$rotatez";
my $printrotatez = Dumper($rotatez);
		print OUTFILE
"$var_number = $printrotatez; # THIS ROUTINE KEEPS THE OBSTRUCTIONS STILL AND ROTATE THE ZONE(S) ON THE ALTITUDE ANGLE.  IT DOES NOT PASS THROUGH ESP-R.  IT JUST MANAGES THE .GEO CONFIGURATION FILE., # x, y (or x) and z of the point that is the center of the axis rotation, #plane of rotation: x or y, #swingrotation of plane xy, #rotation already had by the zone with respect to the x axis, #rotation on plane yz - TO DO, #swing for the rotation on plane xy - TO DO.
\$translate_surface";
my $printtranslate_surface = Dumper($translate_surface);
		print OUTFILE
"$var_number = $printtranslate_surface; # FOR EACH MOVEMENT: # \$yes_or_no_transl_surfs, # \@surfs_to_transl2, # \@ends_movs2, # \$yes_or_no radiation update.
\$shift_vertexes";
my $printshift_vertexes = Dumper($shift_vertexes);
		print OUTFILE
"$var_number = $printshift_vertexes; # \$yes_or_no_shift_surface. y or n.  it turns on and off the related function. # FOR EACH MOVEMENT: # \@pairs_of vertexes defining axes, # \$shift_movements, # \$yes_or_no radiation update.
\$construction_reassignment";
my $printconstruction_reassignment = Dumper($construction_reassignment);
		print OUTFILE
"$var_number = $printconstruction_reassignment; # \$yes_or_no_modify_construction, # \@surfaces_to_reassign, \@constructions_to_choose (letter combination, here!!)
\$thickness_change";
		print OUTFILE
		my $printthickness_change = Dumper($thickness_change);
"$var_number = $printthickness_change; # $yes_or_no_change_thickness, # @entries_to_change: construction database entries to change, # @groups_of_strata_to_change, containing @strata_to_change: strata to change for each entry. There is a correspondence with the above. # @groups_of_pairs_of_min_max_values, containing @min_max_values: min and max values for each change above.  There is a two to one correnspondence of the values below with the above.
\$keep_obstructions";
		print OUTFILE
		my $printkeep_obstructions = Dumper($keep_obstructions);
"$var_number = $printkeep_obstructions; # $yes_or_no_keep_some_obstructions, # ostructions array, # y for yes or n for no update radiation calculation via ish
\$general_variables";
		print OUTFILE
		my $printgeneral_variables = Dumper($general_variables);
"$var_number = $printgeneral_variables; # $generate(n) eq n # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models). #if $sequencer eq y, or last (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, n.\n
\n";
	}
	close OUTFILE;
	mainloop();
}

mainloop(); 
}

# END OF THE CONTENT OF THE "opts_prepare.pl" FILE.
##############################################################################
##############################################################################
##############################################################################







if ( $dowhat[0] eq "y" ) 
{ 
	unless (-e $to) 
	{ &morph(); } 
}

if ( $dowhat[1] eq "y" ) 
{ 
	&sim( $to, $mypath, $file, $filenew, \@dowhat, \@simdata, $simnetwork,
	\@simtitle, $preventsim, $exeonfiles, $fileconfig, \@themereports, 
	\@reportperiods, \@retrievedata, \@retrievedatatemps, 
	\@retrievedatacomfort, \@retrievedataloads, \@retrievedatatempsstats );
}

if ( $dowhat[4] eq "y" ) 
{ &report; }

if ( $dowhat[5] eq "y" )
{ &merge_reports; }

if ( $dowhat[6] eq "y" )
{
	&convert_report(); # CONVERT NOT YET FILTERED REPORTS
}
if ( $dowhat[7] eq "y" )
{
	&filter_reports(); # FILTER ALREADY CONVERTED REPORTS
}
if ( $dowhat[8] eq "y" )
{
	&convert_filtered_reports(); # CONVERT ALREADY FILTERED REPORTS
}
if ( $dowhat[9] eq "y" )
{
	&maketable(); # CONVERT TO TABLE ALREADY FILTERED REPORTS
}

close(OUTFILE);
close(TOSHELL);
exit;

} 

1;
__END__

=head1 NAME

Sim::OPTS manages parametric esplorations through the use of the ESP-r building performance simulation platform

=head1 SYNOPSIS

  use Sim::OPTS;
  Sim::OPTS::opts;

=head1 DESCRIPTION

OPTS is a program conceived to manage parametric explorations through the use of the ESP-r building performance simulation platform. 
(Information about ESP-r is available at the web address http://www.esru.strath.ac.uk/Programs/ESP-r.htm.) Parametric explorations are usually performed to solve design optimization problems.

OPTS may modify directories and files in your work directory. So it is necessary to examine how it works before attempting to use it.

To install OPTS it is necessary to issue the following command in the shell as a superuser: < cpanm Sim::OPTS >. This way Perl will take care to install all necessary dependencies. After loading the module, which is made possible by the commands < use Sim::OPTS >, only the command "Sim::OPTS::opts" will be available to the user. That command will activate the OPTS functions following the setting specified in a previously prepared OPTS configuration file.

The command "Sim::OPTS::prepare" would be also present in the capability of the code (file "opts_prepare.pl"), but it is not possible to use it, because it has not been updated to the last several versions of OPTS, so it is no more usable at the moment. "optslaunch" would open a text interface made to facilitate the preparation of OPTS configuration files. Due to this, currently the OPTS configuration files can only be prepared by example.

When it is launched, OPTS will ask for the name of an OPTS configuration file. On that file the instructions for the program will have to be written by the user before launching OPTS. All the activity of preparation to run OPTS will happen in an OPTS configuration file, which has to be applied to an existing ESP-r model.

In the module distribution, there is a template file with explanations and an example of an OPTS configuration file. The template file should be intended as a part of the present documentation. 

To run OPTS without having it act on files, you should specify the setting < $exeonfiles = "n"; > in the OPTS configuration file. Then you should specify a path for the  text file that will receive the commands in place of the shell, by setting < $outfilefeedbacktoshell = address_the_text_file >. It is a good idea to always send the OPTS commands to a file also when they are prompted to the shell, to be able to trace what has been done to the model files.

The OPTS configuration file will make, if asked, OPTS give instruction to ESP-r in order to make it modify a model in several different copies; then, if asked, it will run simulations; then, if asked, it will retrieve the results; then, if asked, it will extract some results and order them in a required manner; then, if asked, will format the so obtained results. Those functions are performed by the subroutines contained in "OPTS.pm", which previously were written in the following separate files: "opts_morph.pl", "opts_sim.pl", "opts_report.pl", "opts_format.pl", "opts_prepare.pl". It should be noted that some functions in "opts_report.pl" and especially in "opts_format.pl" and "opts_prepare.pl" have been used only once and have not been maintained since then. My attention has indeed been mostly directed to the "OPTS.pm" and "opts_morph.pl" files. I have presently gathered all the parts of the program in one large file as a quick solutions to avoid problems during the install process.

To run OPTS, you may open Perl in a repl. As a repl, you may use the Devel::Repl module. It is going to be installed when OPTS is installed. To launch it, the command < re.pl > has to be given to the shell. Then you may load the Sim:OPTS module from there (< use Sim:OPTS >). Then you should issue the command < Sim::OPTS::opts > from there. When launched, OPTS will ask you to write the name (with path) of the OPTS configuration file to be considered. After that, the activity of OPTS will start and will not stop until completion.

OPTS will make ESP-r perform actions on a certain ESP-r model by copying it several times and morphing each copy. A target ESP-r model must also therefore be present in advance and its name (with path) has to be specified in the OPTS configuration file. The OPTS configuration file will also contain information about your work directory. I usually make OPTS work in a "optsworks" folder in my home folder.

Besides OPTS configuration files, also configuration files for propagation of constraints may be specified. I usually put them into a directory in the model folder named "opts".

The model folders and the result files that will be created through ESP-r will be named as your root model, followed by a "_" character,  followed by a variable number referred to the first morphing phase, followed by a "-" character, followed by an iteration number for the variable in question, and so on for all morphing phases. For example, the model instance produced in the first iteration for a model named "model" in a search constituted by 3 morphing phases and 5 iteration steps each may be named "model_1-1_2-1_3-1"; and the last one may be named "model_1-5_2-5_3-5".
The "_" characters tells OPTS to generate new cases. The character "£" will be used when two parametric variations must be joined before generating new cases, and the character "§" will stop both the joining and the generation for the given branch.

The propagation of constraints on which some OPTS operations on models may be based can regard the geometry of the model, solar shadings, mass/flow network, and/or controls, and how they affect each other and daylighting (as calculated throuch the Radiance lighting simulation program). To study what propagation on constraint can do for the program, the template file included in the OPTS Perl module distribution should be studied.

OPTS presently only works for UNIX and UNIX-like systems. There would be lots of functionality to add to it and bugs to correct. 

OPTS is a program I have written for my personal use as a side project since 2008, when I was beginning to learn programming. Due to that fact, the core parts of it, when they have not been rewritten, are among the ones that are coded in the strangest manner. As you may realize by looking at the code, I am not a professional programmer and do several things in a non-standard way. In particular, I like the rather deprecated symbolic references, because I think they can simplify my coding. 
The only part of OPTS I wrote for work is that in the file "opts_prepare.pl", which was needed to include the use of the tool in an institutional research I was carrying on in 2011-2012.

=head2 EXPORT

"opts".


=head1 SEE ALSO

The available documentation is mostly collected in the readme.txt file. An example of ESP-r model inclusive an "opts" folder contanining files of instruction for propagation of constraints in OPTS are uploaded in my personal page at the Politecnico di Milano (www.polimi.it). Its web address may vary, so I don't list it here.
For inquiries: gianluca.brunetti@polimi.it.

=head1 AUTHOR

Gian Luca Brunetti, E<lt>gianluca.brunetti@polimi.itE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008-2014 by Gian Luca Brunetti and Politecnico di Milano. This is free software.  You can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 2 or later.


=cut
