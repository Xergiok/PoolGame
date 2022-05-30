classdef PoolBall < FlatActor & Ball_Phys

%% Class protected properties block
properties(SetAccess = protected)
    Vertexes(2, :) {mustBeNonempty, mustBeNumeric, mustBeFinite} = ...
        [0; 0];
end

%% Class public properties block
properties(SetAccess = public)
    Color(1, 3) double = ...
        [1 0 0];
end

%% Class constant properties block
properties(Constant)
    CircleSides(1, 1) {mustBeNonempty, mustBePositive, mustBeFinite} = ...
        16; % number of circle patch vertexes - detalization
end

%% Class public methods block
methods

    % class constructor method
    function this = PoolBall(fig, location, ball_params)

        arguments
            fig(1, 1) {mustBeNonempty, mustBeFigureHandle};
            location(1, :) {mustBeNonempty} = [0, 0];
            ball_params(1, 1) = Ball_Phys;
        end

        this = this@FlatActor(fig, location);   % FlatActor constructor
        this.CopyParams(ball_params);           % Copy parameters to new object
%         this.Velocity = vector2d(0);
        

    end

end

%% Class protected methods block
methods(Access = protected)

    % method for updating graphics object
    function ghandle = CreateObject(this, fig)
        
        % calculate radians
        th = linspace(0, 2*pi * (PoolBall.CircleSides - 1) / PoolBall.CircleSides, PoolBall.CircleSides);

        % save vertexes positions
        this.Vertexes = this.Radius* [cos(th); sin(th)];

        initial = this.FindVertexes;

        ghandle = this.DrawBall(initial);

    end

end

%% Class public methods block
methods(Access = public)

    % method for updating graphics object
    function UpdateObject(this, time_step, borders, balls)

        if this.bMoving

            this.UpdateLocation(time_step, borders, balls);
            this.UpdateGraphics();

        end

    end

    % sum all vetexes positions with gobject location
    function vertexes = FindVertexes(this)
        vertexes = this.Vertexes + this.Location';
    end

    % method for updating graphics object
    function this = UpdateGraphics(this)

        pos = this.FindVertexes;
        set(this.GraphicHandle, "XData", pos(1, :), "YData", pos(2, :));

    end

end

methods(Access = protected)

    function gobj = DrawBall(this, XY)

        ax = this.FigureHandle.CurrentAxes;
        gobj = patch(ax, XY(1, :), XY(2, :), this.Color, 'EdgeColor', "none");

    end

    function UpdateLocation(this, at_time, borders, balls)

        % movement equation
        predict = this.Location + this.Velocity*at_time;    % save new location

        % return true if outside borders including ball radius
        % also returns vector corresponding to borders (abs(normal))
        [bCollide, Comp] = borders.CheckCollision(predict, this.Radius);

        if bCollide
            bias = Comp.*sign(predict); % finding normal by quadrant location

            % calculate sweep location including radius
            before_collision = borders.GetBorders.*bias + this.Radius.*(-bias) + predict.*(~Comp);


            refl = this.Velocity*(-Comp*2 + 1) * (1 - GlobalConstants.BorderLoos);
            this.SetVelocity(refl);

            diff = norm(predict - before_collision);
            predict = diff*this.GetUnitVelocity + before_collision;

        end


        for i = 1:size(balls, 2)

            if (norm(this.Location - balls(i).Location) <= this.Radius + balls(i).Radius)

                ball = balls(i);

                % Compute angles:
                alfa1 = atan2(ball.Location.y - this.Location.y, ball.Location.x - this.Location.x);
                beta1 = atan2(this.Velocity.y, this.Velocity.x);
                gamma1 = beta1 - alfa1;

                alfa2 = atan2(this.Location.y - ball.Location.y, this.Location.x - ball.Location.x);
                beta2 = atan2(ball.Velocity.y, ball.Velocity.x);
                gamma2 = beta2 - alfa2;

                % Compute norm of vectors after decomposition
                u12 = this.Speed*cos(gamma1);
                u11 = this.Speed*sin(gamma1);

                u21 = ball.Speed*cos(gamma2);
                u22 = ball.Speed*sin(gamma2);

                % Compute norm of sub vectors after collision
                msum = this.Mass + ball.Mass;
                msubs = this.Mass - ball.Mass;
                v12 = ( (msubs)*u12 - 2*ball.Mass*u21 ) / msum;
                v21 = ( (msubs)*u21 + 2*this.Mass*u12 ) / msum;

                % Compute velocities after collision
                V1 = u11 * [-sin(alfa1), cos(alfa1)] + v12 * [cos(alfa1), sin(alfa1)];
                V2 = u22 * [-sin(alfa2), cos(alfa2)] - v21 * [cos(alfa2), sin(alfa2)];
                
                this.SetVelocity(V1);
                ball.SetVelocity(V2);

            end

        end

        % update location
        this.SetLocation(predict);

        forces = SlidingFriction + RollingFricion;             % get forces
        this.ModifyVelocity(abs(forces))    % apply forces

        % returns amount of sliding friction force applied
        function output = SlidingFriction()

            output = 0;

            if this.Speed > 0   % only for moving
                % FrictionForce = - FrictionCoef *g * VelocityUnitVector
                output = -GlobalConstants.SlidingFriction * GlobalConstants.g * this.GetUnitVelocity;
                coef = max(0, this.Speed/this.Threshold_Max);
                output = output*coef;
            end
            
        end

        function output = RollingFricion()

            output = 0;

            if this.Speed > 0   % only for moving
                % FrictionForce = - FrictionCoef / R * g * VelocityUnitVector
                output = -GlobalConstants.RollingFriction / this.Radius * GlobalConstants.g * this.GetUnitVelocity;
                coef = 1 - min(0.7, this.Speed/this.Threshold_Max);
                output = output*coef;
            end

        end
      
    end

end

end

