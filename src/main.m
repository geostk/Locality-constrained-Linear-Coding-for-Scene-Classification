%Set up paths
addpath('./SpatialPyramid');
addpath('./liblinear/matlab');
addpath('./libsvm/matlab');

%Set up data path
image_dir='../dataset/scene_categories';
data_dir='./data2048';
train_indice_file = 'f_order.txt';

%empty to use all cates
%image_cate_use = [1,2,3];
image_cate_use = [1:15];
%-1 : use all images
image_size = -1;

params.dictionarySize = 2048;
params.K = 5;
params.pyramidLevels = 3;
params.pfig = 0;

% feature_type = 0, nonLLC; 1, LLC.
feature_type = 1;

train_size = 100;
params.numTextonImages = train_size;
params.canSkip = 1;

%Extract features
[image_data, train_indices, cate_names] = extractFeatures(image_dir, data_dir, image_cate_use, image_size, feature_type, params, train_indice_file);

cate_names = cate_names(:,1);

[train_instance, train_label, test_instance, test_label] = splitData(image_data, train_size, train_indices);

options='-s 3 -c 10 -B 1';
%options='-s 0 -t 2';

train_instance_sparse = sparse(train_instance);
test_instance_sparse = sparse(test_instance);
model = liblineartrain(train_label, train_instance_sparse,options);
[predicted_label, ~, ~] = liblinearpredict(test_label, test_instance_sparse, model);

confm = confusionmat(test_label,predicted_label);

nconfm = plotConfusion(cate_names, confm);
mean_accuracy = trace(nconfm) / 15
return;

%for kernel
 predicted_label = libsvm_wrapper(train_instance,train_label, test_instance, test_label);

         
%For grid search
% outputFile = fopen('grid_result.txt', 'w');
% svm_type = [0 : 5];
% C = [0.01, 0.1, 1, 10, 100];
% bias = [- 1, 1];
% type_length = length(svm_type);
% C_length = length(C);
% bias_length = length(bias);
% results = cell(length(type_length * C_length * bias_length));
% count = 1;
% for i = 1 : type_length
%     for j = 1 : C_length
%         for k = 1 : bias_length
%             options = ['-q -s ' num2str(svm_type(i)) ' -c ' num2str(C(j)) ' -B ' num2str(bias(k))]
%             train_instance_sparse = sparse(train_instance);
%             test_instance_sparse = sparse(test_instance);
%             model = liblineartrain(train_label, train_instance_sparse,options);
%             [predicted_label, accuracy, dump] = liblinearpredict(test_label, test_instance_sparse, model);
% 
%             confm = confusionmat(test_label,predicted_label);
% 
%             nconfm = plotConfusion(cate_names, confm);
%             mean_accuracy = trace(nconfm) / 15
%             
%             %results{count} = [options '\t' num2str(mean_accuracy)]
%             fprintf(outputFile, '%s\t%.4f\n', options, mean_accuracy);
%         end
%     end
% end

return;

