clc;clear all;close all;
L0=9;
L1=3;
L2=11;
L3=8;
L5=8;
theta_1=330;
w2=pi/4;
alpha2=0;
theta_2 = 0:2 :360;
for i = 1:length(theta_2)
 
 A=2*L0*L3*cosd(theta_1)-2*L1*L3*cosd(theta_2(i));
 B=2*L0*L3*sind(theta_1)-2*L1*L3*sind(theta_2(i));
 C=L0^2+L1^2+L3^2-L2^2-2*L0*L1*(cosd(theta_1)*cosd(theta_2(i))+sind(theta_1)*sind(theta_2(i)));
 
 t=roots([C-A 2*B A+C]);
 for n=1:2
 if theta_2<180
 t1=t(n);
 end
 end
 theta_4(i)=2*atand(t1);
 theta_3(i)=atand((L0*sind(theta_1)+L3*sind(theta_4)-L1*sind(theta_2(i)))/(L0*cosd(theta_1)+L3*cosd(theta_4)-L1*cosd(theta_2(i))));
   alpha(i) = 90 - theta_4(i);
   beta(i) = 2*alpha(i);
   gama(i)=beta(i)+theta_4(i);
    Ox(i) = 0;
    Oy(i) = 0;
    
    Ax(i) = Ox(i) + L1*cosd(theta_2(i));  
    Ay(i) = Oy(i) + L1*sind(theta_2(i));
    
    Bx(i) = Ox(i) + Ax(i) + L2*cosd(theta_3(i));
    By(i) = Oy(i) + Ay(i) + L2*sind(theta_3(i));
    
    Cx(i) = Ox(i) + L0*cosd(theta_1);
    Cy(i) = Oy(i) + L0*sind(theta_1);
    
   Dx(i) =  Bx(i)+ L5*cosd(gama(i));
    Dy(i) = By(i) + L5*sind(gama(i));
    
  plot([Ox(i) Ax(i)],[Oy(i) Ay(i)], [Ax(i) Bx(i)],[Ay(i) By(i)],....
                   [Bx(i) Cx(i)],[By(i) Cy(i)],[Bx(i) Dx(i)],[By(i) Dy(i)],'Linewidth', 3)
   hold on; 
  
   grid on;
   axis equal;
   axis([-L0 2.5*L0 -2*L3 2.5*L3]);
 drawnow
   hold off 
 a=[L3*cosd(theta_4) -L2*cosd(theta_3); -L3*sind(theta_4) L2*sind(theta_3)];
 b=[L1*w2*cosd(theta_2); -L1*w2*sind(theta_2)];
 w=a\b;
 w4=w(1);
 w3=w(2);
 

end
