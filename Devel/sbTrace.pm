# -*- perl -*-
 
package Devel::sbTrace;
our $TRACE = 1;

sub DB::DB {
  
  if( $TRACE ) {
    my ($p, $f, $l) = caller;
    my $code = \@{"::_<$f"};
    print STDERR ">> $f:$l: $code->[$l]";
  }

}
 
 
 
1;