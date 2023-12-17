% Declare the function
clear  
clear global  
clc    
close   
format compact  
warning off 

fprintf('\nOnes Sanjerico Sitanggang')
fprintf('\nM2022752')
fprintf('\nMid term Exam SLP\n')

[y, Fs] = audioread('sound1.m4a');

% Additive White Gaussian Noise (AWGN)
SNR_values = [-7, 30]; % SNR values to analyze
figure;

for k = 1:length(SNR_values)
    SNR = SNR_values(k);
    y_with_noise = awgn(y, SNR, 'measured');

    max_value = max(y_with_noise);
    min_value = min(y_with_noise);

    l = 1;
    x = [];
    step_size = (max_value - min_value)/(12);
    i = min_value;
    while ((i >= min_value) & (i <= max_value))
        x = [x, i];
        i = i + step_size;
    end

    y1 = zeros(size(y));
    for i = 1:length(y)
        for j = 1:(length(x)-1)
            if ((y_with_noise(i) >= x(j)) && (y_with_noise(i) <= x(j+1)))
                y1(i) = x(j+1);
            end
        end
    end
    
    % Plot original and quantized signals
    figure(1);
    
    % Original Audio Signal
    subplot(length(SNR_values), 2, 2*(k-1) + 1);
    plot(y);
    title('Original Audio Signal');
    
    % Quantized Audio Signal without SNR
    subplot(length(SNR_values), 2, 2*(k-1) + 2);
    plot(y1);
    title('Quantized Audio Signal without SNR');
    
    % Quantized Audio Signal with SNR
    subplot(length(SNR_values), 2, 2*k);
    plot(y1);
    title(['Quantized Audio Signal (SNR = ' num2str(SNR) ' dB)']);


    % QAM Modulation
    y2 = zeros(1, length(y1));
    for i = 2:length(x)
        for j = 1:length(y1)
            if(x(i) == y1(j))
                y2(j) = i-2;
            end
        end
    end
    qam = qammod(y2, 64);
    figure(2);
    subplot(length(SNR_values), 4, 4*(k-1) + 1);
    plot(qam);
    title(['QAM Modulation Signal (SNR = ' num2str(SNR) ' dB)']);

    demodulated = qamdemod(qam, 64);
    subplot(length(SNR_values), 4, 4*(k-1) + 2);
    plot(demodulated);
    title(['Demodulated Output using QAM (SNR = ' num2str(SNR) ' dB)']);

    % OOK Modulation
    threshold = (max_value + min_value) / 2;
    OOK_signal = zeros(1, length(y1));
    for i = 1:length(y1)
        if y1(i) >= threshold
            OOK_signal(i) = 1;
        else
            OOK_signal(i) = 0;
        end
    end

    OOK_demodulated = zeros(size(OOK_signal));
    for i = 1:length(OOK_signal)
        if OOK_signal(i) == 1
            OOK_demodulated(i) = max_value;
        else
            OOK_demodulated(i) = min_value;
        end
    end

    subplot(length(SNR_values), 4, 4*(k-1) + 3);
    plot(OOK_demodulated);
    title(['Demodulated Output using OOK (SNR = ' num2str(SNR) ' dB)']);

    % PPM Modulation
    PPM_signal = zeros(1, length(y1));
    ppm_pulse_width = 0.5;

    for i = 1:length(y1)
        pulse_position = round((y1(i) - min_value) / (max_value - min_value) * (length(PPM_signal) - 1)) + 1;
        PPM_signal(pulse_position) = 1;
    end

    PPM_demodulated = zeros(size(PPM_signal));
    for i = 1:length(PPM_signal)
        if PPM_signal(i) == 1
            detected_pulse_position = i;
            demodulated_value = min_value + (detected_pulse_position - 1) / (length(PPM_signal) - 1) * (max_value - min_value);
            PPM_demodulated(i) = demodulated_value;
        end
    end

    subplot(length(SNR_values), 4, 4*k);
    plot(PPM_demodulated);
    title(['Demodulated Output using PPM (SNR = ' num2str(SNR) ' dB)']);
end
