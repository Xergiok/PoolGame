classdef vector2d < handle
% 2D vector object inherited from handle superclass

%% Class public properties block
properties(SetAccess = public)
    Coord(1, 2) {mustBeNonempty, mustBeNumeric, mustBeFinite, mustBeReal} = ...
        [0, 0];
end

%% Class dependent properties block
properties(Dependent)
    x(1, 1) double {mustBeNumeric, mustBeFinite, mustBeReal};
    y(1, 1) double {mustBeNumeric, mustBeFinite, mustBeReal};
    Length(1, 1) double {mustBeNonnegative, mustBeFinite};
    UnitVector(1, 2) double {mustBeNumeric, mustBeFinite, mustBeReal};
end

%% Class public methods

methods(Access = public)

    %% Class constructor method
    function this = vector2d(varargin)

        arguments(Repeating)
            varargin {mustBeNonempty, mustBeNumeric, mustBeFinite, mustBeReal};
        end

        narginchk(0, 2);    % 0-3 inputs allowed

        switch nargin   % 2 options for input values (or default)

            case 1  % double array
                this.Coord = varargin{1};

            case 2 % separate values
                this.Coord = [varargin{1}, varargin{2}];
        end

    end    

    % methods of scaling 2d vector by inother vector safely
    function ModulateLength(this, value)

        arguments
            this;
            value(1, 1) double {mustBeNonnegative, mustBeFinite};   % pass only scalar double
        end

        scale = value/this.Length;      % length ratio
        this.Coord = this.Coord*scale;  % scale vector coords

    end

end

%% Dependent components properties
methods % dependent properties

    % get first component (named "x") method
    function value = get.x(this)
        value = this.Coord(1);                  % get Сoord(1) property
    end

    % set first component (named "x") method
    function set.x(this, value)
        this.Coord = [value, this.Coord(2)];    % set Сoord(1) property directly
    end

    % get second component (named "y") method
    function value = get.y(this)
        value = this.Coord(2);                  % get Сoord(2) property
    end

    % set first component (named "y") method
    function set.y(this, value)
        this.Coord = [this.Coord(1), value];    % set Сoord(2) property directly 
    end

    % get length of 2D vector (Coord)
    function value = get.Length(this)
        value = norm(this.Coord);           % via euclidean norm
    end

    % get unit vector of 2D vector (Coord)
    function value = get.UnitVector(this)
        value = this.Coord/this.Length;     % divide by norm (length)
    end

end

%% Operator overloading
methods(Access = public)
    
    % cast to double
    function value = double(this)

        if ~isscalar(this)
            cellObj = arrayfun(@(obj) obj.Coord, this, 'UniformOutput', false);
            value = cell2mat(cellObj);
        else
            value = this.Coord;
        end
    end

    % plus method override
    function value = plus(obj1, obj2)
        value = double(obj1) + double(obj2);
    end

    % minus method override
    function value = minus(obj1, obj2)
        value = double(obj1) - double(obj2);
    end

    % uminus method override
    function value = uminus(obj)
        value = -obj.Coord;
    end

    % uplus method override
    function value = uplus(obj)
        value = +obj.Coord;
    end

    % times method override
    function value = times(obj1, obj2)
        value = double(obj1) * double(obj2);
    end

    % mtimes method override
    function value = mtimes(obj1, obj2)
        value = double(obj1) .* double(obj2);
    end

    % rdivide method override
    function value = rdivide(obj1, obj2)
        value = double(obj1) ./ double(obj2);
    end

    % ldivide method override
    function value = ldivide(obj1, obj2)
        value = double(obj1) .\ double(obj2);
    end

    % mrdivide method override
    function value = mrdivide(obj1, obj2)
        value = double(obj1) / double(obj2);
    end

    % mldivide method override
    function value = mldivide(obj1, obj2)
        value = double(obj1) \ double(obj2);
    end

    % power method override
    function value = power(obj1, obj2)
        value = double(obj1) .^ double(obj2);
    end

    % mpower method override
    function value = mpower(obj1, obj2)
        value = double(obj1) ^ double(obj2);
    end

    % ctranspose method override
    function value = ctranspose(obj)
        value = (obj.Coord)';
    end

    % transpose method override
    function value = transpose(obj)
        value = (obj.Coord).';
    end  

    % horzcat method override
    function value = horzcat(obj1, obj2)
        value = [double(obj1), double(obj2)];
    end

    % vertcat method override
    function value = vertcat(obj1, obj2)
        value = [double(obj1); double(obj2)];
    end   

    % isnan method override
    function TF = isnan(obj)
        TF = all(isnan(obj.Coord));
    end

end

methods(Static)

        % convert some types of input to double objects
        function out = ToVector(varargin)

        arguments(Repeating)
            varargin {mustBeNonempty};  % cell array of objects
        end

        narginchk(1, 2);    % vector2d object or 1-2 doubles  is expected

        msg = 'Not supported input!';

        if nargin == 1 && isa(varargin{1}, 'vector2d')
            try
                out = double(varargin{1});      % cast vector2d to double
            catch
                error(msg);
            end
        else

            try
                input_val = cell2mat(varargin); % convert cell to array
                input_val = double(input_val);  % cast to double
                out = input_val;                
            catch
                error(msg);
            end
        end

    end

end
    
end

