# Global Viewer for GT.M/YottaDB

 An example of how GT.M/YottaDB databases works with websocketd.

## Preparing and launch

 1. Download from http://websocketd.com a binary file for your system

 2. Import routines(the Routines folder) in GT.M/YottaDB

 3. Create a bash file startM.sh:
```
     #!/bin/bash
     gtm_dist= ...
     ...
     $gtm_dist/mumps -run Start^%dWebSock
```
 4. Place this files in one folder:

     websocketd, startM.sh and all files/folders from WebApp

 5. Start the server:

    ./websocketd --port=8080 --staticdir=. ./startM.sh

 6. Open in browser http://gtm_host:8080

## Usage

 Global variables are displayed as a tree in the browser.
 Navigation is done using the mouse and keyboard as in the standard TreeView component in Windows.

 There are some differences/additions: 
 
 1. Ctrl+Right - get on the last node of this level. 

 2. DoubleClick on text - copy global link to text field (Globals > Go). 

 3. MouseDown on the first and last selected line - scroll up/down. 

 4. MouseDown+MouseMove - scroll up/down.

