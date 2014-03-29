

$file = "ame";  # Write here the home model directory.  This will remain unchanged. THIS NOW IS DONE VIA KEYBOARD THROUGH THE EXECUTABLE.
$filenew = "$file"."_"; # Write here the work model directory.  The program will copy the root model directory into this one.  Afterwards changes may be made to it
$configfileinsert = ""; # "./erase_first_ams2e.pl";
@dowhat = ( "y", "y", "y", "y", "y", "y", "n", "n", "n" );  # This variables tell to the program what to do.  1) Create cases for simulation; 
# 2) simulate AND retrieve; 3) retrieve data; 4) erase res and .fl file as they are created or not 5) report; 6) merge reports;NOTE: THIS IS NOT UNUSEFUL WITH LOADS AND TEMPS STATS REPORTS. IT HAS TO BE OFF. IT IS A NEW FEATURE NOT YET IMPLEMENTED FOR OTHER VARIABLES
# 7) substitute names (convert) in non-filtered reports, 8) filter already converted reports, 9) make table to be plotted in 3D; 
# 10) convert filtered and make-tabled reports,.$homepath = "/home/luca";
$preventsim = "n"; # prevent simulation, just retrieve

$mypath= "/home/ubuntu"; # Write here the path of the directory in which the OPT executable is.
$homepath= "/home/ubuntu";
$fileconfig=("cells.cfg"); # Write here the name of the configuration file of you model


#$outfilefeedback = "$mypath/$file-$fileconfig.feedback.txt"; # Write here the name of the files in which reports will be printed in order to check the inner working of the program.  In order to do this, you'll have to mess up with the code to specify what you want to be printed.
$outfilefeedbacktoshell = "$mypath/$file-$fileconfig.feedbacktoshell.txt"; # Write here the name of the files in which the output to the shell will be printed in order to check the inner working of the program.  In order to do this, you'll have to mess up with the code to specify what you want to be printed.
#@varthemes_report = ("rotation_zy", "rotation_xy","albedo_terrace", "albedo_side_wall"); ########## Definitions of the variables that are going to substitute the variables' numbers in the tables
@varthemes_variations = ([-1, 1], [-1, 1],[-36, 36] , [-30, 30],[-30, 30],[-30, 30],[-30, 30], [-1, 1]); ######### Minimum and maximum values regarding the variables, in the same order above.
@varthemes_steps = (5, 5, 5, 5, 5);  #########(3, 1, 1, 1, 1, 1);   (7, 5, 5, 5, 5, 3); The number of steps allowed for each variables. In the same order above.
@themereports = ("tempsstats"); # possibilities:  "temps", "comfort", "loads", "tempsstats" ######### General themes regarding the simulation.  This piece of information go to compose the result name files.
@simtitle = ("a"); # write here the name of the time periods will be taken into account in the simulations.
@reportperiods = ("a"); # write here the name of the time periods will be taken into account in the reports.
#$reportloadsdata = [ "y", "", [ "all" ], [1, 2]]; # mixdata y/n,  # "name of the files you want to deal with, if they are not all the existing ones", # list of the the names of the simdata to you want to mix together
@simdata=("01 08", "31 8", "20", "1"); # Here put the data this way: "starting-month_1 starting-day_1", "ending-month_1 ending-day_1", "start-up-period-duration_1", "time/steps-hour_1", "starting-month_2"starting-day_2", "ending-month_2 ending-day_2", "start-up-period-duration_2", "time/steps-hour_2", ..., "starting-month_n starting-day_n", "ending-month_n ending-day_n", "start-up-period-duration_n", "time/steps-hour_n"
$simnetwork = "y"; # "n" id there is no mass/flow network. This information regards the simulation settings.
@retrievedata = ("n", "n", "n", "y"); # NOW UNUSED?!  retrieve_temperatures_results, retrieve_comfort_results, retrieve_loads_results, retrieve tempstats results
@retrievedatatemps = ("1 08 1", "31 08 24", "1" ); # start data to retrieve for temps; end data to retrieve for temps.
@retrievedatacomfort = ("1 08 1", "31 08 24" , "1"); # start data to retrieve for temps; end data to retrieve for temps.
@retrievedataloads = ("01 02 1", "28 2 24", "1"); # start data to retrieve for loads; end data to retrieve for loads.
@retrievedatatempsstats = ("1 08 1", "31 08 24", "1"); # start data to retrieve for temps; end data to retrieve for temps.
@rankdata = ("n", "n", "n", "y"); # THIS DATA ARE POINT-TO- POINT RELATIVE TO THE ARRAY ABOVE AND TELL WHAT FIELD THE RANKING HAS TO BE BASED ON 
@rankcolumn = (0, 0, 3, 0); # THIS DATA ARE POINT-TO- POINT RELATIVE TO THE ARRAY ABOVE AND TELLS WHAT FILE COLUMN THE RANKING HAS TO BE BASED ON: 3 for max air temps, 5 for min air temps, 7 for mean air temps, 8 for resultant max temps, 10 for resultant min temps, 12 for resultant mean temps - TO DO! DDD
@reporttempsdata = ([$simtitle[0], $simtitle[1]], ["UNUSED"], ["Time", "AmbientdbTmp(degC)", "zonedbT(degC)", "zoneMRT(degC)", "zoneResT(degC)"]); # This is for temperatures.  [$simtitle[0] refers to the first @simtitle, [$simtitle[1] refers to the second @simtitle.  If you have more or less $simtitle(s), you'll have to add or subtract them to this line.  In the last set of square parentheses ("[]") the names of the columns in the report files have to be specified.
@reportcomfortdata = ([$simtitle[0], $simtitle[1]], ["UNUSED"], ["Time", "zonePMV(-)"]); # This is for comfort.  Here in the last set of square parentheses ("[]") the names of the columns in the report files have to be specified.
@reportradiationenteringdata = ([$simtitle[0], $simtitle[1]], ["UNUSED"], ["testzone"]); # This is for radiation entering zone.  Here in the last set of square parentheses ("[]") the names of the columns in the report files have to be specified. ES, bizonal: ["zone1", "zone2", "All"]
@reporttempsstats = ([$simtitle[0], $simtitle[1]], "Ann", ["1"]); # This is for temperatures statistics. Put the zones' number in this array. UPDATE: The only working field is the third. Put there the beginning word of the row you want to filter. Es: "All", or "Jan".
$reportloadsdata = [[$simtitle[0], $simtitle[1]], "Feb", ["1"], "Feb"]; # mixdata y/n,  # "name of the files you want to deal with, if they are not all the existing ones", # list of the the names of the simdata to you want to mix together

