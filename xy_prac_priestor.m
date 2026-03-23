%% Zadanie č. 1 – Priama kinematická úloha
% Úloha 4: pracovný priestor manipulátora – pohľad zhora (rovina XY)
% Vypracoval: Viktor Bohunický, AIS ID: 133896

% clear; close all; clc;

%% Načítanie modelu

addpath("data\", "functions\");
load("manipulator_model.mat");   % načíta manipulator_data, T_list, p_list

N_samples = 1000;   % počet vzoriek

%% Generovanie konfigurácií pre z-kĺby

% kĺby s rotáciou okolo z-osi dostanú rovnomerne rozložené uhly v celom rozsahu
% kĺby s rotáciou okolo y-osi ostanú zatiaľ nulové
phi_top = zeros(N_samples, 5);
for i = 1:5
    if manipulator_data.rot_axis{i} == 'z'
        range_i = manipulator_data.phi_range{i} * pi/180;
        phi_top(:, i) = linspace(range_i(1), range_i(2), N_samples)';
    else
        phi_top(:, i) = 0;
    end
end

%% Konfigurácia pre maximálny bočný dosah

% cieľ: phi2 + phi3 + phi5 = 90° (alebo maximum, ak rozsah nestačí)
% uhly sa prideľujú postupne: najprv phi2, zvyšok phi3, zvyšok phi5
target_sum = 90 * pi/180;

r2 = manipulator_data.phi_range{2} * pi/180;
r3 = manipulator_data.phi_range{3} * pi/180;
r5 = manipulator_data.phi_range{5} * pi/180;

phi2_val   = min(r2(2), target_sum);
current_sum = phi2_val;

if current_sum < target_sum
    phi3_val    = min(r3(2), target_sum - current_sum);
    current_sum = current_sum + phi3_val;
else
    phi3_val = 0;
end

if current_sum < target_sum
    phi5_val = min(r5(2), target_sum - current_sum);
else
    phi5_val = 0;
end

% aplikuj fixné y-uhly na všetky vzorky
phi_top(:, 2) = phi2_val;
phi_top(:, 3) = phi3_val;
phi_top(:, 5) = phi5_val;

%% Výpočet koncových bodov

% pre každú konfiguráciu vypočíta polohu konca manipulátora
P_top = zeros(N_samples, 3);
for k = 1:N_samples
    pts      = joint_pos(manipulator_data, phi_top(k,:));
    P_top(k,:) = pts(end,:);   % posledný riadok
end

xt = P_top(:, 1);
yt = P_top(:, 2);

%% Výpočet pracovnej obálky

% konvexná obálka nad mrakom bodov
k_xy  = convhull(xt, yt);
xt_arc = xt(k_xy);
yt_arc = yt(k_xy);

% zoradenie bodov obálky podľa uhla (kvôli správnemu vykresleniu krivky)
[~, idx] = sort(atan2(yt_arc, xt_arc));
xt_arc   = xt_arc(idx);
yt_arc   = yt_arc(idx);

% uzavretie obálky cez základňu [0, 0]
xt_obalka = [0; xt_arc; 0];
yt_obalka = [0; yt_arc; 0];

%% Poloha robota pri maximálnom bočnom dosahu

% rovnaké y-uhly ako pri výpočte dosahu, z-kĺby v nule (rovina XY)
phi_robot    = zeros(1, 5);
phi_robot(2) = phi2_val;
phi_robot(3) = phi3_val;
phi_robot(5) = phi5_val;

pts_top = joint_pos(manipulator_data, phi_robot);   % 6×3, polohy všetkých kĺbov

%% Vykreslenie

figure('Name', 'Pracovná obálka – pohľad zvrchu', 'Color', 'w');
hold on; grid on; axis equal;

% vyplnená obálka
patch(xt_obalka, yt_obalka, [0.8 1 0.8], ...
    'FaceAlpha', 0.5, 'EdgeColor', 'g', 'LineWidth', 1.5);

% robot v polohe maximálneho bočného dosahu
plot(pts_top(:,1), pts_top(:,2), '-',  'Color', '#4682B5', 'LineWidth', 2);
plot(pts_top(:,1), pts_top(:,2), 'o',  'Color', '#4682B5', 'MarkerFaceColor', 'k');

title('Pracovný priestor – pohľad zvrchu');
xlabel('X [mm]');
ylabel('Y [mm]');
hold off;

savefig('data/xy_prac_priestor.fig');