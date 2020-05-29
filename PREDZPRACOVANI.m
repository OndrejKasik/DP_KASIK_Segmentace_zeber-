function [ blur ] = PREDZPRACOVANI( VOLUME, prah )

disp('Probíhá pøedzpracování vstupních dat.');

%% Pøevzorkování 

switch size(VOLUME, 1)
    case 512
        VOLUME = imresize(VOLUME, 0.5);
        VOLUME = VOLUME(:,:,1:2:end);
        VOLUME = round(double(VOLUME));
end

%% Prahování

CT = zeros(size(VOLUME));
CT(VOLUME>prah) = 1;

%% Doèištìní

se = strel('disk',4); % 3

for i = 1:size(CT, 3)
    CT(:,:,i) = imclose(CT(:,:,i),se);
end

%% Násobení pùvodních a binárních dat, rozmazání

CT = CT .* VOLUME;
CT(CT<0) = 0;
CT = round(CT);

blur = imgaussfilt3(CT, 3); 

end

