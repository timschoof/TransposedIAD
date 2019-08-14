% function plotTrackFile(fileName, labelString)

clear 
clear all
labelString='TryItOut';

fileName='real results\SR_ILD-80dBSPL-150rms_10-Sep-2018_14-46-12.csv';
plotHandle = plotTrackFile(fileName, labelString );
saveas(plotHandle,[labelString '.png'])
