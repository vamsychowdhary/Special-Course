% Sweep generation
sig_len_secs = 2;  % Length of the sweep in seconds
fb = 20;           % Start frequency
fe = 20000;        % End frequency
fs = 44100;        % Sampling frequency
Nfadein = 4000;    % Number of input samples to fade
Nfadeout = 1000;   % Number of output samples to fade
end_delay = 0.2;   % End delay for the recording
[x,t_sweep,t_tot] = expsweep_gen(sig_len_secs,fb,fe,fs,Nfadein,Nfadeout,end_delay);

% Create a data acquisition session
d = daq.getDevices;
s = daq.createSession('directsound');

% Add channels specified by subsystem type and device
s.addAudioOutputChannel('Audio0','1');
s.addAudioInputChannel('Audio0','2');
s.addAudioInputChannel('Audio0','3');
s.addAudioInputChannel('Audio0','4');
s.addAudioInputChannel('Audio0','5');

% Queue the data
queueOutputData(s,x);

disp('Press ENTER to start measurements')
pause
disp('Measuring')

% Measures and retrieves the data
[data,timeStamps]=s.startForeground;

disp('Measurement completed');

% Write the data to a mat file
% Pass the measurement number to the program
filename = 'meas_data_' + num2str(meas_seq);
save(filename,data,timeStamps,x,t_sweep,t_tot,fb,fe,fs,end_delay)

% Now plot the data to verify
X_inv = getInverse(x);
N = size(data,1);
t = 0:1/fs:(N-1)/fs;
for i = 1:size(data,2)
    Y = fft(data(:,i));
    H = Y'.*X_inv;
    h = ifft(H);
    figure
    plot(t,h)
end