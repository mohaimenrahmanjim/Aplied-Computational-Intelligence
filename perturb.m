function [x] = gen(num, min, max, x)
    randIndex1 = randi(num);
    alreadyChosen = true;
    while alreadyChosen == true
        randIndex2 = randi(num);
        if randIndex2 ~= randIndex1
            alreadyChosen = false;
        end
    end
    x(randIndex1) = (max-min)*rand()+min;
    x(randIndex2) = (max-min)*rand()+min;
end
