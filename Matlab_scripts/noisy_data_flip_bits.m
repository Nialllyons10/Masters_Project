clc
close all
clear all
N=31; %Period of the sequence N=2ˆL-1
snr_dB = 10; % SNR in decibels
snr = 10.^(snr_dB./10); % Linear Value of SNR
threshold = 0.001:0.001:1.1; % Pf = Probability of False Alarm
errorProbs = 0.20;
ref_poly = [1 0 1 0 0 1]; %X^5 + x^3 + 1 will be coded as 1 0 1 0 0 1
ref_init = [0 0 0 0 1];
ref_lfsr = lfsr(ref_poly,ref_init);
n_packets = 100000;
total_false_alarm = zeros(size(threshold));

%test_case = {'ref,ref'};
%test_case = {'ref,diff'};
%test_case = {'diff,diff'};
test_case = {'ref,ref','ref,diff','diff,diff'};
noise_ref_ref_data = [];
noise_ref_diff_data = [];
noise_dif_diff_data = [];
noisey_data = [];

%% Simulation to plot Probability of Detection (Pd) vs. Probability of False Alarm (Pf)
total_false_alarm = NaN(length(test_case),length(threshold));
for current_case=1:length(test_case)
    total_false_alarm(current_case,:) = 0;
    t_case = test_case{current_case};
    for kk=1:n_packets
  
            current_poly = double(rand(size(ref_poly)) > 0.5);
            current_poly(end) = 1;
            while isequal(current_poly, ref_poly)
                current_poly = double(rand(size(ref_poly)) > 0.5);
                current_poly(end) = 1;
            end
            
            current_init = double(rand(size(ref_init)) > 0.5);
            while isequal(current_init, ref_init)
                current_init = double(rand(size(ref_init)) > 0.5);
            end 
            
            s = getCase(t_case, current_init, current_poly,ref_poly, ref_init);
            x = flip_bits(s,errorProbs);
            
            noisey_data = [noisey_data ; x];
            disp(kk)
    
    end
    
end

