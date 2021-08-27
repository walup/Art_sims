classdef PerlinNoiseDrawer
    
   properties
       perlinGenerator;
       noiseGrid;
       gradientMatrix;
       seedsTable;
       n;
       m;
       
   end
   
   
   
   methods
       
       function obj = PerlinNoiseDrawer(nSeeds, octaves, persistance, frequency)
           %Lo primero que haremos es crear una cuadricula de ruido perlin
           obj.perlinGenerator = PerlinNoise2DGenerator(persistance, octaves);
           
           
           n = 500;
           m = 500;
           
           obj.n = n;
           obj.m = m;
           
           obj.noiseGrid = zeros(n,m);
           f = waitbar(0,'Obteniendo ruido');
           for i = 1:n
               for j = 1:m
                   obj.noiseGrid(i,j) = obj.perlinGenerator.getCompletePerlinNoise(i*frequency, j*frequency);                   
               end
           end
           
           %Ahora vamos a crear nuestra matriz de gradientes
           waitbar(0.33,f,'Calculando matriz de gradientes');
           obj.gradientMatrix = zeros(n,m,2);
           for i = 1:n
               for j = 1:m
                   angle = 2*pi*obj.noiseGrid(i,j);
                   vec = [cos(angle), sin(angle)];
                   obj.gradientMatrix(i,j,:) = vec;
               end
           end
           
           %Vamos a llenar nuestra matriz de semillas
           waitbar(0.66,f,'Creando matriz de semillas');
           obj.seedsTable = zeros(nSeeds, 2);
           for i =1:nSeeds
               xCord = 1 + rand()*(m - 1);
               yCord = 1 + rand()*(n - 1);
               
               vec = [xCord, yCord];
               obj.seedsTable(i,:) = vec;
           end
           waitbar(0.99,f,':)');
           close(f)
       end
       
       
       function h = drawMovement(obj, steps,deltaT)
           nSeeds  = size(obj.seedsTable, 1);
           movementTable = zeros(steps, nSeeds, 2);
           
           for i = 1:nSeeds
              seed = obj.seedsTable(i,:);
              seed = reshape(seed,[1, 2]);
              for j = 1:steps
                  velocity = obj.gradientMatrix(floor(seed(1)), floor(seed(2)),:);
                  velocity = reshape(velocity,[1,2]);
                  if(seed(1) + velocity(1)*deltaT > 1 && seed(1) + velocity(1)*deltaT < obj.m && seed(2) + velocity(2)*deltaT> 1 && seed(2) + velocity(2)*deltaT<obj.n)
                     seed = seed + velocity*deltaT;
                  end
                  movementTable(j,i,:) = seed;                 
              end
           end
           
           %Una vez que hemos llenado la tabla de movimientos
           %vamos a dibujar
           h = figure()
           hold on 
           for i = 1:nSeeds
              timeSeries = movementTable(:,i,:);
              timeSeries = reshape(timeSeries, [steps, 2]);
              
              plot(timeSeries(:,1), timeSeries(:,2), 'LineWidth', 0.5, 'Color', [0,0,0,0.5])
           end
           hold off 
       end
       
       
       function h = drawMovementBlackBackground(obj, steps,deltaT)
           nSeeds  = size(obj.seedsTable, 1);
           movementTable = zeros(steps, nSeeds, 2);
           
           for i = 1:nSeeds
              seed = obj.seedsTable(i,:);
              seed = reshape(seed,[1, 2]);
              for j = 1:steps
                  velocity = obj.gradientMatrix(floor(seed(1)), floor(seed(2)),:);
                  velocity = reshape(velocity,[1,2]);
                  if(seed(1) + velocity(1)*deltaT > 1 && seed(1) + velocity(1)*deltaT < obj.m && seed(2) + velocity(2)*deltaT> 1 && seed(2) + velocity(2)*deltaT<obj.n)
                     seed = seed + velocity*deltaT;
                  end
                  movementTable(j,i,:) = seed;                 
              end
           end
           
           %Una vez que hemos llenado la tabla de movimientos
           %vamos a dibujar
           
           grid off
           
           h = figure()
           set(gca,'Color','#000000')
           hold on 
           for i = 1:nSeeds
              timeSeries = movementTable(:,i,:);
              timeSeries = reshape(timeSeries, [steps, 2]);
              
              plot(timeSeries(:,1), timeSeries(:,2), 'LineWidth', 0.2, 'Color', '#ffffff')
           end
           hold off 
       end
       
       
   end
    
    
    
end