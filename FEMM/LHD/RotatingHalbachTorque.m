
unit = 'millimeters';
D = 100;        % Length of cylindrical magnet
N = 9;          % Number of magnets
d = 25.4;       % Magnet diameter
g = 1;          % Gap between magnets
a = 90;         % Start angle
ra = 90;        % Roll angle

AngleSteps = 5;        % Change in angle over sweep angle
EnableBavg = false;
EnableBn = false;
EnableTorque = true;

SWEEP_ANGLE = 90.0;
UPPER_DISPLAY_B = 1.0;
BN_TEST_HEIGHT = 5;
BN_TEST_POINTS = 500;
MIN_TEST_HEIGHT = 0;
MAX_TEST_HEIGHT = 20;
HEIGHT_TEST_LINES = 20;
HEIGHT_TEST_POINTS = 500;
HEIGHT_TEST_SIDE_CLEARANCE = 0.5 * d;

T = zeros(AngleSteps, N);
Bn = zeros(AngleSteps, BN_TEST_POINTS);

openfemm(0);                                % Open the FEMM program
%main_resize(1000,800);                      % Resize FEMM window

for ai = 1:(AngleSteps+1)
    for X = 1:N
        if (~EnableTorque && X == 2)
            break;
        end
        
        newdocument(0);                             % Create a new document
        mi_probdef(0,unit,'planar',1e-8,D,30);      % Define Problem
        mi_getmaterial('Air');
        mi_getmaterial('N52');

        L = d + g;
        offset = -L * (X - 1);
        r = d / 2.0; 

        for i = 0:(N - 1)
            x = i*L + offset;
            theta = a + (ai-1)*SWEEP_ANGLE/AngleSteps + ra*i;

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

        % -------------------- Results -------------------------
        
        % Torque on magnet X
        if (EnableTorque)
            mo_seteditmode('area');
            mo_selectblock(0, 0);
            T(ai, X) = mo_blockintegral(22);
            mo_clearblock;
        end
        
        if (EnableBn && X == 1)
            % Save image
            mo_showdensityplot(0,0,0,UPPER_DISPLAY_B,'mag')
            mo_zoom(-50,-70,260,76);
            mo_savebitmap(sprintf('rotatinghalbach_%03d.jpg', ai));
            
            % Graph of normal B field along halbach array
            y = r + BN_TEST_HEIGHT;
            for i = 1:BN_TEST_POINTS
                x = offset + (i-1)*L*N/BN_TEST_POINTS;
                B = mo_getb(x, y);
                Bn(ai,i) = B(2);
            end
        end

        % Graph of average B magnetude at different heights above array
        if (EnableBavg && ai == 1 && X == 1)
            Bavg = zeros(1, HEIGHT_TEST_LINES);

            length = L*N - 2*HEIGHT_TEST_SIDE_CLEARANCE;
            height = MAX_TEST_HEIGHT - MIN_TEST_HEIGHT;
            for i = 1:HEIGHT_TEST_LINES
                y = r + MIN_TEST_HEIGHT + (i-1)*height/HEIGHT_TEST_LINES;
                tot = 0;
                for j = 1:HEIGHT_TEST_POINTS
                    x = offset + HEIGHT_TEST_SIDE_CLEARANCE + (j-1)*length/HEIGHT_TEST_POINTS;
                    B = mo_getb(x, y);
                    tot = tot + sqrt(B(1)^2 + B(2)^2);
                end

                Bavg(i) = tot / HEIGHT_TEST_POINTS;
            end

            y = linspace(MIN_TEST_HEIGHT, MAX_TEST_HEIGHT, HEIGHT_TEST_LINES);
            figure;
            plot(y, Bavg);
        end
        
        mo_close;
        mi_close;
    end
    fprintf('Progress: %d/%d\n', ai, AngleSteps+1);
end

if (EnableBn)
    y = linspace(0, L*N, BN_TEST_POINTS);
    figure;
    plot(y, Bn);
end

if (EnableTorque)
    y = linspace(0, SWEEP_ANGLE, AngleSteps+1);
    figure;
    plot(y, T, '--', 'LineWidth', 1.5);
    hold on
    sumT = sum(T, 2);
    plot(y, sumT, 'k', 'LineWidth', 2.5);
    xlabel('Magnet angle (deg)')
    ylabel('Torque (N*m)')
    legend('Magnet 1', 'Magnet 2', 'Magnet 3', 'Magnet 4', 'Magnet 5', 'Magnet 6', 'Magnet 7', 'Magnet 8', 'Magnet 9', 'Sum')
    grid on
    grid minor
end


