clc; clear; close all;
cC = load('EUC_2D_100.txt');
num_Cities = size(cC,1)


t = 15; %number of travellers (pariticles)
MAX_Iteration = 1000;

x = zeros(t,num_Cities);
Cost_x = zeros(t,1);
x_pbest = zeros(t,num_Cities); 
Cost_x_pbest = zeros(t,1);
V = zeros(t,num_Cities);

IvsT= zeros(MAX_Iteration,1);
w=0.5;
c1=0.5;
c2=0.5;

V = {};

x_sbest = randperm(num_Cities); 
Cost_x_sbest = computeEUCDistance(num_Cities, cC, x_sbest); 


for i=1:t
    x(i,:) = randperm(num_Cities); 
    x_pbest(i,:) = x(i,:);
        
    Cost_x(i) = computeEUCDistance(num_Cities, cC, x(i,:));
    Cost_x_pbest(i) = Cost_x(i);
    
    if(i == 1) 
        x_sbest = x_pbest(i,:);
        Cost_x_sbest = Cost_x_pbest(i);
    end
    
    
    if(Cost_x(i) < Cost_x_sbest)
        x_sbest = x(i,:);
        Cost_x_sbest = Cost_x(i);
    end 
end


pStart = 0.6;        % Probability of accepting worse solution at the start
pEnd = 0.001;        % Probability of accepting worse solution at the end
tStart = -1.0/log(pStart); % Initial temperature
tEnd = -1.0/log(pEnd);     % Final temperature
frac = (tEnd/tStart)^(1.0/(MAX_Iteration-1.0));% Fractional reduction per cycle
cityRoute_i = randperm(num_Cities); % Get initial route
cityRoute_b = cityRoute_i;
cityRoute_j = cityRoute_i;
cityRoute_o = cityRoute_i;
% Initial distances
D_j = computeEUCDistance(num_Cities, cC, cityRoute_i);
D_o = D_j; D_b = D_j; D(1) = D_j;
numAcceptedSolutions = 1.0;
tCurrent = tStart;         % Current temperature = initial temperature
DeltaE_avg = 0.0;   % DeltaE Average


for k=1:MAX_Iteration
    for i=1:t
        
        if size(V,1) < i
            V(end+1)=cell(1,1);
        end
        rp = rand(1,1);
        rg = rand(1,1);
        
        %v(i) = w * v(i) + (c1 * rp) * (x_pb(i,:) - x(i,:)) + (c2 * rg) * (x_sb - x(i,:));
        
        PP = swapsequence(x_pbest(i,:), x(i,:));
        GG = swapsequence(x_sbest, x(i,:));  
        MM = mergeswap((c1 * rp),PP,(c2 * rg),GG); 
        V{i} = mergeswap(w,V{i},1,MM);
       
        %x(i,:) =  x(i,:) + v(i);   
        
        newX = performswap(x(i,:), V{i});
        V{i} = swapsequence(newX, x(i,:));   %Setting Basic Swap Sequence as the updated velocity
          
        
%        cityRoute_j = newX;
        cityRoute_j = perturbRoute(num_Cities, newX);
        
        Cost_x(i) = computeEUCDistance(num_Cities, cC, x(i,:));
        D_b = Cost_x(i);
        D_j = computeEUCDistance(num_Cities, cC, cityRoute_j);
        
        DeltaE = abs(D_j-D_b);
        if (D_j > D_b) % objective function is worse
            if (k==1 && i==1) DeltaE_avg = DeltaE; end
            p = exp(-DeltaE/(DeltaE_avg * tCurrent));
            if (p > rand()) accept = true; else accept = false; end
        else accept = true; % objective function is better
      end
      
        if (accept==true)
            x(i,:) = cityRoute_j;
            D_b = D_j;
            numAcceptedSolutions = numAcceptedSolutions + 1.0;
            DeltaE_avg = (DeltaE_avg * (numAcceptedSolutions-1.0) + ... 
                                            DeltaE) / numAcceptedSolutions;
        end
        
         
        if(Cost_x(i) < Cost_x_pbest(i))
            x_pbest(i,:) = x(i,:);
            Cost_x_pbest(i) = Cost_x(i);
            
            if(Cost_x_pbest(i) < Cost_x_sbest)
                x_sbest = x_pbest(i,:);
                Cost_x_sbest = Cost_x_pbest(i);
            end
        end
             
    end
    tCurrent = frac * tCurrent; % Lower the temperature
    D(i+1) = Cost_x_sbest; %record the route distance for each temperature setting
    D_o = Cost_x_sbest; % Update optimal distance 
    IvsT(k)=Cost_x_sbest;
    disp(['Swarm best cost: ',num2str(Cost_x_sbest)])
end
disp(['Best Route: ',num2str(x_sbest)])
disp(['Best Route Distance Cost: ',num2str(Cost_x_sbest)])

figure;
plot(IvsT);
ylabel('Swarm Best Cost', 'fontsize', 18, 'fontname', 'Arial');
xlabel('Iteration', 'fontsize', 18, 'fontname', 'Arial');
title('Swarm Best Cost vs Iteration', 'fontsize', 20, 'fontname', 'Arial');