@files_to_filter = ("wholenew", "1-2var", "2-3var", 
"3-4var", "4-5var", "1-3var", 
"2-4var", "3-5var", "1-4var",
"2-5var", "1-5var",);
@filter_reports = ( [ [ 2, 3, 4, 5, 1] ],  [ [1, 2] , [3, 4, 5] , [5, 5, 5], [18]],   [ [2, 3] , [1, 4, 5] , [5, 5, 5], [18]],
[ [3, 4] , [1, 2, 5] , [5, 5, 5], [18]], [ [4, 5] , [1, 2, 3] , [5, 5, 5], [18]], [ [1, 3] , [2, 4, 5] , [5, 5, 5], [18]],
[ [2, 4] , [1, 3, 5] , [5, 5, 5], [18]], [ [3, 5] , [5, 5, 5] , [1, 1, 1], [18]], [ [1, 4] , [2, 3, 5] , [5, 5, 5], [18]],
[ [2, 5] , [1, 3, 4] , [5, 5, 5], [18]], [ [1, 5] , [2, 3, 4] , [5, 5, 5], [18]]
  ) ; # for the first [] element: a list of all the variables number; from the second on: varnumbers to report, varnumbers not to report, 
  # casenumber to report among varnumbers not to report, column to extract from tables.
@base_columns = ([], [0, 1, 18], [1, 2, 18], 
[2, 3, 18], [3, 4, 18], [0, 2, 18], 
[1, 3, 18], [2, 4, 18], [0, 3, 18],
[1, 4, 18], [0, 4, 18]); #position of the columns to select to be put in the table in the maketable subroutine. THE ORDER IS: COLUMN, ROW, VALUE in the table to be obtained. ALWAYS THE COLUMN THAT IS BEFORE IN THE TABLE HAS TO BE USED AS ROW.
@maketabledata = ([], [5, 5], [5, 5], 
[5, 5], [5, 5], [5, 5], 
[5, 5], [5, 5], [5, 5],
[5, 5], [5, 5]); # THIS VALUES REGARD THE ORDER ABOVE, STARTING FROM THE FIRST GROUP (THAT IS, FROM THE SECOND POSITION) TO THE SECOND GROUP. THE FIRST POSITION HAS TO BE LEFT BLANK: []!
@filter_columns = (0, 1, 2, 3, 4, 19, 20, 21); #THIS IS OF THE GREATEST IMPORTANCE: (0, 1, 2, 3, 4, 5, 9, 11, 13, 14, 16, 18, 19, 20), IS RIGH FOR TEMPSTASTS. (0, 1, 2, 3, 4, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21); THE LAST COLUMN MUST ALWAYS BE IN, PLUS ONE MORE.

# $counterstep = 1;

@varnumbers = ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 );   # (5, 6, 2, 3, 1, 4); (8, 9, 10, 1, 2, 3, 4, 5, 6, 7);  THESE IS DATUM OF THE GREATEST IMPORTANCE. IT TELLS THE SEQUENCE OF THE CICLES OF TRIES.



