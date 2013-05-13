package Getopt::FromPod;

use strict;
use warnings;

# ABSTRACT: Extract getopt configuration from POD
# VERSION

package Getopt::FromPod::Extractor;

use strict;
use warnings;

use parent qw(Pod::Simple);

sub new
{
	my ($ref, %args) = @_;
	my $class = ref $ref || $ref;
	my $self = bless Pod::Simple::new($class, %args), $class;
	my $tag = $args{-tag} || 'getopt';
	$self->{_TAG} = $tag;
	$self->accept_targets($tag);
	return $self;
}

sub _handle_element_start
{
	my ($parser, $element_name, $attr) = @_;
	if($element_name eq 'Document') {
		$parser->{_RESULT} = [];
	}
	if(($element_name eq 'for' || $element_name eq 'begin') && $attr->{target} eq $parser->{_TAG}) {
		$parser->{_IN_TARGET} = 1;
	}
}

sub _handle_element_end
{
	my ($parser, $element_name, $attr) = @_;
	if($element_name eq 'for' || ($element_name eq 'end' && $attr->{target} eq $parser->{_TAG})) {
		$parser->{_IN_TARGET} = 0;
	}
}

sub _handle_text
{
	my ($parser, $text) = @_;
	push @{$parser->{_RESULT}}, eval $text if $parser->{_IN_TARGET};
}

package Getopt::FromPod;

use Carp;

sub new
{
	my $self = shift;
	my $class = ref $self || $self;
	return bless {}, $class;
}

sub _extract
{
	my ($self, %args) = @_;
	my $parser = Getopt::FromPod::Extractor->new(%args);
	my $file = $args{-file};
	$args{-package} ||= 'main';
	if(! defined $file) {
		my $idx = 0;
		my @caller;
		while(@caller = caller($idx++)) {
			if($caller[0] eq $args{-package}) {
				$file = $caller[1];
				last;
			}
		}
	}
	croak if ! defined $file;
	$parser->parse_file($file);
	return $parser->{_RESULT};
}

sub string
{
	my ($self, %args) = @_;
	return join(exists $args{-separator} ? $args{-separator} : '', $self->array(%args));
}

sub array
{
	my ($self, %args) = @_;
	return @{$self->_extract(%args)};
}

sub arrayref
{
	my ($self, %args) = @_;
	return [$self->array(%args)];
}

sub hashref
{
	my ($self, %args) = @_;
	return {$self->array(%args)};
}

1;
