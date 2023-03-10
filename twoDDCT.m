clear;
close all;
clc;


w = 256;
h = 256;
inbit = 9;


[lena8, map] = imread('lena_256.bmp');
lena = double(lena8);

%---------------------------------
% Input to chip lena8x8
%---------------------------------
fid = fopen('./lena.txt','w');
fid10 = fopen('lena10.txt','w');
for i = 1:h/8
    for j = 1:w/8
        lena8x8(:,:,(i-1)*(w/8)+j) = double(lena((i-1)*8+1:i*8,(j-1)*8+1:j*8));
        for m = 1:8
            for n = 1:8
                fprintf(fid, '%x\n', lena8x8(n,m,(i-1)*(w/8)+j));
                fprintf(fid10, '%d\n', lena8x8(n,m,(i-1)*(w/8)+j));
            end
        end
    end
end
fclose(fid);
fclose(fid10);

load('lena10.txt');

lena2 = de2bi(lena10);

fidb = fopen('lena2.txt','w');
for i = 1:65536
    for j = 8:-1:1
        fprintf(fidb,'%d', lena2(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fidb);
%---------------------------------
% simulate HW
%---------------------------------
i = 0:7;
for j = 0:7
    coe(j+1,:) = cos((2*i+1)*j*pi/16);
end
coe(1,:) = coe(1,:) / sqrt(2);
% CXC'
for i = 1:w*h/64
    Y2(:,:,i) = coe*lena8x8(:,:,i)*coe';
end
%---------------------------------
% Fixed for coefficient
%---------------------------------
bw = fix(coe*2^14);
C01 = cos(1*pi/16);
C02 = cos(2*pi/16);
C03 = cos(3*pi/16);
C04 = cos(4*pi/16);
C05 = cos(5*pi/16);
C06 = cos(6*pi/16);
C07 = cos(7*pi/16);
C11 = -C01;
C12 = -C02;
C13 = -C03;
C14 = -C04;
C15 = -C05;
C16 = -C06;
C17 = -C07;
bb = [C01 C02 C03 C04 C05 C06 C07 C11 C12 C13 C14 C15 C16 C17];
bbw = fix(bb*2^14);

fidb = fopen('matrix_b.txt','w');
for i = 1:length(bbw)
    if(bbw(1,i) >= 0)
        fprintf(fidb, '%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n', dec2bin(bbw(1,i),15));
    else
        fprintf(fidb, '%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n', "1", dec2bin((16384 + bbw(1,i)),14));
    end
end
fclose(fidb);

for i = 1:w*h/64
    YB2(:,:,i) = bw*lena8x8(:,:,i)*bw';
end
%---------------------------------
% Output from chip to do idct (Y2)
%---------------------------------
for i = 1:h/8
    for j = 1:w/8
        X2((i-1)*8+1:i*8,(j-1)*8+1:j*8) = (coe/4)'*Y2(:,:,(i-1)*(w/8)+j)*coe/4;
    end
end

YBF2 = YB2/(2^14*2^14);
for i = 1:h/8
    for j = 1:w/8
        YBB2((i-1)*8+1:i*8,(j-1)*8+1:j*8) = (coe'/4)*YBF2(:,:,(i-1)*(w/8)+j)*coe/4;
    end
end
%-----------Recombine after the DCT circuit----------%
load('DCT_output.txt');
for i = 1:8192
    DCT_load(i,:) = DCT_output(i*8-7:i*8,:);
end

for i = 1:1024
    for j = 1:8
        lena8x8_DCT(:,:,i) = DCT_load(i*8-7:i*8,1:8);
    end
end

lena8x8_DCT_Back = lena8x8_DCT*2^27/(2^14*2^14);
for i = 1:h/8
    for j = 1:w/8
        Z2((i-1)*8+1:i*8,(j-1)*8+1:j*8) = (coe'/4)*lena8x8_DCT_Back(:,:,(i-1)*(w/8)+j)*coe/4;
    end
end
%----------------------------------------------------%
fprintf('===========================\n');
fprintf('Original Mode\n');
psnr(lena, X2,1);
%%imshow(uint8(X2));
fprintf('===========================\n');
fprintf('Fixed-Point Mode\n');
psnr(lena, YBB2,1);
%imshow(uint8(YBB2));
fprintf('===========================\n');
fprintf('Circuit Mode\n');
psnr(lena, Z2,1);
imshow(uint8(Z2));