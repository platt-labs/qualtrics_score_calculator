function [scores] = score_qids_sr16(tabledata,id_col,score_col)
% The Function takes in the input data as a table file and then the Quick
% Inventory of Depressive Symptomatology (QIDS) score is calculated. The
% scores follow the rules of considering the highest score for Sleep items
% (Q.1-4), Weight items (Q.6-9), and Psychomotor items (Q.15-16). The
% cumulative score shows the severity for the subject.
% 
% The I/O variables of the function are:
%   scores      =	Output of the form Table.
%   tabledata	=	Tabular reference/data; Input of the form Table.
%   id_col      =   Column Index of Subject's ID; of the form Int.
%   score_col	=   Column Indices of Responses; of the form 1D Int Array.
% 
% Ref: http://www.ids-qids.org/administration.html
if ~istable(tabledata), error('Incorrect first input: not a Table'); end
if ~exist('id_col') || ~exist('score_col')
    error('3 arguments expected');
elseif ~isnumeric(id_col) || ~isnumeric(score_col)
    error('Incorrect argument(s): have to be Integers');
end

% Score Calculation
testsc = tabledata(:,id_col); PANAS_P = []; PANAS_N = [];
indices = score_col; start = indices(1)-1;
QIDS_SR16 = []; sleep = 0; weight = 0; psychomotor = 0;
for i=1:height(testsc), sc = [];
    for ind=1:length(indices), t = tabledata{i,start+ind};
        switch (ind)
            case {1,2,3,4}, sleep = max(sleep, t);
            case {6,7,8,9}, weight = max(weight, t);
            case {15,16}, psychomotor = max(psychomotor, t);
            otherwise, sc = [sc, t];
        end
    end, sc = [sc, sleep, weight, psychomotor];
    sc(find(sc == 30)) = 12; sc = floor(sc/3);
    QIDS_SR16 = [QIDS_SR16; sum(sc)];
end, clear i ind sc t indices sleep weight psychomotor start;

% Output
testsc = addvars(testsc,QIDS_SR16); clear QIDS_SR16;
scores = testsc;
end