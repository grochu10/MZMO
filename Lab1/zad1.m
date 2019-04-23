%skrypt realizujacy rozwiazanie zadania 1
clear all
img = imread('mikasa.jpg');%wczytanie obrazu
imshow(img);
title('Obraz wczytany')
res = [];%struktura przetworzonych obrazow
L = [0:0.1:1];%wartosc odciecia
s = size(img);
s1 = size(s);
if s1(2) == 3    
    img2 = rgb2gray(img);%zamiana na gray
    img_size = size(img2);
    N_pix = img_size(1)*img_size(2);%liczba pixeli na obrazie
    N_ones = zeros(size(L));%liczba jedynek(pixeli) w danym kolorze
    N_zeros = zeros(size(L));
    rng = getrangefromclass(img2);

    size2 = size(L);
    %zliczanie pikseli
    for i=1:size2(2)
        res{i} = img2 > rng(2)*L(i);
        %res_size = size(res{i});
        [~,~,a]=find(res{i});
        N_ones(i)=sum(a);
    %     for j = 1:res_size(1)
    %         for k = 1:res_size(2)
    %             if a(j,k) == 1
    %                 N_ones(i) = N_ones(i) + 1;
    %             end
    %         end
    %     end
        N_zeros(i) = N_pix - N_ones(i);
    end

    %przykladowy obrazek
    figure;

    n = randi(size2(2),1);
    imshow(res{n})
    title(['Przykladowy przetworzony obraz. L = ',sprintf('%d%%',L(n)*100)])

    %mapa kolorow
    map = [1 1 0.2; 0.2157 1 0.2157];%zielony, zolty
    colormap(map);

    %odpowiedz
    figure;
    plot(L,N_ones)
    hold on
    plot(L,N_zeros)
    title('Ilosc pixeli o kolorze zielonym w zaleznosci od wartosci odciecia')
    ylabel('Ilosc pixeli zielonych')
    xlabel('Wartosc odciecia')
    legend('Nof1')
else
    disp('Blad')
end