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


% sensor = 'WV3';
% sensor = 'QB';
sensor = 'GF2';

% Initialization of the Matrix of Results
NumIndexes = 7;
header = {'model','PSNR', 'SSIM', 'SAM', 'ERGAS', 'SCC', 'Qn', 'Q2n'};
MatrixResults = zeros(numel(algorithms),NumIndexes);
RR_matrix = cell(numel(algorithms),NumIndexes+1);
RR_matrix(1, :) = header;

mae_header = {'model', "1" ,'2' ,'3' ,'4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20'};
MAE_matrix = cell(numel(algorithms),20+1);
MAE_matrix(1, :) = mae_header;

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== CrossDiff Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'CrossDiff';

%     printEPS = 0;% Print Eps

file_fusionnet = strcat(model,'/','test_save_gf2_multiExm1');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, 1.0, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== SSDiff Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'SSDiff';

%     printEPS = 0;% Print Eps

file_fusionnet = strcat(model,'/','samp_reduced_20_256_01-29-08-11.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, 1.0, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== PanNet Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'PanNet';

%     printEPS = 0;% Print Eps

file_fusionnet = strcat(model,'/','test_',model,'_',small,'_reduced.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== MSDCnn ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'MSDCnn';

%     printEPS = 0;% Print Eps
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

file_fusionnet = strcat(model,'/','test_',model,'_',small,'_reduced.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== FusionNet Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'FusionNet';

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

file_fusionnet = strcat(model,'/','test_',model,'_',small,'_reduced.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== LAGNet Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'LAGNet';

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

file_fusionnet = strcat(model,'/','test_',model,'_',small,'_reduced.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== S2DBPN Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'S2DBPN';

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

file_fusionnet = strcat(model,'/','test_',model,'_',small,'_reduced.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== DCPNet Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'DCPNet';

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

file_fusionnet = strcat(model,'/','test_',model,'_',small,'_reduced.mat');
data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== PanDiff Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'PanDiff';

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'PanDiff/test_iter_32000_reduced_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'PanDiff/test_iter_16000_reduced_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'PanDiff/test_iter_30000_reduced_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

% diffusion based val_bit은 1로 셋팅해야함
val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== TMDiff Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'TMDiff';

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'TMDiff/test_save_gf2_multiExm1.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'TMDiff/test_save_qb_multiExm1.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'TMDiff/test_save_wv3_multiExm1.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

% diffusion based val_bit은 1로 셋팅해야함
val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== CANConv Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'CANConv';

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'CANConv/test_save_gf2_multiExm1.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'CANConv/test_save_qb_multiExm1.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'CANConv/test_save_wv3_multiExm1.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

% diffusion based val_bit은 1로 셋팅해야함
val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ours teacher Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'ours_t';

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

val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
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

val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ours student_L1 Method ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'ours_s_L1';

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'prior_FTCA_SWTCA_student/test_iter_300000_reduced_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'Ab_student_L1/test_iter_112500_reduced_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'Ab_student_L1/test_iter_300000_reduced_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ablation_teacher_l1 Method ======
model = 'Ablation_teacher_l1';

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'prior_FTCA_SWTCA_student/test_iter_300000_reduced_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'prior_FTCA_SWTCA_student/test_iter_135000_reduced_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'prior_FTCA_SWTCA_teacher/L1/test_iter_65000_reduced_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ablation_student_X_X_X ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'Ablation_student_X_X_X';

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'Ab_student_X_X_X/test_iter_292500_reduced_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'Ab_student_FFA_X_X/test_iter_80000_reduced_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'prior_FTCA_SWTCA_teacher/L1/test_iter_65000_reduced_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ablation_FFA_X_X ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'Ablation_FFA_X_X';

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'Ab_student_FFA_X_X/test_iter_80000_reduced_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'prior_FTCA_SWTCA_student/test_iter_135000_reduced_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'prior_FTCA_SWTCA_teacher/L1/test_iter_65000_reduced_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% ====== Ablation_X_FTCA_SWTCA ======
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model = 'Ablation_X_FTCA_SWTCA';

% ratio = 4;% Resize Factor
% if strcmp(sensor, 'GF2')
%     L = 10; % Radiometric Resolution
%     val_bit = 1023;
%     small = 'gf2';
%     file_fusionnet = 'Ab_student_X_FTCA_SWTCA/test_iter_300000_reduced_gf2.mat';
% elseif strcmp(sensor, 'QB')
%     L = 11;
%     val_bit = 2047;
%     small = 'qb';
%     file_fusionnet = 'prior_FTCA_SWTCA_student/test_iter_135000_reduced_qb.mat';
% else
%     L = 11; % Radiometric Resolution
%     val_bit = 2047;
%     small = 'wv3';
%     file_fusionnet = 'prior_FTCA_SWTCA_teacher/L1/test_iter_65000_reduced_wv3.mat';
% end

% data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% % 파일에 포함된 변수 확인

% whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

% val_bit = 1;
% [mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
% n = n+1;
% % 셀 배열로 결합
% RR_matrix(n,1) = {model};
% RR_matrix(n,2:end) = values;

% MAE_matrix(n,1) = {model};
% MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ablation_student_FFA_X_SWTCA ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'Ablation_student_FFA_X_SWTCA';

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'Ab_student_FFA_X_SWTCA/test_iter_395000_reduced_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'Ab_student_FFA_X_X/test_iter_80000_reduced_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'prior_FTCA_SWTCA_teacher/L1/test_iter_65000_reduced_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ablation_student_FFA_FTCA_X ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'Ablation_student_FFA_FTCA_X';

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'Ab_student_FFA_FTCA_X/test_iter_372500_reduced_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'Ab_student_FFA_X_X/test_iter_80000_reduced_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'prior_FTCA_SWTCA_teacher/L1/test_iter_65000_reduced_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====== Ablation_teacher_DWTCond ======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model = 'Ablation_teacher_DWTCond';

ratio = 4;% Resize Factor
if strcmp(sensor, 'GF2')
    L = 10; % Radiometric Resolution
    val_bit = 1023;
    small = 'gf2';
    file_fusionnet = 'Ab_teacher_DWTCond/test_iter_242500_reduced_gf2.mat';
elseif strcmp(sensor, 'QB')
    L = 11;
    val_bit = 2047;
    small = 'qb';
    file_fusionnet = 'Ab_teacher_DWTCond/test_iter_80000_reduced_qb.mat';
else
    L = 11; % Radiometric Resolution
    val_bit = 2047;
    small = 'wv3';
    file_fusionnet = 'Ab_teacher_DWTCond/test_iter_65000_reduced_wv3.mat';
end

data = load(strcat('2_DL_Result/',sensor,'/', file_fusionnet));

% 파일에 포함된 변수 확인

whos('-file', strcat('2_DL_Result/',sensor,'/', file_fusionnet))

val_bit = 1;
[mae_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data);
n = n+1;
% 셀 배열로 결합
RR_matrix(n,1) = {model};
RR_matrix(n,2:end) = values;

MAE_matrix(n,1) = {model};
MAE_matrix(n,2:end) = num2cell(mae_list);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%