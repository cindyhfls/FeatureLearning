function [expr] = fPRL2initExp(flagModel, flagExp)

% expreriment parameters
n = input('NtrialsShort = 12*n n = ');
if isempty(n)
    n = 1; % default is n = 1
end

%%
expr.Ntargets = 4; % target: (1) Square/red, (2) Triangle/red , (3) Square/blue, (4) Triangle/green
expr.Ncombinations = expr.Ntargets * (expr.Ntargets-1) ;
expr.combinationMap = 1:expr.Ncombinations ;
expr.choiceMap = [4 4 4 3 3 3 2 2 2 1 1 1 ;...
                  3 2 1 4 2 1 4 3 1 4 3 2] ;
expr.colorMap = [2 2 1 1] ;
expr.shapeMap = [3 4 3 4] ;


expr.precision = 1./expr.Ncombinations ;

expr.NblocksLong = 1 ;
expr.NblocksShort = 4 ;
%expr.NblocksShort = expr.NtrialsLong/expr.NtrialsShort ;

expr.NtrialsShort = expr.Ncombinations*n ; %   
expr.NtrialsLong = expr.NblocksShort*expr.NtrialsShort ; % does it have to be a multiple of 12?

expr.Ntrialstot = expr.NblocksLong*expr.NtrialsLong ; % total number of inputs to generate


expr.schedulestring = {'Rs','Rt','Bs','Bt','rS','bS','rT','bT',...
    'r1','r2','b1','b2','s1','s2','t1','t2'};
expr.bestTarget = repmat({'Rs','Rt','Bs','Bt','rS','bS','rT','bT'},1,2);
expr.sidestring = {'L','R'};
%%
% color rule flagModel = 1, flagExp = 1 (N.B.: it is slightly confusing but flagModel is
% exp1 V.S. exp2 but flagExp is the type of volatility)
expr.combination{1,1} = [1 3 1 3];
expr.combination{1,2} = [2 4 2 4];
expr.combination{1,3} = [2 3 2 3];
expr.combination{1,4} = [1 4 1 4];

% shape rule flagModel = 1, flagExp = 2
expr.combination{2,1} = [5 7 5 7];
expr.combination{2,2} = [6 8 6 8];
expr.combination{2,3} = [5 8 5 8];
expr.combination{2,4} = [6 7 6 7];

% color rule flagModel = 2, flagExp = 1
expr.combination{3,1} = [9 11 9 11];
expr.combination{3,2} = [10 12 10 12];
expr.combination{3,3} = [10 11 10 11];
expr.combination{3,4} = [9 12 9 12];

% shape rule flagModel = 2, flagExp = 1
expr.combination{4,1} = [13 15 13 15];
expr.combination{4,2} = [14 16 14 16];
expr.combination{4,3} = [13 16 13 16];
expr.combination{4,4} = [14 15 14 15];

% expr.combination{1,1} = [1 3 1 3];
% expr.combination{1,2} = [3 1 3 1];
% expr.combination{2,1} = [2 4 2 4];
% expr.combination{2,2} = [4 2 4 2];
% expr.combination{3,1} = [5 7 5 7];
% expr.combination{3,2} = [7 5 7 5];
% expr.combination{4,1} = [6 8 6 8];
% expr.combination{4,2} = [8 6 8 6];
% expr.combination{5,1} = [9 11 9 11];
% expr.combination{5,2} = [11 9 11 9];
% expr.combination{6,1} = [10 12 10 12];
% expr.combination{6,2} = [12 10 12 10];
% expr.combination{7,1} = [13 15 13 15];
% expr.combination{7,2} = [15 13 15 13];
% expr.combination{8,1} = [14 16 14 16];
% expr.combination{8,2} = [16 14 16 14];
%%
n = randi([1 4],1,4); % randomly pick one of the schedule
if  flagModel == 1 && flagExp == 1
    expr.ScheduleSeqOrd{1} = [expr.combination{1,n(1)}];%,expr.combination{2,n(2)}]; % e.g. 1 3 1 3 4 2 4 2
