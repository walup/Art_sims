classdef LandscapeGenerator
    
    properties
        
        perlinGenerator;
        
    end
    
    
    
    methods
       
        function obj = LandscapeGenerator(persistance, octaves)
            obj.perlinGenerator = PerlinNoise2DGenerator(persistance, octaves);
        end
        
        function landscape = buildLandscape(obj,n,m)
            
            landscape = zeros(n,m);
            frequency = 0.005;
            for i = 1:n
                for j = 1:m
                    landscape(i,j) = obj.perlinGenerator.getCompletePerlinNoise(i*frequency, j*frequency); 
                end 
            end
            %landscape = landscape * 255;
            
            
            colormap winter
            
            figure()
            surf(landscape, 'LineStyle', 'none');
            
        end
        
        
    end
    
    
end