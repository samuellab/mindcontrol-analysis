function curv=findcurvature(xdata,ydata,win);
%Calculates the curvature by fitting a cirlce to a moving window of data
%points (window size specified by 'win'). 
%The sign of the curvature is calculated by taking a dot product between the tangent 
%vector along the curve and a vector from the first point in the window 
% to the circle's oirigin. 
%
% This function is adapted from a sample by roger stafford at the mathworks online
% newsgroup
%http://www.mathworks.com/matlabcentral/newsreader/view_thread/152405



%As explained by roger Stafford
% Ruchir Srivastava" <ruchir@nus.edu.sg> wrote in message <h418sh$p59$1@fred.mathworks.com>...
% > Hi Roger,
% > The code is good. Can you give me any reference for the mathematics used. I could not understand the use of variances.
% > Regards,
% > Ruchir
% ------------------------------
% Hello Ruchir Srivastava,
% 
%   This two-year-old thread predates my Watch List, and I didn't discover your question until today. My apologies for the two-week delay.
% 
%   As you recall, I defined X and Y (uppercase) by X = x - mean(x) and Y = y - mean(y) where x and y (lowercase) are the original coordinate vectors. We can thus express the quantity whose mean square value is to be minimized as
% 
%  (X-a0)^2 + (Y-b0)^2 - r^2.
% 
%   For any given fixed values of a0 and b0, it can readily be seen by taking the partial derivative of its mean square with respect to r^2, the mean square will reach a minimum with respect to r variation at the value
% 
%  r^2 = mean((X-a0)^2+(Y-b0)^2).
% 
%   Substituting this for r^2 in the above gives an expression involving only the two parameters a0 and b0:
% 
%  (X-a0)^2 - mean((X-a0)^2) + (Y-b0)^2 - mean((Y-b0)^2)
%  = -2*X*a0 - 2*Y*b0 + X^2 - mean(X^2) + Y^2 - mean(Y^2)
% 
% for which we must find the least mean square value (taking advantage of the fact that mean(X) = mean(Y) = 0.) This is equivalent to finding a0 and b0 for the least mean square approximation to the equations
% 
%  a0*X + b0*Y = (X^2-mean(X^2)+Y^2-mean(Y^2)) / 2
% 
%   As you can see, this is the least squares problem that I used the backslash operator to solve. The final determinations of a, b, and r then readily follow from this.
% 
% Roger Stafford 
% 

for k=1:length(q)-win
    x=xdata(k:k+win);
    y=ydata(k:k+win);
    mx = mean(x); my = mean(y);
     X = x - mx; Y = y - my; % Get differences from means
     dx2 = mean(X.^2); dy2 = mean(Y.^2); % Get variances
     t = [X,Y]\(X.^2-dx2+Y.^2-dy2)/2; % Solve least mean squares problem
     a0 = t(1); b0 = t(2); % t is the 2 x 1 solution array [a0;b0]
     r(k) = sqrt(dx2+dy2+a0^2+b0^2); % Calculate the radius
     a = a0 + mx; b = b0 + my; % Locate the circle's center
     
     %get the sign of the curvature by taking the cross product of the
     %tangent vector and the vector to the circle's origin
     s=sum(sign(cross( [X(1)-X(end);Y(1)-Y(end); 0;], [X(1)-a0;Y(1)-b0; 0;])));
     
     curv(k) = s/r(k); % Get the curvature
     
end