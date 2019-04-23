%funkcja do obslugi suwaka
function [out] = zad2_callback(hobj,~,~,start_val,img)
    new_val = get(hobj,'Value') ;
    new_img = rgb2gray(img);
    range = getrangefromclass(new_img);
    range = range(2);
    %kontrast
    high = max(max(new_img));
    low = min(min(new_img));
    
    rat_high = double(range-high);
    rat_low = double(low);
    
    del_vel = (new_val-start_val)/100;
    
    if rat_high == 0
        a = 1;
    else
        a = rat_low/(rat_high+rat_low);
    end
    
    %nowe wartosci nasycen
    if a > 1
        new_high = round(del_vel*range*(1-a))+double(high);
        new_low = low-round(del_vel*range*a);
    elseif a <= 1
        new_high = round(del_vel*range*(1-a))+high;
        new_low = low-round(del_vel*range*a);
    end
    
    %edycja wycinka
    out = zeros(size(new_img), 'like', img);
    for p = 1 : 3
        out(:,:,p) = ( double(img(:,:,p) - low) ./ double(high - low));
        out(:,:,p) = round(out(:,:,p) .* double(new_high - new_low) + double(new_low));
        out(:,:,p) = uint8(out(:,:,p));
    end
    figure(2)
    imshow(out)
end