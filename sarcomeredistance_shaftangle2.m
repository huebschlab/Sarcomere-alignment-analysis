function sarcomeredistance_shaftangle2
[files,pathname] = uigetfile('*.*', 'Select One or More Files' , 'MultiSelect', 'on');

if ispc
    delim = '\';
elseif ismac
    delim = '/';
end

if isa(files, 'char') == 1
    total = 1;
else
    total = max(size(files));
end

list = {'4X - No Bining: 1.612903226 um/px','4X - 2x2 Bining: 3.205128205 um/px','4X - 4x4 Bining: 6.25 um/px','10X - No Bining: 0.657894737 um/px','10X - 2x2 Bining: 1.25 um/px','10X - 4x4 Bining: 2.5 um/px','20X - No Bining: 0.322580645 um/px','20X - 2x2 Bining: 0.657894737 um/px','20X - 4x4 Bining: 1.25 um/px','60X - No Bining: 0.111111111 um/px','60X - 2x2 Bining: 0.219298246 um/px','60X - 4x4 Bining: 0.434782609 um/px','FV1000 Confocal 1.35NA 60X: 0.207 um/px','Custom Scaling Factor'};
objbin = listdlg('PromptString',{'What objective and binning type was used?'},'SelectionMode','single','ListString',list);

switch objbin
    case 1
        scale = 1.612903226; % um/pixel
    case 2
        scale = 3.205128205;
    case 3
        scale = 6.25;
    case 4
        scale = 0.657894737;
    case 5
        scale = 1.25;
    case 6
        scale = 2.5;
    case 7
        scale = 0.322580645;
    case 8
        scale = 0.657894737;
    case 9
        scale = 1.25;
    case 10
        scale = 0.111111111;
    case 11
        scale = 0.219298246;
    case 12
        scale = 0.434782609;
    case 13
        scale = 0.207;
    case 14
        scale = str2double(cell2mat(inputdlg('Input custom scaling factor (um/pixel)')));
end

count = 1; %Set count for total number of files to be analyzed


figPanel = figure('Units','normalized','Position',[.18 .2769 .625 .6481]);
imageAxes = axes('Parent',figPanel,'Position',[0 .1986 .48 .7714]);
lineAxes= axes('Parent',figPanel,'Position',[.52 .5 .47 .49]);
low_in = 0;
high_in = 1;
contrast_panel = uipanel('Parent',figPanel,'Title','Contrast Adjuster','Position',[0.008 0.017 0.35 0.17]);

low_in_slider = uicontrol('Parent',contrast_panel,'Style','slider', 'Units','normalized','Position',[.02 .5 .96 .2],...
    'SliderStep',[0.01 .1],'value',low_in,'min',0,'max',1,'Callback',{@low_in_slider_callback});
addlistener(low_in_slider,'ContinuousValueChange',@low_in_slider_callback);
uicontrol('Parent',contrast_panel,'Style','text','String','Minimum Brightness','Units','normalized','Position',[0.3 0.75 0.4 0.2]);
[lowInSlider_Default{1:3}] = get_default_state(low_in_slider);


high_in_slider = uicontrol('Parent',contrast_panel,'Style','slider','Units','normalized','Position',[0.02 0.04 0.96 0.2],...
    'SliderStep',[0.01 .1],'value',high_in,'min',0,'max',1,'Callback',{@high_in_slider_callback});
addlistener(high_in_slider,'ContinuousValueChange',@high_in_slider_callback);
uicontrol('Parent',contrast_panel,'Style','text','String','Maximum Brightness','Units','normalized','Position',[0.3 0.27 0.4 0.2]);
[highInSlider_Default{1:3}] = get_default_state(high_in_slider);


% useImage = '';
useImage_Panel = uipanel('Parent',figPanel,'Position',[.36, 0.017 .12 .17]);
uicontrol('Parent',useImage_Panel,'Style','text','String','Analyze chosen image?','Units','normalized','Position',[0.1 .8 .9 .2]);
useImage_button = uicontrol('Parent',useImage_Panel,'Style','pushbutton','String','Yes','Units','normalized','Position',[0.2 0.5 0.6 0.17],'Enable','off','Callback',{@useImageButton_callback});
nextImage_button = uicontrol('Parent',useImage_Panel,'Style','pushbutton','String','No, next image','Units','normalized','Position',[0.2 0.168 0.6 0.17],'Enable','off','Callback',{@nextImageButton_callback});

