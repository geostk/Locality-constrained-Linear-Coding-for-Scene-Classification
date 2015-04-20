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
image_cate_use = [];
%-1 : use all images
image_size = -1;

params.dictionarySize = 200;
params.K = 5;
params.pyramidLevels = 3;
params.pfig = 0;

% feature_type = 0, nonLLC; 1, LLC.
feature_type = 0;

train_size = 100;
params.numTextonImages = train_size;
params.canSkip = 1;

%Extract features
[image_data, train_indices, cate_names] = extractFeatures(image_dir, data_dir, image_cate_use, image_size, feature_type, params, train_indice_file);

cate_names = cate_names(:,1);

[train_instance, train_label, test_instance, test_label] = splitData(image_data, train_size, train_indices);

%options='-s 4 -c 1 -B 1';
options='';
train_instance_sparse = sparse(train_instance);
test_instance_sparse = sparse(test_instance);
model = liblineartrain(train_label, train_instance_sparse,options);
[predicted_label, accuracy, dump] = liblinearpredict(test_label, test_instance_sparse, model);

confm = confusionmat(test_label,predicted_label);

nconfm = plotConfusion(cate_names, confm);
return;




    
