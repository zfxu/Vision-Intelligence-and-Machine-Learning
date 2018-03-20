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

% Use the collapse command of the Lab 3 to recover the image
Ic = collapse(LC);

% compute the snr for the recovered image
snr_c = compute_snr(I,Ic);

% use the code from Lab 2 to compute an approximation image with 
% the same level of compression approximately
[rows,cols] = size(I);
n_0 = rows*cols;
M = n_0/8;
Id = decompress(compress(I,sqrt(M)));
snr_d = compute_snr(I,Id);

% plot the resulting images
subplot(1,3,1); 
imshow(I,[]); title('Original image');
subplot(1,3,2); imshow(Ic,[]); 
title('Laplacian Encoding'); xlabel(['SNR = ' num2str(snr_c)]);
subplot(1,3,3); imshow(Id,[]); 
title('Fourier Approximation'); xlabel(['SNR = ' num2str(snr_d)]);

function ent = pyramident(LC)

    % Copy your code from the previous steps
    ent = 0;                % initialization of entropy
    [r, c] = size(LC{1});
    pixI = r*c;             % number of pixels in the original image
    
    for i = 1:numel(LC)
        [m,n] = size(LC{i});
        pixN = m*n;        
        entN = entropy(LC{i});        
        ent = ent+(pixN/pixI)*entN;
        
    end
    
end

function LC = encoding(L, bins)

    % Copy your code from the previous steps
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

function I = collapse(L)

    % Copy your code from Lab 3
    depth = numel(L);
    
    for i = depth:-1:1
        if i == depth
            I = L{i};
        else
            I = expand(I) + L{i};
        end
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

function [Fcomp] = compress(I,M_root)

    % Copy your code from Lab 2  
    F = fft2(I);
    F = fftshift(F);
    [rows,cols] = size(I);
    idx_rows = abs((1:rows) - ceil(rows/2)) < M_root/2 ; 
    idx_cols = abs((1:cols)- ceil(cols/2)) < M_root/2 ; 
    M = (double(idx_rows')) * (double(idx_cols));
    Fcomp = times(F,M);
    
end

function [Id] = decompress(Fcomp)

    % Copy your code from Lab 2
    F = ifftshift(Fcomp);
    F = ifft2(F);
    Id = real(F);

end

function snr = compute_snr(I, Id)

    % Copy your code from Lab 2
    noise = I-Id;
    noisenorm = norm(noise,'fro');
    Inorm = norm(I,'fro');
    snr = -20*log10((noisenorm)/Inorm);

end