shaft_Panel = uipanel('Parent',figPanel,'Position',[0.5 0.285 0.1 0.17]);
uicontrol('Parent',shaft_Panel,'Style','text','String','Measure overall angle?','Units','normalized','Position',[0.1 .8 .9 .2]);
measureAng_button = uicontrol('Parent',shaft_Panel,'Style','pushbutton','String','Yes (Shaft)','Units','normalized','Position',[0.1 0.5 0.8 0.17],'Enable','off','Callback',{@measureAng_callback});
noAng_button = uicontrol('Parent',shaft_Panel,'Style','pushbutton','String','No (Knob)','Units','normalized','Position',[0.1 0.168 0.8 0.17],'Enable','off','Callback',{@noAng_callback});


useLine_Panel = uipanel('Parent',figPanel,'Position',[0.63 0.285 0.1 0.17]);
uicontrol('Parent',useLine_Panel,'Style','text','String','Use drawn line?','Units','normalized','Position',[0.1 .8 .9 .2]);
useLine_button = uicontrol('Parent',useLine_Panel,'Style','pushbutton','String','Yes','Units','normalized','Position',[0.1 0.5 0.8 0.17],'Enable','off','Callback',{@useLineButton_callback});
redrawLine_button = uicontrol('Parent',useLine_Panel,'Style','pushbutton','String','Redraw','Units','normalized','Position',[0.1 0.168 0.8 0.17],'Enable','off','Callback',{@redrawLineButton_callback});


usepeaks = '';
usepeaks_Panel = uipanel('Parent',figPanel,'Position',[.76 .285 .1 .17]);
resetpeaks_button = uicontrol('Parent',usepeaks_Panel,'Style','pushbutton','String','Reset peaks','Units','normalized','Position',[0.1 0.5 0.8 0.17],'Enable','off','Callback',{@resetpeaksButton_callback});

drawNewLine = '';
newLine_Panel = uipanel('Parent',figPanel,'Position',[.89 .285 .1 .17]);
newLine_button = uicontrol('Parent',newLine_Panel,'Style','pushbutton','String','Draw another line','Units','normalized','Position',[0.1 0.5 0.8 0.17],'Enable','off','Callback',{@newLineButton_callback});
newImage_button = uicontrol('Parent',newLine_Panel,'Style','pushbutton','String','Move to next image','Units','normalized','Position',[0.1 0.168 0.8 0.17],'Enable','off','Callback',{@newImageButton_callback});





