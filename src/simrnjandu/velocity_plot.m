figure
p = plot(vmag);
title(["Maximum Velocity (magnitude) achieved for different Temperature Gradients"]);
%subtitle(strcat("Time = ",sprintf('%.3f',(time(k)/86400)), " days"));
xlabel("Decreasing Temperature Gradient");
%ylim([-500 -200]);
ylabel("Velocity (magnitude) (m/s)");
p.XAxis.TickLength([0 0]);
%cb = contourcbar;
%cb.XLabel.String = "Temperature (°C)";
saveas(gcf,['velocity.png']);