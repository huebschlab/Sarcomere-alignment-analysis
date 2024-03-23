% get avg values from data
[files,pathname] = uigetfile('*.*', 'Select One or More Files' , 'MultiSelect', 'on');

if isa(files, 'char') == 1
    total = 1;
else
    total = max(size(files));
end

count = 1;
addpath(pathname);
tic

if ispc
    delim = '\';
elseif ismac
    delim = '/';
end

splitstring = strsplit(pathname,delim);
foldername = char(splitstring(1,length(splitstring)-2));

% create empty arrays/vectors to be filled
filenames = cell(length(total),1);

zers = zeros(total,1);
vars = struct('TotalAVGDist',zers,'TotalSTDDist',zers,'MEANAngle',zers,'AVGAngleVary_mean',zers,'STDAngleVary_mean',zers,'REFAngle',zers,'AVGAngleVary_ref',zers,'STDAngleVary_ref',zers);


MSGID = 'MATLAB:xlswrite:AddSheet';
warning('off', MSGID)
% iterate through the number of files and pull out
while count <= total
    
    if isa(files, 'char') == 1
        filename = files;
    else
        filename = files{1,count};
    end
    
    load(filename);
    filename = {filename(1:end-4)};
    

    filenames(count) = filename;
    vars.TotalAVGDist(count) = totalavgspacing;
    vars.TotalSTDDist(count) = totalstdspacing;
    vars.MEANAngle(count) = meanAngle;
    vars.AVGAngleVary_mean(count) = avgAngleVary_mean;
    vars.STDAngleVary_mean(count) = stdAngleVary_mean;
    vars.REFAngle(count) = ref_angle;
    vars.AVGAngleVary_ref(count) = avgAngleVary_ref;
    vars.STDAngleVary_ref(count) = stdAngleVary_ref;



    count = count + 1;
end

T = struct2table(vars,'RowNames', filenames);
writetable(T, [pathname foldername ' Sarcomere Data.xlsx'],'WriteRowName',true,'Sheet','Compiled');

count = 1;
while count <= total
    
    if isa(files, 'char') == 1
        filename = files;
    else
        filename = files{1,count};
    end
    
    load(filename);
    filename = {filename(1:end-4)};
    rownames = {'Average Distance';'Distance SD';'Total Average Distance';'Total SD Distance';'Angle';'Mean Angle';'Angle Variance from Mean';'Average Angle Variance (mean)';'Angle Variance SD (mean)';'Reference Angle';'Angle Variance from Reference';'Average Angle Variance (reference)';'Angle Variance SD (reference)'};
    writecell(filename,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','A1')
    writecell(rownames,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','A2')
    writematrix(avgspacing,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B2')
    writematrix(stdspacing,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B3')
    writematrix(totalavgspacing,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B4')
    writematrix(totalstdspacing,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B5')
    writematrix(lineAngles,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B6')
    writematrix(meanAngle,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B7')
    writematrix(angleVary_mean,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B8')
    writematrix(avgAngleVary_mean,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B9')
    writematrix(stdAngleVary_mean,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B10')
    writematrix(ref_angle,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B11')
    writematrix(angleVary_ref,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B12')
    writematrix(avgAngleVary_ref,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B13')
    writematrix(stdAngleVary_ref,[pathname foldername ' Sarcomere Data.xlsx'],'Sheet',count+1,'Range','B14')

    count = count + 1;
end