elseif flagModel == 1 && flagExp == 2 
    expr.ScheduleSeqOrd{1} = [expr.combination{2,n(2)}];%,expr.combination{4,n(4)}];
elseif flagModel == 2 && flagExp == 1 
    expr.ScheduleSeqOrd{1} = [expr.combination{3,n(3)}];%,expr.combination{6,n(6)}];
elseif flagModel == 2 && flagExp == 2
    expr.ScheduleSeqOrd{1} = [expr.combination{4,n(4)}];%,expr.combination{8,n(8)}];
end

% introduce extra layer of randomness by fliplr so that 1 3 1 3 becomes 3 1 3 1
nflip = randi([0 1],1);
if nflip
    expr.ScheduleSeqOrd{1} = fliplr(expr.ScheduleSeqOrd{1});
end
expr.ScheduleSeq{1} = repmat(expr.ScheduleSeqOrd{1},1,expr.NblocksLong);

% expr.ScheduleSeq{1} = repmat(expr.ScheduleSeqOrd{1},1,expr.NblocksLong/2);

%     if flagModel==1 % I am assuming that this is experiment one?
%         if flagExp==1                                   % color is volatile
%             expr.ScheduleSeqOrd{1} = [1 3 1 3 4 2 4 2, 3 1 3 1 2 4 2 4] ;
%             % Rs Bs Rs Bs Bt Rt Bt Rt
%         elseif flagExp==2                               % shape is volatile
%             expr.ScheduleSeqOrd{1} = [5 7 5 7 8 6 8 6, 7 5 7 5 6 8 6 8] ;
%         end
%     elseif flagModel==2 % and this is experiment two?
%         if flagExp==1
%             expr.ScheduleSeqOrd{1} = [9 12 9 12 10 11 10 11, 12 9 12 9 11 10 11 10] ;               % r1g1, r2g2
%         elseif flagExp==2
%             expr.ScheduleSeqOrd{1} = [13 15 13 15 14 16 14 16, 15 13 15 13 16 14 16 14] ;           % s1d1, s2d2
%         end
%     end
%         expr.ScheduleSeq{1} = repmat(expr.ScheduleSeqOrd{1}, 1, expr.NblocksLong/4) ;


%% Probability
Pr = [0.9 0.7 0.3 0.1] ; 

%% See Supp Fig 2
% expr.prob(schedule, target)
% target: (1) Square/red, (2) Triangle/red , (3) Square/blue, (4) Triangle/green

%% Exp 1 (Gen)
% schedule 1 Rs
expr.prob(1,1) = Pr(1) ; 
expr.prob(1,2) = Pr(2) ; 
expr.prob(1,3) = Pr(3) ;
expr.prob(1,4) = Pr(4) ;

% schedule 2 Rt
expr.prob(2,1) = Pr(2) ;
expr.prob(2,2) = Pr(1) ;
expr.prob(2,3) = Pr(4) ;
expr.prob(2,4) = Pr(3) ;

% schedule 3 Bs
expr.prob(3,1) = Pr(3) ;
expr.prob(3,2) = Pr(4) ;
expr.prob(3,3) = Pr(1) ;
expr.prob(3,4) = Pr(2) ;

% schedule 4 Bt
expr.prob(4,1) = Pr(4) ;
expr.prob(4,2) = Pr(3) ;
expr.prob(4,3) = Pr(2) ;
expr.prob(4,4) = Pr(1) ;

% schedule 5 rS
expr.prob(5,1) = Pr(1) ;
expr.prob(5,2) = Pr(3) ;
expr.prob(5,3) = Pr(2) ;
expr.prob(5,4) = Pr(4) ;

% Schedule 6 bS
expr.prob(6,1) = Pr(2) ;
expr.prob(6,2) = Pr(4) ;
expr.prob(6,3) = Pr(1) ;
expr.prob(6,4) = Pr(3) ;

