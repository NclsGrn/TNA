%    firstOrderDSM.m
%    Implements a first order Sigma-Delta Modulator
%    Copyright 2007 Brian R Phelps
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see http://www.gnu.org/licenses/clear;

[x,fs,fmt]=auload('whatsup.wav');
x=x(2000:10000);
NumSamps=2000;
OSR=10;         % The over sampling rate
NumSamps=length(x)
z1km1q = 0; % Initialize variables
z1km1 = 0;
% Scale the data to 16 bit "integers", hardware 
% in real life is integer or fixed point math
%returns scaled integers
x=round(x*32766);
for n=1:NumSamps
   z1(1)=z1km1;
   xn=x(n);
   for k=1:OSR  % Each sample is Oversampled OSR times
      % please see the diagram for an explanation for the following:
      z1(k) = z1km1;
      z1km1 = z1(k) + xn  - z1km1q;
      z1km1q = (z1km1 > 0) * 32766 - (z1km1 <= 0) * 32766;
      y(k+(n-1)*OSR) = (z1km1 > 0) - (z1km1 <= 0);
   end
end

b=fir1(121,1/(OSR*2));  % A low pass filter is also an integrator (summer), 
                        % either way it is neccessary to recover the original signal
y=filter(b,1,y);        % This gets rid of the noise, which 
                        % most of which is moved out of the passband
y=decimate(y,OSR);      % Keep only 1/10 samples to get the 
                        % sample rate back down to original
plot(1:length(y),y );
sound(y/3,fs);