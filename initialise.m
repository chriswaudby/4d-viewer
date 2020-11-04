clear all

% set up parameters below and run this file before plot_interactive

%% settings

% set path to 4d cubes:
% (spectrum dimensions are expected to be in the order Hdir, Cdir, Cnoe, Hnoe)
filetemplate_4d = "ft/test%03d.ft4";

% number of points in processed spectrum:
% (Hdir, Cdir, Cnoe, Hnoe)
ftsize = [506 256 256 256];

% set chemical shifts for each axis:
% (can be identified with:
%    pipe2txt.tcl -index ppm ft/test001.ft4 | head
%    pipe2txt.tcl -index ppm ft/test256.ft4 | tail
% )
dH=linspace(1.4, -0.95, ftsize(1));
dHnoe=linspace(1.325, -0.925, ftsize(4));
dC=linspace(25.502, 7.568, ftsize(2));
dCnoe=linspace(25.502, 7.568, ftsize(3));

% set reference 2d spectrum
filename_2d = "hmqc.ft2"
ftsize_2d = [256 506] % number of points in 13C and 1H dimensions
dH2=linspace(1.4,-0.949,506); % chemical shift values for 1H dimension
dC2=linspace(25.502,7.568,256); % chemical shift values for 13C dimension

% set contour levels
clev_4d = logspace(7,11,20); % default contour levels for 4D: 20 points from 10^7 to 10^11
clev_2d = logspace(6.5,10,15); % default contour levels for 2D: 15 points from 10^6.5 to 10^10




%% open 4D
y = zeros([ftsize(1)*ftsize(2)*ftsize(3) ftsize(4)],'single');
for i=1:256
    disp(i)
    fid = fopen(sprintf(filetemplate_4d,i),'rb'); %open file
    header = fread(fid, 2048, 'char');
    y(:,i)=fread(fid, inf, 'float=>single'); %read in the data
    fclose(fid);
end
y=reshape(y, ftsize);

%%
% order = Hdir Cdir Cnoe Hnoe
% reordered = Hdir Cdir Hnoe Cnoe
y=permute(y,[1 2 4 3]);
% calculate projection down Hnoe, Cnoe dimensions
tmp=max(y,[],3);
tmp=max(tmp,[],4);
p2=reshape(tmp,[506 256]);

%% plot 2D projection of 4D
figure(1)
contour(dH,dC,p2',clev_4d,'m')
set(gca,'xdir','reverse');
set(gca,'ydir','reverse');

%% open 2D

fid = fopen(filename_2d,'rb'); %open file
header = fread(fid, 2048, 'char');
hmqc=fread(fid, inf, 'float'); %read in the data
fclose(fid);
hmqc=reshape(hmqc,ftsize_2d);

%% plot 2D
figure(2)
contour(dH2,dC2,hmqc,clev_2d,'m')
set(gca,'xdir','reverse');set(gca,'ydir','reverse')

%% define utility function
vec = @(x) x(:);
