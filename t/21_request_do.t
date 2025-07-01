use strict;
use warnings;
use Test::More;
use Test::Exception;
use Net::Azure::NotificationHubs::Request;
use URI;
use HTTP::Tiny;

subtest 'do' => sub {
    my $uri = URI->new('https://metacpan.org/search');
    $uri->query_form(q => 'Azure', size => 100); 
    my $req = Net::Azure::NotificationHubs::Request->new(GET => $uri);
    $req->agent(HTTP::Tiny->new);
    isa_ok $req, 'Net::Azure::NotificationHubs::Request';
    can_ok $req, qw/do/;
    my $res = $req->do;
    isa_ok $res, 'Net::Azure::NotificationHubs::Response';
    like $res->content, qr/Net::Azure/, 'response body contains "Net::Azure"'; 
};

subtest 'do - 404' => sub {
# The plural URL 'https://azure.microsoft.com/ja-jp/pricing/details/notification-hubs/' is valid, 
# but the singular 'https://azure.microsoft.com/ja-jp/pricing/details/notification-hub/' reliably returns a 404.
    my $uri = URI->new('https://azure.microsoft.com/ja-jp/pricing/details/notification-hub/');
    my $req = Net::Azure::NotificationHubs::Request->new(GET => $uri);
    $req->agent(HTTP::Tiny->new);
    isa_ok $req, 'Net::Azure::NotificationHubs::Request';
    can_ok $req, qw/do/;
    my $res;
    dies_ok {$res = $req->do} qr/not found/;
    is $res, undef, 'Response object is not defined';
};

done_testing