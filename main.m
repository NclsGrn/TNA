%%Realising tp matlab of audio treatment chain
%We need to realise a high-pass filter to enable us to cut the noise in 
%low frequence. 
n=8;
under_samp=downsample(in,3);
%creating normalised frequency
f_n=6144000/6;
fc= 3200;
b=fir1(n,fc/f_n,'low');
y=filter(b,1,in);


[spect,w]=freqz(b,1,2500);
figure(1);
plot(w/(2*pi),20*log(abs(spect)));
%hold on
%plot(y);
%hold off

