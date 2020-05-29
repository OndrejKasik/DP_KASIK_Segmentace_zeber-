clc 
clear all
close all

%% Popis

% Tento skript realizuje segmentaci žeber z hrudních CT dat.
% Jeho vstupem jsou CT data v podobì matice (formát .MAT).
% Skript spustíte stisknutím tlaèítka "Save and run" (F5).
% V tomto skriptu jsou volány jednotlivé funkce realizující dílèí kroky
% procesu segmentace žeber.
% Informace o aktuálním stav procesu naleznete v pøíkazovém øádku.

%% Naètení dat

VOLUME = load('TEST_CT_UINT16.mat');
VOLUME = VOLUME.VOLUME;
VOLUME = double(VOLUME);

% VOLUME = load('CT_PRAH.mat');
% VOLUME = VOLUME.CT;

%% Pøedzpracování vstupních dat

[ BLUR ] = PREDZPRACOVANI( VOLUME, 1250 );

%% Detekce støedových linií

[ RIDGE, V3 ] = STREDOVE_LINIE( BLUR );

%% Tvorba primitiv

[ PRIMITIVA ] = TVORBA_PRIMITIV( RIDGE, V3 );

%% Extrakce pøíznakù 

[ PRIZNAKY ] = EXTRAKCE_PRIZNAKU( VOLUME, PRIMITIVA );

%% Klasifikace primitiv

[ SEED ] = KLASIFIKACE_PRIMITIV( PRIMITIVA, PRIZNAKY, 4, 0.5 );

%% Úprava støedových linií žeber

[ SEED_ZEBRA ] = UPRAVA_STREDOVYCH_LINII( VOLUME, SEED, 10, 24 ); 
[ SEED_BEZ_PATERE ] = UPRAVA_STREDOVYCH_LINII( VOLUME, SEED, 11, 20 ); 
[ SEED_POCATKY, CT_POCATKY, stred, sirka ] = detekce_patere( VOLUME, SEED_BEZ_PATERE, 35 );

%% Segmentace poèátkù žeber

[ ZEBRA_POCATKY ] = NARUSTANI_OBLASTI_3D( CT_POCATKY, SEED_POCATKY, 7, 160, 1.15, 1.1 ); 

%% Segmentace žeber

[ ZEBRA_TELA ] = NARUSTANI_OBLASTI_3D( VOLUME, SEED_ZEBRA, 13, 160, 1.1, 0.95 ); 

%% Sjednocení žeber s jejich poèátky

ZEBRA = ZEBRA_TELA;
ZEBRA(:,stred-sirka:stred+sirka,:) = ZEBRA(:,stred-sirka:stred+sirka,:) + ZEBRA_POCATKY;
ZEBRA(ZEBRA>0) = 1;

ZEBRA = imgaussfilt(double(ZEBRA), 0.5);

%% Vizualizace žeber

volumeViewer(ZEBRA)

clear('V3', 'sirka', 'stred', 'CT_POCATKY', 'SEED_BEZ_PATERE', 'ZEBRA_POCATKY', 'ZEBRA_TELA' )
