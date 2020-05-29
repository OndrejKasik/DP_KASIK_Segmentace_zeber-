clc 
clear all
close all

%% Popis

% Tento skript realizuje segmentaci �eber z hrudn�ch CT dat.
% Jeho vstupem jsou CT data v podob� matice (form�t .MAT).
% Skript spust�te stisknut�m tla��tka "Save and run" (F5).
% V tomto skriptu jsou vol�ny jednotliv� funkce realizuj�c� d�l�� kroky
% procesu segmentace �eber.
% Informace o aktu�ln�m stav procesu naleznete v p��kazov�m ��dku.

%% Na�ten� dat

VOLUME = load('TEST_CT_UINT16.mat');
VOLUME = VOLUME.VOLUME;
VOLUME = double(VOLUME);

% VOLUME = load('CT_PRAH.mat');
% VOLUME = VOLUME.CT;

%% P�edzpracov�n� vstupn�ch dat

[ BLUR ] = PREDZPRACOVANI( VOLUME, 1250 );

%% Detekce st�edov�ch lini�

[ RIDGE, V3 ] = STREDOVE_LINIE( BLUR );

%% Tvorba primitiv

[ PRIMITIVA ] = TVORBA_PRIMITIV( RIDGE, V3 );

%% Extrakce p��znak� 

[ PRIZNAKY ] = EXTRAKCE_PRIZNAKU( VOLUME, PRIMITIVA );

%% Klasifikace primitiv

[ SEED ] = KLASIFIKACE_PRIMITIV( PRIMITIVA, PRIZNAKY, 4, 0.5 );

%% �prava st�edov�ch lini� �eber

[ SEED_ZEBRA ] = UPRAVA_STREDOVYCH_LINII( VOLUME, SEED, 10, 24 ); 
[ SEED_BEZ_PATERE ] = UPRAVA_STREDOVYCH_LINII( VOLUME, SEED, 11, 20 ); 
[ SEED_POCATKY, CT_POCATKY, stred, sirka ] = detekce_patere( VOLUME, SEED_BEZ_PATERE, 35 );

%% Segmentace po��tk� �eber

[ ZEBRA_POCATKY ] = NARUSTANI_OBLASTI_3D( CT_POCATKY, SEED_POCATKY, 7, 160, 1.15, 1.1 ); 

%% Segmentace �eber

[ ZEBRA_TELA ] = NARUSTANI_OBLASTI_3D( VOLUME, SEED_ZEBRA, 13, 160, 1.1, 0.95 ); 

%% Sjednocen� �eber s jejich po��tky

ZEBRA = ZEBRA_TELA;
ZEBRA(:,stred-sirka:stred+sirka,:) = ZEBRA(:,stred-sirka:stred+sirka,:) + ZEBRA_POCATKY;
ZEBRA(ZEBRA>0) = 1;

ZEBRA = imgaussfilt(double(ZEBRA), 0.5);

%% Vizualizace �eber

volumeViewer(ZEBRA)

clear('V3', 'sirka', 'stred', 'CT_POCATKY', 'SEED_BEZ_PATERE', 'ZEBRA_POCATKY', 'ZEBRA_TELA' )
