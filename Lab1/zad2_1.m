close all
clear all;
I = imread('mikasa.jpg'); 
if ~isa(I,'uint8')
    I = im2uint8(I);
end
sizeInPixels=size(I);
f=figure(1);
im=axes('Parent',f);
imshow(I);
pos=get(f,'Position');
slider = uicontrol('Parent',f,'Style','slider','position',[0 0 pos(3) 26],...
'min',0, 'max',100);
%check range
range = getrangefromclass(I);
rect = getrect(im);
[rect,errorFlag]=checkBounds(rect,sizeInPixels);
if errorFlag
    disp("Nothing choosen")
else
subIm = I(rect(2):(rect(2)+rect(4)-1),rect(1):(rect(1)+rect(3)-1),:);
subImGray=rgb2gray(subIm);
%Poziom odniesienia
highest=max(max(subImGray));
lowest=min(min(subImGray));
kontrast=highest-lowest;

value=double(kontrast)/double(range(2))*100;
slider.Value = value;
set(slider,'Callback', {@sld_callback,f,value,subIm} ) 
end

function sld_callback(hobj,~,~,startValue,imrgb)
    newValue = get(hobj,'Value') ;
    imRGB=imrgb;
    im=rgb2gray(imrgb);
    delta = newValue-startValue;
    delta =  delta/100;
    range = getrangefromclass(im);
    range=range(2);
    %Poziom odniesienia
    %MAX
    highest=max(max(im));
    %MIN
    lowest=min(min(im));
    
    forRatioH=range-highest;
    forRatioL=lowest;
    forRatioH=double(forRatioH);
    forRatioL=double(forRatioL);
    if forRatioH==0
        ratio = 1;
    else
        ratio=forRatioL/(forRatioH+forRatioL);
    end
    
    if ratio>1
        newHigh=round(delta*range*(1-ratio))+double(highest);
        newLow=lowest-round(delta*range*ratio);
    elseif ratio<=1
        newHigh=round(delta*range*(1-ratio))+highest;
        newLow=lowest-round(delta*range*ratio);
    else
    end
    out = zeros(size(imRGB), 'like', imrgb);
    for p = 1 : 3
    out(:,:,p) = adjustArray(imRGB(:,:,p), lowest,highest, newLow,newHigh);
    end
    figure(2)
    imshow(out)
    figure(3)
    imhist(out);
end

function out = adjustArray(im,lowest,highest,newLow,newHigh)
    out = ( double(im - lowest) ./ double(highest - lowest));
    out = round(out .* double(newHigh - newLow) + double(newLow));
    out = uint8(out);
end

function [retVal,errorFlag] = checkBounds(rect,maxSize)
errorFlag=0;
if rect(1)<0 
    rect(3)=rect(3)+rect(1);
    rect(1)=1;
elseif(rect(1)>maxSize(2))
    errorFlag=1;
end
if (rect(3)+rect(1))>maxSize(2)
    overstep=rect(3)-maxSize(2);
    rect(3)=rect(3)-overstep;
end
if rect(2)<0 
    rect(4)=rect(4)+rect(2);
    rect(2)=1;
elseif(rect(2)>maxSize(1))
    errorFlag=1;
end
if (rect(4)+rect(2))>maxSize(1)
    overstep=rect(4)-maxSize(1);
    rect(4)=rect(4)-overstep;
end
retVal=rect;
end