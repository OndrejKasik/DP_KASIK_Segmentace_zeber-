function [ SEED ] = UPRAVA_STREDOVYCH_LINII( CT, SEED, vzdalenost_od_plic, sirka_oblasti_patere )

clc
disp('Probíhá úprava støedových linií žeber.')

%% Segmentace plic

PLICE = zeros(size(CT));
PLICE((CT<200)&(CT>0)) = 1;
PLICE(:,:,1) = 0;
PLICE(:,:,end) = 0;
PLICE(230,:,:) = 1;
PLICE(245,:,:) = 1;
PLICE = imclearborder(PLICE);
PLICE = bwareaopen(PLICE, 40000);
SE = strel('sphere', 3);
PLICE = imclose(PLICE, SE);

%% Modifikace plic

PLICE = double(PLICE);

 poradi = zeros(1, size(PLICE,3));
 
 for i = 1:size(PLICE,3)
     poradi(i) = sum(sum(PLICE(:,:,i)));
 end
 
 [~, zlom] = max(poradi);

 for i = zlom:size(PLICE,3)-1
    PLICE(:,:,i) = imgaussfilt(PLICE(:,:,zlom), 2); % 2
 end
 
%% Kontrola vzdálenosti mezi SEEDem a plícemi

oko = vzdalenost_od_plic;
od = oko+1;
do = oko;

plice_obal = zeros(size(PLICE)+2*oko);
plice_obal(od:end-do, od:end-do, od:end-do) = PLICE;
PLICE = plice_obal;
seed_obal = zeros(size(SEED)+2*oko);
seed_obal(od:end-do, od:end-do, od:end-do) = SEED;
SEED_N = seed_obal;
[x, y, z] = ind2sub(size(SEED_N), find(SEED_N)); 

SE = strel('sphere', vzdalenost_od_plic);
SE = SE.Neighborhood;

for i = 1:size(x,1)
    
    vyrez = PLICE(x(i)-vzdalenost_od_plic:x(i)+vzdalenost_od_plic , y(i)-vzdalenost_od_plic:y(i)+vzdalenost_od_plic , z(i)-vzdalenost_od_plic:z(i)+vzdalenost_od_plic);
    
    if ~(any(any(any(SE .* vyrez)))) 
        SEED_N(x(i), y(i), z(i)) = 0;
    end
         
end
    
SEED_N = SEED_N(od:end-do, od:end-do, od:end-do);
 
 %% Odstranìní bodù z oblasti páteøe

[x, y, z] = ind2sub(size(SEED_N), find(SEED_N));
souradnice = [x, y, z];
stred = round(mean(souradnice));
SY = round((5*(size(SEED_N, 2) / 2) + stred(2))/6);
SEED_N(:,SY-sirka_oblasti_patere:SY+sirka_oblasti_patere,:) = 0;
  
 %% Vykreslení
 
% %  [x, y, z] = ind2sub(size(SEED), find(SEED)); 
% %  [k, l, m] = ind2sub(size(SEED_N), find(SEED_N)); 
% %  odstraneno = SEED-SEED_N;
% %  [t, u, v] = ind2sub(size(odstraneno), find(odstraneno)); 
% %  figure()
% %  subplot(121)
% %  plot3(x, y, z, 'k.', 'MarkerSize', 15);
% %  subplot(122)
% %  plot3(k, l, m, 'k.', 'MarkerSize', 15);
% %  hold on
% %  plot3(128, SY, 130, 'r.', 'MarkerSize', 20)
% %  plot3(t, u, v, 'y.', 'MarkerSize', 15)

%% Výsledek

SEED = SEED_N;

end

