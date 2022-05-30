classdef Borders2 < FlatObject

%% Class protected properties block
properties(SetAccess = protected)

    Origin(1, 1) vector2d {mustBeNonempty} = ...
        vector2d(0);
    Radius(1, 1) double {mustBePositive, mustBeFinite} = ...
        3;

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

        this.GraphicHandle = Borders2.DrawBorders(this.FigureHandle);

    end


    function gobj = DrawBorders(this, fig)

        origin = this.Origin*this.Radius;
        lims = [origin, this.Radius, this.Radius];
        ax = gca;
        
        gobj = rectangle(ax, 'Position', lims, 'Curvature', 1, ...
            'FaceColor', [0.55 0.25 0], 'EdgeColor', 'k', 'LineWidth', 0.5);

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