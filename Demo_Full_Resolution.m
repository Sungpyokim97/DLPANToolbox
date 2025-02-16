%%%%%%%%%%%%%%%%%%%%%%%%%%%For FUll-Resolution%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  1) This is a test demo to show all full-resolution results of traditional and DL methods
%     Here, we take WV3 test dataset as example. Readers can change the corresponding director 
%     and setting to test other/your datasets
%  2) The codes of traditional methods are from the "pansharpening toolbox for distribution",
%     thus please cite the paper:
%     [1] G. Vivone, et al., A new benchmark based on recent advances in multispectral pansharpening: Revisiting
%         pansharpening with classical and emerging pansharpening methods, IEEE Geosci. Remote Sens. Mag., 
%         9(1): 53�C81, 2021
%  3) Also, if you use this toolbox, please cite our paper:
%     [2] L.-J. Deng, et al., Machine Learning in Pansharpening: A Benchmark, from Shallow to Deep Networks, 
%         IEEE Geosci. Remote Sens. Mag., 2022

%  LJ Deng (UESTC), 2020-02-27

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: the test dataset of full-resolution are too huge to upload to
% GitHub, thus we provide cloud links to readers to download them to
% successfully run this demo, including:

% i) Download link for full-resolution WV3-NewYork example (named "NY1_WV3_FR.mat"):
%     http:********   (put into the folder of "1_TestData/Datasets Testing")

% ii) Download link of DL's results for full-resolution WV3-NewYork example:
%     http:********   (put into the folder of "'2_DL_Result/WV3")

% Once you have above datasets, you can run this demo successfully, then
% understand how this demo run!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all;
% Tools
addpath([pwd,'/Tools']);
%% =======load directors========

% Tools
algorithms = {'EXP','BT-H','BDSD-PC','C-GSA','SR-D',...
    'MTF-GLP-HPM-R','MTF-GLP-FS','TV','PanNet','DRPNN','LAGNet','MSDCnn','DCPNet','S2DBPN','BDPN','DiCNN','PNN','APNN','FusionNet','PanDiff','ours_t'};


% sensor = 'WV3';
% sensor = 'QB';
sensor = 'GF2';

% Initialization of the Matrix of Results
NumIndexes = 3;
header = {'model','D_lambda', 'D_s', 'HQNR'};
MatrixResults = zeros(numel(algorithms),NumIndexes);
FR_matrix = cell(numel(algorithms),NumIndexes+1);
FR_matrix(1, :) = header;

flagQNR = 0; %% Flag QNR/HQNR, 1: QNR otherwise HQNR
n = 1;

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
end
    
thvalues = 0;% Threshold values out of dynamic range
%     printEPS = 0;% Print Eps
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Rebuttal_only_soft ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'rebuttal_only_soft';

file_fusionnet = strcat(model,'/','test_iter_300000_full_gf2.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, 1, data);

n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Rebuttal_only_hard ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'rebuttal_only_hard';

file_fusionnet = strcat(model,'/','test_iter_300000_full_gf2.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, 1, data);

n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== PanNet Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'PanNet';

file_fusionnet = strcat(model,'/','test_',model,'_',small,'_full.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);

n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;

%% ====== MSDCnn Method ======
model = 'MSDCnn';

file_fusionnet = strcat(model,'/','test_',model,'_',small,'_full.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;

%% ====== FusionNet Method ======
model = 'FusionNet';

file_fusionnet = strcat(model,'/','test_',model,'_',small,'_full.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;

%% ====== LAGNet Method ======
model = 'LAGNet';

file_fusionnet = strcat(model,'/','test_',model,'_',small,'_full.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== S2DBPN Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'S2DBPN';

file_fusionnet = strcat(model,'/','test_',model,'_',small,'_full.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== DCPNet Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'DCPNet';

file_fusionnet = strcat(model,'/','test_',model,'_',small,'_full.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== PanDiff Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'PanDiff';

if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'PanDiff/test_iter_32000_full_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'PanDiff/test_iter_16000_full_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'PanDiff/test_iter_30000_full_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== TMDiff Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'TMDiff';

if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'TMDiff/test_save_gf2_OrigScale_multiExm1.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'TMDiff/test_save_qb_OrigScale_multiExm1.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'TMDiff/test_save_wv3_OrigScale_multiExm1.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== CANConv Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'CANConv';

if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'CANConv/test_save_gf2_OrigScale_multiExm1.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'CANConv/test_save_qb_OrigScale_multiExm1.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'CANConv/test_save_wv3_OrigScale_multiExm1.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== ours_t Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'ours_t';

if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'prior_FTCA_SWTCA_teacher/test_iter_300000_full_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'prior_FTCA_SWTCA_teacher/test_iter_112500_full_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'prior_FTCA_SWTCA_teacher/test_iter_147500_full_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== ours_s Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'ours_s';

if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'prior_FTCA_SWTCA_student/test_iter_280000_full_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'prior_FTCA_SWTCA_student/test_iter_107500_full_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'prior_FTCA_SWTCA_student/test_iter_300000_full_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ours student_L1 Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'ours_s_L1';

if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'prior_FTCA_SWTCA_student/test_iter_300000_full_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'Ab_student_L1/test_iter_112500_full_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'Ab_student_L1/test_iter_300000_full_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ablation_student_L1 Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'Ablation_student_L1';

if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'Ab_student_L1/test_iter_300000_full_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = '';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'prior_FTCA_SWTCA_teacher/L1/test_iter_65000_full_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ablation student_KD(1_0.3_0.001) Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'ours_s_kd_1_0.3_0.001';

if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'Ab_student_kd/test_iter_300000_full_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'Ab_student_L1/test_iter_112500_full_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'Ab_student_L1/test_iter_300000_full_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ablation student_KD uncertainty x Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'Ablation_kd_uncertainty x';

if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'Ab_student_uncertaintyx/test_iter_300000_full_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'Ab_student_L1/test_iter_112500_full_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'Ab_student_L1/test_iter_300000_full_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

