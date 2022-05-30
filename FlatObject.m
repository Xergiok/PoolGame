classdef (Abstract) FlatObject < handle
% class for drawing a flat object in figure and common methods for implementation

%% Class protected properties block
properties(SetAccess = protected)
    FigureHandle(1,1) {mustBeNonempty};
    GraphicHandle(1,1) {mustBeNonempty};
end

%% Class public methods block
methods(Access = public)

    % class constructor method
    function this = FlatObject(fig)

        arguments
            fig(1, 1) {mustBeNonempty, mustBeFigureHandle};
        end

        this.FigureHandle = fig;                        % saves figure handle
        gobj = this.CreateObject(this.FigureHandle);    % creates grafics object on figure
        mustBeGraphicsHandle(gobj);                     % handle validation
        this.GraphicHandle = gobj;                      % saves grafics object

    end

end

methods(Abstract, Access = protected)

    % method for creating graphics object
    ghandle = CreateObject(this, fig);

end

methods(Abstract, Access = public)

    % method for updating graphics object
    this = UpdateGraphics(this);

end

%% Class abstract methods block
methods(Static)
end

end
