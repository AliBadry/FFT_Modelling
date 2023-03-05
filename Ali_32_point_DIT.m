%% --------------initializing the  code -------------%%
clear all
close all
clc
N = 32;   %%----- value of fixed point--------%%

Twiddle_factor = exp((-1i*2*pi*(0:(N/2)-1))/N);
%%inputs = [1,2,4,6,6,4,2,1]; %%----stream of 16 points input------%%
inputs = 0:1:N-1;
Num_of_stages = log2(N);

%% --------------we need to decimate the inputs by dividing and arranging them log2(N)  times--------%%  
inputs_reversed = zeros(1,N);
p=bitrevorder(1:N);
for K=1:N
inputs_reversed(p(K))=inputs(K);
end

inputs = inputs_reversed;

stage = 1;
%% ------Stage 1-------%%
for n=0:(N/2)-1
stage1_o(2*n+1) = inputs(2*n+1) + inputs(2*n+2);
stage1_o(2*n+2) = inputs(2*n+1) - inputs(2*n+2);
end

stage = stage+1;
%% ------Stage 2-------%%
for n=0:(N/4)-1
    for k = 0:1:1
        for t=1:1:2
            stage2_o(4*n+2*k+t) = stage1_o(4*n+t)+ (-1)^k*Twiddle_factor(8*t-7)*stage1_o(4*n+(t+2));
        end
%         stage2_o(4*n+2*k+1) = stage1_o(4*n+1)+ (-1)^k*Twiddle_factor(1)*stage1_o(4*n+3);
%         stage2_o(4*n+2*k+2) = stage1_o(4*n+2)+ (-1)^k*Twiddle_factor(9)*stage1_o(4*n+4);
    end
    
end

stage = stage+1;
%% ------Stage 3-------%%
for n=0:(N/8)-1
    for k = 0:1:1
        for t=1:1:4
            stage3_o(8*n+4*k+t) = stage2_o(8*n+t)+ (-1)^k*Twiddle_factor(4*t-3)*stage2_o(8*n+(t+4));
        end
%         stage3_o(8*n+4*k+1) = stage2_o(8*n+1)+ (-1)^k*Twiddle_factor(1)*stage2_o(8*n+5);
%         stage3_o(8*n+4*k+2) = stage2_o(8*n+2)+ (-1)^k*Twiddle_factor(5)*stage2_o(8*n+6);
%         stage3_o(8*n+4*k+3) = stage2_o(8*n+3)+ (-1)^k*Twiddle_factor(9)*stage2_o(8*n+7);
%         stage3_o(8*n+4*k+4) = stage2_o(8*n+4)+ (-1)^k*Twiddle_factor(13)*stage2_o(8*n+8);
    end
    
end

stage = stage+1;
%% ------Stage 4-------%%
for n=0:(N/16)-1
    for k = 0:1:1
        for t=1:1:8
            stage4_o(16*n+8*k+t) = stage3_o(16*n+t)+ (-1)^k*Twiddle_factor(2*t-1)*stage3_o(16*n+(t+8));
        end
%         stage4_o(16*n+8*k+1) = stage3_o(16*n+1)+ (-1)^k*Twiddle_factor(1)*stage3_o(16*n+9);
%         stage4_o(16*n+8*k+2) = stage3_o(16*n+2)+ (-1)^k*Twiddle_factor(3)*stage3_o(16*n+10);
%         stage4_o(16*n+8*k+3) = stage3_o(16*n+3)+ (-1)^k*Twiddle_factor(5)*stage3_o(16*n+11);
%         stage4_o(16*n+8*k+4) = stage3_o(16*n+4)+ (-1)^k*Twiddle_factor(7)*stage3_o(16*n+12);
% 		  stage4_o(16*n+8*k+5) = stage3_o(16*n+5)+ (-1)^k*Twiddle_factor(9)*stage3_o(16*n+13);
%         stage4_o(16*n+8*k+6) = stage3_o(16*n+6)+ (-1)^k*Twiddle_factor(11)*stage3_o(16*n+14);
%         stage4_o(16*n+8*k+7) = stage3_o(16*n+7)+ (-1)^k*Twiddle_factor(13)*stage3_o(16*n+15);
%         stage4_o(16*n+8*k+8) = stage3_o(16*n+8)+ (-1)^k*Twiddle_factor(15)*stage3_o(16*n+16);
    end
    
end

stage = stage+1;

%% --------------stage 5 -----------%%
for k = 0:1:1
     for t=1:1:16
         stage5_o(16*k+t) = stage4_o(t)+ (-1)^k*Twiddle_factor(t)*stage4_o (t+16);
     end
