% I will need to modify this for eye fixation
function [fixate] = decide_fixation(center_coord, cursor_coord, task_opt)

	% This function decides whether joystick cursor is fixated to center for defined period. 
	mat_center	= repmat( center_coord, task_opt.num_vert, 1);
	distance	= sum(sqrt((cursor_coord - mat_center).^2 ), 2);
	dist_res	= distance < task_opt.fixdot_size;

    % fprintf( 'result: %4.3d     \n', sum(dist_res) );
    
	if sum(dist_res) < (task_opt.num_vert/2.5)
		fixate = 0;
	else
		fixate = 1;
	end
end