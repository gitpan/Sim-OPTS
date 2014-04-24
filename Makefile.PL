use 5.008001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Sim::OPTS',
    VERSION_FROM      => 'lib/Sim/OPTS.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.008 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT       => 'Manages parametric explorations by the means of the ESP-r building performance simulation platform.', # retrieve abstract from module
       AUTHOR         => 'Gian Luca Brunetti <gianluca.brunetti@polimi.it>') : ()),
);
