clear;
close all;
clc;

ang = pi/16;
%% b第一列
y11 = cos(4*ang);
y12 = cos(4*ang);
y13 = cos(4*ang);
y14 = cos(4*ang);
y15 = cos(4*ang);
y16 = cos(4*ang);
y17 = cos(4*ang);
y18 = cos(4*ang);
%% b第二列
y21 =  cos(1*ang);
y22 =  cos(3*ang);
y23 =  cos(5*ang);
y24 =  cos(7*ang);
y25 = -cos(7*ang);
y26 = -cos(5*ang);
y27 = -cos(3*ang);
y28 = -cos(1*ang);
%% b第三列
y31 =  cos(2*ang);
y32 =  cos(6*ang);
y33 = -cos(6*ang);
y34 = -cos(2*ang);
y35 = -cos(2*ang);
y36 = -cos(6*ang);
y37 =  cos(6*ang);
y38 =  cos(2*ang);
%% b第四列
y41 =  cos(3*ang);
y42 = -cos(7*ang);
y43 = -cos(1*ang);
y44 = -cos(5*ang);
y45 =  cos(5*ang);
y46 =  cos(1*ang);
y47 =  cos(7*ang);
y48 = -cos(3*ang);
%% b第五列
y51 =  cos(4*ang);
y52 = -cos(4*ang);
y53 = -cos(4*ang);
y54 =  cos(4*ang);
y55 =  cos(4*ang);
y56 = -cos(4*ang);
y57 = -cos(4*ang);
y58 =  cos(4*ang);
%% b第六列
y61 =  cos(5*ang);
y62 = -cos(1*ang);
y63 =  cos(7*ang);
y64 =  cos(3*ang);
y65 = -cos(3*ang);
y66 = -cos(7*ang);
y67 =  cos(1*ang);
y68 = -cos(5*ang);
%% b第七列
y71 =  cos(6*ang);
y72 = -cos(2*ang);
y73 =  cos(2*ang);
y74 = -cos(6*ang);
y75 = -cos(6*ang);
y76 =  cos(2*ang);
y77 = -cos(2*ang);
y78 =  cos(6*ang);
%% b第八列
y81 =  cos(7*ang);
y82 = -cos(5*ang);
y83 =  cos(3*ang);
y84 = -cos(1*ang);
y85 =  cos(1*ang);
y86 = -cos(3*ang);
y87 =  cos(5*ang);
y88 = -cos(7*ang);
%%-------------------------------------------------------------------------


for i = 1:80
    x = i/pi;
    y(:,i) = [cos(x)];
end
A = y([1 2 3 4 5 6 7 8; 9 10 11 12 13 14 15 16; 17 18 19 20 21 22 23 24; 25 26 27 28 29 30 31 32; 33 34 35 36 37 38 39 40; 41 42 43 44 45 46 47 48; 49 50 51 52 53 54 55 56; 57 58 59 60 61 62 63 64; 65 66 67 68 69 70 71 72; 73 74 75 76 77 78 79 80])';

b = [y11 y12 y13 y14 y15 y16 y17 y18; y21 y22 y23 y24 y25 y26 y27 y28; y31 y32 y33 y34 y35 y36 y37 y38; y41 y42 y43 y44 y45 y46 y47 y48; y51 y52 y53 y54 y55 y56 y57 y58; y61 y62 y63 y64 y65 y66 y67 y68; y71 y72 y73 y74 y75 y76 y77 y78; y81 y82 y83 y84 y85 y86 y87 y88];
Z = b*A;
fprintf('%f\n', Z);
Zmatrix = [Z(:,1); Z(:,2); Z(:,3); Z(:,4); Z(:,5); Z(:,6); Z(:,7); Z(:,8); Z(:,9); Z(:,10)];
ZZ = floor(Zmatrix*2^28);

figure
plot(Zmatrix);
hold on
plot(y);
hold on


%%
%轉二進制
b = [y11 y12 y13 y14 y15 y16 y17 y18 y21 y22 y23 y24 y25 y26 y27 y28 y31 y32 y33 y34 y35 y36 y37 y38 y41 y42 y43 y44 y45 y46 y47 y48 y51 y52 y53 y54 y55 y56 y57 y58 y61 y62 y63 y64 y65 y66 y67 y68 y71 y72 y73 y74 y75 y76 y77 y78 y81 y82 y83 y84 y85 y86 y87 y88];
b = [y11 y12 y13 y14 y15 y16 y17 y18; y21 y22 y23 y24 y25 y26 y27 y28; y31 y32 y33 y34 y35 y36 y37 y38; y41 y42 y43 y44 y45 y46 y47 y48; y51 y52 y53 y54 y55 y56 y57 y58; y61 y62 y63 y64 y65 y66 y67 y68; y71 y72 y73 y74 y75 y76 y77 y78; y81 y82 y83 y84 y85 y86 y87 y88];

bw = round(b*2^14);
fidb = fopen('matrix_b.txt','w');
for i = 1:length(bw)
    if(bw(1,i) >= 0)
        fprintf(fidb, '%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n', dec2bin(bw(1,i),15));
    else
        fprintf(fidb, '%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n', "1",dec2bin((16384+bw(1,i)),14));
    end
end
fclose(fidb);

%%------------------------------------------------------------------------------------------------------

yw = floor(y*2^14);
fidin = fopen('data_input.txt','w');
for i = 1:length(yw)
    if(yw(1,i) >= 0)
        fprintf(fidin, '%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n', dec2bin(yw(1,i),15));
    else
        fprintf(fidin, '%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n', '1', dec2bin((16384+yw(1,i)),14));
    end
end
fclose(fidin);

Ans = [157915135;
  936104966;
  -42745567;
   36243636;
   -8352785;
   10275455;
   -2596446;
    2584671;
 -766625790;
 -702069759;
  207352262;
  -27185533;
   40524330;
   -7723245;
   12575862;
   -1924191;
-1035926068;
  226644452;
 -300684847;
    8769903;
  -58782290;
    2477329;
  -18232555;
     626312;
 1072986483;
  326691431;
  290636250;
   12638528;
   56824425;
    3579947;
   17617085;
     897816;
  667805740;
 -767730078;
 -180653961;
  -29719663;
  -35334250;
   -8440929;
  -10969273;
   -2132208;
  -31673390;
  944782025;
    8552445;
   36580288;
    1668240;
   10373112;
     545497;
    2599323;
 -615499465;
 -797001700;
  166467211;
  -30859540;
   32565435;
   -8765465;
   10111644;
   -2206023;
 1050898520;
  375164032;
 -284278411;
   14534035;
  -55584830;
    4123095;
  -17253531;
    1040782;
  175644740;
  304321327;
    6816226;
   59512145;
    1939985;
   18444254;
     486205;
 -666063407;
 -219732774;
  -25804407;
  -42957180;
   -7330695;
  -13341480;
   -1825715];
AAns = Ans/2^28;
plot(AAns);

yww = floor(A*2^14);
by = bw*yww;
