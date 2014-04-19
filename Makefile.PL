use 5.18.0;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Sim::OPTS',
    VERSION_FROM      => 'lib/Sim/OPTS.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.18.0 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Sim/OPTS.pm', # retrieve abstract from module
       AUTHOR         => 'Gian Luca Brunetti <gianluca.brunetti@polimi.it>') : ()),
);
