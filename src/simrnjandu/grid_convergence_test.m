

%ncdisp('buoyancy_front_1_1.nc');


%Salinity = squeeze(ncread('buoyancy_front_1_1.nc','S'));


%[x, z] = meshgrid(xCoords, zCoords);

% Temp1 = Temp(:,:,1);
% Temp = squeeze(ncread('buoyancy_front_1_1.nc', 'T'));
%
% figure
% contourf(x,z,(Temp1)');
% pbaspect([8 1 1]);
% title(["Temperature (°C) at FPlane = 0°, Time = " numstr() " days"]);
% xlabel("x (m)");
% ylabel("y (m)");
% cb = contourcbar;
% cb.XLabel.String = "Temperature (°C)";
% saveas(gcf,'picture.png');

track_z=zeros([1201 1]);
umax = zeros([5 1]);
vmax = zeros([5 1]);
wmax = zeros([5 1]);

for i = 1:2
    xCoords = squeeze(ncread(['buoyancy_front_' num2str(i) '_1.nc'], 'xC'));
    zCoords = squeeze(ncread(['buoyancy_front_' num2str(i) '_1.nc'], 'zC'));
    time = squeeze(ncread(['buoyancy_front_' num2str(i) '_1.nc'], 'time'));
    [x, z] = meshgrid(xCoords, zCoords);

    for j = 1:1
        Temp = squeeze(ncread(['buoyancy_front_' num2str(i) '_' num2str(j) '.nc'], 'T'));
        u = squeeze(ncread(['buoyancy_front_' num2str(i) '_' num2str(j) '.nc'], 'u'));
        v = squeeze(ncread(['buoyancy_front_' num2str(i) '_' num2str(j) '.nc'], 'v'));
        w = squeeze(ncread(['buoyancy_front_' num2str(i) '_' num2str(j) '.nc'], 'w'));


        % u_t = u(:,:,k);
        % v_t = v(:,:,k);
        % w_t = w(:,:,k);

        umax(j) = max(u(:));
        vmax(j) = max(v(:));
        wmax(j) = max(w(:));

        temp_at_inspection_plane = squeeze(Temp(140,:,:));

        %for k = 1:10:1201
        for k = 1:1201
            % figure
            % contourf(x,z,(Temp(:,:,k))');
            % pbaspect([8 1 1]);
            % title(["Temperature (°C) at FPlane = 45°"]);
            % subtitle(strcat("Time = ",sprintf('%.3f',(time(k)/86400)), " days"));
            % xlabel("x (m)");
            % ylabel("y (m)");
            % cb = contourcbar;
            % cb.XLabel.String = "Temperature (°C)";
            % saveas(gcf,['fig' num2str(i) '_' num2str(j) '_' num2str(k) '.png']);
            % close;




            for m = 1 : size(temp_at_inspection_plane,1)-1
                if(temp_at_inspection_plane(m+1,k) > 9.00 && temp_at_inspection_plane(m,k) <= 9.0 )
                    track_z(k) = zCoords(m) + ...
                        (zCoords(m+1)-zCoords(m))/(temp_at_inspection_plane(m+1,k)-temp_at_inspection_plane(m,k))*(9-temp_at_inspection_plane(m,k));

                end
            end
        end
        figure
        plot(time,track_z);
        pbaspect([8 1 1]);
        title(["Position of T=9 °C at FPlane = 45°"]);
        %subtitle(strcat("Time = ",sprintf('%.3f',(time(k)/86400)), " days"));
        xlabel("time (s)");
        ylim([-500 -200]);
        ylabel("z (m)");
        %cb = contourcbar;
        %cb.XLabel.String = "Temperature (°C)";
        saveas(gcf,['plot' num2str(i) '_' num2str(j) '.png']);
        close;
    end
end

vmag = zeros([5,1]);
for t = 1:5
    vmag(t) = sqrt(umax(t)^2 + vmax(t)^2 + wmax(t)^2);
end
 
plot(vmag);



