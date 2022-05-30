classdef GlobalConstants

%% Class constant properties block
properties(Constant)

    TimeStep            = 0.025;        % dt - time step of game cycle
    
    g                   = 980.665;      % value for the acceleration of gravity in cm/(s^2)
    
    SlidingFriction     = 0.02;         % coefficient of sliding friction
    
    RollingFriction     = 0.0075;       % coefficient of rolling friction
    
    ElasticityCoef_p    = 0.1;          % constant of elasticity (p)
    
    ElasticityCoef_v    = 0.1;          % constant of elasticity (V)
    
    BorderLoos          = 0.05;         % persent of energy losted after colliding with table borders

    minSlidingScale     = 0.01;         % minimum scale of applied friction force (when speed max - max)

    maxRollingScale     = 0.7;          % minimum scale of applied rolling momentum (when speed min - max)
end

end

