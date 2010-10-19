function plotMeanCurvature(file)
%plotMeanCurvature(file)
%
%Load a file exported from the YAML previewer software and display the
%mean curvature as a function of frame number
%
% Andrew Leifer
% leifer@fas.harvard.edu
% 18 October 2010


%Load a file that was exported from the previewer software

load(file);



q=handles.curvdata;
w=20;%window size
N=size(q,1); %number of frames
for k=1:N-w;
   a(k)=mean(mean(q(k:k+w,:)));
end
figure;
plot(a);
hold on;
vert=ylim;
plot([T2-T1, T2-T1],[vert(1), vert(2)],'--');
plot([T3-T1, T3-T1],[vert(1), vert(2)],'--');
title('Mean Curvature')
xlabel('Frame')
ylabel(['Normalized Curvature Averaged Over ', num2str(w), ' frames'])
    