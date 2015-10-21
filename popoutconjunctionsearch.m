%First, let's name some experimental variables with defaults (to tell us
%what we need to/can modify).
scrSz = get(0,'ScreenSize'); %Gets the screen size to display the figure fully.
nofcorrecttrials = 200; %This sets the limit for how many correct trials we will collect (160 in assignment).
setsize = [4, 8, 12, 16]; %We can change this if we want different set sizes.
experimentaldata = cell(nofcorrecttrials,5);%We pre-allcoate to the length of nofcorrecttrials
%These are our 5 columns: popoutvsconj (0 = popout), trialsetsize, presentabsent (0 = absent), timetaken, rightvs.wrong(0 = wrong)
popoutdatapres = zeros(nofcorrecttrials,2);%We have two conditions: One for set size, one for RTs.
conjdatapres = zeros(nofcorrecttrials,2); 
popoutdataabs = zeros(nofcorrecttrials,2); 
conjdataabs = zeros(nofcorrecttrials,2); 

correctdatacounter = 1; %A counter to tell us when we've collected enough correct data.
overalldatacounter = 1; %A counter for our while loops

%% Study Introduction (+Creating a figure)

stimuligraph = figure; %Creates a figure named stimuligraph
set(stimuligraph,'Position',scrSz,'Toolbar','none', 'MenuBar', 'none'); %Sets some properties for that fi
introductiontext = text(0.3,0.6, 'Press "f" for target present and "j" for absent.');
introductiontext2 = text(0.4,0.5, 'Press any key to continue.');
set(introductiontext, 'Fontsize', 20);
set(introductiontext2, 'Fontsize', 20);
axis off
pause;
delete(introductiontext);
delete(introductiontext2);

%% This is our pop-out condition.

while correctdatacounter < (nofcorrecttrials/2) + 1
    popoutvsconj = 0; %This tells us that we are looking at data from the popout condition.
    whichsetsize = randi([1,length(setsize)]); %Generates a random integer from 1 to the length of the set size.
    trialsetsize = setsize(whichsetsize); %Randomly samples from the set size pool.
    presentabsent = round(rand(1)); %Randomly determines whether the target is present/absent

    if presentabsent == 0 %This is the absent condition
    %In the pop-out search, if the target is absent, everything should be
    %green, and there should be an equal number of red and green elements.
    Xpos = rand(round(trialsetsize/2), 2); %Generates a matrix of coordiantes for the Xs
    Opos = rand(round(trialsetsize/2), 2); %Generates a matrix of coordiantes for the Os
    figureXs = text(Xpos(:,1), Xpos(:,2), 'X'); %Prints a bunch of Xs
    figureOs = text(Opos(:,1), Opos(:,2), 'O'); %Prints a bunch of Os
    set(figureXs, 'Fontsize', 20, 'Color', 'g'); %Sets font and green color
    set(figureOs, 'Fontsize', 20, 'Color', 'g'); %Sets font and green color
    tic %Start timer
    pause % Wait for userinput
    timetaken = toc; %Save time taken as timetaken
    keypressed = get(stimuligraph, 'CurrentCharacter'); %collect user input
    %Checks for correct input:
    if keypressed == 'j' %If then statement that checks if the answer is correct or not.
        experimentaldata(overalldatacounter,:) = {popoutvsconj, trialsetsize, presentabsent, timetaken, 0};
        popoutdataabs(correctdatacounter,:) = [trialsetsize, timetaken];  
        overalldatacounter = overalldatacounter + 1;
        correctdatacounter = correctdatacounter + 1;
    else
        experimentaldata(overalldatacounter,:) = {popoutvsconj, trialsetsize, presentabsent, timetaken, 1};
        overalldatacounter = overalldatacounter + 1;
    end
    delete(figureXs);
    delete(figureOs);    
    
    elseif presentabsent == 1
    %In the pop-out search, if the target is present, one of the Os should be red,
    %the rest of the stimuli should be green.
    Xpos = rand(round(trialsetsize/2), 2); %Generates a matrix of coordiantes for the Xs
    Opos = rand(round(trialsetsize/2)-1, 2); %Generates a matrix of coordinates for the non-target Os
    targetpos = rand(1,2);
    figureXs = text(Xpos(:,1), Xpos(:,2), 'X');
    figureOs = text(Opos(:,1), Opos(:,2), 'O');
    figureTar = text(targetpos(:,1), targetpos(:,2), 'O');
    set(figureXs, 'Fontsize', 20, 'Color', 'g'); %Sets font and green color
    set(figureOs, 'Fontsize', 20, 'Color', 'g'); %Sets font and green color
    set(figureTar, 'Fontsize', 20, 'Color', 'r'); %Sets font and green color
    tic %Start timer
    pause % Wait for userinput
    timetaken = toc; %Save time taken as timetaken
    keypressed = get(stimuligraph, 'CurrentCharacter'); %collect user input
    %Checks for correct input:
    if keypressed == 'f' %If then statement that checks if the answer is correct or not.
        experimentaldata(overalldatacounter,:) = {popoutvsconj, trialsetsize, presentabsent, timetaken, 0};
        popoutdatapres(correctdatacounter,:) = [trialsetsize, timetaken];
        overalldatacounter = overalldatacounter + 1;
        correctdatacounter = correctdatacounter + 1;
    else
        experimentaldata(overalldatacounter,:) = {popoutvsconj, trialsetsize, presentabsent, timetaken, 1};
        overalldatacounter = overalldatacounter + 1;
    end %end of if statement
    delete(figureXs);
    delete(figureOs);
    delete(figureTar);
    end %end of if statement
