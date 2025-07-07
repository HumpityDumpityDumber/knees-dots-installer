#!/usr/bin/env fish

# Set output directory
set outdir ~/Pictures/Screenshots
mkdir -p $outdir

# Generate timestamped filename
set filename (date "+%Y-%m-%d_%H-%M-%S.png")
set filepath "$outdir/$filename"

grim -g (slurp) - | tee $filepath | swappy -f -

