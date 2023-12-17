% Declare the funtion to 
clear  
clear global  
clc    
close   
format compact  
warning off 

%
fprintf('\nOnes Sanjerico Sitanggang')
fprintf('\nM2022752')
fprintf('\nMid term Exam SLP\n')
% 

[y, Fs] = audioread('sound1.m4a')

% Additive White Gaussian Noise (AWGN)
SNR = 30; % Adjust the Signal-to-Noise Ratio (SNR) as needed
y_with_noise = awgn(y, SNR, 'measured');

max_value = max(y);
min_value = min(y);
l = 1;
x = [];
step_size = (max_value - min_value)/(12)
i = min_value;
while ((i>=min_value) & (i<=max_value))
    x = [x,i];
    i = i + step_size;
end
for i=1: length(y)
for j=1: (length(x)-1)
    if ((y(i) >= x(j)) && (y(i)<=x(j+1)))
    y1(i) = x(j+1);
    end
end
end
figure(1)
plot(y);
title('original audio signal');
figure(2);
plot(y1);
title('Quantized audio signal');
%%% performingthe QAM on the quantized signal

y2 = zeros(1,length(y1));
for i = 2:length(x)
for j = 1:length(y1)
if(x(i)==y1(j))
    y2(j) = i-2;
end
end
end
qam = qammod(y2,128, 'PlotConstellation',true);
%qam = qammod(y2,8, 'PlotConstellation',true);
%qam = qammod(y2,32, 'PlotConstellation',true);
%qam = qammod(y2,128, 'PlotConstellation',true);

figure(3)
plot(qam)
title('QAM Modulation Signal-QAM 128');
demodulated = qamdemod(qam,128)
%demodulated = qamdemod(qam,8)
%demodulated = qamdemod(qam,32)
%demodulated = qamdemod(qam,128)

figure(4)
plot(demodulated)
title('Demodulated Output');

%%%%%%%%%%%%%%%%%%%%% 
            %% kode TANPA NOISE 
            % Declare the function

%[y, Fs] = audioread('sound1.m4a');

        % Quantization
%max_value = max(y);
%min_value = min(y);
%x = min_value:(max_value - min_value) / 12:max_value;

%y1 = zeros(size(y));
%for i = 1:length(y)
%    for j = 1:(length(x) - 1)
%        if (y(i) >= x(j)) && (y(i) <= x(j + 1))
%            y1(i) = x(j + 1);
%        end
%    end
%end

        % QAM Modulation
%y2 = zeros(1, length(y1));
%for i = 2:length(x)
%    for j = 1:length(y1)
%        if x(i) == y1(j)
%            y2(j) = i - 2;
%        end
%    end
%end

%qam = qammod(y2, 128, 'PlotConstellation', true);
        % Plotting QAM Modulated Signal
%figure;
%subplot(2, 1, 1);
%plot(qam);
%title('QAM Modulation Signal-QAM 128');
        % QAM Demodulation
%demodulated = qamdemod(qam, 128);
%subplot(2, 1, 2);
%plot(demodulated);
%title('Demodulated Output-QAM 128');



