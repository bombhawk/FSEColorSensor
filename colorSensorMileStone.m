global key
InitKeyboard();
speed = 35;
turnTime = 1;
turnDelay = 4;
stopTime = 2;
redDelay = 0;
blueDelay = 0;
greenDelay = 0;

brick.SetColorMode(1, 2);

while 1
    %color sensing
    color_rgb = brick.ColorRGB(1);  % Get Color on port 1.
    %color notes
    %yellow: Red: 153 Green: 68 Blue: 34
    %green: Red: 29 Green: 71 Blue: 40
    %red: Red: 114 Green: 15 Blue: 23
    %blue: Red: 17 Green: 51 Blue: 129
    %black: Red: 10 Green: 11 Blue: 12

    %print color of object
    fprintf("\tRed: %d\n", color_rgb(1));
    fprintf("\tGreen: %d\n", color_rgb(2));
    fprintf("\tBlue: %d\n", color_rgb(3)); 

    %Turn on manual controls on blue and yellow
    %yellow first blue second
    
    %blue
    if color_rgb(1) <= 30 && color_rgb(2) >= 40 && color_rgb(3) >= 100 && blueDelay == 0
            brick.StopMotor('A');
            brick.StopMotor('B');
            brick.playTone(100, 800, 500);
            pause(.5);
            brick.playTone(100, 800, 500);
            pause(1);
            blueDelay = 2;
    %green
    else if color_rgb(1) <= 50 && color_rgb(2) >= 50 && color_rgb(3) <= 60 && greenDelay == 0 
            brick.playTone(100, 800, 500);
            brick.StopMotor('A');
            brick.StopMotor('B');
            pause(.5);
            brick.playTone(100, 800, 500);
            pause(.5);
            brick.playTone(100, 800, 500);
            pause(1);
            greenDelay = 2;

    else


        %Basic move forward, this runs if nothing else takes over
        brick.MoveMotor('A', speed);
        brick.MoveMotor('B', speed);
        
        %Pauses on red and plays sound
        if color_rgb(1) >= 100 && color_rgb(2) <= 30 && color_rgb(3) <= 30 && redDelay == 0
            brick.playTone(100, 800, 500);
            brick.StopMotor('A');
            brick.StopMotor('B');
            redDelay = 2;
            pause(1);
        end

        if redDelay > 0
            redDelay = redDelay - 1;
            pause(1);
        end

        if blueDelay > 0
            blueDelay = blueDelay - 1;
            pause(1);
        end

        if greenDelay > 0
            greenDelay = greenDelay - 1;
            pause(1);
        end
        
        %distance and touch sensing variables
        distance = brick.UltrasonicDist(2);
        reading = brick.TouchPressed(3);
        %display(distance);
    
        %listens to distance sensor unless there is a touch
        %if touch back up and then turn left
        if reading == 1
                brick.MoveMotor('A', -speed);
                brick.MoveMotor('B', -speed);
                pause(.5);
                brick.MoveMotor('A', speed);
                brick.MoveMotor('B', -speed); 
                pause(turnTime);
                brick.StopMotor('A');
                brick.StopMotor('B');
                %untested, doubt this will work
                reading = 0;
        else
                %Go there is no well to the right turn right
                if distance > 60
                     brick.MoveMotor('A', speed);
                     brick.MoveMotor('B', speed);
                     pause(2);
                     brick.MoveMotor('A', -speed);
                     brick.MoveMotor('B', speed);
                     pause(turnTime);
                     brick.MoveMotor('A', speed);
                     brick.MoveMotor('B', speed);
                     pause(turnDelay);
                end
                
                display(distance);
        end
        display(reading);
    
        
    end
    end
end
CloseKeyboard();