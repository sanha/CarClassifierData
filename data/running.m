parts = {'grill', 'headlight', 'backlight', 'side_glass', 'front_view', 'back_view'};

root_path = 'raw';

car_list = dir(root_path);

for idx=3:size(car_list, 1)
    dir_path = fullfile(root_path, car_list(idx).name);
    images = dir(dir_path);
    
    for imgIdx=3:size(images, 1)
        bbox = bounding_box(fullfile(dir_path, images(imgIdx).name), parts);
        str = strsplit(dir_path, {'/', '\'});
        
        file_name = strcat(str(end), '-', num2str(imgIdx-2));
        file_name = file_name{1};
        
        write_xml(file_name, parts, bbox);
    end        
end
   