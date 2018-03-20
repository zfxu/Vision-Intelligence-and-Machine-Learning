img = imread('apple.png');
img_gray = im2double(rgb2gray(img));

smooth = gauss_blur(img_gray);

figure()
subplot(121)
imagesc(img_gray)
subplot(122)
imagesc(smooth)

function smooth = gauss_blur(img)
    % Since the Gaussian filter is separable in x and y we can perform Gaussian smoothing by
    % convolving the input image with a 1D Gaussian filter in the x direction then  
    % convolving the output of this operation with the same 1D Gaussian filter in the y direction.

    % Gaussian filter of size 5
    % the Gaussian function is defined f(x) = 1/(sqrt(2*pi)*sigma)*exp(-x.^2/(2*sigma^2))
    x =  -2:2;
    sigma = 1;
    gauss_filter = 1/(sqrt(2*pi)*sigma)*exp(-x.^2/(2*sigma^2));

    % using the conv2 function and the 'same' option
    % convolve the input image with the Gaussian filter in the x
    smooth_x = conv2(img,gauss_filter,'same');
    % convolve smooth_x with the transpose of the Gaussian filter
    smooth = conv2(smooth_x,gauss_filter','same');
end