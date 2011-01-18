clear all;
load data/GRA31
load data/surfs1995

%%%% THESE CAN BE ADJUSTED TO TEST %%%
nSensors = 3;
nSurfaces = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nSensors < 3 || nSensors > 4
    throw(MException('ResultChk:OutOfRange', ...
        'Test data is only available for 3 or 4 sensors'));
end

if nSensors == 3
    load data/RGB
    sensorResponseCurves = RGB;
end

if nSensors ==4
    load data/sensor4
    sensorResponseCurves = sensor4;
end

% Create some bases
lightBasis = GRA31(:,randi(size(GRA31, 2), 1, nSensors));
surfaceBasis = surfs1995(:, randi(size(surfs1995, 2), 1, nSensors-1));

% Create an illuminant and some surfaces from the basis functions
trueIlluminant = (rand(1, size(lightBasis, 2))*lightBasis')';
trueSurfaceArray = (rand(nSurfaces, size(surfaceBasis, 2))*surfaceBasis')';

% Generate sensors responses from illuminant and surfaces
sensorResponses = ((repmat(trueIlluminant, 1, nSurfaces).*trueSurfaceArray)' * sensorResponseCurves);

% Run the algorithm
[estimateIlluminant, estimateSurfaceArray] = maloneywandell(lightBasis, surfaceBasis, sensorResponseCurves, sensorResponses);

% Pick an arbitrary surface
trueSurface = trueSurfaceArray(:,1);
estimateSurface = estimateSurfaceArray(:,1);

% Plot the true surface reflectance against the estimate
plot([trueSurface, estimateSurface]);