% this is the main code for caculation of correlaion between altimetry
% height and surface area. 

%%%%%%%%%%   update on 9/28/16  %%%%%%%%%%%%%

%% MODIS dates for Surface Area data 
load ('D:\aqua\codesold\modis_dates.mat'); 
DV=datevec(dates); 
for i=1:length(DV); MODIS_t(i,1)=yyyymmdd2doy(DV(i,1)*10000+DV(i,2)*100+DV(i,3)); end
% 
% % ipath = 'D:\JYKim\SWOT_Project\WaterData_MN\20160517_Results\RMGLD\';
% ipath = 'D:\JYKim\SWOT_Project\WaterData_MN\20170403_Results\'; 
%  ifiles=dir([ipath 'ts_*']); 
%  
%  for i=1:length(ifiles); 
%    parts=strsplit(ifiles(i,1).name, {'_', '.mat'});
%    ID(i,1)=str2num(char(parts(1,3))); 
%  end
%  [b,order]=unique(ID(:,1),'first'); 
% v=ID(order,:);  ID=v; 


%%% Target_ID:  1st col:  KMLD ID, 2nd: GLWD ID, 3rd: GRAND ID 

 for jj=1: length(Target_ID); 

 clearvars -except Targets Target_ID  MODIS_t jj Corr    Max_Data Min_Data Num_Data Corr_1 Corr_2 Corr_org Obs RR
   
      ipath = 'D:\aqua\area\'; 
        ifiles=dir([ipath 'ts_','*','_', num2str(Target_ID(jj,3)),'_','*']);
 
if(length(ifiles)>0); 

    %%%%%%   Extract Surface Area data  (ts: timeseries of surface area) 
      for k=1:length(ifiles); 
               filename=[ipath char(ifiles(k,1).name)]; 
                load (filename);    
                I=find(ts_water<0); ts_water(I)=NaN; 
                 t(:,k)=ts_water'; % t_bad(:,k)=ts_bad';  max_v(1,k)=max_val; 
      end
      if(k>=2); ts=t(:,1)+t(:,2); %ts_bad=t_bad(:,1)+t_bad(:,2); 
      else; ts=t; % ts_bad=t_bad; 
      end 
            % ts=ts*0.5*0.5; 
    
%%%%%% Read and Extract the Altimetry Data %%%%%%%                
%ipath = 'D:\JYKim\SWOT_Project\AltimetryData_New\20160810\';   
ipath = 'D:\aqua\alt\';   
 ifiles=dir([ipath num2str(Target_ID(jj,1)),'_*']); 
      
     
TYPE = {'GRLM10', 'GRLM35','LEGOS', 'DAHITI','ESA'}; 
for k=1:5; 
      s=strfind({ifiles.name}, TYPE{1,k});
      if(sum((~cellfun(@isempty,s)))==0); 
          ss(k,1)=0; 
      else;  
      ss(k,1)=1; 
      end
end
I=find(ss>0); 

[GRLM10Raw, GRLM10Smooth, GRLM35Raw, GRLM35Smooth, LEGOS, DAHITI] = Allaltimetry_read (ss, ipath, ifiles); 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 legend_title =  {'GREALM10';'GREALM10f';'GREALM35';'GREALM35f';'LEGOS ';'DAHITI'}; 
 legend_title= cellstr(legend_title ); 

 
 if(sum(ss)>0); 
     
for kk=1:6;     
clear Data

  if((kk==1)&(ss(1,1)==1)); Data(:,1)=GRLM10Raw(:,1); Data(:,2)=GRLM10Raw(:,2)-nanmean(GRLM10Raw(:,2)); color=[0 0 1]; end %color=[0 0.447058826684952 0.74117648601532]; end
  if((kk==2)&(ss(1,1)==1)); Data(:,1)=GRLM10Smooth(:,1); Data(:,2)=GRLM10Smooth(:,2)-nanmean(GRLM10Smooth(:,2)); color=[0 0 1]; end %color=[0 0.447058826684952 0.74117648601532]; end
  if((kk==3)&(ss(2,1)==1));  Data(:,1)=GRLM35Raw(:,1); Data(:,2)=GRLM35Raw(:,2)-nanmean(GRLM35Raw(:,2)); color=[0.5 0 0.5];end; %color=[0.494117647409439 0.184313729405403 0.556862771511078];end    
  if((kk==4)&(ss(2,1)==1));  Data(:,1)=GRLM35Smooth(:,1); Data(:,2)=GRLM35Smooth(:,2)-nanmean(GRLM35Smooth(:,2)); color=[0.5 0 0.5];end; %color=[0.494117647409439 0.184313729405403 0.556862771511078];end    
  if((kk==5)&(ss(3,1)==1));  Data(:,1)=LEGOS(:,1); Data(:,2)=LEGOS(:,2)-nanmean(LEGOS(:,2)); color=[1 0 0];end
  if((kk==6)&(ss(4,1)==1));  Data(:,1)=DAHITI(:,1); Data(:,2)=DAHITI(:,2)-nanmean(DAHITI(:,2)); color=[0 1 0];end %color=[0.466666668653488 0.674509823322296 0.18823529779911];end
   
  
  if exist('Data','var'); 
D_t= Gen_Timeseries(MODIS_t(1,1), MODIS_t(end,1));  
D_t(:,2) = Gen_Composite(MODIS_t, ts, ts, D_t(:,1)); 

C=intersect(Data(:,1),D_t(:,1));  
I=find(ismember(Data(:,1),C));  II= find(ismember(D_t(:,1), C));
%%%  Calculate the correlation 
Corr(jj,kk)=nancorr(D_t(II,2),Data(I,2));


  end
end
 end
end
 end





