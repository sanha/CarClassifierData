function [bounding_box] = bounding_box(image_path, parts)
    % TODO: Modify to use multiple images
    I = imread(image_path);
    fig = figure();
    set(fig, 'OuterPosition', [200 100 1300 900]);
    imshow(I);
    bg = uibuttongroup('Visible', 'on', ...
        'Position', [0 0 1 .07], ...
        'SelectionChangedFcn',@(bg,event) bselection(bg,event));
    text_size = [60, 90, 90, 100, 100, 100, 100, 100];
    left_padding = 30;
    
    bounding_box = uint16(zeros(size(parts, 2), 4));
    
    for part=1:size(parts, 2)
        radiobutton(part) = uicontrol(bg, 'Style', 'radiobutton', ...
        'String', parts(part),...
        'FontSize', 15,...
        'Position', [left_padding, 15, left_padding + text_size(part), 35],...
        'HandleVisibility', 'off');
        left_padding = left_padding + text_size(part) + 30;
    end
    
    uicontrol('Style', 'pushbutton', 'String', 'Skip',...
    'Position', [1050 15 100 35], 'Callback', @skip_part);
    uicontrol('Style', 'pushbutton', 'String', 'Finish',...
    'Position', [1180 15 100 35], 'Callback', @save);
    
    selected = 1;
    set(bg, 'SelectedObject', radiobutton(selected));
    r = rectangle('Position', bounding_box(selected,:), 'EdgeColor', 'r');
    while 1
        try
            rect = getrect(fig);
        catch
            break;
        end
        finished = 0;
        if rect
            finished = select_next_radio(rect);
        end
        if finished == 1
            break;
        end
    end
    
    try
        delete(r);
        close(fig);
    catch
    end
    
    function bselection(~,event)
        selected = find(ismember(parts, event.NewValue.String));
        try
            delete(r);
        catch
        end
        r = rectangle('Position', bounding_box(selected,:), 'EdgeColor', 'r');
    end

    

    
    function finished = select_next_radio(rect)
        bounding_box(selected, :) = rect;
        if selected ~= size(parts,2)
            skip_part(1, 1);
            finished = 0;
        else
            finished = 1;
        end

    end

    function save(~, ~)
        try
            delete(r);
            close(fig);
        catch
        end
    end

    function skip_part(~,~)
        if selected ~= size(parts,2)
            selected = selected + 1;
            set(bg, 'SelectedObject', radiobutton(selected));
            try
                delete(r);
            catch
            end
            r = rectangle('Position', bounding_box(selected,:), 'EdgeColor', 'r');
        else
            close(fig);
        end
    end

    
end
    
