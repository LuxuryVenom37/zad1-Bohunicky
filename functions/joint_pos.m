function p = joint_pos(robot_data, q)
% Funkcia na získanie polohý všetkých kĺbov robota
% robot_data - štruktúra s parametrami robota
% q - uhly jednotlivých kĺbov
% p - matica 6x3, každý riadok obsahujee polohu kĺbu robota
    
    T = eye(4);
    p = zeros(6,3);
    
    for i = 1:5
        Tz = translate_matrix('z', robot_data.L(i));
        R  = rotate_matrix(robot_data.rot_axis{i}, q(i));
        T  = T * Tz * R;
        p(i,:) = T(1:3,4).';
    end
    
    T = T * translate_matrix('z', robot_data.L(6));
    p(6,:) = T(1:3,4).';
    
end