%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 
%           Peak Signal-to-Noise Ratio (PSNR).
% 
% Interface:
%           psnr_value = PSNR(I_F, I_GT)
%
% Inputs:
%           I_F:        Fused image;
%           I_GT:       Ground-truth image.
%           L:          Dynamic range of the image (e.g., 255 for 8-bit images).
% 
% Output:
%           psnr_value: Peak Signal-to-Noise Ratio value.
% 
% Reference:
%           Made by Sungpyo Kim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function psnr_value = PSNR(I_F, I_GT, L)

    % Check if the input images have the same size
    if size(I_F) ~= size(I_GT)
        error('Input images must have the same dimensions.');
    end

    % Convert images to double
    I_F = double(I_F);
    I_GT = double(I_GT);

    % Calculate Mean Squared Error (MSE)
    MSE = mean((I_F(:) - I_GT(:)).^2);

    % Check if MSE is zero
    if MSE == 0
        psnr_value = Inf;
    else
        % Calculate PSNR
        psnr_value = 10 * log10((L^2) / MSE);
    end

end