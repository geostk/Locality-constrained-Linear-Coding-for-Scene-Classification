function [train_instance, train_label, test_instance, test_label] = splitData(data, train_size)
% Split Data to train set and test set for cate-th category
% Input: data
%        cate - categorty index
%        train_size - the train files in each category
% Output: train_instance train_label test_instance test_label

% top train_size from each category is train

cate_num = length(data);
fea_num = size(data{1},2);

train_label = [];
train_instance = [];

test_label = [];
test_instance = [];

for i = 1 : cate_num
    cate_data = data{i};
    train_label = [train_label; i*ones(train_size,1)];
    train_instance = [train_instance; cate_data(1:train_size,:)];
    
    test_label = [test_label; i*ones(size(cate_data,1)-train_size,1)];
    test_instance = [test_instance; cate_data(train_size+1:size(cate_data,1),:)];
end

%{
fea_num = size(data{1},2);
cate_num = length(data);
train_label = -1*ones(cate_num*train_size,1);
train_instance = zeros(cate_num*train_size,fea_num);
test_label = [];
test_instance = [];


train_pos = 0;
test_pos = 0;
for i = 1 : cate_num
    cate_data = data{i};
    if i == cate
        train_label(train_pos+1: train_pos+train_size) = 1;
        test_label = [test_label; ones(size(cate_data,1)-train_size,1)];
    else
        train_label(train_pos+1: train_pos+train_size) = -1;
        test_label = [test_label; -1*ones(size(cate_data,1)-train_size,1)];
    end
    train_instance(train_pos+1 : train_pos+train_size,:) = cate_data(1:train_size,:);
    test_instance = [test_instance; cate_data(train_size+1:end,:)];
    
    train_pos = train_pos + train_size;
    test_pos = test_pos + size(cate_data,1)-train_size;
end
%}
end