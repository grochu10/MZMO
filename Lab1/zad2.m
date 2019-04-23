%skrypt do rozwiazania zadania 2
clear all
%wczytanie i przetworzenie obrazka
img = imread('mikasa.jpg');
img2 = im2uint8(img);
img_size = size(img2);
range = getrangefromclass(img2);
fig = figure;
img3 = axes('Parent',fig);
imshow(img2);
pos = get(fig,'Position');

%suwak
slider = uicontrol('Parent',fig,'Style','slider','position',[0 0 26 pos(4)],'min',0, 'max',100);

%wycinek
rect = getrect(img3);
frag = img2(rect(2):(rect(2)+rect(4)-1),rect(1):(rect(1)+rect(3)-1),:);
frag_gray = rgb2gray(frag);

%wyliczenie kontrastu
high = max(max(frag_gray));
low = min(min(frag_gray));
kontrast = high-low;

%obsluga suwaka
slid_val = double(kontrast)/double(range(2))*100;
slider.Value = slid_val;
set(slider,'Callback', {@zad2_callback,fig,slid_val,frag});
%img2(rect(2):(rect(2)+rect(4)-1),rect(1):(rect(1)+rect(3)-1),:) = frag2;
%figure;
%imshow(img2)