%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file was downloaded from:
%       https://github.com/ryanmdavis/MSE-HOT-thermometry
%
% Ryan M Davis.             rmd12@duke.edu                       05/08/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end%header


%Written by Ryan M Davis
%this function reads scan parameters from Paravision method or acqp files

%example:
%p_meth=struct('PVM_NRepetitions',[]);
%p_meth=getPVEntry3('C:/<location of method file',p_meth);
function fieldss = getPVEntry3(file,fieldss)

text_temp = textread(file,'%s');
text = '';
for cell_num = 1:size(text_temp,1)
    text = [text text_temp{cell_num} ' '];
end

fields = fieldnames(fieldss);
for field_num = 1:size(fields,1);
    field = ['##$' fields{field_num} '='];
    field_size = size(field,2);
    location = min(strfind(text,field)) + field_size;
    if ~isempty(location)
        delimiters1 = location + min(strfind(text(location:end),'##')); %two for delimiter (##) and one for a space
        delimiters2 = location + min(strfind(text(location:delimiters1(1)),'$$'));
    %     delimiters3 = location + strfind(text(location:delimiters1(1)),' ');
        field_end_location = min([delimiters1 delimiters2]) - 2;
        parentheses_locations = strfind(text(location:field_end_location),' )'); %this tests if it is an array
        if ~isempty(parentheses_locations)
            location = location + parentheses_locations(1) + 1;
        end
        value = text(location:field_end_location);

        %If the string is truly a double in char form then convert it to a
        %double:
        num_spaces = sum(double(int16(value) == 32));
        if sum(double(int16(value) >= 45)) == size(value,2) - num_spaces && sum(double(int16(value) <= 57)) == size(value,2) && sum(double(int16(value) == 47)) == 0
            value = str2num(value);
        end
        fieldss.(fields{field_num}) = value;
    end
end