%% 
% Run 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 and 11
% Test a image, run 12


%% 1
red = alexnet;
%% 2
capas = red.Layers; 
capas; 
%% 3
carpetaTrain = 'C:\Users\ddzam\Documents\Red_Neuronal\Datasets\Train'; 
variables = {'Perro','Gato', 'Persona'}; 
imds = imageDatastore(fullfile(carpetaTrain, variables), 'LabelSource', 'foldernames');
imds = splitEachLabel(imds, 1000, 'randomize');
imds.ReadFcn = @readFunctionTrain; 

%% 4
capas = capas(1:end-3);
capas(end+1) = fullyConnectedLayer(64, 'Name', 'special_2');
capas(end+1) = reluLayer;
capas(end+1) = fullyConnectedLayer(3, 'Name', 'fc8_2 ');
capas(end+1) = softmaxLayer;
capas(end+1) = classificationLayer();

%% 5
capas(end-2).WeightLearnRateFactor = 10;
capas(end-2).WeightL2Factor = 1;
capas(end-2).BiasLearnRateFactor = 20;
capas(end-2).BiasL2Factor = 0;

%% 6
config = trainingOptions('sgdm', ...
    'LearnRateSchedule', 'none',...
    'InitialLearnRate', .0001,... 
    'MaxEpochs', 20, ...
    'MiniBatchSize', 128);
%% 7
modelo = trainNetwork(imds, capas, config);

%% 8
save('C:\Users\ddzam\Documents\Red_Neuronal\modelo.mat', 'modelo');

%% 9
carpetaPruebas = 'C:\Users\ddzam\Documents\Red_Neuronal\Datasets\Test';
testDS = imageDatastore(fullfile(carpetaPruebas, variables), 'LabelSource', 'foldernames');
testDS.ReadFcn = @readFunctionTrain;

%% 10
load modelo.mat % Modelo entrenado y guardado
[labels,err_test] = classify(modelo, testDS, 'MiniBatchSize', 64);
confMat = confusionmat(testDS.Labels, labels); 
confMat = confMat./sum(confMat,2);
mean(diag(confMat))
%% 11
YPred = classify(modelo,imds);
YValidation = imds.Labels; 
plotconfusion(YValidation,YPred);
accuracy = sum(YPred == YValidation)/numel(YValidation);

%% 12
load modelo.mat 
im = imread('C:\Users\ddzam\Documents\Red_Neuronal\Datasets\Train\Gato\54.png'); 
im = imresize(im, [227 227]);
[labelpredict, err] = classify(modelo, im);
err
err(1);
err(2);
err(3); 
figure; 
imshow(im) 
rangoPrecision = 0.50; % 50% 
rangoVerificar = 0.20; % 20% 
if err(1) > rangoPrecision || err(2) > rangoPrecision || err(3) > rangoPrecision
    if err(1) > rangoPrecision && (err(2)> rangoVerificar || err(3) > rangoVerificar)
        title({['ERROR,'] 
               ['El modelo lo reconoce como ' upper(char(labelpredict))]
               ['pero la predicción es elevada en las otras variables']
               });  %#ok<NBRAK>
    elseif err(2) > rangoPrecision && (err(1)> rangoVerificar || err(3) > rangoVerificar)
        title({['ERROR,'] 
               ['El modelo lo reconoce como ' upper(char(labelpredict))]
               ['pero la predicción es elevada en las otras variables']
               });  %#ok<NBRAK>
    elseif err(3) > rangoPrecision && (err(2)> rangoVerificar || err(1) > rangoVerificar)
        title({['ERROR,'] 
               ['El modelo lo reconoce como ' upper(char(labelpredict))]
               ['pero la predicción es elevada en las otras variables']
               });  %#ok<NBRAK>
    else
        title(upper(char(labelpredict)));
    end
else
    title(upper(char('ERROR NO SUPERA EL 50% DE PRECISIÓN')));
end

