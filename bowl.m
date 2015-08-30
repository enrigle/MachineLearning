function score = bowl( game )
%BOWL determines the score of any bowling game, if not a valid input returns -1

%STRIKE: frame in which all 10 pins are knocked down by the 1rst ball (2nd
%ball of the frame omitted. On the 10TH FRAME earns 2 bonus balls:
    %IF bowl a spare, they only get to bowl one more (1 bonus ball)
    %IF 1srt of those 2 bonus-balls is a strike then
    %all 10 pins are set-up again for the 2nd ball   (2 bonus ball)
%SCORE: 10 pts + the sum of the pins knocked down by the next 2 balls
%(which may include balls from the next 2 frames)
%Max points in a single frame is 30 pts (10 for 1 strike + strikes in 2 subsequent frames). 
%BONUS SCORE: A bonus ball counts the nº of pins it knocked down

%SPARE: all 10 pins are knocked down with 2 balls. A spare in the 10th frame 
%earns the bowler 1 “bonus” ball for that frame, which is simply an extra ball
%SCORE: 10 pts + pins knocked down by the next ball

%OPEN: frame with fewer than 10 pins down 
%SCORE: counts the nº of pins knocked down in that frame

%Example: see PDF, a perfect game (12 strikes) is 300 points
%[9 1 0 10 10 10 6 2 7 3 8 2 10 9 0 9 1 10] -> 168 

%NO: length of game < 12 or greater than 21
if length(game) < 12 || length(game) > 21 
    score = -1;
    return;
%NO: numbers greater than 10 or negative
elseif sum(game>10) > 0 ||  sum(game<0) > 0
    score = -1;
    return;    
end

%convert game, to take into account the real number of pins
game = convert(game);
%NO: min length is 20 and max is 21 when the game vector is converted
if length(game) < 20 || length(game) > 21
    score = -1;
    return;    
%NO: if the 10th frame is 21, but the sum of the 10th frame isn't 10
elseif (length(game) == 21) && sum(game(19:20)) < 10
    score = -1;
    return;    
%if a strike or a spare is made at the 10th frame, there must be 21 balls 
elseif (length(game) < 21) 
    if ( game(19) == 10 || sum(game(19:20)) == 10 )
        score = -1;
        return;           
    %if it's an open game, the sum of the first 2 balls must be less than 10
    elseif sum(game(19:20)) > 10
        score = -1;
        return;
    end    
end    

%sum keep track of the scores
suma = 0;

for s = 1:2:length(game)-3    
    %NO: the sum of each frame > 10
    if ( game(s) + game(s+1)) > 10
        score = -1;
        return;
    end    
    %spare case
    if ( game(s) + game(s+1)) == 10 && (game(s) ~= 10)        
        fprintf('spare ');
        suma = suma + 10 + game(s+2)
    %strike case
    elseif game(s) == 10
        fprintf('strike ');
        s
        %if frame is the penultimate and there are 2 strikes in a row
        if game(s+2) == 10 && s == 17            
            suma = suma + 10 + game(s+2) + game(s+3)
        elseif game(s+2) == 10
            suma = suma + 10 + game(s+2) + game(s+4)
        else
            suma = suma + 10 + game(s+2) + game(s+3)
        end
    %open case   
    elseif ( game(s) + game(s+1) ) < 10
        fprintf('open case ')
        suma = suma + game(s) + game(s+1)
    end
end
fprintf('10th frame ')
if sum(game(s+2:s+3)) > 20 || sum(game(s+2:end)) > 30
   score = -1;
   return;
end
suma = suma + sum(game(s+2:end))
score = suma;
end

function newGame = convert( game )
%INPUT:  receives a game (col vector)
%OUTPUT: col vector that takes into account the strikes
%example: convert([9 1 0 10 10   10   6  2  7 3  8  2 10    9 0 9 1 10])
%                 [9 1|0 10|10 0|10 0|6  2 |7 3 |8  2|10 0 |9 0|9 1|10]
%                  1   3    5    7    9    11   13    15   17  19   
%Tip: 1. treat it in pairs, 2. if the 1rst elem. of the pair is 10 add a 0
%3. for the 10th frame don't add anything
newGame = [];
for i=1:2:21-3
    if game(i)==10
        newGame = [newGame game(i) 0];        
        game =    [game(1:i) 0 game(i+1:end)];
    else
        newGame = [newGame game(i) game(i+1)];            
    end        
end
%10th frame don't add anything
newGame = [newGame game(i+2:end)];            
end
