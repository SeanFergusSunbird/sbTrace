# -*- perl -*-
 
package Devel::SBTrace;
$VERSION = '0.12';
$TRACE = 1;
our $CODE_COVERED = {}; 
# This is the important part.  The rest is just fluff.
sub DB::DB {  
 if($TRACE) {
  my ($p, $f, $l) = caller;
  my $code = \@{"::_<$f"};
  print STDERR ">> $f:$l: $code->[$l]";
 }
}
 
 
sub import {
  my $package = shift;
  foreach (@_) {
    if ($_ eq 'trace') {
      my $caller = caller;
      *{$caller . '::trace'} = \&{$package . '::trace'};
    } else {
      use Carp;
      croak "Package $package does not export `$_'; aborting";
    }
  }
}
 
my %tracearg = ('on' => 1, 'off' => 0);
sub trace {
  my $arg = shift;
  $arg = $tracearg{$arg} while exists $tracearg{$arg};
  $TRACE = $arg;
}
 
1;