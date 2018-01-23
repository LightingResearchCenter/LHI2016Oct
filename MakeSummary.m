function MakeSummary
%MAKE Summary of this function goes here
%   Detailed explanation goes here

timestamp = datestr(now,'yyyy-mm-dd_HHMM');

addpath('C:\Users\jonesg5\Documents\GitHub\d12pack');

projectDir = '\\root\programs\Outreach-Education\Light_and_Health_Inst\daysimeter_2016-10-18';

ls = dir([projectDir,filesep,'*.mat']);
[~,idxMostRecent] = max(vertcat(ls.datenum));
dataName = ls(idxMostRecent).name;
dataPath = fullfile(projectDir,dataName);

load(dataPath)

n = numel(objArray);
C = cell(n,1);
N = NaN(n,1);
varNames = {'subject','phasor_magnitude','phasor_angle','interdaily_stability','intradaily_variability','mean_waking_activity_index','mean_waking_circadian_stimulus','geometric_mean_waking_photopic_illuminance'};
T = table(C,N,N,N,N,N,N,N,'VariableNames',varNames);

for iObj = 1:n
    thisObj = objArray(iObj);
    
    if ~ischar(thisObj.ID)
        thisObj.ID = num2str(thisObj.ID);
    end
    
    T.subject{iObj,1} = thisObj.ID;
    
    if any(thisObj.Compliance)
        T.phasor_magnitude(iObj,1) = thisObj.Phasor.Magnitude;
        T.phasor_angle(iObj,1) = thisObj.Phasor.Angle.hours;
        T.interdaily_stability(iObj,1) = thisObj.InterdailyStability;
        T.intradaily_variability(iObj,1) = thisObj.IntradailyVariability;
        T.mean_waking_activity_index(iObj,1) = thisObj.MeanWakingActivityIndex;
        T.mean_waking_circadian_stimulus(iObj,1) = thisObj.MeanWakingCircadianStimulus;
        T.geometric_mean_waking_photopic_illuminance(iObj,1) = thisObj.GeometricMeanWakingIlluminance;
    end
end

excelPath = fullfile(projectDir,['summary_',timestamp,'.xlsx']);
writetable(T,excelPath);

end

