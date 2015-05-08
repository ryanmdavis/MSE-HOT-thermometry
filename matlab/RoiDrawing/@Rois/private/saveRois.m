function obj = saveRois(obj,source)
    if strcmp(source(2:3),':\') %if the file path is absolute
        obj.path = source;
        obj.fid = fopen(source,'r','l');
    else
        obj.path = strcat(pwd,'\',source);
        obj.fid = fopen(obj.path,'r','l'); %else, source must be the file name
    end
    
    path = [path '.roi'];
    
fid = fopen(path,'w','l');

for roi_num = 1: obj.getLength
    group = obj.getSpecRoi(roi_num).getGroup;
    group_length = size(group,2);
    [x_points,y_points] = obj.getSpecRoi(roi_num).getRoiPoints;
    x_points_length = size(x_points,2);
    y_points_length = size(y_points,2);
    fwrite(fid,group_length,'single');
    fwrite(fid,double(group),'single');
    fwrite(fid,x_points_length,'single');
    fwrite(fid,x_points,'single');
    fwrite(fid,y_points_length,'single');
    fwrite(fid,y_points);
end

fclose(fid);