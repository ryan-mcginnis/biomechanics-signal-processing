function [t2a, time_diff] = align_time_simple(t1,d1,t2,d2,plot_flag)
%Function to align time records of data.
%Inputs: 
%1. t1 - reference time vector
%2. d1 - reference data
%3. t2 - time vector to be aligned
%4. d2 - data to be aligned
%5. plot_flag - flag (True/False) indicating desire to plot aligned data

%Outputs:
%1. t2a - aligned time vector
%2. time_diff - time offset

%Re-sample everything to 1000Hz
t1r = (t1(1):0.001:t1(end)).';
t2r = (t2(1):0.001:t2(end)).';
d1r = interp1(t1,d1,t1r);
d2r = interp1(t2,d2,t2r);

%Truncate to ensure that all data starts and ends at roughly the same time
start_time = max([t1r(1), t2r(1)]);
end_time = min([t1r(end), t2r(end)]);
d1r = d1r(t1r>=start_time & t1r<=end_time,:);
t1r = t1r(t1r>=start_time & t1r<=end_time,:);
d2r = d2r(t2r>=start_time & t2r<=end_time,:);
t2r = t2r(t2r>=start_time & t2r<=end_time,:);

%Normalize data by std 
d1r = d1r ./ std(d1r);
d2r = d2r ./ std(d2r);

%Identify time offset to apply to t2
len = max([length(t1r),length(t2r)]);
[c,lags]=xcorr(d1r-mean(d1r),d2r-mean(d2r), len);
[~,indL] = max(c);
time_diff = lags(indL) * 0.001; 
t2a = t2 + time_diff;

if plot_flag
    figure; 
    subplot(311)
    hold on;
    title('original');
    plot(t1, d1,'b');
    plot(t2, d2,'r');

    subplot(312)
    hold on;
    title('time shifted');
    plot(t1, d1,'b');
    plot(t2+time_diff, d2,'r');

    subplot(313)
    hold on;
    title('correlation');
    plot(c);
end

end
