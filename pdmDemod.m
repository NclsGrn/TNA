%clear all;
close all;
load ("pdm_in.mat");
%DEMODULATION%
% sous-Ã©chantillonnage, filtrage, rÃ©-Ã©chantillonage% 

%Variables globales%
n = 16;
N = 128;
f_e = 6144000;

%% DEMOD AVEC FIR %%
% ETAPE 1 : Filtre %
%load("FIR_Num16.mat");
%y = filter(Num16, 1, in);

% ETAPE 2 : SOUS ECHANTILLONNAGE 16 %
%y_d = downsample(y, 16);
%y_d = y(1:16:end);

% ETAPE 3 : FILTRAGE %
%f_e1 = f_e/16;
%load("FIR_Num8.mat");
%y1 = filter(Num8, 1, y_d);

% ETAPE  4 : SOUS ECHANTILLONNAGE 8                                          
%y1_d = downsample(y1, 8);
%y1_d = y1(1:8:end);

%sound(y1_d);

% PLOTS %
%[h,w] = freqz(Num16,1);
%[h1,w1] = freqz(Num8,1);

% Entrée
%figure(1)
%subplot(211)
%stem(in(1:500))
%title("Signal d'entrée")

% Spectre entrée
%subplot(212)
%plot(linspace(0, 1, length(in)), abs(fft(in)));
%grid on;
%xlabel("\nu");
%ylabel('in[\nu]');
%title("Representation fréquentielle : module de l'entrée[\nu]");

% Filtres
%figure(2)
%subplot(121)
%plot((w/(2*pi))*(6144000), 20*log10(abs(h)))
%xlabel('Frequency (Hz)')
%ylabel('Magnitude (dB)')
%title("Filtre FIR avant échantillonnage par 16")

%subplot(122)
%plot((w1/(2*pi))*(6144000/16), 20*log10(abs(h1)))
%xlabel('Frequency (Hz)')
%ylabel('Magnitude (dB)')
%title("Filtre FIR avant échantillonnage par 8")

% Signal dÃ©modulÃ©
%figure(3)
%subplot(211)
%stem(y_d(1:500))
%title("Signal démodulé après sous échantillonnage par 16")

% Spectre du signal dÃ©modulÃ©
%subplot(212)
%plot(linspace(0, 1, length(y_d)), abs(fft(y_d)));
%grid on;
%xlabel("\nu");
%ylabel('signal_16[\nu]');
%title('Representation frequentielle : module de signal16[\nu]');


% Signal dÃ©modulÃ©
%figure(4)
%subplot(211)
%stem(y1_d(1:500))
%title("Signal démodulé après sous échantillonnage par 8")

% Spectre du signal dÃ©modulÃ©
%subplot(212)
%plot(linspace(0, 1, length(y1_d)), abs(fft(y1_d)));
%grid on;
%xlabel("\nu");
%ylabel('signal_8[\nu]');
%title('Representation fréquentielle : module de signal8[\nu]');


%% DEMOD AVEC IIR %%
% ETAPE 1 : Filtre %
load("IIR_ell_16.mat");
y = filter(G16, 1, in);

% ETAPE 2 : SOUS ECHANTILLONNAGE 16 %
y_d = y(1:16:end);

% ETAPE 3 : FILTRAGE %
f_e1 = f_e/16;
load("IIR_ell_8.mat");
y1 = filter(G8, 1, y_d);

% ETAPE  4 : SOUS ECHANTILLONNAGE 8                                          
out_pdm = y1(1:8:end);

%sound(y1_d);

% PLOTS %
[h,w] = freqz(Num16,1);
[h1,w1] = freqz(Num8,1);

% Entrée
figure(1)
subplot(211)
stem(in(1:500))
title("Signal d'entrée")

% Spectre entrée
subplot(212)
plot(linspace(0, 1, length(in)), abs(fft(in)));
grid on;
xlabel("\nu");
ylabel('in[\nu]');
title("Representation fréquentielle : module de l'entrée[\nu]");

% Filtres
figure(2)
subplot(121)
plot((w/(2*pi))*(6144000), 20*log10(abs(h)))
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title("Filtre IIR avant échantillonnage par 16")

subplot(122)
plot((w1/(2*pi))*(6144000/16), 20*log10(abs(h1)))
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title("Filtre IIR avant échantillonnage par 8")

% Signal dÃ©modulÃ©
figure(3)
subplot(211)
stem(y_d(1:500))
title("Signal démodulé après sous échantillonnage par 16")

% Spectre du signal dÃ©modulÃ©
subplot(212)
plot(linspace(0, 1, length(y_d)), abs(fft(y_d)));
grid on;
xlabel("\nu");
ylabel('signal_16[\nu]');
title('Representation frequentielle : module de signal16[\nu]');


% Signal dÃ©modulÃ©
figure(4)
subplot(211)
stem(y1_d(1:500))
title("Signal démodulé après sous échantillonnage par 8")

% Spectre du signal dÃ©modulÃ©
subplot(212)
plot(linspace(0, 1, length(y1_d)), abs(fft(y1_d)));
grid on;
xlabel("\nu");
ylabel('signal_8[\nu]');
title('Representation fréquentielle : module de signal8[\nu]');


%% Stage 2 :Sample rate converter
% We found a value of 160/147 upsample/dwonsample rate and divided it 
% In factor so that we could use polyphase filter generation
% We use filterdesign entering interpolation value and decimation value to
% have get the filter function 
%

%Upsampling  values of the signal

load("H1_file.mat");
load("H2_file.mat");
load("H3_file.mat");
load("pcm_48k.mat");
index=1:30000;
%First stage of polyphase filtering, 7/4
tic
pcm_d1=pcm_48(1:7:end);%downsampling by 7
out_filt=filter(H1,1,pcm_d1);%applying filter at 6.3 kHz
pcm_out_1=upsample(out_filt,4);%output at 25.2 kHz
%Second stage of polyphase filtering 7/4
pcm_d2=pcm_out_1(1:7:end);
out_filt2=filter(H2,1,pcm_d2);
pcm_out_2=upsample(out_filt2,4);
%Third stage of polyphase filtering 3/2
pcm_d3=pcm_out_2(1:3:end);
out_filt3=filter(H3,1,pcm_d3);
pcm_out_3=upsample(out_filt3,2);
toc

%Last upsampling stage
pcm_out=upsample(pcm_out_3,5);

%preparing plot
abscisse_pd1=(1:length(pcm_d1));
abscisse_po1=(1:length(pcm_out_1));
abscisse_pd2=(1:length(pcm_d2));
abscisse_po2=(1:length(pcm_out_2));
abscisse_pd3=(1:length(pcm_d3));
abscisse_po3=(1:length(pcm_out_3));
abscisse_out=(1:length(pcm_out));



%Let's plot
figure;
subplot(211)
stem(abscisse_pd1,pcm_d1);
subplot(212)
stem(abscisse_po1,pcm_out_1);

figure;
subplot(211)
stem(abscisse_pd2,pcm_d2);
subplot(212)
stem(abscisse_po2,pcm_out_2);

figure;
subplot(211)
stem(abscisse_pd3,pcm_d3);
subplot(212)
stem(abscisse_po3,pcm_out_3);

figure;
stem(abscisse_out,pcm_out);
% hold on
% stem(abscisse_po1(1:index),pcm_out_1(1:index));
% hold off


