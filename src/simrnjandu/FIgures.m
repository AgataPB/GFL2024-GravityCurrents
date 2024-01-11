clear
clc

%ncdisp('buoyancy_front_1_1.nc');

for i = 1:3
    xCoords = squeeze(ncread(['buoyancy_front_' num2str(i) '_1.nc'], 'xC'));
    zCoords = squeeze(ncread(['buoyancy_front_' num2str(i) '_1.nc'], 'zC'));
    time = squeeze(ncread(['buoyancy_front_' num2str(i) '_1.nc'], 'time'));
    [x, z] = meshgrid(xCoords, zCoords);

    for j = 1:1
    Temp = squeeze(ncread(['buoyancy_front_' num2str(i) '_' num2str(j) '.nc'], 'T'));

        for k = 1:size(time,1)
            fg = figure(Visible="off");
            contourf(x,z,(Temp(:,:,k))');
            pbaspect([8 1 1]);
            title(["Temperature (°C) at FPlane = 45°"]);
            subtitle(strcat("Time = ",sprintf('%.3f',(time(k)/86400)), " days"));
            xlabel("x (m)");
            ylabel("y (m)");
            cb = contourcbar;
            cb.XLabel.String = "Temperature (°C)";
            cb.LimitsMode = "manual";
            cb.Limits = [8.95 9.05];
            cb.TickLabelsMode = "manual";
            cb.Ticks = [8.95 9.00 9.05];
            
            axes = fg.Children(2);

            axes.XLimMode = "manual";
            axes.YLimMode = "manual";
            axes.XLim = [0 10000];
            axes.YLim = [-500 0];
            axes.FontSize = 8;
            saveas(gcf,['fig' num2str(i) '_' num2str(j) '_' num2str(k) '.png']);
            close;
        end
    end
end