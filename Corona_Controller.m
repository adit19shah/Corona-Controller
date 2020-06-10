% Software implementation of Corona Scoring Algorithm

% Assigned by: Prof. Manish K. Gupta     Course: SC 205
% Name: Adit Shah                        Student Id: 201901454

% Few important Points:
 
%1. when someone is tested positive, this software can be used to use the
    %stored social-interaction graph's data productively by converting it to "adjacency" matrix(As
    %per definition of note-2 given below) and then updating corona Scores of required
    %people in graph.When it prompts to enter id of the one tested
    %positive, enter id of each person tested positive in the network one by one. 
    
%2 .The matrix "adjacency" used in the code is similar to standard adjacency matrix
    % used to represent a graph but the difference is instead of storing
    % 1's, it is storing the distance with which interaction happened. i.e.
    % adjacency(i,j) stores the distance(in ft.) with which i and j interacted
    % value 0 in matrix indicates no interaction had happend as in standard adjacency matrix
    
%3 .The matrix "Dayes" used in the code is also similar to standard adjacency matrix
    % used to represent a graph but the difference is instead of storing
    % 1's, it is storing days passed since the interaction happened. i.e.
    % Dayes(i,j) stores the days passed since i and j interacted last time.
    % At the indices of Dayes matrix equal to the indices of standard 
    % adjacency matrix having value 0, arbitrary values are stored and must
    % be ignored.
    
%4. 'Day 0' in output indicates the day when the person was confirmed
%    positive. 


clc; clearvars;
fprintf('---------------------Welcome to our Corona Scoring Software Model-----------------------------\n\n\n');

fprintf("Press 0 if you want to add your own data and press 1 if you want to continue with sample data stored in software.");
fprintf("\n (You will be shown the matrix representation of sample graph stored)  \n");
choice=input('Enter your choice here   ');

if(choice==0)
% This snippet prepares the adjacency matrix of the Social graph required
% and allocates memory for few required variables(matrices)
    population_size=input('Please enter the size of population you want to analyse : ');
    adjacency = zeros(population_size,population_size);
    dayes = zeros(population_size,population_size);
    for i=1:population_size
        ch=1;
        fprintf('\n person: %d\n',i);
        while(ch==1)
            inter=input('Enter the unique id of person with whom he interacted :(one at at time)  ');
            dis=input('Enter the distance with which he interacted with him:(in ft.)  ');
            day = input('Enter the days passed since he interaced with him ');
            dayes(i,inter)=day; % Storing the number of days passed since both interacted
            % If number of days are more than 14, there is no need to add
            % the edge between two nodes
            if(dayes(i,inter)<=14)
                adjacency(i,inter)=dis;
            end
            fprintf('\n person: %d\n',i);
            ch=input("want to add more connections ?(press 1 to respond yes / press 0 to respond no)  ");
        end
    end
else
    load('sample_data_for_simulation');
    wi=input("Do you wish to see the variables used as sample data ? (press 1 for yes and press 0 for no)  ");
    if(wi==1)
        fprintf("\nPopulation size used for sample data: %d \n",population_size);
        fprintf("\n Adjacency matrix used is as follows: (as per definition given at the beginning of code)\n");
        disp(adjacency);
        fprintf("\n Dayes matrix used is as follows: (as per definition given at the beginning of code) \n");
        disp(dayes);
    end     
end


% Specifying the id of Corona Positive person for which we want to simulate
ct=1;
positive=[];
while(ct==1)
    positiv = input('Enter id of person tested positive(one at a time) ');
    positive=[positive,positiv];
    ct=input("Want to add any more positive person?(Press 1 for yes and 0 for no)   ");
end
see_next_day=1;  % Indicates that simulation for next day should continue
days_passed=0;  % this variable indicates the days passed since the person was tested positive


