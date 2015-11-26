%% Assignment 6 - Gabors

%% The first thing we want to do is to create an array of our randomization

%We first set a seed.
rng(0);
%Then we generate an 800 x 5 matrix to store all our crap.
data = zeros(800,6);
data(:,1) = randi([1,4],800,1); %Generates a column for our conditions
data(:,2) = (10).*rand(800,1)-5; %Generates a column for our left offset
data(:,3) = (10).*rand(800,1)-5; %Generates a column for our right offset
data(:,6) = abs(data(:,2)) + abs(data(:,3)); %Generates a column of absolute offset (for our grpah)

%% Display some instructions
ourdisplay = figure('units','normalized','outerposition',[0 0 1 1], 'KeyPressFcn',@(obj,evt) 0); %Makes a fullscreen display and disables keypresses
set(ourdisplay, 'Toolbar','none', 'MenuBar', 'none', 'Color', [0 0 0 ]); %Sets up our display
xlim([0 1]); %Sets the axes for uor display
ylim([0 1]); %Same
axis off %Turns off the axes
instructions1 = text(.3,.5, 'Press j if the right object is clockwise.', 'Fontsize', 20, 'Color',  [1 1 1]);
instructions2 = text(.3,.4, 'Press f if the right object is counter-clockwise.', 'Fontsize', 20, 'Color',  [1 1 1]);
waitforbuttonpress; %Waits for participants to press button
delete(instructions1); %Clears the screen of our instructions
delete(instructions2); %Ditto

fixationcross = text (.45, .5, '+', 'Fontsize', 60, 'Color', [1 1 1]); %Produces a fixation cross

%% Draw a gabor
for row = 1:length(data)
    %The following if statements sets the angle for the condition.
    if data(row,1) == 1 
        condangle = 0;
    elseif data(row,1) == 2
        condangle = 90;
    elseif data(row,1) == 3
        condangle = 45;
    elseif data(row,1) == 4
        condangle = 135;
    end    
    %The following if statements sets what the correct key is.
    if data(row,3) > data(row,2) %If right side is more clockwise than left side.
        correctkey = 'j';
    elseif data(row,3) < data(row,2)
        correctkey = 'f';
    end
    
    angle = condangle + data(row,2); %degrees for sinewave grating (changes by condition)
    sf = 10; %frequency
    n = 101; 
    [X, Y] = meshgrid( linspace(-pi, pi, n)); %This is a mesh grid for drawing one of our Gabors.
    ramp = cos(angle*pi/180)*X - sin(angle*pi/180)*Y; 
    gaussian = exp(-X.^ 2-Y.^ 2); %This is our gaussian distribution for drawing our Gabors.
    orientedgrating = sin(sf * ramp);  %Rotates the sine wave
    gabor = gaussian.*orientedgrating; %This produces a Gabor.
    subplot(1,2,1); %Plots in the first position of a 3-plot subplot
    imagesc(gabor); %Plots the gabor
    axis equal; %Squares the graph
    axis off; %Turns off the axis
    colormap(gray(256));

    %subplot(1,3,2); %Plots in the second position of a 3-plot subplot
    %axis equal; %Squares the graph
    %axis off; %Turns off the axis
    %fixationcross = text (.45, .5, '+', 'Fontsize', 60, 'Color', [1 1 1]); %Produces a fixation cross

    angle = condangle + data(row,3); %degrees for sinewave grating (changes by condition)
    sf = 10; %frequency
    n = 101; 
    [X, Y] = meshgrid( linspace(-pi, pi, n)); %This is a mesh grid for drawing one of our Gabors.
    ramp = cos(angle*pi/180)*X - sin(angle*pi/180)*Y; 
    gaussian = exp(-X.^ 2-Y.^ 2); %This is our gaussian distribution for drawing our Gabors.
    orientedgrating = sin(sf * ramp);  %Rotates the sine wave
    gabor = gaussian.*orientedgrating; %This produces a Gabor.
    subplot(1,2,2); %Plots in the first position of a 3-plot subplot
    imagesc(gabor); %Plots the gabor
    axis equal; %Squares the graph
    axis off; %Turns off the axis
    colormap(gray(256));
    waitforbuttonpress;
    keypressed = get(ourdisplay, 'CurrentCharacter'); %collect user input
    if keypressed == correctkey
        data(row,4:5) = [keypressed, 1]; %Stores the key pressed, and 1, because correct.
    else
        data(row,4:5) = [keypressed, 0];
    end
end

%% Analyses

bins = 0:10; %Creates 10 bins

horzvertdata = data(find(data(:,1) == 1 | data(:,1) == 2),:); %Creates a new array with only the horizontal or vertical trials
horzvertbinned = histc(horzvertdata(:,6),bins); %Creates an array of all the counts of each bin (e.g., how many in the first bin, etc.)
obliquedata = data(find(data(:,1) == 3 | data(:,1) == 4),:); %Creates a new array with only the oblique trials
obliquebinned = histc(obliquedata(:,6),bins); %Creates an array of all the counts of each bin (e.g., how many in the first bin, etc.)
correcthorzvert = horzvertdata(find(horzvertdata(:,5) == 1),:); %Creates a new array with only the *correct* horizontal and verticla trials
correcthorzvertbinned = histc(correcthorzvert(:,6), bins); %Creates an array with the counts for the correct horizontal and vertical trials
correctoblique = obliquedata(find(obliquedata(:,5) == 1),:); %Creates a new array with only the *correct* oblique trials
correctobliquebinned = histc(correctoblique(:,6), bins); %Creates a new array with the counts for the correct oblique trials per bin

horzvertprop = correcthorzvertbinned./horzvertbinned; %Calculates the proportion of correct horz and vert trials
obliqueprop = correctobliquebinned./obliquebinned; %Calculates the proportion of correct oblique trials

figure
horzvertbar = bar(horzvertprop); %Creates a bar graph of the proportion of correct horz and vert trials
xlabel('Proportion of correct trials for horizontal and vertical trials')
figure
obliquebar = bar(obliqueprop); %Creates a bar graph of the proportion of correct oblique trials
xlabel('Proportion of correct trials for oblique trials')