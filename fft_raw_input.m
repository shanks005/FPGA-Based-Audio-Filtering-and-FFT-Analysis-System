clc; clear; close all;

%% Parameters
csvFile = 'C:/Users/admin/Downloads/FPGA_MINI_PROF/fft_debug_dump.csv';
Nfft = 1024;
threshold = 1;   % adjust if needed

%% Read CSV
data = readmatrix(csvFile);

Raw_re  = data(:,6);
Raw_im  = data(:,7);
Filt_re = data(:,8);
Filt_im = data(:,9);

raw_mag_all  = sqrt(double(Raw_re).^2  + double(Raw_im).^2);
filt_mag_all = sqrt(double(Filt_re).^2 + double(Filt_im).^2);

%% Find nonzero / meaningful filtered region
idx = find(filt_mag_all > threshold);

if isempty(idx)
    error('No nonzero filtered FFT window found.');
end

k0 = idx(1);   % first meaningful point

% make sure enough points remain
if k0 + Nfft - 1 > length(Filt_re)
    error('Not enough samples after detected window start. Choose another k0.');
end

%% Extract one 1024-point complex FFT frame
Y_filt = complex(Filt_re(k0:k0+Nfft-1), Filt_im(k0:k0+Nfft-1));
Y_raw  = complex(Raw_re(k0:k0+Nfft-1),  Raw_im(k0:k0+Nfft-1));

%% IFFT
y_filt = ifft(Y_filt, Nfft);
y_raw  = ifft(Y_raw, Nfft);

y_filt_real = real(y_filt);
y_raw_real  = real(y_raw);

%% Normalize for viewing / listening
y_filt_norm = y_filt_real / (max(abs(y_filt_real)) + eps);
y_raw_norm  = y_raw_real  / (max(abs(y_raw_real))  + eps);

%% Plot captured spectrum region
figure;
subplot(2,1,1);
plot(raw_mag_all);
hold on;
xline(k0, '--r', 'Start Window');
grid on;
title('Raw FFT Magnitude (All Captured Samples)');

subplot(2,1,2);
plot(filt_mag_all);
hold on;
xline(k0, '--r', 'Start Window');
grid on;
title('Filtered FFT Magnitude (All Captured Samples)');

%% Plot selected FFT frame magnitudes
figure;
plot(abs(Y_raw(1:Nfft/2)), 'LineWidth', 1.2); hold on;
plot(abs(Y_filt(1:Nfft/2)), 'LineWidth', 1.2);
grid on;
xlabel('FFT Bin');
ylabel('Magnitude');
title('Selected 1024-point FFT Window');
legend('Raw FFT Window', 'Filtered FFT Window');

%% Plot reconstructed time-domain signals
figure;
subplot(2,1,1);
plot(y_raw_norm, 'LineWidth', 1.2);
grid on;
xlabel('Sample Index');
ylabel('Amplitude');
title('Reconstructed Raw Audio from Selected FFT Window');

subplot(2,1,2);
plot(y_filt_norm, 'LineWidth', 1.2);
grid on;
xlabel('Sample Index');
ylabel('Amplitude');
title('Reconstructed Filtered Audio from Selected FFT Window');

%% Optional playback
Fs = 8192;   % your sample rate
sound(y_filt_norm, Fs);

%% Optional save
audiowrite('filtered_reconstructed.wav', y_filt_norm, Fs);