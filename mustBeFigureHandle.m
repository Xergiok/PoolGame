function mustBeFigureHandle(arg)

try
    valid_handle = strcmp(get(arg, 'type'), 'figure') && ~isnumeric(arg);
catch
    valid_handle = false;
end

if ~valid_handle
    eidType = 'mustBeFigureHandle:notRealFigureHandle';
    msgType = 'Input must be a valid figure handle.';
    throwAsCaller(MException(eidType,msgType))
end

end