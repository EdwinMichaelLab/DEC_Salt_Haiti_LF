x=[2013 2014 2015 2016 2017 2018];
v=[3.38 4.27 0.94 0.97 1.01 0.58];
xq=[2019 2020 2021 2022 2023 2024 2025 2026 2027];
vq1=interp1(x,v,xq,'linear','extrap')

x=[2016 2017 2018];
v=[0.97 1.01 0.58];
xq=[2019 2020 2021 2022 2023 2024 2025 2026 2027];
vq1=interp1(x,v,xq,'linear','extrap')

x=[2015 2016 2017 2018];
v=[0.94 0.97 1.01 0.58];
xq=[2019 2020 2021 2022 2023 2024 2025 2026 2027];
vq1=interp1(x,v,xq,'pchip')

x=[2013 2014 2015 2016 2017 2018];
y=[200.0045 169.176 149.4445 140.81 143.2725 156.832];
z=[983.026 669.904 432.134 269.716 182.65 170.936];
a=[316.298 246.402 201.482 181.538 186.57 216.578];
b=[917.3103 660.7964 476.0133 342.9024 247.0142 177.9399];
p=[268.1564 227.9136 200.0216 184.4804 181.29 190.4504];
q=[992.782 764.868 579.658 437.152 337.35 280.252];
xi = linspace(min(x), max(x), 150);                     % Evenly-Spaced Interpolation Vector
yi = interp1(x, y, xi, 'spline', 'extrap');
zi = interp1(x, z, xi, 'spline', 'extrap');
ai = interp1(x, a, xi, 'spline', 'extrap');
bi = interp1(x, b, xi, 'spline', 'extrap');
pi = interp1(x, p, xi, 'spline', 'extrap');
qi = interp1(x, q, xi, 'spline', 'extrap');
subplot(1,3,1)
a2=plot(xi,zi,'k','LineWidth',2);
hold on;
a1=plot(xi,yi,'b','LineWidth',2);
hold on;

% xlabel('Years','FontSize',10);
 ylabel('US$','FontSize',10);
 title('Industrial Salt');
hold on;
subplot(1,3,2)
a4=plot(xi,bi,'k','LineWidth',2);
hold on;
a3=plot(xi,ai,'b','LineWidth',2);
hold on;
xlabel('Years','FontSize',10);
%  ylabel('US$','FontSize',10);
 title('Single-fortified Salt');
hold on;
subplot(1,3,3)
a6=plot(xi,qi,'k','LineWidth',2);
hold on;
a5=plot(xi,pi,'b','LineWidth',2);
hold on;
% xlabel('Years','FontSize',10);
%  ylabel('US$','FontSize',10);
 title('Double-fortified Salt');
