use strict;
use warnings;
use Test::More;
use Net::Azure::NotificationHubs::Request;
use LWP::UserAgent;

subtest 'html response' => sub {
    my $uri = URI->new('http://search.cpan.org/search');
    $uri->query_form(query => 'Azure', mode => 'all'); 
    my $req = Net::Azure::NotificationHubs::Request->new(GET => $uri);
    $req->agent(LWP::UserAgent->new);
    my $res = $req->do;
    can_ok $res, qw/as_hashref/;
    my $data = $res->as_hashref;
    is $data, undef, 'data is undefined';
};

subtest 'json response' => sub {
    my $uri = URI->new('http://api.metacpan.org/v0/release/_search');
    $uri->query_form(q => 'name:Net-Azure-Authorization-SAS-0.02', fields => 'download_url,name'); 
    my $req = Net::Azure::NotificationHubs::Request->new(GET => $uri);
    $req->agent(LWP::UserAgent->new);
    my $res = $req->do;
    can_ok $res, qw/as_hashref/;
    my $data = $res->as_hashref;
    isa_ok $data, 'HASH', 'data is a HASHREF';
    is $data->{hits}{hits}[0]{fields}{name}, 'Net-Azure-Authorization-SAS-0.02', 'matched module name is "Net-Azure-Authorization-SAS-0.02"';
};


done_testing;