clc; clear; close all;
%Connecting arduino with MATLAB system.
a = arduino('/dev/cu.usbmodem141401'); %It is used for the arduino port address in parentheses.

%Information about modes and taking mode name from user.
while true
    fprintf("Modes that you can use:\n1- One Color Lightning\n2- Fade Away\n3- Music Visualizer\n")
    mode = input('Please enter a mode you want to use: ','s');
    modes = ["One Color Lightning" , "Fade Away", "Music Visualizer"];
    if find(mode==modes)==1 || find(mode==modes)==2 || find(mode==modes)==3
        break %If there is wrong input, this structre help us to get right input.
    else
        fprintf("\nInvalid input.\n\n");
    end
end

%If led strip is on, 3 lines below this line will turn off led strip.
writePWMVoltage(a,'D9',0);
writePWMVoltage(a,'D10',0);
writePWMVoltage(a,'D11',0);
switch mode
    case 'One Color Lightning' %The first case is about lightning the led one color.
        fprintf("Which color do you want to see? Here is color list.\n\n");
        fprintf("  Green         Blue           White\n");
        fprintf("  Pink         Purple          Cyan\n");
        fprintf("  Orange       Yellow           Red\n\n");
        fprintf("If you want to out please use control+c. After that please copy this on commad window:\n");
        fprintf("writePWMVoltage(a,'D9',0);writePWMVoltage(a,'D10',0);writePWMVoltage(a,'D11',0);\n")
        %I start an array for colors and each color has different RGB combination.
        Color = ["Green","Blue","White","Pink","Purple","Cyan","Orange","Yellow","Red"];
        %I start an other array for RGB combination.
        %In "while true" and "if", program find color index according Color string array with "find" and
        %its color combination from Voltage with 3*Index.
        Voltage = [0 5 0 5 0 0 5 5 5 1 0 5 5 0 3 5 5 0 0 1 5 0 3 5 0 0 5]; i=1;
        while true %this makes the program endless.
            if i==1 %After first enter, "i" makes the program enter "else".
                    %This will change what is written inside "fprintf".
                in_color = input("Please enter a color you want to see:\n",'s');
                Index = find(Color==in_color); i=2;
                writePWMVoltage(a,'D9',Voltage(3*Index-2));
                writePWMVoltage(a,'D10',Voltage(3*Index-1));
                writePWMVoltage(a,'D11',Voltage(3*Index));
            else
                key = input("If you want to change color please enter:\n",'s');
                Index = find(Color==key); i=2; 
                writePWMVoltage(a,'D9',Voltage(3*Index-2));
                writePWMVoltage(a,'D10',Voltage(3*Index-1));
                writePWMVoltage(a,'D11',Voltage(3*Index));
            end
        end
    case 'Fade Away' %The second case provides the color spectrum in the led strip.
        %Information about how to end the program.
         fprintf("If you want to out please use control+c. After that please copy this on commad window:\n");
         fprintf("writePWMVoltage(a,'D9',0);writePWMVoltage(a,'D10',0);writePWMVoltage(a,'D11',0);\n")
         while true %this makes the program endless.
            for i=0:0.1:5 %purple to blue
                pause(0.005)
                writePWMVoltage(a,'D9',5)
                writePWMVoltage(a,'D10',0)
                writePWMVoltage(a,'D11',5-i)
            end
            for k=0:0.1:5 %blue to cyan
                pause(0.005)
                writePWMVoltage(a,'D9',i)
                writePWMVoltage(a,'D10',k)
                writePWMVoltage(a,'D11',5-i)
            end
            for l=0:0.1:5 %cyan to green
                pause(0.005)
                writePWMVoltage(a,'D9',i-l)
                writePWMVoltage(a,'D10',k)
                writePWMVoltage(a,'D11',5-i)
            end
            for m=0:0.1:5 %green to yellow
                pause(0.005)
                writePWMVoltage(a,'D9',i-l)
                writePWMVoltage(a,'D10',k)
                writePWMVoltage(a,'D11',5-i+m)
            end
            for n=0:0.1:5 %yellow to red
                pause(0.005)
                writePWMVoltage(a,'D9',i-l)
                writePWMVoltage(a,'D10',k-n)
                writePWMVoltage(a,'D11',5-i+m)
            end
            for x=0:0.1:5 %red to purple
                pause(0.005)
                writePWMVoltage(a,'D9',i-l+x)
                writePWMVoltage(a,'D10',k-n)
                writePWMVoltage(a,'D11',5-i+m)
            end
         end
    case 'Music Visualizer'
         fprintf("If you want to out please use control+c. After that please copy this on commad window:\n");
         fprintf("writePWMVoltage(a,'D9',0);writePWMVoltage(a,'D10',0);writePWMVoltage(a,'D11',0);\n");
         %This code start to work here. The first impulse turns led strip on.
         while true %For first impulse
             if readVoltage(a,'A0')<4.95 %System is not ideal so this value is changing depending on situation.
                blue=5*rand; green=5*rand; red=5*rand;   %I mentioned it 5V as ideal in report and presentation.
                writePWMVoltage(a,'D9',blue);
                writePWMVoltage(a,'D10',green);
                writePWMVoltage(a,'D11',red);
                break;
             end
         end

        while true %this makes the program endless.
            r=readVoltage(a,'A0'); %We get the information from the sound sensor with the change of voltage.
            if r<4.95  %if it is 5, the sound sensor is not detecting a sound change. 
                    %If it is different from 5, the sound sensor has detected the sound change.

                move=randi(3);
                switch move
                    case 1
                        blue=5*rand; %I set up a test like this to see the color white less often.
                        testing1=logical(abs(blue-red)<1);
                        testing2=logical(abs(blue-green)<1);
                        if testing1==1 || testing2 == 1 %Blue-green or blue-red voltage difference is less than 1
                            blue=5*rand;                %Assign random number for blue again.
                        end
                        writePWMVoltage(a,'D9',blue); %Changing colors.
                        writePWMVoltage(a,'D10',green);
                        writePWMVoltage(a,'D11',red);
                        pause(0.02);
                    case 2
                        green=5*rand;
                        testing1=logical(abs(green-blue)<1); %This works the same with the one for blue.
                        testing2=logical(abs(green-red)<1);
                        if testing1==1 || testing2 == 1
                            green=5*rand;
                        end
                        writePWMVoltage(a,'D9',blue); %Changing colors.
                        writePWMVoltage(a,'D10',green);
                        writePWMVoltage(a,'D11',red);
                        pause(0.02);
                    otherwise
                        red=5*rand;
                        testing1=logical(abs(red-blue)<1); %This works the same with the one for blue.
                        testing2=logical(abs(red-green)<1);
                        if testing1==1 || testing2 == 1
                            red=5*rand;
                        end
                        writePWMVoltage(a,'D9',blue); %Changing colors.
                        writePWMVoltage(a,'D10',green);
                        writePWMVoltage(a,'D11',red);
                        pause(0.02);
                end
            elseif r>=4.95 %If the sound sensor does not detect a sound change,
                pause(0.1); %this will make the previous color lasts a little more.
            end
        end
end

%Turn off lights.
writePWMVoltage(a,'D9',0);
writePWMVoltage(a,'D10',0);
writePWMVoltage(a,'D11',0);