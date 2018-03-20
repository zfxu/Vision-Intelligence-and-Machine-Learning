A = im2double(imread('orange.png'));
B = im2double(imread('apple.png'));

R = zeros(512,512); R(:,257:512)=1;

gA = expand(A);
gB = reduce(B);

gR = reduce(R);

function g = expand(I)

    % Input:
    % I: the input image
    % Output:
    % g: the image after the expand operation

    % Please follow the instructions to fill in the missing commands.
    
    % 1) Create the expanded image. 
    % The new image should be twice the size of the original image.
    % So, for an n x n image you will create an emty 2n x 2n image
    % Fill every second row and column with the rows and columns of the original image
    % i.e., 1st row of I -> 1st row of expanded image
    %       2nd row of I -> 3rd row of expanded image
    %       3rd row of I -> 5th row of expanded image, and so on
    
    [r,c,z] = size(I);
    t = zeros(2*r,2*c,z);
    for m = 1:r
        for n = 1:c
            for l = 1:z
                t(2*m-1,2*n-1,l) = I(m,n,l);
            end
        end
    end
    
    % 2) Create a Gaussian kernel of size 5x5 and 
    % standard deviation equal to 1 (MATLAB command fspecial)
    
    h = fspecial('gaussian', 5, 1);
    
    % 3) Convolve the input image with the filter kernel (MATLAB command imfilter)
    % Tip: Use the default settings of imfilter
    % Remember to multiply the output of the filtering with a factor of 4
    
    g = 4*imfilter(t,h);

end

function g = reduce(I)

    % Input:
    % I: the input image
    % Output:
    % g: the image after Gaussian blurring and subsampling

    % Please follow the instructions to fill in the missing commands.
    
    % 1) Create a Gaussian kernel of size 5x5 and 
    % standard deviation equal to 1 (MATLAB command fspecial)
    
    h = fspecial('gaussian', 5, 1);
    
    % 2) Convolve the input image with the filter kernel (MATLAB command imfilter)
    % Tip: Use the default settings of imfilter
            
    t = imfilter(I,h);

    % 3) Subsample the image by a factor of 2
    % i.e., keep only 1st, 3rd, 5th, .. rows and columns
    
    [r,c,z] = size(t);
    g = zeros(r/2,c/2,z);
    for m = 1:r/2
        for n = 1:c/2
            for l = 1:z
                g(m,n,l) = t(2*m-1,2*n-1,l);
            end
        end
    end

end