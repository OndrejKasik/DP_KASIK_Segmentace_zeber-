function [ PRIZNAKY ] = EXTRAKCE_PRIZNAKU( CT, element )

clc
disp('Probíhá výpoèet pøíznakù.')
h = waitbar(0,'Probíhá výpoèet pøíznakù.');

%% Definice promìnných

cil = max(max(max(element)));
oko = 5;
od = oko+1;
do = oko;
EL = element;
CT_obal = zeros(size(CT)+2*oko);
CT_obal(od:end-do, od:end-do, od:end-do) = CT;
CT = CT_obal;

EL_obal = zeros(size(EL)+2*oko);
EL_obal(od:end-do, od:end-do, od:end-do) = EL;
EL = EL_obal;

%% Výpoèet gradientních obrazù

[ GRADIENTY ] = vypocet_gradientu( CT );

%% Výpoèet jednotlivých pøíznakù

PRIZNAKY = zeros(max(max(max(EL))), 1);
kontrola_okoli = zeros(size(EL));
se = strel('sphere', 8);
prvek = zeros(size(EL));

for i = 1 : max(max(max(EL)))
    
    prvek(:,:,:) = 0;
    prvek(EL == i) = 1;
    poradi_priznaku = 1;
    N_PX_i = sum(sum(sum(prvek)));
    
    if  N_PX_i < 2 
        EL(prvek == i) = 0;
    else
        clc
        disp('Probíhá výpoèet pøíznakù.')
        disp(['  - probíhá výpoèet pøíznakù pro ', num2str(i), '. primitivum'])
        waitbar(i / cil);
        
        [x, y, z] = ind2sub(size(prvek), find(prvek)); % najde souøednice všech bodù

        sou = [x,y,z];
        zacatek = sou(1,:);
        konec = sou(end,:);
        
        %% Poøadí
        
        PRIZNAKY(i,poradi_priznaku) = i;
        poradi_priznaku = poradi_priznaku+1;
                
        %% 6,7) relativní souøadnice støedu primitiv % NAVÍC
        
        PRIZNAKY(i,poradi_priznaku) = mean([zacatek(1), konec(1)]) / size(EL, 1);
        poradi_priznaku = poradi_priznaku+1;
        PRIZNAKY(i,poradi_priznaku) = mean([zacatek(2), konec(2)]) / size(EL, 2);
        poradi_priznaku = poradi_priznaku+1;
        
        %% 15) 16) GRADIENT MAGNITUDE
        
        PRIZNAKY(i,poradi_priznaku) = mean(GRADIENTY{1, 11}(prvek == 1));
        poradi_priznaku = poradi_priznaku+1;
        
        PRIZNAKY(i,poradi_priznaku) = mean(GRADIENTY{2, 11}(prvek == 1));
        poradi_priznaku = poradi_priznaku+1;
        
        %% 17) - 46) Intensity Based Feat
        
        PRIZNAKY(i,poradi_priznaku) = mean(GRADIENTY{1, 1}(prvek == 1)); 
        poradi_priznaku = poradi_priznaku+1;

        PRIZNAKY(i,poradi_priznaku) = mean(GRADIENTY{2, 2}(prvek == 1)); 
        poradi_priznaku = poradi_priznaku+1;

        PRIZNAKY(i,poradi_priznaku) = mean(GRADIENTY{3, 2}(prvek == 1)); 
        poradi_priznaku = poradi_priznaku+1;

        PRIZNAKY(i,poradi_priznaku) = mean(GRADIENTY{3, 3}(prvek == 1)); 
        poradi_priznaku = poradi_priznaku+1;

        PRIZNAKY(i,poradi_priznaku) = mean(GRADIENTY{3, 4}(prvek == 1)); 
        poradi_priznaku = poradi_priznaku+1;

        PRIZNAKY(i,poradi_priznaku) = mean(GRADIENTY{3, 6}(prvek == 1)); 
        poradi_priznaku = poradi_priznaku+1;

        PRIZNAKY(i,poradi_priznaku) = mean(GRADIENTY{3, 7}(prvek == 1)); 
        poradi_priznaku = poradi_priznaku+1;

        PRIZNAKY(i,poradi_priznaku) = mean(GRADIENTY{3, 9}(prvek == 1)); 
        poradi_priznaku = poradi_priznaku+1;

        PRIZNAKY(i,poradi_priznaku) = mean(GRADIENTY{3, 10}(prvek == 1)); 
        poradi_priznaku = poradi_priznaku+1;
          
    %% INTERACTION BETWEEN PRIMITIVES (vzájemné pøíznaky)
           
        %% Kontrola okolí koncových bodù primitiva, nalezení nejbližšího souseda
        
        kontrola_okoli(:,:,:) = 0;
        kontrola_okoli(zacatek(1), zacatek(2), zacatek(3)) = 5000;
        kontrola_okoli(konec(1), konec(2), konec(3)) = 5000;
        kontrola_okoli = double(imdilate(kontrola_okoli==5000, se));
        
        kontrola_okoli = EL .* kontrola_okoli;
        kontrola_okoli(kontrola_okoli == i) = 0;
        
        [K1, K2, K3] = ind2sub(size(kontrola_okoli), find(kontrola_okoli));
        souradnice = [K1, K2, K3];
        sousedi = (kontrola_okoli(find(kontrola_okoli)));
        [~ ,dist1] = dsearchn(zacatek,souradnice);
        [~ ,dist2] = dsearchn(konec,souradnice);
        
        dist = 0;
        
        if ~(isempty(dist1)) 
            for d = 1:length(dist1)
                dist(d) = min(dist1(d), dist2(d));
            end

            [~, nejblizsi] = min(dist);
            soused = (EL==sousedi(nejblizsi));
            
            N_PX_j = sum(sum(sum(soused)));
            
            if N_PX_j > 2 
            
                [X, Y, Z] = ind2sub(size(soused), find(soused));

                sou2 = [X, Y, Z];
                zacatek_s = sou2(1,:);
                konec_s = sou2(end,:);

                %% 56) 57) 58) SOUØADNICE

                S = abs(mean(sou) - mean(sou2));

                PRIZNAKY(i,poradi_priznaku) = S(1);
                poradi_priznaku = poradi_priznaku+1;

                PRIZNAKY(i,poradi_priznaku) = S(2);
                poradi_priznaku = poradi_priznaku+1;

                PRIZNAKY(i,poradi_priznaku) = S(3);
            
            end
        end
    end
end

PRIZNAKY( ~any(PRIZNAKY,2), : ) = []; 
close(h)

end

