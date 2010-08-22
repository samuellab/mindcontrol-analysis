
%%%%%%%% AVM

[short long t]=aggregateReversals('D:\Analysis\AVM_habituation\100621_worm2');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\AVM_habituation\100622_worm0');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\AVM_habituation\100623_worm1');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\AVM_habituation\100624_mec4ChR2_worm0');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\AVM_habituation\100727_mec4ChR2_2');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\AVM_habituation\100727_worm6');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\AVM_habituation\100727_mec4ChR2_2');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\AVM_habituation\100727_worm7');
clear all; close all;

%%%%%%%% ALM

[short long t]=aggregateReversals('D:\Analysis\ALM_habituation\100728_mec4ChR2_5');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\ALM_habituation\100728_mec4ChR2_6');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\ALM_habituation\100730_mec4ChR2_1');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\ALM_habituation\100730_mec4ChR2_5');
clear all; close all;



[short long t]=aggregateReversals('D:\Analysis\ALM_habituation\100730_mec4ChR2_8');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\ALM_habituation\100730_mec4ChR2_9');
clear all; close all;


[short long t]=aggregateReversals('D:\Analysis\ALM_habituation\100731_mec4ChR2_0');
clear all; close all;



%%%%%%%% Combined

[short long t]=aggregateReversals('D:\Analysis\ALM_AVM_habituation\100731_mec4ChR2_2');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\ALM_AVM_habituation\100731_mec4ChR2_6');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\ALM_AVM_habituation\100802_mec4ChR2_1');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\ALM_AVM_habituation\100802_mec4ChR2_4');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\ALM_AVM_habituation\100802_mec4ChR2_8');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\ALM_AVM_habituation\100802_mec4ChR2_10');
clear all; close all;

[short long t]=aggregateReversals('D:\Analysis\ALM_AVM_habituation\100803_worm0');
clear all; close all;




clear all; close all;
thresh=-.03; %worm lengths per second
xALM=fitMLEtoExperiment('D:\Analysis\ALM_habituation',thresh)
xAVM=fitMLEtoExperiment('D:\Analysis\AVM_habituation',thresh)
xALMcom=fitMLEProto2('D:\Analysis\ALM_AVM_habituation',thresh,1);
xAVMcom=fitMLEProto2('D:\Analysis\ALM_AVM_habituation',thresh,0);

xALM
xAVM
xALMcom
xAVMcom

disp(['ALM alone: ' num2str(1/xALM(3)/60)])
disp(['AVM alone: ' num2str(1/xAVM(3)/60)])


disp(['ALM combined: ' num2str(1/xALMcom(3)/60)])
disp(['AVM combined: ' num2str(1/xAVMcom(3)/60)])
