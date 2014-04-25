package Sim::OPTS;
# Copyright (C) 2008-2014 by Gian Luca Brunetti and Politecnico di Milano.
# This is OPTS, a program conceived to manage parametric esplorations through the use of the ESP-r building performance simulation platform.
# This is free software.  You can redistribute it and/or modify it under the terms of the GNU General Public License 
# as published by the Free Software Foundation, version 2.

use 5.008001;
use Exporter; # require Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
use Devel::REPL;
no strict; # use strict: THIS CAN'T BE DONE SINCE THE PROGRAM USES SYMBOLIC REFERENCES
no warnings; # use warnings;

@ISA = qw(Exporter); # our @ISA = qw(Exporter);


# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use opts ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.

%EXPORT_TAGS = ( DEFAULT => [qw(&opts &prepare)]); # our %EXPORT_TAGS = ( 'all' => [ qw( ) ] );
@EXPORT_OK   = qw(); # our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
@EXPORT = qw(opts prepare); # our @EXPORT = qw( );
$VERSION = '0.25'; # our $VERSION = '';
$ABSTRACT = 'OPTS is a program conceived to manage parametric explorations through the use of the ESP-r building performance simulation platform.';


use Sim::OPTS::prepare; # HERE IS THE FUNCTION 'prepare', a text interface to the function 'opts'.

#################################################################################
#################################################################################
#################################################################################
# BEGINNING OF THE OPTS PROGRAM

