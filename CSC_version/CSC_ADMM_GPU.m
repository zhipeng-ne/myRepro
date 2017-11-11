function [  Z, Chara_200, Chara_400, Chara_600, Chara_800] = CSC_ADMM_GPU( Filters, FX, MaxIter, lambda, rho, mu0 )

% Solve convolutional sparse coding problem by ADMM algorithm 
% Filters is the FFT coefficients of decomposition filters
% FX is the FFT coefficients of the input image
% MaxIter is the maximum iteration value in the ADMM algorithm
% lambda is the regularization parameter
% rho and mu0 is the parameters for the ADMM algorithm

max_mu = 1e8;
tol = 1e-8;

mu = mu0;

iter = 1;
Cond = 1;
[M, N , K] = size(Filters);

FR = gpuArray(zeros(M,N,K));
FTX = gpuArray(zeros(M,N,K));

Z = gpuArray(zeros(M,N,K));
S = gpuArray(zeros(M,N,K));
T = gpuArray(zeros(M,N,K));


C_Filters = conj(Filters);

FTX = C_Filters.*repmat(FX,[1,1,K]);
FTF  = sum(C_Filters.*Filters,3);
while(iter<MaxIter&&Cond)

    FR = FTX+mu*fft2(S-T);
    FZ = (FR-repmat(sum(Filters.*FR,3)./(mu+FTF),[1,1,K]).*C_Filters)./mu;  
    Z = real(ifft2(FZ));
    S = max(abs(Z+T)-lambda/mu,0).*sign(Z+T);
    T = T + Z - S;
    
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
 
 Z = real(gather(Z));
 SS = Z(:,:,1);
   for j = 2:800
       z = Z(:,:,j); 
       SS = SS + z ;
     switch j
        case 200
            Chara_200 = SS;
        case 400
            Chara_400 = SS;
        case 600
            Chara_600 = SS;
        case 800 
            Chara_800 =SS;
            %imwrite(SS,['F:\targetTracking\picture\' num2str(4) '.jpg']);
     end
     if mod(j,200) == 0
       %imwrite(SS,['F:\targetTracking\picture\' num2str(j) '.jpg']);
       SS = 0;
     end
   end
end
