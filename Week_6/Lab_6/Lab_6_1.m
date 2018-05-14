img = imread('peppers.png');
img_gray = double(rgb2gray(img));

smooth = gauss_blur(img_gray);
[I_x,I_y] = grad2d(smooth);

function [I_x,I_y] = grad2d(img)
  dx_filter = [1/2 0 -1/2];
  I_x = conv2(img,dx_filter,'same');

  dy_filter = dx_filter';
  I_y = conv2(img,dy_filter,'same');
end

function smooth = gauss_blur(img)
  x = -2:2;
  sigma = 1;
  gauss_filter = 1/(sqrt(2*pi)*sigma)*exp(-x.^2/(2*sigma));
  smooth_x = conv2(img,gauss_filter,'same');
  smooth = conv2(smooth_x,gauss_filter','same');
end
