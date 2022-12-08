classdef Double_Toggle < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        ShowingAnalyticalValuesLabel   matlab.ui.control.Label
        SaveasButton                   matlab.ui.control.Button
        ResetAnalysisButton            matlab.ui.control.Button
        ResetButton                    matlab.ui.control.Button
        TorqueNmEditField              matlab.ui.control.NumericEditField
        TorqueNmEditFieldLabel         matlab.ui.control.Label
        CalculateButton                matlab.ui.control.Button
        CouplerofSliderCrankEditField  matlab.ui.control.NumericEditField
        CouplerofSliderCrankEditFieldLabel  matlab.ui.control.Label
        PistonEditField                matlab.ui.control.NumericEditField
        PistonEditFieldLabel           matlab.ui.control.Label
        RockerEditField                matlab.ui.control.NumericEditField
        CouplerEditField               matlab.ui.control.NumericEditField
        CouplerEditFieldLabel          matlab.ui.control.Label
        RockerEditFieldLabel           matlab.ui.control.Label
        ForcePEditField                matlab.ui.control.NumericEditField
        ForcePEditFieldLabel           matlab.ui.control.Label
        ForAnalysisLabel               matlab.ui.control.Label
        ExitButton                     matlab.ui.control.Button
        TimeEditFieldLabel             matlab.ui.control.Label
        TimeEditField                  matlab.ui.control.NumericEditField
        w2EditField                    matlab.ui.control.NumericEditField
        w2EditFieldLabel               matlab.ui.control.Label
        theta2EditField                matlab.ui.control.NumericEditField
        theta2EditFieldLabel           matlab.ui.control.Label
        AnalyzeDropDown                matlab.ui.control.DropDown
        AnalyzeDropDownLabel           matlab.ui.control.Label
        L0fixedEditFieldLabel          matlab.ui.control.Label
        L0fixedEditField               matlab.ui.control.NumericEditField
        AnimateButton                  matlab.ui.control.Button
        L4coupler2EditField            matlab.ui.control.NumericEditField
        L4coupler2EditFieldLabel       matlab.ui.control.Label
        L3RockerEditField              matlab.ui.control.NumericEditField
        L3RockerEditFieldLabel         matlab.ui.control.Label
        L2couplerEditField             matlab.ui.control.NumericEditField
        L2couplerEditFieldLabel        matlab.ui.control.Label
        L1CrankEditField               matlab.ui.control.NumericEditField
        L1CrankEditFieldLabel          matlab.ui.control.Label
        UIAxes                         matlab.ui.control.UIAxes
    end

    
    methods (Access = public)
        
        function CreateOutputfile(app)
            L1=app.L0fixedEditField.Value;
            L2=app.L1CrankEditField.Value;
            L3=app.L2couplerEditField.Value;
            L4=app.L3RockerEditField.Value;
            L5=app.L4coupler2EditField.Value;
             P = app.ForcePEditField.Value;
                   w2 = app.w2EditField.Value;
                   time = app.TimeEditField.Value;
                   theta_2 = app.theta2EditField.Value;
                  
 e=0;
 alpha2 = 0;                  
  TIME=0:0.1:time;
    Theta_2 = ((theta_2)+(TIME*w2))*180/pi;
    AC = sqrt(L1.^2 + L2.^2 - 2*L1*L2*cosd(Theta_2))
    B = AC.^2
    beta = acosd((L1.^2 + B - L2.^2) ./ (2*L1.*AC))
    psi = acosd((L3.^2 + B - L4.^2) ./ (2*L3*AC))
    lambda = acosd((L4.^2 + B - L3.^2) ./ (2*L4*AC))
    
    theta_3 = psi - beta
    theta_4 = 180 - lambda - beta
    
    
    
w3 = (L2/L3)*w2*(sind(theta_4-Theta_2))./sind(theta_3-theta_4)
w4 = (L2/L4)*w2*(sind(theta_3-Theta_2))./sind(theta_3-theta_4)

