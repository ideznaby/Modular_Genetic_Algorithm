function NewGeneration = SimpleReplacement( Parents,ParentFitness,Offsprings,OffspringFitness,BestType,~ )
%REPLACEGENERATION is a selecttion method
%   It's used to replace Offsprings with previous generation via Random
%   Replacement method

    %Ellitism: Best/Worst Selection
    if (strcmp(BestType,'max'))
        [~,BestInd]=max(ParentFitness);
        [~,WorstInd]=min(OffspringFitness);
    else
        [~,BestInd]=min(ParentFitness);
        [~,WorstInd]=max(OffspringFitness);
    end
    
    NextGeneration=Offsprings;
    
    %Ellitism: Worst-Best Replacement
    NextGeneration(WorstInd,:)=Parents(BestInd,:);
        
    NewGeneration=NextGeneration;
end

