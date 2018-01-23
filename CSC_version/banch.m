function banch()
    base_path =uigetdir();
    
	if ispc(), base_path = strrep(base_path, '\', '/'); end
	if base_path(end) ~= '/', base_path(end+1) = '/'; end
    contents = dir(base_path);
	names = {};
	for k = 1:numel(contents)
		name = contents(k).name;
		if ~any(strcmp(name, {'.','..'}))
			names{end+1} = name;      
        end
    end
    
    for i=1:size(names,2)
        try  
            close all;
            clearvars -EXCEPT base_path contents i name names
            
            run(names{1,i},base_path);
            
            close all;
        catch
            error_handle(base_path,names{1,i});
        end
    end
end
