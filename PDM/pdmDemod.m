%clear all;
close all;
load ("pdm_in.mat");
%DEMODULATION%
% sous-échantillonnage, filtrage, ré-échantillonage% 

%Variables globales%
n = 16;
N = 128;
f_e = 6144000;

%% DEMOD EN 2 BLOCS %%
% ETAPE 1 : Filtre %
load("FIR_Num16.mat");
y = filter(Num16, 1, in);

% ETAPE 2 : SOUS ECHANTILLONNAGE 16 %
%y_d = downsample(y, 16);
y_d = y(1:16:end);

% ETAPE 3 : FILTRAGE %
f_e1 = f_e/16;
load("FIR_Num8.mat");
y1 = filter(Num8, 1, y_d);

% ETAPE  4 : SOUS ECHANTILLONNAGE 8                                          
%y1_d = downsample(y1, 8);
y1_d = y1(1:8:end);

sound(y1_d);

% PLOTS %
[h,w] = freqz(Num16,1);
[h1,w1] = freqz(Num8,1);

% Entr�e
figure(1)
subplot(211)
stem(in(1:500))
title("Signal d'entr�e")

% Spectre entr�e
subplot(212)
plot(linspace(0, 1, length(in)), abs(fft(in)));
grid on;
xlabel("\nu");
ylabel('in[\nu]');
title("Representation fr�quentielle : module de l'entr�e[\nu]");

% Filtres
figure(2)
subplot(121)
plot((w/(2*pi))*(6144000), 20*log10(abs(h)))
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title("Filtre FIR avant �chantillonnage par 16")

subplot(122)
plot((w1/(2*pi))*(6144000/16), 20*log10(abs(h1)))
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title("Filtre FIR avant �chantillonnage par 8")

% Signal démodulé
figure(3)
subplot(211)
stem(y_d(1:500))
title("Signal d�modul� apr�s sous �chantillonnage par 16")

% Spectre du signal démodulé
subplot(212)
plot(linspace(0, 1, length(y_d)), abs(fft(y_d)));
grid on;
xlabel("\nu");
ylabel('signal_16[\nu]');
title('Representation frequentielle : module de signal16[\nu]');


% Signal démodulé
figure(4)
subplot(211)
stem(y1_d(1:500))
title("Signal d�modul� apr�s sous �chantillonnage par 8")

% Spectre du signal démodulé
subplot(212)
plot(linspace(0, 1, length(y1_d)), abs(fft(y1_d)));
grid on;
xlabel("\nu");
ylabel('signal_8[\nu]');
title('Representation fr�quentielle : module de signal8[\nu]');


%% DEMOD EN 4 BLOCS %%

% 1 

