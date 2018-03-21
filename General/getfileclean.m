% AS: code for recieving the eyetracker file and cleaning up after the
% experiment is done 
function getfileclean()
status = Eyelink('IsConnected');
if status ==1
    Eyelink('StopRecording');
    Eyelink('CloseFile');
    Eyelink('command','clear_screen %d', 0); % removes previous drawing
 
%     try
%         sprintf('%s','Receiving data file ');
%         status=Eyelink('ReceiveFile');
%         if status > 0
%             fprintf('ReceiveFile status %d\n', status);
%         end
%     catch rdf
%         sprintf('%s','Problem receiving data file ');
%         rdf;
%     end
end
 
%cleanup;
Eyelink('Shutdown');
Screen('CloseAll');
end