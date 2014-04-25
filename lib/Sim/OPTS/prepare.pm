#!/usr/bin/perl

# Copyright: Gian Luca Brunetti and Politecnico di Milano, 2008-2014
# email gianluca.brunetti@polimi.it
# This is a part of the Sim::OPTS Perl module.
# OPTS is made to manage parametric explorations through the use of the ESP-r building energy performance simulation platform.  
# This is free software.  You can redistribute it and/or modify it under the terms of the GNU General Public License 
# as published by the Free Software Foundation, version 2.

# This program launched a text interface for creating OPTS configuration files. 
# It has not been updated after a lot of changes to OPTS, so it is currently not usable.

##############################################################################
##############################################################################
##############################################################################
# HERE FOLLOWS THE CONTENT OF THE "opts_prepare.pl" FILE, WHICH HAS BEEN MERGED HERE
# TO AVOID COMPLICATIONS WITH THE PERL MODULE INSTALLATION

# This program launched a text interface for creating OPTS configuration files. 
# It has not been updated after a lot of changes to OPTS, so it is currently not usable.
package Sim::OPTS::prepare;

no strict; 
no warnings;
use lib "../../";
@ISA = qw(Exporter); # our @ISA = qw(Exporter);
@EXPORT = qw( &prepare );

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


1;

