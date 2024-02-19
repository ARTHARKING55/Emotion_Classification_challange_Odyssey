function [stat, delta, double_delta] = lfcc_bp(speech, Fs, Window_Length, NFFT, No_Filter, No_coeff, low_freq, high_freq)
    frame_length_inSample = round((Fs/1000) * Window_Length);
    overlap = round(frame_length_inSample / 2);
    % Check if the signal needs padding to meet the minimum length requirement
    if length(speech) < frame_length_inSample + overlap
        num_zeros_to_add = frame_length_inSample + overlap - length(speech);
        speech = [speech; zeros(num_zeros_to_add, 1)];
    end
    framedspeech = buffer(speech, frame_length_inSample, overlap, 'nodelay')';
    w = hamming(frame_length_inSample);
    y_framed = framedspeech .* repmat(w', size(framedspeech, 1), 1);
    
    f = (Fs/2) * linspace(0, 1, NFFT/2+1);
    filbandwidthsf = linspace(low_freq, high_freq, No_Filter+2);
    fr_all = (abs(fft(y_framed', NFFT))).^2;
    
    [~, closestIndex_low_freq] = min(abs(f - low_freq));
    [~, closestIndex_high_freq] = min(abs(f - high_freq));
    fa_all = fr_all(closestIndex_low_freq:closestIndex_high_freq, :)';
    filterbank = zeros(size(fa_all, 2), No_Filter);
    f = f(closestIndex_low_freq:closestIndex_high_freq);
    
    for i = 1:No_Filter
        filterbank(:, i) = trimf(f, [filbandwidthsf(i), filbandwidthsf(i+1), filbandwidthsf(i+2)]);
    end
    
    filbanksum = fa_all * filterbank(1:end, :);
    
    t = log10(filbanksum' + eps);
    t = t(1:No_coeff, :);
    stat = t';
    delta = Deltas(stat', 1)';
    double_delta = Deltas(delta', 1)';
%     triple_delta = Deltas(double_delta', 1)';  % use it for triple derivitive
end

function D = Deltas(x, hlen)
    win = hlen:-1:-hlen;
    xx = [repmat(x(:, 1), 1, hlen), x, repmat(x(:, end), 1, hlen)];
    D = filter(win, 1, xx, [], 2);
    D = D(:, hlen*2+1:end);
    D = D ./ (2 * sum((1:hlen).^2));
end
