function [FinalX,FinalY,iterOfBest,Progresses]=SGA(SelectionMethod,ReplacementMethod,ShowResults,BestType,SMArguments,PCM)
%SGA Simple Genetic Algorithm

    %Input Checking
    if nargin<5
		%Determine that the problem is to find the maximum or minimum
		if nargin<4
			if nargin<3
				disp('Arguments:');
				disp('1)[Mandatory] SelectionMethod: it should be @RWS, @SUS, or @BBTS');
				disp('2)[Mandatory] ShowResults: it should be either 1 or 0');
				disp('3)[Optional-mandatory if SMArguments is set] type: it should be either "max" or "min"');
				disp('4)[Optional] SMArguments: it should be a number');
				return;
			end
		elseif strcmp(BestType,'max')
			BestTypeMethod=@max;
		elseif strcmp(BestType,'min')
			BestTypeMethod=@min;
		else
			error('type should be either "max" or "min"')
		end
    elseif strcmp(BestType,'max')
        BestTypeMethod=@max;
    elseif strcmp(BestType,'min')
        BestTypeMethod=@min;
    else
        error('type should be either "max" or "min"')
    end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Phase1: Initialization

    %problem specific variables
     cities(1,:) = [10 9.8 9.3 8.5 7.5 6.3 5 3.7 2.5 1.5 0.7 0.2 0 0.2 0.7 1.5 2.5 3.7 5 6.3 7.5 8.5 9.3 9.8];
     cities(2,:) = [5 6.3 7.5 8.5 9.3 9.8 10 9.8 9.3 8.5 7.5 6.3 5 3.7 2.5 1.5 0.7 0.2 0 0.2 0.7 1.5 2.5 3.7];
    distances = calculatedistance(cities);
    %set general variables
    PopSize=80;
    OffspringSize=80;
    ChromoSize=length(cities);
    Pc=PCM(1);
    Pm=PCM(2);
    MateSize=50;
    MaxFitness=679;
	%how many of last fitnesses' variance to be checked for loop finishing
    CheckCount=400;
    MaxGener=400;
	
    %close any figures and show the initial plot
    if ShowResults
        figure;
        Text=text(0,0,' ');
    end
    
    ResultsProgress = zeros(1,1);
    Population = zeros(PopSize,ChromoSize);

    for i=1:1:PopSize
        Population(i,:)=randperm(ChromoSize);
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %Phase2: Main Loop
    Parents=Population;
    Offsprings=zeros(OffspringSize,ChromoSize);
    GenerCount=0;
    pause('on');
    ParentsFitness=zeros(1,1);
    while ~(LoopFinished(GenerCount,ResultsProgress,CheckCount,MaxFitness,MaxGener))
        
        %generate corresponding Xs to each Chromosome
        %ParentXs=Map2X(Parents,XLowerBound,XUpperBound);
        
        %generate fitness for each chromosome
        ParentsFitness=Ys(Parents,distances);
        
        Probabilities=ParentsFitness/sum(ParentsFitness);

        %fill mating pool with Selection Method
        MatingPool=SelectionMethod(Parents,MateSize,Probabilities,BestType,ParentsFitness,SMArguments);
        
        %create new generation
        i=1;
        while i<OffspringSize
            c1=random('unid',MateSize);
            c2=random('unid',MateSize);
            if rand()>Pc
                Offsprings(i,:)=MatingPool(c1,:);
                Offsprings(i+1,:)=MatingPool(c2,:);
            else
                [child1 child2] = Crossover(MatingPool(c1,:),MatingPool(c2,:),ChromoSize);
                %Mutate
                child1 = Mutate(child1,Pm,ChromoSize);
                child2 = Mutate(child2,Pm,ChromoSize);
                Offsprings(i,:)=child1;
                Offsprings(i+1,:)=child2;
                
            end
            i=i+2;
        end
        
        %generate fitness for each chromosome
        OffspringFitness=Ys(Offsprings,distances);

        %Selecting from Offsprings to replace in New Generation
        Parents=ReplacementMethod(Parents,ParentsFitness,Offsprings,OffspringFitness,BestType,SMArguments);
        
        %generate fitness for each chromosome
        ParentsFitness=Ys(Parents,distances);
        GenerCount=GenerCount+1;
        
        ResultsProgress(GenerCount)=BestTypeMethod(ParentsFitness);
        
        %show the the results
        if ShowResults
			[c,i]=BestTypeMethod(ParentsFitness);
			plot((1:GenerCount),ResultsProgress,'b');
        end

    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
   %Phase3: Finalization
   
   [c,i]=BestTypeMethod(ParentsFitness);
   %FinalX=ParentXs(i);
   FinalY=c;
   [~,iterOfBest]=BestTypeMethod(ResultsProgress);
   if ShowResults
       figure;
       plot([cities(1,Parents(i,:)),cities(1,Parents(i,1))],[cities(2,Parents(i,:)),cities(2,Parents(i,1))],'b');
       hold on;
       plot([cities(1,Parents(i,:)),cities(1,Parents(i,1))],[cities(2,Parents(i,:)),cities(2,Parents(i,1))],'*r');
       hold off;
       figure;
       plot(1:GenerCount,ResultsProgress,'');
       hold on;
       plot([iterOfBest,iterOfBest],[0,c],'--');
       text(iterOfBest+2,c-0.15,['iteration ',num2str(iterOfBest)],'Rotation',90);
       hold off;
   end
   ResultsProgress(iterOfBest)
   c
   Parents(i,:)
   %disp(['FinalChromosome=',Parents(i,:),', FinalX=',num2str(FinalX),', FinalY=',num2str(FinalY)])
   Progresses=ResultsProgress;
end