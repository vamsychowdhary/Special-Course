function H_inv = getInverse(x)
y = fft(x);
H_inv = 1./y;
end