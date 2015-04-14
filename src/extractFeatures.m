function [result] = extractFeatures(image_dir, data_dir, image_cate_use, image_cate_size)
% Extract feature from images
% Input: image_dir - image base dir
%        data_dir - feature output dir
%        image_cate_use - which categories will be used
%        image_cate_size - how many images per category will be selected
% Output: features

image_dir_list = dir(image_dir);
image_dir_list = image_dir_list(3:end);

result = cell(length(image_cate_use));

for i = 1 : length(image_cate_use)
    cate_name = image_dir_list(i).name;
    
    sub_image_dir = [image_dir '/' cate_name]
    sub_data_dir = [data_dir '/' cate_name]
    
    disp(['[' datestr(now) ']-Processing ' i ':' cate_name]);
    %Select top image_cate_size files
    fnames = dir(fullfile(sub_image_dir, '*.jpg'));
    num_files = image_cate_size;
    filenames = cell(num_files,1);

    for f = 1:num_files
        filenames{f} = fnames(f).name;
    end
    
    pyramid_feature = BuildPyramid(filenames,sub_image_dir,sub_data_dir);
    result{1} = pyramid_feature;
end