% load the image we will experiment with
I = imresize(double(rgb2gray(imread('lena.png'))),[256 256]);

% build the Laplacian pyramid of this image with 6 levels
depth = 6;
L = laplacianpyr(I,depth);

% compute the quantization of the Laplacian pyramid
bins = [16,32,64,128,128,256]; % number of bins for each pyramid level
LC = encoding(L,bins);

function LC = encoding(L, bins)

    % Input:
    % L: the Laplacian pyramid of the input image
    % bins: The number of bins used for discretization of each pyramid level
    % Output:
    % LC: the quantized version of the image stored in the Laplacian pyramid
    
    % Please follow the instructions to fill in the missing commands.

    depth = numel(bins);
    LC = cell(1,depth);
    
    for i = 1:depth

        % 1) Compute the edges of the bins we will use for discretization
        % (MATLAB command: linspace)
        % For level i, the linspace command will give you a row vector 
        % with bins(i) linearly spaced points between [X1,X2].
        % Remember that the range [X1,X2] depends on the level of the 
        % pyramid. The difference images (levels 1 to depth-1) are in 
        % the range of [-128,128], while the blurred image is in the 
        % range of [0,256]
        if i == depth % blurred image in range [0, 256]
            edges = linspace(0,256,bins(i));
        else % difference image in range [-128,128]
            edges = linspace(-128,128,bins(i));
        end
        
        % 2) Compute the centers that correspond to the above edges
        % The 1st center -> (1st edge + 2nd edge)/2
        % The 2nd center -> (2nd edge + 3rd edge)/2 and so on
        centers = (edges(1:end-1) + edges(2:end))/2;
        
        % 3) Discretize the values of the image at this level of the
        % pyramid according to edges (MATLAB command: discretize)
        % Hint: use 'centers' as the third argument of the discretize
        % command to get the value of each pixel instead of the bin index.
        LC{i} = discretize(L{i},edges,centers);
        
    end
    
end

function L = laplacianpyr(I,depth)

    % Add your code from Lab 3
    L = cell(1,depth);  
    GA = gausspyr(I,depth);

    for i = 1:depth
        if i < depth
            L{i} = GA{i} - expand(GA{i+1});    % same level of Gaussian pyramid minus the expanded version of next level
        else
            L{i} = GA{i};    % same level of Gaussian pyramid
        end
    end
    
end

function G = gausspyr(I,depth)

    % Add your code from Lab 3
    G = cell(1,depth);
    
    for i = 1:depth
        if i == 1
            G{i} = I;    % original image
        else
            G{i} = reduce(G{i-1});% reduced version of the previous level
        end
    end

end

function g = reduce(I)

    % Add your code from Lab 3
    h = fspecial('gaussian', 5, 1);
    t = imfilter(I,h);
    
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

function g = expand(I)

    % Add your code from Lab 3
    [r,c,z] = size(I);
    t = zeros(2*r,2*c,z);
    for m = 1:r
        for n = 1:c
            for l = 1:z
                t(2*m-1,2*n-1,l) = I(m,n,l);
            end
        end
    end
        
    h = fspecial('gaussian', 5, 1);    
    g = 4*imfilter(t,h);

end