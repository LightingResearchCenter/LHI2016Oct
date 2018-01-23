%% Reset MATLAB
close all
clear
clc

%% Enable dependencies
[githubDir,~,~] = fileparts(pwd);
d12packDir      = fullfile(githubDir,  'd12pack');
circadianDir	= fullfile(githubDir,'circadian');
addpath(d12packDir,circadianDir);

%% Map paths
timestamp = datestr(now,'yyyy-mm-dd_HHMM');
calPath = '\\root\projects\DaysimeterAndDimesimeterReferenceFiles\recalibration2016\calibration_log.csv';
prjDir  = '\\root\programs\Outreach-Education\Light_and_Health_Inst\daysimeter_2016-10-18';
orgDir  = fullfile(prjDir,'best_downloads');
logDir  = fullfile(prjDir,'logs');
dbName  = [timestamp,'.mat'];
dbPath  = fullfile(prjDir,dbName);
tzPath  = fullfile(prjDir,'time_zones.xlsx');

%% Read time zone table
tzTable = readtable(tzPath);


%% Crop and convert data
listingCDF   = dir(fullfile(orgDir,'*.cdf'));
cdfPaths     = fullfile(orgDir,{listingCDF.name});
loginfoPaths = regexprep(cdfPaths,'\.cdf','-LOG.txt');
datalogPaths = regexprep(cdfPaths,'\.cdf','-DATA.txt');

for iFile = numel(loginfoPaths):-1:1
    cdfData = daysimeter12.readcdf(cdfPaths{iFile});
    ID = cdfData.GlobalAttributes.subjectID;
    
    thisObj = d12pack.HumanData;
    thisObj.CalibrationPath = calPath;
    thisObj.RatioMethod     = 'newest';
    thisObj.ID              = ID;
    thisObj.TimeZoneLaunch	= 'America/New_York';
    
    % Find matching time zone
    tzIdx = tzTable.Subject == str2double(ID);
    thisObj.TimeZoneDeploy	= tzTable.TimeZone(tzIdx);
    
    % Import the original data
    thisObj.log_info = thisObj.readloginfo(loginfoPaths{iFile});
    thisObj.data_log = thisObj.readdatalog(datalogPaths{iFile});
    
    % Import bed log if one exists
    bedlogPath = fullfile(logDir,['bedLog_subject ',ID,'.xlsx']);
    if exist(bedlogPath,'file') == 2
        thisObj.BedLog = d12pack.BedLogData;
        thisObj.BedLog.import(bedlogPath,thisObj.TimeZoneDeploy);
    end
    
    % Crop the data
    thisObj = crop(thisObj);
    
    objArray(iFile,1) = thisObj;
end

%% Save converted data to file
save(dbPath,'objArray');


