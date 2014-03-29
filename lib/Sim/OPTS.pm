package Sim::OPTS;

use 5.014002;
use Exporter; # require Exporter;
no strict; # use strict;
no warnings; # use warnings;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
@ISA = qw(Exporter); # our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use opts ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.

%EXPORT_TAGS = ( DEFAULT => [qw(&opts &optslaunch)]); # our %EXPORT_TAGS = ( 'all' => [ qw( ) ] );
@EXPORT_OK   = qw(opts); # our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
@EXPORT = qw( ); # our @EXPORT = qw( );
$VERSION = '0.01'; # our $VERSION = '0.01';

eval `cat ./opts_launch.pl`; # HERE IS THE FUNCTION "launch", a text interface to the function "opts".
# require "./opts_launch.pl"; # HERE IS THE FUNCTION "launch", a text interface to the function "opts".

sub opts {
print "THIS IS OPTS.
Copyright by Politecnico di Milano, 2008-13.
Author: Gian Luca Brunetti - gianluca.brunetti\@polimi.it
-------------------
\n";

print "Please insert the name of the configuration file (Unix path):\n";
$configfile = <STDIN>;
chomp $configfile;
print "You wrote $configfile, is this correct? (y or n).\n";
$response1 = <STDIN>;
chomp $response1;
if ( $response1 eq "y" )
{ ; }
else { die; }
eval `cat $configfile`; # The file where the program data are
# require $configfile; # The file where the program data are

eval `cat ./opts_morph.pl`; # HERE THERE ARE THE FUNCTION CALLED FROM THE MAIN FUNCTION, "morph", FROM THIS FILE (MAIN).
# require "./opts_morph.pl"; # HERE THERE ARE THE FUNCTION CALLED FROM THE MAIN FUNCTION, "morph", FROM THIS FILE (MAIN).

eval `cat ./opts_sim.pl`; # HERE THERE IS THE FUNCTION "sim" CALLED FROM THIS FILE (MAIN).
# require "./opts_sim.pl"; # HERE THERE IS THE FUNCTION "sim" CALLED FROM THIS FILE (MAIN).

eval `cat ./opts_report.pl`; # HERE THERE IS THE FUNCTION "report" CALLED FROM THIS FILE (MAIN).
# require "./opts_report.pl"; # HERE THERE IS THE FUNCTION "report" CALLED FROM THIS FILE (MAIN).

eval `cat ./opts_format.pl`; # HERE THERE ARE RATHER UMNANTAINED FUNCTIONS CALLED FROM THIS FILE (MAIN) FOR RANKING AND FORMATTING REPORTS.
# require "./opts_format.pl"; # HERE THERE ARE RATHER UMNANTAINED FUNCTIONS CALLED FROM THIS FILE (MAIN) FOR RANKING AND FORMATTING REPORTS.


# use strict;
# use warnings;
if ($exeonfiles == undef) { $exeonfiles = "y";} # SO EVEN IF THE CONFIGFILE IS OF AN OLD TYPE THE PROGRAM WON'T STOP.
use Math::Trig;
use Data::Dumper;
use List::Util qw[min max];
$Data::Dumper::Indent = 0;
$Data::Dumper::Useqq  = 1;
$Data::Dumper::Terse  = 1;


if ( $stepsvar2 == 0 )  { $stepsvar2  = 1; }
if ( $stepsvar3 == 0 )  { $stepsvar3  = 1; }
if ( $stepsvar4 == 0 )  { $stepsvar4  = 1; }
if ( $stepsvar5 == 0 )  { $stepsvar5  = 1; }
if ( $stepsvar6 == 0 )  { $stepsvar6  = 1; }
if ( $stepsvar7 == 0 )  { $stepsvar7  = 1; }
if ( $stepsvar8 == 0 )  { $stepsvar8  = 1; }
if ( $stepsvar9 == 0 )  { $stepsvar9  = 1; }
if ( $stepsvar10 == 0 ) { $stepsvar10 = 1; }
if ( $stepsvar11 == 0 ) { $stepsvar11 = 1; }
if ( $stepsvar12 == 0 ) { $stepsvar12 = 1; }
if ( $stepsvar13 == 0 ) { $stepsvar13 = 1; }
if ( $stepsvar14 == 0 ) { $stepsvar14 = 1; }
if ( $stepsvar15 == 0 ) { $stepsvar15 = 1; }
if ( $stepsvar16 == 0 ) { $stepsvar16 = 1; }
if ( $stepsvar17 == 0 ) { $stepsvar17 = 1; }
if ( $stepsvar18 == 0 ) { $stepsvar18 = 1; }
if ( $stepsvar19 == 0 ) { $stepsvar19 = 1; }
if ( $stepsvar20 == 0 ) { $stepsvar20 = 1; }
if ( $stepsvar21 == 0 ) { $stepsvar21 = 1; }
if ( $stepsvar22 == 0 ) { $stepsvar22 = 1; }
if ( $stepsvar23 == 0 ) { $stepsvar23 = 1; }
if ( $stepsvar24 == 0 ) { $stepsvar24 = 1; }
if ( $stepsvar25 == 0 ) { $stepsvar25 = 1; }
if ( $stepsvar26 == 0 ) { $stepsvar26 = 1; }
if ( $stepsvar27 == 0 ) { $stepsvar27 = 1; }
if ( $stepsvar28 == 0 ) { $stepsvar28 = 1; }
if ( $stepsvar29 == 0 ) { $stepsvar29 = 1; }
if ( $stepsvar30 == 0 ) { $stepsvar30 = 1; }
if ( $stepsvar31 == 0 ) { $stepsvar31 = 1; }
if ( $stepsvar32 == 0 ) { $stepsvar32 = 1; }
if ( $stepsvar33 == 0 ) { $stepsvar33 = 1; }
if ( $stepsvar34 == 0 ) { $stepsvar34 = 1; }
if ( $stepsvar35 == 0 ) { $stepsvar35 = 1; }
$casenumbers =
  ( $stepsvar1 * $stepsvar2 * $stepsvar3 * $stepsvar4 * $stepsvar5 * $stepsvar6 * 
  $stepsvar7 * $stepsvar8 * $stepsvar9 * $stepsvar10 * $stepsvar11 * $stepsvar12 *
  $stepsvar13 * $stepsvar14 * $stepsvar15 * $stepsvar16 * $stepsvar17 * $stepsvar18 *
  $stepsvar19 * $stepsvar20 * $stepsvar21 * $stepsvar22 * $stepsvar23 * $stepsvar24 *
  $stepsvar25 * $stepsvar26 * $stepsvar27 * $stepsvar28 * $stepsvar29 * $stepsvar30 *
  $stepsvar31 * $stepsvar32 * $stepsvar33 * $stepsvar34 * $stepsvar35 );

print "THIS IS OPTS.
Copyright by Politecnico di Milano, 2008-13.
Author: Gian Luca Brunetti - gianluca.brunetti\@polimi.it
-------------------
The number of cases set in the configuration file on the whole is $casenumbers.
If they are too many, stop OPTS with CONTROL+C. \n";

# open( OUTFILEFEEDBACK, ">$outfilefeedback" ) or die "Can't open UFF $outfilefeedback: $!";
if (-e "$outfilefeedbacktoshell") { open( OUTFILEFEEDBACKTOSHELL, ">$outfilefeedbacktoshell" ) or die "Can't open UFFUFF $outfilefeedbacktoshell: $!" };
sub morph    # This function generates the test cases and modifies them
{
	my $counter_countervar = 0;
	foreach $countervar (@varnumbers)
	{
		if ( $countervar == 1 )
		{
			$stepsvar                  = ${ "stepsvar" . "$countervar" };
			@applytype                 = @{ "applytype" . "$countervar" };
			@generic_change            = @{ "generic_change" . "$countervar" };
			$rotate                    = ${ "rotate" . "$countervar" };
			$rotatez                   = ${ "rotatez" . "$countervar" };
			$general_variables         = ${ "general_variables" . "$countervar" };
			$translate                 = ${ "translate" . "$countervar" };
			$translate_surface_simple  = ${ "translate_surface_simple" . "$countervar" };
			$translate_surface         = ${ "translate_surface" . "$countervar" };
			$keep_obstructions         = ${ "keep_obstructions" . "$countervar" };
			$shift_vertexes            = ${ "shift_vertexes" . "$countervar" };
			$construction_reassignment = ${ "construction_reassignment" . "$countervar" };
			$thickness_change          = ${ "thickness_change" . "$countervar" };
			$recalculateish		   = ${ "recalculateish" . "$countervar" };
			@recalculatenet		   = @{ "recalculatenet" . "$countervar" };
			$obs_modify		   = ${ "obs_modify" . "$countervar" };
			$netcomponentchange 	   = ${ "netcomponentchang" . "$countervar" };
			$changecontrol             = ${ "changecontrol" . "$countervar" };
			@apply_constraints	   = @{ "apply_constraints" . "$countervar" };
			$rotate_surface		   = ${ "rotate_surface" . "$countervar" };
			@reshape_windows	   = @{ "reshape_windows" . "$countervar" };
			@apply_netconstraints      = @{ "apply_netconstraints" . "$countervar" };
			@apply_windowconstraints  = @{ "apply_windowconstraints" . "$countervar" };
			@translate_vertexes        = @{ "translate_vertexes" . "$countervar" };
			$warp				= ${ "warp" . "$countervar" };
			@daylightcalc		   = @{ "daylightcalc" . "$countervar" };
			@change_config 		= @{ "change_config" . "$countervar" };
		} 
		my @cases_to_sim;
		my @files_to_convert;
		my $generate  = $$general_variables[0];
		my $sequencer = $$general_variables[1];
		my $dffile = "df-$file.txt";
		if ( $counter_countervar == 0 )
		{
			if ($exeonfiles eq "y") { print `cp -r $mypath/$file $mypath/$filenew`; }
			print OUTFILEFEEDBACKTOSHELL
			  "cp -r $mypath/$file $mypath/$filenew\n\n";
		}
		if ( ( $sequencer eq "n" ) and not( $counter_countervar == 0 ) )
		{
			my @files_to_convert = grep -d, <$mypath/$file*£>;
			foreach $file_to_convert (@files_to_convert)
			{
				$file_converted = "$file_to_convert" . "_";
				if ($exeonfiles eq "y") { print `mv $file_to_convert $file_converted\n`; }
				print OUTFILEFEEDBACKTOSHELL
				  "mv $file_to_convert $file_converted\n\n";
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
						print OUTFILEFEEDBACKTOSHELL "chmod -R 777 $from\n\n";
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
						print OUTFILEFEEDBACKTOSHELL "chmod -R 777 $from\n\n";
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
					print OUTFILEFEEDBACKTOSHELL "mv $from $to\n\n";
					if ($exeonfiles eq "y") { print `chmod -R 777 $to\n`; }
					print OUTFILEFEEDBACKTOSHELL "chmod -R 777 $to\n\n";
				} else
				{
					if ($exeonfiles eq "y") { print `cp -R $from $to\n`; }
					print OUTFILEFEEDBACKTOSHELL "cp -R $from $to\n\n";
					if ($exeonfiles eq "y") { print `chmod -R 777 $to\n`; }
					print OUTFILEFEEDBACKTOSHELL "chmod -R 777 $to\n\n";
				}
				$counterzone = 0;
				foreach my $zone (@applytype)
				{
					my $modification_type = $applytype[$counterzone][0];
					if (
						 (
						   $applytype[$counterzone][1] ne
						   $applytype[$counterzone][2]
						 )
						 and ( $modification_type ne "changeconfig" )
					  )
					{
						if ($exeonfiles eq "y") { print 
`cp -f $to/zones/$applytype[$counterzone][1] $to/zones/$applytype[$counterzone][2]\n`; }
						print OUTFILEFEEDBACKTOSHELL
"cp -f $to/zones/$applytype[$counterzone][1] $to/zones/$applytype[$counterzone][2]\n\n";
						if ($exeonfiles eq "y") { print
`cp -f $to/cfg/$applytype[$counterzone][1] $to/cfg/$applytype[$counterzone][2]\n`; }    # ORDINARILY, REMOVE THIS LINE
						print OUTFILEFEEDBACKTOSHELL
"cp -f $to/cfg/$applytype[$counterzone][1] $to/cfg/$applytype[$counterzone][2]\n\n";    # ORDINARILY, REMOVE THIS LINE
					}
					if (
						 (
						   $applytype[$counterzone][1] ne $applytype[$counterzone][2]
						 )
						 and ( $modification_type eq "changeconfig" )
					  )
					{
						if ($exeonfiles eq "y") { print `cp -f $to/cfg/$applytype[$counterzone][1] $to/cfg/$applytype[$counterzone][2]\n`; }
						print OUTFILEFEEDBACKTOSHELL 
						"cp -f $to/cfg/$applytype[$counterzone][1] $to/cfg/$applytype[$counterzone][2]\n\n"; # ORDINARILY, REMOVE THIS LINE
					}

					my $yes_or_no_rotate_obstructions = "$$rotate[$counterzone][1]"
					  ; # WHY $BRING_CONSTRUCTION_BACK DOES NOT WORK IF THESE TWO VARIABLES ARE PRIVATE?
					my $yes_or_no_keep_some_obstructions = "$$keep_obstructions[$counterzone][0]";    # WHY?

					my $countercycles_transl_surfs = 0;
					my $recalc_net = $recalculatenet[0];
					
					if ( $stepsvar > 1)
					{
						if ( $modification_type eq "generic_change" )#
						{
							make_generic_change($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $generic_change);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }

						} #
						elsif ( $modification_type eq "surface_translation_simple" )
						{
							translate_surfaces_simple($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $translate_surface_simple);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						} 
						elsif ( $modification_type eq "surface_translation" )
						{
							translate_surfaces($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $translate_surface);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						} 
						elsif ( $modification_type eq "surface_rotation" )              #
						{
							rotate_surface($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $rotate_surface);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						} 
						elsif ( $modification_type eq "vertexes_shift" )
						{
							shift_vertexes($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $shift_vertexes);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } 	# 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						}
						elsif ( $modification_type eq "vertex_translation" )  			#
						{
							translate_vertexes($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@translate_vertexes);                         
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						}  
						elsif ( $modification_type eq "construction_reassignment" )
						{
							reassign_construction($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $construction_reassignment);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); } # 
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						} 
						elsif ( $modification_type eq "rotation" )
						{
							rotate($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $rotate);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						} 
						elsif ( $modification_type eq "translation" )
						{
							translate($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $translate);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						} 
						elsif ( $modification_type eq "thickness_change" )
						{
							change_thickness($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $thickness_change);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						} 
						elsif ( $modification_type eq "rotationz" )
						{
							rotatez($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $rotatez);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						} 
						elsif ( $modification_type eq "change_config" )
						{
							change_config($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@change_config);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						}
						elsif ( $modification_type eq "window_reshapement" ) 
						{
							reshape_windows($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@reshape_windows);					
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig,  $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig,  $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						}
						elsif ( $modification_type eq "obs_modification" )  # REWRITE FOT NEW GEO FILE
						{
							obs_modify($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $obs_modify);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } # 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
						}
						elsif ( $modification_type eq "warping" )
						{
							warp($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $warp);
							if ($$keep_obstructions[$counterzone][0] eq "y") 
							{ bring_obstructions_back($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, $keep_obstructions); }
							if ($apply_constraints[$counterzone][0] eq "y") 
							{ apply_constraints($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@apply_constraints); }
							if (@apply_windowconstraints[0] eq "y") { apply_windowconstraints; } # 
							if ($apply_netconstraints[0] eq "y") { apply_netconstraints; } 	# 
							if ($recalculateish eq "y") 
							{ recalculateish($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculateish); }
							if ($recalc_net eq "y") 
							{ recalculatenet($to, $fileconfig, $stepsvar, $counterzone, $counterstep, \@applytype, \@recalculatenet); }
							if ($daylightcalc[0] eq "y") 
							{ daylightcalc($to, $fileconfig, $stepsvar, $counterzone,  $counterstep, \@applytype, $filedf, \@daylightcalc); }
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
				print OUTFILEFEEDBACKTOSHELL
				  "rm -rf $file_to_clean\n";
			}
}    # END SUB morph


if ( $dowhat[0] eq "y" ) { unless (-e $to) { morph(); } }
if ( $dowhat[1] eq "y" ) { sim(); }
if ( $dowhat[4] eq "y" ) { report(); }
if ( $dowhat[5] eq "y" )
{
	merge_reports();
}

if ( $dowhat[6] eq "y" )
{
	convert_report(); # CONVERT NOT YET FILTERED REPORTS
}
if ( $dowhat[7] eq "y" )
{
	filter_reports(); # FILTER ALREADY CONVERTED REPORTS
}
if ( $dowhat[8] eq "y" )
{
	convert_filtered_reports(); # CONVERT ALREADY FILTERED REPORTS
}
if ( $dowhat[9] eq "y" )
{
	maketable(); # CONVERT TO TABLE ALREADY FILTERED REPORTS
}

close(OUTFILEFEEDBACK);
close(OUTFILEFEEDBACKTOSHELL);
exit;

}

