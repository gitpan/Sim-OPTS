#!/usr/bin/perl

# Copyright: Gian Luca Brunetti and Politecnico di Milano, 2008-2014
# email gianluca.brunetti@polimi.it
# OPTS is made to manage parametric explorations through the use of the ESP-r building energy performance simulation platform.  
# This is a part of the Sim::OPTS Perl module.
# This is free software.  You can redistribute it and/or modify it under the terms of the GNU General Public License 
# as published by the Free Software Foundation, version 2.

# HERE FOLLOW THE "rank_reports", "convert_report" , "filter_reports" and "maketable" FUNCTIONS, CALLED FROM THE MAIN PROGRAM FILE.

##############################################################################
##############################################################################
##############################################################################
# HERE FOLLOWS THE CONTENT OF THE "opts_format.pl" FILE, WHICH HAS BEEN MERGED HERE
# TO AVOID COMPLICATIONS WITH PERL MODULE INSTALLATION.

# HERE FOLLOW THE "rank_reports", "convert_report" , "filter_reports" and "maketable" FUNCTIONS, CALLED FROM THE MAIN PROGRAM FILE.

no strict; 
use warnings;
use lib "../../";

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

1;
