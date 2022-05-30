classdef Ball_Phys < handle

%% Class public properties block
properties
    Mass(1, 1) {mustBeNumeric, mustBePositive, mustBeFinite} = ...
        160; % weight in grams
    Radius(1, 1) {mustBeNumeric, mustBePositive, mustBeFinite} = ...
        2.85;  % radius in centimeters
end

%% Class constant properties block
properties(Constant)
    UnitMultiplier = struct('Mass', 0.001 , 'Radius', 0.01);
end

%% Class public methods block
methods

    % class constructor method
    function this = Ball_Phys(params)

        arguments
            params.Mass {mustBePositive, mustBeFinite};
            params.Radius {mustBePositive, mustBeFinite};
        end

        if isfield(params, 'Mass')
            this.Mass = params.Mass;
        end

        if isfield(params, 'Radius')
            this.Radius = params.Radius;
        end

    end

    function cellst = Convert2Cell(this)

        objst = struct(this);
        objst = rmfield(objst, 'UnitMultiplier');
        cellst = [fieldnames(objst).'; struct2cell(objst).'];

    end

    function this = CopyParams(this, obj)

        arguments
            this;
            obj(1, 1) Ball_Phys;
        end

        this.Mass = obj.Mass;
        this.Radius= obj.Radius;

    end

end

methods(Static)
end

end

