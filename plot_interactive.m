% run 'initalise' first

% left-click to select a peak position
% use up/down arrows to adjust contour levels
% 'p' to print NOE peak positions to console window
% 'q' to quit

contour(dH2,dC2,hmqc,clev_2d)
set(gca,'xdir','reverse');set(gca,'ydir','reverse')
xlabel('1H chemical shift / ppm')
ylabel('13C chemical shift / ppm')
    
[gx,gy,but]=ginput(1);
cscale = 1;
peaksx=[]; peaksy=[];

while true
    contour(dH2,dC2,hmqc,clev_2d,'color',[.7 .7 .7])
    set(gca,'xdir','reverse');set(gca,'ydir','reverse')
    xlabel('1H chemical shift / ppm')
    ylabel('13C chemical shift / ppm')
    ix = closest(dH,gx);
    iy = closest(dC,gy);
    if p2(ix+1,iy)>p2(ix,iy)
        ix = ix+1;
    elseif p2(ix-1,iy)>p2(ix,iy)
        ix = ix-1;
    end
     if p2(ix,iy+1)>p2(ix,iy)
        iy = iy+1;
    elseif p2(ix,iy-1)>p2(ix,iy)
        iy = iy-1;
    end
    p=y(ix,iy,:,:);
    p=reshape(p,[ftsize(3) ftsize(4)]);
    clev = clev_4d * cscale;
    hold on
    contour(dHnoe,dCnoe,p',clev,'r')
    contour(dHnoe,dCnoe,p',-clev,'m')
    plot(dH(ix),dC(iy),'kx')

    noe = p;
    noe(noe<clev(1)) = 0;
    [peaksx, peaksy] = find(imregionalmax(noe)==1);
    %plot(dHnoe(peaksx),dCnoe(peaksy),'kd','markerfacecolor','g')
    for n=1:length(peaksx)
        x=dHnoe(peaksx(n));
        yy=dCnoe(peaksy(n));
        x0=dH(ix); y0=dC(iy);
        if abs(x0-x)>0.01
            if abs(y0-yy)>0.05
                plot([x0 x],[y0 yy],'k--');
            end
        end
    end
    
    hold off
    set(gca,'xdir','reverse');set(gca,'ydir','reverse')
    xlabel('1H chemical shift / ppm')
    ylabel('13C chemical shift / ppm')
    
    % get next input
    [gx2,gy2,but]=ginput(1);
    % LMB = 1, up = 30, down = 31, q = 113
    if but==30
        cscale = cscale * 1.3;
    elseif but==31
        cscale = cscale / 1.3;
    elseif but==1
        % pick another peak position
        % zoom in and re-pick
        xl = xlim; yl = ylim; % store old plot limits
        xlim([gx2-.1 gx2+.1])
        ylim([gy2-1 gy2+1])
        drawnow nocallbacks
        but = 0;
        while(but ~= 1)
            % wait for left click
            [gx2, gy2, but] = ginput(1);
        end
        
        % restore old plot limits
        xlim(xl); ylim(yl);
        cscale = 1; % reset contour scale
        gx=gx2;
        gy=gy2;
    elseif but==113 % q
        break
    elseif but==112 % p - fit peaks
        label = input('Please enter a peak label: ','s');

        for n=1:length(peaksx)
            intensity = y(ix,iy,peaksx(n),peaksy(n));
            fprintf('%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.3e\n',label,dH(ix),dC(iy),dHnoe(peaksx(n)),dCnoe(peaksy(n)),intensity)
        end
    end
end
