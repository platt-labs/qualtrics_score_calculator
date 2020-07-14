function [tabout,indices] = clean_qualtrics_data(filein)
% The Function takes in the input as the '.csv' file exported from the
% UPENN-Qualtrics online survey services.
% 
% The function has the following data:
%   tabout	=	Output of the form Table.
%   indices	=	Indices where the ID's read a 'NaN' of the form array.
%   filein	=	CSV file name of the form Character Array.
% 
% Penn-Qualtrics online service: https://upenn.co1.qualtrics.com/

if ~exist(filein) || (exist(filein) && ~contains(filein,'.csv'))
    error('File Not Found');
end, opts = detectImportOptions(filein); opts.MissingRule = 'fill';

dat = readtable(filein,opts);
dat = removevars(dat,{'RecipientLastName','RecipientFirstName',...
    'RecipientEmail','ExternalReference','Comments','Email_Topics'});

natime = unique([find(isnat(dat.StartDate));find(isnat(dat.StartDate))]);
dat(natime,:) = [];

indices = find(isnan(dat.WBLID)); tabout = dat;
end