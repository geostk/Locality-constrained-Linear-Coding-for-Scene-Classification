%function [train_instance, train_label, test_instance, test_label] = splitData(data, train_size, train_indices)
%function [test_instance, test_label, models] = splitData(data, train_size, train_indices)
function [train_instance, train_label, test_instance, test_label] = splitData(data, train_size, train_indices)
% Split Data to train set and test set for cate-th category
% Input: data
%        cate - categorty index
%        train_size - the train files in each category
% Output: train_instance train_label test_instance test_label


cate_num = length(data);
fea_num = size(data{1},2);

train_label = [];
train_instance = [];

test_label = [];
test_instance = [];


for i = 1 : cate_num
    cate_data = data{i};
    all_indices = [1:size(cate_data,1)];
    is_train = ismember(all_indices,train_indices);
    
    train_label = [train_label; i*ones(train_size,1)];
    train_instance = [train_instance; cate_data(is_train == 1,:)];
    
    test_label = [test_label; i*ones(size(cate_data,1)-train_size,1)];
    test_instance = [test_instance; cate_data(is_trian == 0,:)];
end

end