classdef Controller < handle

%% Class public properties block
properties
    FigureHandle;
end

methods

    function this = Controller(fig)

        arguments
            fig(1, 1) {mustBeNonempty, mustBeFigureHandle};
        end

        this.FigureHandle = fig;
    end

end
% 
% methods(Abstract, Access = public)
% 
%     GetMousePosition(ax)
% 
%     OnMouseDown(~, ~)
% 
%     OnMouseUp(~, ~)
% 
%     OnMouseMove (~, ~)
% 
%     OnKeyDown(~, ko)
% 
%     OnFigureClose(~, ~)
% 
% end

end