alpha3 = (L2.*w2.^2.*(cosd(theta_4-Theta_2))+L3.*w3.^2.*(cosd(theta_4-theta_3))-L4.*w4.^2)./L3.*sind(theta_4-theta_3)
alpha4 = (-L2.*w2.^2.*(cosd(theta_3-Theta_2))+L4.*w4.^2.*(cosd(theta_3-theta_4))-L3.*w3.^2)./L4.*sind(theta_3-theta_4)



alpha1 = 90 - theta_4

w=w4;
a2=alpha4;
thetA2=alpha1;
theta3=asind((e-L4.*sind(thetA2))./(L5))
w5=(L4*-w.*cosd(thetA2))./(L5.*cosd(theta3))
v=((L4*w.*sind(theta3-thetA2))./(cosd(theta3)));
a3=(L4*(w.^2).*sind(thetA2)+L5.*(w5.^2).*sind(theta3)-L4.*a2.*cos(theta3))./L5.*cosd(theta3);
a=(L4.*a2.*sind(theta3-thetA2)-L4.*(w.^2).*cosd(theta3-thetA2)-L5.*(w5.^2))./cosd(theta3);



startingFolder = userpath;
            filter = {'.docx';'*.dat';'*.txt';'*.m';'*.slx';'*.mat';'*.*'};
            defaultFileName = fullfile(startingFolder, filter);
            [baseFileName, folder] = uiputfile(defaultFileName, 'Specify a file');
            if baseFileName == 0
              % User clicked the Cancel button.
              return;
            end
            fullFileName = fullfile(folder, baseFileName);
            import mlreportgen.dom.*
            d_2 = Document(fullFileName,"docx");
            open(d_2);
            if d_2 ~= -1
                 tableStyle_1 = { Width("70%"), ...
                                   Border("solid"), ...
                                   RowSep("solid"), ...
                                   ColSep("solid") };
    
                    append(d_2,Heading1("INPUTS: "));
                    
                    HeaderContent = {'LINKS','LENGTH (metres)','TYPE'};
                    BodyContent = {'L0',L1,'Fixed';'L1',L2,'Crank';'L2',L3,'Coupler';...
                                    'L3',L4,'Rocker';'L4',L5,'Couplerof SliderCrank';};
                    tableContent_2 = [HeaderContent;BodyContent];
                    
                    table = Table(tableContent_2);
                    table.Style = tableStyle_1;
                    
                    table.TableEntriesHAlign = "center";
                    append(d_2, table);
                     tableStyle = { Width("110%"), ...
                               Border("solid"), ...
                               RowSep("solid"), ...
                               ColSep("solid") };
 
               append(d_2,Heading1("GIVEN DATA:"));
                BodyContent = {'Time  (secs)', time; ...
                               'Initial angle made by crank with horizontal (radians)',theta_2; ...                                 
                                'Anglular velocity of driver crank (rad/s) ' ,w2};
                
                    tableContent_1 = [BodyContent];
                    
                    table = Table(tableContent_1);
                    table.Style = tableStyle;
                    
                    table.TableEntriesHAlign = "center";
                    append(d_2, table); 
                     headerContent = {'Time (secs)','CRANK angle with horizontal (degrees)'};
                    bodyContent = [TIME',Theta_2'];
                    
                    data_str = string(bodyContent)
                    %round to 2 decimal places
                    for i = 1:numel(data_str)
                    data_str(i) = sprintf('%.2f',data_str(i))
                    end            
                    
                    tableContent = [headerContent; data_str];            
                    
                    append(d_2,Heading1("All Table Entries Centered"));
                    
                    table = Table(tableContent);
                    table.Style = tableStyle;
                    
                    table.TableEntriesHAlign = "center";
                    append(d_2, table);
                    table_Style = { Width("100%"), ...
                                   Border("solid"), ...
                                   RowSep("solid"), ...
                                   ColSep("solid") };
                    
                    header_Content = {'Time (secs)','Velocity_Coupler (rad/s)','Velocity_Rocker (rad/s)','Velocity of slider (m/s)',...
                              'Velocity_CouplerofSliderCrank(rad/s)','Acceleration_Coupler (rad/s^2)','Acceleration_Rocker (rad/s^2)',...
                              'Acceleration of slider (m/s^2)','Acceleration_CouplerofSliderCrank(rad/s)' };
                    body_Content = [TIME',w3',w4',v',w5',alpha3',alpha4',a3',a'];
                    
                    data__str = string(body_Content);
                    %round to 2 decimal places
                    for i = 1:numel(data__str)
                    data__str(i) = sprintf('%.2f',data__str(i));
                    end
                    
                    
                    table_Content = [header_Content; data__str];
                    
                    
                    append(d_2,Heading1("All Table Entries Centered"));
                    
                    table = Table(table_Content);
                    table.Style = table_Style;
                    
                    table.TableEntriesHAlign = "center";
                    append(d_2, table);
                    
                    close(d_2);   
                     else
                warningMessage = sprintf('Cannot open file:\n', fullFileName);
                uiwait(warndlg(warningMessage));         
                
                    
            end
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: AnimateButton
        function AnimateButtonPushed(app, event)
            L1=app.L0fixedEditField.Value;
            L2=app.L1CrankEditField.Value;
            L3=app.L2couplerEditField.Value;
            L4=app.L3RockerEditField.Value;
            L5=app.L4coupler2EditField.Value;
theta_2 = 0:2:360;
 if (L2+L3>L1+L4 )
   f = errordlg("Given link lenghts doesn't Satisfy the mechanism ");
                    
 elseif (L2+L3==L1+L4) 
     f = errordlg("Given link lenghts doesn't Satisfy the mechanism ");
                    
        
        elseif (L4<L5|L4>L5)
   f = errordlg("L3 and L4 lengths shoulld be same ");
        
 else if (L2+L3<L1+L4)
  
for i = 1:length(theta_2)
    AC(i) = sqrt(L1^2 + L2^2 - 2*L1*L2*cosd(theta_2(i)));
    beta(i) = acosd((L1^2 + AC(i)^2 - L2^2) / (2*L1*AC(i)));
    psi(i) = acosd((L3^2 + AC(i)^2 - L4^2) / (2*L3*AC(i)));
    lambda(i) = acosd((L4^2 + AC(i)^2 - L3^2) / (2*L4*AC(i)));
    
    theta_3(i) = psi(i) - beta(i);
    theta_4(i) = 180 - lambda(i) - beta(i);
    
    
    if theta_2(i) > 180
        theta_3(i) = psi(i) + beta(i);
        theta_4(i) = 180 - lambda(i) + beta(i);
    end
   alpha(i) = 90 - theta_4(i);
   beta(i) = 2*alpha(i);
   gama(i)=beta(i)+theta_4(i);
  
   
    
     Ox(i) = 0;
     Oy(i) = 0;
    
    Ax(i) = Ox(i) + L2*cosd(theta_2(i));  
    Ay(i) = Oy(i) + L2*sind(theta_2(i));
    
    Bx(i) = Ox(i) + Ax(i) + L3*cosd(theta_3(i));
    By(i) = Oy(i) + Ay(i) + L3*sind(theta_3(i));
    
    Cx(i) = L1;
    Cy(i) = 0;
    
    
    Dx(i) =  Bx(i)+ L5*cosd(gama(i));
    Dy(i) = By(i) + L5*sind(gama(i));
   
    
  plot(app.UIAxes,[Ox(i) Ax(i)],[Oy(i) Ay(i)], [Ax(i) Bx(i)],[Ay(i) By(i)],...
                   [Bx(i) Cx(i)],[By(i) Cy(i)],[Bx(i) Dx(i)],[By(i) Dy(i)],...
                   'Linewidth', 3) 
  rectangle(app.UIAxes,'Position',[Dx(i)-1 Dy(i) 4 4],"FaceColor",'g');
  hold on;
   app.UIAxes,grid on;
   axis equal;
   axis(app.UIAxes,[-L1 2.5*L1 -2*L4 2.5*L4]);
 drawnow
   hold on; 
end
end
 end     
        end

        % Button pushed function: ExitButton
        function ExitButtonPushed(app, event)
            closereq();
        end

        % Button pushed function: CalculateButton
        function CalculateButtonPushed(app, event)
            L1=app.L0fixedEditField.Value;
            L2=app.L1CrankEditField.Value;
            L3=app.L2couplerEditField.Value;
            L4=app.L3RockerEditField.Value;
            L5=app.L4coupler2EditField.Value;
            P = app.ForcePEditField.Value;
                   w2 = app.w2EditField.Value;
                   time = app.TimeEditField.Value;
                   theta_2 = app.theta2EditField.Value;
                   Theta_2 = (theta_2+w2*time)*180/pi;
 e=0;
 alpha2 = 0; 
 if (L2+L3>L1+L4 )
    f = errordlg("Given link lenghts doesn't Satisfy the mechanism ");
                  
                    
 elseif (L2+L3==L1+L4) 
      f = errordlg("Given link lenghts doesn't Satisfy the mechanism ");
                  
                    
        
        elseif (L4<L5|L4>L5)
    f = errordlg("L3 and L4 lengths shoulld be same  ");
                 
                 
        
 else if (L2+L3<L1+L4)
 for timE=time

    AC = sqrt(L1^2 + L2^2 - 2*L1*L2*cosd(Theta_2));
    beta = acosd((L1^2 + AC^2 - L2^2) / (2*L1*AC));
    psi = acosd((L3^2 + AC^2 - L4^2) / (2*L3*AC));
    lambda = acosd((L4^2 + AC^2 - L3^2) / (2*L4*AC));
    
    theta_3 = psi - beta;
    theta_4 = 180 - lambda - beta;
    
    
    if Theta_2 > 180
        theta_3 = psi + beta;
        theta_4 = 180 - lambda + beta;
    end
a=[L4*cosd(theta_4) -L3*cosd(theta_3); -L4*sind(theta_4) L3*sind(theta_3)];
b=[L2*w2*cosd(Theta_2); -L2*w2*sind(Theta_2)];
w=a\b;
w4=w(1);
w3=w(2);
couplerV = w3;
c=[L4*(w4^2)*sind(theta_4)-L2*(w2^2)*sind(Theta_2)+L2*alpha2*cosd(Theta_2)-...
L3*(w3^2)*sind(theta_3);
-L4*(w4^2)*cosd(theta_4)-L2*(w2^2)*cosd(Theta_2)-L2*alpha2*sind(Theta_2)-....
L3*(w3^2)*cosd(theta_3)];
alpha=a\c;
alpha4=alpha(1)
alpha3=alpha(2)

end
alpha1 = 90 - theta_4

w=w4;
a2=alpha4;
thetA2=alpha1
theta3=asind((e-L4.*sind(thetA2))./(L5))
w5=(L4*-w.*cosd(thetA2))./(L5.*cosd(theta3))
v=((L4*w.*sind(theta3-thetA2))./(cosd(theta3)))
a3=(L4*(w.^2).*sind(thetA2)+L5.*(w5.^2).*sind(theta3)-L4.*a2.*cos(theta3))./L5.*cosd(theta3)
a=(L4.*a2.*sind(theta3-thetA2)-L4.*(w.^2).*cosd(theta3-thetA2)-L5.*(w5.^2))./cosd(theta3)

if(strcmp(app.AnalyzeDropDown.Value,'Velocity'))
    app.CouplerEditField.Value = couplerV;
    app.RockerEditField.Value = w4;
    app.PistonEditField.Value = v;
    app.CouplerofSliderCrankEditField.Value = w5;
    
end
        if(strcmp(app.AnalyzeDropDown.Value,'Acceleration'))
             app.CouplerEditField.Value = alpha3;
             app.RockerEditField.Value = alpha4;
             app.PistonEditField.Value = a;
             app.CouplerofSliderCrankEditField.Value = a3;
        end
syms F
FX = -P + F*cosd(alpha1) ==0;
Fbe = double(rhs(vpa(isolate(FX,F))))
Fab = 2*P*tand(alpha1);
Torque = cross( L2*[cosd(Theta_2) sind(Theta_2) 0], Fab*([cosd(theta_3)... 
                  sind(theta_3) 0]));
T2 = Torque(3);
if(strcmp(app.AnalyzeDropDown.Value,'Force'))
    app.CouplerEditField.Value = Fab;
    app.RockerEditField.Value = Fab;
    app.PistonEditField.Value = P;
    app.CouplerofSliderCrankEditField.Value = Fbe;
end
if(strcmp(app.AnalyzeDropDown.Value,'Torque'))
    app.TorqueNmEditField.Value = T2;
end
 end
 end
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            app.L0fixedEditField.Value=0;
            app.L1CrankEditField.Value=0;
            app.L2couplerEditField.Value=0;
            app.L3RockerEditField.Value=0;
            app.L4coupler2EditField.Value=0;
            app.theta2EditField.Value=0;
            app.w2EditField.Value=0;
            app.TimeEditField.Value=0;
            app.ForcePEditField.Value=0;
             app.Label.Text="";
        end

        % Button pushed function: ResetAnalysisButton
        function ResetAnalysisButtonPushed(app, event)
            app.theta2EditField.Value=0;
            app.w2EditField.Value=0;
            app.TimeEditField.Value=0;
            app.ForcePEditField.Value=0;
        end

        % Button pushed function: SaveasButton
        function SaveasButtonPushed(app, event)
            CreateOutputfile(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 0.6431 0.0706];
            app.UIFigure.Position = [100 100 698 500];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, {'Double Toggle Animation'; ''})
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [195 228 425 258];

            % Create L1CrankEditFieldLabel
            app.L1CrankEditFieldLabel = uilabel(app.UIFigure);
            app.L1CrankEditFieldLabel.HorizontalAlignment = 'right';
            app.L1CrankEditFieldLabel.Position = [14 417 59 22];
            app.L1CrankEditFieldLabel.Text = 'L1(Crank)';

            % Create L1CrankEditField
            app.L1CrankEditField = uieditfield(app.UIFigure, 'numeric');
            app.L1CrankEditField.Position = [88 417 100 22];

            % Create L2couplerEditFieldLabel
            app.L2couplerEditFieldLabel = uilabel(app.UIFigure);
            app.L2couplerEditFieldLabel.HorizontalAlignment = 'right';
            app.L2couplerEditFieldLabel.Position = [7 385 66 22];
            app.L2couplerEditFieldLabel.Text = 'L2(coupler)';

            % Create L2couplerEditField
            app.L2couplerEditField = uieditfield(app.UIFigure, 'numeric');
            app.L2couplerEditField.Position = [88 385 100 22];

            % Create L3RockerEditFieldLabel
            app.L3RockerEditFieldLabel = uilabel(app.UIFigure);
            app.L3RockerEditFieldLabel.HorizontalAlignment = 'right';
            app.L3RockerEditFieldLabel.Position = [8 353 65 22];
            app.L3RockerEditFieldLabel.Text = 'L3(Rocker)';

            % Create L3RockerEditField
            app.L3RockerEditField = uieditfield(app.UIFigure, 'numeric');
            app.L3RockerEditField.Position = [88 353 100 22];

            % Create L4coupler2EditFieldLabel
            app.L4coupler2EditFieldLabel = uilabel(app.UIFigure);
            app.L4coupler2EditFieldLabel.HorizontalAlignment = 'right';
            app.L4coupler2EditFieldLabel.Position = [0 320 73 22];
            app.L4coupler2EditFieldLabel.Text = 'L4(coupler2)';

            % Create L4coupler2EditField
            app.L4coupler2EditField = uieditfield(app.UIFigure, 'numeric');
            app.L4coupler2EditField.Position = [88 320 100 22];

            % Create AnimateButton
            app.AnimateButton = uibutton(app.UIFigure, 'push');
            app.AnimateButton.ButtonPushedFcn = createCallbackFcn(app, @AnimateButtonPushed, true);
            app.AnimateButton.Position = [371 198 100 22];
            app.AnimateButton.Text = 'Animate';

            % Create L0fixedEditField
            app.L0fixedEditField = uieditfield(app.UIFigure, 'numeric');
            app.L0fixedEditField.Position = [88 451 100 22];

            % Create L0fixedEditFieldLabel
            app.L0fixedEditFieldLabel = uilabel(app.UIFigure);
            app.L0fixedEditFieldLabel.HorizontalAlignment = 'right';
            app.L0fixedEditFieldLabel.Position = [21 451 52 22];
            app.L0fixedEditFieldLabel.Text = 'L0(fixed)';

            % Create AnalyzeDropDownLabel
            app.AnalyzeDropDownLabel = uilabel(app.UIFigure);
            app.AnalyzeDropDownLabel.HorizontalAlignment = 'right';
            app.AnalyzeDropDownLabel.Position = [25 69 48 22];
            app.AnalyzeDropDownLabel.Text = 'Analyze';

            % Create AnalyzeDropDown
            app.AnalyzeDropDown = uidropdown(app.UIFigure);
            app.AnalyzeDropDown.Items = {'Velocity', 'Acceleration', 'Force', 'Torque'};
            app.AnalyzeDropDown.Position = [88 69 100 22];
            app.AnalyzeDropDown.Value = 'Velocity';

            % Create theta2EditFieldLabel
            app.theta2EditFieldLabel = uilabel(app.UIFigure);
            app.theta2EditFieldLabel.HorizontalAlignment = 'right';
            app.theta2EditFieldLabel.Position = [34 207 39 22];
            app.theta2EditFieldLabel.Text = 'theta2';

            % Create theta2EditField
            app.theta2EditField = uieditfield(app.UIFigure, 'numeric');
            app.theta2EditField.Position = [88 207 100 22];

            % Create w2EditFieldLabel
            app.w2EditFieldLabel = uilabel(app.UIFigure);
            app.w2EditFieldLabel.HorizontalAlignment = 'right';
            app.w2EditFieldLabel.Position = [48 176 25 22];
            app.w2EditFieldLabel.Text = 'w2';

            % Create w2EditField
            app.w2EditField = uieditfield(app.UIFigure, 'numeric');
            app.w2EditField.Position = [88 176 100 22];

            % Create TimeEditField
            app.TimeEditField = uieditfield(app.UIFigure, 'numeric');
            app.TimeEditField.Position = [88 140 100 22];

            % Create TimeEditFieldLabel
            app.TimeEditFieldLabel = uilabel(app.UIFigure);
            app.TimeEditFieldLabel.HorizontalAlignment = 'right';
            app.TimeEditFieldLabel.Position = [42 140 31 22];
            app.TimeEditFieldLabel.Text = 'Time';

            % Create ExitButton
            app.ExitButton = uibutton(app.UIFigure, 'push');
            app.ExitButton.ButtonPushedFcn = createCallbackFcn(app, @ExitButtonPushed, true);
            app.ExitButton.BackgroundColor = [1 0 0];
            app.ExitButton.FontColor = [1 1 1];
            app.ExitButton.Position = [599 479 100 22];
            app.ExitButton.Text = 'Exit';

            % Create ForAnalysisLabel
            app.ForAnalysisLabel = uilabel(app.UIFigure);
            app.ForAnalysisLabel.BackgroundColor = [1 1 0.0667];
            app.ForAnalysisLabel.FontSize = 20;
            app.ForAnalysisLabel.Position = [48 239 140 25];
            app.ForAnalysisLabel.Text = 'For Analysis';

            % Create ForcePEditFieldLabel
            app.ForcePEditFieldLabel = uilabel(app.UIFigure);
            app.ForcePEditFieldLabel.HorizontalAlignment = 'right';
            app.ForcePEditFieldLabel.Position = [21 111 52 22];
            app.ForcePEditFieldLabel.Text = 'Force(P)';

            % Create ForcePEditField
            app.ForcePEditField = uieditfield(app.UIFigure, 'numeric');
            app.ForcePEditField.Position = [88 111 100 22];

            % Create RockerEditFieldLabel
            app.RockerEditFieldLabel = uilabel(app.UIFigure);
            app.RockerEditFieldLabel.HorizontalAlignment = 'right';
            app.RockerEditFieldLabel.Position = [522 119 43 22];
            app.RockerEditFieldLabel.Text = 'Rocker';

            % Create CouplerEditFieldLabel
            app.CouplerEditFieldLabel = uilabel(app.UIFigure);
            app.CouplerEditFieldLabel.HorizontalAlignment = 'right';
            app.CouplerEditFieldLabel.Position = [518 155 47 22];
            app.CouplerEditFieldLabel.Text = 'Coupler';

            % Create CouplerEditField
            app.CouplerEditField = uieditfield(app.UIFigure, 'numeric');
            app.CouplerEditField.Position = [580 155 100 22];

            % Create RockerEditField
            app.RockerEditField = uieditfield(app.UIFigure, 'numeric');
            app.RockerEditField.Position = [580 119 100 22];

            % Create PistonEditFieldLabel
            app.PistonEditFieldLabel = uilabel(app.UIFigure);
            app.PistonEditFieldLabel.HorizontalAlignment = 'right';
            app.PistonEditFieldLabel.Position = [526 82 39 22];
            app.PistonEditFieldLabel.Text = 'Piston';

            % Create PistonEditField
            app.PistonEditField = uieditfield(app.UIFigure, 'numeric');
            app.PistonEditField.Position = [580 82 100 22];

            % Create CouplerofSliderCrankEditFieldLabel
            app.CouplerofSliderCrankEditFieldLabel = uilabel(app.UIFigure);
            app.CouplerofSliderCrankEditFieldLabel.HorizontalAlignment = 'right';
            app.CouplerofSliderCrankEditFieldLabel.Position = [434 48 131 22];
            app.CouplerofSliderCrankEditFieldLabel.Text = 'Coupler of Slider-Crank';

            % Create CouplerofSliderCrankEditField
            app.CouplerofSliderCrankEditField = uieditfield(app.UIFigure, 'numeric');
            app.CouplerofSliderCrankEditField.Position = [580 48 100 22];

            % Create CalculateButton
            app.CalculateButton = uibutton(app.UIFigure, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.Position = [371 111 100 22];
            app.CalculateButton.Text = 'Calculate';

            % Create TorqueNmEditFieldLabel
            app.TorqueNmEditFieldLabel = uilabel(app.UIFigure);
            app.TorqueNmEditFieldLabel.HorizontalAlignment = 'right';
            app.TorqueNmEditFieldLabel.Position = [496 14 69 22];
            app.TorqueNmEditFieldLabel.Text = 'Torque(Nm)';

            % Create TorqueNmEditField
            app.TorqueNmEditField = uieditfield(app.UIFigure, 'numeric');
            app.TorqueNmEditField.Position = [580 14 100 22];

            % Create ResetButton
            app.ResetButton = uibutton(app.UIFigure, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.Position = [4 1 100 22];
            app.ResetButton.Text = 'Reset';

            % Create ResetAnalysisButton
            app.ResetAnalysisButton = uibutton(app.UIFigure, 'push');
            app.ResetAnalysisButton.ButtonPushedFcn = createCallbackFcn(app, @ResetAnalysisButtonPushed, true);
            app.ResetAnalysisButton.Position = [122 1 100 22];
            app.ResetAnalysisButton.Text = 'ResetAnalysis';

            % Create SaveasButton
            app.SaveasButton = uibutton(app.UIFigure, 'push');
            app.SaveasButton.ButtonPushedFcn = createCallbackFcn(app, @SaveasButtonPushed, true);
            app.SaveasButton.Position = [249 1 100 22];
            app.SaveasButton.Text = 'Save as';

            % Create ShowingAnalyticalValuesLabel
            app.ShowingAnalyticalValuesLabel = uilabel(app.UIFigure);
            app.ShowingAnalyticalValuesLabel.BackgroundColor = [1 1 0.0667];
            app.ShowingAnalyticalValuesLabel.FontSize = 16;
            app.ShowingAnalyticalValuesLabel.Position = [484 184 196 22];
            app.ShowingAnalyticalValuesLabel.Text = 'Showing Analytical Values ';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Double_Toggle

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end