function write_xml(image_name, parts, bounding_box)
    docNode = com.mathworks.xml.XMLUtils.createDocument('annotation')
    docRootNode = docNode.getDocumentElement;
    
    thisElement = docNode.createElement('folder');
    thisElement.appendChild(docNode.createTextNode('car'));
    docRootNode.appendChild(thisElement);

    thisElement = docNode.createElement('filename');
    thisElement.appendChild(docNode.createTextNode(strcat(image_name, '.jpg')));
    docRootNode.appendChild(thisElement);
    
    for i=1:size(parts, 2)
        if bounding_box(i, 3) == 0 || bounding_box(i, 4) == 0
            continue;
        end
        
        object = docNode.createElement('object'); 
        
        name = docNode.createElement('name');
        name.appendChild(docNode.createTextNode(parts{i}));
        
        bndbox = docNode.createElement('bndbox');
        xmin = docNode.createElement('xmin');
        ymin = docNode.createElement('ymin');
        xmax = docNode.createElement('xmax');
        ymax = docNode.createElement('ymax');
        xmin.appendChild(docNode.createTextNode(num2str(bounding_box(i, 1))));
        ymin.appendChild(docNode.createTextNode(num2str(bounding_box(i, 2))));
        xmax.appendChild(docNode.createTextNode(num2str(bounding_box(i, 1)+bounding_box(i, 3))));
        ymax.appendChild(docNode.createTextNode(num2str(bounding_box(i, 2)+bounding_box(i, 4))));
        bndbox.appendChild(xmin);
        bndbox.appendChild(ymin);
        bndbox.appendChild(xmax);
        bndbox.appendChild(ymax);
        
        object.appendChild(name);
        object.appendChild(bndbox);
        
        docRootNode.appendChild(object);
    end
    xmlFileName = [image_name,'.xml'];
    full_path = fullfile('Annotations', xmlFileName);
    xmlwrite(full_path,docNode);
%     type(xmlFileName);
end