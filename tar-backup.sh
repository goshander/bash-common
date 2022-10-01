#!/bin/bash

tar --exclude='**/node_modules/*' --exclude='**/.git/*' --exclude='**/.cache/*' -cvzf backup_$(date '+%Y%m%d_%H%M%S').tar.gz * 
