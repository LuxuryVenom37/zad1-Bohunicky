function draw_manipulator(p_list)
% Funkcia na vykreslenie manipulátora
% p_list = zoznam polohových vektorov 

figure('Name','Vykreslenie manipulátora v 3D','Color','w');
hold on; grid on; axis equal;
xticks(0:500:8000);
yticks(0:500:8000);
zticks(0:500:8000);

% vykreslenie ramien a kĺbov
for i = 1:length(p_list)-1
    p = p_list{i};
    j = i+1;
    q = p_list{j};

plot3([p(1) q(1)], [p(2) q(2)], [p(3) q(3)], '-', 'Color', '#4682B5', 'LineWidth', 2);
plot3(p(1), p(2), p(3), 'o', 'Color', '#4682B5', 'MarkerSize', 8, 'MarkerFaceColor','k');
end
plot3(p_list{length(p_list)}(1), p_list{length(p_list)}(2), p_list{length(p_list)}(3), 'o', 'Color', '#4682B5', 'MarkerSize', 8, 'MarkerFaceColor','k');

title('Vykreslenie manipulátora v 3D');
xlabel('X'); ylabel('Y'); zlabel('Z');
view(45,25);

savefig('data/manipulator.fig');
end