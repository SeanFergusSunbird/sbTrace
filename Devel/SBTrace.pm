# -*- perl -*-
#use strict;
package Devel::sbTrace;
#use IO::Handle;
#use Data::Dumper;
#use PPI;
#use PPI::Dumper;
#use PadWalker qw(peek_my);
our $TRACE = 1;
my $cfg_file;
open($cfg_file,'<','trace.config');
my $match  = {};
my $config = {};
while (my $line = <$cfg_file>){
    chomp $line;
    if( $line !~ /^#/) {
        if($line =~/^=\s*(.+)\s*:(.+)$/) {
            $config->{$1} = $2;
        }
        elsif ($line =~ /^(.+)/){
            my @l = split(/\s+/,$1);
            my $m = shift @l;
            $match->{$m} = \@l;
        }
    }
}
if(! defined $config->{OUTPUT_APPEND_MODE}) {
    $config->{OUTPUT_APPEND_MODE} = ">>";
}
#
our $OUTPUTFH = *STDERR;

if(defined $config->{OUTPUT_FILE}) {
    my $mode = $config->{OUTPUT_APPEND_MODE};
    open(my $fh,$mode,$config->{OUTPUT_FILE});
    if (defined $fh) {
        $fh->autoflush;
        $OUTPUTFH = $fh;
    }
}
print $OUTPUTFH "Begin Testing ",scalar(localtime),"\n";
print $OUTPUTFH Dumper $config,$match;
sub DB::DB {
  return unless $TRACE;
  my ($p, $f, $l) = caller;
  my @c = caller(1);
  my $code = \@{"::_<$f"};
  my @check_match = ("$c[3]:$l",$c[3],$p);
  for my $m(@check_match) {
      if(defined $match->{$m}) {
       my $watch = $match->{$m};
        print $OUTPUTFH ">>$c[3]:$l $code->[$l]";
        for my $wv(@{$watch}) {
          # my $h = peek_my(1);
          # my $doc = PPI::Document->new(\$wv);
          # my ($top) = $doc->children;
          # @kids = $top->children;
          # $vname = $kids[0]->content;
          # my $var = $h->{$vname};
          # if ('REF' eq ref($var)) {
          #     $kids[0]->set_content('${$var}');
          # }elsif ('HASH' eq ref($var)) {
          #     $kids[0]->set_content('%{$var}');
          # }
          # elsif ('ARRAY' eq ref($var)) {
          #     $kids[0]->set_content('@{$var}');
          # }
          # else {
          #     $kids[0]->set_content('$var');
          # }
          # my $code = $doc->serialize;
          # print $OUTPUTFH $wv,"\t",Dumper eval $code;
        }
        last;
      }
  }
}
END {
    close $OUTPUTFH;
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
