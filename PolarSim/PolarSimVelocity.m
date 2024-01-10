%Output Interface Velocity
function velocity=PolarSimVelocity(StartPattern,EndPattern,ST,ET)
%CellLength
CellLength=StartPattern{1,2}(1,end)-StartPattern{1,2}(1,1);
NodeNum=size(StartPattern{1,2},1)-1;
%whether the pattern is polarized
Polarizedornot=[];
for Node=1:NodeNum
    Location=StartPattern{1,1}{Node,2};
    AnteriorStart=StartPattern{1,2}(Node+1,1);PosteriorStart=StartPattern{1,2}(Node+1,end);
    AnteriorEnd=EndPattern{1,2}(Node+1,1);PosteriorEnd=EndPattern{1,2}(Node+1,end);
    %anterior-located node
    if strcmp(Location,'a') && AnteriorStart>PosteriorStart && AnteriorEnd>PosteriorEnd
        Polarizedornot=[Polarizedornot;1];
    %posterior-located node
    elseif strcmp(Location,'p') && AnteriorStart<PosteriorStart && AnteriorEnd<PosteriorEnd
        Polarizedornot=[Polarizedornot;1];
    else
        Polarizedornot=[Polarizedornot;0];
    end
end

if all(Polarizedornot)
    %division plane
    [~,StartDivision]=max(abs(diff(StartPattern{1,2}(2:end,:),1,2)),[],2);
    [~,EndDivision]=max(abs(diff(EndPattern{1,2}(2:end,:),1,2)),[],2);
    Startplane=(StartDivision-1)./99;Endplane=(EndDivision-1)./99;
    velocity=CellLength*(mean(Endplane)-mean(Startplane))./(ET-ST);
else
    velocity='It isn''t a polarized pattern.';
end
end