%HW5

% Note. You can use the code readIlastikFile.m provided in the repository to read the output from
% ilastik into MATLAB.

%% Problem 1. Starting with Ilastik

% Part 1. Use Ilastik to perform a segmentation of the image stemcells.tif
% in this folder. Be conservative about what you call background - i.e.
% don't mark something as background unless you are sure it is background.
% Output your mask into your repository. What is the main problem with your segmentation?  
%it looks like too many of the cells were not separated during segmentation.
%I noticed that there seemed to be a great deal of gray pixels present in
%the image which made it hard to distinugish between cells and true
%background. 

% Part 2. Read you segmentation mask from Part 1 into MATLAB and use
% whatever methods you can to try to improve it. 
Seg1 = readIlastikFile('stemcells_SimpSeg_HighBG.h5');
Seg1 = Seg1;
figure(1);imshow(Seg1,[]);


Seg1 = imerode(Seg1,strel('disk',5));
%Seg1 = imfill(Seg1,'holes'); DO NOT USE
Seg1 = imdilate(Seg1,strel('disk',5));
figure(2);imshow(Seg1,[]);


% Part 3. Redo part 1 but now be more aggresive in defining the background.
% Try your best to use ilastik to separate cells that are touching. Output
% the resulting mask into the repository. What is the problem now?

Seg2 = readIlastikFile('stemcells_SimpSeg_LowBG.h5');
Seg2 = ~Seg2;
figure(3);imshow(Seg2,[]);
%Adam Howard: Several of the nuclei are much better resolve now, though
%clusters still remain. The major issue is that some of the nuclei appear
%overly fragmented, particularly in the highly blured region of the upper
%left in the original image. 

% Part 4. Read your mask from Part 3 into MATLAB and try to improve
% it as best you can.
for ii = 2:2:8
Seg2 = imerode(Seg2,strel('disk',ii));
Seg2 = imdilate(Seg2,strel('disk',ii));
figure(4);imshow(Seg2,[]);
end

%Possible Watershed here?

%% Problem 2. Segmentation problems.

% The folder segmentationData has 4 very different images. Use
% whatever tools you like to try to segement the objects the best you can. Put your code and
% output masks in the repository. If you use Ilastik as an intermediate
% step put the output from ilastik in your repository as well as an .h5
% file. Put code here that will allow for viewing of each image together
% with your final segmentation. 
clear all

reader{1} = bfGetReader('segmentationData\bacteria.tif');
reader{2} = bfGetReader('segmentationData\cellPhaseContrast.png');
reader{3} = bfGetReader('segmentationData\worms.tif');
reader{4} = bfGetReader('segmentationData\yeast.tif');

fid = fopen('readerData.txt','w');
for i = 1:4
    fprintf(fid,'Data for image number: %d \n',i);
    fprintf(fid,'Channel Num: %d \n',(reader{i}.getSizeC));
    fprintf(fid,'Time Scale: %d \n',(reader{i}.getSizeT));
    fprintf(fid,'Z slices: %d \n \n',(reader{i}.getSizeZ));
end
fclose(fid);

chan = 1;
time = 1;
zplane = 1;

for ii = 1:4
iplane = reader{ii}.getIndex(zplane-1,chan-1,time-1)+1;
img{ii} = bfGetPlane(reader{ii},iplane);
end
%Replace image 2 with the best version
iplane = reader{2}.getIndex(zplane-1,2,time-1)+1;
img{2}= bfGetPlane(reader{2},iplane);

img{4} = im2double(img{4});
img{4} = imfilter(img{4},fspecial('gaussian',4,2));

for ii = 1:4
    figure(5);subplot(2,2,ii);
    imshow(img{ii},[]);
    filename = ['image' num2str(ii) '.tif']
    imwrite(img{ii},filename,'TIFF')
end

%Moved files to Ilastik

%Reimport Ilastik files and view the resulting masks. 
for ii = 1:4
    filename = ['image' num2str(ii) '_Simple Segmentation.h5']
    imgMask{ii} = readIlastikFile(filename)
    figure(6);subplot(2,2,ii);imshow(img{ii},[]);
end
