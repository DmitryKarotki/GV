%dWebSock	;WebSocketd  ;;[ Last editing 05 MAY 2019 at 17:02:59 ]
	Q
ZLC(n)	Q $C(n\95#95+32,n#95+32)
ZLA(s)	Q $A(s)-32*95+$A(s,2)-32
Start	 ;
	I $ZCH'="M" VIEW "NOBADCHAR"
	Set logout=0
	S Charset=""
	N $es,$et s $et="g:'$es terr"
tnxt	For  Do:$$twaitsin(10)  Quit:$G(logout)
	.;; read header
	.If $$tread(.s,2,5) Do  Quit
	..Set res=$$tread(.s,$$ZLA(s),5)
	..D Do(s)
	Quit
terr	;
	;S ^wsError($H,$J)=$ZS
	S $ec=""
	Goto tnxt
tread(str,len,tout) ;
	Set len=$Get(len,0),tout=$Get(tout,1)
	If (len=0) Quit 1
	Read str#len:tout
	Quit $T&($L(str)=len)
twaitsin(tout) ;twaitsinh
	New i,a,t1,zh
	Set i=0,tout=$Get(tout,5),t1=$P($H,",",2)
	Set (zh,t1)=$P($H,",",2)
	For  Do   Quit:(i=4)!logout!((tout>0)&(zh-t1>tout))
	 .I $ZEO S logout=1 Q
	 .Read *a:1 I $ZB=-9 S logout=1 Q  ;The operating system socket operation failed
	 .Set zh=$P($H,",",2) S:zh<t1 zh=zh+86400
	 .If (a>0) Set i=$S(a=126:i+1,1:0)
	If 'logout Goto:i>0&(i<4) twaitsin+2
	Quit (i=4)
Do(S)	;
	New logout
	S S=$$Replace(S,"\""",""""""),S=$$Replace(S,"\\","\")
	S S=$E(S,2,$L(S)-1),s=$P(S,",",1) S:s'["^" $P(S,",",1)=""""_$TR(s,"""")_"^%dWebSock"""
	X "S S=$$Do^%dWFn("_S_")"
	W S,! Q
	;
Replace(str,from,to) ;
	N i S i=1
	F  S i=$F(str,from,i) Q:i=0  S $E(str,i-$L(from),i-1)=to,i=i-$L(from)+$L(to)
	Q str
Format(str,s1,s2,s3,s4,s5) ;
	N i F i=1:1:5 Q:'$D(@("s"_i))  S str=$$Replace(str,"%s"_i,@("s"_i))
	Q str
Reply(fn,arg)	;
	Q $$Format("{""fn"":""%s1"",""arg"":%s2}",fn,arg)	
Conv(S) ;
	I Charset'="UTF-8"&(Charset'="") S S=$$Ansi2Utf^%dWFn(S,$NA(Charset(Charset)))
	E  I $ZCH="M" D:'$$Utf8^%dWFn(S)
	.N i F i=1:1:$L(S) S:$A($E(S,i))>127 $E(S,i)="?"
	Q $$Conv^%dWTree(S)
Begin()	;
	N s,Charset S s=$$Begin^%dWTree()
	S %conv="Conv^%dWebSock"
	Q $$Reply("Begin",s)
Charset(name,s)	;
	N g S g=$NA(Charset(name)) S:'$D(@g) s=$$SetUtf^%dWFn(g,s) 
	S Charset=name 
	Q $$Screen($O(%ss(""),-1))
New(g) ;
	I g'["(" I '$D(@g) S GL="" Q $$Reply("New",$$ListBW^%dWFn(0))
	Q $$Reply("New",$$ListBW^%dWFn($$New^%dWTree(g)))
Resize(kol,i)	;
	Q $$Reload($C(250)_"%ci"_$C(250)_$$ci^%dWList(i),kol,i)
Reload(par,kol,i)	;
	N res S res=$$Begin^%dWList(par,.kol,.i)
	Q $$Reply("Reload",$$ListBW^%dWFn(res,kol,i))
Screen(I,p)	;	
	N s S s=$$Ekr^%dWTree(I,.p)
	Q $$Reply("Screen",$$ListBW^%dWFn("["_s_"]",p))
Click(kol,i)	;
	N ns Q:$$Click^%dWTree(i,.ns) ""
	Q $$Reload($C(250)_"%ci"_$C(250)_ns,kol,i)
DClick(i,l)	;DoubleClick
	N ns Q:$$DClick^%dWTree(i,l,.ns) ""
	N par,kol S par=$C(250)_"%ci"_$C(250)_ns,kol=$O(%ss(""),-1)
	Q $$Reload(par,kol,i)
Left(i,l)	;
	N ns S ns=$G(%ss(i)),ns=$$QS^%dWTree(ns,1,l-1)
	Q:$$GoTo^%dWTree(ns) ""
	N par,kol S par=$C(250)_"%ci"_$C(250)_ns,kol=$O(%ss(""),-1)
	for i=1:1:kol I ns=$G(%ss(i)) S %Ici=i Q
	Q $$Reload(par,kol,i)
GoTo(g,kol)	;
	;I $ZCH="M" I Charset'="UTF-8"&(Charset'="") S g=$$Utf2Ansi(g)
	N G,ns,i S G=$P(g,"(",1) Q:G="" "" S:$E(G,1)'="^" G="^"_G
	I G'=$G(GL) Q:'$$New^%dWTree(G) "" 
	S ns=$P(g,"(",2,99) S:$E(ns,$L(ns))=")" ns=$E(ns,1,$L(ns)-1)
	I ns'="" Q:$$GoTo^%dWTree(ns) ""
	S i=1 Q:$$Begin^%dWList($C(250)_"%ci"_$C(250)_ns,.kol,.i) ""
	Q $$Reply("GoTo",$$ListBW^%dWFn(GL,kol,i))
CtrlRight(i)	;
	N ns S ns=$$CRClick^%dWTree(i)
	Q:ns="" ""
	S ns=$P($E(ns,1,$L(ns)-1),"(",2,99)
	Q:$$GoTo^%dWTree(ns) ""
	N par,kol S par=$C(250)_"%ci"_$C(250)_ns,kol=$O(%ss(""),-1)
	for i=1:1:kol I ns=$G(%ss(i)) S %Ici=i Q
	Q $$Reload(par,kol,i)
Key(k,i)	;
	N res,kol S res=1,kol=$O(%ss(""),-1) D
	.I k="ArrowUp" S res=$$Up^%dWList(i) Q
	.I k="ArrowDown" S res=$$Dn^%dWList(i) Q
	.I k="PageUp" S res=$$PgUp^%dWList(i) Q
	.I k="PageDown" S res=$$PgDn^%dWList(i) Q
	.I k="Home" S res=$$Home^%dWList(i) Q
	.I k="End" S res=$$End^%dWList(i) Q
	Q $S('res:$$Screen(kol),res=2:$$Reload($C(250)_"%ci"_$C(250)_$$ci^%dWList(i),kol,i),1:"")
Download(i)	;
	Q:GL="" $$Reply("Download",$$ListBW^%dWFn(""))
	N file S file="global.txt"
	o file:(newversion:block=2048:record=2044:exception=""):0
	Q:'$t $$Reply("Download",$$ListBW^%dWFn(""))
	u file D Write^%dWTree(i)
	c file u $p:(ctrap="":exc="")
	Q $$Reply("Download",$$ListBW^%dWFn(file))
	;