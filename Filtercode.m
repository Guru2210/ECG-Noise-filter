ecg_file=fopen('100.dat','r');
time=10;  % ecg signal duration
Fs = 150; %sampling frequency
get_ecg=fread(ecg_file,2*Fs*time,'ubit12');
signal_length = length(get_ecg(1:2:length(get_ecg))); %signal length
step_time = 1/Fs; 
final_time = signal_length/Fs; % duration of signal 
t = step_time:step_time:final_time;  % time vector.
original_ecg=get_ecg(1:2:length(get_ecg))/signal_length; %compute the clean ecg signal
figure;
plot(t,original_ecg)
xlabel('Time(s)')
ylabel('Amplitude')
power_noise_coefficent = 0.02;    % cofficent of the noise added with ecg
power_noise = 5*sin(2*pi*50*t);      %50Hz noise from power supply
power_noise = power_noise';           %transpose vector
corrupted_signal = original_ecg + power_noise_coefficent*power_noise;  % adding original ecg signal with the noisy 50 Hz power signal
figure;
plot(t,power_noise);
xlabel('Time(s)')
ylabel('Amplitude')
figure;
plot(t,corrupted_signal);
corrupted_fft = fft(corrupted_signal);  %fft of the noisy signal
corrupted_fft_abs = abs(corrupted_fft); %magnitude and normalize the spectrum
frequency_fft = linspace(0,Fs,length(corrupted_signal)); %scale the frequency axis 
figure;
plot(frequency_fft,corrupted_fft_abs);
xlabel('Frequency(Hz)')
ylabel('Magnitude')
filtered_signal=filter(filter_design,corrupted_signal); % filtering the ecg signal
figure;
plot(t,corrupted_signal) % plotting corrupted ecg signal;
xlabel('Time(s)')
ylabel('Amplitude')
clear_fft = fft(filtered_signal);  %fft of the noisy signal
clear_fft_abs = abs(clear_fft); %magnitude and normalize the spectrum
frequency_fft_clear = linspace(0,Fs,length(clear_fft)); %scale the frequency axis 
figure;
plot(frequency_fft_clear,clear_fft_abs);
xlabel('Frequency(Hz)')
ylabel('Magnitude')
figure;
plot(t,filtered_signal) % plots the filtered ecg signal;
figure;
%periodogram(corrupted_signal);
periodogram(corrupted_signal,[],length(corrupted_signal),Fs)
xlabel('Frequency(Hz)')
ylabel('Magnitude')
figure;
%periodogram(filtered_signal);
periodogram(filtered_signal,[],length(filtered_signal),Fs)
xlabel('Frequency(Hz)')
ylabel('Magnitude')