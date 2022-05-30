classdef MovementComponent < handle

%% Class protected properties block
properties(SetAccess = protected)

    Velocity(1,1) vector2d {mustBeNonempty} = ...
        vector2d(0);
    bMoving(1,1) logical {mustBeNonempty} = ...
        false;

end

%% Class dependent properties block
properties(Dependent)

    Speed;  % speed = Euclidean norm of velocity vector

end

%% Class public properties block
properties(SetAccess = public)

    Threshold_Min(1, 1) double {mustBeNonempty, mustBePositive} = 1e-2;
    Threshold_Max(1, 1) double {mustBeNonempty, mustBePositive} = 1000;
    
end

%% Class public methods block
methods

    % class constructor method
    function this = MovementComponent(initial_value)

        arguments
            initial_value(1, :) double {mustBeNonempty} = ...
                0;  % not moving at start by default
        end

        this.Velocity = vector2d(0);
        this.SetVelocity(initial_value); % set initial value
    end

    % method for calculating speed
    function value = get.Speed(this)
        value = this.Velocity.Length;   % length of 2D vector
    end

    % method for calculating unit vector
    function value = GetUnitVelocity(this)
        value = this.Velocity.UnitVector;   % vector/length
    end

%     function TF = IsMoving(this)
%         TF = this.Speed > 0;
%     end
% 
%     function TF = IsNotMoving(this)
%         TF = this.Speed == 0;
%     end

end

methods(Access = public)

    % main protected property setter with validation
    function SetVelocity(this, new_vel)

        arguments
            this;
            new_vel(1, 2) double {mustBeNonempty};
        end

        new_speed = norm(new_vel);  % get Euclidean norm of input vector

        if new_speed <= this.Threshold_Min      % case less than limit

            this.Velocity.Coord = 0;
            this.bMoving = false;

        elseif new_speed >= this.Threshold_Max  % case above limit

            this.Velocity.Coord = new_vel * this.Threshold_Max/new_speed;
            this.bMoving = true;

        else                                    % case in range

            this.Velocity.Coord = new_vel;
            this.bMoving = true;

        end

    end

    % add 2D vector to velocity
    function AddVelocity(this, value)

        arguments
            this
            value(1, :) double {mustBeNonempty};  % double vector input
        end

        this.SetVelocity(this.Velocity + value);
    end

    % safe modulate velocity vector
    function ModifyVelocity(this, value)
        ratio = 1 - value./abs(this.Velocity.Coord);
        modifier = max(ratio, 0);
        this.SetVelocity(this.Velocity*modifier);
    end

end

methods(Access = private)

    function SetMovingState(this, state)

        arguments
            this;
            state(1, 1) logical {mustBeNonempty};
        end

        this.bMoving = state;

    end

end

end
