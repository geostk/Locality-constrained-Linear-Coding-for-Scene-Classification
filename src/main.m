%Set up paths
addpath('./SpatialPyramid');
addpath('./liblinear/matlab');
addpath('./libsvm/matlab');

%Set up data path
image_dir='../dataset/scene_categories';
data_dir='./data';
train_indice_file = 'f_order.txt';

%empty to use all cates
%image_cate_use = [1,2,3];
image_cate_use = [1:15];
%-1 : use all images
image_size = -1;

params.dictionarySize = 1024;
params.K = 5;
params.pyramidLevels = 3;
params.pfig = 0;

% feature_type = 0, nonLLC; 1, LLC.
feature_type = 1;

train_size = 100;
params.numTextonImages = train_size;
params.canSkip = 1;

%Extract features
[image_data, train_indices] = extractFeatures(image_dir, data_dir, image_cate_use, image_size, feature_type, params, train_indice_file);

%====== original start ======%
% [train_instance, train_label, test_instance, test_label] = splitData(image_data, train_size, train_indices);
% %One-Versus-All classification
% train_options='';
% predict_options='';
% train_instance_sparse = sparse(double(train_instance));
% test_instance_sparse = sparse(double(test_instance));
% model = liblineartrain(double(train_label), train_instance_sparse,train_options);
% [predicted_label, accuracy, dump] = liblinearpredict(double(test_label), test_instance_sparse, model, predict_options);
% confm = confusionmat(predicted_label, test_label);
%====== original end ======%

[test_instance_cell, test_label_cell, models] = splitData(image_data, train_size, train_indices);
%test_instance_sparse = sparse(test_instance);
cate_size = size(image_cate_use);
total_count = 0;
acc_vector = zeros(cate_size);
for k = 1 : cate_size(1, 2)
    test_instance = test_instance_cell{k};
    test_label = test_label_cell{k};
    test_size = size(test_instance);
    total_count = total_count + test_size(1, 1);
    predicted_label = zeros(test_size);
    correct = 0;
    for i = 1 : test_size(1, 1)
        max_cate = -1.0;
        max_value = -1.0;
        for j = 1 : cate_size(1, 2)
            prob = dot(models{j}.w(1, :), test_instance(i, :));
            if(prob > max_value)
                max_value = prob;
                max_cate = j;
            end
        end
        predicted_label(i) = max_cate;
        if(max_cate == test_label(i))
            correct = correct + 1;
        end
    end
    
    acc_vector(k) = correct * 1.0 / test_size(1, 1);
    sprintf('accuracy %d is %f', k, acc_vector(k))
end

mean_accuracy = mean(acc_vector)

%% Don't use the following code!
%{
for i = 1 : 1
    [train_instance, train_label, test_instance, test_label] = ...
            splitData(image_feature,i, train_size);
        
    if solve_type == 0
        options='-q';
        train_instance_sparse = sparse(train_instance);
        test_instance_sparse = sparse(test_instance);
        model = train(train_label, train_instance_sparse,options);
        [predicted_label, accuracy, dump] = predict(test_label, test_instance_sparse, model, options);
    elseif solve_type == 1
        train_K = hist_isect(train_instance, train_instance);
        test_K = hist_isect(test_instance, test_instance);
        train_num = size(train_K,1);
        test_num = size(test_K,1);
        model= libsvmtrain(train_label, [(1:train_num)', train_K], '-t 4');
        [predict_label, accuracy, dump] = ...
             svmpredict(test_label, [(1:test_num)', test_K], model);
    end            
end
%}



    
