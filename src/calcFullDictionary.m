function calcFullDictionary(image_dir, data_dir, image_cate_use, image_cate_size, ...
    feature_type, params, train_indice_file)

    if(~isfield(params,'oldSift'))
        params.oldSift = false;
    end
    if(~isfield(params,'K'))
        params.K = 5;
    end
    if(~exist('canSkip','var'))
        canSkip = 1;
    end
    if(~exist('saveSift','var'))
        saveSift = 1;
    end
       
    image_dir_list = dir(image_dir);
    image_dir_list = image_dir_list(3:end);
    if isempty(image_cate_use)
        image_cate_use = 1:length(image_dir_list);
    end
    
    for i = 1 : length(image_cate_use)
        cate_name = image_dir_list(image_cate_use(i)).name;
        
        sub_image_dir = [image_dir '/' cate_name];
        sub_data_dir = [data_dir '/' cate_name];
        
        fnames = dir(fullfile(sub_image_dir, '*.jpg'));
        num_files = image_cate_size;
        if image_cate_size == -1
            num_files = length(fnames);
        end

        filenames = cell(num_files,1);

        for f = 1:num_files
            filenames{f} = fnames(f).name;
        end
        
        pfig = sp_progress_bar('Generating sift');
        if(saveSift)
            GenerateSiftDescriptors(filenames, sub_image_dir, sub_data_dir, params, canSkip, pfig);
        end
        close(pfig);
    end
    
    % check if the dictionary has been generated
    cate_name = image_dir_list(image_cate_use(1)).name;
    check_sub_data_dir = [data_dir '/' cate_name];
    
    checkDirName = fullfile(data_dir, sprintf('dictionary_%d.mat', params.dictionarySize));
    if(exist(checkDirName,'file')~=0)
        fprintf('Dictionary file %s already exists.\n', checkDirName);
        return;
    end
    
    totalR = [];
    
    [pathstr, name, ext] = fileparts(data_dir);
    checkfileOrder = fullfile(pathstr, 'f_order.txt');
    if(exist(checkfileOrder,'file')~=0)
        totalR = load(checkfileOrder, '-ascii');
        fprintf('total file order for dic exists.\n');
    else
        for i = 1 : length(image_cate_use)
            cate_name = image_dir_list(image_cate_use(i)).name;
            sub_image_dir = [image_dir '/' cate_name];
            sub_data_dir = [data_dir '/' cate_name];
            fnames = dir(fullfile(sub_image_dir, '*.jpg'));
            num_files = image_cate_size;
            if image_cate_size == -1
                num_files = length(fnames);
            end

            filenames = cell(num_files,1);

            for f = 1:num_files
                filenames{f} = fnames(f).name;
            end
            inFName = fullfile(sub_data_dir, 'f_order.txt');
            if ~isempty(dir(inFName))
                R = load(inFName, '-ascii');
                if(size(R,2)~=length(filenames))
                    R = randperm(length(filenames));
                    sp_make_dir(inFName);
                    save(inFName, 'R', '-ascii');
                end
                totalR = [totalR R(1:params.numTextonImages)];
            else
                R = randperm(length(filenames));
                sp_make_dir(inFName);
                save(inFName, 'R', '-ascii');
                totalR = [totalR R(1:params.numTextonImages)];
            end
        end

        % output total file order
        outputfileOrder = fullfile(data_dir, 'total_f_order.txt');
        save(outputfileOrder, 'totalR', '-ascii');
    end
    train_size = size(totalR, 2);
    filenames = cell(train_size,1);
    for i = 1 : length(image_cate_use)
        cate_name = image_dir_list(image_cate_use(i)).name;
        sub_image_dir = [image_dir '/' cate_name];
        sub_data_dir = [data_dir '/' cate_name];
        fnames = dir(fullfile(sub_image_dir, '*.jpg'));
        subR = totalR(((i - 1) * params.numTextonImages + 1) : i * params.numTextonImages);
        for f = 1:params.numTextonImages
            filenames{(i - 1) * params.numTextonImages + f} = [cate_name '/' fnames(subR(f)).name];
        end
    end
    
    oldnumTextonImages = params.numTextonImages;
    params.numTextonImages = length(image_cate_use) * params.numTextonImages;
    pfig = sp_progress_bar('Building Full Dictionary');
    CalculateDictionary(filenames, image_dir, data_dir, '_sift.mat', params, 1, pfig);
    params.numTextonImages = oldnumTextonImages;
    close(pfig);
end