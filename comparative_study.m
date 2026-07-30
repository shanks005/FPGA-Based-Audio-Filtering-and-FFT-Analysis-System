clc; clear;

%% Read audio_data.mem
fid = fopen('C:/Users/admin/Downloads/FPGA_MINI_PROF/audio_data.mem','r');
x_hex = textscan(fid, '%s');
fclose(fid);

x_hex = x_hex{1};
N_in = length(x_hex);

x_u16 = uint16(hex2dec(x_hex));
x_int16 = typecast(x_u16, 'int16');
x = double(x_int16);clc; clear;

%% Read audio_data.mem
fid = fopen('C:/Users/admin/Downloads/FPGA_MINI_PROF/audio_data.mem','r');
x_hex = textscan(fid, '%s');
fclose(fid);

x_hex = x_hex{1};
N_in = length(x_hex);

x_u16 = uint16(hex2dec(x_hex));
x_int16 = typecast(x_u16, 'int16');
x = double(x_int16);

Nfft = 1024;

x = x(1:Nfft);   % keep first 1024 samples
X = fft(x, Nfft);
X_mag = abs(X);

%% Read FPGA output CSV
data = readmatrix('C:/Users/admin/Downloads/FPGA_MINI_PROF/fft_debug_dump.csv');

capture_idx = data(:,1);
cycle       = data(:,2);
in_valid    = data(:,3);
sample_addr = data(:,4);
audio_sample= data(:,5);
Out1_re     = data(:,6);
Out1_im     = data(:,7);
Filt_re     = data(:,8);
Filt_im     = data(:,9);

Y_raw  = complex(Out1_re, Out1_im);
Y_filt = complex(Filt_re, Filt_im);

Y_raw_mag  = abs(Y_raw);
Y_filt_mag = abs(Y_filt);

figure;
subplot(3,1,1);
plot(Out1_re); grid on; title('Out1\_re');

subplot(3,1,2);
plot(Out1_im); grid on; title('Out1\_im');

subplot(3,1,3);
plot(Y_raw_mag); grid on; title('Raw FPGA FFT magnitude');

k0 = 2000;   % adjust after inspection

fpga_raw_mag  = Y_raw_mag(k0:k0+Nfft-1);
fpga_filt_mag = Y_filt_mag(k0:k0+Nfft-1);

bins = 0:Nfft-1;

figure;
plot(bins(1:Nfft/2), X_mag(1:Nfft/2), 'LineWidth', 1.2); hold on;
plot(bins(1:Nfft/2), fpga_raw_mag(1:Nfft/2), 'LineWidth', 1.2);
plot(bins(1:Nfft/2), fpga_filt_mag(1:Nfft/2), 'LineWidth', 1.2);
grid on;
xlabel('FFT Bin');
ylabel('Magnitude');
title('Input FFT vs FPGA Raw FFT vs FPGA Filtered FFT');
legend('MATLAB FFT of audio\_data.mem', 'FPGA Raw FFT', 'FPGA Filtered FFT');

X_mag_n        = X_mag / max(X_mag);
fpga_raw_mag_n = fpga_raw_mag / max(fpga_raw_mag);
fpga_filt_mag_n= fpga_filt_mag / max(fpga_filt_mag);

figure;
plot(bins(1:Nfft/2), X_mag_n(1:Nfft/2), 'LineWidth', 1.2); hold on;
plot(bins(1:Nfft/2), fpga_raw_mag_n(1:Nfft/2), 'LineWidth', 1.2);
plot(bins(1:Nfft/2), fpga_filt_mag_n(1:Nfft/2), 'LineWidth', 1.2);
grid on;
xlabel('FFT Bin');
ylabel('Normalized Magnitude');
title('Normalized Spectrum Comparison');
legend('MATLAB FFT of input', 'FPGA Raw FFT', 'FPGA Filtered FFT');
