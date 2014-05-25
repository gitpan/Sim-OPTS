#! /usr/bin/perl
#THIS IS AN OPTS CONFIGURATION FILE

#######################################################################################################
# BELOW FOLLOWS A SECTION TO CONFIGURE BLOCK SEARCH
$blocksearch = "y"; # say yes of you want to perform a block search optimization. Say "no" if you want to make a brute force optimization.
$ordercolumn = ""; # FOR SUB GETDATA
$comparecolumn = ""; # FOR SUB GETDATA
$number_of_bests = "";
$parnumber = 3; #number of parameters.
$wholeresultsfile = "";
$take_column_inresults = 14; # UNUSED
$absmax = "";
$absmin = "";
# $varsnum;

@varn = ( [ [1, 2, 3, 4] ] );
$chancefile; 
$reportfile = "";
$steps = 3;
@midvalues = (2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2); 

@casegroup = ( [ [4, 4] ] ) ;
$casegroupfile;

# END OF THE SECTION TO CONFIGURE BLOCK SEARCH
#######################################################################################################

$file = "ame";  # Write here the root model directory.  This will remain unchanged. THIS NOW IS DONE VIA KEYBOARD THROUGH THE EXECUTABLE.
$configfileinsert = ""; # "./erase_first_ams2e.pl";
@dowhat = ( "y", # 1) Create cases for simulation: morph.
"y", # 2) simulate
"y", # 3) retrieve
"n", # 4) erase res and .fl file as they are created or not
"n", # 5) report. OBSOLETE. DON'T USE.
"y", # 6) merge reports
"n", # 7) name variables in non-filtered reports (convert reports)
"n", # 8) filter already converted reports
"n", # 9) make table to be plotted in 3D
"n", # 10) convert filtered and make-tabled reports
"n" ); #
# This variables tell to the program what to do.  1) Create cases for simulation; 
# 2) simulate AND retrieve; 3) retrieve data; 4) erase res and .fl file as they are created or not 5) report; 6) merge reports; NOTE: THIS IS NOT UNUSEFUL WITH LOADS AND TEMPS STATS REPORTS. IT HAS TO BE OFF. IT IS A NEW FEATURE NOT YET IMPLEMENTED FOR OTHER VARIABLES
# 7) substitute names (convert) in non-filtered reports, 8) filter already converted reports, 9) make table to be plotted in 3D; 
# 10) convert filtered and make-tabled reports,.$homepath = "/home/luca";

$exeonfiles = "y";

$preventsim = "n"; # prevent simulation, just retrieve

$mypath= "/home/luca/optsworks"; # Write here the path of the directory in which you are going to work
$homepath= "/home/luca/optsworks";
$fileconfig=("cellw.cfg"); # Write here the name of the configuration file of you model

$outfile = "/home/luca/optsworks/$file-$fileconfig.feedback.txt"; # Write here the name of the files in which reports will be printed in order to check the inner working of the program.  In order to do this, you'll have to mess up with the code to specify what you want to be printed.
$toshell = "/home/luca/optsworks/$file-$fileconfig.feedbacktoshell.txt"; # Write here the name of the files in which the output to the shell will be printed in order to check the inner working of the program.  In order to do this, you'll have to mess up with the code to specify what you want to be printed.

