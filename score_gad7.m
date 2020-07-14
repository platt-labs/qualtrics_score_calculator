function [scores] = score_gad7(tabledata,id_col,score_col)
% The Function takes in the input data as a table file and then the
% GAD-7 Score is calculated. GAD-7 is a seven question anxiety severity
% screening test, scored between 0-3 for all the answers and then added to
% give the final score.
%
% The I/O variables of the function are:
%   scores      =	Output of the form Table.
%   tabledata	=	Tabular reference/data; Input of the form Table.
%   id_col      =   Column Index of Subject's ID; of the form Int.
%   score_col	=   Column Indices of Responses; of the form 1D Int Array.
%
% Ref: https://www.pcpcc.org/sites/default/files/resources/instructions.pdf
if ~istable(tabledata), error('Incorrect first input: not a Table'); end
if ~exist('id_col') || ~exist('score_col')
    error('3 arguments expected');
elseif ~isnumeric(id_col) || ~isnumeric(score_col)
    error('Incorrect argument(s): have to be Integers');
end

% Score Calculation
testsc = tabledata(:,id_col); indices = score_col;
GAD7 = []; GAD7_Q73 = [];
if length(indices) < 7 || length(indices) > 8
    error('The number of response columns have to be either 7 or 8');
elseif length(indices) == 7, for i=1:height(testsc), sc = 0;
        for ind=indices, t = tabledata{i,ind}; switch(t)
                case {1}, sc = sc + 0;
                case {4}, sc = sc + 1;
                case {5}, sc = sc + 2;
                case {6}, sc = sc + 3;
            end
        end, GAD7 = [GAD7; sc];
    end, clear i ind sc t indices;
    testsc = addvars(testsc,GAD7); clear GAD7 GAD7_Q73;
else, for i=1:height(testsc), sc = 0;
        for ind=indices, t = tabledata{i,ind};
            if ind == indices(end) && isempty([t]), GAD7_Q73 = [GAD7_Q73; NaN];
            elseif ind == indices(end), GAD7_Q73 = [GAD7_Q73; t];
            else, switch(t)
                    case {1}, sc = sc + 0;
                    case {4}, sc = sc + 1;
                    case {5}, sc = sc + 2;
                    case {6}, sc = sc + 3;
                end
            end
        end, GAD7 = [GAD7; sc];
    end, clear i ind sc t indices;
    testsc = addvars(testsc,GAD7,GAD7_Q73); clear GAD7 GAD7_Q73;
end
scores = testsc; % Output
end