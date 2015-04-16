function [pyramid] = test_LLC_pooling(texton_ind)
    params.pyramidLevels = 3;
    params.dictionarySize = 1024;
    
    binsHigh = 2^(params.pyramidLevels-1);
    %% get width and height of input image
    wid = texton_ind.wid;
    hgt = texton_ind.hgt;

    
    %% compute histogram at the finest level
     pyramid_cell = cell(params.pyramidLevels,1);
    pyramid_cell{1} = zeros(binsHigh, binsHigh, params.dictionarySize);

    
    for i=1:binsHigh
        for j=1:binsHigh

            % find the coordinates of the current bin
            x_lo = floor(wid/binsHigh * (i-1));
            x_hi = floor(wid/binsHigh * i);
            y_lo = floor(hgt/binsHigh * (j-1));
            y_hi = floor(hgt/binsHigh * j);
            
            texton_patch = texton_ind.data(((texton_ind.x > x_lo) & (texton_ind.x <= x_hi) & (texton_ind.y > y_lo) & (texton_ind.y <= y_hi)),:);
            size(texton_patch)
            
            % make histogram of features in bin
            pyramid_cell{1}(i,j,:) = max(texton_patch, [], 1);
        end
    end

    %% compute histograms at the coarser levels
    num_bins = binsHigh/2;
    for l = 2:params.pyramidLevels
        pyramid_cell{l} = zeros(num_bins, num_bins, params.dictionarySize);
        for i=1:num_bins
            for j=1:num_bins
                %{
                pyramid_cell{l}(i,j,:) = ...
                pyramid_cell{l-1}(2*i-1,2*j-1,:) + pyramid_cell{l-1}(2*i,2*j-1,:) + ...
                pyramid_cell{l-1}(2*i-1,2*j,:) + pyramid_cell{l-1}(2*i,2*j,:);
                %}
                pyramid_cell{l}(i,j,:) = ...
                max([pyramid_cell{l-1}(2*i-1,2*j-1,:), pyramid_cell{l-1}(2*i,2*j-1,:) ...
                pyramid_cell{l-1}(2*i-1,2*j,:) ,pyramid_cell{l-1}(2*i,2*j,:)]);
            end
        end
        num_bins = num_bins/2;
    end

    %% stack all the histograms with appropriate weights 1
    pyramid = [];
    for l = 1:params.pyramidLevels-1
        pyramid = [pyramid_cell{l}(:)' pyramid];
    end
    pyramid = [ pyramid_cell{params.pyramidLevels}(:)' pyramid];
    
    pyramid = pyramid./sqrt(sum(pyramid.^2));
end