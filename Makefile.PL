use inc::Module::Install;

name     'Algorithm-BestChoice';
all_from 'lib/Algorithm/BestChoice.pm';
author   'Robert Krimen <rkrimen@cpan.org>';
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

