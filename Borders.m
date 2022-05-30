classdef Borders < FlatObject

%% Class protected properties block
properties(SetAccess = protected)

    xdim(1, 1) double {mustBeNonempty, mustBePositive, mustBeFinite} = ...
        300;
    ydim(1, 1) double {mustBeNonempty, mustBePositive, mustBeFinite} = ...
        140;

end

properties(Dependent)
    
    halfx(1, 1) double {mustBeNonempty, mustBePositive, mustBeFinite};
    halfy(1, 1) double {mustBeNonempty, mustBePositive, mustBeFinite};

end

%% Class public methods block
methods

    function value = get.halfx(this)
        value = 0.5*this.xdim;
    end

    function value = get.halfy(this)
        value = 0.5*this.ydim;
    end

end

methods(Access = protected)

    % method for updating graphics object
    function ghandle = CreateObject(this, fig)

        ghandle = this.DrawBorders(fig);
        
    end

end


methods(Access = public)

    % method for updating graphics object
    function this = UpdateGraphics(this)

        this.GraphicHandle = Borders.DrawBorders(this.FigureHandle);

    end


    function gobj = DrawBorders(this, fig)

        origin = -[this.halfx, this.halfy];
        lims = [origin, this.xdim, this.ydim];
        ax = gca;
        
        gobj = rectangle(ax, 'Position', lims, 'Curvature', 0);

        axis equal;

    end

    function [TF, comp] = CheckCollision(this, point, radius)

        point = abs(point);
        half = [this.halfx, this.halfy];
        comp = point +  radius >= half;
        TF = any(comp);

    end

    function value = GetBorders(this)
        value = [this.halfx this.halfy];
    end

end

%% Class static methods block
methods(Static)
end

end