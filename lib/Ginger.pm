package Ginger;
use strict;
use warnings;
our $VERSION = '0.01';

use Mouse;
use URI;
use LWP::Simple qw/get/;
use JSON qw/decode_json/;

has 'lang'    => (is => 'rw', isa => 'Str', default => 'US');
has 'version' => (is => 'rw', isa => 'Str', default => '2.0');
has 'api_key' => (is => 'rw', isa => 'Str');

my $endpoint = "http://services.gingersoftware.com/Ginger/correct/json/GingerTheText";

sub gingeration {
    my ($self, $text) = @_;
    my $uri = URI->new($endpoint);
    $uri->query_form({
        lang          => $self->lang,
        clientVersion => $self->version,
        apiKey        => $self->api_key,
        text          => $text,
    });

    my $res = Ginger::Result->new(
        origin => $text,
        data    => decode_json get($uri)
    );
    warn $res->dump if $ENV{DEBUG};
    return $res->to_s;
}

package Ginger::Result;
use Mouse;
use JSON;

has 'origin' => (is => 'rw', isa => 'Str');
has 'data'   => (is => 'rw');

sub to_s {
    my $self = shift;
    my $text = $self->origin;
    my $gap = 0;
    for my $rs (@{$self->data->{LightGingerTheTextResult}}) {
        my $from = $rs->{From};
        my $to   = $rs->{To};
        my $suggest = $rs->{Suggestions}[0]{Text};
        $to -= $from if $to;
        substr($text, $from + $gap, $to + 1) = $suggest;
        $gap += length($suggest) - 1 - $to;
    }
    return $text;
}

sub dump {
    my $self = shift;
    return JSON->new->pretty->encode($self->data);
}

1;

__END__

=head1 NAME

Ginger - Handle Ginger Unofficial API

=head1 SYNOPSIS

  use Ginger;
  my $ginger = Ginger->new(
      lang => 'US',
      version => '2.0',
      api_key => '6ae0c3a0-afdc-4532-a810-82ded0054236'
  );
  is $ginger->gingeration("this is test"), "This is a test";

=head1 DESCRIPTION

Ginger - Handle Ginger Unofficial API.

I'm not sure how to get an API key :/

=head1 AUTHOR

Naoya Ito E<lt>i.naoya@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
