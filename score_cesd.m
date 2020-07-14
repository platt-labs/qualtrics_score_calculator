function [scores] = score_cesd(tabledata,id_col,score_col)
% The Function takes in the input data as a table file and then the CES -
% Depression (CESD) score is calculated. All items of the questionnaire are
% score 0-3 with Q.4,8,12, and 16 reverse-scored.
% 
% The I/O variables of the function are:
%   scores      =	Output of the form Table.
%   tabledata	=	Tabular reference/data; Input of the form Table.
%   id_col      =   Column Index of Subject's ID; of the form Int.
%   score_col	=   Column Indices of Responses; of the form 1D Int Array.
% 
% Ref: https://outcometracker.org/library/CES-D.pdf
if ~istable(tabledata), error('Incorrect first input: not a Table'); end
if ~exist('id_col') || ~exist('score_col')
    error('3 arguments expected');
elseif ~isnumeric(id_col) || ~isnumeric(score_col)
    error('Incorrect argument(s): have to be Integers');
end

% Calculation of the Scores
testsc = tabledata(:,id_col); CESD = [];
for i=1:height(testsc), sc = 0;
    for ind=score_col, t = tabledata{i,ind};
        switch (ind-score_col(1)+1)
            case {4,8,12,16}, sc = sc + 3 - t;
            otherwise, sc = sc + t;
        end
    end, CESD = [CESD; sc];
end, clear i ind sc t;

% Output
testsc = addvars(testsc,CESD); clear CESD;
scores = testsc;
end