clear all;
% close all;
% load ("pdm_in.mat");
% %DEMODULATION%
% % sous-échantillonnage, filtrage, ré-échantillonage% 
% 
% %Variables globales%
% n = 16;
% N = 128;
% f_e = 6144000;
% 
% % ETAPE 1 : Filtre %
% %load("Fir_coefficient.mat");
% y = filter(Num, 1, in);
% 
% % ETAPE 2 : SOUS ECHANTILLONNAGE 16 %
% y_d = y(1:16:end);
% 
% % ETAPE 3 : FILTRAGE %
% f_e1 = f_e/16;
% %load("Fir1_coefficient.mat");
% y1 = filter(Num1, 1, in);
% 
% % ETAPE  4 : SOUS ECHANTILLONNAGE 8%
% y1_d = y1(1:16:end);
% 
% 
% figure(1)
% plot(in);
% hold on
% plot(y);
% hold off
% 
% figure(2)
% subplot(1, 2, 1)
% plot(in);
% subplot(1, 2, 2)
% plot(y);
%sound(y);

% ETAPE 3 : RE ECHANTILLONNER %


%%% Stage 2 :Sample rate converter
%% We found a value of 160/147 upsample/dwonsample rate and divided it 
%% In factor so that we could use polyphase filter generation
%% We use filterdesign entering interpolation value and decimation value to
%% have get the filter function 
%%

%Upsampling  values of the signal
load("filter_poly_stg1.mat");
load("pcm_48k.mat");
pcm_up=upsample(pcm_48,4);
output_poly1=filter(Num,1,pcm_up);
%Decimating by seven for the first stage
pcm_down=output_poly1(1:7:end);