@themereports = ([ "loads", "tempsstats"], [ "loads", "tempsstats"]); # possibilities: "loads", "temps" , "comfort", "tempsstats" ######### General themes regarding the simulation.  This piece of information go to compose the result name files.
@simtitles = ("mar1-apr30"); # write here the name of the time periods will be taken into account in the simulations.
@reporttitles = ( ["march1-31", "march1-31"], ["april1-30", "april1-30"] ); # THESE ARE THE PERIODS TO BE REPORTED. THERE IS A POINT TO POINT CORRENSPONDENCE WITH @simtitles
@simdata=(["1 3", "30 4", "20", "1"]
#, ["1 4", "30 4", "20", "1"]
); # Here put the data this way: "starting-month_1 starting-day_1", "ending-month_1 ending-day_1", "start-up-period-duration_1", "time/steps-hour_1", "starting-month_2"starting-day_2", "ending-month_2 ending-day_2", "start-up-period-duration_2", "time/steps-hour_2", ..., "starting-month_n starting-day_n", "ending-month_n ending-day_n", "start-up-period-duration_n", "time/steps-hour_n"
# THESE ARE THE PERIODS TO BE REPORTED. THERE IS A POINT TO POINT CORRENSPONDENCE WITH @simdata
$simnetwork = "y"; # "n" id there is no mass/flow network. This information regards the simulation settings.
@retrievedata = ( 
[["1 3 1", "31 3 24", "1"] , ["1 3 1", "31 3 24", "1"]], [["1 4 1", "30 4 24", "1"] , ["1 4 1", "30 4 24", "1"]]
); # start data to retrieve for temps; end data to retrieve for temps.
# THESE ARE THE PERIODS TO BE REPORTED. THERE IS A POINT TO POINT CORRENSPONDENCE WITH @reporttiles# THESE ARE THE PERIODS TO BE REPORTED. THERE IS A POINT TO POINT CORRENSPONDENCE WITH @simdata# THESE ARE THE PERIODS TO BE REPORTED. THERE IS A POINT TO POINT CORRENSPONDENCE WITH @simdata

@keepcolumns = ( [1, 6], [16, 18] ); # COLUMNS TO KEEP FROM THE FILE OF RESULTS. THEY ARE WRITTEN IN PAIRS. 
# THE FIRST ITEM OF EACH PAIR IS THE OBJECTIVE FUNCTION NAME AND THE SECOND IS THE OBJECTIVE FUNCTION.
@weights = ( -0.5, 0.5); # RATIOS OF EACH OBJECTIVE FUNCTION OVER THE TOTAL OF ONE.
# IF A WEIGHT IS ASSIGNED A NEGATIVE VALUE, THE SIGN OF THE CORRESPONDING OBJECTIVE FUNCTION IS INVERTED, BY MULTIPLYING IT FOR (-1). 
@weightsaim = (1, -1); # THERE IS A POINT TO POINT CORRENSPONDENCE WITH THE ABOVE ARRAY. A (-1) VALUE TELLS THE PROGRAM THAT THE OBJECTIVE FOR THAT OBJECTIVE FUNCTION IS MINIMIZATION. 
# A (+1) VALUE TELLS THE PROGRAM THAT THE OBJECTIVE IS MAXIMIZATION. 


@varthemes_report = (
"rotation_zy", "rotation_xy","albedo_terrace", "albedo_side_wall"
); ########## Definitions that are going to substitute the variable numbers in the tables. (THIS OPERATION MAY OFTEN BE UNUSED.)
@varthemes_variations = ([-9, 9], [-6, 6],[-2, 2] , [-30, 30],[-30, 30],[-30, 30],[-30, 30], [-1, 1]); ######### Minimum and maximum values regarding the variables, in the same order above.
@varthemes_steps = (3, 3);  #########(3, 1, 1, 1, 1, 1);   (7, 5, 5, 5, 5, 3); The number of steps allowed for each variables. In the same order above.

@reporttempsdata = ([$simtitle[0], $simtitle[1]], ["UNUSED"], ["Time", "AmbientdbTmp(degC)", "zonedbT(degC)", "zoneMRT(degC)", "zoneResT(degC)"]); # This is for temperatures.  [$simtitle[0] refers to the first @simtitle, [$simtitle[1] refers to the second @simtitle.  If you have more or less $simtitle(s), you'll have to add or subtract them to this line.  In the last set of square parentheses ("[]") the names of the columns in the report files have to be specified.
@reportcomfortdata = ([$simtitle[0], $simtitle[1]], ["UNUSED"], ["Time", "zonePMV(-)"]); # This is for comfort.  Here in the last set of square parentheses ("[]") the names of the columns in the report files have to be specified.
@reportradiationenteringdata = ([$simtitle[0], $simtitle[1]], ["UNUSED"], ["testzone"]); # This is for radiation entering zone.  Here in the last set of square parentheses ("[]") the names of the columns in the report files have to be specified. ES, bizonal: ["zone1", "zone2", "All"]
@stripchecks = ( ["zone", "Ann"], ["zone", "Ann"] ) ;

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

