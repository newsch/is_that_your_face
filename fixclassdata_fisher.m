% fixclassdata_fisher.m  Clean up the classdata_fisher.mat dataset
% You should probably run 'clear all' before running this.

clear all
try
    load('classdata_fisher.mat');
catch
    disp('Couldn''t find "classdata_fisher.mat".')
    disp('Make sure its placed in the same folder as this script.')
    return;  % stop executing 
end

% trim y data down to length 172
y.name = y.name(1:172);
y.picnum = y.picnum(1:172);
y.smile = y.smile(1:172);

% combine same names
newNames = string(zeros(1,length(y.name)));
for i = 1:length(y.name)  % fix names for some datapoints in 'classdata_full.mat'
    groups = regexp(y.name(i),'(?<name>\w*)_\d\d\.\w*','names');  % get name w/ RegEx capturing group
    newNames(i) = groups{1}.name;  % select name of first find
end
y.name = newNames;

% shift two students' image numbers because they index at 1 instead of 0
y.picnum(97:100) = y.picnum(97:100) - 1;
y.picnum(157:160) = y.picnum(157:160) - 1;

save('classdata_fisher_fixed.mat')
disp('Saved new file "classdata_fisher_fixed.mat".')