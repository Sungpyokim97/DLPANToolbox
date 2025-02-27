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


% 측정하려는 데이터셋만 주석제거
% sensor = 'WV3';
% sensor = 'QB';
sensor = 'GF2';

% % Initialization of the Matrix of Results
% NumIndexes = 3;
% header = {'model','D_lambda', 'D_s', 'HQNR'};
% MatrixResults = zeros(numel(algorithms),NumIndexes);
% FR_matrix = cell(numel(algorithms),NumIndexes+1);
% FR_matrix(1, :) = header;

% Initialization of the Matrix of Results
NumIndexes = 7;
header = {'model','D_lambda', 'D_s', 'HQNR', 'SCC_F', 'SAM_F', 'ERGAS_F','JQM'};
MatrixResults = zeros(numel(algorithms),NumIndexes);
FR_matrix = cell(numel(algorithms),NumIndexes+1);
FR_matrix(1, :) = header;


flagQNR = 0; %% Flag QNR/HQNR, 1: QNR otherwise HQNR
n = 1;

ratio = 4;% Resize Factor    
thvalues = 0;% Threshold values out of dynamic range
%     printEPS = 0;% Print Eps





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== ours_t Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'ours_t';  % 여기에 넣고싶은 모델이름 쓰기

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

% .mat 파일이 있는 디렉토리
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/WV3/', file_fusionnet, '.mat'))
whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

% mat에 저장된 값이 0~1 일때 활성화
% val_bit = 1;

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


% mat에 저장된 값이 0~1 일때 활성화
% val_bit = 1;

values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data);
n = n+1;           
% 셀 배열로 결합
FR_matrix(n,1) = {model};
FR_matrix(n,2:end) = values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%