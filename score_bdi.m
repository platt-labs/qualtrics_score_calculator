function [scores] = score_bdi(tabledata,id_col,score_col)
% The Function takes in the input data as a table file and then the Beck
% Depression Inventory (BDI) score is calculated. Each response is scored
% between 0-3, giving maximum and minimum scores of 63 and 0 respectively.
% 
% The I/O variables of the function are:
%   scores      =	Output of the form Table.
%   tabledata	=	Tabular reference/data; Input of the form Table.
%   id_col      =   Column Index of Subject's ID; of the form Int.
%   score_col	=   Column Indices of Responses; of the form 1D Int Array.
% 
% Ref: https://www.commondataelements.ninds.nih.gov/doc/noc/beck_depression_inventory_noc_link.pdf
if ~istable(tabledata), error('Incorrect first input: not a Table'); end
if ~exist('id_col') || ~exist('score_col')
    error('3 arguments expected');
elseif ~isnumeric(id_col) || ~isnumeric(score_col)
    error('Incorrect argument(s): have to be Integers');
end

% Calculation of the Scores
testsc = tabledata(:,id_col); BDI = [];
for i=1:height(testsc), sc = 0;
    for ind=score_col, t = tabledata{i,ind}; sc = sc + t; end
    BDI = [BDI; sc];
end, clear i ind sc t indices;

% Output
testsc = addvars(testsc,BDI); clear BDI;
scores = testsc;
end