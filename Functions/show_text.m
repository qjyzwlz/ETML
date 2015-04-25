%% FXN_show_text
function key_summary = show_text(wind, trial_config, stim_position, key_summary)

if nargin < 3
    stim_position = '';
end

if nargin < 4
    key_summary = [];
end

while KbCheck; end;

% What text to display?
the_text = get_trial_config(trial_config, [stim_position 'Stim'] );

% How long?
[duration, min_duration] = set_duration(trial_config, stim_position);

% Draw:
DrawFormattedText(wind, the_text, 'center', 'center');
Screen('Flip', wind);
text_start = GetSecs();

% Wait For KeyPress:
key_code = check_keypress();
while 1
    [key_code, key_summary] = check_keypress(key_code, key_summary);
    
    if GetSecs() - text_start >= duration
        break % end
    end
    
    if any(key_code)
        if GetSecs() - text_start >= min_duration
            break % end
        end
    end
end

[~, key_summary] = check_keypress(key_code, key_summary, 'flush');

return

%
    function [duration, min_duration] = set_duration(trial_config, stim_position)
        
        dur_field = get_trial_config(trial_config, [stim_position 'StimDuration']);
        dur_config = eval_field(dur_field);
        
        if length(dur_config) > 1
            duration = dur_config(2);
            min_duration = dur_config(1);
        else
            if isempty(dur_config) || dur_config == 0
                duration = Inf;
                min_duration = 0;
            else
                duration = dur_config;
                min_duration = duration;
            end
        end
        
    end

end
