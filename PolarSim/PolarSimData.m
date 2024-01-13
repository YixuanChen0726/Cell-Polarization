%GUI Data
function PolarSimData(NodeNum,CellLength,Interaction,TimeSpan,dt,SavingInterval,FolderName,WaitProcess)
%Input
%Node number(N)
%interaction Matrix

mywaitbar(0,['Initiation...',num2str(0),'%'],WaitProcess);

%Molecular Name
molecular_set=cell(NodeNum,1);
for i=2:NodeNum+1
    name=Interaction{1,i};
    molecular_set{i-1,1}=[' [',name,']'];
end

%basal parameters
location_set=cell(NodeNum,1);
cytosol_set=zeros(NodeNum,1);
Dm_set=zeros(NodeNum,1);
gamma_set=zeros(NodeNum,1);
alpha_set=zeros(NodeNum,1);
for i=1:NodeNum
    basicstr=Interaction{2,i+1};
    basicpara=strsplit(basicstr,'/');
    %Location:anterior/posterior
    location=basicpara{1,1};location_set{i,1}=location;    
    %cytoplasmic concentration
    cytosol=str2double(basicpara{1,2});cytosol_set(i,1)=cytosol;
    %membrane diffusion coefficient(Dm):matrix(N,1)
    Dm=str2double(basicpara{1,3});Dm_set(i,1)=Dm;
    %Basal association rate(gamma):matrix(N,1)
    gamma=str2double(basicpara{1,4});gamma_set(i,1)=gamma;
    %Basal association rate(gamma):matrix(N,1)
    alpha=str2double(basicpara{1,5});alpha_set(i,1)=alpha;
end

mywaitbar(0.2,['Loading the parameter...',num2str(20),'%'],WaitProcess);
%interactions
q1_set=zeros(NodeNum,NodeNum);
q2_set=zeros(NodeNum,NodeNum);
nq_set=zeros(NodeNum,NodeNum);
k1_set=zeros(NodeNum,NodeNum);
k2_set=zeros(NodeNum,NodeNum);
nk_set=zeros(NodeNum,NodeNum);
for i1=1:NodeNum
    for i2=1:NodeNum
        interstr=Interaction{i1+2,i2+1};
        interpara=strsplit(interstr,'/');
        %activation parameter:q1/q2/nq
        q1=str2double(interpara{1,1});q1_set(i1,i2)=q1;
        q2=str2double(interpara{1,2});q2_set(i1,i2)=q2;
        nq=str2double(interpara{1,3});nq_set(i1,i2)=nq;
        %inhibition parameter:k1/k2/nk
        k1=str2double(interpara{1,4});k1_set(i1,i2)=k1;
        k2=str2double(interpara{1,5});k2_set(i1,i2)=k2;
        nk=str2double(interpara{1,6});nk_set(i1,i2)=nk;
    end
end

mywaitbar(0.4,['Running the simulation...',num2str(40),'%'],WaitProcess);
%simulation
m=0;L=CellLength;

%time step & final timepoint
x=linspace(-L/2,L/2,101);
t=0:dt:TimeSpan;

%main function
sol=pdepe(m,@(x,t,u,ux)pdefun(x,t,u,ux,NodeNum,cytosol_set,Dm_set,gamma_set,alpha_set,q1_set,q2_set,nq_set,k1_set,k2_set,nk_set),@(x)pdeicm(x,NodeNum,location_set),@(xL,uL,xR,uR,t)pdebc(xL,uL,xR,uR,t,NodeNum),x,t);
mywaitbar(0.6,['Organizing the result...',num2str(60),'%'],WaitProcess);
PatternFormation=cell(NodeNum,1);
for i=1:NodeNum
    PatternFormation{i,1}=sol(:,:,i);
end

