%% Artificial dispersive wave train
function R2 = Artificial_disp(R,dx,Fs,b)
Y = fft(R);
L = length(R);
f = Fs*(0:(L-1))/L;
Y1 = 2*Y(1:round(L/2));
Y2 = flip(Y1);
f1 = f(1:round(L/2));
% a= 2e-13;
% b=-4e-05;
a= 1.983e-13;
c= 5000;
% vpp = (a.*f1.^2+b.*f1.^1+c);
vpp = (b.*f1.^1+c);
% vpp = (3.*exp(-f1/60000000)+2).*1000;
sp = 1./vpp;
R2dft1 = Y1.*exp(-2.*1i.*pi.*f1.*sp.*dx);
R2dft = [R2dft1 flip(R2dft1)];
R2=real(ifft(R2dft1,length(R)));
end