# @varnumbers = ( 1, 2 );   # (5, 6, 2, 3, 1, 4); (8, 9, 10, 1, 2, 3, 4, 5, 6, 7);  THESE IS DATUM OF THE GREATEST IMPORTANCE. IT TELLS THE SEQUENCE OF THE CICLES OF TRIALS. IT IS THE LIST OF THE VARIABLES IN PLAY.

$stepsvar1 = 3; # 5; 7 $stepsvar(n) = numer_of_steps_for_this_variable.  This shoulld always better be an odd number since one number is the central one, the default one supplied;
@applytype1 = ( ["translation", "zone.cfg", "zone.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$general_variables1 = [
"y", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
];
$translate1 = [ ["y", #yes_or_no_translate # @applytype111 = (["translation", "zone.geo", "zone.geo", "a"]);
"n", # $yes_or_no_translate_obstructions
["9", "0", "0"], # give the coordinates for one extreme of the swing.  The other one will be simmetrical along the line.
"c", # update radiation calculation with the "ish" module?  "a" for yes and "c" for no, continue.
"" # configuration file for conditions
] ];



$stepsvar2 = 3; # 5; 7 $stepsvar(n) = numer_of_steps_for_this_variable.  This shoulld always better be an odd number since one number is the central one, the default one supplied;
@applytype2 = ( ["translation", "zone.cfg", "zone.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$general_variables2 = [
"y", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
];
$translate2 = [ ["y", #yes_or_no_translate # @applytype111 = (["translation", "zone.geo", "zone.geo", "a"]);
"n", # $yes_or_no_translate_obstructions
["0", "6", "0"], # give the coordinates for one extreme of the swing.  The other one will be simmetrical along the line.
"a", # update radiation calculation with the "ish" module?  "a" for yes and "c" for no, continue.
"" # configuration file for conditions
] ];

$stepsvar3 = 3; # 5; 7 $stepsvar(n) = numer_of_steps_for_this_variable.  This shoulld always better be an odd number since one number is the central one, the default one supplied;
@applytype3 = ( ["translation", "zone.cfg", "zone.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$general_variables3 = [
"y", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
];
$translate3 = [ ["y", #yes_or_no_translate # @applytype111 = (["translation", "zone.geo", "zone.geo", "a"]);
"n", # $yes_or_no_translate_obstructions
["0", "0", "2"], # give the coordinates for one extreme of the swing.  The other one will be simmetrical along the line.
"c", # update radiation calculation with the "ish" module?  "a" for yes and "c" for no, continue.
"" # configuration file for conditions
] ];

$stepsvar4 = 2; # 5; 7 $stepsvar(n) = numer_of_steps_for_this_variable.  This shoulld always better be an odd number since one number is the central one, the default one supplied;
@applytype4 = ( ["rotation", "zone.cfg", "zone.cfg", "a"]); #  @applytype(n) = (["type_of_change", "your_test_file", "file_name_to_which_the_former_will_be_copied_to", "zone_letter"]), 
$general_variables4 = [
"n", # $generate(n) eq "n" # (if the models deriving from this runs will not be generating new models) or y (if they will be generating new models).
"n" #if $sequencer eq "y", or "last" (of a sequence) iteration between non-continuous cases wanted.  The first gets appended to the middle(s) and to he last. Otherwise, "n".
];
$rotate4 = [ ["y",  # yes or no rotate # @applytype111 = (["rotation", "zone.geo", "zone.geo", "a"]);
"n", # $yes_or_no_rotate_obstruction: 	"y" o "n"						
"90", # swingrotate
"a", # update radiation calculation with the "ish" module?  "b" for yes and "c" for no, continue.
"a", #vertex around which to rotate
"undef" # configuration file for conditions. UNUSED FOR NOW.
] ];
$recalculateish4 = "n"; # "y" or "n". This way ish is launched just at the end of a whole morphing operation, and not at every suboperations componing it.

1;





