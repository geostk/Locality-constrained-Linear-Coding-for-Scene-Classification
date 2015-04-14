%Set up paths
addpath('./SpatialPyramid');
addpath('./liblinear/matlab');

%Set up data path
image_dir='../dataset/scene_categories';
data_dir='./data';

image_cate_use = [1 2 3 4 5];
image_size = 200;

%Extract features
[image_feature] = extractFeatures(image_dir, data_dir, image_cate_use, image_size);

%One-Versus-All classification

train_size = 130;
for i = 1 : 1
    [train_instance train_label test_instance test_label] = ...
        splitData(image_feature,i, train_size);
    model = train(train_label, train_instance);

    [predicted_label, accuracy, dump] = predict(test_label, test_instance, model);
end


    
