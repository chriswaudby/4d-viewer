clear all

%% open 4D
y = zeros([506*256*256 256],'single');
for i=1:256
    disp(i)
    fid = fopen(sprintf('test%03d.ft4',i),'rb'); %open file
    header = fread(fid, 2048, 'char');
    y(:,i)=fread(fid, inf, 'float=>single'); %read in the data
    fclose(fid);
end
y=reshape(y,[506 256 256 256]);

%%
% order = Hdir Cdir Cnoe Hnoe
% reordered = Hdir Cdir Hnoe Cnoe
y=permute(y,[1 2 4 3]);
% calculate projection down Hnoe, Cnoe dimensions
tmp=max(y,[],3);
tmp=max(tmp,[],4);
p2=reshape(tmp,[506 256]);
imagesc(p2)
%%
dH=linspace(1.4,-0.95,506);
dHnoe=linspace(0.2+2.25/2,0.2-2.25/2,256);
dC=linspace(25.502,7.568,256);
dCnoe=linspace(25.502,7.568,256);
contour(dH,dC,p2',logspace(7,11,20),'m')
set(gca,'xdir','reverse');set(gca,'ydir','reverse')

%% open 2D

fid = fopen('hmqc.ft2','rb'); %open file
header = fread(fid, 2048, 'char');
hmqc=fread(fid, inf, 'float'); %read in the data
fclose(fid);
%%
hmqc=reshape(hmqc,[256 506]);
dH2=linspace(1.4,-0.949,506);
dC2=linspace(25.502,7.568,256);
contour(dH2,dC2,hmqc,logspace(6.5,10,15),'m')
set(gca,'xdir','reverse');set(gca,'ydir','reverse')

%%
vec = @(x) x(:);