while count <= total

    %Initialize text objects
    low_in = 0;
    high_in = 1;
    firstline = '';
    secondline = '';
    thirdline = '';
    fourthline = '';
    fifthline = '';
    sixthline = '';
    seventhline = '';
    eighthline = '';
    ninthline = '';
    tenthline = '';
    firstLine_Text = gobjects(0);
    secondLine_Text = gobjects(0);
    thirdLine_Text = gobjects(0);
    fourthLine_Text = gobjects(0);
    fifthLine_Text = gobjects(0);
    sixthLine_Text = gobjects(0);
    seventhLine_Text = gobjects(0);
    eigthLine_Text = gobjects(0);
    ninthLine_Text = gobjects(0);
    tenthLine_Text = gobjects(0);
    newline = 0;
    count2 = 1;
    spacing = [];
    linex = [];
    liney = [];
    lineData = [];
    lineAngle = [];
    lineAngles = [];


    % choose specific file
    tic
    if isa(files, 'char') == 1
        filename = files;
    else

        filename = files{1,count};
    end
    comWin_Pan = uipanel('Parent',figPanel,'BackgroundColor','white','Title','Command Window','Position',[.5 0 .45 .275],'BorderType','none');

    filetitle = uicontrol('Parent',figPanel,'Style','text','String',filename,'FontSize',8,'Fontweight','bold','Units','normalized','Position',[0 .97 .4 .03]);
    progresscounter = uicontrol('Parent',figPanel,'Style','text','String',[num2str(count) 'of' num2str(total)],'FontSize',12,'Fontweight','bold','Units','normalized','Position',[.95 .0 .05 .05]);

    [~,~,ext] = fileparts([pathname filename]);


    if ext == ".oif"
        foldername = [pathname filename '.files' delim];
        file = 's_C003.tif';  % Will need to change to name of file with the specific .tif image to be analyzed.
        t = Tiff([foldername file]);
        imageData = read(t);
        % Determine scaling factor from magnification and bining

    elseif ext == ".nd2"
        data = bfopen([pathname filename]);
        imageData = data{1,1}{1,1};

    elseif ext == ".tif"
        t = Tiff([pathname filename]);
        imageData = read(t);
        
    else
        try
            t = imread([pathname filename]);
        catch
            if exist('firstLine_Text','var')
                delete(firstLine_Text);
            end

            peaks = NaN;
            spacing = NaN;
            lineAngle = NaN;
            ref_angle = NaN;
            badImageBox = msgbox("File type not compatible! Move to next file.","Warning","warn");
            set(badImageBox,'Deletefcn',@nextImageButton_callback);
            uiwait(badImageBox);
            count = count + 1;
            continue

        end

        if ndims(t) == 3
            imageData = rgb2gray(t);
        else
            imageData = t;
        end

    end
    imageData= double(imageData);
    imageData = imageData/max(imageData,[],'all');
    filename = filename(1:end-4);










    currentImage = imagesc(imageAxes,imadjust(imageData,[low_in high_in]));
    axis(imageAxes,'off')
    colormap(imageAxes,gray);

    useImage = 0;
    useImage_button.Enable = 'on';
    nextImage_button.Enable = 'on';
    uiwait(figPanel);

    if useImage == 1
        if exist('firstLine_Text','var')
            delete(firstLine_Text);
        end


        whichline = '';
        goodref_line = 0;
        ref_line = [];

        measureAng_button.Enable = 'on';
        noAng_button.Enable = 'on';

        uiwait(figPanel);



        if goodref_line == 0
            while goodref_line == 0
                ref_line = drawline(imageAxes,'LineWidth',1);
                ref_x = ref_line.Position(:,1);
                ref_y = ref_line.Position(:,2);
                if ref_x(1) == ref_x(2) && ref_y(1) == ref_y(2)
                    if exist('firstLine_Text','var')
                        delete(firstLine_Text);
                    end
                    firstLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String','Point was drawn. Redraw line.',...
                        'Units','normalized','Position',[0 0 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
                        'BackgroundColor','white');textMove_callback;
                    delete(ref_line);
                else
                    whichline = 'refline';
                    useLine_button.Enable = 'on';
                    redrawLine_button.Enable = 'on';
                    uiwait(figPanel)
                end
            end



        else
            ref_angle = nan;
        end








        firstLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String','Draw line over sarcomeres',...
            'Units','normalized','Position',[0 0 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
            'BackgroundColor','white');textMove_callback;


 
        while newline == 0

            goodline = 0;
            line = [];
            while goodline == 0
                line = drawline(imageAxes,'LineWidth',1);
                x = line.Position(:,1);
                y = line.Position(:,2);
                if x(1) == x(2) && y(1) == y(2)
                    if exist('firstLine_Text','var')
                        delete(firstLine_Text);
                    end
                    firstLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String','Point was drawn. Redraw line.',...
                        'Units','normalized','Position',[0 0 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
                        'BackgroundColor','white');textMove_callback;
                    delete(line);
                    cla(lineAxes);
                else
                    [linex,liney,lineData] = improfile(imageData,x,y);
                    plot(lineAxes, lineData);
                    xlowerlim = 1-(round(0.05*length(lineData)));
                    xupperlim = length(lineData)+(round(0.05*length(lineData)));
                    xlim(lineAxes,[xlowerlim xupperlim]);

                    whichline = 'lines';
                    useLine_button.Enable = 'on';
                    redrawLine_button.Enable = 'on';
                    uiwait(figPanel)
                end
            end


            numpeak = 1;
            selectpeaks = 0;
            peaks = zeros(100,2);
            while selectpeaks == 0
                peakzone = [];

                if numpeak == 1
                    if exist('firstLine_Text','var')
                        delete(firstLine_Text);
                    end
                    firstLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String','Pick point to left of left most peak',...
                        'Units','normalized','Position',[0 0 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
                        'BackgroundColor','white');textMove_callback;
                    leftpoint = drawpoint(lineAxes,'Markersize',1);
                    p1 = round(leftpoint.Position(1));
                    py = leftpoint.Position(2);
                    delete(leftpoint)
                    lastline = xline(lineAxes,p1,'r-');


                    if exist('firstLine_Text','var')
                        delete(firstLine_Text);
                    end
                    firstLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String','Pick point to left of the next peak',...
                        'Units','normalized','Position',[0 0 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
                        'BackgroundColor','white');textMove_callback;
                    rightpoint = drawpoint(lineAxes,'Markersize',1);
                    p2 = rightpoint.Position(1);
                    if p2>xupperlim - 1 && p2 < xupperlim
                        p2 = xupperlim-1;
                    else
                        p2 = round(p2);
                    end
                    py = rightpoint.Position(2);
                    py = rightpoint.Position(2);
                    delete(rightpoint)
                    lastline = xline(lineAxes,p2,'r-');

                else


                    if exist('firstLine_Text','var')
                        delete(firstLine_Text);
                    end
                    firstLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String','Pick point to left of the next peak',...
                        'Units','normalized','Position',[0 0 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
                        'BackgroundColor','white');textMove_callback;
                    p1 = p2;
                    rightpoint = drawpoint(lineAxes,'Markersize',1);
                    p2 = rightpoint.Position(1);
                    if p2>xupperlim - 1 && p2 < xupperlim
                        p2 = xupperlim-1;
                    else
                        p2 = round(p2);
                    end
                    py = rightpoint.Position(2);


                end
                if p1 < 1
                    p1 = 1;
                end

                if p2 >= length(lineData) && p2 < xupperlim
                    p2 = length(lineData);
                    selectpeaks = 2;
                end

                if p2 >= xupperlim  || p2 <= p1 || py >= max(lineData) || py <= min(lineData)
                    p2 = length(lineData);
                    resetpeaks_button.Enable = 'on';
                    if numpeak > 1

                        newLine_button.Enable = 'on';
                        newImage_button.Enable = 'on';
                    end
                    delete(rightpoint)
                    lastline.Color = 'cyan';

                    if exist('firstLine_Text','var')
                        delete(firstLine_Text);
                    end
                    firstLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String',[num2str(count2) ' lines analyzed'],...
                        'Units','normalized','Position',[0 0 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
                        'BackgroundColor','white');textMove_callback;
                    uiwait(figPanel);
                else
                    delete(rightpoint)
                    lastline = xline(lineAxes,p2,'r-');
                    peakzone(:,1) = lineData(p1:p2);
                    peakzone(:,2) = (p1:p2);
                    [~,peakindind] = max(peakzone(:,1));
                    hold(lineAxes,'on');
                    peakind = peakzone(peakindind,2);
                    plot(lineAxes,peakind,lineData(peakind),'ro')
                    peaks(numpeak,:) = [linex(peakind) liney(peakind)];



                    numpeak = numpeak+1;
                end

                if selectpeaks == 2
                    resetpeaks_button.Enable = 'on';
                    if numpeak > 1

                        newLine_button.Enable = 'on';
                        newImage_button.Enable = 'on';
                    end
                    delete(rightpoint)
                    lastline.Color = 'cyan';

                    if exist('firstLine_Text','var')
                        delete(firstLine_Text);
                    end
                    firstLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String',[num2str(count2) ' lines analyzed'],...
                        'Units','normalized','Position',[0 0 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
                        'BackgroundColor','white');textMove_callback;

                    uiwait(figPanel);
                end




            end






        end
    end
    delete(progresscounter);
    delete(filetitle);
    clearvars -except count total pathname files scale isnd2 delim figPanel imageAxes lineAxes contrast_panel...
        lowInSlider_title lowInSlider_listener low_in_slider lowInSlider_Default...
        highInSlider_title highInSlider_listener high_in_slider highInSlider_Default...
        useImage_Panel useImage_Text useImage_button nextImage_button...
        useLine_Panel useLine_Text useLine_button redrawLine_button...
        usepeaks_Panel resetpeaks_button...
        newLine_Panel newLine_button newImage_button...
        noAng_button measureAng_button



    count = count + 1;
