function Convolution

% Vertical Resolution
%
% In this code we demonstrate how changing the wavelet frequency affects Seismic vertical
% resolution.
% 
% Author: Haydar E. Khayou
% Department of Geology - Faculty of Sciences - Damascus University 

%% Preparation
clear;
clc;
load('Sections.mat');             % This is an experimental Data contains RC matix.
load('Seis_maps.mat');            % Maps to plot

%% Wavelet prameters
Sampling_Interval= 1/1000;                     % Sampling Interval in Sec
NumberOfSamples= (10/Sampling_Interval)+1;       % Must be enough to make sure the whole wavelet is plotted
                                               % (must contains zeros at the sides)
NumberOfSamples= round(NumberOfSamples, 0);

t0= 0;    % This determines where the peak/trough must appear. In our case
          % we generate a zero-phase wavelet that shows its peak at 0.
%% Processing
% In this section we generate the wavelet with a certain frequency and 
% convolve it with the RC matrix then we plot the results

for iter=1:0.2:120
    Freqeuncy= iter;
    
    % Generate Ricker wavelet with the above parameters
    [Wavelet, t]= Edited_ricker(Freqeuncy, NumberOfSamples, Sampling_Interval, t0);
    
    
    % delete the unnecessary 0 Values of the Wavelet and make sure it is still
    %  symmetric
    for it=1:length(Wavelet) % start from 1 to end and determine where the non zero values starts
        if Wavelet(it)~=0
            Left= it-1;      % the left coordinate of the wavelet contains one zero
            Left= max(1, Left); % sometimes because we choose a small number of NumberOfSamples the wavelet
            break;              % is already cut and doesn't have zeros! 
        end
    end
    
    for ite=length(Wavelet):-1:1 % The same as the previous loop but here we determine the coordinate
        if Wavelet(ite)~=0       % at which the zeros end.
            Right= ite+1;
            Right= min(Right, length(Wavelet));
            break;
        end
    end
    
    % Modify the Wavelet and Time rows
    t= t(1, Left:Right);                  % Trim the Time row
    Wavelet= Wavelet(1, Left:Right);      % Trim the Wavelet row  
    
    
    % Convolove the Wavelet with the RC matrix
    Res= conv2(Wavelet, 1, RC_Matrix_RHG);
    
    % The convolved matrix is larger in size(Rows) than the RC matrix so we have
    % to trim the values from the begining and ending of the Res matrix so
    % they match each other.
    
    S1= size(Res, 1);                  % Convoloved matrix size
    S2= size(RC_Matrix_RHG, 1);        % RC matrix size
    dif= (S1 - S2)/2;                  % dif is the values we must delete from the begining and ending of RC
    Res(1:dif, :)= [];                 % Delete dif from the begining of the matrix
    Res(end:-1:(end-dif)+1, :)= [];    % Delete from the end of the matrix
    
    
    T= 1:size(Res,1);
    
    if iter>1
        cla(h1);
        cla(h2);
        cla(h3);
        cla(h4);
        cla(h5);
    end
    subplot(4, 8, [1 25]);plot(RC_Matrix_RHG(:, 1), T);
    h1= gca;
    h1.YDir= 'reverse';
    title('RC series');
    grid on;
    
    subplot(4,8,[2 26]);plot(Wavelet, t);
    h2= gca;
    h2.YDir= 'reverse';
    title({'Wavelet'; ['Frequency= ' num2str(round(Freqeuncy, 0)) ' Hz']}, 'Color', 'b');
    grid on;
    subplot(4,8,[3 27]);plot(Res(:,1), T);
    h3= gca;
    h3.YDir= 'reverse';
    title({'1D Synthetic'});
    grid on;
    subplot(4,8,[4 16]);imagesc(RC_Matrix_RHG);
    h4= gca;
    title({'Subsurface geology'});
    subplot(4,8,[20 32]);imagesc(Res);
    hold on
    plot([1:1:size(Res, 2)]+Res(:, 1:1:end), T, 'k');
    h5= gca;
    colormap(Red_blue_map);
    title({'Synthetic Section'});
    xlabel('Coded by Haydar Khayou - Damascus University', 'Color', 'b');
    drawnow;
end


