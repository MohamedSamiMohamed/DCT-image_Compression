m=4;
block_size=8;
%read the image and construct 3 channels 
image=imread('image1.bmp');
image_colored_red=image;
image_colored_green=image;
image_colored_blue=image;
image_colored_red(:,:,2)=0;
image_colored_red(:,:,3)=0;
image_colored_green(:,:,1)=0;
image_colored_green(:,:,3)=0;
image_colored_blue(:,:,1)=0;
image_colored_blue(:,:,2)=0;
image_red=image(:,:,1);
image_green=image(:,:,2);
image_blue=image(:,:,3);
imwrite(image_colored_red,'red_colored_image.bmp');
imwrite(image_colored_green,'green_colored_image.bmp');
imwrite(image_colored_blue,'blue_colored_image.bmp');
imwrite(image_red,'red_channel_image.bmp');
imwrite(image_green,'green_channel_image.bmp');
imwrite(image_blue,'blue_channel_image.bmp');
%compress the image
for i=0:(size(image,2)/block_size)-1
for j=0:(size(image,1)/block_size)-1
block_red=image_red(((j*block_size)+1):(j+1)*block_size,((i*block_size)+1):(i+1)*block_size);
coeffecients_red((j*m)+1:(j+1)*m,(i*m)+1:(i+1)*m)=compress(block_red,m);
block_green=image_green(((j*block_size)+1):(j+1)*block_size,((i*block_size)+1):(i+1)*block_size);
coeffecients_green((j*m)+1:(j+1)*m,(i*m)+1:(i+1)*m)=compress(block_green,m);
block_blue=image_blue(((j*block_size)+1):(j+1)*block_size,((i*block_size)+1):(i+1)*block_size);
coeffecients_blue((j*m)+1:(j+1)*m,(i*m)+1:(i+1)*m)=compress(block_blue,m);
end;
end;
%calculating the compression ratio
compression_ratio=size(image_blue,1)*size(image_blue,2)/(size(coeffecients_blue,1)*size(coeffecients_blue,2))
%decompress the image by idct2 to the coeffecients calculated in the
%previos step
for i=0:(size(coeffecients_blue,2)/m)-1
    for j=0:(size(coeffecients_blue,1)/m)-1
        block_red=coeffecients_red(((j*m)+1):(j+1)*m,((i*m)+1):(i+1)*m);
        recovered_red(((j*block_size)+1):(j+1)*block_size,((i*block_size)+1):(i+1)*block_size)=idct2(block_red,[block_size,block_size]);
        block_green=coeffecients_green(((j*m)+1):(j+1)*m,((i*m)+1):(i+1)*m);
        recovered_green(((j*block_size)+1):(j+1)*block_size,((i*block_size)+1):(i+1)*block_size)=idct2(block_green,[block_size,block_size]);
        block_blue=coeffecients_blue(((j*m)+1):(j+1)*m,((i*m)+1):(i+1)*m);
        recovered_blue(((j*block_size)+1):(j+1)*block_size,((i*block_size)+1):(i+1)*block_size)=idct2(block_blue,[block_size,block_size]);
    end;
end;
recovered_image(:,:,1)=recovered_red;
recovered_image(:,:,2)=recovered_green;
recovered_image(:,:,3)=recovered_blue;
recovered_image=uint8(recovered_image);
imshow(recovered_image);
imwrite(recovered_image,'decompressed_image_m4.bmp');
psnr_value=psnr(recovered_image,image)
psnr_value=psnr(recovered_image,image,255)
clear;

function [ coeffs ] = compress( block,m )
coeffs=dct2(block);
coeffs=coeffs(1:m,1:m);
end
