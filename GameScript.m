function GameScript

close all;
clear all; 
clear class;
clc;

% GM = GameMode.GetInstance;

f = figure(1);

% figure properties
set(f, 'MenuBar', 'none', 'ToolBar', 'none');
axis equal
set(gca, "Xtick", [], "Ytick", []);
xlim("padded");
ylim("padded");
hold on

State = GameState();
Input = Controller(f);

pool_table = Borders(f);

pocket_pos = [150 70; 0 70; -150 70; -150 -70; 0 -70; 150 -70];

for i = 1:size(pocket_pos, 1)
    Pockets(i) = Pocket(f, pocket_pos(i, :));
end

max_time = zeros(1, 100);

PhysParams(1, 2) = Ball_Phys;

Ball_Array(1) = PoolBall(f, vector2d(100, 0), PhysParams(1));
Ball_Array(2) = PoolBall(f, vector2d(-100, 0), PhysParams(2));

Ball_Array(1).AddVelocity([-100 1]);
Ball_Array(2).AddVelocity([-36 -433]);

InitialNum = size(Ball_Array, 2);
Num = InitialNum;

time_step = GlobalConstants.TimeStep;

Controlled = [];
bFixedControl = false;
AuxiliaryLine = gobjects(2, 1);

% setting figure callbacks
set(f, 'WindowButtonDownFcn', @OnMouseDown)
set(f, 'WindowButtonUpFcn', @OnMouseUp)
set(f, 'WindowButtonMotionFcn', @OnMouseMove);
set(f, 'KeyPressFcn', @OnKeyDown);
set(f, 'CloseRequestFcn', @OnFigureClose);

State.Start;

while State.bRunning

    tic;    % start timer

    if any(isvalid(Ball_Array))
        if IsAnyMoving
            for i = 1:Num
                i
                Ball_Array(i).UpdateObject(time_step, pool_table, Ball_Array(Ball_Array ~= Ball_Array(i)));

                for j = 1:6
                    potted = Pockets(j).CheckPocket(Ball_Array(i).Location.Coord);
                    if potted
                        if Controlled == Ball_Array(i)
                            Controlled = [];
                        end
                        delete(Ball_Array(i));
                        Ball_Array(i) = [];
                        Num = Num - 1;
                        i = max(i - 1, 1);
                        last_i = i
                        continue;
                    end
                end

            end
        end
    end

    drawnow;

    elapsed = toc;  % stop timer and get result

    if elapsed > max_time
        max_time = [max_time elapsed];
    end

    pause(time_step - elapsed)


end


function output = CollisionDynamics(AnotherBall)

    output = 0;
    
    dp = this.Location - AnotherBall.Location;
    dp_norm = norm(dp);
    R2 = this.Radius + AnotherBall.Radius;
    dV = this.Velocity - AnotherBall.Velocity;
    
    if (dp_norm < R2)
    
        p_val = GlobalConstants.ElasticityCoef_p*(R2 - dp_norm) * dp/dp_norm;
        V_val = GlobalConstants.ElasticityCoef_v*dV;
        output = p_val - V_val;
    
    end

end

    function TF = IsAnyMoving()

        TF = false;

        if any(isvalid(Ball_Array))

            i = 0;
            for i = 1:Num
                moves(i) = Ball_Array(i).bMoving;
            end

            clear i;

            TF = any(moves);
        end

    end

    function TF = IsAnyControlled()

        TF =  ~isempty(Controlled);

    end


    function pos = GetMousePosition()
        pos = get(gca, 'CurrentPoint');
        pos = pos(1, 1:2);
    end

    function OnFigureClose(~, ~)

        State.Finish;
        delete(f);

    end

    function OnMouseDown(~, ~)

        if ~IsAnyMoving
            pos = GetMousePosition();

            if ~IsAnyControlled
                Controlled = LoopForAll(pos);
            else
                point = pos - Controlled.Location;
                Controlled.AddVelocity(point*10);

                if ishghandle(AuxiliaryLine)
                    set(AuxiliaryLine(1, 1), "Color", 'r', "LineStyle", ':');
                    set(AuxiliaryLine(2, 1), "EdgeColor", 'r');
                end

                if ~bFixedControl   % not fixed controlled ball
                    Controlled = [];
                end
            end
        end

    end

    function OnMouseMove (~, ~)

        if ~IsAnyMoving

            if IsAnyControlled
                pos = GetMousePosition();
                locate =  Controlled.Location.Coord;
                if ishghandle(AuxiliaryLine)
                    set(AuxiliaryLine(1, 1), "XData", [pos(1) locate(1)], ...
                        "YData", [pos(2) locate(2)], "Color", 'b', "LineStyle", '-.');
                    vertx = Controlled.Vertexes + pos';
                    set(AuxiliaryLine(2, 1), "XData", vertx(1, :), "YData", vertx(2, :), 'EdgeColor', 'b');
                else
                    AuxiliaryLine(1, 1) = plot([pos(1) locate(1)], [pos(2) locate(2)], '-.b');
                    vertx = Controlled.Vertexes + pos';
                    AuxiliaryLine(2, 1) = patch("XData", vertx(1, :), "YData", vertx(2, :), ...
                        'EdgeColor', 'b', 'FaceColor','none','LineWidth', 1);
                    

                end

            end
        end

    end

    function OnMouseUp(~, ~)

        if IsAnyControlled
            
        end

    end

    function OnKeyDown(~, ko)
        
        if ko.Key == "f"
            bFixedControl = ~bFixedControl;
        end

    end

    function ball = LoopForAll(point)

        ball = [];
        point = double(point);
        margin = 3;

        if ~isvalid(Ball_Array)
            return;
        end

        for i = 1:Num

            mr = Ball_Array(i).Radius + margin;

            if norm(point - Ball_Array(i).Location.Coord) <=  mr
                ball = Ball_Array(i);
                return;
            end

        end

    end

end

