%pass the string generated from getPVEntry3 for a pulse (e.g. RefPulse) and
%this function will parse it into a structure that gives all of the pulse
%attributes

function pulse=parsePulseInfo(string)

pulse=struct('Length',[],'Bandwidth',[],'FlipAngle',[],'Attenuation',[],'TrimBandwidth',[],'TrimAttenuation',[],'TrimRephase',[],'Classification',[],'Filename',[],'BandwidthFactor',[],'IntegralRatio',[],'RephaseFactor',[],'MinPulseLength',[],'Type',[]);

delimeter_location=[1 strfind(string,', ') size(string,2)];
fields=fieldnames(pulse);

%fields that have numbers
for field_num=[1:7 10:13]
    pulse.(fields{field_num})=str2double(string((delimeter_location(field_num)+1):(delimeter_location(field_num+1)-1))); 
end

%fields that have strings
for field_num=[8 9 14]
    pulse.(fields{field_num})=string((delimeter_location(field_num)+1):(delimeter_location(field_num+1)-1)); 
end