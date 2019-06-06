%---------------------------------------------------------------------------------
clear
clc
a= imread('test3.bmp');
mysize=size(a);
 if numel(mysize)>2
     I0=rgb2hsv(a);             %ת����HSVģ��
     v=I0(:,:,3);                %��ȡV����
     I=uint8(255 .* v);
 else
      I=a;
 end             
[M,N] = size(I);   
subplot(231)
imshow(a)                 %��ʾԭʼͼ��
title('ԭʼͼ��');
subplot(234)
imhist(I)                 %��ʾԭʼͼ��ֱ��ͼ
title('ԭʼv����ͼ��ֱ��ͼ');

%�������ػҶ�ͳ�ƣ�n;
n = zeros(1,256);         %ͳ�Ƹ��Ҷ���Ŀ����256���Ҷȼ�
for i = 1:M
    for j = 1: N
        n(I(i,j) + 1) = n(I(i,j) + 1) + 1;%��Ӧ�Ҷ�ֵ���ص���������һ
    end
end

%����Ҷȷֲ��ܶȣ�����pdf��
pdf = zeros(1,256);
for i = 1:256
   pdf(i)=n(i) / (M* N);
end

%%�ҳ�ͼ��������ֵ��������,lmax
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

%%����cdf��
cdf=zeros(1,256);
num=0;
for i=1:256
    num=num+pdf(i);    %ÿһ��ǿ��ֵ��pdf��ӳ��
    cdf(i)=num;
end

%%THE_method���⻯
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
imshow(I)            %��ʾ��ǿͼ��
title('THE��ǿͼ��');
subplot(235)
imhist(v)            %��ʾ��ǿͼ��ֱ��ͼ
title('THE��ǿͼ��ֱ��ͼ');