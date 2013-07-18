function data = av_get_video_params(vi)
ss = getselectedsource(vi);
a = get(ss);
c = fieldnames(a);
    
data={}; j = 1;
%ignore properties: parent, selected, tag, type, frameTimeout,
for i = 1:length(c)
    if strcmpi(c{i},'parent')|strcmpi(c{i},'selected')|strcmpi(c{i},'tag')|...
       strcmpi(c{i},'type')|strcmpi(c{i},'NormalizedBytesPerPacket')|...
       strcmpi(c{i},'FrameTimeout')
        continue
    end
    data{j,1} = c{i}; data{j,2} = eval(['a.',c{i}]); 
    
    pinfo=propinfo(ss,c{i});
    
    switch pinfo.Constraint
        case 'none'
            data{j,3} = pinfo.ConstraintValue;
        case 'bounded'
            tmp =  pinfo.ConstraintValue;
            data{j,3} = ['  [',num2str(tmp(1)),' ',num2str(tmp(2)),']'];
        case 'enum'
            str = '';
            for i = 1:length(pinfo.ConstraintValue)
                str = [str,', ',pinfo.ConstraintValue{i}];
            end
            str(1:2) = ' ';
            data{j,3} = str;
    end
    
    data{j,4}=pinfo.ReadOnly;
    
    j = j+1;
end


