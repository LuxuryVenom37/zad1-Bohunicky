function R = rotate_matrix(axis,phi);
%Vytvori 4x4 homogennu maticu rotacie na osi x, y alebo z


switch axis
    case 'x'
        R = [ 1    0         0     0;
              0 cos(phi) -sin(phi) 0;
              0 sin(phi)  cos(phi) 0;
              0    0         0     1];

    case 'y'
        R = [ cos(phi) 0 sin(phi) 0;
                 0     1    0     0;
             -sin(phi) 0 cos(phi) 0;
                 0     0    0     1];

    case 'z'
        R = [ cos(phi) -sin(phi) 0 0;
              sin(phi)  cos(phi) 0 0;
                 0         0     1 0;
                 0         0     0 1];

    otherwise
        error('Axis must be ''x'', ''y'' or ''z''.');
end

end