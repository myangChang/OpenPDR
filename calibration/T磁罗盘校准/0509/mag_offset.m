%mag_offset
clc;
clear;
close all;

load('mag_offset.mat');
% scatter3(mx,my,mz);
% plot3(mx,my,mz,'b.');grid on;
x = mx;
y = my;
z = mz;

% do the fitting
[ center, radii, evecs, v, chi2 ] = ellipsoid_fit( [ x y z ], '' );
fprintf( 'Ellipsoid center: %.5g %.5g %.5g\n', center );
fprintf( 'Ellipsoid radii: %.5g %.5g %.5g\n', radii );
FS = [radii(3)/radii(1),radii(3)/radii(2),radii(3)/radii(3)];
fprintf( 'Fator Scale: %.5g %.5g %.5g\n', radii(3)/radii(1),radii(3)/radii(2),radii(3)/radii(3) );
fprintf( 'Ellipsoid evecs:\n' );
fprintf( '%.5g %.5g %.5g\n%.5g %.5g %.5g\n%.5g %.5g %.5g\n', ...
    evecs(1), evecs(2), evecs(3), evecs(4), evecs(5), evecs(6), evecs(7), evecs(8), evecs(9) );
fprintf( 'Algebraic form:\n' );
fprintf( '%.5g ', v );
fprintf( '\nAverage deviation of the fit: %.5f\n', sqrt( chi2 / size( x, 1 ) ) );
fprintf( '\n' );

% draw data
figure;
plot3( x, y, z, '.r' );
hold on;axis equal;

%draw fit
mind = min( [ x y z ] );
maxd = max( [ x y z ] );
nsteps = 50;
step = ( maxd - mind ) / nsteps;
[ x, y, z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ), linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ), linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );

Ellipsoid = v(1) *x.*x +   v(2) * y.*y + v(3) * z.*z + ...
          2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ...
          2*v(7) *x    + 2*v(8)*y    + 2*v(9) * z;
p = patch( isosurface( x, y, z, Ellipsoid, -v(10) ) );
hold off;
set( p, 'FaceColor', 'g', 'EdgeColor', 'none' );
view( -70, 40 );
axis vis3d equal;
camlight;
lighting phong;

% [x_fit, y_fit, z_fit] = ellipsoid(center(1),center(2),center(3),radii(1),radii(2),radii(3),30);
% surf(x_fit, y_fit, z_fit)
% axis equal;


x1 = FS(1)*(mx - center(1));
y1 = FS(2)*(my - center(2));
z1 = FS(3)*(mz - center(3));
figure;
scatter3(x1,y1,z1,'b','filled');%校正之后的圆
hold on;
scatter3(mx,my,mz,'r','filled');%未校正之后的圆
axis equal

figure;
nbins = 36;
subplot(3,1,1);
histogram(x1,nbins);
xlabel('hx');ylabel('#sample');title('samples magnetic field strength distribution');
subplot(3,1,2);
histogram(y1,nbins);
xlabel('hx');ylabel('#sample');
subplot(3,1,3);
histogram(z1,nbins);
xlabel('hx');ylabel('#sample');


rang_mx = (max(mx)-min(mx))/2;
rang_my = (max(my)-min(my))/2;
rang_mz = (max(mz)-min(mz))/2;
[rang_mx rang_my rang_mz]
% clear;