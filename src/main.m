%Set up paths
addpath('./SpatialPyramid');
addpath('./liblinear/matlab');

%Set up data path
image_dir='../dataset/scene_categories';
data_dir='./data';

image_cate_use = [1 2 3];
%-1 : use all images
image_size = 200;

params.dictionarySize = 1024;
% feature_type = 0, nonLLC; 1, LLC.
feature_type = 1;
%Extract features
image_data = extractFeatures(image_dir, data_dir, image_cate_use, image_size, feature_type, params);

%One-Versus-All classification
%solve_type=0 non-kernel; 1 kernel.
solve_type = 0;
train_size = 100;%round(image_size*0.7);

[train_instance, train_label, test_instance, test_label] = ...
            splitData(image_data, train_size);
options='';
train_instance_sparse = sparse(train_instance);
test_instance_sparse = sparse(test_instance);
model = liblineartrain(train_label, train_instance_sparse,options);
[predicted_label, accuracy, dump] = liblinearpredict(test_label, test_instance_sparse, model, options);










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



    
