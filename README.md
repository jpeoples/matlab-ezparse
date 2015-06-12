# ezparse
Implement optional arguments with default values using the name-value
pair pattern.  Additionally, create flags using names with no values.

## Usage
Let's say I want a funtion that accepts 3 optional arguments, foo, bar
and baz, all with default values of 0, and a 'verbose' flag.  Then I
could define it as follows:

    ```matlab
    function [output] = funcname(required, arguments, varargin)

        opt.foo = 0;
        opt.bar = 0;
        opt.baz = 0;
        opt.verbose = '%FLAG%';

        [opt, unparsed] = ezparse(opt, varargin);

        % rest of code here

and I could call the function as follows (for example):

    funcname(required, arg, 'bar' 10, 'verbose', foo', 3, );

resulting in

    opt.foo = 3;
    opt.bar = 10;
    opt.baz = 0;
    opt.verbose = 1;

Additional details can be found in the source.
