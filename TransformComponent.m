classdef TransformComponent < handle

%% Class protected properties block
properties(SetAccess = protected)

    Location(1,1) vector2d {mustBeNonempty} = ...
        vector2d(0, 0);
%     Rotation;
%     Scale;

end

%% Class public methods block
methods(Access = public)

    % class constructor method
    function this = TransformComponent(inputs)
        this.Location = vector2d(vector2d.ToVector(inputs));
    end

    function this = SetLocation(this, new_value)
        this.Location.Coord = new_value;
    end

    function this = AddLocation(this, value)
        this.Location.Coord = this.Location.Coord + value;
    end

end

methods(Abstract, Access = protected)

    UpdateLocation(this);

end

end
