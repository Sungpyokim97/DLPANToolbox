function score = JQM(I_F, I_MS_LR, I_MS, I_PAN, L, v1, v2)
    if nargin < 4
        v1 = 0.5;
    end
    if nargin < 5
        v2 = 0.5;
    end

    I_F_mean = mean(I_F, 3);
    I_MS_LR_mean = mean(I_MS_LR, 3);
    I_MS_mean = mean(I_MS, 3);
    I_PAN_mean = mean(I_PAN, 3);

    score = v1 * qlr(I_F_mean, I_MS_mean, L) + v2 * qhr(I_F_mean, I_PAN_mean, L);
end

function score = cmsc(x, y, bit_depth)
    if nargin < 3
        bit_depth = 12;  % Default 12-bit images
    end
    
    % Compute mean and standard deviation across all channels
    mean_x = mean(x(:));
    mean_y = mean(y(:));
    std_x = std(x(:));
    std_y = std(y(:));
    
    % Compute cosine similarity
    x_flat = x(:);
    y_flat = y(:);
    correlation = dot(x_flat, y_flat) / (norm(x_flat) * norm(y_flat));
    
    % CMSC formula
    R = 2^bit_depth - 1;
    d_R = ((std_x - std_y) ^ 2) / (2 * R^2);
    d_mu = ((mean_x - mean_y) ^ 2) / (2 * R^2);
    
    score = (1 - d_R) * (1 - d_mu) * correlation;
end

function score = qlr(pan_sharpened, ms_low_upsampled, L)
    % Bilinear interpolation for upsampling by a factor of 4
    % ms_low_res_upsampled = imresize(ms_low_res, 4, 'bilinear');
    score = cmsc(pan_sharpened, ms_low_upsampled, L);
end

function score = qhr(pan_sharpened, pan, L)
    score = cmsc(pan_sharpened, pan, L);
end

