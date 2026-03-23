Zadanie č. 1 – Vizualizácia priamej kinematickej úlohy
Vypracoval: Viktor Bohunický
AIS ID: 133896

======================================================
SPUSTENIE
======================================================

Otvorte priečinok projektu v MATLAB-e a spustite:

    manipulator.m

Skript nakreslí robota so súradnicovými systémami a potom spočíta
pracovný priestor – raz v rovine XY (pohľad zhora), raz v rovine XZ
(pohľad zboku).

======================================================
ŠTRUKTÚRA PROJEKTU
======================================================

manipulator.m           hlavný skript
xy_prac_priestor.m      pracovný priestor, rovina XY
xz_prac_priestor.m      pracovný priestor, rovina XZ
README.txt              tento súbor

/functions
    draw_axis.m
    draw_manipulator.m
    joint_pos.m
    rotate_matrix.m
    translate_matrix.m

/data                   (generované po spustení)
    manipulator.fig
    manipulator_model.mat
    xy_prac_priestor.fig
    xz_prac_priestor.fig

======================================================
ČO ROBÍ KAŽDÝ SÚBOR
======================================================

manipulator.m
    Nastaví parametre robota podľa AIS ID, zostaví homogénne
    transformačné matice, vypočíta polohy kĺbov a všetko vykreslí.
    Výsledok uloží do data/manipulator_model.mat, potom zavolá oba
    skripty pre pracovný priestor.

xy_prac_priestor.m
    Pracovný priestor v rovine XY (pohľad zhora).
    Prechádza konfiguráciami rotačných osí okolo z-osi.
    Uhly phi2, phi3 a phi5 nastavuje tak, aby ich súčet dosiahol 90°
    alebo maximum povolených rozsahov – podľa toho, čo nastane skôr.
    Polohy koncového bodu počíta cez joint_pos.
    Obrys priestoru určuje konvexnou obálkou (convhull), body zoraďuje
    podľa atan2.

xz_prac_priestor.m
    Pracovný priestor v rovine XZ (pohľad zboku).
    Načíta model z manipulator_model.mat.
    Prehľadáva kombinácie uhlov kĺbov 2, 3 a 5 (rotácia okolo y-osi)
    cez 3D mriežku (ndgrid).
    Obrys počíta pomocou alphaShape; ak zlyhá, padne späť na convhull.

======================================================
FUNKCIE V /functions
======================================================

draw_axis.m
    Vykreslí súradnicové systémy robota.
    Farby: x červená, y zelená, z modrá.

draw_manipulator.m
    Nakreslí robota ako úsečky medzi kĺbmi.
    Uloží obrázok do data/manipulator.fig.

joint_pos.m
    Pre zadané uhly vráti maticu 6×3 s polohou každého kĺbu.

rotate_matrix.m
    Vráti 4×4 homogénnu rotačnú maticu okolo osi x, y alebo z.

translate_matrix.m
    Vráti 4×4 homogénnu translačnú maticu pozdĺž osi x, y alebo z.

======================================================
PARAMETRE MANIPULÁTORA
======================================================

AIS ID: 133896
    ID2 = 96   (posledné dvojčíslie)
    ID3 = 896  (posledné trojčíslie)

Dĺžky ramien:
    L1 = L2 = L3 = L4 = L5 = L6 = 896 mm

Rozsahy uhlov (stupne):
    phi1  <-192, 192>
    phi2  < -96,  96>
    phi3  < -96,  96>
    phi4  <-288, 288>
    phi5  < -96,  96>

Osi rotácie: { z, y, y, z, y }

======================================================
VÝSTUPY
======================================================

Po spustení manipulator.m priečinok /data obsahuje:

    manipulator_model.mat       parametre a model robota
    manipulator.fig             3D vizualizácia s osami
    xy_prac_priestor.fig        pracovný priestor, rovina XY
    xz_prac_priestor.fig        pracovný priestor, rovina XZ