end
close all


%% Use Image
    function useImageButton_callback(~,~)
        %         useImage = 'Yes';
        useImage_button.Enable = 'off';
        nextImage_button.Enable = 'off';
        useImage = 1;
        uiresume(figPanel)
    end

%% Next Image
    function nextImageButton_callback(~,~)
        useImage = 'No';
        useImage_button.Enable = 'off';
        nextImage_button.Enable = 'off';
        set(highInSlider_Default{1:3});
        set(lowInSlider_Default{1:3});
        cla(imageAxes);
        uiresume(figPanel);
    end

%% Adjust Contrast
    function low_in_slider_callback(source,~)
        low_in = get(source,'Value');
        if low_in >= high_in
            low_in = high_in - 0.01;
        end
        set(currentImage,'CData',imadjust(imageData,[low_in high_in]))
    end

    function high_in_slider_callback(source,~)
        high_in = get(source,'Value');
        if high_in <= low_in
            high_in = low_in + 0.01;
        end
        set(currentImage,'CData',imadjust(imageData,[low_in high_in]))
    end

%% Draw Reference Line
    function measureAng_callback(~,~)
        measureAng_button.Enable = 'off';
        noAng_button.Enable = 'off';
        firstLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String','Draw reference line',...
            'Units','normalized','Position',[0 0 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
            'BackgroundColor','white');textMove_callback;
        goodref_line = 0;
        uiresume(figPanel);
    end


