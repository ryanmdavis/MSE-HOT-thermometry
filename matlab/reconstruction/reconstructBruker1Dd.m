%inpt is full path to file, including the name of the file, not just
%directory
function varargout = reconstructBruker1Dd(file)

%for systems using the big endian convention
fid=fopen(file,'r','b'); %opens the data file
rawbuf=fread(fid,inf,'int32');  %reads data as a single line

%reshapes the data in real and imaginary data
fidcom=zeros(1,size(rawbuf,1)/2*8);
fidcom(1:size(rawbuf,1)/2)=permute(rawbuf(1:2:end)+1i*rawbuf(2:2:end),[2 1]);

%Fourier Transform of combined data
spect = fftshift(fft2(fidcom));

varargout{1} = spect;
if nargout >= 2
    varargout{2} = fidcom;
end
if nargout ==3
    varargout{3} = spect;
end