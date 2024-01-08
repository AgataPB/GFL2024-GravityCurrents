clear
clc

ncdisp('buoyancy_front_1_1.nc');

xCoords = squeeze(ncread('buoyancy_front_1_1.nc', 'xC'));
zCoords = squeeze(ncread('buoyancy_front_1_1.nc', 'zC'));
Temp = squeeze(ncread('buoyancy_front_1_1.nc', 'T'));
Salinity = squeeze(ncread('buoyancy_front_1_1.nc','S'));


[x, z] = meshgrid(xCoords, zCoords);

Temp1 = Temp(:,:,1);

figure
contourf(x,z,(Temp1)');
contourcbar