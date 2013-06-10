use Test::More tests => 5;
use Test::Exception;

use_ok 'Getopt::Config::FromPod';

my $p;
lives_ok { $p = Getopt::Config::FromPod->new; } 'create';

{ 
	my $dat = <<EOF;
\=pod

\=head1

\=over 4

\=item C<-h>

\=for getopt 'h'

\=item C<-v> E<lt>levelE<gt>

\=for getopt 'v:'

\=back
EOF
	open my $fh, '<', \$dat;
	is($p->string(-file => $fh, -separator => ','), 'h,v:', 'string with file handle and separator');
	close $fh;
}

my $expected = [
	'h', 'v:', 
	[ 'server|s=s', "the server to connect to" ],
	[ 'port|p=i',   "the port to connect to", { default => 79 } ],
];
is_deeply($p->arrayref(-file => 't/test.pod'), $expected, 'arrayref with external file');

$expected = {
	'-h' => 'help',
	'-f:' => 'filename',
};
is_deeply($p->hashref, $expected, 'hashref with default');

__END__

=head1 OPTIONS

=head2 C<-h>

=for getopt '-h', 'help'

=head1 REQUIRED ARGS

=over 4

=item C<-f> E<lt>fileE<gt>

=begin getopt

'-f:', 'filename'

=end getopt

=back