%         stage5_o(16*k+1) = stage4_o(1)+ (-1)^k*Twiddle_factor(1)*stage4_o (17);
%         stage5_o(16*k+2) = stage4_o(2)+ (-1)^k*Twiddle_factor(2)*stage4_o (18);
%         stage5_o(16*k+3) = stage4_o(3)+ (-1)^k*Twiddle_factor(3)*stage4_o (19);
%         stage5_o(16*k+4) = stage4_o(4)+ (-1)^k*Twiddle_factor(4)*stage4_o(20);
% 		stage5_o(16*k+5) = stage4_o(5)+ (-1)^k*Twiddle_factor(5)*stage4_o (21);
%         stage5_o(16*k+6) = stage4_o(6)+ (-1)^k*Twiddle_factor(6)*stage4_o (22);
%         stage5_o(16*k+7) = stage4_o(7)+ (-1)^k*Twiddle_factor(7)*stage4_o (23);
%         stage5_o(16*k+8) = stage4_o(8)+ (-1)^k*Twiddle_factor(8)*stage4_o(24);
% 		stage5_o(16*k+9) = stage4_o(9)+ (-1)^k*Twiddle_factor(9)*stage4_o (25);
% 		stage5_o(16*k+10) = stage4_o(10)+ (-1)^k*Twiddle_factor(10)*stage4_o (26);
% 		stage5_o(16*k+11) = stage4_o(11)+ (-1)^k*Twiddle_factor(11)*stage4_o (27);
%         stage5_o(16*k+12) = stage4_o(12)+ (-1)^k*Twiddle_factor(12)*stage4_o(28);
%         stage5_o(16*k+13) = stage4_o(13)+ (-1)^k*Twiddle_factor(13)*stage4_o (29);
%         stage5_o(16*k+14) = stage4_o(14)+ (-1)^k*Twiddle_factor(14)*stage4_o (30);
%         stage5_o(16*k+15) = stage4_o(15)+ (-1)^k*Twiddle_factor(15)*stage4_o (31);
%         stage5_o(16*k+16) = stage4_o(16)+ (-1)^k*Twiddle_factor(16)*stage4_o(32);
	end
	stage = stage+1;
%% ----------diplaying the outputs-----------%%
    display(stage5_o)
    
    Y=fft(0:1:N-1,N);
    display(Y)
 
    if (real(Y(13))==real(stage5_o(13)))
        display("Equal")
    else
        display("NOT Equal")
    end
    
    
    
%% Fixed-Point Representation Object
Integer_Part = 16;
Fractional_Part = 16;
q = quantizer('DataMode', 'fixed', 'Format', [Integer_Part+Fractional_Part Fractional_Part]);

% quantize (q,real(stage1_o));
stage1_real = num2bin(q, real(stage1_o)');
stage1_imag = num2bin(q, imag(stage1_o)');
stage2_real = num2bin(q, real(stage2_o)');
stage2_imag = num2bin(q, imag(stage2_o)');
stage3_real = num2bin(q, real(stage3_o)');
stage3_imag = num2bin(q, imag(stage3_o)');
stage4_real = num2bin(q, real(stage4_o)');
stage4_imag = num2bin(q, imag(stage4_o)');
stage5_real = num2bin(q, real(stage5_o)');
stage5_imag = num2bin(q, imag(stage5_o)');

fileID1 = fopen(['stage1_real.txt'], 'w');
fileID2 = fopen(['stage1_imag.txt'], 'w');
fileID3 = fopen(['stage2_real.txt'], 'w');
fileID4 = fopen(['stage2_imag.txt'], 'w');
fileID5 = fopen(['stage3_real.txt'], 'w');
fileID6 = fopen(['stage3_imag.txt'], 'w');
fileID7 = fopen(['stage4_real.txt'], 'w');
fileID8 = fopen(['stage4_imag.txt'], 'w');
fileID9 = fopen(['stage5_real.txt'], 'w');
fileID10= fopen(['stage5_imag.txt'], 'w');

for i = 1 :  N
    if i ==  N
      fprintf(fileID1 , '%s', stage1_real(i, :));
      fprintf(fileID2 , '%s', stage1_imag(i, :));
      fprintf(fileID3 , '%s', stage2_real(i, :));
	  fprintf(fileID4 , '%s', stage2_imag(i, :));
      fprintf(fileID5 , '%s', stage3_real(i, :));
      fprintf(fileID6 , '%s', stage3_imag(i, :));
	  fprintf(fileID7 , '%s', stage4_real(i, :));
      fprintf(fileID8 , '%s', stage4_imag(i, :));
      fprintf(fileID9 , '%s', stage5_real(i, :));
	  fprintf(fileID10, '%s', stage5_imag(i, :));
    else
      fprintf(fileID1 , '%s\n', stage1_real(i, :));
	  fprintf(fileID2 , '%s\n', stage1_imag(i, :));
	  fprintf(fileID3 , '%s\n', stage2_real(i, :));
      fprintf(fileID4 , '%s\n', stage2_imag(i, :));
      fprintf(fileID5 , '%s\n', stage3_real(i, :));
      fprintf(fileID6 , '%s\n', stage3_imag(i, :));
      fprintf(fileID7 , '%s\n', stage4_real(i, :));
      fprintf(fileID8 , '%s\n', stage4_imag(i, :));
      fprintf(fileID9 , '%s\n', stage5_real(i, :));
      fprintf(fileID10, '%s\n', stage5_imag(i, :));
	  end 
end

fclose(fileID1);
fclose(fileID2);
fclose(fileID3);
fclose(fileID4);
fclose(fileID5);
fclose(fileID6);
fclose(fileID7);
fclose(fileID8);
fclose(fileID9);
fclose(fileID10);