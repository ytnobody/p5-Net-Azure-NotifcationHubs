requires 'perl', '5.008001';
requires 'Net::Azure::Authorization::SAS';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

