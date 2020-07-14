function [scores] = score_test(filename)
% scores = import 'filename' and calculate the BDI, PANAS, PHQ9, QIDS
% SR-16, GAD-7, CESD, and STAI (State/Trait) scores for subject 'WBLID'.
if ~exist('filename')||(exist('filename')&&~contains(filename,'.csv'))
    error('File Load Problem: File Not Found');
end
opts = detectImportOptions('numeric.csv');
opts.MissingRule = 'fill';

dat = readtable('numeric.csv',opts); clear opts;
dat(1:2,:) = []; dat(:,[10:13,159:160]) = [];
tab = dat; clear dat;

% tab = readtable('raw.csv'); tab(1,:) = [];
pause(0.01); close all; clc;
testsc = tab(:,14);

%%% BDI (Q2-Q23)
% All questions are scored 0-3, giving a maximum of 63 and minimum of 0
% for each score.
% Ref: https://www.commondataelements.ninds.nih.gov/doc/noc/beck_depression_inventory_noc_link.pdf
indices = 16:36; BDI = [];
for i=1:height(testsc), sc = 0;
    for ind=indices, t = tab{i,ind}; sc = sc + t; end
    BDI = [BDI; sc];
end, clear i ind sc t indices;
testsc = addvars(testsc,BDI); clear BDI;

%%% PANAS (Q100_1-Q100_20)
% Positive Affect Questions are 1,3,5,9,10,12,14,16,17,19. Negative Affect
% Questions are 2,4,6,7,8,11,13,15,18,20. Add both - the score is generally
% given as a Bi-scaled (PANAS-Pos, PANAS-Neg) score.
% Ref: https://ogg.osu.edu/media/documents/MB%20Stream/PANAS.pdf
indices = 37:56; PANAS_P = []; PANAS_N = [];
for i=1:height(testsc), scp = 0; scn = 0;
    for ind=indices, t = tab{i,ind};
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
testsc = addvars(testsc,PANAS_P,PANAS_N); clear PANAS_P PANAS_N;

%%% PHQ9 (Q49_1-Q49_9 and Q50)
% Patient Health Questionnaire - 9 is a nine question test, each answer
% scored between 0 to 3, and the severity score is the cum-sum (0-27).
% Ref: https://www.pcpcc.org/sites/default/files/resources/instructions.pdf
indices = 57:66; PHQ9 = []; PHQ9_Q50 = [];
for i=1:height(testsc), sc = 0;
    for ind=indices, t = tab{i,ind};
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

%%% QIDS SR-16 (Q54-Q69)
% Quick Inventory of Depressive Symptomatology (QIDS, referenced at:
% http://www.ids-qids.org/administration.html) is scored with the highest
% scoring considered for the Sleep items (Q.1-4), Weight items (Q.6-9), and
% Psychomotor items (Q.15-16). The score is cum-sum.
delete qids_sr16.txt; clc; diary qids_sr16.txt; diary on;
indices = 89:104; start = indices(1)-1;
QIDS_SR16 = []; sleep = 0; weight = 0; psychomotor = 0;
for i=1:height(testsc), sc = [];
    for ind=1:length(indices), t = tab{i,start+ind};
        switch (ind)
            case {1,2,3,4}, sleep = max(sleep, t);
            case {6,7,8,9}, weight = max(weight, t);
            case {15,16}, psychomotor = max(psychomotor, t);
            otherwise, sc = [sc, t];
        end
    end, sc = [sc, sleep, weight, psychomotor]; disp(sc);
    sc(find(sc == 30)) = 12; sc = floor(sc/3); disp(sc);
    QIDS_SR16 = [QIDS_SR16; sum(sc)]; disp('-------------');
end, clear i ind sc t indices sleep weight psychomotor start;
testsc = addvars(testsc,QIDS_SR16); clear QIDS_SR16; diary off;

%%% GAD-7 (Q72_1-Q72_7 and Q73)
% GAD-7 is a seven question anxiety severity screening test, scored between
% 0-3 for all the answers, the cum-sum giving the GAD-7 score.
% Ref: https://www.pcpcc.org/sites/default/files/resources/instructions.pdf
indices = 105:112; GAD7 = []; GAD7_Q73 = [];
for i=1:height(testsc), sc = 0;
    for ind=indices, t = tab{i,ind};
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

%%% CESD (Q27-Q46)
% All items of the questionnaire are score 0-3 with Q.4,8,12, and 16
% reverse-scored. The cum-sum is the over-all CES-Depression score.
% Ref: https://outcometracker.org/library/CES-D.pdf
indices = 113:132; CESD = [];
for i=1:height(testsc), sc = 0;
    for ind=indices, t = tab{i,ind};
        switch (ind-indices(1)+1)
            case {4,8,12,16}, sc = sc + 3 - t;
            otherwise, sc = sc + t;
        end
    end, CESD = [CESD; sc];
end, clear i ind sc t indices;
testsc = addvars(testsc,CESD); clear CESD;

%%% STAI - State Anxiety (Q99_1-Q99_20)
% All questions scored from 1-4. Questions: Q. 1, 2, 5, 8, 10, 11, 15, 16,
% 19, and 20 are reverse scored. The total state score for the 40-question
% test is the cum-sum from Q.1-20.
% Ref: https://www.essex.ac.uk/-/media/elct/zhao---anxiety-inventory.pdf
indices = 133:152; STAI_STATE = [];
for i=1:height(testsc), sc = 0;
    for ind=indices, t = tab{i,ind};
        if t ~= 1, t = t - 2; end
        switch (ind-indices(1)+1)
            case {1,2,5,8,10,11,15,16,19,20}, sc = sc + 5 - t;
            otherwise, sc = sc + t;
        end
    end, STAI_STATE = [STAI_STATE; sc];
end, clear i ind sc t indices;
testsc = addvars(testsc,STAI_STATE); clear STAI_STATE;

%%% STAI - Trait Anxiety (Q79-Q98)
% All questions scored from 1-4. Questions: Q. 21, 23, 26, 27, 30, 33, 34,
% 36, and 39 are reverse scored. The total state score for the 40-question
% test is the cum-sum from Q.21-40.
% Ref: https://www.essex.ac.uk/-/media/elct/zhao---anxiety-inventory.pdf
indices = 69:88; STAI_TRAIT = [];
for i=1:height(testsc), sc = 0;
    for ind=indices, t = tab{i,ind};
        switch (ind-indices(1)+1)
            case {1,3,6,7,10,13,14,16,19}, sc = sc + 5 - t;
            otherwise, sc = sc + t;
        end
    end, STAI_TRAIT = [STAI_TRAIT; sc];
end, clear i ind sc t indices;
testsc = addvars(testsc,STAI_TRAIT); clear STAI_TRAIT;

%%% Output
scores = testsc;
end
%% ==================================================================== %%