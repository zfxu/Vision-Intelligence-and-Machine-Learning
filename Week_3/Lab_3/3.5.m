% we load the two images we will blend
A = im2double(imread('orange.png'));
B = im2double(imread('apple.png'));

% mask that defines the blending region
R = zeros(512,512); R(:,257:512)=1;

% depth of the pyramids
depth = 5;

% 1) we build the Laplacian pyramids of the two images
LA = laplacianpyr(A,depth);
LB = laplacianpyr(B,depth);

% 2) we build the Gaussian pyramid of the selected region
GR = gausspyr(R,depth); 

% 3) we combine the two pyramids using the nodes of GR as weights
[LS] = combine(LA, LB, GR);

% 4) we collapse the output pyramid to get the final blended image
Ib = collapse(LS);

% visualization of the result
imshow(Ib);


function I = collapse(L)

    % Input:
    % L: the Laplacian pyramid of an image
    % Output:
    % I: Recovered image from the Laplacian pyramid

    % Please follow the instructions to fill in the missing commands.
    
    depth = numel(L);
    
    % 1) Recover the image that is encoded in the Laplacian pyramid
    for i = depth:-1:1
        if i == depth
            % Initialization of I with the smallest scale of the pyramid
            I = L{i};
        else
            % The updated image I is the sum of the current level of the
            % pyramid, plus the expanded version of the current image I.
            I = expand(I) + L{i};
        end
    end

end

function [LS] = combine(LA, LB, GR)
    
    % Add your code from the previous step
    depth = numel(LA);
    LS = cell(1,depth);    

    for i = 1:depth
        LS{i} = GR{i}.*LA{i} + (1-GR{i}).*LB{i};
    end
    
end

function L = laplacianpyr(I,depth)

    % Add your code from the previous step
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

    % Add your code from the previous step
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

    % Add your code from the previous step
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

    % Add your code from the previous step
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