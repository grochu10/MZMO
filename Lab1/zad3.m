%skrypt do realizacji zadania 3
clear all
[img,map] = imread('PCB1.jpg');

min_pix = 70;%minimalna wielkosc pada

%zmiana na bialoczarne
img2 = rgb2gray(img);
img2 = imbinarize(img2,'adaptive');

%przyciecie
stats = regionprops(img2);
areas = vertcat(stats.Area);
max_area = max(areas);%ramka
field = find(areas == max_area);
cut_field = stats(field);
x_min = floor(cut_field.BoundingBox(1));
x_max = x_min + cut_field.BoundingBox(3) - 1;
y_min = floor(cut_field.BoundingBox(2));
y_max = y_min + cut_field.BoundingBox(4) - 1;
img2 = img2(y_min:y_max,x_min:x_max);

%pobranie linii od usera
img3 = bwareaopen(img2,min_pix);%odrzucenie mniejszych elementow niz pady i linie
fig = figure();
ax = axes('Parent',fig);
im = imshow(img3,'Parent',ax);
rect = getrect(ax);
width = min(rect(3),rect(4));
pix = (0.2)/width;%szerokosc pixela w rzeczywistosci
pow_pix = pix*pix;

%pierwsza selekcja padow
pady = regionprops(img3);
pady2 = pady;
pow = vertcat(pady.Area);
n_area = sum(size(pow))-1;
pos = vertcat(pady.BoundingBox);

k = 1;
for i = 1:n_area%druga selekcja padow
    if pos(i,1) >= 163.0 && pos(i,1) <= 792.0
        if pos(i,2) >= 100.0 && pos(i,2) <= 900.0
            pady2(k) = pady(i);
            k = k + 1;
        end
    end
end

%wyliczenie powierzchni oraz miejsca wyswietlen
pady2 = pady2(1:end-10);
n_pad = size(pady2);
pow = vertcat(pady2.Area);
pos = vertcat(pady2.BoundingBox);
pos_wysw = [pos(:,1) pos(:,2)];
pos_wysw(:,1)=(pos(:,1)+round(pos(:,3)./3));
pos_wysw(:,2)=(pos(:,2)+round(pos(:,4)./2));
s=sum(size(pow))-1;
pow = round(pow.*pow_pix.*1000);
pow = pow./1000;

figure;
imshow(img)
%wyswietlenie
for i=1:n_pad(1)
%     a = round(sqrt(pow(i)),3);
%     if pow(i) > 0.5
%         str1 = num2str(a);
%         str2 = num2str(a);
%     else
%         str1 = num2str(b);
%         str2 = num2str(round(pow(i)/b,3));
%     end
    text(pos_wysw(i,1)+160,pos_wysw(i,2)+110,[pos(i,3)*pix,"x",pos(i,4)*pix]);
    drawnow();
end
