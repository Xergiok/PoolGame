function mustBeGraphicsHandle(arg)

try
    valid_handle = ishghandle(arg) && ~isnumeric(arg);
catch
    valid_handle = false;
end

if ~valid_handle
    eidType = 'mustBeGraphics:notRealGraphics';
    msgType = 'Input must be a valid graphics object handle.';
    throwAsCaller(MException(eidType,msgType))
end

end