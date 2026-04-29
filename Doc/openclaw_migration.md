stop OpenClaw first: 
systemctl --user stop openclaw-gateway.service
 then
hermes claw cleanup

✓ Archived: /home/matt/.openclaw → /home/matt/.openclaw.pre-migration

Disable openClaw service so it will not recreate  work/momory structure again
systemctl --user disable openclaw-gateway.service && systemctl --user list-unit-files | grep openclaw

After you run Hermes you can ask him to read/import (some or all) your archived OpenClaw files/worspace/memory.
I did not migrate settings (api keys, tools, sould.md etc), many of them are not compatible. I asked Hermes just to import  some of my stored md files (mostly articles and links to articles).