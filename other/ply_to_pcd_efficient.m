% This function converts the ply file into pcd format which is employed in
% PCL library

[filename, pathname] = uigetfile({'*.ply;', 'Choose the camera position from bundler'});

plyfilename = [pathname filename];
pcdfilename = [pathname filename(1:end-4) '.pcd'];
plyfile = fopen(plyfilename, 'r');
pcdfile = fopen(pcdfilename, 'wt');

% ingore the ply header
plytline = fgetl(plyfile);

% Write the pcd header
fprintf(pcdfile, '%s\n', '# .PCD v.7 - Point Cloud Data file format');

% ingore the ply format
plytline = fgetl(plyfile);

% Write the pcd version
fprintf(pcdfile, '%s\n', 'VERSION .7');

% ingore the ply comment
plytline = fgetl(plyfile);

% grab the number of vertices in ply
plytline = fgetl(plyfile);
NumVertices = sscanf(plytline, ['element vertex' '%d']);

% analysis information constitution in ply file
% throw away x, y, z properties in header
plytline = fgetl(plyfile);
plytline = fgetl(plyfile);
plytline = fgetl(plyfile);

plytline = fgetl(plyfile);
disp('===========================');
disp('                           ');
if ~isempty(strfind(plytline, 'red'))
    tic
    fclose(plyfile);
    fprintf('PLY file has color information for vertex!\n');

    % write the header in pcd file
    fprintf(pcdfile, '%s\n', 'FIELDS x y z rgb');
    fprintf(pcdfile, '%s\n', 'SIZE 4 4 4 4');
    fprintf(pcdfile, '%s\n', 'TYPE F F F U');
    fprintf(pcdfile, '%s\n', 'COUNT 1 1 1 1');
    fprintf(pcdfile, 'WIDTH %d\n', NumVertices);
    fprintf(pcdfile, 'HEIGHT %d\n', 1);
    fprintf(pcdfile, '%s\n', 'VIEWPOINT 0 0 0 1 0 0 0');
    fprintf(pcdfile, 'POINTS %d\n', NumVertices);
    fprintf(pcdfile, '%s\n', 'DATA ascii');
    fclose(pcdfile);
    
    % read the data block from ply to pcd
    data = dlmread(plyfilename, ' ',[14 0 NumVertices+13 5]);
    red = dec2hex(data(:, 4));
    green = dec2hex(data(:, 5));
    blue = dec2hex(data(:, 6));
    rgb = hex2dec([red green blue]);
    data = [data(:,1:3) rgb];
    dlmwrite(pcdfilename, data, 'delimiter', ' ', '-append', 'precision', '%u');
    fprintf('Format conversion complete!\n');
    toc
else
    tic
    fclose(plyfile);
    fprintf('PLY file has no color information for vertex!\n');

    % write the header in pcd file
    fprintf(pcdfile, '%s\n', 'FIELDS x y z');
    fprintf(pcdfile, '%s\n', 'SIZE 4 4 4');
    fprintf(pcdfile, '%s\n', 'TYPE F F F');
    fprintf(pcdfile, '%s\n', 'COUNT 1 1 1');
    fprintf(pcdfile, 'WIDTH %d\n', NumVertices);
    fprintf(pcdfile, 'HEIGHT %d\n', 1);
    fprintf(pcdfile, '%s\n', 'VIEWPOINT 0 0 0 1 0 0 0');
    fprintf(pcdfile, 'POINTS %d\n', NumVertices);
    fprintf(pcdfile, '%s\n', 'DATA ascii');
    fclose(pcdfile);
    
    % read the data block from ply to pcd
    data = dlmread(plyfilename, ' ',[10 0 NumVertices+9 2]);
    dlmwrite(pcdfilename, data, 'delimiter', ' ', '-append');
    fprintf('Format conversion complete!\n');
    toc
end
    
        