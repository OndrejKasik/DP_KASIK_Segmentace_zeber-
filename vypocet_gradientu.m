function [ GRADIENTY ] = vypocet_gradientu( CT )

    GRADIENTY = cell(3, 11);
    
% % %     DETERMINANTY = cell(pocet_meritek, 1);
% % %     TRACES = cell(pocet_meritek, 1);
    
    % sou�adnice h�ebenov�ch voxel�
% % %     ridge = (EL>0);    
% % %     [sx, sy, sz] = ind2sub(size(ridge), find(ridge));
    
%     VOLUME = CT;

%% SCALE = 1

%     CT = VOLUME;

    [gx, gy, gz] = gradient(CT); 
    
    GRADIENTY{1, 1} = CT;
    GRADIENTY{1, 11} = sqrt(gx.^2 + gy.^2 + gz.^2);
    
%% SCALE =  2   

    CT = imgaussfilt3(CT, 1);
     
    [gx, gy, gz] = gradient(CT); 
    
    GRADIENTY{2, 2} = gx;
    GRADIENTY{2, 11} = sqrt(gx.^2 + gy.^2 + gz.^2);

%% SCALE = 3

   CT = imgaussfilt3(CT, 2);
   
   [gx, gy, gz] = gradient(CT); 
   [~, gxy, gxz] = gradient(gx); 
   [~, ~, gyz] = gradient(gy); 
   [~, ~, gzz] = gradient(gz); 
   
   GRADIENTY{3, 2} = gx;
   GRADIENTY{3, 3} = gy;
   GRADIENTY{3, 4} = gz;
   GRADIENTY{3, 6} = gxy;
   GRADIENTY{3, 7} = gxz;
   GRADIENTY{3, 9} = gyz;
   GRADIENTY{3, 10} = gzz;
   
%%

% % %     for scale = 1:pocet_meritek 
% % % 
% % %         switch scale
% % %             case 1
% % %                 disp('Prob�h� v�po�et gragientu pro scale == 0')
% % %             case 2
% % %                 disp('Prob�h� v�po�et gragientu pro scale == 1')
% % %                 CT = imgaussfilt3(CT, 1);
% % %             case 3
% % %                 disp('Prob�h� v�po�et gragientu pro scale == 2')
% % %                 CT = imgaussfilt3(CT, 2); 
% % %             case 4
% % %                 disp('Prob�h� v�po�et gragientu pro scale == 4')
% % %                 CT = imgaussfilt3(CT, 4); 
% % %         end 
% % % 
% % % 
% % %         [gx, gy, gz] = gradient(CT); % 1.
% % %         [gxx, gxy, gxz] = gradient(gx); % 2.
% % %         [~, gyy, gyz] = gradient(gy); % 2.
% % %         [~, ~, gzz] = gradient(gz); % 2.
% % % 
% % %         GRADIENTY{scale, 1} = CT;
% % %         
% % %         GRADIENTY{scale, 2} = gx;
% % %         GRADIENTY{scale, 3} = gy;
% % %         GRADIENTY{scale, 4} = gz;
% % %         
% % %         GRADIENTY{scale, 5} = gxx;
% % %         GRADIENTY{scale, 6} = gxy;
% % %         GRADIENTY{scale, 7} = gxz;
% % %         GRADIENTY{scale, 8} = gyy;
% % %         GRADIENTY{scale, 9} = gyz;
% % %         GRADIENTY{scale, 10} = gzz;
% % %         
% % %         GRADIENTY{scale, 11} = sqrt(gx.^2 + gy.^2 + gz.^2);
        
        
        
        % v�po�et DETERMINANTU a TRACE Hessovy matice pro ka�d� voxel ridge
        
% % %         DETERMINANT = zeros(size(CT));
% % %         TRACE = zeros(size(CT));
        
% % %         for voxel = 1:length(sx)
% % %             
% % %             x = sx(voxel); 
% % %             y = sy(voxel); 
% % %             z = sz(voxel);
% % %             
% % %             H = [ gxx(x,y,z) gxy(x,y,z) gxz(x,y,z) ; gxy(x,y,z) gyy(x,y,z) gyz(x,y,z) ; gxz(x,y,z) gyz(x,y,z) gzz(x,y,z)];
% % %             
% % %             DETERMINANT(x,y,z) = det(H);
% % %             TRACE(x,y,z) = H(1,1) + H(1,1) + H(3,3);
% % %             
% % %         end
        
% % %         DETERMINANTY{scale,1} = DETERMINANT;
% % %         TRACES{scale,1} = TRACE;

end


