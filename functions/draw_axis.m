function draw_axis(T_list, first, last, plot_title, open_flag, figure_name)
% T_list = zoznam HTM pre každý bod manipulátora
% lenght = dĺžka osí

if open_flag
openfig(figure_name);
end

hold on; grid on; axis equal;
xticks(0:500:8000);
yticks(0:500:8000);
zticks(0:500:8000);
xlabel('X'); ylabel('Y'); zlabel('Z');
title(plot_title);

for i = first:last
    T = T_list{i};
    p = T(1:3,4);
    R = T(1:3,1:3);

    if(i == 1 || i == 6)
        font_size = 14;
        lenght = 500;
    else
        font_size = 12;
        lenght = 300;
    end

    % vykreslenie osi
    quiver3(p(1), p(2), p(3), R(1,1)*lenght, R(2,1)*lenght, R(3,1)*lenght, 'r', 'LineWidth', 2);
    quiver3(p(1), p(2), p(3), R(1,2)*lenght, R(2,2)*lenght, R(3,2)*lenght, 'g', 'LineWidth', 2);
    quiver3(p(1), p(2), p(3), R(1,3)*lenght, R(2,3)*lenght, R(3,3)*lenght, 'b', 'LineWidth', 2);

    % popis osi
    text(p(1) + R(1,1)*lenght, p(2) + R(2,1)*lenght, p(3) + R(3,1)*lenght, ...
         sprintf('x_%d', i-1), 'Color','r','FontSize', font_size);

    text(p(1) + R(1,2)*lenght, p(2) + R(2,2)*lenght, p(3) + R(3,2)*lenght, ...
         sprintf('y_%d', i-1), 'Color','g','FontSize', font_size);

    text(p(1) + R(1,3)*lenght, p(2) + R(2,3)*lenght, p(3) + R(3,3)*lenght, ...
         sprintf('z_%d', i-1), 'Color','b','FontSize', font_size);
end

view(45,25);

if (open_flag)
    savefig('data/manipulator_all_axis.fig');
end
end

