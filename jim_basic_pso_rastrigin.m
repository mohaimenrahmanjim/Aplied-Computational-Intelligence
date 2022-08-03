clc; clear; close all;

% Rastrigin Benchmark

num = 2
minValue = -5.12 
maxValue = 5.12


t = 15; %number of pariticles
MAX_Iteration = 1000;

x = zeros(t,num);
Cost_x = zeros(t,1);
x_pbest = zeros(t,num);
Cost_x_pbest = zeros(t,1);
v = zeros(t,num);
IvsT=zeros(MAX_Iteration,1);

w=0.5; 
c1=.5;
c2=.5;

x_sbest = (maxValue-minValue).*rand(1,num)+minValue; 
Cost_x_sbest = rast(x_sbest,num); 


for i=1:t
    x(i,:) = (maxValue-minValue).*rand(1,num)+minValue; 
    x_pbest(i,:) = x(i,:);
        
    Cost_x(i) = rast(x(i,:),num);
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



for k=1:MAX_Iteration
    for i=1:t
        rp = rand(1,1);
        rg = rand(1,1);
        
        v(i,:) = w * v(i) + (c1 * rp) * (x_pbest(i,:) - x(i,:)) + (c2 * rg) * (x_sbest - x(i,:));
        
        newX =  x(i,:) + v(i,:);
        
        x(i,:) = newX;
        
        cityRoute_j = perturb(num, minValue, maxValue, newX);
        
        Cost_x(i) = rast(x(i,:),num);
        
        
        if(Cost_x(i) < Cost_x_pbest(i))
            x_pbest(i,:) = x(i,:);
            Cost_x_pbest(i) = Cost_x(i);
            
            if(Cost_x_pbest(i) < Cost_x_sbest)
                x_sbest = x_pbest(i,:);
                Cost_x_sbest = Cost_x_pbest(i);
              end
        end
             
    end
    
    D(i+1) = Cost_x_sbest; %record the route distance for each temperature setting
    D_o = Cost_x_sbest; % Update optimal distance 
    IvsT(k)=Cost_x_sbest;
  
    
    disp(['Iteration #',num2str(k),' Swarm best cost: ',num2str(Cost_x_sbest)])
end
disp(['Best Values: ',num2str(x_sbest)])
disp(['Best Cost: ',num2str(Cost_x_sbest)])

figure;
plot(IvsT);
ylabel('Swarm Best Cost', 'fontsize', 18, 'fontname', 'Arial');
xlabel('Iteration', 'fontsize', 18, 'fontname', 'Arial');
title('Swarm Best Cost vs Iteration', 'fontsize', 20, 'fontname', 'Arial');
