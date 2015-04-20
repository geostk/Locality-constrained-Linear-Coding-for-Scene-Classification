function [confm_normalize] = plotConfusion( cate_names, confm )

confm_normalize = confm;
for i=1:size(cate_names,1)
    confm_normalize(i,:) = confm(i,:)/sum(confm(i,:));
end

imagesc(confm_normalize)
textStrings = num2str(confm_normalize(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1:15);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(confm_normalize(:) < midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

set(gca,'XTick',1:15, ...
    'YTick',1:15, ...
    'XTickLabel', cate_names, ...
    'YTickLabel', cate_names);

xticklabel_rotate([],45,[]);

figure;
imagesc(confm)
textStrings = num2str(confm(:),'%d');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1:15);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(confm(:) < midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

set(gca,'XTick',1:15, ...
    'YTick',1:15, ...
    'XTickLabel', cate_names, ...
    'YTickLabel', cate_names);

xticklabel_rotate([],45,[]);

end