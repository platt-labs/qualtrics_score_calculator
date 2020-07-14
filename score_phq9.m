function [scores] = score_phq9(tabledata,id_col,score_col)
% The Function takes in the input data as a table file and then the Patient
% Health Questionnaire with 9 questions (PHQ-9) is scored. Each answer is
% scored between 0 to 3, and the severity is the cumulative score (0-27).
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

% Calculation of the Scores
testsc = tabledata(:,id_col); indices = score_col;
PHQ9 = []; PHQ9_Q50 = [];
if length(indices) < 9 || length(indices) > 10
    error('The number of response columns have to be either 9 or 10');
elseif length(indices) == 9, for i=1:height(testsc), sc = 0;
        for ind = indices, t = tabledata{i,ind};
            switch(t)
                case {1}, sc = sc + 0;
                case {4}, sc = sc + 1;
                case {5}, sc = sc + 2;
                case {6}, sc = sc + 3;
            end
        end, PHQ9 = [PHQ9; sc];
    end, clear i ind sc t indices;
    testsc = addvars(testsc,PHQ9); clear PHQ9 PHQ9_Q50;
else, for i=1:height(testsc), sc = 0;
        for ind = indices, t = tabledata{i,ind};
            if ind == indices(end) && isempty([t]), PHQ9_Q50 = [PHQ9_Q50; NaN];
            elseif ind == indices(end), PHQ9_Q50 = [PHQ9_Q50; t];
            else, switch(t)
                    case {1}, sc = sc + 0;
                    case {4}, sc = sc + 1;
                    case {5}, sc = sc + 2;
                    case {6}, sc = sc + 3;
                end
            end
        end, PHQ9 = [PHQ9; sc];
    end, clear i ind sc t indices;
    testsc = addvars(testsc,PHQ9,PHQ9_Q50); clear PHQ9 PHQ9_Q50;
end
scores = testsc; % Output
end