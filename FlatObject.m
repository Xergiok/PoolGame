classdef (Abstract) FlatObject < handle
% class for drawing a flat object in figure and common methods for implementation

%% Class protected properties block
properties(SetAccess = protected)
    FigureHandle(1,1) {mustBeNonempty};
    GraphicHandle(1,1) {mustBeNonempty};
    Origin(1, 1) vector2d {mustBeNonempty} = ...
        vector2d(0);
end

%% Class public methods block
methods

    % class constructor method
    function this = FlatObject(fig, origin)

        arguments
            fig(1, 1) {mustBeNonempty, mustBeFigureHandle};
            origin(1, 2) double {mustBeNonempty, mustBeFinite} = ...
                0;
        end

        this.FigureHandle = fig;                        % saves figure handle
        this.Origin = vector2d(origin);
        gobj = this.CreateObject(this.FigureHandle);    % creates grafics object on figure
        mustBeGraphicsHandle(gobj);                     % handle validation
        this.GraphicHandle = gobj;                      % saves grafics object

    end

    % class destructor method
    function delete(this)
        % this is always scalar
        
        delete(this.Origin);
        delete(this.GraphicHandle);
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
