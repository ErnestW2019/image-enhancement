%---------------------------------------------------------------------------------------------------
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
pdfmax=max(pdf);
pdfmin=min(pdf);
%����pdfw��
pdfw = zeros(1,256);
for i=1:256
    E(i)=(pdf(i)-pdfmin)/(pdfmax-pdfmin);  %%
    pdfw(i)=pdfmax*power(E(i),1);
end
%����cdfw��
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

%%AGCWD���⻯
%ͳ������ֵ
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
imshow(I)            %��ʾAGCWD��ǿͼ��
title('AGCWD��ǿͼ��');
subplot(236)
imhist(v)            %��ʾAGCWD��ǿͼ��ֱ��ͼ
title('AGCWD��ǿֱ��ͼ');