% viewImage.m
% By: Cody Smith
% script to connect via serial to the CK2015 Freescale Cup Car
% and show a live-updating graph of the data reveived over serial

% Main Script
function [] = viewImage()
    
    %%%%%%%%%%%%
    % Plotting %
    %%%%%%%%%%%%
    
    % Setup Live graph struct
    global liveGraph;
    liveGraph = struct;
    liveGraph.plots = gobjects;
    liveGraph.data  = {};
    liveGraph.state = 1;
    
    figure
    
    subplot(2,1,1);
    liveGraph.data{1}  = zeros(1,123);
    liveGraph.plots(1) = plot(liveGraph.data{1});
    title('Image (Post smoothing)');
    
    subplot(2,1,2);
    liveGraph.data{2}  = zeros(1,121);
    liveGraph.plots(2) = plot(liveGraph.data{2});
    title('Image Derivative');
    
    
    %%%%%%%%%%
    % Serial %
    %%%%%%%%%%
    
    % Serial Port Config
    serial_port_name = '/dev/tty.usbserial-AH02F1FF';
    
    % Setup Serial Connection
    s_connection = serial(serial_port_name);
    s_connection.BaudRate = 38400;
    s_connection.BytesAvailableFcnMode = 'terminator';
    s_connection.Terminator = 'LF/CR';
    s_connection.InputBufferSize = 4096;
    s_connection.BytesAvailableFcn = @bytesAvailableHandler;
    
    % Flush the input (just in case)
    flushinput(s_connection);
    
    % Open the serial connection
    fopen(s_connection);
    
    
    % Loop to keep the program running
    running = true;

    while running
        x = input('\n','s');
        if(strcmp(x,'exit') || strcmp(x, 'e'))
            running = false;
        end
    end

    % Close everything
    fclose(s_connection);
    close;
    
end

% Bytes Available Handler
function bytesAvailableHandler(serialConnection, ~)
    
    global liveGraph;

    % Eval the data we just got in from serial
    in_data = fscanf(serialConnection);
    in_data = strrep(in_data, ',', '');
    
    data = eval(in_data);
    
    % liveGraph state reset
    if liveGraph.state > size(liveGraph.plots)
        liveGraph.state = 1;
    end
    
    % Update data and update plot of that data
    liveGraph.data{liveGraph.state} = data;
    set(liveGraph.plots(liveGraph.state),'YData', data);
    
    % Increment liveGraph state
    liveGraph.state = liveGraph.state + 1;
    
end
