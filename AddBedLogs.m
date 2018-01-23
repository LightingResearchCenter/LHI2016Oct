function AddBedLogs
%MAKE Summary of this function goes here
%   Detailed explanation goes here

addpath('C:\Users\jonesg5\Documents\GitHub\d12pack');

timestamp = datestr(now,'yyyy-mm-dd_HHMM');

projectDir = '\\root\programs\Outreach-Education\Light_and_Health_Inst\daysimeter_2016-10-18';
logDir  = fullfile(projectDir,'logs');

dbName  = [timestamp,'.mat'];
dbPath  = fullfile(projectDir,dbName);

ls = dir([projectDir,filesep,'*.mat']);
[~,idxMostRecent] = max(vertcat(ls.datenum));
dataName = ls(idxMostRecent).name;
dataPath = fullfile(projectDir,dataName);


load(dataPath)

for iObj = 1:numel(objArray)
    thisObj = objArray(iObj);
    
    bedlogPath = fullfile(logDir,['bedLog_subject ',thisObj.ID,'.xlsx']);
    if exist(bedlogPath,'file') == 2
        thisObj.BedLog = thisObj.BedLog.import(bedlogPath,thisObj.TimeZoneDeploy);
        objArray(iObj,1) = thisObj;
    end
end

save(dbPath,'objArray');

end

