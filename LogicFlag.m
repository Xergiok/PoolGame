classdef LogicFlag < handle

properties
    State(1, 1) logical {mustBeNumericOrLogical, mustBeFinite, mustBeNonmissing, mustBeNonnegative} = ...
        0;
end

events
    ChangeState;
end

methods

    function this = LogicFlag(init)

        this.State = init;

    end

    function this = Switch(this)

        this.State = ~this.State;

    end

end

end
