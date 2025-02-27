%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 
%           Full resolution quality indexes. 
% 
% Interface:
%           [D_lambda,D_S,QNR_index,SAM_index,sCC] = indexes_evaluation_FS(I_F,I_MS_LR,I_PAN,L,th_values,I_MS,sensor,tag,ratio)
%
% Inputs:
%           I_F:                Fused image;
%           I_MS_LR:            MS image;
%           I_PAN:              Panchromatic image;
%           L:                  Image radiometric resolution; 
%           th_values:          Flag. If th_values == 1, apply an hard threshold to the dynamic range;
%           I_MS:               MS image upsampled to the PAN size;
%           sensor:             String for type of sensor (e.g. 'WV2','IKONOS');
%           ratio:              Scale ratio between MS and PAN. Pre-condition: Integer value;
%           flagQNR:            if flagQNR == 1, the software uses the QNR otherwise the HQNR is used.
%
% Outputs:
%           D_lambda:           D_lambda index;
%           D_S:                D_S index;
%           QNR_index:          QNR index;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [D_lambda,D_S,QNR_index] = indexes_evaluation_FS(I_F,I_MS_LR,I_PAN,L,th_values,I_MS,sensor,ratio,flagQNR)
function [D_lambda,D_S,QNR_index, SCC_F,SAM_F, ERGAS_F, JQM_index] = indexes_evaluation_FS(I_F,I_MS_LR,I_PAN,L,th_values,I_MS,sensor,ratio,flagQNR)

if th_values
    I_F(I_F > 2^L) = 2^L;
    I_F(I_F < 0) = 0;
end

cd Quality_Indices

if flagQNR == 1
    [QNR_index,D_lambda,D_S]= QNR(I_F,I_MS,I_MS_LR,I_PAN,ratio);
else
    [QNR_index,D_lambda,D_S] = HQNR(I_F,I_MS_LR,I_MS,I_PAN,32,sensor,ratio);
end
v1 = 0.5;
JQM_index = JQM(I_F,I_MS_LR,I_MS,I_PAN, L, v1, (1-v1));

I_PAN_expand = repmat(I_PAN, [1, 1, size(I_F, 3)]);
SCC_F = SCC(I_F,I_PAN_expand);

% H/4, W/4, C 사이즈로 다운샘플링
I_F_reduced = zeros(size(I_F, 1) / 4, size(I_F, 2) / 4, size(I_F, 3));

for i = 1:size(I_F, 3)
    I_F_reduced(:, :, i) = imresize(I_F(:, :, i), 1/4, 'bilinear');
end
SAM_F = SAM(I_MS_LR,I_F_reduced);

ERGAS_F = ERGAS(I_MS_LR, I_F_reduced, 4);
cd ..

end