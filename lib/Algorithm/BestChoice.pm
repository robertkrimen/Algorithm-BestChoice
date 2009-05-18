package Algorithm::BestChoice;

use warnings;
use strict;

=head1 NAME

Algorithm::BestChoice - Choose the best

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

=cut

use Moose;

use Algorithm::BestChoice::Matcher;
use Algorithm::BestChoice::Ranker;
use Algorithm::BestChoice::Result;
use Algorithm::BestChoice::Option;

use Scalar::Util qw/looks_like_number/;

has options => qw/is ro required 1 isa ArrayRef/, default => sub { [] };

sub add {
    my $self = shift;
    my %given = @_;

    $given{matcher} = $given{match} unless exists $given{matcher};
    $given{ranker} = $given{rank} unless exists $given{ranker};
    my ($matcher, $ranker) = @given{ qw/matcher ranker/ };

    if ($ranker && ! ref $ranker && $ranker eq 'length') {
        if (! ref $matcher) {
            $ranker = defined $matcher ? length $matcher : 0;
        }
        else {
            die "Trying to rank by length, but given not-scalar matcher $matcher";
        }
    }

    $matcher = Algorithm::BestChoice::Matcher->parse( $matcher );
    $ranker = Algorithm::BestChoice::Ranker->parse( $ranker );

    my $option = Algorithm::BestChoice::Option->new( matcher => $matcher, ranker => $ranker, value => $given{value} );

    push @{ $self->options }, $option;
}

sub _best {
    my $self = shift;
    my $key = shift;

    my @tally;
    for my $option (@{ $self->options }) {
        if (my $match = $option->match( $key )) {
            my $rank;
            if (ref $match eq 'HASH') {
                $rank = $match->{rank};
                die "Got an undefined rank from a match" unless defined $rank;
                die "Got a non-numeric rank ($rank) from a match" unless looks_like_number $rank;
            }
            else {
                $rank = $option->rank( $key );
                die "Got an undefined rank from a ranker" unless defined $rank;
                die "Got a non-numeric rank ($rank) from a ranker" unless looks_like_number $rank;
            }
            push @tally, Algorithm::BestChoice::Result->new( rank => $rank, value => $option->value );
        }
    }

    return @tally;
}

# TODO: Test for this multi-key ranker
# TODO: Probably want to give different weights to different keys!
sub best {
    my $self = shift;

    my @tally = map { $self->_best( $_ ) } @_ ? @_ : (undef);
    @tally = sort { $b->rank <=> $a->rank } @tally;
    return wantarray ? @tally : $tally[0];
}

=head1 AUTHOR

Robert Krimen, C<< <rkrimen at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-algorithm-bestchoice at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Algorithm-BestChoice>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Algorithm::BestChoice


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Algorithm-BestChoice>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Algorithm-BestChoice>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Algorithm-BestChoice>

=item * Search CPAN

L<http://search.cpan.org/dist/Algorithm-BestChoice/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Robert Krimen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Algorithm::BestChoice
