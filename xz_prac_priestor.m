%% Zadanie č. 1 – Priama kinematická úloha
% Úloha 4: pracovný priestor manipulátora – pohľad zboku (rovina XZ)
% Vypracoval: Viktor Bohunický, AIS ID: 133896

% clear; close all; clc;

%% Načítanie modelu

addpath("data\", "functions\");
load("manipulator_model.mat");   % načíta manipulator_data, T_list, p_list

% krok vzorkovania y-kĺbov [stupne]
% pri zúžení phi_range musí step_deg ostať deliteľom rozsahu
step_deg = 6;

%% Generovanie polôh pre y-kĺby

% pohľad zboku ovplyvňujú len kĺby rotujúce okolo y-osi: phi2, phi3, phi5
% phi1 a phi4 (z-os) ostávajú nulové – v rovine XZ sa neprejavujú
p2_vals = deg2rad(manipulator_data.phi_range{2}(1) : step_deg : manipulator_data.phi_range{2}(2));
p3_vals = deg2rad(manipulator_data.phi_range{3}(1) : step_deg : manipulator_data.phi_range{3}(2));
p5_vals = deg2rad(manipulator_data.phi_range{5}(1) : step_deg : manipulator_data.phi_range{5}(2));

% 3D mriežka všetkých kombinácií – každý prvok = jedna konfigurácia
[P2, P3, P5] = ndgrid(p2_vals, p3_vals, p5_vals);
N = numel(P2);   % celkový počet konfigurácií

%% Výpočet pracovného priestoru

% pre každú konfiguráciu vypočíta polohu 6. kĺbu
% ukladáme len X a Z súradnice – Y sa pri pohľade zboku ignoruje
pointsXZ = zeros(N, 2);
for i = 1:N
    [i2, i3, i5] = ind2sub(size(P2), i);
    q    = zeros(5, 1);
    q(2) = P2(i2, i3, i5);
    q(3) = P3(i2, i3, i5);
    q(5) = P5(i2, i3, i5);

    p         = joint_pos(manipulator_data, q);
    p0k       = p(6, :);                    % 6. kĺb
    pointsXZ(i,:) = [p0k(1), p0k(3)];      % [X, Z]
end

% odstráni duplicitné body pre vykreslovaním
pointsXZ = unique(pointsXZ, 'rows');

%% Poloha robota v hraničnej polohe

q_max    = zeros(5, 1);
q_max(2) = deg2rad(manipulator_data.phi_range{2}(2));
q_max(3) = deg2rad(manipulator_data.phi_range{3}(2));
q_max(5) = deg2rad(manipulator_data.phi_range{5}(2));

P_all = joint_pos(manipulator_data, q_max);   % 6×3, polohy všetkých kĺbov

%% Vykreslenie

figure('Name', 'Pracovná obálka – pohľad zboku', 'Color', 'w');
hold on; grid on; axis equal;

% obálka: vykreslí sa cez alphaShape
shp           = alphaShape(pointsXZ(:,1), pointsXZ(:,2), 1000);
h             = plot(shp);
h.FaceColor   = '#CCFFCC';
h.FaceAlpha   = 0.3;
h.EdgeColor   = '#22AA22';


% robot v hraničnej polohe
plot(P_all(:,1), P_all(:,3), '-', 'Color', '#4682B5', 'LineWidth', 2);
plot(P_all(:,1), P_all(:,3), 'o', 'Color', '#4682B5', 'MarkerFaceColor', 'k');

title('Pracovný priestor – pohľad zboku');
xlabel('X [mm]');
ylabel('Z [mm]');
hold off;

savefig('data/xz_prac_priestor.fig');