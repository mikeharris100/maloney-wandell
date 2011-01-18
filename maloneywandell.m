function [illuminant, surfaceArray] = maloneywandell(lightBasis, surfaceBasis, sensorResponseCurves, sensorResponses)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Michael Harris, michael.harris@uea.ac.uk
    % University of East Anglia, Norwich, UK
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Find nullspace of sensor responses, which gives the normal of the
    % plane in the illuminant space
    illuminantPlaneNormal = null(sensorResponses);

    
    % Create a known surface from each basis function individually, then
    % whatever values simultaneously map these surfaces onto the illuminant
    % plane will be the values for epsilon, for 2 surface basis functions
    % this could be written as:
    %
    % baseSurface1 = (repmat(surfaceBasis(:,1),1 ,3) .*lightBasis)' * sensorResponseCurves;
    % baseSurface2 = (repmat(surfaceBasis(:,2),1 ,3) .*lightBasis)' * sensorResponseCurves;
    % epsilon = null([baseSurface1 * illuminantPlaneNormal,  baseSurface2 * illuminantPlaneNormal]');
    
    baseSurfaces = zeros(size(surfaceBasis, 2), size(sensorResponseCurves,2));
    for i = 1 : size(surfaceBasis, 2)
        baseSurfaces(i,:) =  (repmat(surfaceBasis(:,i),1 ,size(lightBasis,2)) .*lightBasis)' * sensorResponseCurves * illuminantPlaneNormal;
    end
    
    epsilon = null(baseSurfaces);
    
    % The estimate for the illuminant
    illuminant = lightBasis * epsilon;

    % Create the lighting matrix using the illuminant estimate
    lightingMatrix = zeros(size(lightBasis,2),size(surfaceBasis,2));
    for k = 1:size(lightBasis,2)
        for j = 1:size(surfaceBasis,2)
            lightingMatrix(k,j) = sum(illuminant.*surfaceBasis(:,j).*sensorResponseCurves(:,k));
        end
    end

    % Convert sensor responses into sigma values
    surfaceArray = zeros(size(surfaceBasis, 1), size(sensorResponses, 1));
    for i = 1:size(sensorResponses, 1)
        surfaceArray(:,i) = surfaceBasis * (lightingMatrix\sensorResponses(i,:)');
    end
    
end