%% --------------initializing the  code -------------%%
clear all
close all
clc
N = 8;   %%----- value of fixed point--------%%
Twiddle_factor = exp((-1i*2*pi*(0:N-1))/N);
%%inputs = [1,2,4,6,6,4,2,1]; %%----stream of 16 points input------%%
inputs = 0:1:N-1;
Num_of_stages = log2(N);

%% --------------we need to decimate the inputs by dividing and arranging them log2(N)  times--------%%  

n=1; %%----------to compare it with the number of stage--------%%
%%div_ratio = size(inputs)/N;
inputs_2 = zeros(1,N);
while (n < Num_of_stages)
   if(n==1)
        for k=0:1:N-1
           if(mod(k,2)==0)
              inputs_2((k/2)+1) = inputs(k+1);  %%-------you will find all the indeces incremented
           else                               %% by 1 as they begin from 1 not 0 :(-----------%%
               inputs_2(((N-1)-(N-1-k)/2)+1) = inputs(k+1);
           end
        end
   elseif(n==2)
       NN = N/2;
       for k=0:1:N-1
          if((k/(N/n))<1)
              if(mod(k,2)==0)
                inputs_2((k/2)+1) = inputs(k+1); 
              else
                inputs_2(((NN-1)-(NN-1-k)/2)+1) = inputs(k+1);
              end
          else
              if(mod(k,2)==0)
                inputs_2((((k-(N/n))/2)+(N/n))+1) = inputs(k+1);        
              else
                inputs_2(((N-1)-(N-1-k)/2)+1) = inputs(k+1);
              end
          end
       end
   end
   inputs = inputs_2;
   n = n+1;
   inputs_2 = zeros(1,N);
end
display(inputs)

%% ------------- implementing the Butterfly unit ------------------- %%

%%--------note: the twiddle factor depends on the number --------------%%
%%--------------of  interchanging inputs-------------------------------%%

%----------------------stage 1-----------------%   

Stage1_out = zeros(1,N);

Stage1_out(1) = inputs(1)+exp((-1i*2*pi*0*(N/2))/N)*inputs(2);
Stage1_out(2) = inputs(1)+exp((-1i*2*pi*1*(N/2))/N)*inputs(2);

Stage1_out(3) = inputs(3)+exp((-1i*2*pi*0*(N/2))/N)*inputs(4);
Stage1_out(4) = inputs(3)+exp((-1i*2*pi*1*(N/2))/N)*inputs(4);

Stage1_out(5) = inputs(5)+exp((-1i*2*pi*0*(N/2))/N)*inputs(6);
Stage1_out(6) = inputs(5)+exp((-1i*2*pi*1*(N/2))/N)*inputs(6);

Stage1_out(7) = inputs(7)+exp((-1i*2*pi*0*(N/2))/N)*inputs(8);
Stage1_out(8) = inputs(7)+exp((-1i*2*pi*1*(N/2))/N)*inputs(8);

%-------------------stage 2--------------------------%

Stage2_out = zeros(1,N);

Stage2_out(1) = Stage1_out(1)+exp((-1i*2*pi*0*(N/4))/N)*Stage1_out(3);
Stage2_out(2) = Stage1_out(2)+exp((-1i*2*pi*1*(N/4))/N)*Stage1_out(4);
Stage2_out(3) = Stage1_out(1)+exp((-1i*2*pi*2*(N/4))/N)*Stage1_out(3);
Stage2_out(4) = Stage1_out(2)+exp((-1i*2*pi*3*(N/4))/N)*Stage1_out(4);

Stage2_out(5) = Stage1_out(5)+exp((-1i*2*pi*0*(N/4))/N)*Stage1_out(7);
Stage2_out(6) = Stage1_out(6)+exp((-1i*2*pi*1*(N/4))/N)*Stage1_out(8);
Stage2_out(7) = Stage1_out(5)+exp((-1i*2*pi*2*(N/4))/N)*Stage1_out(7);
Stage2_out(8) = Stage1_out(6)+exp((-1i*2*pi*3*(N/4))/N)*Stage1_out(8);

%--------------------stage 3-----------------------%

Stage3_out = zeros(1,N);

Stage3_out(1) = Stage2_out(1)+exp((-1i*2*pi*0*(N/8))/N)*Stage2_out(5);
Stage3_out(2) = Stage2_out(2)+exp((-1i*2*pi*1*(N/8))/N)*Stage2_out(6);
Stage3_out(3) = Stage2_out(3)+exp((-1i*2*pi*2*(N/8))/N)*Stage2_out(7);
Stage3_out(4) = Stage2_out(4)+exp((-1i*2*pi*3*(N/8))/N)*Stage2_out(8);
Stage3_out(5) = Stage2_out(1)+exp((-1i*2*pi*4*(N/8))/N)*Stage2_out(5);
Stage3_out(6) = Stage2_out(2)+exp((-1i*2*pi*5*(N/8))/N)*Stage2_out(6);
Stage3_out(7) = Stage2_out(3)+exp((-1i*2*pi*6*(N/8))/N)*Stage2_out(7);
Stage3_out(8) = Stage2_out(4)+exp((-1i*2*pi*7*(N/8))/N)*Stage2_out(8);

%% -----------------compacting the previous section -----------%%
Stage_out = zeros(Num_of_stages,N);

for stage=1:1:Num_of_stages
    if(stage == 1)
        for k=1:1:N/2
           Stage_out(stage,2*k-1) = inputs(2*k-1)+ inputs(2*k);
           Stage_out(stage,2*k) = inputs(2*k-1)- inputs(2*k);
        end
    elseif(stage == 2)
        for k=1:1:N/4
%             for L=0:1
%                 Stage_out(stage,4*k+2*L-3) = Stage_out(stage-1,4*k-3)+((-1)^L)* Stage_out(stage-1,4*k-1);
%                 Stage_out(stage,4*k+2*L-2) = Stage_out(stage-1,4*k-2)+((-1)^L) * Twiddle_factor(3) * Stage_out(stage-1,4*k);
%             end
           Stage_out(stage,4*k-3) = Stage_out(stage-1,4*k-3)+ Stage_out(stage-1,4*k-1);
           Stage_out(stage,4*k-2) = Stage_out(stage-1,4*k-2)+ exp((-1i*2*pi*1*(N/4))/N) * Stage_out(stage-1,4*k);
           Stage_out(stage,4*k-1) = Stage_out(stage-1,4*k-3)- Stage_out(stage-1,4*k-1);
           Stage_out(stage,4*k) = Stage_out(stage-1,4*k-2)- exp((-1i*2*pi*1*(N/4))/N) * Stage_out(stage-1,4*k);
        end
    elseif(stage == 3)
        for k=1:1:N/8

           Stage_out(stage,8*k-7) = Stage_out(stage-1,8*k-7)+ Stage_out(stage-1,8*k-3);
           Stage_out(stage,8*k-6) = Stage_out(stage-1,8*k-6)+ exp((-1i*2*pi*1*(N/8))/N) * Stage_out(stage-1,8*k-2);
           Stage_out(stage,8*k-5) = Stage_out(stage-1,8*k-5)+ exp((-1i*2*pi*2*(N/8))/N) * Stage_out(stage-1,8*k-1);
           Stage_out(stage,8*k-4) = Stage_out(stage-1,8*k-4)+ exp((-1i*2*pi*3*(N/8))/N) * Stage_out(stage-1,8*k);
           Stage_out(stage,8*k-3) = Stage_out(stage-1,8*k-7)- Stage_out(stage-1,8*k-3);
           Stage_out(stage,8*k-2) = Stage_out(stage-1,8*k-6)- exp((-1i*2*pi*1*(N/8))/N) * Stage_out(stage-1,8*k-2);
           Stage_out(stage,8*k-1) = Stage_out(stage-1,8*k-5)- exp((-1i*2*pi*2*(N/8))/N) * Stage_out(stage-1,8*k-1);
           Stage_out(stage,8*k) = Stage_out(stage-1,8*k-4)- exp((-1i*2*pi*3*(N/8))/N) * Stage_out(stage-1,8*k);
        end
    end
end

%% -------------displayng the results--------------- %%
display(Stage_out(3,:))
display(Stage3_out)

Y=fft([0,1,2,3,4,5,6,7],N);
display(Y)