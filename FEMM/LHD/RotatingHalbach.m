

unit = 'millimeters';
N = 9;          % Number of magnets
X = 1;          % Magnet being analyzed (for torque) (1 to N)
d = 25.4;       % Magnet diameter
g = 1;          % Gap between magnets
a = 90;         % Start angle
da = 90;        % Roll angle

UPPER_DISPLAY_B = 1.0;

BN_TEST_HEIGHT = 5;
BN_TEST_POINTS = 500;
MIN_TEST_HEIGHT = 0;
MAX_TEST_HEIGHT = 20;
HEIGHT_TEST_LINES = 20;
HEIGHT_TEST_POINTS = 500;
HEIGHT_TEST_SIDE_CLEARANCE = 0.5 * d;



openfemm;                                   % Open the FEMM program...
main_resize(1000,800);                       % Resize FEMM window..
newdocument(0);                             % Create a new document...
mi_probdef(0,unit,'planar',1e-8,1,30);         % Define Problem..
mi_getmaterial('Air');
mi_getmaterial('N52');

L = d + g;
offset = -L * (X - 1);
r = d / 2.0; 

for i = 0:(N - 1)
    x = i*L + offset;
    theta = a + da*i;
    
    mi_drawarc(x, -r, x, r, 180, 1);        % Draw circle
    mi_addarc(x, r, x, -r, 180, 1);
    
    mi_addblocklabel(x, 0);                 % Add Magnetic Material
    mi_selectlabel(x, 0);
    mi_setblockprop('N52', 1, 0, '<None>', theta, 0, 0);
    mi_clearselected;
end

mi_addblocklabel(offset, d);        % Add Air
mi_selectlabel(offset, d);
mi_setblockprop('Air', 1, 0, '<None>', 0, 0, 0);
mi_clearselected;

mi_makeABC;                         % Create default open boundary
mi_zoomnatural;                     
mi_saveas('rotatinghalbach.fem');
mi_analyze;
mi_loadsolution;

mo_showdensityplot(1,0,0,UPPER_DISPLAY_B,'mag')

% -------------------- Results -------------------------

% Torque on magnet X
mo_seteditmode('area');
mo_selectblock(0, 0);
mo_blockintegral(22)
mo_clearblock;

% Graph of normal B field along halbach array
Bn = zeros(1, BN_TEST_POINTS);

y = r + BN_TEST_HEIGHT;
for i = 1:BN_TEST_POINTS
    x = offset + (i-1)*L*N/BN_TEST_POINTS;
    B = mo_getb(x, y);
    Bn(i) = B(2);
end

y = linspace(0, L*N, BN_TEST_POINTS);
plot(y, Bn);

% Graph of average B magnetude at different heights above array
Bavg = zeros(1, HEIGHT_TEST_LINES);

length = L*N - 2*HEIGHT_TEST_SIDE_CLEARANCE;
height = MAX_TEST_HEIGHT - MIN_TEST_HEIGHT;
for i = 1:HEIGHT_TEST_LINES
    y = r + MIN_TEST_HEIGHT + (i-1)*height/HEIGHT_TEST_LINES;
    sum = 0;
    for j = 1:HEIGHT_TEST_POINTS
        x = offset + HEIGHT_TEST_SIDE_CLEARANCE + (j-1)*length/HEIGHT_TEST_POINTS;
        B = mo_getb(x, y);
        sum = sum + sqrt(B(1)^2 + B(2)^2);
    end
    
    Bavg(i) = sum / HEIGHT_TEST_POINTS;
end

y = linspace(MIN_TEST_HEIGHT, MAX_TEST_HEIGHT, HEIGHT_TEST_LINES);
figure;
plot(y, Bavg);