sub opts 
{ 
print "THIS IS OPTS.
Copyright by Gian Luca Brunetti and Politecnico di Milano, 2008-14.
Dipartimento DAStU, Politecnico di Milano.
Copyright license: GPL.
-------------------

To use OPTS, an OPTS configuration file and a target ESP-r model should have been prepared.
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

use Sim::OPTS::morph;
use Sim::OPTS::sim; # HERE THERE IS THE FUNCTION "sim" CALLED
use Sim::OPTS::report; 
use Sim::OPTS::format;
if (-e "./SIM/OPTS/search.pm")
{
	use Sim::OPTS::search;
}

if ($exeonfiles eq undef) { $exeonfiles = "y";}
use Math::Trig;
use Data::Dumper;
use List::Util qw[min max reduce];
$Data::Dumper::Indent = 0;
$Data::Dumper::Useqq  = 1;
$Data::Dumper::Terse  = 1;

###########################################################################################
# BELOW THE OPTS PROGRAM FOLLOWS.

print "OPTS - IS - RUNNING.
-------------------\n";
if ($outfile ne "" ) 
{ open( OUTFILE, ">$outfile" ) or die "Can't open $outfile: $!"; }

if ($toshell ne "" ) 
{ open( TOSHELL, ">$toshell" ) or die "Can't open $toshell: $!" };

#################################################################################
#################################################################################
#################################################################################

sub dophase
{

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
		my $swap = shift;
		my @arrayarrived = @$swap;
		if (@arrayarrived) { @varnumbers = @arrayarrived; }
		
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
			
			if ( ( $counter_countervar == $#varnumbers ) and ($$general_variables[0] eq "y") )
			{
				$$general_variables[0] = "n";
			} # THIS TELLS THAT IF THE SEARCH IS ENDING (LAST SUBSEARCH CYCLE) GENERATION OF CASES HAS TO BE TURNED OFF
			
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
									&propagate_constraints
									($to, $fileconfig, $stepsvar, $counterzone, 
									$counterstep, $exeonfiles, \@applytype, $zone_letter, \@propagate_constraints); 
								}
								if ($apply_constraints[$counterzone][0] eq "y") 
								{ 
									&apply_constraints
									($to, $fileconfig, $stepsvar, $counterzone, 
									$counterstep, $exeonfiles, \@applytype, $zone_letter, \@constrain_geometry); 
								}
								if ($constrain_geometry[$counterzone][0] eq "y") 
								{ 
									&constrain_geometry
									($to, $fileconfig, $stepsvar, $counterzone, 
									$counterstep, $exeonfiles, \@applytype,  $zone_letter, \@constrain_geometry, $to_do); 
								}
								if ($constrain_controls[$counterzone][0] eq "y") 
								{ 
									&constrain_controls
									($to, $fileconfig, $stepsvar, $counterzone, 
									$counterstep, $exeonfiles, \@applytype, $zone_letter, \@constrain_controls, $to_do); 
								}
								if ($$keep_obstructions[$counterzone][0] eq "y") # TO BE SUPERSEDED BY get_obstructions AND pin_obstructions
								{ 
									&bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, 
									$counterstep, $exeonfiles, \@applytype, $zone_letter, $keep_obstructions); 
								}
								if ($constrain_net[$counterzone][0] eq "y")
								{ 
									&constrain_net($to, $fileconfig, $stepsvar, $counterzone, 
									$counterstep, $exeonfiles, \@applytype, $zone_letter, \@constrain_net, $to_do); 
								}
								if ($recalculatenet[0] eq "y") 
								{ 
									&recalculatenet
									($to, $fileconfig, $stepsvar, $counterzone, 
									$counterstep, $exeonfiles, \@applytype, $zone_letter, \@recalculatenet); 
								}
								if ($constrain_obstructions[$counterzone][0] eq "y") 
								{ 
									&constrain_obstructions
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
									&recalculateish
									($to, $fileconfig, $stepsvar, $counterzone, 
									$counterstep, $exeonfiles, \@applytype, $zone_letter, \@recalculateish); 
								}
								if ($daylightcalc[0] eq "y") 
								{ 
									&daylightcalc
									($to, $fileconfig, $stepsvar, $counterzone,  
									$counterstep, $exeonfiles, \@applytype, $zone_letter, $filedf, \@daylightcalc); 
								}
							} # END SUB DOTHINGS
							
							if ( $modification_type eq "generic_change" )#
							{
								&make_generic_change
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, $exeonfiles,
								\@applytype, $zone_letter, $generic_change);
								&dothings;
							} #
							elsif ( $modification_type eq "surface_translation_simple" )
							{
								&translate_surfaces_simple
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, $translate_surface_simple);
								&dothings;
							} 
							elsif ( $modification_type eq "surface_translation" )
							{
								&translate_surfaces
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, $translate_surface);
								&dothings;
							} 
							elsif ( $modification_type eq "surface_rotation" )              #
							{
								&rotate_surface
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, $rotate_surface);
								&dothings;
							} 
							elsif ( $modification_type eq "vertexes_shift" )
							{
								&shift_vertexes
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, $shift_vertexes);
								&dothings;
							}
							elsif ( $modification_type eq "vertex_translation" )
							{
								&translate_vertexes
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, \@translate_vertexes);                         
								&dothings;
							}  
							elsif ( $modification_type eq "construction_reassignment" )
							{
								&reassign_construction
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, $construction_reassignment);
								&dothings;
							} 
							elsif ( $modification_type eq "rotation" )
							{
								&rotate
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, $rotate);
								&dothings;
							} 
							elsif ( $modification_type eq "translation" )
							{
								&translate
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, $translate);
								&dothings;
							} 
							elsif ( $modification_type eq "thickness_change" )
							{
								&change_thickness
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, $thickness_change);
								&dothings;
							} 
							elsif ( $modification_type eq "rotationz" )
							{
								&rotatez
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, $rotatez);
								&dothings;
							} 
							elsif ( $modification_type eq "change_config" )
							{
								&change_config
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, \@change_config);
								&dothings;
							}
							elsif ( $modification_type eq "window_reshapement" ) 
							{
								&reshape_windows
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, \@reshape_windows);					
								&dothings;
							}
							elsif ( $modification_type eq "obs_modification" )  # REWRITE FOR NEW GEO FILE?
							{
								&obs_modify
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, $obs_modify);
								&dothings;
							}
							elsif ( $modification_type eq "warping" )
							{
								&warp
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, $warp);
								&dothings;
							}
							elsif ( $modification_type eq "vary_controls" )
							{
								&vary_controls
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, \@vary_controls);
								&dothings;
							}
							elsif ( $modification_type eq "vary_net" )
							{
								&vary_net
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, \@vary_net);
								&dothings;
							}
							elsif ( $modification_type eq "change_climate" )
							{
								&change_climate
								($to, $fileconfig, $stepsvar, $counterzone, $counterstep, 
								$exeonfiles, \@applytype, $zone_letter, \@change_climate);
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

} # END SUB DOPHASE
###########################################################################################
###########################################################################################
###########################################################################################


###########################################################################################
###########################################################################################
# BELOW THE PROGRAM THAT LAUNCHES OPTS.

#print "NOT ENTERED, " . Dumper(@bundlesgroup) . " \n";

if ( (@bundlesgroup) and (-e "./scripts/opts_search.pl") )
{
	foreach my $el (@bundlesgroup)
	{
		my @bundleref = @{$el};
		#print "I ENTER 1 @bundleref\n";
		foreach my $el (@bundleref)
		{
			my @sequence = @{$el};
			#print "I ENTER 2 @sequence\n";
			foreach my $el (@sequence)
			{
				my @block = @{$el};
				#print "I ENTER 3 @block\n";

				@varnumbers = @chancelines[ $block[0] .. ( $block[0] + $block[1] - 1 ) ];
				if (@varnumbers)
				{
					&dophase(\@varnumbers);
					print "I ENTER 4, @varnumbers\n";
				}
			}
		}
	}
}
else
{  &dophase; }

