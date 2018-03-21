function coords = coordsSetup(rect,setup)
res = rect(3:4)-rect(1:2);   % screen resolution

x0 = res(1)/2; % get screen length
y0 = res(2)/2; % get screen width

targRect(1,:) = CenterRectOnPoint([0 0 setup.targSize setup.targSize],x0-setup.targDist,y0) ;        % left side
targRect(2,:) = CenterRectOnPoint([0 0 setup.targSize setup.targSize],x0+setup.targDist,y0) ;        % right side

% fixCoords(:,1) =  [x0-setup.bigSize,y0-setup.smallSize,x0+setup.bigSize,y0+setup.smallSize] ;
% fixCoords(:,2) =  [x0-setup.smallSize,y0-setup.bigSize,x0+setup.smallSize,y0+setup.bigSize] ;

fixRadius = 10;
fixCoords = [[x0,y0]-fixRadius,[x0,y0]+fixRadius];
% draw fixation cross

targRectN(1,:)=CenterRectOnPoint([0 0 setup.targSizeN/1.5 setup.targSizeN/1.5],x0-setup.targDist,y0);  % left side
targRectN(2,:)=CenterRectOnPoint([0 0 setup.targSizeN/1.5 setup.targSizeN/1.5],x0+setup.targDist,y0);  % right side

diamondL = [x0-setup.targDist+setup.targSize*1.25/(2) y0+setup.targSize*1.25*sqrt(3)/6; ...
    x0-setup.targDist-setup.targSize*1.25/(2) y0+setup.targSize*1.25*sqrt(3)/6; ...
    x0-setup.targDist   y0-setup.targSize*1.25*2*sqrt(3)/6 ] ;

diamondR = [x0+setup.targDist+setup.targSize*1.25/(2) y0+setup.targSize*1.25*sqrt(3)/6; ...
    x0+setup.targDist-setup.targSize*1.25/(2) y0+setup.targSize*1.25*sqrt(3)/6; ...
    x0+setup.targDist   y0-setup.targSize*1.25*2*sqrt(3)/6 ] ;

objLcoords = [x0-setup.targDist,y0];
objRcoords = [x0+setup.targDist,y0];

coords.x0 = x0;
coords.y0 = y0;
coords.targRect = targRect;
coords.fixCoords = fixCoords;
coords.targRectN = targRectN;
coords.diamondL = diamondL;
coords.diamondR = diamondR;
coords.objLcoords = objLcoords;
coords.objRcoords = objRcoords;

end