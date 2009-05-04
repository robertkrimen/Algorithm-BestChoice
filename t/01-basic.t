#!/usr/bin/perl -w

use strict;
use warnings;

use Test::Most;

plan qw/no_plan/;

use Algorithm::BestChoice;

my (@result, $result, $choice);
$choice = Algorithm::BestChoice->new;

$choice->add( value => 'apple' );

@result = $choice->best();
is( @result, 1 );
is( $result[0]->value, 'apple' );

$choice->add( value => 'banana', rank => 2 );

@result = $choice->best();
is( @result, 2 );
is( $result[0]->value, 'banana' );

$choice->add( value => 'cherry', rank => 4, match => 'xyzzy' );

@result = $choice->best();
is( @result, 2 );
is( $result[0]->value, 'banana' );

@result = $choice->best( 'xyzzy' );
is( @result, 3 );
is( $result[0]->value, 'cherry' );

@result = $choice->best( 'xyzzyxyz' );
is( @result, 2 );
is( $result[0]->value, 'banana' );