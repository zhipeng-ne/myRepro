function [precision, fps] = run(video,base_path)  
        %path to the videos (you'll be able to choose one with the GUI).


	kernel_type = 'gaussian';
	feature_type = 'hog';
	show_visualization = 1;
	show_plots = 1;
	%parameters according to the paper. at this point we can override
	%parameters based on the chosen kernel or feature type
	kernel.type = kernel_type;
	
	features.gray = false;
	features.hog = false;
	
	padding = 1.5;  %extra area surrounding the target
	lambda = 1e-4;  %regularization
	output_sigma_factor = 0.1;  %spatial bandwidth (proportional to target)
	
	switch feature_type
	case 'gray'
		interp_factor = 0.075;  %linear interpolation factor for adaptation

		kernel.sigma = 0.2;  %gaussian kernel bandwidth
		
		kernel.poly_a = 1;  %polynomial kernel additive term
		kernel.poly_b = 7;  %polynomial kernel exponent
	
		features.gray = true;
		cell_size = 1;
		
	case 'hog'
		interp_factor = 0.02;
		
		kernel.sigma = 0.5;
		
		kernel.poly_a = 1;
		kernel.poly_b = 9;
		
		features.hog = true;
		features.hog_orientations = 9;
		cell_size = 4;
		
	otherwise
		error('Unknown feature.')
	end


	%assert(any(strcmp(kernel_type, {'linear', 'polynomial', 'gaussian'})), 'Unknown kernel.')


	switch video
	case 'choose'
		%ask the user for the video, then call self with that video name.
		video = choose_video(base_path);
		if ~isempty(video)
			[precision, fps] = run(video, kernel_type, ...
				feature_type, show_visualization, show_plots);
			
			if nargout == 0  %don't output precision as an argument
				clear precision
			end
        end
		
        
	otherwise
		%we were given the name of a single video to process.
	
		%get image file names, initial state, and ground truth for evaluation
		[img_files, pos, target_sz, ground_truth, video_path] = load_video_info(base_path, video);
		
%%
        temp = regexp(video_path, '[/\\]', 'split');   
        match = 0;
        index = 1;
        result_path =[];
        for i = 1:size(temp,2)
            match = regexp(temp{i}, 'd+a+t+a', 'once');
            if(~isempty(match))
                index = i-1;
                break;
            end
        end
        
        for i=1:index
           result_path = [result_path,temp{i},'/'];            
        end
        result_path = [result_path,'result','/']; 
        img_path = [result_path, video,'/'];
        if ~isdir(result_path)
            mkdir(result_path);
        end
        if ~isdir(img_path)
            mkdir(img_path);
        end
%%
        
		%call tracker function with all the relevant parameters
		%%[positions, time] = tracker(video_path, img_files, pos, target_sz, ...
		%%padding, kernel, lambda, output_sigma_factor, interp_factor, ...
		%%cell_size, features, show_visualization); 
        [positions, time] = tracker(video_path, img_files, pos, target_sz, ...
			padding, kernel, lambda, output_sigma_factor, interp_factor, ...
			cell_size, features, show_visualization,result_path); 
      
        Locate = [result_path video '/'];
        Locate_file= [Locate video '.txt'];
        locate = [positions, repmat(target_sz',[1,size(positions,1)])'];
        locate = round(locate');
        fid = fopen(Locate_file,'w');
        fprintf(fid,'%d %d %d %d\r\n',locate);
        fclose(fid);
%%        
		%calculate and show precision plot, as well as frames-per-second
		precisions = precision_plot(positions, ground_truth, video, show_plots);
		fps = numel(img_files) / time;

		fprintf('%12s - Precision (20px):% 1.3f, FPS:% 4.2f\n', video, precisions(20), fps)

		if nargout > 0
			%return precisions at a 20 pixels threshold
			precision = precisions(20);
		end

	end
end
