function [ distances ] = calculatedistance( cities )
%this function calculates the distances between cities
distances = zeros(length(cities),length(cities));
for i=1:1:length(cities)
    for j=1:1:length(cities)
        distances(i,j) = sqrt((cities(1,j) - cities(1,i)).^2 + (cities(2,j) - cities(2,i)).^2);
    end
end
end

