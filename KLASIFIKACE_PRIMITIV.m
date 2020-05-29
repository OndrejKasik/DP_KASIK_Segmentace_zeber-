function [ SEED ] = KLASIFIKACE_PRIMITIV( element, PRIZNAKY_TEST, pocet_sousedu, prah )
    
    clc
    disp('Prob�h� klasifikace primitiv.')

    %% Na�ten� u�ebn� mno�iny
    
    PRIZNAKY_TRAIN = load('TRAIN_DATA.mat');
    PRIZNAKY_TRAIN = PRIZNAKY_TRAIN.data_ALL;
    ELEMENT_CELY = element;
    vybrane_priznaky = [6 7 14 15 17 28 38 39 40 42 43 45 46 56 57 58];
    
    %% Modifikace u�ebn� mno�iny 

    PRIZNAKY_TRAIN(:,1) = []; 
    lab_TRAIN = PRIZNAKY_TRAIN(:,end); 
    PRIZNAKY_TRAIN(:,end) = [];
    PRIZNAKY_TRAIN(:,end) = [];
    zebra = PRIZNAKY_TEST(:,1);
    PRIZNAKY_TEST(:,1) = [];

    %% Standardizace p��znak�

    [ PRIZNAKY_TRAIN ] = standardizace( PRIZNAKY_TRAIN );
    [ PRIZNAKY_TEST ] = standardizace( PRIZNAKY_TEST );

    %% Odstran�n� ne��douc�ch p��znak� (KORELACE)

        % ji� nen� t�eba, z u�ebn� mno�iny jsou vybr�ny pouze relevantn�
        % p��znaky
        
    %% Odstran�n� ne��douc�ch p��znak� (D�LE�ITOST P��ZNAK�)

    PRIZNAKY_TRAIN = PRIZNAKY_TRAIN(:,vybrane_priznaky);

    %% Rozd�len� Train / Test 

    test_data = PRIZNAKY_TEST;
    train_data = PRIZNAKY_TRAIN;
    train_lab = lab_TRAIN;

    %% SAMOTN� KLASIFIKACE

    MODEL = fitcknn(train_data,train_lab,'NumNeighbors', pocet_sousedu); %
    [~, score] = predict(MODEL, test_data);

    label = score(:,2);
    label(label >= prah) = 1;
    label(label < 1) = 0;

    %% VYKRESLEN�

    zebra(label == 0) = [];
    stredove_linie_zeber = zeros(size(ELEMENT_CELY));

    for o = 1:length(zebra)  
       stredove_linie_zeber(ELEMENT_CELY == zebra(o)) = 1;
    end

    ELEMENT_CELY(ELEMENT_CELY>0) = 1;
    ostatni = ELEMENT_CELY-stredove_linie_zeber;
    [xz, yz, zz] = ind2sub(size(stredove_linie_zeber), find(stredove_linie_zeber));
    [xo, yo, zo] = ind2sub(size(ostatni), find(ostatni));

    figure()
    title('Primitiva klasifikovan� jako �ebra a pozad�.')
    plot3(xz, yz, zz, '.k', 'MarkerSize', 18);
    hold on
    plot3(xo, yo, zo, '.r', 'MarkerSize', 5);

    SEED = stredove_linie_zeber;

end
