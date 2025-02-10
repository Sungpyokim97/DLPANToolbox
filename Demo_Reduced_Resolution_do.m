%%%%%%%%%%%%%%%%%%%%%%%%%%%For Reduced-Resolution%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  1) This is a test demo to show all reduced-resolution results of traditional and DL methods
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
% Note: the test datasets of reduced-resolution are still too huge to upload to
% GitHub, thus we provide cloud links to readers to download them to
% successfully run this demo, including:

% i) Download link for reduced-resolution WV3-NewYork example (named "NY1_WV3_RR.mat"):
%     http:********   (put into the folder of "1_TestData/Datasets Testing")

% ii) Download link of DL's results for reduced-resolution WV3-NewYork example:
%     http:********   (put into the folder of "'2_DL_Result/WV3")

% Once you have above datasets, you can run this demo successfully, then
% understand how this demo run!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all;
addpath([pwd,'/Tools']);


%% =======load directors========

% Tools
algorithms = {'EXP','BT-H','BDSD-PC','C-GSA','SR-D',...
    'MTF-GLP-HPM-R','MTF-GLP-FS','TV','PanNet','DRPNN','LAGNet','MSDCnn','DCPNet','S2DBPN','BDPN','DiCNN','PNN','APNN','FusionNet','PanDiff','ours_t','ours_s','Ablation_teacher_l1'};
Qblocks_size = 32;
    %     bicubic = 0;% Interpolator
flag_cut_bounds = 0;% Cut Final Image
dim_cut = 21;% Cut Final Image
thvalues = 0;% Threshold values out of dynamic range


% 측정하려는 데이터셋만 주석제거
% sensor = 'WV3';
% sensor = 'QB';
sensor = 'GF2';

% Initialization of the Matrix of Results
NumIndexes = 7;
header = {'model','PSNR', 'SSIM', 'SAM', 'ERGAS', 'SCC', 'Qn', 'Q2n'};
MatrixResults = zeros(numel(algorithms),NumIndexes);
RR_matrix = cell(numel(algorithms),NumIndexes+1);
RR_matrix(1, :) = header;

% mae_header = {'model', "1" ,'2' ,'3' ,'4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20'};
% MAE_matrix = cell(numel(algorithms),20+1);
% MAE_matrix(1, :) = mae_header;

n = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ours teacher Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'ours_t'; % 여기에 넣고싶은 모델이름 쓰기

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'prior_FTCA_SWTCA_teacher/10_27/test_iter_297500_reduced_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'prior_FTCA_SWTCA_teacher/test_iter_112500_reduced_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'prior_FTCA_SWTCA_teacher/test_iter_147500_reduced_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))


% .mat에 저장된 값이 0~1 일때 활성화
val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

% MAE_matrix(n,1) = {model};
% MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ours student Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'ours_s';

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'prior_FTCA_SWTCA_student/test_iter_280000_reduced_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'prior_FTCA_SWTCA_student/test_iter_107500_reduced_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'prior_FTCA_SWTCA_student/test_iter_300000_reduced_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))


% .mat에 저장된 값이 0~1 일때 활성화
val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

% MAE_matrix(n,1) = {model};
% MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%