%% No Reference Line
    function noAng_callback(~,~)
        measureAng_button.Enable = 'off';
        noAng_button.Enable = 'off';
        goodref_line = 1;
        uiresume(figPanel);
    end


%% Use Line
    function useLineButton_callback(~,~)
        switch whichline
            case 'lines'
                goodline = 1;
                useLine_button.Enable = 'off';
                redrawLine_button.Enable = 'off';
                xVec = x(2) - x(1);
                yVec = (size(imageData,1) - y(2)) - (size(imageData,1) - y(1));
                lineAngle = wrapTo360(rad2deg(atan2(yVec,xVec)));
                uiresume(figPanel);
            case 'refline'
                goodref_line = 1;
                useLine_button.Enable = 'off';
                redrawLine_button.Enable = 'off';
                ref_xVec = ref_x(2) - ref_x(1);
                ref_yVec = (size(imageData,1) - ref_y(2)) - (size(imageData,1) - ref_y(1));
                ref_angle = wrapTo360(rad2deg(atan2(ref_yVec,ref_xVec)));
                delete(ref_line)
                uiresume(figPanel);
        end
    end

%% Redraw Line
    function redrawLineButton_callback(~,~)
        switch whichline
            case 'lines'
                useLine_button.Enable = 'off';
                redrawLine_button.Enable = 'off';
                delete(line);
                cla(lineAxes);
                if exist('firstLine_Text','var')
                    delete(firstLine_Text);
                end
                firstLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String','Redraw line',...
                    'Units','normalized','Position',[0 0 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
                    'BackgroundColor','white');textMove_callback;
                uiresume(figPanel);
            case 'refline'
                useLine_button.Enable = 'off';
                redrawLine_button.Enable = 'off';
                delete(ref_line);
                if exist('firstLine_Text','var')
                    delete(firstLine_Text);
                end
                firstLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String','Redraw line',...
                    'Units','normalized','Position',[0 0 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
                    'BackgroundColor','white');textMove_callback;
                uiresume(figPanel);
        end
    end

%% Reset Peak Picking
    function resetpeaksButton_callback(~,~)
        resetpeaks_button.Enable = 'off';
        newLine_button.Enable = 'off';
        newImage_button.Enable = 'off';
        cla(lineAxes);
        plot(lineAxes, lineData);
        peaks = zeros(100,2);
        numpeak = 1;
        selectpeaks = 0;
        uiresume(figPanel);
    end

%% Finish Peak Picking and Draw New Line
    function newLineButton_callback(~,~)
        resetpeaks_button.Enable = 'off';
        newLine_button.Enable = 'off';
        newImage_button.Enable = 'off';
        selectpeaks = 1;
        peakCrop = find(peaks == 0, 1, 'first');
        peaks = peaks(1:peakCrop-1,:);

        for i = 1:size(peaks,1)-1
            spacing(i,count2) = sqrt((peaks(i,1)-peaks(i+1,1))^(2)+(peaks(i,2)-peaks(i+1,2))^(2));
        end
        spacing(:,count2) = spacing(:,count2).*scale; %convert from pixel to um
        lineAngles(count2) = lineAngle;
        count2 = count2+1;
        cla(lineAxes);
        set(line,'Color','green');
        uiresume(figPanel);
    end

