function [X,map] = rawread(filename,n,m);
% RAWREAD Read a Portable Bitmap file, or a raw file.
%       RAWREAD('imagefile.raw', xsize, ysize) reads a "raw" image file
%       RAWREAD('imagefile.pgm') reads a "pgm" (portable gray map) image
%       [X,map] = RAWREAD('imagefile.raw') returns both the image and a
%       color map, so that
%               [X,map] = rawread('imagefile.raw',sx,sy);
%       or      [X,map] = rawread('imagefile.pgm');
%               image(X)
%               colormap(map)
%       will display the result with the proper colors.
%
%       NOTE : map is optional and could be replaced during the display by
%              the "colormap('gray')" command
%
%       See also IMWRITE, IMREAD, IMAGE, COLORMAP.

dot = max(find(filename == '.'));
suffix = filename(dot+1:dot+3);

if strcmp(suffix,'pgm') | strcmp(suffix,'raw')

   disp(sprintf('\nopens %s file\n',filename));
   fp = fopen(filename,'rb','b');  % "Big-endian" byte order.
   
   if (fp<0)
      error(['Cannot open ' filename '.']);
  end

   if strcmp(suffix,'pgm')
   % Read and crack the header
   
      head = fread(fp,2,'uchar'); % pgm magic number : P5
      if ~strcmp(head,'P5'),
         fprintf(1,'\n Magic Number : %s\n',head);
      else
         fprintf(1,'\n Bad Magic Number : %s\n',head);
         error('cannot continue this way, good bye cruel world');
      end

      c = fread(fp,1,'uchar'); %reads the carriage return separating P5 from the creator

      precreator = fread(fp,1,'uchar'); % look for a '#' character preceeding a creator signature
      if precreator == '#',
         c = setstr(20);  % any character except carriage return
         cr = setstr(10); % defines a carriage return
         while c ~= cr,
               c = fread(fp,1,'uchar');
               creator = [creator,c];
         end;
         fprintf(1,'\n creator : %s\n',creator);
      else
         fprintf('\n No creator signature\n');
         fseek(fp,-1,'cof'); % return one char before
      end;

end

   if nargin <2,
      if strcmp(suffix,'raw')
      % assume image size is 256x256
         disp('RAW file without size : assume image size is 256x256');
         n = 256;
         m = 256;
      else % for PGM files
      % reads the size and depth
          disp(' reads sizes');
          n = fscanf(fp,'%d',1);
          tn = num2str(n);
          disp(['  xsize = ' tn]);
          m = fscanf(fp,'%d',1);
          tm = num2str(m);
          disp(['  ysize = ' tm]);
          p = fscanf(fp,'%d',1);
          tp = num2str(p);
          disp(['  depth = ' tp]);
          c = fread(fp,1,'uchar'); %reads the last carriage return
      end;
   end


   % Creates a gray palette and scale it to [0,1].
   disp(' create gray palette');
   for i=1:256,
       map(i,[1:3])=[i/256,i/256,i/256];
   end;
   
  
   % Read the image
   disp(' Reads image data ...');
   [X,l] = fread(fp,[n,m],'uchar');
   if l ~= m*n, l, error('HSI image file is wrong length'), end
   % Image elements are colormap indices, so start at 1.
   X = X'+1;
   
   fclose(fp);
  
   disp('end');

else
   error('Image file name must end in ''raw'' or ''pgm''.')
end




