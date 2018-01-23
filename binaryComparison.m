function binaryComparison
%BINARYCOMPARISON Summary of this function goes here
%   Detailed explanation goes here

mainDir = '\\root\programs\Outreach-Education\Light_and_Health_Inst\daysimeter_2016-10-18';
mainListing = dir(mainDir);
mainListing(~[mainListing.isdir]') = [];
parentIdx = strcmp({mainListing.name}','.') | strcmp({mainListing.name}','..');
mainListing(parentIdx) = [];
dirArray = fullfile(mainDir,{mainListing.name}');

for iDir = 1:numel(dirArray)
    thisDir = dirArray{iDir};
    listing = dir([thisDir,filesep,'*DATA.txt']);
    fileNameArray = {listing(:).name};
    filePathArray = fullfile(thisDir,fileNameArray);
    varNameArray = matlab.lang.makeValidName(regexprep(fileNameArray,'([^a-zA-Z0-9]*)','_'));

    T = initTable(varNameArray);

    n = numel(listing);

    for i1 = 1:n
        for j1 = 1:n
            if j1 == i1
                continue;
            end
            filePath1 = filePathArray{i1};
            filePath2 = filePathArray{j1};
            if isDiff(filePath1,filePath2)
                T.(j1)(i1) = {'diff'};
            else
                T.(j1)(i1) = {'same'};
            end
        end
    end


    timestamp = datestr(now,'yyyy-mm-dd_HHMM');
    excelPath = fullfile(thisDir,['comparison_',timestamp,'.xlsx']);
    try
    writetable(T,excelPath,'WriteRowNames',true);
    catch err
        display(err.message)
    end
end

end

function T = initTable(varNameArray)

n = numel(varNameArray);
T = cell2table(cell(n,n));
T.Properties.VariableNames = varNameArray;
T.Properties.RowNames = varNameArray;
T.Properties.DimensionNames = {'file1','file2'};

end

function TF = isDiff(filePath1,filePath2)
file_1 = javaObject('java.io.File', filePath1);
file_2 = javaObject('java.io.File', filePath2);
TF = ~javaMethod('contentEquals','org.apache.commons.io.FileUtils',file_1, file_2);
end