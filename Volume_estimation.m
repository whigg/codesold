% sortedTimeSeries[n].append(0)
% 			sortedTimeSeries[n].append(((sortedTimeSeries[c][1]/1000) * .5*sortedTimeSeries[c][2]))
% 			c += 1
% 			print sortedTimeSeries[n]
% 			continue
% 		if c == len(sortedTimeSeries):
% 			continue
% 		
% 		diffArea = sortedTimeSeries[c][2] - sortedTimeSeries[c-1][2]
% 		diffHeight = sortedTimeSeries[c][1] - sortedTimeSeries[c-1][1]
% 		diffVolume = sortedTimeSeries[c-1][3] + ((diffHeight/1000) * (sortedTimeSeries[c-1][1] + .5*diffArea))
% 		#volume = ((sortedTimeSeries[c][2]/1000) * .5*sortedTimeSeries[c][1])	#temp
% 		volume = (sortedTimeSeries[c][2] * sortedTimeSeries[c][1]) / 1000
% 
%         Area=D_t(II,2); Depth=Alt_Comb(I,2); 
% for k=1:length(Area); 
%         Relat_Vol(k+1,1)=((Depth(k+1,1)-Depth(k,1))/1000)*(Depth(k,1)+ ((Area(k+1,1)-Area(k,1))*0.5)); 
% end
%         plot(
%         
%         
%          Area=(D_t(II,2))-nanmin(D_t(II,2)); Depth=Alt_Comb(I,2)-nanmin(Alt_Comb(I,2)); 
%          
%         for k=1:length(Area); 
%             Sort_Time(k,1)=0.5*(Depth(k,1)/1000)*Area(k,1); 
%         end  
%         I=find(Sort_Time==min(Sort_Time)); 
%         for k=1:length(Area); 
%         Relat_Vol(k+1,1)=((Depth(k+1,1)-Depth(k,1))/1000)*(Depth(k,1)+ ((Area(k+1,1)-Area(k,1))*0.5)); 
%         end
        

%      Area=(D_t(II,2))*463.3*463.3; Depth=Alt_Comb(I,2)-nanmin(Alt_Comb(I,2)); 
% %         Area=(D_t(II,2))-nanmin(D_t(II,2)); Depth=Alt_Comb(I,2)-nanmin(Alt_Comb(I,2)); 
%      Data=[C Depth Area]; 
%      Vol=(0.5*(Depth).*Area)  ;     % unit: m^3; 
%      Sort_Data=  sortrows(Data,3);
%      
%      diffVol(1,1)=(0.5*(Sort_Data(1,2)).*Sort_Data(1,3))  ; 
%      for k=2:length(Sort_Data); 
%          diffArea(k,1)=Sort_Data(k,3)-Sort_Data(k-1,3); 
%          diffDepth(k,1)=Sort_Data(k,2)-Sort_Data(k-1,2); 
%          diffVol(k,1)=diffVol(k-1,1)+ ( (diffDepth(k,1)) *  (Sort_Data(k-1,3)+0.5*diffArea(k,1)) ); 
%      end
%     % Volume=Sort_Data(:,3).*Sort_Data(:,2)./2000; 
%      DD=[Sort_Data(:,1) diffVol(:,1)]; 
%         DD2=sortrows(DD,1); 
%         plot(DD2(:,2)-min(DD2(:,2)))
%      
%      
     
%%%%%%%%%%%%%%   11/16/2016 
%%%%% Main code for volume (storage) estimate 

% clear diffArea diffDepth diffVol Depth Vol Sort_Data DD DD2 Data Data2 
%Data=LEGOS4470; 

% Load the data 
   Data=[C Area Depth];   % C: time, Area: Surface Area Timeseries, Depth: Altimetry height timeseries
   I=find((Data(:,2)>0)&(Data(:,3)>-100));  
   Data=Data(I,:);  
   Data(:,2)=Data(:,2)*463.3*463.3;   % Convert to meter
   Sort_Data=  sortrows(Data,2);
     
     diffVol(1,1)=(0.5*(Sort_Data(1,3)).*Sort_Data(1,2))  ; 
     for k=2:length(Sort_Data); 
         diffArea(k,1)=Sort_Data(k,2)-Sort_Data(k-1,2); 
         diffDepth(k,1)=Sort_Data(k,3)-Sort_Data(k-1,3); 
         diffVol(k,1)=diffVol(k-1,1)+ ( (diffDepth(k,1)) *  (Sort_Data(k-1,2)+0.5*diffArea(k,1)) ); 
     end
    % Volume=Sort_Data(:,3).*Sort_Data(:,2)./2000; 
     DD=[Sort_Data(:,1) diffVol(:,1)]; 
     DD2=sortrows(DD,1); 
        
 Vol_est=[Data(:,1) DD2(:,2)-min(DD2(:,2))];    % 1st colume: Time, 2nd colume:  relative volume change (m^3) 

 
 % write output in text file 
 ipath = 'D:\JYKim\SWOT_Project\WaterData_MN\'; 
 text_file=([ipath 'Storage_',num2str(Target_ID(kk,1)),'.txt']);
 dlmwrite(text_file,Vol_est,'delimiter',' ','precision','%.3f')
 
       