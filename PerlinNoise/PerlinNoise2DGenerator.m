classdef PerlinNoise2DGenerator
properties
    
    gridN;
    yArr;
    octaves;
    p;
end



methods
    
    function obj = PerlinNoise2DGenerator(p, octaves)
        obj.octaves = octaves;
        obj.p = p;
        obj.gridN = 256;
        obj.yArr = 1:obj.gridN;
        %Shuffle the numbers
        for i= 1:obj.gridN
            nextIndex = randi([1,obj.gridN]);
            temp = obj.yArr(i);
            obj.yArr(i) = obj.yArr(nextIndex);
            obj.yArr(nextIndex) = temp;
        end
    end
    
    function n = computePerlinNoise(obj, x, y)
       col = int32(mod(floor(x), obj.gridN))  + 1;
       row = int32(mod(floor(y), obj.gridN)) + 1;
       
       xRes = x - floor(x);
       yRes = y - floor(y);
       
       %Vectores que van desde las esquinas de la cuadrícula hacia el punto
       %donde sacaremos el ruido
       trToPoint = [xRes-1, yRes-1];
       tlToPoint = [xRes, yRes-1];
       brToPoint = [xRes-1, yRes];
       blToPoint = [xRes, yRes];
       
       %disp(mod(obj.yArr(mod(col + 1,obj.gridN))+row+1, obj.gridN))
       valueTopRight = obj.yArr(mod(obj.yArr(mod(col,obj.gridN)+1)+row+1, obj.gridN) +1);
       valueTopLeft = obj.yArr(mod(obj.yArr(col)+row+1, obj.gridN) +1);
       valueBottomRight = obj.yArr(mod(obj.yArr(mod(col, obj.gridN)+1) + row, obj.gridN) +1);
       valueBottomLeft = obj.yArr(mod(obj.yArr(col) + row, obj.gridN)+1);
       
      
       dotTopRight = trToPoint*obj.getCornerVector(valueTopRight)';
       dotTopLeft = tlToPoint*obj.getCornerVector(valueTopLeft)';
       dotBottomRight = brToPoint*obj.getCornerVector(valueBottomRight)';
       dotBottomLeft = blToPoint*obj.getCornerVector(valueBottomLeft)';
       
       u = obj.fade(xRes);
       v = obj.fade(yRes);
       
       n = obj.linearInterpolation(u, obj.linearInterpolation(v, dotBottomLeft, dotTopLeft), obj.linearInterpolation(v, dotBottomRight, dotTopRight));
    end
    
    function n = getCompletePerlinNoise(obj, x, y)
       n = 0;
       for i = 0:obj.octaves-1
          n = n + (obj.p^i)*obj.computePerlinNoise((2^i)*x, (2^i)*y);
       end
    end
    
    
    function vec = getCornerVector(obj,val)
       h = mod(val, 4);
       if(h == 0)
          vec = [1,1];
       elseif(h == 1)
           vec = [-1,1];
       elseif(h == 2)
           vec = [-1,-1];
       else
           vec = [1,-1];
       end
    end
    
    
    function y = linearInterpolation(obj,t,a1, a2)
       y = a1 + t*(a2 - a1); 
    end
    
    function y = fade(obj, t)
        y = 6*t^5 - 15*t^4 +10*t^3;
    end
    
    
    
end
    
    
    
    
end
