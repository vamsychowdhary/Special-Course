function [s,t_sweep,t_tot] = expsweep_gen(sig_len_secs,fb,fe,fs,Nfadein,Nfadeout,end_delay)
close all

% Total length of sweep in samples
N = sig_len_secs*fs;

% Number of samples for end delay
Nend = ceil(end_delay*N);

% Effective length of sweep in samples
Nsweep = N-Nend;

% Time vector and total duration of the sweep
t = (0:Nsweep-1).'/fs;
T = Nsweep/fs;

% Sweep calculation
a = 2*pi*fb;
b = log(fe/fb)/T;
phi = (a/b)*(exp(b*t)-1);
s = sin(phi);

% Reduce the ripples in the frequency response by fading in and out
tfadeIn = linspace(0,pi,Nfadein);
tfadeOut = linspace(0,pi,Nfadeout);
w1 = 1-((1+cos(tfadeIn))/2);
w2 = (1+cos(tfadeOut))/2;
w = [w1(:); ones(Nsweep-Nfadein-Nfadeout,1); w2(:)]; % complete window

% Window and pad with zeros
s = [(w.*s)' zeros(1,Nend)];

t_tot = (0:N-1).'/fs;
t_sweep = t;

spectrogram(s,200,190,200,fs,'yaxis');
shading interp
end