function [res, predicted_y_transpose] = LP_residual_extraction(P,y, fs)
    P = P;
    ycorr = xcorr(y, P); % gives (2P+1) long autocorrelation, where (P+1)th position of ycorr is rx(0)
    Af = flip(ycorr(1:(P+1))); % since (P+1)th position is rx(0), it is the highest value. We flip it so that the first value is rx(0), so that the toeplitz matrix comes out correct
    A = toeplitz(Af(1:P));
    r = Af(2:P+1);
    L = -inv(A) * r; % multiplying inverse of A with r to get coeff
    L = L';
    LPCoeffs(1, 1:length([1, L])) = [1, L];
    predicted_y = filter([0 -LPCoeffs(2:end)], 1, y);  % Estimated signal
    predicted_y_transpose = predicted_y.';
    res = y - predicted_y; % Prediction error
end
