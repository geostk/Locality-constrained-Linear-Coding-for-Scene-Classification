<<<<<<< HEAD
function [result, train_indices, cate_names] = extractFeatures(image_dir, data_dir, image_cate_use, ...
=======
function [result, train_indices, names] = extractFeatures(image_dir, data_dir, image_cate_use, ...
>>>>>>> f78ca5aff87104c5792e10ebb3123b99bf8e3c5c
    image_cate_size, feature_type, params, train_indice_file)
% Extract feature from images
% Input: image_dir - image base dir
%        data_dir - feature output dir
%        image_cate_use - which categories will be used, if empty, use all
%        image_cate_size - how many images per category will be selected
%                  if -1, use all images
%        feature_type - 0: nonLLC 1: LLC
% Output: features
if feature_type == 1
    data_dir = [data_dir 'LLC'];
end

image_dir_list = dir(image_dir);
image_dir_list = image_dir_list(3:end);

if isempty(image_cate_use)
    image_cate_use = 1:length(image_dir_list);
end

result = cell(length(image_cate_use));
train_indices = cell(length(image_cate_use));

calcFullDictionary(image_dir, data_dir, image_cate_use, image_cate_size, feature_type, params, train_indice_file);

temp_indices = importdata([fileparts(data_dir),'/', train_indice_file]);
cate_names = cell(length(image_cate_use));
for i = 1 : length(image_cate_use)
    cate_name = image_dir_list(image_cate_use(i)).name;
    cate_names{i} = cate_name;
    sub_image_dir = [image_dir '/' cate_name];
    sub_data_dir = [data_dir '/' cate_name];
    
    disp(['[' datestr(now) ']-Processing ' i ': ' cate_name]);
    %Select top image_cate_size files
    fnames = dir(fullfile(sub_image_dir, '*.jpg'));
    num_files = image_cate_size;
    if image_cate_size == -1
        num_files = length(fnames);
    end
    
    filenames = cell(num_files,1);

    for f = 1:num_files
        filenames{f} = fnames(f).name;
    end
    if feature_type == 0
        pyramid_feature = BuildPyramid(filenames,sub_image_dir,sub_data_dir, params);
    else
        pyramid_feature = BuildPyramidLLC(filenames,sub_image_dir,sub_data_dir,params);
    end
    result{i} = pyramid_feature;  
    
    %read training indices
    train_indices{i} = temp_indices(((i-1)*params.numTextonImages + 1) : i*params.numTextonImages);
    train_indices{i}(1:10)
end
