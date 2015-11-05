%% Clear our canvas
close all

%% Let's initialize some variables
numberoftrials = 100; %Variable to determine how many correct trials we want.
trialnumber = 1; %Variable to count the number of total valid trials
flashresults = []; %We'll store our results here
arrowresults = [];
results = [];
leftrightpos = {[0.2 0.4 0.1 0.2], [0.6 0.4 0.1 0.2]}; %Presets for left-right position of stimulus
updownpos = {[0.42 0.7 0.1 0.2], [0.42 0.1 0.1 0.2]}; %Presets for up-down position of stimulus
arrowleftright = {[.55 .45],[.6, .6];[.45 .55],[.6 .6]};
arrowupdown ={[.45 .45], [.45 .6]; [.45 .45],[.6 .45]};

%% Let's make a figure that we will use throughout the experiment, and write some instructions

ourdisplay = figure('units','normalized','outerposition',[0 0 1 1], 'KeyPressFcn',@(obj,evt) 0); %Makes a fullscreen display and disables keypresses
set(ourdisplay, 'Toolbar','none', 'MenuBar', 'none', 'Color', [0 0 0 ]); %Sets up our display
xlim([0 1]); %Sets the axes for uor display
ylim([0 1]); %Same
axis off %Turns off the axes
instructions1 = text(.3,.6, 'A white cross "+" will appear. Stare at it.', 'Fontsize', 20, 'Color', [1 1 1]);
instructions2 = text(.2,.5, 'Press any key when you see a white rectangle.', 'Fontsize', 20, 'Color',  [1 1 1]);
waitforbuttonpress; %Waits for participants to press button
delete(instructions1); %Clears the screen of our instructions
delete(instructions2); %Ditto

%% We need 2 (arrows vs. flashes) x 2 (horizontal vs. vertical) x 2 (valid vs. invalid) stimuli.