1;
__END__

=head1 NAME

Sim::OPTS - Perl module to run parametric esploration with the ESP-r building performance simulation platform

=head1 SYNOPSIS

  use Sim::OPTS;
  opts;

=head1 DESCRIPTION


OPTS is made to manage parametric explorations through the use of the ESP-r building energy performance simulation platform.
Be aware that OPTS may modify directories and files in your work directory. 
So it is necessary to examine how it works before attempting to use it.
All the necessary information about ESP-r is available at the web address http://www.esru.strath.ac.uk/Programs/ESP-r.htm.

For the non-habitual users of Perl: to install OPTS it is necessary to issue the following command in the shell as a superuser: "cpanm Simulation::OPTS".
This way Perl will take care to install all necessary dependencies.
After loading the module, which is made possible by the commands "use Simulation::OPTS", only two commands will be available to the user.
Those will be "opts" and "optslaunch".
The command "opts" will give activate the opts functions as written in a previously prepared OPTS configuration file.
The command "optslaunch" will open a text interface made to facilitate the preparation of OPTS configuration files.
However, "optslaunch" has not been updated to the last several versions of opts, so it not usable at the moment. 

The command "opts" has no parameter or other information excepted the name of an OPTS configuration file.
It will ask for its name as soon it is launched.
On that OPTS configuration file the instructions for the program will be written.
Therefore, all the activity of preparation for a run of opts will happen in an OPTS configuration file.
The OPTS configuration files will have to be prepared in advance. The first thing to do 
to run OPTS is to prepare an OPTS configuration files to apply to an existing ESP-r model.

