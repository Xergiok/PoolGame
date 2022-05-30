classdef GameState < handle

%% Class private properties block
properties(SetAccess = private)
    bRunning(1, 1) logical {mustBeNonempty, mustBeNumericOrLogical, mustBeFinite, mustBeNonnegative} = ...
        false;
    bStopped(1, 1) logical {mustBeNonempty, mustBeNumericOrLogical, mustBeFinite, mustBeNonnegative} = ...
        false;
end

%% Class public methods block
methods

    % class constructor method
    function this = GameState()
        this.bRunning = false;
        this.bStopped = false;
    end

    function this = Start(this)
        this.bRunning = true;
        this.bStopped = false;
    end

    function this = Pause(this)
        this.bRunning = false;
        this.bStopped = true;
    end

    function this = Finish(this)
        this.bRunning = false;
        this.bStopped = false;
    end

end

end

