%---------------------------------------------------------------------------------------------------
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
pdfmax=max(pdf);
pdfmin=min(pdf);
%生成pdfw表
pdfw = zeros(1,256);
for i=1:256
    E(i)=(pdf(i)-pdfmin)/(pdfmax-pdfmin);  %%
    pdfw(i)=pdfmax*power(E(i),1);
end
%生成cdfw表
cdfw=zeros(1,256);
num1=0;
num2=0;
for i=1:256
    num1=num1+pdfw(i);    
%     cdfw(i)=num1;
end
for i=1:256
    num2=num2+pdfw(i);    
    cdfw(i)=num2/num1;
end

%%AGCWD均衡化
%统计亮度值
 for i = 1:M
     for j = 1: N
       A(i,j)=double(I(i,j))/double(lmax);
     end
 end

for i = 1:M
     for j = 1: N 
        I(i,j)=lmax*power(A(i,j),1-cdfw(I(i,j)+1));    
     end
end

h=I0(:,:,1);
s=I0(:,:,2);
v=double(I)/255;
I=hsv2rgb(h,s,v);

subplot(233)
imshow(I)            %显示AGCWD增强图像
title('AGCWD增强图像');
subplot(236)
imhist(v)            %显示AGCWD增强图像直方图
title('AGCWD增强直方图');