# END OF THE OPTS LAUNCH PROGRAM
##########################################################################################
##########################################################################################


### ZZZZ REQUIRE SEARCH PROGRAM. IF PRESENT, REQUIRE.


close(OUTFILE);
close(TOSHELL);
exit;

} # END OF SUB OPTS
#############################################################################
#############################################################################
#############################################################################


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

To install OPTS it is necessary to issue the following command in the shell as a superuser: < cpanm Sim::OPTS >. This way Perl will take care to install all necessary dependencies. After loading the module, which is made possible by the commands < use Sim::OPTS >, only the command < opts > will be available to the user. That command will activate the OPTS functions following the setting specified in a previously prepared OPTS configuration file.

The command < prepare > would be also present in the capability of the code (file "prepare.pm"), but it is not possible to use it, because it has not been updated to the last several versions of OPTS, so it is no more usable at the moment. The command would open a text interface made to facilitate the preparation of OPTS configuration files. Due to this, currently the OPTS configuration files can only be prepared by example.

When it is launched, OPTS will ask for the name of an OPTS configuration file. On that file the instructions for the program will have to be written by the user before launching OPTS. All the activity of preparation to run OPTS will happen in an OPTS configuration file, which has to be applied to an existing ESP-r model.

In the module distribution, there is a template file with explanations and an example of an OPTS configuration file. The template file should be intended as a part of the present documentation. 

To run OPTS without having it act on files, you should specify the setting < $exeonfiles = "n"; > in the OPTS configuration file. Then you should specify a path for the  text file that will receive the commands in place of the shell, by setting < $outfilefeedbacktoshell = address_the_text_file >. It is a good idea to always send the OPTS commands to a file also when they are prompted to the shell, to be able to trace what has been done to the model files.

The OPTS configuration file will make, if asked, OPTS give instruction to ESP-r in order to make it modify a model in several different copies; then, if asked, it will run simulations; then, if asked, it will retrieve the results; then, if asked, it will extract some results and order them in a required manner; then, if asked, will format the so obtained results. Those functions are performed by the subroutines contained in "OPTS.pm", which previously were written in the following separate files: "morph.pm", "sim.pm", "report.pm", "format.pm", "prepare.pm". Some functions in "report.pm" and especially "format.pm" and "prepare.pm" have been used only once and have not been maintained since then. My attention has indeed been mostly directed to the things in the "OPTS.pm" and "morph.pm" files.

To run OPTS, you may open Perl in a repl. As a repl, you may use the Devel::Repl module. It is going to be installed when OPTS is installed. To launch it, the command < re.pl > has to be given to the shell. Then you may load the Sim:OPTS module from there (< use Sim:OPTS >). Then you should issue the command < opts > from there. When launched, OPTS will ask you to write the name (with path) of the OPTS configuration file to be considered. After that, the activity of OPTS will start and will not stop until completion.

OPTS will make ESP-r perform actions on a certain ESP-r model by copying it several times and morphing each copy. A target ESP-r model must also therefore be present in advance and its name (with path) has to be specified in the OPTS configuration file. The OPTS configuration file will also contain information about your work directory. I usually make OPTS work in a "optsworks" folder in my home folder.

Besides OPTS configuration files, also configuration files for propagation of constraints may be specified. I usually put them into a directory in the model folder named "opts".

The model folders and the result files that will be created through ESP-r will be named as your root model, followed by a "_" character,  followed by a variable number referred to the first morphing phase, followed by a "-" character, followed by an iteration number for the variable in question, and so on for all morphing phases. For example, the model instance produced in the first iteration for a model named "model" in a search constituted by 3 morphing phases and 5 iteration steps each may be named "model_1-1_2-1_3-1"; and the last one may be named "model_1-5_2-5_3-5".
The "_" characters tells OPTS to generate new cases. The character "£" will be used when two parametric variations must be joined before generating new cases, and the character "§" will stop both the joining and the generation for the given branch.

The propagation of constraints on which some OPTS operations on models may be based can regard the geometry of the model, solar shadings, mass/flow network, and/or controls, and how they affect each other and daylighting (as calculated throuch the Radiance lighting simulation program). To study what propagation on constraint can do for the program, the template file included in the OPTS Perl module distribution should be studied.

OPTS presently only works for UNIX and UNIX-like systems. There would be lots of functionality to add to it and bugs to correct. 

OPTS is a program I have written for my personal use as a side project since 2008, when I was beginning to learn programming. The earlier parts of it are the ones that are coded in the strangest manner. I am not a professional programmer and do several things in a non-standard way. The part of OPTS I wrote for work is that in the file "prepare.pm", which made possible to include the use of the tool in an institutional research I was participating to in 2011-2012.

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
