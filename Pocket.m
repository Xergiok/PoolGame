classdef Pocket < FlatObject

%% Class protected properties block
properties(SetAccess = protected)

    Radius(1, 1) double {mustBePositive, mustBeFinite} = ...
        10;

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

        this.GraphicHandle = this.DrawBorders(this.FigureHandle);

    end


    function gobj = DrawBorders(this, fig)

        origin = this.Origin - this.Radius;
        rd = [this.Radius, this.Radius] * 2;
        lims = [origin, rd];
        ax = gca;
        
        gobj = rectangle(ax, 'Position', lims, 'Curvature', 1, ...
            'FaceColor', [0.55 0.25 0], 'EdgeColor', 'k', 'LineWidth', 0.5);

        axis equal;

    end

    function TF = CheckPocket(this, location)

        TF = false;
        margin = 0;

        if (norm(this.Origin - location) <= this.Radius + margin)

            TF = true;

        end

%         A = GetCorners(this.Origin, this.Radius);
%         B = GetCorners(origin, radius);
%         area = rectint(A, B);
% 
%         function corners = GetCorners(origin, radius)
% 
%             corners = origin - radius;
%             diameter = origin + radius;
%             corners = [corners, diameter];
% 
%         end

    end

end

end