$stepsvar1 = 3; # 5; 7 $stepsvar(n) = numer_of_steps_for_this_variable.  This shoulld always better be an odd number since one number is the central one, the default one supplied;
@applytype1 = ( ["surface_translation", "zone.cfg", "zone.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$recalculateish1 = "n"; # "y" or "n". This way ish is launched just at the end of a whole morphing operation, and not at every suboperations componing it.
$general_variables1 = [
"y", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
]; 
$translate_surface1 = # THIS VERSION IS THE MOST ADVISABLE BUT IT HAS STILL TO BE DEVELOPED. THIS NEEDS STILL TO INCORPORATE A CONFIGURATION FILE ON THE EXAMPLE OF sub reshape_windows
[ ["y", # $yes_or_no_transl_surfs: shifts along the surface normal # @applytype111 = ( ["surface_translation", "zone.cfg", "zone.cfg", "a"]);
"a", # transform type: "a" for surface translation along normal, "b" for x y z surface translation
["b", "d"],  #@surfs_to_transl2
[ 1, 1 ] , # @ends_movs, in case of surface_translation_along_normal (example: [2, 2, 2, 2, 2, 2] ), or "x y z" translation if x y z translation of surface (example: ["2  2  2", "2  2  2"]). Relative to the fields above.
"c", # $yes_or_no radiation update : "b" for yes or "c" for no.
[  ], # x y z movs, in case of surface x y z translation
]
];
@apply_constraints1 = (
[
"y", # $yes_or_no_apply_constraints
["/zones/zone.geo"], # source file
["/zones/zone.geo"], # target file
["confile_ams2.pl"], # configuration file for constraints
[216], # base values
[], # swing values: still unused
[ "e", "f", "g", "h", "0\nb\nb" , "0\nb\nd", "0\nb0\nb\nf", "0\nb\n0\nb\nh", "0\nb\n0\nb\nj" ],
"y" # do you long menues for items in ESP-r here? "y" or "n".
]
); # TO DO: RIFARE CON: lettere vertici parete, lettere vertici finestra, piano di lavoro (xz, yz, xy), distanza desiderata della finestra dalla base (o da cosa a cosa, distanza desiderata della finestra dalla sommità (o da cosa a cosa), variabile da ottenere


$stepsvar2 = 3; # 5; 7 $stepsvar(n) = numer_of_steps_for_this_variable.  This shoulld always better be an odd number since one number is the central one, the default one supplied;
@applytype2 = ( ["surface_translation", "zone.cfg", "zone.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$recalculateish2 = "n"; # "y" or "n". This way ish is launched just at the end of a whole morphing operation, and not at every suboperations componing it.
$general_variables2 = [
"y", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
]; 
$translate_surface2 = # THIS VERSION IS THE MOST ADVISABLE BUT IT HAS STILL TO BE DEVELOPED. THIS NEEDS STILL TO INCORPORATE A CONFIGURATION FILE ON THE EXAMPLE OF sub reshape_windows
[ ["y", # $yes_or_no_transl_surfs: shifts along the surface normal # @applytype111 = ( ["surface_translation", "zone.cfg", "zone.cfg", "a"]);
"a", # transform type: "a" for surface translation along normal, "b" for x y z surface translation
["a", "c"],  #@surfs_to_transl2
[ 1, 1 ] , # @ends_movs, in case of surface_translation_along_normal (example: [2, 2, 2, 2, 2, 2] ), or "x y z" translation if x y z translation of surface (example: ["2  2  2", "2  2  2"]). Relative to the fields above.
"c", # $yes_or_no radiation update : "b" for yes or "c" for no.
[  ], # x y z movs, in case of surface x y z translation
]
];
@apply_constraints2 = (
[
"y", # $yes_or_no_apply_constraints
["/zones/zone.geo"], # source file
["/zones/zone.geo"], # target file
["confile_ams2.pl"], # configuration file for constraints
[216], # base values
[], # swing values: still unused
[  "e", "f", "g", "h", "0\nb\nb" , "0\nb\nd", "0\nb\n0\nb\nf", "0\nb\n0\nb\nh", "0\nb\n0\nb\nj"  ],
"y" # do you long menues for items in ESP-r here? "y" or "n".
]
); # TO DO: RIFARE CON: lettere vertici parete, lettere vertici finestra, piano di lavoro (xz, yz, xy), distanza desiderata della finestra dalla base (o da cosa a cosa, distanza desiderata della finestra dalla sommità (o da cosa a cosa), variabile da ottenere

$stepsvar3 = 3; # $stepsvar(n) = numer_of_steps_for_this_variable.  This must always be an odd number since one number is the central one, the default one supplied;
@applytype3 = ( ["warping", "cell.cfg", "cell.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$general_variables3 = [
"y", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
];
$warp3 = [ ["y", # $yes_or_no_warp # @applytype111 = ( ["warping", "zone.cfg", "zone.cfg", "a"]); # THIS OPERATION ROTATES A SURFACE THEN MAKE A VERTEX SHIFT TO LEAVE THE BASE AREA UNCHANGED.
["b", "d"],  #@surfs_to_warp
[2, 2], # @vertexes_around_which_to_rotate
[36, -36] , # @swings_of_rotation
[ "y", "y" ], # $yes_or_no_apply_to_others
"amoeba.configfile.warp1.pl", # configuration file for conditions. # TO COMPLETE
["a" , "d" , "e", "h" , "b" , "c", "f", "g" , "d" , "a" , "h", "e" , "c" , "b", "g", "f" ], # @pairs_of vertexes defining axes
["g", "i"], # windows to reallign
"/zones/zone.geo", # source file
"y" #long menus in ESP-r? "y", "n".
]
];
$recalculateish3 = "n"; # "y" or "n". This way ish is launched just at the end of a whole morphing operation, and not at every suboperations componing it.
@recalculatenet3 = ("n", "cell.afn", [["a"], ["a", "g", "g"], ["a", "h", "g"]]); # "y" or "n"; "path after $mypath", [zone letter; if a wind boundary node, put also: letter_of_surface_in_room, coefficient_set]. BE CAREFUL: after "r" pressure coefficient letters does not work anymore. "g" is semi-exposed long wall.




$stepsvar4 = 3; # $stepsvar(n) = numer_of_steps_for_this_variable.  This must always be an odd number since one number is the central one, the default one supplied;
@applytype4 = ( ["window_reshapement", "cell.cfg", "cell.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$general_variables4 = [
"y", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
]; 
$recalculateish4 = "n"; # "y" or "n". This way ish is launched just at the end of a whole morphing operation, and not at every suboperations componing it.
@recalculatenet4 = ("n", "cell.afn", [["a"], ["a", "g", "g"], ["a", "h", "g"]]); # "y" or "n"; "path after $mypath", [zone letter; if a wind boundary node, put also: letter_of_surface_in_room, coefficient_set]. BE CAREFUL: after "r" pressure coefficient letters does not work anymore. "g" is semi-exposed long wall.
@reshape_windows4 = (
[
[ 
["/zones/zone.geo"], # source file
["/zones/zone.geo"], # target file
["amoeba.reshape_frontwindow.pl"], # configuration file for constraints
[(20/100)], #windows percentage base value
[(10/100)], #windows percentage swing
[ "k", "l", "m", "n"], # vertex letters of the windows to change
["y"] # long menus in ESP-r here? "y" or "n"
]
]
); # TO DO: RIFARE CON: lettere vertici parete, lettere vertici finestra, piano di lavoro (xz, yz, xy), distanza desiderata della finestra dalla base (o da cosa a cosa, distanza desiderata della finestra dalla sommità (o da cosa a cosa), variabile da ottenere

$stepsvar5 = 3; # $stepsvar(n) = numer_of_steps_for_this_variable.  This must always be an odd number since one number is the central one, the default one supplied;
@applytype5 = ( ["window_reshapement", "cell.cfg", "cell.cfg", "a"], ["window_reshapement", "cell.cfg", "cell.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$general_variables5 = [
"y", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
]; 
$recalculateish5 = "n"; # "y" or "n". This way ish is launched just at the end of a whole morphing operation, and not at every suboperations componing it.
@recalculatenet5 = ("n", "cell.afn", [["a"], ["a", "g", "g"], ["a", "h", "g"]]); # "y" or "n"; "path after $mypath", [zone letter; if a wind boundary node, put also: letter_of_surface_in_room, coefficient_set]. BE CAREFUL: after "r" pressure coefficient letters does not work anymore. "g" is semi-exposed long wall.
@reshape_windows5 =  (
[
[ 
["/zones/zone.geo"], # source file
["/zones/zone.geo"], # target file
["amoeba.reshape_rightwindow.pl"], # configuration file for constraints
[(15/100)], #windows percentage base value
[(10/100)], #windows percentage swing
[ "0\nb\nw", "0\nb\nx","0\nb\ny", "0\nb\nz"], # vertex letter of the windows to change
["y"] # long menus in ESP-r here? "y" or "n"
]
],
[
[ 
["/zones/zone.geo"], # source file
["/zones/zone.geo"], # target file
["amoeba.reshape_leftwindow.pl"], # configuration file for constraints
[(15/100)], #windows percentage base value
[(10/100)], #windows percentage swing
[ "o", "p","0\nb\nq", "0\nb\nr"], # vertex letter of the windows to change
["y"] # long menus in ESP-r here? "y" or "n"
]
]
)
; # TO DO: RIFARE CON: lettere vertici parete, lettere vertici finestra, piano di lavoro (xz, yz, xy), distanza desiderata della finestra dalla base (o da cosa a cosa, distanza desiderata della finestra dalla sommità (o da cosa a cosa), variabile da ottenere


$stepsvar6 = 3; # $stepsvar(n) = numer_of_steps_for_this_variable.  This must always be an odd number since one number is the central one, the default one supplied;
@applytype6 = ( ["window_reshapement", "cell.cfg", "cell.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$general_variables6 = [
"y", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
]; 
@reshape_windows6 =  (
[
[ 
["/zones/zone.geo"], # source file
["/zones/zone.geo"], # target file
["amoeba.reshape_backwindow.pl"], # configuration file for constraints
[(15/100)], #windows percentage base value
[(10/100)], #windows percentage swing
[ "0\nb\ns", "0\nb\nt","0\nb\nu", "0\nb\nv"], # vertex letter of the windows to change
["y"] # long menus in ESP-r here? "y" or "n"
]
]
);


$stepsvar7 = 3; # 5; 7 $stepsvar(n) = numer_of_steps_for_this_variable.  This shoulld always better be an odd number since one number is the central one, the default one supplied;
@applytype7 = ( ["translation", "zone.cfg", "zone.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$general_variables7 = [
"y", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
];
$translate7 = [ ["y", #yes_or_no_translate # @applytype111 = (["translation", "zone.geo", "zone.geo", "a"]);
"n", # $yes_or_no_translate_obstructions
["9", "0", "0"], # give the coordinates for one extreme of the swing.  The other one will be simmetrical along the line.
"c", # update radiation calculation with the "ish" module?  "a" for yes and "c" for no, continue.
"" # configuration file for conditions
] ];



$stepsvar8 = 3; # 5; 7 $stepsvar(n) = numer_of_steps_for_this_variable.  This shoulld always better be an odd number since one number is the central one, the default one supplied;
@applytype8 = ( ["translation", "zone.cfg", "zone.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$general_variables8 = [
"y", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
];
$translate8 = [ ["y", #yes_or_no_translate # @applytype111 = (["translation", "zone.geo", "zone.geo", "a"]);
"n", # $yes_or_no_translate_obstructions
["0", "6", "0"], # give the coordinates for one extreme of the swing.  The other one will be simmetrical along the line.
"c", # update radiation calculation with the "ish" module?  "a" for yes and "c" for no, continue.
"" # configuration file for conditions
] ];



$stepsvar9 = 5; # 5; 7 $stepsvar(n) = numer_of_steps_for_this_variable.  This shoulld always better be an odd number since one number is the central one, the default one supplied;
@applytype9 = ( ["rotation", "zone.cfg", "zone.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$general_variables9 = [
"y", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
];
$rotate9 = [ ["y",  # yes or no rotate # @applytype111 = (["rotation", "zone.geo", "zone.geo", "a"]);
"n", # $yes_or_no_rotate_obstruction: 	"y" o "n"						
"90", # swingrotate
"c", # update radiation calculation with the "ish" module?  "b" for yes and "c" for no, continue.
"a", #vertex around which to rotate
"undef" # configuration file for conditions. UNUSED FOR NOW.
] ];
$recalculateish9 = "y"; # "y" or "n". This way ish is launched just at the end of a whole morphing operation, and not at every suboperations componing it.
@recalculatenet9 = ("y", # "y" or "n"; PRESENTLY THIS PROCEDURES WORKS ONLY FOR A SINGLE ZONE, BECAUSE I DON'T HAVE TEH TIME YET TO IMPLEMENT IT BETTER    $counterzone FOR IT.
"cell.afn", # "path after $mypath", 
[["a"]], # zone letter of zone node. 
[["a"], ["a", "g", "g"], ["a", "h", "g"], ["a", "i", "g"], ["a", "j", "g"]], # zone letter (if zone) or: wind boundary node, letter_of_surface_in_room, coefficient_set. # BE CAREFUL: after "o" (exposed long wall) pressure coefficient letters does not work anymore. "g" is semi-exposed long wall.
"/zones/zone.geo", # source file
"confile_ams2n_recalculatenet7.pl", # configuration file for constraints
"y", # "YES OR NO" reassign wind coefficient value dependent from surface proximity to the urban objects  # THE PROGRAM WILL AUTOMATICCALLY CHECK FOR SIGNIFICANT POINTS OF URBAN OBSTRUCTION WHOSE VICINITY HAVE TO BE CHECKED
"n", # "YES OR NO" auto-detect the obstruction points' position. WARNING: THE "y" OPTION IS STILL TO BE IMPLEMENTED!
[ [30, 10, 30], [40, 10, 30], [43, 20, 18], [43, 30, 18], [15, 8, 15], [20, 8, 15] , [5, 10, 10], [10, 10, 10], [4, 15, 8], [4, 20, 8], [3, 30, 27], [3, 31, 27]], #OSTRUCTION POINTS' COORDINATES (JUST UPPER, NOT BASE. AND JUST ABOUT THE FACES FaCING THE MODEL.
# THESE ARE NECESSARY ONLY IF "n" in the previous point is chosen. UNTIL THE FUNCTION IS NOT IMPLEMENTED, YOU'LL HAVE TO WRITE THE OBSTRUCTION COORDINATES HERE.
[0.1, 0.1, 0.1, 0.1] # cracks' width, relative to zone letter of wind boundary nodes, point to point, one by one. THIS HAVE TO BE CORRECTED. THE CRACK WIDTH HAVE TO BE READ FROM THE CONFIG FILE, NOT SPECIFIED IN ADVANCE HERE. AFTER THAT, A SUBROUTINE TO VARY THESE VALUES HAS TO BE WRITTEN. THIS STILL HAVE TO BE DONE
);
@daylightcalc9 = ("n", # yes or no compute daylight factors. EVEN THIS FUNCTION PRESENTLY WORKS ONLY FOR A SINGLE ZONE, SINCE I HAD NO TIME TO IMPLEMENT IT BETTER.
"a", # zone letter
"f", # surface with respect to which daylight factors have to be calculated
"a", # "a" for Inside, "b" for Outside: what daylight factor have to be calculated with respect to
"f", # edge with respect to which the first row has to be calculated
"0.9", # distance from surface
"1 2", #  grid layout density
"5", # level of accuracy, for convergence in calculations
"cell_Day_fa.df" #name of daylight factor file
);



$stepsvar10 = 3; # 5; 7 $stepsvar(n) = numer_of_steps_for_this_variable.  This shoulld always better be an odd number since one number is the central one, the default one supplied;
@applytype10 = ( ["construction_reassignment", "zone.cfg", "zone.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$general_variables10 = [
"n", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
];
$construction_reassignment10 =  [ ["y", # $yes_or_no_modify_construction # @applytype111 = (["construction_reassignment", "zone.geo", "zone.geo", "a"]);
["a", "b", "c", "d", "e", "f" , "k", "l", "m", "n", "o", "p", "q", "r" ], # @surfaces_to_reassign 
[["b", "d", "g", "h"], ["b", "d", "g", "h"], ["b", "d", "g", "h"], ["b", "d", "g", "h"], 
["b", "d", "g", "h"], ["b", "d", "g", "h"] , ["b", "0\nu", "0\nv", "0\nw"] , ["b", "0\nu", "0\nv", "0\nw"], ["b", "0\nu", "0\nv", "0\nw"], ["b", "0\nu", "0\nv", "0\nw"], 
["b", "0\nu", "0\nv", "0\nw"], ["b", "0\nu", "0\nv", "0\nw"], ["b", "0\nu", "0\nv", "0\nw"], ["b", "0\nu", "0\nv", "0\nw"]], 
# @constructions_to_choose (letter combination, here!!)
"unused" # configuration file for conditions
] ]; # ["d",  "e", "f", "g", "i","h", "j"],




####------------------------------ ####------------------------------ ####------------------------------
####------------------------------ ####------------------------------ ####------------------------------
####------------------------------ ####------------------------------ ####------------------------------
### HERE FOLLOWS THE COMPLETE LIST OF VARIABLES LINKED TO MORPHING PROCEDURES

$rotate111 = [ ["y",  # yes or no rotate # @applytype111 = (["rotation", "zone.geo", "zone.geo", "a"]);
"n", # $yes_or_no_rotate_obstruction: 	"y" o "n"						
"90", # swingrotate
"c", # update radiation calculation with the "ish" module?  "b" for yes and "c" for no, continue.
"m", #vertex around which to rotategreen4_+5-1_+6-1_+2-1_+3-1_+1-1_+4-1
"configfile.rotate111.pl" # configuration file for conditions
] ];

$translate111 = [ ["y", #yes_or_no_translate # @applytype111 = (["translation", "zone.geo", "zone.geo", "a"]);
"n", # $yes_or_no_translate_obstructions
["0", "3", "0"], # give the coordinates for one extreme of the swing.  The other one will be simmetrical along the line.
"c", # update radiation calculation with the "ish" module?  "a" for yes and "c" for no, continue.
"configfile.translate111.pl" # configuration file for conditions
] ];

$construction_reassignment111 =  [ ["y", # $yes_or_no_modify_construction # @applytype111 = (["construction_reassignment", "zone.geo", "zone.geo", "a"]);
["a", "b", "d", "e", "k", "l", "m", "n", "0\nw", "0\nx"], # @surfaces_to_reassign 
[["d", "f", "h"], ["d", "f", "h"], ["d", "f", "h"], ["d", "f", "h"], 
["d", "f", "h"], ["d", "f", "h"],  ["d", "f", "h"],  ["d", "f", "h"], 
 ["d", "f", "h"], ["d", "f", "h"] ], # @constructions_to_choose (letter combination, here!!)
"configfile.reassign_construction111.pl" # configuration file for conditions
] ]; # ["d",  "e", "f", "g", "i","h", "j"],

@translate_vertexes111 = ( [ # STILL UNFINISHED, NOT WORKING. PROBABLY ALMOST FINISHED. ON THE BRINK OF IT. The reference to @base_coordinates is not working # @applytype111 = ( ["vertex_translation", "zone.cfg", "zone.cfg", "a"]);
[ "a", "i", "0\ny", "j",  "b", "f", "k", "l", "e",      "d", "0\nr", "0\na", "0\nq", "c", "g", "0\nt", "0\ns", "h" ],  # @vertexes_to_transl, Consider that after "p" you have to write "0\nq".
[ [0, 2, 0], [0, 2, 0], [0, 2, 0], [0, 2, 0], [0, 2, 0], [0, 2, 0], [0, 2, 0], [0, 2, 0], [0, 2, 0],    [0, -2, 0], [0, -2, 0], [0, -2, 0], [0, -2, 0], [0, -2, 0], [0, -2, 0], [0, -2, 0], [0, -2, 0], [0, -2, 0] ], # x y z movs, in case of surface x y z translation
["/zones/zone.geo"], # source file
["/zones/zone.geo"], # target file
"configfile.translate_vertexes111.pl", # configuration file for conditions
"y" # apply long menus in ESP-r? "y" or "n".
]
);

$rotate_surface111 = [ ["y", # $yes_or_no_rotate_surf around a vertex # @applytype111 = ( ["surface_rotation", "zone.cfg", "zone.cfg", "a"]);
["b", "d"],  #@surfs_to_rotate
[10, 12], # @vertexes_around_which_to_rotate
[30, 30] , # @swings_of_rotation
[ "y", "y" ], # $yes_or_no_apply_to_others
"configfile.rotate_surfaces111.pl" # configuration file for conditions. # TO COMPLETE
]
];

$shift_vertexes111 = # @applytype111 = ( ["vertexes_shift", "zone.cfg", "zone.cfg", "a"]);
[ 
["y", # $yes_or_no_shift_surface. "y" or "n".  it turns on and off the related function.
"j", # movement type: "j": shift vertexes along a line. "h": align vertexes with a line.
["e" , "p" , "m", "l" , "i" , "n", "f", "j" ], # @pairs_of vertexes defining axes
[2, 2, 2, 2], # $shift_movements
"c", # $yes_or_no radiation update : "b" for yes or "c" for no.
"configfile.shift_vertexes111.pl" # configuration file for conditions
]
];

$obs_modify111= ( [   # @applytype111 = (["obs_modification",trans "cell.geo", "cell.geo", "a"], ["obs_modification", "cell.geo", "cell.geo", "a"]);
[ 
["i","j", "k", "l"], # letters of the obstructions to modify
"c",  # what to modify: "a" for origin, "b" for dimensions, "c" for z_rotation, "d" for y_rotation, "g" for construction, "h" for opacity, "t" for transform. That care, because the first shading, that is "e" in the other transformation operations, in transforms is "a". "a" in the 					
[45 ], # enter value or values corresponding to the above. If origin coordinates of one extreme of the translation. If dimensions: x y z of dimensions. If rotation: swing of the rotation. If construction:construction name. If opacity: percentage of opacity.
[180], # if origin: base x y z origin. If dimensions: base x y z dimensions. If rotations: start rotation. If opacity: base opacity. if transform: "a" for rotation, "b" for transform.
"configfile.obs_modify111.pl" # configuration file for conditions
]
]);#TAKE CARE: THE DIFFERENT ZONE DATA ARE BETWEEN ([]) in obs_modify. THAT IS, TO TAKE INTO ACCOUNT TWO ZONE, YOU HAVE TO DO THIS: ([ [something], [sometjing_else] ]).

$rotatez111 = ["y", #  #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), ES: @applytype1 = (["generic_change", "zona1.geo", "zona1.geo", "a"]).  The possibilities regarding changes are: "generic_change", "surface_translation", "vertexes_shift", "construction_reassignment", "rotation", "translation",  "thickness_change",  "climate_change", "construction_modification".
# THIS ROUTINE KEEPS THE OBSTRUCTIONS STILL AND ROTATE THE ZONE(S) ON THE ALTITUDE ANGLE.  IT DOES NOT PASS THROUGH ESP-R.  IT JUST MANAGES THE .GEO CONFIGURATION FILE.
[0.7, 0.7, 0.02], # x, y (or x) and z of the point that is the center of the axis rotation
"x", #plane of rotation: x or y
90, #swingrotation of plane xy
0, #rotation already had by the zone with respect to the x axis
# 0, #rotation on plane yz - TO DO
# 0, #swing for the rotation on plane xy - TO DO
];

$thickness_change111 = [ ["n", # $yes_or_no_change_thickness # @applytype111 = ( ["thickness_change", "zone.cfg", "zone.cfg", "a"]); 
[a, b, c], # @entries_to_change: construction database entries to change
[[i, j], [a, b], [k] ], # @groups_of_strata_to_change, containing @strata_to_change: strata to change for each entry. There is a correspondence with the above.
[ [ [10, 20] , [20, 50] ], [ [20, 60] , [10, 40] ], [ [20, 50 ]]],
"configfile.change_thickness111.pl" # configuration file for conditions
] ]; # @groups_of_pairs_of_min_max_values, containing @min_max_values: min and max values for each change above.  There is a two to one correnspondence of the values below with the above. 
# To specify constraints for some variable's variations, the "hook" to the principal changing variable in code here is the variable $thickness, which is the variation at each time step.

@generic_change111 = ([ [  # FILL THIS SEQUENCE OF DATA IF IT IS COVERED BY THE $stepsvars' RUNS # @applytype111 = (["generic_change", "zona1.geo", "zona1.geo", "a"])
["-", 4, # ([["-", numer_of_row_to_modify, 
[18, 7, 0.5, 5], # [1st-field-of_the_text_area_to_modify, 1st-field-length, 1st-f-variable's-swing, 1st-f-number_of_decimals],
[0, 0, 0, 0],  # [nth-field-of_the_text_area_to_modify, nth-field-length, nth-f-variable's-swing, nth-f-number_of_decimals],
[0, 0, 0, 0]], # [last-field-of_the_text_area_to_modify, last-field-length, last-f-variable's-swing, last-f-number_of_decimals],
["-", 5, # ([["-", numer_of_row_to_modify, 
[0, 0, 0, 0], # [1st-field-of_the_text_area_to_modify, 1st-field-length, 1st-f-variable's-swing, 1st-f-number_of_decimals],
[0, 0, 0, 0], # [nth-field-of_the_text_area_to_modify, nth-field-length, nth-f-variable's-swing, nth-f-number_of_decimals],
[0, 0, 0, 0]], # [last-field-of_the_text_area_to_modify, last-field-length, last-f-variable's-swing, last-f-number_of_decimals],
["-", 8, # ([["-", numer_of_row_to_modify, 
[0, 0, 0, 0], # [1st-field-of_the_text_area_to_modify, 1st-field-length, 1st-f-variable's-swing, 1st-f-number_of_decimals],
[0, 0, 0, 0], # [nth-field-of_the_text_area_to_modify, nth-field-length, nth-f-variable's-swing, nth-f-number_of_decimals],
[0, 0, 0, 0]], # [last-field-of_the_text_area_to_modify, last-field-length, last-f-variable's-swing, last-f-number_of_decimals],
] ]); 

$keep_obstructions111 = [ [
"n", # $yes_or_no_keep_some_obstructions  
[["e", "0", "0", "-7", "-20", "0"],
["f", "0", "90", "32", "-8", "0"],
["g", "0", "90", "-17", "-9", "0"]],
"y", # "y" for yes or "n" for no update radiation calculation with "ish"
"configfile.keep_obstructions111.pl" # configuration file for conditions
] ]; # TO BE REWRITTEN

$general_variables111 = [
"n", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
]; 

$recalculateish111 = "n"; # "y" or "n". This way ish is launched just at the end of a whole morphing operation, and not at every suboperations componing it.

@recalculatenet111 = ("n", # "y" or "n";
"cell.afn", # "path after $mypath", 
[["a"], ["a", "g", "g"], ["a", "h", "g"]]); #  [zone letter; if a wind boundary node, put also: letter_of_surface_in_room, coefficient_set]. BE CAREFUL: after "r" pressure coefficient letters does not work anymore. "g" is semi-exposed long wall.

@reshape_windows111 = (
[
[ 
["/zones/zone.geo"], # source file
["/zones/zone.geo"], # target file
["amoeba.reshape_frontwindow.pl"], # configuration file for constraints
[(40/100)], #windows percentage base value
[(30/100)], #windows percentage swing
[ "k", "l", "m", "n"], # vertex number of the windows to change
["y"] # long menus in ESP-r here? "y" or "n"
]
]
); # TO DO: RIFARE CON: lettere vertici parete, lettere vertici finestra, piano di lavoro (xz, yz, xy), distanza desiderata della finestra dalla base (o da cosa a cosa, distanza desiderata della finestra dalla sommità (o da cosa a cosa), variabile da ottenere

@apply_constraints111 = (
[ 
"n", # $yes_or_no_apply_constraints
["/zones/zone.geo"], # source file
["/zones/zone.geo"], # target file
["cellconstruction.apply_constraints111.pl"], # configuration file for constraints
[90], # base values
[], # swing values: still unused
["e", "f", "g", "h", "k", "l", "o", "p", "s", "t", "w", "x"],
"y" # do you long menues for items in ESP-r here? "y" or "n".
]
); # TO DO: RIFARE CON: lettere vertici parete, lettere vertici finestra, piano di lavoro (xz, yz, xy), distanza desiderata della finestra dalla base (o da cosa a cosa, distanza desiderata della finestra dalla sommità (o da cosa a cosa), variabile da ottenere

@apply_windowconstraints111 = ( # TO DO
[
[ 
["/zones/zone.geo"], # source file
["/zones/zone.geo"], # target file
["cellconstruction.apply_windowconstraints111.pl"], # configuration file for constraints
[(40/100)], #windows percentage base value
"y" # yes_or_no_apply_windowconstraints
]
]
); # TO DO: RIFARE CON: lettere vertici parete, lettere vertici finestra, piano di lavoro (xz, yz, xy), distanza desiderata della finestra dalla base (o da cosa a cosa, distanza desiderata della finestra dalla sommità (o da cosa a cosa), variabile da ottenere

@apply_netconstraints111 = (
[
[ 
["/zones/zone.geo"], # source file
["/zones/zone.geo"], # target file
["cellconstruction.apply_netconstraints111.pl"], # configuration file for constraints
[1], #windows  base value, 1
[1], #windows base value, 2
"y" #yes_or_no_apply_netconstraints
]
]
); # TO DO: RIFARE CON: lettere vertici parete, lettere vertici finestra, piano di lavoro (xz, yz, xy), distanza desiderata della finestra dalla base (o da cosa a cosa, distanza desiderata della finestra dalla sommità (o da cosa a cosa), variabile da ottenere

@apply_constraints_rotate_surface111 = ( #TO DO
[
[ 
["/zones/zone.geo"], # source file
["/zones/zone.geo"], # target file
["cellconstruction.apply_constraints111.pl"], # configuration file for constraints
[100], # base value
"y" # $yes_or_no_apply_constraints
]
]
); # TO DO: RIFARE CON: lettere vertici parete, lettere vertici finestra, piano di lavoro (xz, yz, xy), distanza desiderata della finestra dalla base (o da cosa a cosa, distanza desiderata della finestra dalla sommità (o da cosa a cosa), variabile da ottenere

@applytype111 = (["changeconfig", "basetestdonothing.cfg", "basetest.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 

# TO DO: warp function (with apply_constraint for windows)

$warp111 = [ ["y", # $yes_or_no_warp # @applytype111 = ( ["warping", "zone.cfg", "zone.cfg", "a"]); # THIS OPERATION ROTATES A SURFACE THEN MAKE A VERTEX SHIFT TO LEAVE THE BASE AREA UNCHANGED.
["b", "d"],  #@surfs_to_warp
[2, 2], # @vertexes_around_which_to_rotate
[60, -60] , # @swings_of_rotation
[ "y", "y" ], # $yes_or_no_apply_to_others
"configfile.warp111.pl", # configuration file for conditions. # TO COMPLETE
["a" , "d" , "e", "h" , "b" , "c", "f", "g" , "d" , "a" , "h", "e" , "c" , "b", "g", "f" ], # @pairs_of vertexes defining axes
["g", "i"], # windows to reallign
"/zones/zone.geo", # source file
"y" #long menus in ESP-r? "y", "n".
]
];

$translate_surface_simple111 = [ ["y", # $yes_or_no_transl_surfs: shifts along the surface normal
["b", "d"],  #@surfs_to_transl2
[1.4, 1.4, 1.4, 1.4] , # @ends_movs2
"c", # $yes_or_no radiation update : "b" for yes or "c" for no.
[ 6, 6 ], # This is aimed to constrained increments of the base dimensions (rectangular) in the case the base area has to be kept fixed:  first edge length, second edge length
["a", "c"], #@surfs_to_transl-constrained, in the case in which the base area is fixed.
]
];

$translate_surface111 = # THIS VERSION IS THE MOST ADVISABLE BUT IT HAS STILL TO BE DEVELOPED. THIS NEEDS STILL TO INCORPORATE A CONFIGURATION FILE ON THE EXAMPLE OF sub reshape_windows
[ ["y", # $yes_or_no_transl_surfs: shifts along the surface normal # @applytype111 = ( ["surface_translation", "zone.cfg", "zone.cfg", "a"]);
"a", # transform type: "a" for surface translation along normal, "b" for x y z surface translation
["g", "a", "h", "m",  "c", "j"],  #@surfs_to_transl2
[ -2, -2, -2, -2, -2, -2, -2,  -2 ] , # @ends_movs, in case of surface_translation_along_normal (example: [2, 2, 2, 2, 2, 2] ), or "x y z" translation if x y z translation of surface (example: ["2  2  2", "2  2  2"]). Relative to the fields above.
"c", # $yes_or_no radiation update : "b" for yes or "c" for no.
[ [0, 2, 0], [0, 2, 0], [0, 2, 0], [0, 2, 0], [0, 2, 0], [0, 2, 0] ], # x y z movs, in case of surface x y z translation
]
];


@daylightcalc111 = ("y", #yes or no compute daylight factors. EVEN THIS FUNCTION PRESENTLY WORKS ONLY FOR A SINGLE ZONE, SINCE I HAD NO TIME TO IMPLEMENT IT BETTER.
"a", # zone letter
"f",
"2 2", #  grid layout
);


1;


