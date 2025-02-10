function [MSE_list, values] = evaluate_image_quality(ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues, val_bit, data)
    % 배치 개수 추출
    num_batches = size(data.sr, 1);
    addpath([pwd,'/Tools']);
    % 각 지표의 결과를 저장할 배열 초기화
    MSE_list = zeros(1, num_batches);
    PSNR_avg_values = zeros(num_batches, 1);
    SSIM_avg_values = zeros(num_batches, 1);
    Q_avg_values = zeros(num_batches, 1);
    SAM_values = zeros(num_batches, 1);
    ERGAS_values = zeros(num_batches, 1);
    SCC_values = zeros(num_batches, 1);
    Q_values = zeros(num_batches, 1);
    
    % 각 배치에 대해 연산 수행
    for batch_idx = 1:num_batches
        % 각 배치의 데이터를 가져와 처리
        gt = squeeze(data.gt(batch_idx, :, :, :));
        sr = squeeze(data.sr(batch_idx, :, :, :));
        
        % 차원 순서 변경 (C H W -> H W C)
        gt_first_batch_hwc = permute(gt, [2, 3, 1]);  % (H, W, C)
        sr_first_batch_hwc = permute(sr, [2, 3, 1]);  % (H, W, C)
        
        % val_bit 스케일링 적용
        % val_bit % 스케일링 값을 정의합니다. 필요에 따라 변경하세요.
        I_fusionnet = val_bit * double(sr_first_batch_hwc);
        I_GT = double(gt_first_batch_hwc);
            % 평가 함수 호출
        [PSNR_avg, SSIM_avg, Q_avg, SAM, ERGAS, SCC, Q] = indexes_evaluation(I_fusionnet, I_GT, ratio, L, Qblocks_size, flag_cut_bounds, dim_cut, thvalues);
        
        % 결과 저장
        MSE_list(1,batch_idx) = L*10^(-(PSNR_avg)/20);
        PSNR_avg_values(batch_idx) = PSNR_avg;
        SSIM_avg_values(batch_idx) = SSIM_avg;
        Q_avg_values(batch_idx) = Q_avg;
        SAM_values(batch_idx) = SAM;
        ERGAS_values(batch_idx) = ERGAS;
        SCC_values(batch_idx) = SCC;
        Q_values(batch_idx) = Q;
    end
    
    % 각 지표의 평균 및 표준편차 계산
    mean_PSNR_avg = mean(PSNR_avg_values);
    std_PSNR_avg = std(PSNR_avg_values);
    
    mean_SSIM_avg = mean(SSIM_avg_values);
    std_SSIM_avg = std(SSIM_avg_values);
    
    mean_Q_avg = mean(Q_avg_values);
    std_Q_avg = std(Q_avg_values);
    
    mean_SAM = mean(SAM_values);
    std_SAM = std(SAM_values);
    
    mean_ERGAS = mean(ERGAS_values);
    std_ERGAS = std(ERGAS_values);
    
    mean_SCC = mean(SCC_values);
    std_SCC = std(SCC_values);
    
    mean_Q = mean(Q_values);
    std_Q = std(Q_values);
    
    % 결과를 문자열로 결합하여 반환
    values = {sprintf('%.3f $\\pm$ %.3f', mean_PSNR_avg, std_PSNR_avg), ...
              sprintf('%.3f $\\pm$ %.3f', mean_SSIM_avg, std_SSIM_avg), ...
              sprintf('%.3f $\\pm$ %.3f', mean_SAM, std_SAM), ...
              sprintf('%.3f $\\pm$ %.3f', mean_ERGAS, std_ERGAS), ...
              sprintf('%.3f $\\pm$ %.3f', mean_SCC, std_SCC), ...
              sprintf('%.3f $\\pm$ %.3f', mean_Q_avg, std_Q_avg), ...
              sprintf('%.3f $\\pm$ %.3f', mean_Q, std_Q)};
end
