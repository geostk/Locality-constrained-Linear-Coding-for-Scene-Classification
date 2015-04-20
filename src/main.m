%Set up paths
addpath('./SpatialPyramid');
addpath('./liblinear/matlab');
addpath('./libsvm/matlab');

%Set up data path
image_dir='../dataset/scene_categories';
data_dir='./data200';
train_indice_file = 'f_order.txt';

%empty to use all cates
%image_cate_use = [1,2,3];
image_cate_use = [1:15];
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

%options='-s 3 -c 100 -B 1';
%options='-s 0 -t 2';

train_K = hist_isect(train_instance, train_instance);
test_K = hist_isect(test_instance, test_instance);
train_num = size(train_K,1);
test_num = size(test_K,1);
model= libsvmtrain(train_label, [(1:train_num)', train_K], '-t 4');
[predict_label, accuracy, dump] = ...
             libsvmpredict(test_label, [(1:test_num)', test_K], model);
% train_instance_sparse = sparse(train_instance);
% test_instance_sparse = sparse(test_instance);
% model = libsvmtrain(train_label, train_instance_sparse,options);
% [predicted_label, accuracy, dump] = libsvmpredict(test_label, test_instance_sparse, model);
% 
% confm = confusionmat(test_label,predicted_label);
% 
% nconfm = plotConfusion(cate_names, confm);
% mean_accuracy = trace(nconfm) / 15

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


% %Grid Search for liblinear
% results = zeros(8,1);
% for i = 0 : 7
%     options=['-q -s ' int2str(i)];
%     options
%     model = liblineartrain(train_label, train_instance_sparse,options);
%     [predicted_label, accuracy, dump] = liblinearpredict(test_label, test_instance_sparse, model);
%     confm = confusionmat(test_label, predicted_label);
%     confm = confm./(ones(15,1)*sum(confm,1));
%     results(i+1) = trace(confm)/15;
% end
% 
% 
% %Grid Search for C
% C=[-5 -2 -1 0 1 2 5];
% results = zeros(length(C),1);
% for i = 1 : length(results)
%     options=['-q -c ' num2str(1/2^C(i))];
%     options
%     model = liblineartrain(train_label, train_instance_sparse,options);
%     [predicted_label, accuracy, dump] = liblinearpredict(test_label, test_instance_sparse, model);
%     confm = confusionmat(test_label, predicted_label);
%     confm = confm./(ones(15,1)*sum(confm,1));
%     results(i) = trace(confm)/15;
% end
% 
% % Vary bias
% B=[-1 1];
% results = zeros(length(B),1);
% for i = 1 : length(results)
%     options=['-q -B ' num2str(B(i))];
%     options
%     model = liblineartrain(train_label, train_instance_sparse,options);
%     [predicted_label, accuracy, dump] = liblinearpredict(test_label, test_instance_sparse, model);
%     confm = confusionmat(test_label, predicted_label);
%     confm = confm./(ones(15,1)*sum(confm,1));
%     results(i) = trace(confm)/15;
% end
% 
% % For non-linear kernel
 predicted_label = libsvm_wrapper(train_instance,train_label, test_instance, test_label);
