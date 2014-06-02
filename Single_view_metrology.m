input = imread('CSL.jpg', 'jpg');

%{
vp_z = getVanishingPoint_shell(input);
vp_x = getVanishingPoint_shell(input);
vp_y = getVanishingPoint_shell(input);
%}


vp_z = [-205 213 1]
vp_x = [1295 222 1]
vp_y = [428 4683 1]
%vp_y = [550 4683 1]

figure();
imagesc(input);
hold on;
plot(vp_x(1), vp_x(2), 'r*');
plot(vp_y(1), vp_y(2), 'r*');
plot(vp_z(1), vp_z(2), 'r*');

figure();
imagesc(input);
hold on;
plot([vp_z(1) vp_x(1)], [vp_z(2) vp_x(2)]);
axis image;

horizon = real(cross(vp_z', vp_x'));

length = sqrt(horizon(1)^2 + horizon(2)^2);
horizon = horizon/length;

%camera calibration
syms u v;
[u_sol, v_sol] = solve(...
                    -u*(vp_x(1)+vp_y(1)) + vp_x(1)*vp_y(1) + -v*(vp_x(2)+vp_y(2)) + vp_x(2)*vp_y(2) == ...
                    -u*(vp_y(1)+vp_z(1)) + vp_y(1)*vp_z(1) + -v*(vp_y(2)+vp_z(2)) + vp_y(2)*vp_z(2),...
                    -u*(vp_z(1)+vp_x(1)) + vp_z(1)*vp_x(1) + -v*(vp_z(2)+vp_x(2)) + vp_z(2)*vp_x(2) == ...
                    -u*(vp_y(1)+vp_z(1)) + vp_y(1)*vp_z(1) + -v*(vp_y(2)+vp_z(2)) + vp_y(2)*vp_z(2));
syms f;
[f_sol] = solve((u_sol - vp_x(1))*(u_sol - vp_y(1)) + (v_sol - vp_x(2))*(v_sol - vp_y(2)) + f*f == 0);

f = double(f_sol);
f = f(1);
u = double(u_sol);
v = double(v_sol);

K = [f      0       u;
     0      f       v;
     0      0       1];                
%rotation matrix                
r_x = inv(K)*vp_x';
r_y = inv(K)*vp_y';
r_z = inv(K)*vp_z';

r_x = r_x / sqrt(sumsqr(r_x));
r_y = r_y / sqrt(sumsqr(r_y));
r_z = r_z / sqrt(sumsqr(r_z));

R = [r_x r_y r_z]; 

%measure height

b0 = [628 507 1];
t0 = [628 464 1];
H = 66;

reference_points = load('reference_points.mat');
reference_points = reference_points.reference_points;
height = zeros(size(reference_points, 1), 1);
for i = 1:size(reference_points, 1)
    b = reference_points(i, 1:3);
    r = reference_points(i, 4:6);
    line1 = real(cross(b0', b'));
    v = real(cross(line1, horizon));
    v = v/v(3);

    line2 = real(cross(v', t0'));
    vertical_line = real(cross(r', b'));
    t = real(cross(line2', vertical_line'));
    t = t/t(3);
    
    %draw pictures
    figure();
    imagesc(input);
    hold on;
    plot([vp_z(1) vp_x(1)], [vp_z(2) vp_x(2)]);
    plot([v(1) b0(1)], [v(2) b0(2)], 'r');
    plot([t0(1) b0(1)], [t0(2) b0(2)], 'r');
    plot([v(1) t0(1)], [v(2) t0(2)], 'r');
    plot([v(1) t(1)], [v(2) t(2)], 'g');
    plot([b(1) t(1)], [b(2) t(2)], 'g');
    plot([b(1) v(1)], [b(2) v(2)], 'g');
    plot([b(1) r(1)], [b(2) r(2)], 'y');
    axis equal;
    axis image;


    height(i) = H*sqrt(sumsqr(r-b))*sqrt(sumsqr(vp_z-t))/...
        sqrt(sumsqr(t-b))/sqrt(sumsqr(vp_z-r));
    
end