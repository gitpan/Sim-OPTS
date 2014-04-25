#!/usr/bin/perl

# Copyright: Gian Luca Brunetti and Politecnico di Milano, 2008-2014
# email gianluca.brunetti@polimi.it
# This is a part of the Sim::OPTS Perl module.
# OPTS is made to manage parametric explorations through the use of the ESP-r building energy performance simulation platform.  
# This is free software.  You can redistribute it and/or modify it under the terms of the GNU General Public License 
# as published by the Free Software Foundation, version 2.

# package OPTS;

## HERE FOLLOW THE "report", "retrieve" and "merge" FUNCTIONS, CALLED FROM THE MAIN PROGRAM FILE.

##############################################################################
##############################################################################
##############################################################################
# HERE FOLLOWES THE CONTENT OF THE "opts_report.pl" FILE, WHICH HAS BEEN MERGED HERE
# TO AVOID COMPLICATION WITH THE PERL MODULE INSTALLATION.

## HERE THE "report", "retrieve" and "merge" FUNCTIONS FOLLOW, CALLED FROM THE MAIN PROGRAM FILE.
package Sim::OPTS::report;

no strict; 
no warnings;
use lib "../../";

@ISA = qw(Exporter); # our @ISA = qw(Exporter);
@EXPORT = qw( &report &merge_reports );

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

1;
