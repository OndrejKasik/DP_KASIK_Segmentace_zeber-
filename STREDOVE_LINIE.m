function [ ridge, vektor3 ] = STREDOVE_LINIE( blur )

clc
disp('Prob�h� detekce h�ebenov�ch voxel�.');
h = waitbar(0,'Prob�h� detekce h�ebenov�ch voxel�.');

%% V�po�et gradientn�ch obraz�

ridge = zeros(size(blur));
vektor3 = cell(size(blur));
ct = blur;

[gx, gy, gz] = gradient(ct);
[XX, XY, XZ] = gradient(gx);
[YX, YY, YZ] = gradient(gy);
[ZX, ZY, ZZ] = gradient(gz);
 
%% Detekce h�ebenov�ch voxel�

i = size(ct, 1); 
j = size(ct, 2); 
k = size(ct, 3); 
 
polo = 1; 
theta = [0 45 90 135 180 225 270 315];
theta = deg2rad(theta);

for  z = 2:k-1
   for x = 2:i-1
       for y = 2:j-1

           if ct(x, y, z) > 300 
           
               % Hesian Matrix
               H = [ XX(x,y,z) XY(x,y,z) XZ(x,y,z) ; YX(x,y,z) YY(x,y,z) YZ(x,y,z) ; ZX(x,y,z) ZY(x,y,z) ZZ(x,y,z)];
               
               % Eigen Vectors
               [eig_vec, eig_val] = eig(H);
               
               % Se�azen� vektor� sestupn� dle vlastn�ch ��sel
               razeni = zeros(3,4);
                
               razeni(1,:) = [eig_vec(:,1)', eig_val(1,1)];
               razeni(2,:) = [eig_vec(:,2)', eig_val(2,2)];
               razeni(3,:) = [eig_vec(:,3)', eig_val(3,3)]; 
                
               razeni = sortrows(razeni, 4, 'descend');
               razeni(:,4) = [];
               v1 = razeni(1,:);
               v2 = razeni(2,:);
               v3 = razeni(3,:);
               
               vektor3{x,y,z} = v3;
                
               % Porovn�v�n� pixel� v okol� ka�d�ho pixelu (v definovan� rovin�)
               
               for p = 1:length(theta)
                   
                   c =  [x, y, z] + polo*(v1*cos(theta(p)) + v2*sin(theta(p)));
                   hodnota_c = ct(round(c(1)), round(c(2)), round(c(3)));  
                   
                   if hodnota_c > ct(x,y,z)
                       break
                   elseif p == length(theta)
                       ridge(x,y,z) = 1;
                   end

               end
           end
       end
   end
   
   %% V�pis do CW
   
   clc
   disp('Prob�h� detekce h�ebenov�ch voxel�.');
   disp(['  - zpracov�v� se ', num2str(z), '. �ez z ', num2str(size(blur,3))])
   waitbar(z / size(blur,3))
   
end

close(h)

end

