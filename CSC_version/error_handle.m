function error_handle(base_path,filename)
  if(exist([base_path 'error.txt'],'file')==2)
     fid=fopen([base_path 'error.txt'],'a+');
     fprintf(fid,'%s\n',filename);
     fclose(fid);
  else
     fid=fopen([base_path 'error.txt'],'a+');
     fprintf(fid,'%s\n','error file name:');
     fprintf(fid,'%s\n',filename);
     fclose(fid);
  end



end