fixationcross = text (.45, .5, '+', 'Fontsize', 60, 'Color', [1 1 1]); %Produces a fixation cross
counterbalance = randi([0,1]); %0 = flash, 1 = arrow
for conditions = 1:2
    trialnumber = 1;
    if counterbalance == 0
    while trialnumber < (numberoftrials/2) + 1 %Loop untill we've collected all our data for the flash
    %We create some variables to determine what is shown.
    horizontalvertical = randi([0,1]); %Determines if the current trial is horizontal or vertical
    validcue = randi([1,10]); %Determine if the current cue will be valid or invalid
    stimulusonset = randi([1,500])/1000; %For stimulus onset.
    leftrightupdown = randi([1,2]); %Randomizes direction
    %Now we simply have a bunch of if statements representing our
    %conditions.
    if horizontalvertical == 0 %If we are using arrows and horizontal for this trial
        pause(stimulusonset); %Delay by a random amount (to keep participants guessing)
        %Draw a cue rectangle
        cuerectangle = rectangle('Position',leftrightpos{leftrightupdown},'FaceColor', [0 0 0 ], 'EdgeColor', [0 0 0]);
        for ii = 1:2; %Flash it a couple of times
            set(cuerectangle, 'EdgeColor', [1 1 1]); %By changing the color of the edges of this black rectangle
            pause(.05);
            set(cuerectangle, 'EdgeColor', [0 0 0]);
            pause(.05);
        end
            delete(cuerectangle); %Get rid of it
        if validcue < 8 %If the cue is valid
            %Draw a stimulus rectangle
            stimulusrectangle = rectangle('Position',leftrightpos{leftrightupdown},'FaceColor', [1, 1, 1], 'EdgeColor', [1, 1, 1]);
        elseif validcue >= 8 %If the cue is invalid
            %Draw a stimulus rectangle *at the opposite location*.
            %modulo(leftrightupdown,2)+1 returns the opposite value of that
            %inital random variable (e.g., if leftrightupdown was 2,
            %modulo(2,2) will return 1).
            stimulusrectangle = rectangle('Position',leftrightpos{(mod(leftrightupdown,2)+1)},'FaceColor', [1, 1, 1], 'EdgeColor', [1, 1, 1]);
        end
        tic
        waitforbuttonpress; %Wait for Ps to push button
        delete(stimulusrectangle); %Get rid of stimulus rectangle
        RT = toc;
        flashresults(trialnumber,:) = [RT,1];
    elseif horizontalvertical == 1 %If we are using arrows and vertical for this trial
        pause(stimulusonset); %Delay by a random amount (to keep participants guessing)
        %Draw a cue rectangle
        cuerectangle = rectangle('Position',updownpos{leftrightupdown},'FaceColor', [0 0 0 ], 'EdgeColor', [0 0 0]);
        for ii = 1:2; %Flash it a couple of times
            set(cuerectangle, 'EdgeColor', [1 1 1]); %By changing the color of the edges of this black rectangle
            pause(.05);
            set(cuerectangle, 'EdgeColor', [0 0 0]);
            pause(.05);
        end
            delete(cuerectangle); %Get rid of it
            %Draw a stimulus rectangle
        if validcue < 8 %If the cue is valid
            stimulusrectangle = rectangle('Position',updownpos{leftrightupdown},'FaceColor', [1, 1, 1], 'EdgeColor', [1, 1, 1]);
        elseif validcue >= 8 %If the cue is invalid
            %Draw a stimulus rectangle at the opposite location
            stimulusrectangle = rectangle('Position',updownpos{(mod(leftrightupdown,2)+1)},'FaceColor', [1, 1, 1], 'EdgeColor', [1, 1, 1]);
        end
        tic
        waitforbuttonpress; %Wait for Ps to push button
        delete(stimulusrectangle); %Get rid of stimulus rectangle
        RT = toc;
        flashresults(trialnumber,:) = [RT,2];
    end
    %pause(2.5); %Pause between trials
    trialnumber = trialnumber + 1;
    end
    end
    
    if counterbalance == 1
    trialnumber = 1;
    while trialnumber < (numberoftrials/2) + 1 %Loop untill we've collected all our data for the arrows
    horizontalvertical = randi([0,1]); %Determines if the current trial is horizontal or vertical
    validcue = randi([1,10]); %Determine if the current cue will be valid or invalid
    stimulusonset = randi([1,500])/1000; %For stimulus onset.
    leftrightupdown = randi([1,2]); %Randomizes direction
    if horizontalvertical == 0 %If we are using flashes and horizontal for this trial
        pause(stimulusonset); %Delay by a random amount (to keep participants guessing)
        %Draw an arrow
        arrow = annotation('arrow',arrowleftright{leftrightupdown,:}, 'Color', [1 1 1], 'HeadWidth', 40, 'HeadLength', 40, 'LineWidth', 5);
        if validcue < 8 %If the cue is valid
            pause(stimulusonset);  %Delay by a random amount (to keep participants guessing)
            %Draw a stimulus rectangle where the arrow is pointing
            stimulusrectangle = rectangle('Position',leftrightpos{leftrightupdown},'FaceColor', [1, 1, 1], 'EdgeColor', [1, 1, 1]);            
        elseif validcue >= 8 %If the cue is invalid
            %Draw a stimulus rectangle opposite to where the arrow is pointing
            stimulusrectangle = rectangle('Position',leftrightpos{(mod(leftrightupdown,2)+1)},'FaceColor', [1, 1, 1], 'EdgeColor', [1, 1, 1]);            
        end
        tic
        waitforbuttonpress; %Wait for Ps to push button
        RT = toc;
        arrowresults(trialnumber,:) = [RT,3];
        delete(stimulusrectangle); %Get rid of stimulus rectangle
        delete(arrow); %Get rid of arrow
    elseif horizontalvertical == 1 %If we are using flashes and vertical for this trial
        pause(stimulusonset); %Delay by a random amount (to keep participants guessing)
        arrow = annotation('arrow',arrowupdown{leftrightupdown,:}, 'Color', [1 1 1], 'HeadWidth', 40, 'HeadLength', 40, 'LineWidth', 5);
        pause(stimulusonset);  %Delay by a random amount (to keep participants guessing)
        if validcue < 8 %If the cue is valid
            stimulusrectangle = rectangle('Position',updownpos{leftrightupdown},'FaceColor', [1, 1, 1], 'EdgeColor', [1, 1, 1]);            
        elseif validcue >= 8 %If the cue is invalid
            stimulusrectangle = rectangle('Position',updownpos{(mod(leftrightupdown,2)+1)},'FaceColor', [1, 1, 1], 'EdgeColor', [1, 1, 1]);            
        end
        tic
        waitforbuttonpress; %Wait for Ps to push button
        RT = toc;
        arrowresults(trialnumber, :) = [RT,4];
        delete(stimulusrectangle); %Get rid of stimulus rectangle
        delete(arrow); %Get rid of arrow
    end
    pause(1); %Pause between trials
    trialnumber = trialnumber + 1;
    end
    end
    counterbalance = mod(1,counterbalance);
end
    close all
    
%% Analyses

results = vertcat(flashresults, arrowresults);
flashhori = results(find(results(:,2) == 1));
flashvert = results(find(results(:,2) == 2));
arrowhori = results(find(results(:,2) == 3));
arrowvert = results(find(results(:,2) == 4));

horiresults = vertcat(flashhori,arrowhori);
vertresults = vertcat(flashvert,arrowvert);


mean(flashresults(:,1)) %Mean of flash
mean(arrowresults(:,1)) %Mean of arrow
[h,p, ci, stats] = ttest2(flashresults(:,1), arrowresults(:,1))

mean(horiresults(:,1)) %Mean of horizontal
mean(vertresults(:,1)) %Mean of vertical
[h,p, ci, stats] = ttest2(horiresults(:,1), vertresults(:,1))
