package Sim::OPTS;
# Copyright (C) 2008-2014 by Gian Luca Brunetti and Politecnico di Milano.
# This is OPTS, a program conceived to manage parametric esplorations through the use of the ESP-r building performance simulation platform.
# This is free software.  You can redistribute it and/or modify it under the terms of the GNU General Public License 
# as published by the Free Software Foundation, version 2.


use 5.014002;
use Exporter; # require Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
use Devel::REPL;
no strict; # use strict;
use warnings; # use warnings;
@ISA = qw(Exporter); # our @ISA = qw(Exporter);


# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use opts ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.

%EXPORT_TAGS = ( DEFAULT => [qw(&opts &optslaunch)]); # our %EXPORT_TAGS = ( 'all' => [ qw( ) ] );
@EXPORT_OK   = qw(); # our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
@EXPORT = qw(); # our @EXPORT = qw( );
$VERSION = '0.05'; # our $VERSION = '0.05';

# eval `cat ../../scripts/opts_launch.pl`; # HERE IS THE FUNCTION "launch", a text interface to the function "opts".
# require "../../scripts/opts_launch.pl"; # HERE IS THE FUNCTION "launch", a text interface to the function "opts".

sub opts { # UNCOMMENT HERE AND AT THE END IF THIS PROGRAM IS A MODULE.
print "THIS IS OPTS.
Copyright by Politecnico di Milano and Gian Luca Brunetti, 2008-13.
Author: Gian Luca Brunetti - gianluca.brunetti\@polimi.it
Dipartimento DAStU, Politecnico di Milano.
Copyright license: Creative Commons Attribution-NoDerivs (CC BY-ND).
-------------------

To use OPTS an OPTS configuration file in should have been prepared
in which a target ESP-r model is specified.
This OPTS version is for UNIX systems.
Please insert the name of a configuration file (local path):\n";
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

# eval `cat ../../scripts/opts_morph.pl`; # HERE THERE ARE THE FUNCTION CALLED FROM
require "../../scripts/opts_morph.pl"; # HERE THERE ARE THE FUNCTION CALLED FROM
# THE MAIN FUNCTION, "morph", FROM THIS FILE (MAIN).
# eval `cat ../../scripts/opts_sim.pl`; # HERE THERE IS THE FUNCTION "sim" CALLED
require "../../scripts/opts_sim.pl"; # HERE THERE IS THE FUNCTION "sim" CALLED
# FROM THIS FILE (MAIN).
# eval `cat ../../scripts/opts_report.pl`; # NOT USED YET. FOR NOW THIS FILE IS
require "../../scripts/opts_report.pl"; # NOT USED YET. FOR NOW THIS FILE IS
# STILL CALLED BY EVAL IN THE ENVIRONMENT WHERE THE CALL HAPPENS, WITHOUT
# PARAMETERS (SEE BELOW).
# eval `cat ../../scripts/opts_format.pl`; # # NOT USED YET. FOR NOW THIS FILE IS
require "../../scripts/opts_format.pl"; # # NOT USED YET. FOR NOW THIS FILE IS
# STILL CALLED BY EVAL IN THE ENVIRONMENT WHERE THE CALL HAPPENS, WITHOUT
# PARAMETERS (SEE BELOW).
# use strict; # THIS CAN'T BE DONE SINCE THE PROGRAM USES SYMBOLIC REFERENCES
# and "eval" with other files.
# use warnings; # THIS CAN'T BE DONE SINCE THE PROGRAM USES HARD REFERENCES 
# and "eval" with other files.

if ($exeonfiles == undef) { $exeonfiles = "y";} # SO EVEN IF THE CONFIGFILE
# IS OF AN OLD TYPE THE PROGRAM WON'T STOP.
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

open( OUTFILE, ">$outfile" ) or die "Can't open $outfile: $!";
#if ($toshell != null) 
{ open( TOSHELL, 
">$toshell" ) or die 
"Can't open $toshell: $!" };

unless ( $optsworks eq "" ) 
{ 
	unless (-e "$mypath/$optsworks")
	{
		if ($exeonfiles eq "y") { print `mkdir $mypath/$optsworks`;
		print `chmod 777 $mypath/$optsworks`; }
		print TOSHELL "mkdir $mypath/$optsworks\n\n";
		print TOSHELL "chmod 777 $mypath/$optsworks\n\n"; 
	}
	if ($exeonfiles eq "y") 
	{ 
		print `mkdir $mypath/$optsworks/$file`; 
		print `chmod 777 $mypath/$optsworks/$file`; 
	}
	print TOSHELL "mkdir $mypath/$optsworks/$file\n\n"; 
	print TOSHELL "chmod 777 $mypath/$optsworks/$file\n\n"; 
	if ($exeonfiles eq "y") { print `cp -r $mypath/$file $mypath/$optsworks/$file/$file`; }
	print TOSHELL "cp -r $mypath/$file $mypath/$optsworks/$file/$file\n\n";
		
	$mypath = "$mypath" . "/$optsworks/$file";
	
}

eval `cat ./opts_report_functions.pl`; # HERE THERE ARE THE FUNCTION "report"
# AND "merge" CALLED FROM THIS FILE (MAIN). 
# HERE "require" SHOULD HAVE BEEN USE FOR SAFETY, BUT FOR IT THE FUNCTION CALLS
# ARE NOT MADE LEXICALLY NOT DYNAMICALLY. THEREFORE, THAT THE FUNCTIONS
# WERE DEFINED INSIDE THE MAIN ENVIRONMENT WAS NECESSARY. THEREFORE, "eval" WAS
# HERE USED INSTEAD OF "require". THIS IS DETRIMENTAL FOR MODULARITY  
# AND has to BE FIXED, BUT IS NOT DETRIMENTAL FOR FUNCTIONALITY.

eval `cat ./opts_format_functions.pl`; # HERE THERE ARE RATHER UMNANTAINED 
#FUNCTIONS CALLED FROM THIS FILE (MAIN) FOR RANKING AND FORMATTING REPORTS.
# SEE THE COMMENT ABOVE about THE "eval".

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
		if ( $countervar == 1 ) 
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
			@apply_constraints = @{ "apply_constraints" . "$countervar" }; # IS TO BE SUPERSEDED BY @constrain_geometry
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
		} 
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
						{	# THIS CONTAINS FUNCTIONS THAT APPLIES CONSTRAINTS AND UPDATE CALCULATIONS.							
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
								$counterstep, $exeonfiles, \@applytype, \@propagate_constraints); 
							}
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ 
								apply_constraints
								($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, \@constrain_geometry); 
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
								$counterstep, $exeonfiles, \@applytype, \@constrain_controls, $to_do); 
							}
							if ($$keep_obstructions[$counterzone][0] eq "y") # TO BE SUPERSEDED BY get_obstructions AND pin_obstructions
							{ 
								bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, $keep_obstructions); 
							}
							if ($constrain_net[$counterzone][0] eq "y")
							{ 
								constrain_net($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, \@constrain_net, $to_do); 
							}
							if ($recalculatenet[0] eq "y") 
							{ 
								recalculatenet
								($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, \@recalculatenet); 
							}
							if ($constrain_obstructions[$counterzone][0] eq "y") 
							{ 
								constrain_obstructions
								($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, \@constrain_obstructions, $to_do); 
							}
							#if ( $pin_obstructions[$counterzone][0] eq "y" ) 
							#{ 
							#	pin_obstructions ($to, $fileconfig, $stepsvar, $counterzone, 
							#	$counterstep, $exeonfiles, \@applytype, \@pin_obstructions); 
							#}
							if ($recalculateish eq "y") 
							{ 
								recalculateish
								($to, $fileconfig, $stepsvar, $counterzone, 
								$counterstep, $exeonfiles, \@applytype, \@recalculateish); 
							}
							if ($daylightcalc[0] eq "y") 
							{ 
								daylightcalc
								($to, $fileconfig, $stepsvar, $counterzone,  
								$counterstep, $exeonfiles, \@applytype, $filedf, \@daylightcalc); 
							}
						} # END SUB DOTHINGS
						
						if ( $modification_type eq "generic_change" )#
						{
							make_generic_change
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $exeonfiles,
							\@applytype, $generic_change);
							dothings;
						} #
						elsif ( $modification_type eq "surface_translation_simple" )
						{
							translate_surfaces_simple
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $translate_surface_simple);
							dothings;
						} 
						elsif ( $modification_type eq "surface_translation" )
						{
							translate_surfaces
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $translate_surface);
							dothings;
						} 
						elsif ( $modification_type eq "surface_rotation" )              #
						{
							rotate_surface
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $rotate_surface);
							dothings;
						} 
						elsif ( $modification_type eq "vertexes_shift" )
						{
							shift_vertexes
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $shift_vertexes);
							dothings;
						}
						elsif ( $modification_type eq "vertex_translation" )
						{
							translate_vertexes
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, \@translate_vertexes);                         
							dothings;
						}  
						elsif ( $modification_type eq "construction_reassignment" )
						{
							reassign_construction
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $construction_reassignment);
							dothings;
						} 
						elsif ( $modification_type eq "rotation" )
						{
							rotate
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $rotate);
							dothings;
						} 
						elsif ( $modification_type eq "translation" )
						{
							translate
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $translate);
							dothings;
						} 
						elsif ( $modification_type eq "thickness_change" )
						{
							change_thickness
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $thickness_change);
							dothings;
						} 
						elsif ( $modification_type eq "rotationz" )
						{
							rotatez
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $rotatez);
							dothings;
						} 
						elsif ( $modification_type eq "change_config" )
						{
							change_config
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, \@change_config);
							dothings;
						}
						elsif ( $modification_type eq "window_reshapement" ) 
						{
							reshape_windows
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, \@reshape_windows);					
							dothings;
						}
						elsif ( $modification_type eq "obs_modification" )  # REWRITE FOR NEW GEO FILE?
						{
							obs_modify
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $obs_modify);
							dothings;
						}
						elsif ( $modification_type eq "warping" )
						{
							warp
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, $warp);
							dothings;
						}
						elsif ( $modification_type eq "vary_controls" )
						{
							vary_controls
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, \@vary_controls);
							dothings;
						}
						elsif ( $modification_type eq "vary_net" )
						{
							vary_net
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, \@vary_net);
							dothings;
						}
						elsif ( $modification_type eq "change_climate" )
						{
							change_climate
							($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
							$exeonfiles, \@applytype, \@change_climate);
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

OPTS is a program conceived to manage parametric explorations through the use of the ESP-r building performance simulation platform. (All the necessary information about ESP-r is available at the web address http://www.esru.strath.ac.uk/Programs/ESP-r.htm.) Parametric explorations are usually performed to solve design optimization problems.

OPTS may modify directories and files in your work directory. So it is necessary to examine how it works before attempting to use it.

For the non-habitual users of Perl: to install OPTS it is necessary to issue the following command in the shell as a superuser: < cpanm Sim::OPTS >. This way Perl will take care to install all necessary dependencies.
After loading the module, which is made possible by the commands < use Sim::OPTS >, only the command "opts" will be available to the user. That command "opts" will activate the opts functions following the setting specified in a previously prepared OPTS configuration file.

The command "optslaunch" is also present in the capability of the code (file "opts_launch.pl"), but it is presently disabled, because it has not been updated to the last several versions of OPTS, so it is no more usable at the moment. "optslaunch" would open a text interface made to facilitate the preparation of OPTS configuration files. Due to this, currently the OPTS configuration files can only be prepared by example.

OPTS will ask for the name of an OPTS configuration file when it is launched.
On that OPTS configuration file the instructions for the program will have to be written before launching OPTS.
All the activity of preparation to run OPTS will happen in an OPTS configuration file, which has to be applied to an existing ESP-r model.

In the module distribution, there is a template file with explanations and an example of an OPTS configuration file.
The template file should be intended as a part of the present documentation. 

To run OPTS without having it act on files, you should specify setting < $exeonfiles = "n"; > in the OPTS configuration file. Then you should specify a path for the the text file that will receive the commands in place of the shell, by setting < $outfilefeedbacktoshell = address_the_text_file >. It is a good idea to always send the OPTS commands to a file, also when they are prompted to the shell, to be able to trace what has been done to the model files.

The OPTS configuration file will make, if asked, OPTS give instruction to ESP-r in order to make it modify a model in several different copies; then, if asked, it will run simulations; then, if asked, it will retrieve the results; then, if asked, it will extract some results and order them in a required manner; then, if asked, will format the so obtained results.
Those functions are performed by the subroutines written in the following files: "opts_morph.pl", "opts_sim.pl", "opts_report.pl", "opts_format.pl".
It should be noted that some functions in "opts_report.pl" and especially in "opts_format.pl" have been used only once and have not been maintained since then.
My attention has indeed been mostly directed to the "OPTS.pm" and "opts_morph.pl" files.

To run OPTS, you may open Perl in a repl. As a repl, you may use the Devel::Repl module. It is going to be installed when OPTS is installed. To launch it, the command < re.pl > has to be given to the shell. 
Then you may load the Sim:OPTS module from there (< use Sim:OPTS >).
Then you should issue the command < Sim::OPTS::opts > from there.
When launched, OPTS will ask you to write the name (with path) of the OPTS configuration file to be considered.
After that, the activity of OPTS will start and will not stop until completion.

OPTS will make ESP-r perform actions on a certain ESP-r model by copying it several times and morphing each copy.
A target ESP-r model must also therefore be present in advance and its name (with path) has to be specified in the OPTS configuration file.
The OPTS configuration file will also contain information about your work directory.
I usually make OPTS work in a "optsworks" folder in my home folder.
Besides OPTS configuration files, also configuration files for propagation of constraints may be specified.
I usually put them into a directory in the model folder named "opts".

The model folders and the result files that will be created through ESP-r will be named as your root model, followed by a "_" character,  followed by a variable number referred to the first morphing phase, followed by a "-" character, followed by an iteration number for the variable in question, and so on for all morphing phases. For example, the model instance produced in the first iteration for a model named "model" in a search constituted by 3 morphing phases and 5 iteration steps each may be named "model_1-1_2-1_3-1"; and the last one may be named "model_1-5_2-5_3-5".
The "_" characters tells OPTS to generate new cases. The character "£" will be used when two parametric variations must be joined before generating new cases. The character "§" stops both the joining and the generation for that branch, but it is useful only for the program, and not for the user.

The propagation of constraints on which some OPTS operations on models may be based can regard the geometry of the model, solar shadings, mass/flow network, and/or controls, and how they affect each other and daylighting (as calculated throuch the Radiance lighting simulation program). 
To study what propagation on constraint can do for the program, the template file included in the OPTS Perl module distribution should be studied.

OPTS presently only works for UNIX and UNIX-like systems. (With a few variations concerning paths and shell commands, it could easily work for Windows as well.)
There still would be lots of things to add to it and bugs to correct. 
OPTS is a program I have written as a side project since 2008, when I was beginning to learn programming. Due to that, the core parts of it are the ones that are written in the strangest manner. As you may realize by looking at the code, anyway, I am not a professional programmer and do several things in a non-standard way.

=head2 EXPORT

"opts".


=head1 SEE ALSO

The available documentation is mostly collected in the readme.txt file.
An example of ESP-r model inclusive an "opts" folder contanining files of instruction for propagation of constraints in OPTS
are uploaded in my personal page at the Politecnico di Milano (www.polimi.it). Its web address may vary, so I don't list it here.
For inquiries: gianluca.brunetti@polimi.it.

=head1 AUTHOR

Gian Luca Brunetti, E<lt>gianluca.brunetti@polimi.itE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008-2014 by Gian Luca Brunetti and Politecnico di Milano
This is free software.  You can redistribute it and/or modify it under the terms of the GNU General Public License 
as published by the Free Software Foundation, version 2 or later.


=cut