%% Finish Peak Picking and Move to Next Image
    function newImageButton_callback(~,~)
        resetpeaks_button.Enable = 'off';
        newLine_button.Enable = 'off';
        newImage_button.Enable = 'off';
        selectpeaks = 1;
        set(highInSlider_Default{1:3});
        set(lowInSlider_Default{1:3});
        newline = 1;

        peakCrop = find(peaks == 0, 1, 'first');
        peaks = peaks(1:peakCrop-1,:);
        for i = 1:size(peaks,1)-1
            spacing(i,count2) = sqrt((peaks(i,1)-peaks(i+1,1))^(2)+(peaks(i,2)-peaks(i+1,2))^(2)); %#ok<*AGROW>
        end
        spacing(:,count2) = spacing(:,count2).*scale; %convert from pixel to um
        spacing(find(spacing == 0)) = nan; %#ok<FNDSB>
        avgspacing = mean(spacing, 1,'omitnan');
        totalavgspacing = mean(avgspacing);
        stdspacing = std(spacing, [],1,'omitnan');
        totalstdspacing = std(spacing, [],'all','omitnan');


        lineAngles(count2) = lineAngle;
        lineAngleX = cosd(lineAngles);
        lineAngleY = sind(lineAngles);
        avgAngleX = mean(lineAngleX);
        avgAngleY = mean(lineAngleY);
        meanAngle = wrapTo360(atan2d(avgAngleY,avgAngleX));
        angleVary_mean = abs(wrapTo180(meanAngle) - wrapTo180(lineAngles));
        angleVary_mean(angleVary_mean>90) = abs(180 - angleVary_mean(angleVary_mean>90));
        avgAngleVary_mean = mean(angleVary_mean);
        stdAngleVary_mean = std(angleVary_mean);
        angleVary_ref = abs(wrapTo180(ref_angle)-wrapTo180(lineAngles));
        angleVary_ref(angleVary_ref>90) = abs(180 - angleVary_ref(angleVary_ref>90));
        avgAngleVary_ref = mean(angleVary_ref);
        stdAngleVary_ref = std(angleVary_ref);




        if isequal(exist([pathname 'Sarcomere Distances'], 'dir'),0)
            mkdir([pathname 'Sarcomere Distances'])
        end
        cla(lineAxes);
        cla(imageAxes);

        save([pathname 'Sarcomere Distances' delim filename '.mat'],'spacing','avgspacing','stdspacing','totalavgspacing','totalstdspacing','lineAngles','angleVary_mean','meanAngle','avgAngleVary_mean','stdAngleVary_mean','ref_angle','angleVary_ref','avgAngleVary_ref','stdAngleVary_ref')
        uiresume(figPanel);
    end


%% Pseudo Command Window Output
    function textMove_callback(~,~)
        tenthline = ninthline;
        ninthline = eighthline;
        eighthline = seventhline;
        seventhline = sixthline;
        sixthline = fifthline;
        fifthline = fourthline;
        fourthline = thirdline;
        thirdline = secondline;
        secondline = firstline;
        firstline = get(firstLine_Text,'String');






        if exist('tenthLine_Text','var') %#ok<*NODEF>
            delete(tenthLine_Text);
        end
        if exist('ninthLine_Text','var')
            delete(ninthLine_Text);
        end
        if exist('eigthLine_Text','var')
            delete(eigthLine_Text);
        end
        if exist('seventhLine_Text','var')
            delete(seventhLine_Text);
        end
        if exist('sixthLine_Text','var')
            delete(sixthLine_Text);
        end
        if exist('fifthLine_Text','var')
            delete(fifthLine_Text);
        end
        if exist('fourthLine_Text','var')
            delete(fourthLine_Text);
        end
        if exist('thirdLine_Text','var')
            delete(thirdLine_Text);
        end
        if exist('secondLine_Text','var')
            delete(secondLine_Text);
        end



        tenthLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String',tenthline,...
            'Units','normalized','Position',[0 .9 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
            'BackgroundColor','white'); %#ok<*NASGU>
        ninthLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String',ninthline,...
            'Units','normalized','Position',[0 .8 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
            'BackgroundColor','white');
        eigthLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String',eighthline,...
            'Units','normalized','Position',[0 .7 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
            'BackgroundColor','white');
        seventhLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String',seventhline,...
            'Units','normalized','Position',[0 .6 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
            'BackgroundColor','white');
        sixthLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String',sixthline,...
            'Units','normalized','Position',[0 .5 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
            'BackgroundColor','white');
        fifthLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String',fifthline,...
            'Units','normalized','Position',[0 .4 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
            'BackgroundColor','white');
        fourthLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String',fourthline,...
            'Units','normalized','Position',[0 .3 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
            'BackgroundColor','white');
        thirdLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String',thirdline,...
            'Units','normalized','Position',[0 .2 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
            'BackgroundColor','white');
        secondLine_Text = uicontrol('Parent',comWin_Pan,'Style','text','String',secondline,...
            'Units','normalized','Position',[0 .1 1 .1],'Fontsize',12,'HorizontalAlignment','left',...
            'BackgroundColor','white');


    end



end





% Local function:
function [guicontroller,propArray, valueArray] = get_default_state(guicontroller)
propArray = fieldnames(set(guicontroller(1)));
valueArray = get(guicontroller, propArray);
end


