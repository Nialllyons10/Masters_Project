clc
%close all
clear all
N=31; %Period of the sequence N=2ˆL-1
threshold = 0.001:0.001:1.1; % Pf = Probability of False Alarm
errorProbs = 0.4;
ref_poly = [1 0 1 0 0 1]; %X^5 + x^3 + 1 will be coded as 1 0 1 0 0 1
ref_init = [0 0 0 0 1];
ref_lfsr = lfsr(ref_poly,ref_init);
n_packets = 100000;
total_false_alarm = zeros(size(threshold));

test_case = {'ref,ref', 'ref,diff','diff,diff'};

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

            x = flip_bits(s,errorProbs); %process the bits through flipping (Gaussian noise and Multipath Chanell)
            Rxy = 1/(2*N)*sequence_correlation(x,ref_lfsr,0,0); 
            total_false_alarm(current_case,:) = total_false_alarm(current_case,:) + (Rxy >= threshold); %threshold based on where you want to be on NP curve
    
    end
    
end

total_false_alarm = total_false_alarm/n_packets;

%% Develop Plots
figure("Name", ['Error Probability ',num2str(errorProbs)])
plot(threshold, total_false_alarm,'linewidth',2)
grid on
hold on
xlabel('Threshold')
ylabel('Probability of Detection')
title(['Error Probability ',num2str(errorProbs)])
legend('Ref Ref', 'Ref Diff', 'Diff Diff');

figure(2)
loglog(1-total_false_alarm(1,:), max(total_false_alarm(2:3,:),[],1))
hold on
grid on
xlabel('False Alarm')
ylabel('Missed Detection')