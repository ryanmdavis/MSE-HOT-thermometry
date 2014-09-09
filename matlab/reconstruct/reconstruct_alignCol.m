% called by reconstruct(...).  Formats each hyperlink to be more visually
% apealing, so that each printed string is aligned columnwise.
% input:
%   cell array is individual cells to be concatenated
%   col is an array of columns to start each printed string
function out_cell=reconstruct_alignCol(cell_array,col)

col=[col col(end)+size(cell_array{end}{1},2)];
out_cell={''};
for ii=1:col(end) out_cell=strcat(out_cell,{' '}); end
for cell_num=2:size(cell_array,2)
    cell_size=size(cell_array{cell_num}{1},2);
    if col(cell_num+1)-col(cell_num)>=cell_size
        out_cell{1}(col(cell_num):(col(cell_num)+size(cell_array{cell_num}{1},2)-1))=cell_array{cell_num}{1};
    else
        string_size=col(cell_num+1)-col(cell_num);
        out_cell{1}(col(cell_num):(col(cell_num+1)-1))=cell_array{cell_num}{1}(1:string_size);
    end
end

%add back in the first entry, which is the link
link_buffer_whitespace=3;
str_info=out_cell{1}((col(2)-link_buffer_whitespace):end);
out_cell=strcat(cell_array{1},str_info);