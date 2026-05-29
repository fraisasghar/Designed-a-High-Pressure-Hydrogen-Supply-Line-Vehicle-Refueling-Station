%% Fluid Mechanics Project - Group A12 Visualizations
% Baseline: DN 300 mm, 50% H2 Blend
clear; clc; close all;
%% 1. Constants and Baseline Data
L = 50000;              % Pipeline length (m) [cite: 92]
D = 0.304;              % Internal Diameter (m) [cite: 104]
A = pi * D^2 / 4;       % Cross-sectional area (m^2) [cite: 106]
P1 = 50;                % Inlet pressure (bar) [cite: 92]
T1 = 298.15;            % Inlet temperature (K) [cite: 92]
m_dot = 0.2667;         % Total mass flow rate (kg/s) [cite: 92, 95]
eta_p = 0.75;           % Polytropic efficiency [cite: 164]
delta_P_base = 0.00946; % Baseline pressure drop (bar)
% Gas Properties Table (H2 mol%, R, k) [cite: 34]
h2_content = [0, 20, 30, 50, 100];
R_vals = [518, 570, 615, 780, 4124];
k_vals = [1.30, 1.315, 1.33, 1.36, 1.405];
figure('Color', 'w', 'Position', [100, 100, 1200, 400]);
%% GRAPH 1: Pipeline Pressure Profile
subplot(1,3,1);
dist = linspace(0, L/1000, 100); % Distance in km
pres = P1 - (delta_P_base * dist / (L/1000));
plot(dist, pres, 'b', 'LineWidth', 2);
xlabel('Distance (km)'); ylabel('Pressure (bar)');
title('12.1 Pipeline Pressure Profile');
grid on; ylim([49.98, 50.02]); % Zoomed to see the minor drop
hold on; plot(0, P1, 'ro', 50, pres(end), 'ro');
text(2, 50.005, 'Inlet: 50 bar');
text(30, 49.995, 'Outlet: 49.991 bar');
%% GRAPH 2: Effect of Gas Blend on Velocity
subplot(1,3,2);
h2_range = linspace(0, 100, 100);
R_interp = interp1(h2_content, R_vals, h2_range, 'pchip');
% rho = P / (RT) [cite: 117], v = m_dot / (rho * A) [cite: 124]
rho_range = (P1 * 1e5) ./ (R_interp * T1);
v_range = m_dot ./ (rho_range * A);
plot(h2_range, v_range, 'g', 'LineWidth', 2);
xlabel('H_2 Concentration (mol%)'); ylabel('Velocity (m/s)');
title('12.2 Velocity vs. Gas Blend');
grid on; hold on;
% Mark baseline (50%) and Future (100%)
v_50 = m_dot / (((P1*1e5)/(780*T1)) * A);
v_100 = m_dot / (((P1*1e5)/(4124*T1)) * A);
plot(50, v_50, 'ks', 100, v_100, 'ks');
text(40, v_50+0.1, 'Baseline (0.17 m/s)');
text(60, v_100-0.1, '100% H2 (1.11 m/s)');
%% GRAPH 3: Compressor Specific Work
subplot(1,3,3);
P2_range = linspace(50, 1000, 100);
R_base = 780; k_base = 1.36; % For 50% blend [cite: 97]
% Polytropic work formula
w = (k_base/(k_base-1)) * R_base * T1 * ((P2_range/P1).^((k_base-1)/k_base) - 1) / eta_p;
plot(P2_range, w/1000, 'r', 'LineWidth', 2); % kJ/kg
xlabel('Outlet Pressure (bar)'); ylabel('Specific Work (kJ/kg)');
title('12.3 Compression Energy Requirement');
grid on; hold on;
% Mark target 850 bar [cite: 164]
w_850 = (k_base/(k_base-1)) * R_base * T1 * ((850/P1)^((k_base-1)/k_base) - 1) / eta_p;
plot(850, w_850/1000, 'ko');
text(400, w_850/1000 + 100, ['Target 850 bar: ', num233(w_850/1000,4), ' kJ/kg']);
sgtitle('Fluid Mechanics Project: Group A12 System Analysis');