%---------------------------------------------------------------------------------
clear
clc
a= imread('test3.bmp');
mysize=size(a);
 if numel(mysize)>2
     I0=rgb2hsv(a);             %转换到HSV模型
     v=I0(:,:,3);                %提取V分量
     I=uint8(255 .* v);
 else
      I=a;
 end             
[M,N] = size(I);   
subplot(231)
imshow(a)                 %显示原始图像
title('原始图像');
subplot(234)
imhist(I)                 %显示原始图像直方图
title('原始v分量图像直方图');

%进行像素灰度统计，n;
n = zeros(1,256);         %统计各灰度数目，共256个灰度级
for i = 1:M
    for j = 1: N
        n(I(i,j) + 1) = n(I(i,j) + 1) + 1;%对应灰度值像素点数量增加一
    end
end

%计算灰度分布密度，生成pdf表
pdf = zeros(1,256);
for i = 1:256
   pdf(i)=n(i) / (M* N);
end

%%找出图像中亮度值最大的像素,lmax
lmax=0;
lmin=256;
for i=1:1:M
    for j=1:1:N
        if I(i,j)<lmin
            lmin=I(i,j);
        end
        if I(i,j)>lmax
            lmax=I(i,j);
        end
    end
end
lmax;

%%生成cdf表
cdf=zeros(1,256);
num=0;
for i=1:256
    num=num+pdf(i);    %每一个强度值和pdf表映射
    cdf(i)=num;
end

%%THE_method均衡化
for i = 1:M
    for j = 1: N
        I1(i,j) = cdf(I(i,j)+1)*lmax;
    end
end

h=I0(:,:,1);
s=I0(:,:,2);
v=double(I1)/255;
I=hsv2rgb(h,s,v);

subplot(232)
imshow(I)            %显示增强图像
title('THE增强图像');
subplot(235)
imhist(v)            %显示增强图像直方图
title('THE增强图像直方图');