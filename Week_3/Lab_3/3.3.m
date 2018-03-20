% loading the image
A = im2double(imread('orange.png'));
% depth of the pyramids
depth = 5;

% we build the Gaussian pyramid
LA = laplacianpyr(A,depth);

function L = laplacianpyr(I,depth)

    % Input:
    % I: the input image
    % depth: number of levels of the Laplacian pyramid
    % Output:
    % L: a cell containing all the levels of the Laplacian pyramid
    
    % Please follow the instructions to fill in the missing commands.
    
    L = cell(1,depth);
    
    % 1) Create a Gaussian pyramid
    % Use the function you already created.
    
    GA = gausspyr(I,depth);

    % 2) Create a pyramid, where each level is the corresponding level of
    % the Gaussian pyramid minus the expanded version of the next level of
    % the Gaussian pyramid.
    % Remember that the last level of the Laplacian pyramid is the same as
    % the last level of the Gaussian pyramid.
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