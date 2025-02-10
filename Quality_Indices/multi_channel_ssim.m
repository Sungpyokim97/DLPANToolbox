function [mssim, ssim_maps] = multi_channel_ssim(img1, img2, K, window, L)
    % Get the number of channels in the images
    [~, ~, num_channels] = size(img1);
    
    % Initialize variables to store SSIM values and SSIM maps
    ssim_values = zeros(1, num_channels);
    ssim_maps = cell(1, num_channels);
    
    % Loop over each channel to calculate SSIM
    for c = 1:num_channels
        [ssim_values(c), ssim_maps{c}] = ssim(img1(:,:,c), img2(:,:,c), K, window, L);
    end
    
    % Calculate the mean SSIM across all channels
    mssim = mean(ssim_values);
end
