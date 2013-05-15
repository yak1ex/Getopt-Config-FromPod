# NAME

Getopt::Config::FromPod - Extract getopt configuration from POD

# VERSION

version v0.0.0

# SYNOPSIS

    # Typical usage for Getopt::Std
    use Getopt::Std;
    use Getopt::Config::FromPod;
    getopts(Getopt::Config::FromPod->new->string);

    # Typical usage for Getopt::Long or variants
    use Getopt::Long::Descriptive;
    use Getopt::Config::FromPod;
    GetOptions(Getopt::Config::FromPod->new->array);

    # For most usage, you don't have to specify parameters but you can do so if necessary
    Getopt::Config::FromPod->new(-tag => 'getopts')->arrayref(-file => $filename);
    Getopt::Config::FromPod->new->arrayref(-package => $package);
    Getopt::Config::FromPod->new->string(-separator => ','); # for string() only

# DESCRIPTION

There are many and many `Getopt::*` modules on CPAN. Is this module yet another option parsing module?

__NO.__

This module is NOT to be another option parsing module but to be a companion of the modules.

The `Getopt::*` modules try to solve developers' preference of option parsing.
So, it is likely to be impossible to provide all-in-one option parsing modules.
One of the common problems in option parsing is consistency among:
=for :list
1\. Availability in actual process
2\. Document shown by, typically, -h option
3\. Document shown by perldoc

Some modules such as [Getopt::Long::Descriptive](http://search.cpan.org/perldoc?Getopt::Long::Descriptive) solves 1 and 2.
Few modules such as [Getopt::Auto](http://search.cpan.org/perldoc?Getopt::Auto) solves 1, 2 and 3.
So, if you want to keep all consistencies you need to stick some specific `Getopt::*` modules.

This module does not stick to specific `Getopt::*` module and provide a way to specify 1, 2 and 3 in POD.

To tell the truth, this module just collects option specifications distributed in POD.
So, dupulication between POD documentation and specification are NOT eliminated.
However, I believe it has some advantages to enable us to describe documentation and specification at the same place.

# METHODS

## new(%args)

Constructor. An available parameter is `'-tag'`.
You can change POD tag name from `'getopt'`.

    Getopt::Config::FromPod->new(-tag => 'options')->string;
    =for options 'h'

## string(%args)

Returns a string concatenated parameters written in POD.
Available parameters are as follows. Except for `'-separator'`, all arguments are available for other accessors.

- `'-separator'` => $separator

    parameters are concatenated with this separator. Defaults to `''`, that is empty string.

- `'-file'` => $filename

    Read POD from the specified file. If specified, `'-package'` is ignored.

- `'-package'` => $packagename

    Read POD from the file including the specified package. Defaults to `'main'`.

## array(%args)

Returns an array of parameters written in POD. See `string` for available parameters.

## arrayref(%args)

Returns an array reference of parameters written in POD. See `string` for available parameters.

## hashref(%args)

Returns a hash reference of parameters written in POD. See `string` for available parameters.

# AUTHOR

Yasutaka ATARASHI <yakex@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yasutaka ATARASHI.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
