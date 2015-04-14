% viewImage.m
% By: Cody Smith
% script to connect via serial to a device and show a live-updating graph
% of the data reveived over serial

% Make serial object for connection
% UPDATE THIS WITH PROPER SERIAL PORT
s_connection = serial('tty.something', 'BaudRate', 9600);

% Setup updatePlot to be called everytime a byte is received
set(serialConnection, 'BytesAvailableFcnMode', 'byte');
set(serialConnection, 'BytesAvailableFcnCount', 1);
set(serialConnection, 'BytesAvailableFcn', @updatePlot);

% Open the serial connection
fopen(s_connection);

% Set running true
running = true;

while running
    x = input('\n','s');
    if(strcmp(x,'exit') || strcmp(x, 'e'))
        running = false;
    end
end

% Close the serial connection
fclose(s_connection);