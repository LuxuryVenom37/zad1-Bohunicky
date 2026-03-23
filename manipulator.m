%% Zadanie č. 1 – Priama kinematická úloha
% Úlohy 2 a 3: 3D vizualizácia manipulátora a súradnicových systémov
% Úloha 4: spustenie skriptov pre pracovný priestor
% Vypracoval: Viktor Bohunický, AIS ID: 133896

close all;
clear;
clc;

% pridanie priečinkov do path
addpath("data", "functions");

%% Parametre manipulátora

manipulator_data.ID  = 133896;
manipulator_data.ID2 = mod(manipulator_data.ID, 100);   % posledné dvojčíslie: 96
manipulator_data.ID3 = mod(manipulator_data.ID, 1000);  % posledné trojčíslie: 896

% všetky ramená majú rovnakú dĺžku z ID3 [mm]
manipulator_data.L = ones(6, 1) * manipulator_data.ID3;

% kĺbové rozsahy [stupne] získané z  ID2
manipulator_data.phi_range = {
    [-manipulator_data.ID2*2, manipulator_data.ID2*2];
    [-manipulator_data.ID2,   manipulator_data.ID2  ];
    [-manipulator_data.ID2,   manipulator_data.ID2  ];
    [-manipulator_data.ID2*3, manipulator_data.ID2*3];
    [-manipulator_data.ID2,   manipulator_data.ID2  ];
};

% pracovná konfigurácia manipulátora [stupne → radiány]
manipulator_data.phi = [
    -20;
     45;
     35;
    -25;
     75;
] * pi/180;

% osi rotácie jednotlivých kĺbov
manipulator_data.rot_axis = {'z','y','y','z','y'};

% overenie: pri nulových uhloch musí byť celková dĺžka 6·L
% manipulator_data.phi = zeros(5,1);

%% Homogénne transformačné matice

% T_list{1} = T00
% T_list{2..6} = T01..T05
% T_list{7} = T06 (posun bez rotácie o L6 pozdĺž z-osi)
T_list = cell(1, 7);
T_list{1} = eye(4);

% každá matica = posun pozdĺž z o dĺžku ramena, potom rotácia kĺbu
for i = 1:5
    Tz = translate_matrix('z', manipulator_data.L(i));
    R  = rotate_matrix(manipulator_data.rot_axis{i}, manipulator_data.phi(i));
    T_list{i+1} = T_list{i} * Tz * R;
end
clear R Tz i;

% koncový efektor: len posun, žiadna rotácia
T_list{7} = T_list{6} * translate_matrix('z', manipulator_data.L(6));

%% Polohy kĺbov

% z každej T-matice vytiahni posledný stĺpec (prvé tri riadky, štvrtý stĺpec)
p_list = cell(size(T_list));
for i = 1:length(T_list)
    p_list{i} = T_list{i}(1:3, 4);
end
clear i;

%% Vizualizácia

draw_manipulator(p_list);   % úsečky a kĺby manipulátora

% len svetový súradnicový systém
draw_axis(T_list, 1, 1, "Vykreslenie manipulátora v 3D", false);
% len koncový súradnicový systém 
draw_axis(T_list, 7, 7, "Vykreslenie manipulátora v 3D",  false);
%ulozenie grafu
savefig("data/manipulator_axis.fig")
% všetky súradnicové systémy naraz
draw_axis(T_list, 1, 7, "Manipulátor so všetkými súradnicovými systémami", true, "manipulator.fig");

%% Uloženie modelu

save("data/manipulator_model.mat", "manipulator_data", "T_list", "p_list");

%% Pracovný priestor

xy_prac_priestor    % pohľad zhora  – rotačné osi okolo z
xz_prac_priestor    % pohľad zboku  – rotačné osi okolo y