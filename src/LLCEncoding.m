function [code] = LLCEncoding(X,B,K)
% LLC encoding
% Input: X - data
%        B - codebook
%        K - parameter for knn
% Output: code - LLC code

%Calculate distance
D = sp_dist2(X,B);

%Sort D to get nn, nearest neighbor
[~, nn] = sort(D, 2, 'ascend');
nn = nn(:,1:K);

%codebook size
s = size(B,1);

%instance num
n = size(X,1);

code = zeros(n,s);

for i = 1 : n
    c = B(nn(i,:),:) - repmat(X(i,:),K,1);
    c = c*c';
    c = c + eye(K,K)*1e-4*trace(c);
    c = c\ones(K,1);
    c = c/sum(c);
    code(i,nn(i,:)) = c';
end
end