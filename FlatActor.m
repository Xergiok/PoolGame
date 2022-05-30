classdef (Abstract) FlatActor < FlatObject & TransformComponent  & MovementComponent
% subclass handle of FlatObject with movement on screen

%% Class public methods block
methods(Access = public)

    % class constructor method
    function this = FlatActor(fig, location)

        this = this@TransformComponent(location);   % calls Transform comp constructor
        this = this@FlatObject(fig);                % calls FlatObject constructor

    end

end

end

