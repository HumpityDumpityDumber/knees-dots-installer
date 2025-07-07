#!/usr/bin/env fish

# Buffer the last WorkspacesChanged payload for lookup
set last_workspaces_json ""

niri msg --json event-stream | while read -l line
    # Save WorkspacesChanged for later lookup
    if string match -q '*"WorkspacesChanged"*' -- $line
        set last_workspaces_json $line
        continue
    end

    # Detect a newly activated workspace
    if string match -q '*"WorkspaceActivated"*' -- $line
        # Get the workspace ID
        set active_id (echo $line | jq -r '.WorkspaceActivated.id')

        # Look up the corresponding output (monitor) from saved workspace state
        set output (echo $last_workspaces_json | jq -r --arg id "$active_id" '
            .WorkspacesChanged.workspaces[] | select(.id == ($id | tonumber)) | .output
        ')

        if test -n "$output"
            echo "Switching dynamic cast target to: $output"
            niri msg action set-dynamic-cast-monitor "$output"
        end
    end
end