end %end of for loop

%% This is our conjunction condition

    %Make sure that the number of green and red stimuli (if you are red/green blind, use
    %blue and red) is balanced in the conjunction search (it should be 50%/50%). Also, make
    %sure that there is an equal number of x and o elements, if possible.
   
while correctdatacounter < nofcorrecttrials + 1
    
    popoutvsconj = 1; %This tells us that we are looking at data from the conjunction condition
    whichsetsize = randi([1,length(setsize)]); %Generates a random integer from 1 to the length of the set size.
    trialsetsize = setsize(whichsetsize); %Randomly samples from the set size pool.
    presentabsent = round(rand(1)); %Randomly determines whether the target is present/absent

    if presentabsent == 0 %If target is absent
    %In the conjunction search, if the target is absent, all the Os should be
    %green, and there should be an equal number of red/green Xs.
    Xpos = rand(round(trialsetsize/2), 2); %Generates a matrix of coordiantes for the Xs
    Opos = rand(round(trialsetsize/2), 2); %Generates a matrix of coordiantes for the Os
    figureXsg = text(Xpos(1:(length(Xpos)/2),1), Xpos(1:(length(Xpos)/2),2), 'X'); %Prints half the Xs to be marked green.
    figureXsr = text(Xpos((length(Xpos)/2):length(Xpos),1), Xpos((length(Xpos)/2):length(Xpos),2), 'X'); %The other half will be red.
    figureOs = text(Opos(:,1), Opos(:,2), 'O');
    set(figureXsg, 'Fontsize', 20, 'Color', 'g'); %Sets font and green color
    set(figureXsr, 'Fontsize', 20, 'Color', 'r'); %Sets font and green color
    set(figureOs, 'Fontsize', 20, 'Color', 'g'); %Sets font and green color
    tic %Start timer
    pause % Wait for userinput
    timetaken = toc; %Save time taken as timetaken
    keypressed = get(stimuligraph, 'CurrentCharacter'); %collect user input
    %Checks for correct input:    
    if keypressed == 'j' %If then statement that checks if the answer is correct or not.
        experimentaldata(overalldatacounter,:) = {popoutvsconj, trialsetsize, presentabsent,timetaken, 0};
        conjdataabs(overalldatacounter,:) = [trialsetsize, timetaken];
        overalldatacounter = overalldatacounter + 1;
        correctdatacounter = correctdatacounter + 1;
    else
        experimentaldata(overalldatacounter,:) = {popoutvsconj, trialsetsize, presentabsent,timetaken, 1};
        overalldatacounter = overalldatacounter + 1;
    end
    delete(figureXsg);
    delete(figureXsr);
    delete(figureOs);
    
    elseif presentabsent == 1
    %In the conjunction search, if the target is present, one of the Os should
    %be red, and there should be an equal number of red/green Xs (all the others Os
    %should be green).
    Xpos = rand(round(trialsetsize/2), 2); %Generates a matrix of coordiantes for the Xs
    Opos = rand(round(trialsetsize/2)-1, 2); %Generates a matrix of coordinates for the non-target Os
    targetpos = rand(1,2);
    figureXsg = text(Xpos(1:(length(Xpos)/2)-1,1), Xpos(1:(length(Xpos)/2)-1,2), 'X'); %Prints half the Xs to be marked green.
    figureXsr = text(Xpos((length(Xpos)/2):length(Xpos),1), Xpos((length(Xpos)/2):length(Xpos),2), 'X'); %The other half will be red.
    figureOs = text(Opos(:,1), Opos(:,2), 'O');
    figureTar = text(targetpos(:,1), targetpos(:,2), 'O');
    set(figureXsg, 'Fontsize', 20, 'Color', 'g'); %Sets font and green color
    set(figureXsr, 'Fontsize', 20, 'Color', 'r'); %Sets font and green color
    set(figureOs, 'Fontsize', 20, 'Color', 'g'); %Sets font and green color
    set(figureTar, 'Fontsize', 20, 'Color', 'r'); %Sets font and green color
    tic %Start timer
    pause % Wait for userinput
    timetaken = toc; %Save time taken as timetaken
    keypressed = get(stimuligraph, 'CurrentCharacter'); %collect user input
    %Checks for correct input:       
    if keypressed == 'f' %If then statement that checks if the answer is correct or not.
        experimentaldata(overalldatacounter,:) = {popoutvsconj, trialsetsize, presentabsent,timetaken, 0};
        conjdatapres(overalldatacounter,:) = [trialsetsize, timetaken];
        overalldatacounter = overalldatacounter + 1;
        correctdatacounter = correctdatacounter + 1;
    else
        experimentaldata(overalldatacounter,:) = {popoutvsconj, trialsetsize, presentabsent,timetaken, 1};
        overalldatacounter = overalldatacounter + 1;
    end %end of if statement
    delete(figureXsg);
    delete(figureXsr);
    delete(figureOs);
    delete(figureTar);
    end  %end of inside if statement
