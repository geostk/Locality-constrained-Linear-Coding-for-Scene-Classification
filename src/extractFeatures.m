function [result] = extractFeatures(image_dir, data_dir, image_cate_use, ...
    image_cate_size, feature_type, params)
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

for i = 1 : length(image_cate_use)
    cate_name = image_dir_list(image_cate_use(i)).name;
    
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
end