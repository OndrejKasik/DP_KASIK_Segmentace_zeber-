function [ blur ] = PREDZPRACOVANI( VOLUME, prah )

disp('Prob�h� p�edzpracov�n� vstupn�ch dat.');

%% P�evzorkov�n� 

switch size(VOLUME, 1)
    case 512
        VOLUME = imresize(VOLUME, 0.5);
        VOLUME = VOLUME(:,:,1:2:end);
        VOLUME = round(double(VOLUME));
end

%% Prahov�n�

CT = zeros(size(VOLUME));
CT(VOLUME>prah) = 1;

%% Do�i�t�n�

se = strel('disk',4); % 3

for i = 1:size(CT, 3)
    CT(:,:,i) = imclose(CT(:,:,i),se);
end

%% N�soben� p�vodn�ch a bin�rn�ch dat, rozmaz�n�

CT = CT .* VOLUME;
CT(CT<0) = 0;
CT = round(CT);

blur = imgaussfilt3(CT, 3); 

end

