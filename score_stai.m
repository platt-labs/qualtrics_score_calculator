function [scores] = score_stai(tabledata,id_col,score_col,is_trait)
% The Function takes in the input data as a table file and then the State
% and Trait Anxiety Inventory (STAI) scores are calculated. Each response
% is scored from 1-4. Questions 1,2,5,8,10,11,15,16,19,20 are reverse
% scored for State scores, and questions 21,23,26,27,30,33,34,36,39 are
% reverse scored for Trait scores. The total score for the 40-question
% test is the cum-sum from Q.1-20 for State and Q.21-40 for Trait.
%
% The I/O variables of the function are:
%   scores      =	Output of the form Table.
%   tabledata	=	Tabular reference/data; Input of the form Table.
%   id_col      =   Column Index of Subject's ID; of the form Int.
%   score_col	=   Column Indices of Responses; of the form 1D Int Array.
%   is_trait	=   (Optional) Boolean indication for the case of only a
%                       single score of either State or Trait anxiety.
%
% Ref: https://www.essex.ac.uk/-/media/elct/zhao---anxiety-inventory.pdf
if ~istable(tabledata), error('Incorrect first input: not a Table'); end
if ~exist('id_col') || ~exist('score_col')
    error('3 arguments expected');
elseif ~isnumeric(id_col) || ~isnumeric(score_col)
    error('Incorrect argument(s): have to be Integers');
end

% Calculation of the Scores
testsc = tabledata(:,id_col);
if length(score_col)==20, if ~exist('is_trait')
        error('Missing "is_trait" boolean argument'); end
    switch(is_trait)
        case {0} % STAI - State Anxiety (Q99_1-Q99_20)
            indices = score_col; STAI_STATE = [];
            for i=1:height(testsc), sc = 0;
                for ind=indices, t = tabledata{i,ind};
                    if t ~= 1, t = t - 2; end
                    switch (ind-indices(1)+1)
                        case {1,2,5,8,10,11,15,16,19,20}, sc = sc + 5 - t;
                        otherwise, sc = sc + t;
                    end
                end, STAI_STATE = [STAI_STATE; sc];
            end, clear i ind sc t indices;
            testsc = addvars(testsc,STAI_STATE); clear STAI_STATE;
        otherwise % STAI - Trait Anxiety (Q79-Q98)
            indices = score_col; STAI_TRAIT = [];
            for i=1:height(testsc), sc = 0;
                for ind=indices, t = tabledata{i,ind};
                    switch (ind-indices(1)+1)
                        case {1,3,6,7,10,13,14,16,19}, sc = sc + 5 - t;
                        otherwise, sc = sc + t;
                    end
                end, STAI_TRAIT = [STAI_TRAIT; sc];
            end, clear i ind sc t indices;
            testsc = addvars(testsc,STAI_TRAIT); clear STAI_TRAIT;
    end
elseif length(score_col)==40	% STAI - State and Trait Anxiety
    % STAI - State Anxiety (Q99_1-Q99_20)
    indices = score_col(1:20); STAI_STATE = [];
    for i=1:height(testsc), sc = 0;
        for ind=indices, t = tabledata{i,ind};
            if t ~= 1, t = t - 2; end
            switch (ind-indices(1)+1)
                case {1,2,5,8,10,11,15,16,19,20}, sc = sc + 5 - t;
                otherwise, sc = sc + t;
            end
        end, STAI_STATE = [STAI_STATE; sc];
    end, clear i ind sc t indices;
    testsc = addvars(testsc,STAI_STATE); clear STAI_STATE;
    
    % STAI - Trait Anxiety (Q79-Q98)
    indices = score_col(21:40); STAI_TRAIT = [];
    for i=1:height(testsc), sc = 0;
        for ind=indices, t = tabledata{i,ind};
            switch (ind-indices(1)+1)
                case {1,3,6,7,10,13,14,16,19}, sc = sc + 5 - t;
                otherwise, sc = sc + t;
            end
        end, STAI_TRAIT = [STAI_TRAIT; sc];
    end, clear i ind sc t indices;
    testsc = addvars(testsc,STAI_TRAIT); clear STAI_TRAIT;
else, error('Data incorrect: 20 or 40 response column indices expected');
end, scores = testsc; % Output
end