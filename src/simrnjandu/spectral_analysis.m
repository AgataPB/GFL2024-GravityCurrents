clear
clc

track_z=zeros([241 1]);
umax = zeros([5 1]);
vmax = zeros([5 1]);
wmax = zeros([5 1]);

group_track_z = cell(5,1);
fspectrum = cell(5,1);

figure(1)
pbaspect([8 1 1]);
title(["Position of T=9 °C at FPlane = 45°"]);
%subtitle(strcat("Time = ",sprintf('%.3f',(time(k)/86400)), " days"));
xlabel("time (s)");
ylim([-500 0]);
ylabel("z (m)");
hold on;

for i = 1:1
    xCoords = squeeze(ncread(['buoyancy_front_' num2str(i) '_1.nc'], 'xC'));
    zCoords = squeeze(ncread(['buoyancy_front_' num2str(i) '_1.nc'], 'zC'));
    time = squeeze(ncread(['buoyancy_front_' num2str(i) '_1.nc'], 'time'));
    [x, z] = meshgrid(xCoords, zCoords);

    for j = 1:5
        Temp = squeeze(ncread(['buoyancy_front_' num2str(i) '_' num2str(j) '.nc'], 'T'));
        u = squeeze(ncread(['buoyancy_front_' num2str(i) '_' num2str(j) '.nc'], 'u'));
        v = squeeze(ncread(['buoyancy_front_' num2str(i) '_' num2str(j) '.nc'], 'v'));
        w = squeeze(ncread(['buoyancy_front_' num2str(i) '_' num2str(j) '.nc'], 'w'));

        umax(j) = max(u(:));
        vmax(j) = max(v(:));
        wmax(j) = max(w(:));

        temp_at_inspection_plane = squeeze(Temp(140,:,:));

        for k = 1:size(time,1)
            for m = 1 : size(temp_at_inspection_plane,1)-1
                if(temp_at_inspection_plane(m+1,k) > 9 && temp_at_inspection_plane(m,k) <= 9 )
                    track_z(k) = zCoords(m) + ...
                        (zCoords(m+1)-zCoords(m))/(temp_at_inspection_plane(m+1,k)-temp_at_inspection_plane(m,k))*(9-temp_at_inspection_plane(m,k));

                end
            end
        end
        plot(time,track_z);

        group_track_z{j} = track_z;

    end
end


figure
xlabel('Frequency')
ylabel('Power')
n = length(time);          % number of samples
fs = 1/(time(2) - time(1)); % per second
f = (0:n-1)*(fs/n);     % frequency range
hold on;

for i = 1:5
    fspectrum{i} = fft(group_track_z{i});
    power = abs(fspectrum{i}).^2/n;    % power of the DFT

    plot(f(2:length(f)),power(2:length(power)));

end
