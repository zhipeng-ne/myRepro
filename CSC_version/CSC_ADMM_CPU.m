function [ Z ] = CSC_ADMM_CPU( Filters, FX, MaxIter, lambda, rho, mu0 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
max_mu = 1e8;
tol = 1e-8;

mu = mu0;

iter = 1;
Cond = 1;
[M ,N ,K] = size(Filters);

FR = zeros(M,N,K);
FTX = zeros(M,N,K);

Z = zeros(M,N,K);
S = zeros(M,N,K);
T = zeros(M,N,K);

C_Filters = conj(Filters);

FTX = C_Filters.*repmat(FX,[1,1,K]);   
FTF  = sum(C_Filters.*Filters,3);     %an*an
while(iter<MaxIter&&Cond)

    FR = FTX+mu*fft2(S-T);     %b
    FZ = (FR-repmat(sum(Filters.*FR,3)./(mu+FTF),[1,1,K]).*C_Filters)./mu;    %Vn
    Z = real(ifft2(FZ));     %x
    S = max(abs(Z+T)-lambda/mu,0).*sign(Z+T);     %y
    T = T + Z - S;    %u
    
    if(mu<max_mu)
        mu = mu*rho;
    end
    if(mod(iter,10)==0)
        %fprintf('%i ',iter);
        ConvergenceError = mean((Z(:)-S(:)).^2);
        Cond = (ConvergenceError>tol);
    end
    if(iter == 70)
        fprintf('%i ',iter);
    end
    iter = iter+1;  
end
   
Z = real(Z);


%  SS = Z(:,:,1);
%    for j = 2:400
%        z = Z(:,:,j); 
%        SS = SS + z ;
% %      if mod(j,100) == 0
% %        imwrite(SS,['F:\targetTracking\picture\' num2str(j) '.jpg']);
% %        SS = 0;
% %      end
%     switch j
%         case 100
%             Chara_100 = SS;
%         case 200
%             Chara_200 = SS;
%         case 300
%             Chara_300 = SS;
%         case 400 
%             Chara_400 =SS;
%    %         imwrite(SS,['F:\targetTracking\picture\' num2str(4) '.jpg']);
%     end
%    end
end


