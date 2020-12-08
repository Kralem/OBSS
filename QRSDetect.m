function idx = QRSDetect(filename, M, WS, WSDecision)
  %we load the signal here
  signal = load(filename);
  x = signal.val(1,:);

  %1. High-pass filter
  y = zeros(1, size(x,2));
  for n=1:size(x,2)
    if (n >= M)   %In the line beneath, we do "i-M" and we do not want negative array indices.
      y1   = (1/M) * sum(x((n - (M - 1)) : n)); %this is the equation from the chen paper
      y2   = x(n - ((M + 1)/2));
      y(n) = y2 - y1;
    else
      y(n) = 0;
    end
  end

  %2. Low-pass filter
  for n = 1 : (size(x,2) - WS - 1)
    y(n) = sum(y(n : n + WS).^2);
  end 

  %To correct the offset that we created in LPF phase.
  y = [zeros(1,floor((WS+1)/2)) y(1:numel(y-3))];

  
  %Decision making.
  thresholdCompute = @(alpha, gamma, peak, threshold) alpha * gamma * peak + (1 - alpha) * threshold;
  
  alpha = 0.05; %chen says alpha should be less be less than 1 and gamma should be 0.15
  gamma = 0.15;
  
  threshold = max(y(1:WSDecision));
    
  %Iterate through the points with the step of window size.
  for n = 1:WSDecision:length(y)-WSDecision
     [max_v,max_i] = max(y(n:n+WSDecision));
     if max_v >= threshold
         y(max_i+n) = 1;
         %Updating the threshold when finding the peak.
         threshold = thresholdCompute(alpha, gamma, max_v, threshold);
     end
  end
  
  idx = find(y==1);
  
 end
