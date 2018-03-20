img = imread('peppers.png');
img_gray = im2double(rgb2gray(img));

img_gray_smooth = gauss_blur(img_gray);
[I_x,I_y] = grad2d(img_gray_smooth);

I_xx = gauss_blur(I_x.^2);
I_yy = gauss_blur(I_y.^2);
I_xy = gauss_blur(I_x.*I_y);

k = 0.06;
% Use the corner score equation from the lecture.
[r c]=size(I_xx);
R = zeros(r, c);
R = ((I_xx.*I_yy)-(I_xy.^2))-k.*(I_xx+I_yy).^2;

function [I_x,I_y] = grad2d(img)
  dx_filter = [1/2 0 -1/2];
  I_x = conv2(img,dx_filter,'same');

  dy_filter = dx_filter';
  I_y = conv2(img,dy_filter,'same');
end

function smooth = gauss_blur(img)
  x =  -2:2;
  sigma = 1;
  gauss_filter = 1/(sqrt(2*pi)*sigma)*exp(-x.^2/(2*sigma));

  smooth_x = conv2(img,gauss_filter,'same');
  smooth = conv2(smooth_x,gauss_filter','same');
end
