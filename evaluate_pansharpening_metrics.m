function values = evaluate_pansharpening_metrics(L, thvalues, sensor, ratio, flagQNR, val_bit, data)
    % 초기화: 각 배치마다 D_lambda, D_S, QNRI 값을 저장할 배열
    num_batches = size(data.sr, 1);  % 배치 개수
    addpath([pwd,'/Tools']);
    D_lambda_values = zeros(num_batches, 1);
    D_S_values = zeros(num_batches, 1);
    QNRI_values = zeros(num_batches, 1);

    for batch_idx = 1:num_batches
        % 각 배치의 데이터를 가져와 처리
        sr = squeeze(data.sr(batch_idx, :, :, :));
        ms_lr = squeeze(data.ms(batch_idx, :, :, :));
        ms = squeeze(data.lms(batch_idx, :, :, :));
        pan = squeeze(data.pan(batch_idx, :, :, :));
        
        % 차원 순서 변경 (C H W -> H W C)
        sr_first_batch_hwc = permute(sr, [2, 3, 1]);  % (H, W, C)
        ms_lr_first_batch_hwc = permute(ms_lr, [2, 3, 1]);  % (H, W, C)
        ms_first_batch_hwc = permute(ms, [2, 3, 1]);  % (H, W, C)
        pan_first_batch_hwc = pan;  % (H, W, 1)

        % val_bit 스케일링 적용
        I_fusionnet = val_bit*double(sr_first_batch_hwc);
        I_MS_LR = double(ms_lr_first_batch_hwc);
        I_PAN = double(pan_first_batch_hwc);
        I_MS = double(ms_first_batch_hwc);

        % Quality indexes computation (각 배치마다)
        [D_lambda, D_S, QNRI] = indexes_evaluation_FS(I_fusionnet, I_MS_LR, I_PAN, L, thvalues, I_MS, sensor, ratio, flagQNR);

        % 결과 저장
        D_lambda_values(batch_idx) = D_lambda;
        D_S_values(batch_idx) = D_S;
        QNRI_values(batch_idx) = QNRI;

        end

    % 각 값에 대한 평균 및 표준편차 계산
    mean_D_lambda = mean(D_lambda_values);
    std_D_lambda = std(D_lambda_values);

    mean_D_S = mean(D_S_values);
    std_D_S = std(D_S_values);

    mean_QNRI = mean(QNRI_values);
    std_QNRI = std(QNRI_values);

    % 결과를 문자열로 결합하여 반환
    values = {sprintf('%.3f $\pm$ %.3f', mean_D_lambda, std_D_lambda), ...
              sprintf('%.3f $\pm$ %.3f', mean_D_S, std_D_S), ...
              sprintf('%.3f $\pm$ %.3f', mean_QNRI, std_QNRI)};
end