Currently the OPTS config files can only be prepared by example.
In the distribution there is a template file with explanations and an example of an OPTS config file.
That template file constitute an integrative part of the present documentation.
The OPTS config file will make, is asked, OPTS give instruction to the ESP-r building performance simulation program
in order to make it modify a model in several different copies; then, if asked, will run some simulations;
then, if asked, will retrieve the results; then, if asked, will extract some results.
These are the functions done by the subroutines written in the files "opts_morph.pl", "opts_sim.pl", "opts_report.pl".
It should be noted that some functions in "opts_report.pl" have been used only once and have not been maintained since then.
This is because I have mostly dedicated my time to "opts.pm" and "opts_morph.pl".

To run opts, I advise that Perl is called in a repl, then the Simulation:OPTS module is loaded from there, and
the command "opts" is issued from there as well.
As a repl, you may use the Perl debugger.
To call it, the command "perl -de" may be used. Once in the debugger, issue "use Simulation::OPTS". Then issue "opts".
At that point, OPTS will ask you to write the name and path of the OPTS configuration file to consider.
After you will have given that response, the activity of OPTS will start and will not stop until completion.

OPTS will make ESP-r act on a certain ESP-r files by copying it several times and morphing it.
The target ESP-r model file  must also therefore be prepared in advance and specified in the OPTS configuration file.
The OPTS configuration file will also contain information about your work directory.
I usually make OPTS work in a "optsworks" folder in my home folder.
Beside OPTS configuration files, also configuration files for propagation of constraint may be specificed.
I usually put them into a directory of the model folders named "opts".

