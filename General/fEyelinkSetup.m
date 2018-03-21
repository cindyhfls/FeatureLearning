function fEyelinkSetup(setup,coords)

if strcmp(setup.devicename,'eye') % draw boxes on eyelink
    Eyelink('command','clear_screen %d', 0); % removes previous drawing
    Eyelink('command', 'draw_cross %d %d 15', coords.x0, coords.y0); % put a cross in the middle
    objLcoords = coords.objLcoords;
    objRcoords = coords.objRcoords;
    pxerr = setup.pxerr; % fixation window radius in pixels
    
    Eyelink('command', 'draw_box %d %d %d %d 15', round(coords.x0-pxerr), round(coords.y0-pxerr),round(coords.x0+pxerr), round(coords.y0+pxerr));
    Eyelink('command', 'draw_box %d %d %d %d 15',...        % draw_box: x1,y1,x2,y2 (corner of the boxes only)
        round(objLcoords(1)-pxerr),round(objLcoords(2)-pxerr), round(objLcoords(1)+pxerr),round(objLcoords(2)+pxerr));
    Eyelink('command', 'draw_box %d %d %d %d 15',...
        round(objRcoords(1)-pxerr),round(objRcoords(2)-pxerr), round(objRcoords(1)+pxerr),round(objRcoords(2)+pxerr));
end

end