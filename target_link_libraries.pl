#!/bin/perl
use strict;
use utf8;

my $resolved_symbol = {};
my $unresolved_symbol = {};
{
    foreach my $filename (@ARGV){
        foreach my $line (readpipe( "nm --extern-only $filename" )){
            chomp $line;
            if( $line =~ m/([0-9a-f]{8,16})?\s+([dwrtbTU])\s+(.*)/ ){
                my ( $addr , $type , $symbol ) = ($1,$2,$3);
                if( $1 ne '' ){
                    $resolved_symbol->{$symbol} = $filename;
                }else{
                    if( defined($unresolved_symbol->{$symbol}) ){
                        push( @{$unresolved_symbol->{$symbol}} , $filename );
                    }else{
                        $unresolved_symbol->{$symbol} = [$filename];
                    }
                }
            }
        }
    }
}

{
    my $depends = {};
    foreach my $symbol ( keys( %$unresolved_symbol ) ){
        if( defined( $resolved_symbol->{$symbol} )){
            my $filename = $resolved_symbol->{$symbol};
            foreach  my $dependee (@{$unresolved_symbol->{$symbol}}){
                if( defined( $depends->{$dependee} )){
                    push( @{$depends->{$dependee}} , $filename ) ;
                }else{
                    $depends->{$dependee} = [ $filename ] ;
                }
            }
        }else{
            print STDERR "$symbol is not resolved\n";
        }
    }

    foreach my $filename ( keys( %$depends ) ){
        my %temp;
        @temp{@{$depends->{$filename}}} = 1;
        print "target_link_libraries( $filename PRIVATE ",join( " ",keys( %temp ) )," )\n";
    }
}