mywaitbar(0.8,['Saving the data...',num2str(80),'%'],WaitProcess);
%SavingInterval=100;
%saving every time interval
mkdir([FolderName]);
SavingNum=floor(TimeSpan./SavingInterval)+1;
for k1=1:SavingNum
    Pattern=cell(1,2);
    Pattern{1,1}=[molecular_set,location_set];
    Pattern0=zeros(NodeNum+1,101);
    Pattern0(1,:)=x;
    k2=find(t==(k1-1)*SavingInterval);
    for k3=1:NodeNum
        Pattern0(k3+1,:)=PatternFormation{k3,1}(k2,:);
    end
    Pattern{1,2}=Pattern0;
    save(['.\',FolderName,'\Pattern_',num2str((k1-1)*SavingInterval),'.mat'],'Pattern','-v7.3');
end

mywaitbar(1,['Complete! ',num2str(100),'%'],WaitProcess);
%close(bar);
end

%pde function
function [c,f,s]=pdefun(x,t,u,ux,NodeNum,cytosol_set,Dm_set,gamma_set,alpha_set,q1_set,q2_set,nq_set,k1_set,k2_set,nk_set)
c=ones(NodeNum,1);
f=Dm_set.*ux;
s=RateF(u,NodeNum,cytosol_set,gamma_set,alpha_set,q1_set,q2_set,nq_set,k1_set,k2_set,nk_set);
end

%initial curve:sigmoid function
function [u0]=pdeicm(x,NodeNum,location_set)
S=20;B=0;T=1;k=0;
u0=zeros(NodeNum,1);
for i=1:NodeNum
    if strcmp(location_set{i,1},'a')
        u0(i,1)=T-B-(T-B)/(1+exp(-S*(x-k)));
    else
        u0(i,1)=B+(T-B)/(1+exp(-S*(x-k)));
    end
end
end

%boundary condition
function [pL,qL,pR,qR]=pdebc(xL,uL,xR,uR,t,NodeNum)
pL=zeros(NodeNum,1);qL=ones(NodeNum,1);
pR=zeros(NodeNum,1);qR=ones(NodeNum,1);
end

function PathwayInteraction=RateF(u,NodeNum,cytosol_set,gamma_set,alpha_set,q1_set,q2_set,nq_set,k1_set,k2_set,nk_set)
PathwayInteraction=zeros(NodeNum,1);
for i=1:NodeNum
    Fon=0;Foff=0;
    for j=1:NodeNum
        q1=q1_set(i,j);q2=q2_set(i,j);nq=nq_set(i,j);
        k1=k1_set(i,j);k2=k2_set(i,j);nk=nk_set(i,j);
        Fon=Fon+q2*u(j).^nq./(1+q1*u(j).^nq);
        Foff=Foff+k2*u(j).^nk./(1+k1*u(j).^nk);
    end
    PathwayInteraction(i,1)=(gamma_set(i,1)+Fon)*(cytosol_set(i,1))-(alpha_set(i,1)+Foff)*u(i);
end
end

%progress bar function
function mywaitbar(x,varargin)
if nargin < 1
    error('Input arguments not valid');
end
fh = varargin{end};
set(0,'CurrentFigure',fh);
fAxes = findobj(fh,'type','axes');
set(fh,'CurrentAxes',fAxes);
if nargin > 1
    hTitle = get(fAxes,'title');
    set(hTitle,'String',varargin{1});
end
set(gca,'FontSize',15,'Fontname','Times New Roman');
fractioninput = x;
x = max(0,min(100*x,100));
if fractioninput == 0   
    cla
    xpatch = [0 x x 0];
    ypatch = [0 0 1 1];
    xline = [100 0 0 100 100];
    yline = [0 0 1 1 0];
    patch(xpatch,ypatch,[151,198,221]./255,'EdgeColor','k','LineStyle','-','facealpha',0.7);
    set(fh,'UserData',fractioninput);
    l = line(xline,yline);
    set(l,'Color',get(gca,'XColor'));
else
    p = findobj(fh,'Type','patch');
    l = findobj(fh,'Type','line');
    if (get(fh,'UserData') > fractioninput)
        set(p);
    end
    xpatch = [0 x x 0];
    set(p,'XData',xpatch);
    xline = get(l,'XData');
    set(l,'XData',xline);  
end
drawnow;
end
