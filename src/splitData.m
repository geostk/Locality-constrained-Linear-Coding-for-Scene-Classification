%function [train_instance, train_label, test_instance, test_label] = splitData(data, train_size, train_indices)
%function [test_instance, test_label, models] = splitData(data, train_size, train_indices)
function [test_instance_ret_cell, test_label_ret_cell, models] = splitData(data, train_size, train_indices)
% Split Data to train set and test set for cate-th category
% Input: data
%        cate - categorty index
%        train_size - the train files in each category
% Output: train_instance train_label test_instance test_label

% top train_size from each category is train

cate_num = length(data);
fea_num = size(data{1},2);

test_label = [];
test_instance = [];

models = cell(cate_num);
test_instance_ret_cell = cell(cate_num);
test_label_ret_cell = cell(cate_num);
for i = 1 : cate_num
    liblinearTrainCate = i
    cate_train_label = [];
    cate_train_instance = [];
    cate_test_label = [];
    cate_test_instance = [];
    for j = 1 : cate_num
        cate_data = data{j};
        cate_data_size = size(cate_data, 1);
        cate_total_indices = [1:cate_data_size];
        cate_train_indices = train_indices{j};
        cate_test_indices = setdiff(cate_total_indices, cate_train_indices);
        
        if(j == i) 
            cate_train_label = [cate_train_label; 1*ones(train_size,1)];
            cate_test_label = [cate_test_label; 1*ones(size(cate_data,1)-train_size,1)];
            cate_test_instance = [cate_test_instance; cate_data(cate_test_indices,:)];

        else
            cate_train_label = [cate_train_label; -1*ones(train_size,1)];
            %cate_test_label = [cate_test_label; -1*ones(size(cate_data,1)-train_size,1)];
            %cate_test_instance = [cate_test_instance; cate_data(cate_test_indices,:)];

        end
        cate_train_instance = [cate_train_instance; cate_data(cate_train_indices,:)];
    end
    train_instance_sparse = sparse(cate_train_instance);
    train_options='-s 4';
    models{i} = liblineartrain(cate_train_label, train_instance_sparse, train_options);
    test_instance_sparse = sparse(cate_test_instance);
    [predicted_label, accuracy, dump] = liblinearpredict(cate_test_label, test_instance_sparse, models{i}, '');


    cate_data = data{i};
    cate_data_size = size(cate_data, 1);
    cate_total_indices = [1:cate_data_size];
    cate_train_indices = train_indices{i};
    cate_test_indices = setdiff(cate_total_indices, cate_train_indices);
    %test_label = [test_label; i*ones(size(cate_data,1)-train_size,1)];
    %test_instance = [test_instance; cate_data(cate_test_indices,:)];
    test_label_ret_cell{i} = i*ones(size(cate_data,1)-train_size,1);
    test_instance_ret_cell{i} = cate_data(cate_test_indices,:);
end

%====== original start ======
% train_label = [];
% train_instance = [];
% for i = 1 : cate_num
% 
%     cate_data = data{i};
%     cate_data_size = size(cate_data, 1);
%     cate_train_indices = train_indices{i};
%     cate_total_indices = [1:cate_data_size];
%     cate_test_indices = setdiff(cate_total_indices, cate_train_indices);
%     
%     train_label = [train_label; i*ones(train_size,1)];
%     %train_instance = [train_instance; cate_data(1:train_size,:)];
%     train_instance = [train_instance; cate_data(cate_train_indices,:)];
%     
%     test_label = [test_label; i*ones(size(cate_data,1)-train_size,1)];
%     %test_instance = [test_instance; cate_data(train_size+1:size(cate_data,1),:)];
%     test_instance = [test_instance; cate_data(cate_test_indices,:)];
%     
% 
% %     if(i == 4) 
% %         train_label = [train_label; 1*ones(train_size,1)];
% %         %train_instance = [train_instance; cate_data(1:train_size,:)];
% %         train_instance = [train_instance; cate_data(cate_train_indices,:)];
% %     else 
% %         train_label = [train_label; -1*ones(train_size,1)];
% %         %train_instance = [train_instance; cate_data(1:train_size,:)];
% %         train_instance = [train_instance; cate_data(cate_train_indices,:)];
% %     end
% %     
% %     if(i == 4)
% %         test_label = [test_label; 1*ones(size(cate_data,1)-train_size,1)];
% %         %test_instance = [test_instance; cate_data(train_size+1:size(cate_data,1),:)];
% %         test_instance = [test_instance; cate_data(cate_test_indices,:)];
% %     %else 
% %     %    test_label = [test_label; -1*ones(size(cate_data,1)-train_size,1)];
% %     %    test_instance = [test_instance; cate_data(cate_test_indices,:)];
% %     end
%     
%     %test_label = [test_label; i*ones(size(cate_data,1)-train_size,1)];
%     %test_instance = [test_instance; cate_data(train_size+1:size(cate_data,1),:)];
%     %test_instance = [test_instance; cate_data(cate_test_indices,:)];
% end
%====== original end ======

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