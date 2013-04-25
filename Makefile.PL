use inc::Module::Install;
name 'Ginger';
all_from 'lib/Ginger.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
