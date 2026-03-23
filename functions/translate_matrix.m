function T = translate_matrix(axis, d)
% Vytvori 4x4 homogennu maticu posunu pozdlz osi x, y alebo z

% Vytvorenie jednotkovej matice
T = eye(4);

switch axis
    case 'x'
        T(1,4) = d;

    case 'y'
        T(2,4) = d;

    case 'z'
        T(3,4) = d;

    otherwise
        error('Axis must be ''x'', ''y'' or ''z''.');
end

end