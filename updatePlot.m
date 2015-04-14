function updatePlot(serialConnection,~)
%UPDATEPLOT Reads in data from serial connection, updates a plot.
%   Handler set to run every time serial connection receives a byte.
%   Buffers the received characters and when a full set is recieved
%   (indicated by a newline character) attempts to parse that set and
%   display it on a graph
    
    bytes = get(serialConnection, 'BytesAvailable');
    if(bytes > 0)
        data = fread(serialConnection, bytes);
    end

end

