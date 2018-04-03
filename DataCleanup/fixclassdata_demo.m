% fixclassdata_demo.m  Clean up the classdata_full.mat dataset
% You should probably run 'clear all' before running this.

clear all
load classdata_full_fixed.mat
FullNames = unique(y.name);

load('classdata_demo.mat');
newNames = string(zeros(1,length(y.name)));
flags = zeros(1,length(y.name));
for i = 1:length(y.name)  % fix names for some datapoints in 'classdata_demo.mat'
    shortName = y.name(i);
    matches = FullNames(contains(FullNames,shortName));
    if length(matches) ~= 1
        disp('Warning, not exactly one match')
        flags(i) = 1;
    else
        newNames(i) = matches(1);
    end
end
y.name = newNames(~flags);
y.picnum = y.picnum(~flags);
grayfaces = grayfaces(:,:,~flags);

save('classdata_demo_fixed.mat')
disp('Saved new file "classdata_demo_fixed.mat".')