end %end of for loop
close(stimuligraph);

%% Data Analyses

%1. Pruning

%Remove all the 0s caused by indexing
popoutpresclean = popoutdatapres(find(popoutdatapres(:,1) ~= 0),:);
popoutabsclean = popoutdataabs(find(popoutdataabs(:,1) ~= 0),:);
conjpresclean = conjdatapres(find(conjdatapres(:,1) ~= 0),:);
conjabsclean = conjdataabs(find(conjdataabs(:,1) ~= 0),:);

%Sort trials by set size
popoutpresclean = sort(popoutpresclean,1);
popoutabsclean = sort(popoutabsclean,1);
conjpresclean= sort(conjpresclean,1);
conjabsclean = sort(conjabsclean,1);

%2. We find the means for each of the set sizes

popoutpresmeans = [];
popoutabsmeans = [];
conjpresmeans = [];
conjabsmeans = [];

%This loop goes through all the potential set sizes, and returns the mean
%for each one (e.g., the mean RT when the set-size is 4, and so on).
meanscounter = 1;
for jj = setsize

popoutpresmeans(meanscounter,:) = [jj, mean(popoutpresclean(find(popoutpresclean(:,1) == jj),2))];
popoutabsmeans(meanscounter,:) = [jj, mean(popoutabsclean(find(popoutabsclean(:,1) == jj),2))];
conjpresmeans(meanscounter,:) = [jj, mean(conjpresclean(find(conjpresclean(:,1) == jj),2))];
conjabsmeans(meanscounter,:) = [jj, mean(conjabsclean(find(conjabsclean(:,1) == jj),2))];
meanscounter = meanscounter + 1;
end


%Print the means
popoutpresmeans
popoutabsmeans
conjpresmeans
conjabsmeans

%3. Correlations

[PopOutPresentPearsonR, PopOutPresentpvalue] = corrcoef(popoutpresclean)
[PopOutAbsentPearsonR, PopOutAbsentpvalue] = corrcoef(popoutabsclean)
[ConjunctionPresentPearsonR, ConjunctionPresentpvalue] = corrcoef(conjpresclean)
[ConjunctionAbsentPearsonR, ConjunctionAbsentpvalue] = corrcoef(conjabsclean)

%4. Plots

%For stimuli present
presentplot = figure;
hold on;
popoutpresline = plot(popoutpresmeans(:,1), popoutpresmeans(:, 2));
conjpresline = plot(conjpresmeans(:,1), conjpresmeans(:, 2));
set(popoutpresline, 'Color', 'Blue');
set(conjpresline, 'Color', 'Red');
xlabel('Set Size');
ylabel('RT');
title('Target Present');
legend('Blue = Pop-out','Red = Conjunction', 'Location', 'Northwest');
hold off;

%For stimuli absent
absentplot = figure;
hold on;
plot(popoutabsmeans(:,1), popoutabsmeans(:, 2));
plot(conjabsmeans(:,1), conjabsmeans(:, 2));
xlabel('Set Size');
ylabel('RT');
title('Target Absent');
legend('Blue = Pop-out','Red = Conjunction', 'Location', 'Northwest');
hold off;