% Schedule 7 rS
expr.prob(7,1) = Pr(3) ;
expr.prob(7,2) = Pr(1) ;
expr.prob(7,3) = Pr(4) ;
expr.prob(7,4) = Pr(2) ;

%Schedule 8 bS
expr.prob(8,1) = Pr(4) ;
expr.prob(8,2) = Pr(2) ;
expr.prob(8,3) = Pr(3) ;
expr.prob(8,4) = Pr(1) ;

%% Exp 2 (non-Gen)
% Schedule 9 r1
expr.prob(9,1) = Pr(1) ;
expr.prob(9,2) = Pr(3) ;
expr.prob(9,3) = Pr(4) ;
expr.prob(9,4) = Pr(2) ;

% Schedule 10 r2
expr.prob(10,1) = Pr(3) ;
expr.prob(10,2) = Pr(1) ;
expr.prob(10,3) = Pr(2) ;
expr.prob(10,4) = Pr(4);

% Schedule 11 b1
expr.prob(11,1) = Pr(2) ;
expr.prob(11,2) = Pr(4) ;
expr.prob(11,3) = Pr(3) ;
expr.prob(11,4) = Pr(1) ;

% Schedule 12 b2
expr.prob(12,1) = Pr(4) ;
expr.prob(12,2) = Pr(2) ;
expr.prob(12,3) = Pr(1) ;
expr.prob(12,4) = Pr(3) ;

% Schedule 13 s1
expr.prob(13,1) = Pr(1) ;
expr.prob(13,2) = Pr(4) ;
expr.prob(13,3) = Pr(3) ;
expr.prob(13,4) = Pr(2) ;

% Schedule 14 s2
expr.prob(14,1) = Pr(3) ;
expr.prob(14,2) = Pr(2) ;
expr.prob(14,3) = Pr(1) ;
expr.prob(14,4) = Pr(4) ;

% Schedule 15 t1
expr.prob(15,1) = Pr(2) ;
expr.prob(15,2) = Pr(3) ;
expr.prob(15,3) = Pr(4) ;
expr.prob(15,4) = Pr(1) ;

% Schedule 16 t2
expr.prob(16,1) = Pr(4) ;
expr.prob(16,2) = Pr(1) ;
expr.prob(16,3) = Pr(2) ;
expr.prob(16,4) = Pr(3) ;

% Other combinations not used
% expr.prob(17,1) = Pr(1) ;
% expr.prob(18,1) = Pr(2) ;
% expr.prob(19,1) = Pr(3) ;
% expr.prob(20,1) = Pr(4) ;
% expr.prob(21,1) = Pr(2) ;
% expr.prob(22,1) = Pr(1) ;
% expr.prob(23,1) = Pr(4) ;
% expr.prob(24,1) = Pr(3) ;
% 
% expr.prob(17,2) = Pr(2) ;
% expr.prob(18,2) = Pr(1) ;
% expr.prob(19,2) = Pr(4) ;
% expr.prob(20,2) = Pr(3) ;
% expr.prob(21,2) = Pr(3) ;
% expr.prob(22,2) = Pr(4) ;
% expr.prob(23,2) = Pr(1) ;
% expr.prob(24,2) = Pr(2) ;
% 
% expr.prob(17,3) = Pr(4) ;
% expr.prob(18,3) = Pr(3) ;
% expr.prob(19,3) = Pr(2) ;
% expr.prob(20,3) = Pr(1) ;
% expr.prob(21,3) = Pr(1) ;
% expr.prob(22,3) = Pr(2) ;
% expr.prob(23,3) = Pr(3) ;
% expr.prob(24,3) = Pr(4) ;
% 
% expr.prob(17,4) = Pr(3) ;
% expr.prob(18,4) = Pr(4) ;
% expr.prob(19,4) = Pr(1) ;
% expr.prob(20,4) = Pr(2) ;
% expr.prob(21,4) = Pr(4) ;
% expr.prob(22,4) = Pr(3) ;
% expr.prob(23,4) = Pr(2) ;
% expr.prob(24,4) = Pr(1) ;
end
