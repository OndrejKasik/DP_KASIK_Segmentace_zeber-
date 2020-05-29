function [ ZEBRA ] = NARUSTANI_OBLASTI_3D( CT, seed, max_vzdalenost, maximalni_rozdil, vyska_prahu1, vyska_prahu2 )

tic
clc
disp('Zaèíná finální segmentace metodou narùstání oblastí.')

%% Definice promìnných

aktualizace_prahu = 1000; 
oko = max_vzdalenost+3;
od = oko+1;
do = oko;
CT_obal = zeros(size(CT)+2*oko);
CT_obal(od:end-do, od:end-do, od:end-do) = CT;
CT = CT_obal;
SEED_obal = zeros(size(seed)+2*oko);
SEED_obal(od:end-do, od:end-do, od:end-do) = seed;
seed = SEED_obal;
J = zeros(size(CT));
J(seed==1) = 1;
koule = strel('sphere', max_vzdalenost);
koule = koule.Neighborhood;
se = strel('sphere', 2);
rozsireny = imdilate(J, se);
J(rozsireny>0) = 1;

%% Definice parametrù 

okoli = [-1 0 0 ; 1 0 0 ; 0 -1 0 ; 0 1 0 ; 0 0 -1 ; 0 0 1];
[k, l, m] = ind2sub(size(J), find(J));
souradnice = [k,l,m];
prumer = vyska_prahu1 * mean(CT(J>0));

%% Samotné narùstání oblastí

citac = 0;
pocet_voxelu = sum(sum(sum(J)));

while ~isempty(souradnice)
    
    citac = citac+1;
    posuzovany = souradnice(1,:);
    
    for i = 1:length(okoli)
        kandidat = posuzovany + okoli(i,:);
        xk = kandidat(1);
        yk = kandidat(2);
        zk = kandidat(3);
        
        uvnitr =(xk>=1) && (yk>=1) && (zk>=1) && (xk<=size(CT, 1)) && (yk<=size(CT, 2)) && (zk<=size(CT, 3));
        
        if uvnitr 
            
            rozdil = abs(CT(xk,yk,zk)-prumer) < maximalni_rozdil;
            poprve = J(xk,yk,zk) == 0;
            
            vzdalenost = (sum(sum(sum(koule .* (seed(xk-max_vzdalenost:xk+max_vzdalenost, yk-max_vzdalenost:yk+max_vzdalenost , zk-max_vzdalenost:zk+max_vzdalenost)))))) > 0;
            
            if rozdil && poprve && vzdalenost
                
                J(xk,yk,zk) = 1;
                pocet_voxelu = pocet_voxelu+1;
                souradnice(end+1,:) = [xk,yk,zk];
                
            end
        
        end 
    end
    
    souradnice(1,:) = [];
    
    switch mod(citac, aktualizace_prahu) 
        case 0
            prumer = vyska_prahu1 * mean(CT(J>0));
            maximalni_rozdil = vyska_prahu2 * std(CT(J>0)); % 1
            
            clc
            disp('Probíhá finální segmentace metodou narùstání oblastí.')
            disp(['  - iterace: ',num2str(citac), '   aktuálnì zbývá zpracovat ', num2str(size(souradnice, 1)), ' voxelù']) 
    end
    
end

%% Doèištìní 

ZEBRA = J>0;

se = [false false true true true true true false false;false true true true true true true true false;true true true true true true true true true;true true true true true true true true true;true true true true true true true true true;true true true true true true true true true;true true true true true true true true true;false true true true true true true true false;false false true true true true true false false];

for i = 1:size(ZEBRA, 3)
    ZEBRA(:,:,i) = imclose(ZEBRA(:,:,i),se);
end

ZEBRA = ZEBRA(od:end-do, od:end-do, od:end-do);
cas = toc;

%% Výpis do CW

clc
disp('Probíhá finální segmentace metodou narùstání oblastí.')
disp(' ')
disp([' Doba trvání RegionGrowingu: ', num2str(floor(round(cas)/60)), ' min ', num2str(mod(round(cas),60)), ' sec'])
disp(' ')

end