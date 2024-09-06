%------author: Wang Tianji------
%------date  : 2024.9.6   ------
%------compute cos and sin by Cordic------
%-----------------------------------------
function [cos_val, sin_val] = Cordic_solve_cos_sin(angle,ite_num)
%判断角度是否为负
if angle < 0
    neg_flag = 1;
    angle = abs(angle);
else
    neg_flag = 0;
end
%把角度映射到第一象限
angle_val = angle - floor(angle/90) * 90;
quadrant = mod(floor(angle/90),4);

%缩放因子K = 0.6073
K = 0.6073;
%初始值
x0 = K;
y0 = 0;
z0 = 0;
%目标角度的弧度值
z_tar = angle_val/180*pi;
%旋转方向，0-逆时针旋转，1-顺时针旋转
d0 = 0;
%迭代过程，只计算正值0-89度角的三角函数，其它象限及负角度通过标志位控制输出
for i = 0:ite_num
    xi = x0 - y0 * (-1)^d0 * 2^(-i);
    yi = y0 + x0 * (-1)^d0 * 2^(-i);
    zi = z0 + (-1)^d0 * atan(2^(-i));

    x0 = xi;
    y0 = yi;
    z0 = zi;

    if z0 > z_tar
        d0 = 1;
    else
        d0 = 0;
    end
end

%angle_val == 0的时候角度在坐标轴上
if angle_val == 0
    switch quadrant
        case 0
            cos_val = 1;
            sin_val = 0;
        case 1
            cos_val = 0;
            sin_val = 1;
        case 2
            cos_val = -1;
            sin_val = 0;
        case 3
            cos_val = 0;
            sin_val = -1;
        otherwise
            cos_val = 0;
            sin_val = 0;
    end
else
    switch quadrant
        case 0
            cos_val = x0;
            sin_val = y0;
        case 1
            cos_val = -y0;
            sin_val = x0;
        case 2
            cos_val = -x0;
            sin_val = -y0;
        case 3
            cos_val = y0;
            sin_val = -x0;
        otherwise
            cos_val = 0;
            sin_val = 0;
    end
end
%如果角度为负值，sin值取反
if neg_flag == 1
    sin_val = -sin_val;
end

end