% Running a for loop over the following part to simulate it for 14 days since he was detected positive.
while(see_next_day==1)
    
    % condition to check if some person is to be added or distance value of
    % some branch is to be updated at any Day after Day 0.( Day 0 values
    % are already given as input in the first part)
    if(days_passed~=0)          
        fprintf("\nPress 1 if some new person is to be added on day %d\n",days_passed);
        fprintf("Press 2 to update distance between any two nodes in the existing network if they had interacted today \n");
        fprintf("Press 3 for doing both 1 and 2\n");
        fprintf("press 4 to continue with the previous data only (Select this if no distance is to be updated and no new person was added today ) \n");
        cs=input("\n Please enter your choice here:  ");
        
        % The code for adding a new person on a given day
        if(cs==1) 
            num=input("How many new persons are to be added ?  ");
            for r=population_size+1:population_size+num
                fprintf("\n Person: %d \n",r);
                % For new entries, we need to know if he is already
                % diagnosed positive or not.
                state=input("Is he already diagnosed positive ? (Press 1 for yes and 0 for no)  ");
                if(state==1)
                    positive=[positive,r];
                end
                ck=1;  
                 while(ck==1)
                    inter=input('Enter the unique id of person with whom he interacted :(one at at time)  ');
                    dis=input('Enter the distance with which he interacted with him:(in ft.)  ');
                    day = input('Enter the days passed since he interaced with him ');
                    dayes(r,inter)=day; % Storing the number of days passed since both interacted
                    dayes(inter,r)=day; % This will also hold as the ajacency matrix is symetric
                    % If number of days are more than 14, there is no need to add
                    % the edge between two nodes
                    if(dayes(i,inter)<=14)
                        adjacency(r,inter)=dis;
                        adjacency(inter,r)=dis;
                    end
                    fprintf('\n person: %d\n',r);
                    ck=input("want to add more connections ?(press 1 to respond yes / press 0 to respond no)  ");
                 end
            end
            population_size=population_size+num;
            
        % Code for updating distance corresponding to any branch on a given day
       elseif(cs==2)
            num=input("How many new branches were traversed(or previous ones were re-traversed with a new interactin distance) today ?\n (how many pairs interacted today in existing social network) ");
            for r=1:num
                fprintf("pair: %d\n",r);
                p1=input("Enter id of one person who interacted today : ");
                p2=input("Enter id of other person with whom he interaced: ");
                new_dis=input("Enter latest distance with which they interacted today ");
                % Update the distance of that branch in adjacency matrix
                % only if it is less than previously stored value else no
                % change is to de done.
                if(new_dis<adjacency(p1,p2))
                    adjacency(p1,p2)=new_dis;
                    adjacency(p2,p1)=new_dis;
                end
                dayes(p1,p2)=0;
            end
       
     % Code for doing both, adding a person as well as updating the distance
     % corresponding to any branch on a given day
    elseif(cs==3)
        % Part-01
             num=input("How many new persons are to be added ?  ");
            for r=population_size+1:population_size+num
                fprintf("\n Person: %d \n",r);
                state=input("Is he already diagnosed positive ? (Press 1 for yes and 0 for no)  ");
                if(state==1)
                    positive=[positive,r];
                end
                ck=1;
                 while(ck==1)
                    inter=input('Enter the unique id of person with whom he interacted :(one at at time)  ');
                    dis=input('Enter the distance with which he interacted with him:(in ft.)  ');
                    day = input('Enter the days passed since he interaced with him ');
                    dayes(r,inter)=day; % Storing the number of days passed since both interacted
                    dayes(inter,r)=day;
                    % If number of days are more than 14, there is no need to add
                    % the edge between two nodes
                    if(dayes(i,inter)<=14)
                        adjacency(r,inter)=dis;
                        adjacency(inter,r)=dis;
                    end
                    fprintf('\n person: %d\n',r);
                    ck=input("want to add more connections ?(press 1 to respond yes / press 0 to respond no)  ");
                 end
            end
            population_size=population_size+num;
            
            %Part -02
            num=input("How many new branches were traversed(or previous ones were re-traversed with a new interactin distance) today ?\n (how many pairs interacted today in existing social network) ");
            for r=1:num
                fprintf("pair: %d\n",r);
                p1=input("Enter id of one person who interacted today : ");
                p2=input("Enter id of other person with whom he interaced: ");
                new_dis=input("Enter latest distance with which they interacted today ");
                % Update the distance of that branch in adjacency matrix
                % only if it is less than previously stored value else no
                % change is to de done.
                if(new_dis<adjacency(p1,p2)||adjacency(p1,p2)==0)
                    adjacency(p1,p2)=new_dis;
                    adjacency(p2,p1)=new_dis;
                end
                dayes(p1,p2)=0;
            end      
        end
    end 
    no_of_positives=length(positive);
    corona_score=zeros(population_size,no_of_positives);
    corona_score(positive,:)=100; % Assign score 100 only for ones tested positive by reports
    
    % counter to save corona score corresponding to each positive person 
    % which will be incremented while starting calculations for next positive person
    posit=1;  
    
    for pos=positive
        level_1=[];        % Nodes falling under level_1 will be stored in this array
        level_2=[];        % Nodes falling under level_2 will be stored in this array
        level_3=[];        % Nodes falling under level_3 will be stored in this array
        % Traversal to calculate Corona Score of Level 1 nodes:
        for i=1:population_size
            % Below condition checks whether interaction happened or not and if it
            % happened then it further checks whether he is already Corona positive
            % or not. As if he is already Corona positive, he must not be included
            % in level_1.
            if(adjacency(pos,i)>0 && corona_score(i,posit)~=100)
                % following 10 lines of code take care that one person is not
                % counted more than once while making the array of level_1 people.
                ct=0;
                for k=level_1
                    if(i==k)
                        ct=ct+1;
                    end
                end
                if(ct==0)
                    level_1=[level_1,i];
                end
                % Mapping of distance with corresponding probability used here is
                % given in pdf attached.
                if(adjacency(pos,i)<=1)
                    corona_score(i,posit)=corona_score(i,posit)+0.99*corona_score(pos);
                elseif(adjacency(pos,i)<=2)
                    corona_score(i,posit)=corona_score(i,posit)+0.90*corona_score(pos);
                elseif(adjacency(pos,i)<=3)
                    corona_score(i,posit)=corona_score(i,posit)+0.75*corona_score(pos);
                elseif(adjacency(pos,i)<=4)
                    corona_score(i,posit)=corona_score(i,posit)+0.50*corona_score(pos);
                elseif(adjacency(pos,i)<=5)
                    corona_score(i,posit)=corona_score(i,posit)+0.25*corona_score(pos);
                elseif(adjacency(pos,i)<=6)
                    corona_score(i,posit)=corona_score(i,posit)+0.01*corona_score(pos);
                end
            end
        end
        
        % Traversal to calculate Corona scores of level 2 people
        for pos=level_1  % loop that iterates over each node included in level-1
            for i=1:population_size
                
                % Following 10 lines of code check that the person to be included
                % in level 2 is neither Corona positive nor already counted in
                % Level 1.
                count=0;
                if(adjacency(pos,i)>0 && corona_score(i,posit)~=100)
                    for k=1:length(level_1)
                        if(i==level_1(k))
                            count=count+1;
                        end
                    end
                    if(count~=0)
                        continue;
                    end
                    
                    % To check whether a person already a part of level 2 is not
                    % counted again in level 2
                    ct=0;
                    for k=level_2
                        if(i==k)
                            ct=ct+1;
                        end
                    end
                    if(ct==0)
                        level_2=[level_2,i];
                    end
                    
                    if(adjacency(pos,i)<=1)
                        corona_score(i,posit)=corona_score(i,posit)+0.99*corona_score(pos);
                    elseif(adjacency(pos,i)<=2)
                        corona_score(i,posit)=corona_score(i,posit)+0.90*corona_score(pos);
                    elseif(adjacency(pos,i)<=3)
                        corona_score(i,posit)=corona_score(i,posit)+0.75*corona_score(pos);
                    elseif(adjacency(pos,i)<=4)
                        corona_score(i,posit)=corona_score(i,posit)+0.50*corona_score(pos);
                    elseif(adjacency(pos,i)<=5)
                        corona_score(i,posit)=corona_score(i,posit)+0.25*corona_score(pos);
                    elseif(adjacency(pos,i)<=6)
                        corona_score(i,posit)=corona_score(i,posit)+0.01*corona_score(pos);
                    end
                end
            end
        end
        
        % Traversal to calculate Corona score of Level 3 people
        for pos=level_2
            for i=1:population_size
                
                % Following lines of code check that the person to be included
                % in level 3 is neither Corona positive nor already counted in
                % level 1 or level 2
                count=0;
                if(adjacency(pos,i)>0 && corona_score(i,posit)~=100)
                    for k=1:length(level_1)
                        if(i==level_1(k))
                            count=count+1;
                        end
                    end
                    for k=1:length(level_2)
                        if(i==level_2(k))
                            count=count+1;
                        end
                    end
                    if(count~=0)
                        continue;
                    end
                    
                    % To check a person already a part of level 3 is not counted
                    % again in level 3
                    ct=0;
                    for k=level_3
                        if(i==k)
                            ct=ct+1;
                        end
                    end
                    if(ct==0)
                        level_3=[level_3,i];
                    end
                    
                    if(adjacency(pos,i)<=1)
                        corona_score(i,posit)=corona_score(i,posit)+0.99*corona_score(pos);
                    elseif(adjacency(pos,i)<=2)
                        corona_score(i,posit)=corona_score(i,posit)+0.90*corona_score(pos);
                    elseif(adjacency(pos,i)<=3)
                        corona_score(i,posit)=corona_score(i,posit)+0.75*corona_score(pos);
                    elseif(adjacency(pos,i)<=4)
                        corona_score(i,posit)=corona_score(i,posit)+0.50*corona_score(pos);
                    elseif(adjacency(pos,i)<=5)
                        corona_score(i,posit)=corona_score(i,posit)+0.25*corona_score(pos);
                    elseif(adjacency(pos,i)<=6)
                        corona_score(i,posit)=corona_score(i,posit)+0.01*corona_score(pos);
                    end
                    
                end
            end
        end
        
        % Increment the counter to start calculations corresponding to other
        % person tested positive
        posit=posit+1; 
    end

    % Loop to display final Corona Scores of entire population
    fprintf("\n Corona scores at the end of day %d\n",days_passed);
    cumm_corona_score=sum(corona_score,2);
    for i=1:population_size
        % Corona score scale is from 0-99 and 100(for the one who is
        % confirmed as positive) if while calculation, we get score of some node
        % more than 99, then instead of directly declaring him as positive, a
        % warning message is shown to him to conduct his check-up
        % immediately. 
        if(cumm_corona_score(i)<=99) 
            fprintf("\n Corona score of person %d : %.2f\n",i,cumm_corona_score(i));
        elseif(mod(cumm_corona_score(i),100)==0)
            fprintf("\n Corona score of person %d : %.2f\n",i,100);
        else
            fprintf("\n Person %d: WARNING !! Probably, You have crossed path with someone infected with Corona. Please conduct your checkup immediately. \n",i);
        end
    end
    fprintf("\n Day %d ended ......\n",days_passed);
 
    % Corona scores of all except the ones tested positive will become 0 if
    % you simulate it for more than 14 days and no other in the network is
    % tested positive
    
    see_next_day=input('Press 1 if you want to simulate the next day and 0 if you want to end the simulation  ');
    
   % Corona scores at the end of each day will be shown in the output and at
   % the end of each day, day count corresponding to a branch will be
   % incremented and if it exceeds 14 then that branch will be removed.
   dayes=dayes+1;               % Day count of each branch is incremented
   days_passed=days_passed+1;   % Days passed since person was tested positve
   for z=1:population_size
       for y=1:population_size
           if(dayes(z,y)>=14)
                  adjacency(z,y)=0; %Delete a branch if day-count corresponding to it becomes more than 14 
           end 
       end
   end
end
fprintf(" \n ------------------Thank You for using our software-----------------\n ");
