function [] = bounding_box()
% TODO: Modify to use multiple images
I = imread('bmw10/bmw10_ims/3/150197528.jpg');
fig = figure();
imshow(I);
uicontrol('Style', 'pushbutton', 'String', 'Save',...
    'Position', [20 20 100 40], 'Callback', @save);
uicontrol('Style', 'pushbutton', 'String', 'Cancel',...
    'Position', [140 20 100 40], 'Callback', @cancel);
rect = [];
while 1
    rect = getrect(fig);
    r = rectangle('Position', rect, 'EdgeColor', 'r');
    uiwait(fig);
    delete(r);
    if rect
        break;
    end
end

% TODO: save coordinate in a proper format
disp(rect);

    function [] = save(~, ~)
        uiresume();
    end
    function [] = cancel(~, ~)
        rect = [];
        uiresume();
    end
end