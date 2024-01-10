%Plot Figure
function plane=PolarSimPlot(Pattern)
%calculate the transition plane
NodeNum=size(Pattern{1,2},1)-1;
x=Pattern{1,2}(1,:);
L=max(x)-min(x);
%whether the pattern is polarized
Polarizedornot=[];
for Node=1:NodeNum
    Location=Pattern{1,1}{Node,2};
    Anterior=Pattern{1,2}(Node+1,1);Posterior=Pattern{1,2}(Node+1,end);
    %anterior-located node
    if strcmp(Location,'a') && Anterior>Posterior
        Polarizedornot=[Polarizedornot;1];
    %posterior-located node
    elseif strcmp(Location,'p') && Anterior<Posterior
        Polarizedornot=[Polarizedornot;1];
    else
        Polarizedornot=[Polarizedornot;0];
    end
end

if all(Polarizedornot)
    %division plane
    [~,Division]=max(abs(diff(Pattern{1,2}(2:end,:),1,2)),[],2);
    percentplane=(Division-1)./99;
    plane=L*mean(percentplane)+min(x);
else
    plane='Transition plane doesn''t exist.';
end


figure
%Molecular Name
molecular_set=Pattern{1,1}(:,1);
%location
location_set=Pattern{1,1}(:,2);
AnMatrix=strcmp('a',location_set);
%Pattern Information
Pattern0=Pattern{1,2}(2:end,:);

%colorfunction
%anterior
color_anraw=[172,73,122
218,180,218
183,37,37
231,167,181
241,106,67
253,216,133
246,106,109
251,185,105
221,75,74
136,0,55
224,132,165
135,41,145];
colorFunc=colorFuncFactory(color_anraw);
color_an=colorFunc(linspace(0,1,NodeNum))./255;
%posterior
color_poraw=[23,85,148
173,127,236
65,152,182
196,229,122
17,119,102
122,200,165
62,122,152
116,122,219
180,190,44
82,125,153
125,179,239
72,59,141];
colorFunc=colorFuncFactory(color_poraw);
color_po=colorFunc(linspace(0,1,NodeNum))./255;

%plot figure
annum=0;posnum=0;
for i=1:NodeNum
    if AnMatrix(i,1)==1
        annum=annum+1;
        plot(x,Pattern0(i,:),'Color',color_an(annum,:),'Linewidth',2.25);hold on;
    else
        posnum=posnum+1;
        plot(x,Pattern0(i,:),'Color',color_po(posnum,:),'Linewidth',2.25);hold on;
    end 
end
legend(molecular_set,'Location','eastoutside');


xlabel('\itx');xticks([-L/2 0 L/2]);
ylabel('Concentration');
set(gca,'FontSize',22,'Fontname','Arial');
y_updata=ceil(max(max(Pattern0)));
axis([-L/2 L/2 -0.1 y_updata+0.1]);%axis square;
set(gcf,'unit','centimeters','position',[10 5 15 8]);
end

function colorFunc=colorFuncFactory(colorList)
x=(0:size(colorList,1)-1)./(size(colorList,1)-1);
y1=colorList(:,1);y2=colorList(:,2);y3=colorList(:,3);
colorFunc=@(X)[interp1(x,y1,X,'linear')',interp1(x,y2,X,'linear')',interp1(x,y3,X,'linear')'];
end