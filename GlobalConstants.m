classdef GlobalConstants

%% Class constant properties block
properties(Constant)

    TimeStep = 0.025;
    g = 980.665;    % value for the acceleration of gravity in cm/(s^2)
    SlidingFriction = 0.02;    % coefficient of sliding friction
    RollingFriction = 0.0075;    % coefficient of rolling friction
    ElasticityCoef_p = 0.1;    % constant of elasticity
    ElasticityCoef_v = 0.1;    % constant of elasticity
    BorderLoos = 0.05;

end

end

