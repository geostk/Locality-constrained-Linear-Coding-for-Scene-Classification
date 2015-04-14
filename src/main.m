%Set up paths
addpath('./SpatialPyramid');
addpath('./liblinear/matlab');

%Set up data path
image_dir='../dataset/scene_categories';
data_dir='./data';

image_cate_use = [1 2 3];
image_size = 200;

%Extract features
[image_feature] = extractFeatures(image_dir, data_dir, image_cate_use, image_size);

%One-Versus-All classification
flag_kernel = 1;
train_size = 100;%round(image_size*0.7);
for i = 1 : 1
    [train_instance, train_label, test_instance, test_label] = ...
            splitData(image_feature,i, train_size);
        
    if flag_kernel == 0
        train_instance_sparse = sparse(train_instance);
        test_instance_sparse = sparse(test_instance);
        model = train(train_label, train_instance);
        [predicted_label, accuracy, dump] = predict(test_label, test_instance, model);
    else
        train_K = hist_isect(train_instance, train_instance);
        test_K = hist_isect(test_instance, test_instance);
        train_num = size(train_K,1);
        test_num = size(test_K,1);
        model= libsvmtrain(train_label, [(1:train_num)', train_K], '-t 4');
        [predict_label, accuracy, dump] = ...
             svmpredict(test_label, [(1:test_num)', test_K], model);
    end
end



    
