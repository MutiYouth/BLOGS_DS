function rawwrite(X,MAX,filename);
% RAWWRITE Write a Portable Bitmap file, or a raw file.
%       RAWWRITE(X,MAX,'imagefile.raw') writes a "raw" image file
%       RAWWRITE(X,MAX,'imagefile.pgm') writes a "pgm" (portable gray map) image
%       MAX is the maximum intensity value used, must be smaller or
%       equal to 255. If bigger, 255 is automatically used. 
%
%       See also RAWREAD, IMWRITE, IMREAD, IMAGE, COLORMAP.

%      Chenyang Xu and Jerry L. Prince, 4/1/95, 6/17/97
%      Copyright (c) 1995-97 by Chenyang Xu and Jerry L. Prince
%      Image Analysis and Communications Lab, Johns Hopkins University

disp('RawWrite');
dot = max(find(filename == '.'));
suffix = filename(dot+1:dot+3);

if strcmp(suffix,'pgm') | strcmp(suffix,'raw')

   disp(sprintf('\nopens %s file\n',filename));
   fp = fopen(filename,'wb','b');  % "Big-endian" byte order.
   
   if (fp<0)
      error(['Cannot open ' filename '.']);
   end

   [height,width] = size(X);

   if strcmp(suffix,'pgm')
   % Write and crack the header
   
      fprintf(fp,'P5\n'); % pgm magic number : P5

      fprintf(fp, '%d %d\n', [height width]);
      if (MAX>255)
	MAX = 255;
      end
      fprintf(fp, '%d\n', MAX);
   end

   % Read the image
   disp(' Writes image data ...');
   l = fwrite(fp,X,'uchar');
   if l ~= height*width, l, error('HSI image file is wrong length'), end
   
   fclose(fp);
   
   disp('end');

else
   error('Image file name must end in ''raw'' or ''pgm''.')
end


