function [ SEED_pater, CT_pater, SY, sirka ] = detekce_patere( CT, SEED_N, sirka )
 
 %% Odstranìní páteøe

% sirka = 25;

[x, y, z] = ind2sub(size(SEED_N), find(SEED_N));
souradnice = [x, y, z];

stred = round(mean(souradnice));

% SY = stred(2);

% SY = round((7*(size(SEED_N, 2) / 2) + stred(2))/8);
SY = round((5*(size(SEED_N, 2) / 2) + stred(2))/6);
% SY = round((3*(size(SEED_N, 2) / 2) + stred(2))/4);
% SY = round(((size(SEED_N, 2) / 2) + stred(2))/2);

SEED_pater = SEED_N(:,SY-sirka:SY+sirka,:);

CT_pater = CT(:,SY-sirka:SY+sirka,:);
  
 %% Vykreslení
 
%  [x, y, z] = ind2sub(size(SEED), find(SEED)); 
%  [k, l, m] = ind2sub(size(SEED_N), find(SEED_N)); 
%  
%  odstraneno = SEED-SEED_N;
%  [t, u, v] = ind2sub(size(odstraneno), find(odstraneno)); 
 
%  figure()
%  subplot(121)
%  plot3(x, y, z, 'k.', 'MarkerSize', 15);
%  subplot(122)
%  plot3(k, l, m, 'k.', 'MarkerSize', 15);
%  hold on
%  plot3(128, SY, 130, 'r.', 'MarkerSize', 20)
%  plot3(t, u, v, 'y.', 'MarkerSize', 15)


end

