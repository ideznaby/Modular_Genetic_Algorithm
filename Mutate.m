function [ ChildMX ] = Mutate( ChildX,ProbMutation,CityNumber )
%MUTATE Summary of this function goes here
if(rand<ProbMutation)
    indexr1=random('unid',CityNumber,1,1);
    indexr2=random('unid',CityNumber,1,1);
    temp=ChildX(indexr1);
    ChildX(indexr1)=ChildX(indexr2);
    ChildX(indexr2)=temp;
    ChildMX=ChildX;
else
    ChildMX=ChildX;
end
end

