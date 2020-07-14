function [scores] = score_panas(tabledata,id_col,score_col)
% The Function takes in the input data as a table file and then the
% Positive And Negative Affect Scores (PANAS) are calculated. The positive
% affect questions are 1,3,5,9,10,12,14,16,17,19, and the negative affect
% questions are 2,4,6,7,8,11,13,15,18,20. Add them all - the score is
% generally given as a Bi-scaled (PANAS-Pos, PANAS-Neg) score.
% 
% The I/O variables of the function are:
%   scores      =	Output of the form Table.
%   tabledata	=	Tabular reference/data; Input of the form Table.
%   id_col      =   Column Index of Subject's ID; of the form Int.
%   score_col	=   Column Indices of Responses; of the form 1D Int Array.
% 
% Ref: https://ogg.osu.edu/media/documents/MB%20Stream/PANAS.pdf
if ~istable(tabledata), error('Incorrect first input: not a Table'); end
if ~exist('id_col') || ~exist('score_col')
    error('3 arguments expected');
elseif ~isnumeric(id_col) || ~isnumeric(score_col)
    error('Incorrect argument(s): have to be Integers');
end

% Score Calculation
testsc = tabledata(:,id_col); PANAS_P = []; PANAS_N = [];
indices = score_col;
for i=1:height(testsc), scp = 0; scn = 0;
    for ind=indices, t = tabledata{i,ind};
        if (t ~= 1), t = t - 2; end
        switch(ind-indices(1)+1)
            case {1,3,5,9,10,12,14,16,17,19}
                scp = scp + t;
            case {2,4,6,7,8,11,13,15,18,20}
                scn = scn + t;
        end
    end
    PANAS_P = [PANAS_P; scp]; PANAS_N = [PANAS_N; scn];
end, clear i ind scp scn t indices;

% Output
testsc = addvars(testsc,PANAS_P,PANAS_N); clear PANAS_P PANAS_N;
scores = testsc;
end