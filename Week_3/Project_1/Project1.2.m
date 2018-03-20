% load the image we will experiment with
I = imresize(double(rgb2gray(imread('lena.png'))),[256 256]);

% build the Laplacian pyramid of this image with 6 levels
depth = 6;
L = laplacianpyr(I,depth);

% compute the quantization of the Laplacian pyramid
bins = [16,32,64,128,128,256]; % number of bins for each pyramid level
LC = encoding(L,bins);

% compute the entropy for the given quantization of the pyramid
ent = pyramident(LC);

function ent = pyramident(LC)

    % Input:
    % LC: the quantized version of the images stored in the Laplacian pyramid
    % Output:
    % br: the bitrate for the image given the quantization
    
    % Please follow the instructions to fill in the missing commands.
    
    ent = 0;                % initialization of entropy
    [r, c] = size(LC{1});
    pixI = r*c;             % number of pixels in the original image
    
    for i = 1:numel(LC)
        
        % 1) Compute the number of pixels at this level of the pyramid
        [m,n] = size(LC{i});
        pixN = m*n;
        
        % 2) Compute the entropy at this level of the pyramid 
        % (MATLAB command: entropy)
        entN = entropy(LC{i});
        
        % 3) Each level contributes to the entropy of the pyramid by a
        % factor that is equal to the sample density at this level, times
        % the entropy at this level. The sample density is computed as
        % (number of pixels at this level)/(number of pixels of original image).
        % Add this to the current sum of the entropy 'ent'
        ent = ent+(pixN/pixI)*entN;
        
    end
    
end

function LC = encoding(L, bins)

    % Copy your code from Lab 3
    depth = numel(bins);
    LC = cell(1,depth);
    
    for i = 1:depth
        if i == depth
            edges = linspace(0,256,bins(i));
        else
            edges = linspace(-128,128,bins(i));
        end
       
        centers = (edges(1:end-1) + edges(2:end))/2;
        LC{i} = discretize(L{i},edges,centers);
        
    end
    
end

function L = laplacianpyr(I,depth)

    % Copy your code from Lab 3
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

    % Copy your code from Lab 3
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

    % Copy your code from Lab 3
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

    % Copy your code from Lab 3
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