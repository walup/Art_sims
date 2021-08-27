classdef Histogram
    
   properties
       
       
   end
   
   
   
   methods
       function [xVals, h] = computeHistogram(obj, data)
           nData = length(data);
           nBins = floor(sqrt(length(data)));
           h = zeros(1, nBins);
           xMin = min(data);
           xMax = max(data);
           intervalSize = (xMax - xMin)/nBins;
           xVals = linspace(xMin, xMax, nBins);
           for i = 1:nData
               index = floor((data(i) - xMin)/intervalSize) + 1;
               if(index ~= nBins+1)
                   h(index) = h(index) + 1;
               else
                   h(index - 1) = h(index - 1) + 1;
               end
               
           end
           
       end
       
   end
   
    
    
    
end