The model folders and the result files that will be created by OPTS through ESP-r will be named as your root model, followed by a “_” character,  followed by a variable number referred to the first morphing phase, followed by a “-” character, followed by an iteration number for the variable in question, and so on for all morphing phases. 
For example, the first iteration for a model named “model” in a search constituted by 3 morphing phases and 5 iteration steps each may be named “model_1-1_2-1_3-1”; and the last one may be named “model_1-5_2-5_3-5”.

Some of OPTS operations on models are based on propagation of constraints. That propagation may regard the geometry of the model, solar shadings, mass/flow network, and controls, and how they affect each other and daylighting (as calculated throuch the Radiance lighting simulation program). 
To study what propagation on constraint can do for the program the tempate file must be studied.

OPTS presently only works for UNIX, and there still are lots of things to add to it and to correct.
This is a program I have written as a side project since 2008, where I was beginning to learn to program.
For this reason, its writing at first proceeded slowly and the most fundamental parts of it are the ones that are written in the strangest manner.
As you may realize by looking at the code, I am not a professional programmer and I don't do most things in a standard way.
In this module I am making use of symbolic references and I use "eval" in place of "require" or else.
I did this in order to make programming things easier. 
This is also the reasons neither "warnings" nor "strict" are used in the program.



=head2 EXPORT

"opts" and "optslaunch".



=head1 SEE ALSO

All the available documentation is collected in the readme.txt file.
For inquiries: gianluca.brunetti@polimi.it

=head1 AUTHOR

Gian Luca Brunetti, E<lt>gianluca.brunetti@polimi.itE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008-2014 by Gian Luca Brunetti and Politecnico di Milano
This is free software.  You can redistribute it and/or modify it under the terms of the GNU General Public License 
as published by the Free Software Foundation, version 2.


=cut
