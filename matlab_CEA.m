clear
close all
clc

% Chamber parameters
eps  = 100;      % expansion ratio
OF = 15;
Pvec = 2:10:206.4; % bar





names = find_names(max(Pvec), OF, eps);

fractions = zeros(length(names), 3, length(Pvec)); %prendo solo le frazioni all'uscita
isp = zeros(length(Pvec), 1);
cst = zeros(length(Pvec), 1);
cT  = zeros(length(Pvec), 1);
T   = zeros(length(Pvec), 3);

for ii = 1:length(Pvec)
    P = Pvec(ii);
    x = callCEA(P, OF, eps);
    if length(x.output.eql.fractions(:, 3)) < length(names)
        this_nms = x.output.eql.products;
        indx = ismember(names, this_nms);
        fractions(indx, :, ii) = x.output.eql.fractions(:, :);
    elseif length(x.output.eql.fractions(:, 3)) == length(names)
        fractions(:, :, ii) = x.output.eql.fractions(:, :);
    else
        error('initial dissociation names is not wide enough')
    end
    isp(ii)  = x.output.eql.isp(end);
    cst(ii)  = x.output.eql.cstar(end);
    cT (ii)  = x.output.eql.cf(end);
    T(ii, :) = x.output.eql.temperature;
end

fprintf("Species found: \n")
disp(names)

pos = ["injector"; "throat"; "exit"];
for indx = 1:length(names)
    figure('Color',[1 1 1], 'Name', string(names(indx)) + '%')
    hold on
    for ii = 1:3
        plot(Pvec, squeeze(fractions(indx, ii, :)) * 100, 'DisplayName', 'Fraction at '+pos(ii));
    end
    xlabel('Pressure [bar]')
    ylabel('Fraction [%]')
    grid on
    legend
    title('Fraction of '+string(names(indx)) + ' in percentage')
end

figure('Color',[1 1 1], 'Name','Isp [s]')
plot(Pvec, isp)
xlabel('Pressure [bar]')
ylabel('Isp [s]')
grid on
title('Specific gravimetric impulse (best, shifting) [s]')

figure('Color',[1 1 1], 'Name','c^*')
plot(Pvec, cst)
xlabel('Pressure [bar]')
ylabel('c^* [m/s]')
grid on
title('Characteristic speed = $\frac{P_c\cdot A_t}{\dot{m}}$', 'Interpreter','latex')

figure('Color',[1 1 1], 'Name','cT')
plot(Pvec, cT)
xlabel('Pressure [bar]')
ylabel('c_T [-]')
grid on
title('Thrust coefficient = $\frac{T}{P_c\cdot A_t}$', 'Interpreter','latex')

figure('Color',[1 1 1], 'Name', 'Temperature in the nozzle')
hold on
for ii = 1:3
    plot(Pvec, T(:, ii), 'DisplayName', 'At '+pos(ii))
end
xlabel('Pressure [bar]')
ylabel('Temperature [K]')
legend


clearvars this_nms indx ii pos P;



function names = find_names(Pmax, OF, eps)
    [x, ~] = callCEA(Pmax, OF, eps);
    names = x.output.eql.products;
end


function [x, t] = callCEA(P, OF, eps)
% calls NASA CEA for LOX/LH2 at standard temperatures, but with custom
% pressure, OF and expansion rateo (only supersonic)
[x,t] = CEA( ...
    'problem','rocket', ...
    'equilibrium', ...
    'o/f',OF, ...
    'p,bar',P, ...
    'supar',eps, ...
    'reactants', ...
    'fuel','H2(L)','wt%',100,'t(k)',20.17, ...
    'oxid','F2(L)','wt%',100,'t(k)',85.02, ...
    'output','mks', ...
    'end');
% 'fuel','H2(L)','wt%',100,'t(k)',20.17, ...
% 'oxid','O2(L)','wt%',100,'t(k)',90.18, ...
end