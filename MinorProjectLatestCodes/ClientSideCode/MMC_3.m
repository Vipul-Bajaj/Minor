% Author : Vipul Bajaj
% All the Sparse Matrices are Diagonal in nature or its permutations
% Inverse of only Diagonal Sparse matrices is guranteed to be sparse
% Platform : Octave
% EncryptedMatrix1 = key1 * DataMatrix1 * Key2
% EncryptedMatrix2 = inverse(Key2) * DataMatrix2 * key3


% IF USING CMD PLS MODIFY THIS 
M= str2num(argv(){1});;

%Generating Data matrices.

DATA1 =  ceil(12 * rand(M,M));
DATA2 =  ceil(13 * rand(M,M));

% ***  Plain Matrix Multiplication  *** 
tic 
plain_Mul = DATA1*DATA2;
t_original = toc; 

%Sparse Matrices Generation;
tic;
Key1 = 12.56*circshift(speye(M),-2);
Key2 = 6*speye(M);
Key3 = 4.8*circshift(speye(M),-5);
CM = randi([0,1],M,1); % coloum matrix
t_sparse = toc;

% ENCRYPTION 
tic 
EncDATA1 = (Key1*DATA1*Key2);
EncDATA2 = (inv(Key2)*DATA2*Key3);
t_encrypt=toc;

% CLOUD SIDE 
tic;
Result = EncDATA1*EncDATA2;
t_cloud = toc;

% Decryption
tic
Decry_Ans = (inv(Key1)*(Result)*inv(Key3));
t_decrypt=toc;

% Verification
tic;
int32 (round(Decry_Ans) * CM) == plain_Mul*CM;
t_verifiy = toc;

t_client = t_encrypt + t_decrypt + t_verifiy + t_sparse;
printf("%dx%d\t",M,M);
printf("%.15f\t",t_original);  %Time taken for plain multiplication. 
printf("%.15f\n",t_client); %Total time taken by Client. 
clear;

