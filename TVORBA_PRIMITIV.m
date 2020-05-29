function [ element ] = TVORBA_PRIMITIV( ridge, vektor )

clc
disp('Prob�h� tvorba primitiv.')

%% Definice prom�nn�ch

oko = 5;
od = oko+1;
do = oko;

vektor3 = cell(size(ridge)+2*oko);
vektor3(od:end-do, od:end-do, od:end-do) = vektor;

ridge_obal = zeros(size(ridge)+2*oko);
ridge_obal(od:end-do, od:end-do, od:end-do) = ridge;
ridge = ridge_obal;
element = zeros(size(ridge));

hodnota = 0;

figure(1)
title('St�edov� linie rozd�len� na jednotliv� primitiva.')
hold on

%% Samotn� tvorba primitiv

while sum(sum(sum(ridge))) > 0

    [x, y, z] = ind2sub(size(ridge), find(ridge));
    vsechny_souradnice = [x, y, z]; % sou�ednice v�ech nenulov�ch pixel� v ridge
    pixel = vsechny_souradnice(1,:); % sou�adnice konkr�tn�ho nenulov�ho bodu
    hodnota = hodnota + 1; r = 1;
    xx = []; yy = []; zz = [];

    for i = 1:25 

        x = pixel(1);
        y = pixel(2);
        z = pixel(3);

        okoli = ridge(x-r:x+r, y-r:y+r, z-r:z+r);
        s = (size(okoli, 1)+1)/2;
        okoli(s,s,s) = 0;
        element(x,y,z) = hodnota; 
        ridge(x,y,z) = 0; 

        % nalezen� nenulov�ch pixel� v okol�:
        [x2, y2, z2] = ind2sub(size(okoli), find(okoli));
        v_okoli = [x2, y2, z2];

        % volba jednoho z nich:
        if ~isempty(v_okoli)
            pix = v_okoli(1,:);
            stred = [r+1, r+1, r+1];

            % p�epo�et jeho sou�adnic k p�vodn� matici (sou�adnice v ridge)
            sou_pix = pixel + (pix - stred); % sou�adnice pixelu soused�c�ho s n�hodn� vybran�m pixelem

            v3c = vektor3{sou_pix(1), sou_pix(2), sou_pix(3)};
            v3s = vektor3{pixel(1), pixel(2), pixel(3)};
            rr = pixel - sou_pix;

            dist = norm(sou_pix - pixel);
            smer = abs(v3c * v3s'); 
            orientace = abs(rr * v3s'); 

            if dist < 5
                if smer > 0.8
                    if orientace > 0.7
                        element(sou_pix(1), sou_pix(2), sou_pix(3)) = hodnota; % nov� p�idan� voxel do matice element�
                        ridge(sou_pix(1), sou_pix(2), sou_pix(3)) = 0; % vynulov�n� bodu v p�vodn� matici (aby u� nebyl pou�it)
                    end
                end
            end

            % body pro vykreslen�

            xx = [xx, sou_pix(1)];
            yy = [yy, sou_pix(2)];
            zz = [zz, sou_pix(3)];


            pixel = sou_pix;

        else

            if r == 5
                break
            end

            r = r+1;

        end

    end

    %% V�pis, vykreslen�
    
    clc
    disp('Prob�h� tvorba primitiv.')
    disp(['  - bylo vytvo�eno ', num2str(hodnota), '. primitivum'])
    plot3(xx, yy, zz, '.', 'MarkerSize', 15);

end

element = element(od:end-do, od:end-do, od:end-do);

end

