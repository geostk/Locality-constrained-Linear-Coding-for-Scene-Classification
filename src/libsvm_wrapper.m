function [ predicted_label ] = libsvm_wrapper( train_instance,train_label,test_instance,test_label)

    
    numClasses=max(test_label);
    predicted_label = zeros(length(test_instance(:,1)),1);

    for k=1:numClasses
        display(['Training Model #',num2str(k)]); 
        models{k} = svmtrain(train_instance,double(train_label==k),'kernel_function',@hist_isect);
    end
    display(['Begin Testing']);
    for j=1:length(test_label)
        label = randi(numClasses,1);
        for k=1:numClasses
            if(svmclassify(models{k},test_instance(j,:))) 
                label = k;
                break;
            end
        end
        predicted_label(j) = label;
    end

end
