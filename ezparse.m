function [ argstruct, unparsed ] = ezparse( argstruct, argin )
%EZPARSE Fast and easy arg parser for 'key',val pair type optional args.
%   Pass in 2 parameters:
%       ARGSTRUCT: a struct populated with default values for all optional
%                  arguments.  Fields should be named corresponding to the
%                  desired 'key' in the key,value pairs.
%
%       ARGIN:     The varargin cell array from your function
%
%   This also supports 'flag' type arguments, where there is a string 'key'
%   with no value to be input, (for example
%       func(blabh, blah, 'optarg1', 2, 'verbose')
%   where 'verbose' is just a flag that gets toggled on.  These are
%   achieved by setting argstruct.flagname = '%FLAG%' in the default values
%   to signify a flag.
%
%   Note that all fields are case INsensitive
%
%   The returned 'unparsed' is a cellarray of all args in argin that
%   couldn't be parsed based on your input struct.  Most likely these are
%   simply arguments for which no corresponding field exists.  Handling
%   this is up to the user, for example it could simply be ignored, warned
%   about, or throw an error, depending on the application.
%
%   NOTE:
%   If argin is instead a struct, it is assumed that the caller wants
%   struct style arg parsing, so for any field in argin matching a field of
%   argstruct, argstruct.field is overwritten with argin.field.  Fields of
%   argin not contained in argin are returned as unparsed, where unparsed
%   will be a cell array of the unparsed field-names.
%


if isstruct(argin)
    [argstruct, unparsed] = struct_args(argstruct, argin);
elseif iscell(argin)
    [argstruct, unparsed] = cell_args(argstruct, argin);
else
    unparsed = argin;
end

end

function [argstruct, unparsed] = cell_args(argstruct, argin)
argnames = fieldnames(argstruct);

na = length(argin);
nf = length(argnames);

for j=1:nf
    fld = argnames{j};
    for i=1:na
        arg = argin{i};
        if strcmpi(arg, fld)
            % then we have matched a field
            % check for flag
            if strcmp(argstruct.(fld), '%FLAG%')
                % arg is a flag
                argstruct.(fld) = true;
                argin(i) = []; % delete field from argin to save searchtime
                na = na-1;
                break; % no need to search for this fld anymore
            end
            argstruct.(fld) = argin{i+1};
            argin(i:i+1) = [];
            na = na-2;
            break;
        end
    end
    % set a field arg to false if not found in argin
    if strcmp(argstruct.(fld), '%FLAG%')
        argstruct.(fld) = false;
    end
end

% all remaining args could not be parsed!
unparsed = argin;


end


function [argstruct, unparsed] = struct_args(argstruct, argin)

infields = fieldnames(argin);
rem = zeros(length(infields), 1);
remc = 0;
for i = 1:length(infields)

    fld = infields{i};

    if isfield(argstruct, fld)
        argstruct.(fld) = argin.(fld);
        remc = remc + 1;
        rem(remc) = i;
    end
end

rem(remc+1:end) = [];
infields(rem) = [];

% fields not in argstruct are returned as unparsed!
unparsed = infields;
end


