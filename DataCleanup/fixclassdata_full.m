% fixclassdata_full.m  Clean up the classdata_full.mat dataset

clear all
try
    load('classdata_full.mat');
catch
    disp('Couldn''t find "classdata_full.mat".')
    disp('Make sure its placed in the same folder as this script.')
    return;  % stop executing 
end

newNames = string(zeros(1,length(y.name)));
for i = 1:length(y.name)  % fix names for some datapoints in 'classdata_full.mat'
    groups = regexp(y.name(i),'(?<name>\w*)_\d\d\.\w*','names');  % get name w/ RegEx capturing group
    newNames(i) = groups{1}.name;  % select name of first find
end
y.name = newNames;
% shift two students' image numbers because they index at 1 instead of 0
y.picnum(124:127) = y.picnum(124:127) - 1;
y.picnum(205:208) = y.picnum(205:208) - 1;

save('classdata_full_fixed.mat')
disp('Saved new file "classdata_full_fixed.mat".')