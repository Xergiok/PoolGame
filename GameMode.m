classdef GameMode < handle

%% Class public properties block
properties
    State;
    Input;
end

%% Class public methods block
methods

    function this = GameMode()
        
        this.State = GameState();
        this.Input = Controller();

    end

end

%% Class static methods block
methods (Static)

    % primitive singleton implimentation
    function singleObj = GetInstance

        persistent localObj;    % persistent handle

        if isempty(localObj) || ~isvalid(localObj)  % conditions for creation
            localObj = GameMode;
        end

        singleObj = localObj;   

    end

end


end

