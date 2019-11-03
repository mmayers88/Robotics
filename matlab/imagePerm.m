% Image Perm
% Kai Brooks
% github.com/kaibrooks
% 2019
%
% takes an image and makes a bunch of permutations of it for training an image recognition algorithm

clc
close all
clear all
rng('shuffle')

% user settings ------------------------------------------------

makeImages = 500; % (20) images to make
termChance = 0.2; % (0.4) 0 for ~ ~ ~ w a r h o l m o d e ~ ~ ~
maxAngle = 90; % (90) max angle rotations will make
fuzz = 0.1; % (0.1) fuzz in noise

WEIRDNESS = 1; % (0.3-1.0) beeeeewaaaaaaaaaree

% image to load in
cat = imread('images/cat.jpg');

% go ----------------------------------------------------------------

im = cat;

% get details about it
%imhist(cat)
[height, width, colorSpace] = size(im);
imCenter = [width/2 height/2];

while i < makeImages
    adjFactor = rand();
    alg = randi(6);
    
    switch alg
        case 5 % make b&w
            temp = rgb2gray(im);
            
        case 4 % make fuzzy
            temp = imnoise(im,'gaussian',0.0,adjFactor*fuzz*WEIRDNESS);
      
        case 1 % flip
            temp = flipdim(im, 2);           % horizontal flip
            
        case 2 % change contrast
            temp = imadjust(im,[.1 .2 0; .8*WEIRDNESS .9*WEIRDNESS 1],[]);
   
        case 3 % rotate
            temp = imrotate(im,randi([1 maxAngle]),'crop');
            
              
        case 8 % adjust HSV
            adjFactor = adjFactor;
            temp = rgb2hsv(im);
            temp(:, :, 2) = temp(:, :, 2) * adjFactor;
            
        case 6 % denoise (must be b&w)
            temp = wiener2(rgb2gray(im),[5 5]);
            
    end % switch
    
    % crop it
    [newH, newW, colorSpace] = size(temp); % get width / height
    imXY = [(newW/2)-(width/2) newH/2-(height/2)];
    cropRect = [[imXY] width height]; % xmin ymin width height

    %temp = imcrop(temp,cropRect);
    
    imshow(temp);
    f=getframe;
    imwrite(f.cdata,'images/temp.jpg');
    %saveas(gcf,'images/temp.jpg', 'jpg')
    
    % write image and move on to next
    if rand() < termChance
        f=getframe;
        imwrite(f.cdata,'images/1.jpg');
        %saveas(gcf,'images/1.jpg', 'jpg')        
        i = i + 1;
        fprintf("Image %i created using %i\n",i, alg)
        im = cat;
    else
       fprintf("Looping after %i\n", alg)
       im = imread('images/temp.jpg'); 
    end
    
    
    
end % 1:makeImages
