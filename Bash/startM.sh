#!/bin/bash
gtm_dist=/usr/lib/x86_64-linux-gnu/fis-gtm/V6.2-002A-2build1_x86_64; export gtm_dist
gtmgbldir=/home/dim/.fis-gtm/V6.2-002A_x86_64/g/gtm.gld; export gtmgbldir
gtmroutines=$gtm_dist; export gtmroutines
gtmdir=/home/dim/.fis-gtm; export gtmdir
gtmver=`$gtm_dist/mumps -run %XCMD 'Write $Piece($ZVersion," ",2),"_",$Piece($ZVersion," ",4)'` ; export gtmver

# UTF-8 mode
#gtm_chset="UTF-8"; export gtm_chset
#LC_CTYPE="en_US.utf8"; export LC_CTYPE
#gtm_icu_version=5.5; export gtm_icu_version
#gtmroutines=$gtm_dist/utf8; export gtmroutines

$gtm_dist/mumps -run Start^%dWebSock
