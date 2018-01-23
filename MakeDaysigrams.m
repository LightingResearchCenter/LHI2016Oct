function MakeDaysigrams
%MAKE Summary of this function goes here
%   Detailed explanation goes here

addpath('C:\Users\jonesg5\Documents\GitHub\d12pack');

projectDir = '\\root\programs\Outreach-Education\Light_and_Health_Inst\daysimeter_2016-10-18';

ls = dir([projectDir,filesep,'*.mat']);
[~,idxMostRecent] = max(vertcat(ls.datenum));
dataName = ls(idxMostRecent).name;
dataPath = fullfile(projectDir,dataName);

exportDir = fullfile(projectDir,'daysigrams');

load(dataPath)

for iObj = 1:numel(objArray)
    thisObj = objArray(iObj);
    
    if ~ischar(thisObj.ID)
        thisObj.ID = num2str(thisObj.ID);
    end
    
    if any(thisObj.Compliance)
    
    titleText = {'Light and Health Institute, October 2016';['Subject ID: ',thisObj.ID,', Device SN: ',num2str(thisObj.SerialNumber)]};
    
    d = d12pack.daysigram(thisObj,titleText);
    
    for iFile = 1:numel(d)
        d(iFile).Title = titleText;
        fileName = ['SUB',thisObj.ID,'_SN',num2str(thisObj.SerialNumber),'_p',num2str(iFile),'.pdf'];
        filePath = fullfile(exportDir,fileName);
        saveas(d(iFile).Figure,filePath);
        close(d(iFile).Figure);
        
    end
    
    end
end

end

