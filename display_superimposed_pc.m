function display_superimposed_pc(pc1,c1, pc2, c2)
%plot two surimposed points clouds in two different colors. 
% c is a 1x3 vector with values between 0 and 255 (corresponding to RGB)

Color_pc1 = uint8(zeros(pc1.Count, 3));
Color_pc2 = uint8(zeros(pc2.Count, 3));
    % pc1 color
Color_pc1(:,1) = c1(1);
Color_pc1(:,2) = c1(2);
Color_pc1(:,3) = c1(3);

pc1.Color = Color_pc1;

    % pc2 color
Color_pc2(:,1) = c2(1); 
Color_pc2(:,2) = c2(2); 
Color_pc2(:,3) = c2(3); 

pc2.Color = Color_pc2;

pcshow(pc1);
hold on
pcshow(pc2);
hold off
end

