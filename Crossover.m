function [ child1 child2 ] = Crossover( parent1,parent2,ChromoSize )
%CROSSOVER Summary of this function goes here
%   Detailed explanation goes here
                x=randperm(ChromoSize,2);
                %rand1=random('unid',ChromoSize);
                %rand2=random('unid',ChromoSize);
                %rand1 =2;
                %rand2 =4;
                r1 = min(x(1),x(2));%min(rand1,rand2);
                r2 = max(x(1),x(2));%max(rand1,rand2);
                changes = [parent1(r1:r2); parent2(r1:r2)];
                %create two children
                child1=[parent1(1:r1-1),parent2(r1:r2),parent1(r2+1:ChromoSize)];
                child2=[parent2(1:r1-1),parent1(r1:r2),parent2(r2+1:ChromoSize)];
                
                %Repair
                for k=[1:r1-1 , r2+1:ChromoSize]
                    while sum(changes(2,:) == child1(k))>0
                        child1(k) = changes(1,find(changes(2,:) == child1(k)));
                    end
                    while sum(changes(1,:) == child2(k))>0
                        child2(k) = changes(2,find(changes(1,:) == child2(k)));
                    end
                end
end

