%Written by Ryan M Davis

%input:
%   k_space: raw data, with read and phase encode dimensions as last two
%   dimensions
function k_space_square = makeKSpaceMatSquare(k_space)


n_dims = ndims(k_space);

if n_dims == 2
    if size(k_space,1) > size(k_space,2)
        k_space_square = zeros(size(k_space,1));
        zero_buf_size = (size(k_space,1) - size(k_space,2))/2;
        k_space_square(:,zero_buf_size + 1:(end - zero_buf_size)) = k_space;
    elseif size(k_space,1) < size(k_space,2)
        k_space_square = zeros(size(k_space,2));
        zero_buf_size = (size(k_space,2) - size(k_space,1))/2;
        k_space_square(zero_buf_size + 1:(end - zero_buf_size),:) = k_space;
    else
        k_space_square = k_space;
%         warning('makeKSpaceMatSquare: matrix was already square');
    end
elseif n_dims == 3

    if size(k_space,2) > size(k_space,3)
        k_space_square = zeros(size(k_space,1),size(k_space,2),size(k_space,2));
        zero_buf_size = (size(k_space,2) - size(k_space,3))/2;
        k_space_square(:,:,zero_buf_size+1:end - zero_buf_size) = k_space;
    elseif size(k_space,2) < size(k_space,3)
        k_space_square = zeros(size(k_space,1),size(k_space,3),size(k_space,3));
        zero_buf_size = (size(k_space,3) - size(k_space,2))/2;
        k_space_square(:,zero_buf_size + 1:end - zero_buf_size,:) = k_space;
    else
        k_space_square = k_space;
%         warning('makeKSpaceMatSquare: matrix was already square');
    end
elseif n_dims == 4

    if size(k_space,3) > size(k_space,4)
        k_space_square = zeros(size(k_space,1),size(k_space,2),size(k_space,3),size(k_space,3));
        zero_buf_size = (size(k_space,3) - size(k_space,4))/2;
        k_space_square(:,:,:,zero_buf_size+1:end - zero_buf_size) = k_space;
    elseif size(k_space,3) < size(k_space,4)
        k_space_square = zeros(size(k_space,1),size(k_space,2),size(k_space,4),size(k_space,4));
        zero_buf_size = (size(k_space,4) - size(k_space,3))/2;
        k_space_square(:,:,zero_buf_size + 1:end - zero_buf_size,:) = k_space;
    else
        k_space_square = k_space;
%         warning('makeKSpaceMatSquare: matrix was already square');
    end
elseif n_dims == 5

    if size(k_space,4) > size(k_space,5)
        k_space_square = zeros(size(k_space,1),size(k_space,2),size(k_space,3),size(k_space,4),size(k_space,4));
        zero_buf_size = (size(k_space,4) - size(k_space,5))/2;
        k_space_square(:,:,:,:,zero_buf_size+1:end - zero_buf_size) = k_space;
    elseif size(k_space,4) < size(k_space,5)
        k_space_square = zeros(size(k_space,1),size(k_space,2),size(k_space,3),size(k_space,5),size(k_space,5));
        zero_buf_size = (size(k_space,5) - size(k_space,4))/2;
        k_space_square(:,:,:,zero_buf_size + 1:end - zero_buf_size,:) = k_space;
    else
        k_space_square = k_space;
%         warning('makeKSpaceMatSquare: matrix was already square');
    end
end