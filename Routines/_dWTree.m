%dWTree	;TreeView  ;;[ Last editing 22 MAY 2019 at 15:09:44 ]
	Q
Begin()	;
	K  S r=$C(250),%dm="^%dWList",%usl="1"
	S %nns="D nns^%dWTree",%kns="D kns^%dWTree"
	S %LV=500,%conv=""
	;Q $$ListBd^%dWFn($$GD,$$UCI,$ZV)
	Q $$ListBW^%dWFn($$GD,$ZV_" ( "_$ZCH_" )",($ZCH'="M"))
GD()	;Global directory
	N GN,S S GN="^%",S="" F  S GN=$O(@GN) Q:GN=""  S S=S_GN
	Q S
UCI()	;UCI
	N i,j,z,S S S="",i=$S($ZV["MSM-Workstation":1,1:0) F i=i:1:7 D
	.F j=1:1:30 S z=$ZU(j,i) Q:z=""  S S=S_z_"^"
	Q S
UChange(UCI) ;UCI change
	S UCI=$ZU($P(UCI,","),$P(UCI,",",2))
	V 0:$J:$ZB($V(0,$J,2),1,7):2,2:$J:$P(UCI,",",2)*32+UCI:2
	Q $$GD
New(S)	;
	N i K %pp1,%pp2,%kk,%k,%ci,%Ici,%kkk,%www,%ww
	;S $ZT="NewErr"
	N $es,$et s $et="g:'$es NewErr"
	S GL=$P(S,"(",1),S=$P(S,"(",2,99)
	S i=$E(S,$L(S)),S=$S(i=")"!(i=","):$E(S,1,$L(S)-1),1:S),i=1 D:S'=""  Q i
	.N NS,%s,j S i=$QL("%ww("_S_")")
	.I i>1 F j=1:1:(i-1) S %s=$$QS(S,1,j) S:%s'="" @("%ww("_%s_")")=""
	.S NS=S D kns
	.S %pp1=NS,NS=S_","""_$$LastInd_"""" D nns S %pp2=NS
NewErr	S $ec="" Q 0
nns	N ns,i S ns=NS,NS=$S(NS="":GL,1:GL_"("_NS_")"),NS=$Q(@NS)
	S i=0 S:NS'="" i=$QL(NS)-1
	S NS=$P($E(NS,1,$L(NS)-1),"(",2,99),%kk=""
	F i=1:1:i I $$QS(ns,i)'=$$QS(NS,i) S NS=$$QS(NS,1,i) Q
	I NS'=""&'$D(%kkk) F i=1:1:$QL(GL_"("_NS_")") I '($D(@("%ww("_$$QS(NS,1,i)_")"))#10) S %kk=i Q
	Q
kns	;N ns,i S ns=NS,NS=$S(NS="":GL_"("""")",1:GL_"("_NS_")"),NS=$Q(@NS,-1)
	N ns,i S ns=NS,NS=$S(NS="":GL_"("""")",1:GL_"("_NS_")"),NS=$$QR^%dWFn(NS)
	S i=0 S:ns'="" i=$QL(GL_"("_ns_")")-1
	S NS=$P($E(NS,1,$L(NS)-1),"(",2,99),%kk=""
	F i=i:-1:1 I $$QS(ns,1,i)'=$$QS(NS,1,i) S NS=$$QS(ns,1,i) Q
	I NS'=""&'$D(%kkk) F i=1:1:$QL(GL_"("_NS_")") I '($D(@("%ww("_$$QS(NS,1,i)_")"))#10) S %kk=i Q
	Q
Ekr(I,%p) ;
	N i,j,l,Z,NS,S,p,g,s S %p=0,S="" F j=1:1:I D
	.S r=$C(250),NS=$G(%ss(j)),g=GL_"("_NS_")",l=$QL(g),Z=$G(@g)
	.S:$G(%LV)'="" Z=$E(Z,1,%LV)_$S(%LV<$L(Z):" ...",1:"")
	.S %p=%p+$S(NS=%p1&(NS=%p2):3,NS=%p2:2,NS=%p1:1,1:0)
	.S i=2 D
	..N ns,J S J=$G(@("%ww("_NS_")")) I J=2 S i=0 Q
	..I NS=%p1&(NS=%p2) S i=0 Q
	..I NS=%p2 S i=4 Q
	..I NS=%p1 S i=3 Q
	..I J=1 S i=4 Q
	..I j<I S ns=NS,NS=$G(%ss(j+1))
	..E  S ns=NS D @("nns"_%dm)
	..S:l>$QL(GL_"("_NS_")") i=4 S NS=ns
	.D:l>1
	..N i,%s S %s="" F i=1:1:l-1  S:$G(@("%ww("_$$QS(NS,1,i)_")")) $E(%s,i)=1
	..S:%s'="" l=l_"."_%s
	.S s=$$ListBW^%dWFn($D(@g),(l\1),($D(@("%ww("_NS_")"))#10),i)
	.S:%conv'="" NS=$$Do^%dWFn(%conv,NS),Z=$$Do^%dWFn(%conv,Z)
	.S S=S_$S(S'="":",",1:"")_$$ListBW^%dWFn(NS,Z,s)
	Q S
Value(I) ;
	N NS,S I I=0 S S=$G(@GL) Q $$Conv(S)
	S NS=$G(%ss(I)),S="" S:NS'="" S=$G(@(GL_"("_NS_")")) Q $$Conv(S)
Conv(S)	;
	N %S,s,i,j,err S err=0,%S="" F i=1:1:$L(S) D
	.S s=$E(S,i),j=$A(s) I j<32 S err=1,s=j D  Q
	..F i=i+1:1:$L(S) S j=$A($E(S,i)) D  Q:j'<32
	...I j'<32 S i=i-1 Q
	...S s=s_","_j
	..S %S=%S_$S(%S'="":"""_",1:"")_"$C("_s_")"_$S(i<$L(S):"_""",1:"")
	.S %S=%S_s_$S(s="""":"""",1:"")
	Q:'err S  S j=$A($E(S,1)),i=$A($E(S,$L(S)))
	S %S=$S(j'<32:"""",1:"")_%S_$S(i'<32:"""",1:"") Q %S
CRClick(I) ;Ctrl+Right
	N ns,l S (ns,NS)=$G(%ss(I)),l=$QL(GL_"("_NS_")")
	S NS=$$QS(NS,0,l-1) S:NS'="" NS=NS_","""_$$LastInd_""""
	D @("kns"_%dm) S NS=$$QS(NS,1,l)
	Q:ns'=NS GL_"("_NS_")" Q ""
Click(I,NS) ;
	N i,j,g S NS=$G(%ss(I)),%Ici=I
Clck	S g=GL_"("_NS_")" Q:$D(@g)'>1 1
	S g="%ww("_NS_")" I $D(@g)#10 D ZKill(g)
	E  D Setww(NS)
	Q 0
ZKill(g) N tmp,j S j="" F  S j=$O(@g@(j)) Q:j=""  M tmp(j)=@g@(j)
	K @g M @g=tmp Q
Setww(NS) ;
	N g,i S g="%ww("_NS_")" S i="" D  S @g=i
	.N l S l=$QL(g) I NS=$G(%p2) S i=1 S:NS=$G(%p1) i=2 Q
	.D
	..N %kk,ns S %kk=l
	..S ns=NS D @("nns"_%dm) S:$$QS(ns,l-1)'=$$QS(NS,l-1) i=1 S NS=ns
	Q
DClick(I,J,NS) ;
	N i,j,g S NS=$G(%ss(I)),NS=$$QS(NS,1,J),%Ici=I D  ;G Clck
	.F i=I-1:-1:1 I $G(%ss(i))=NS S %Ici=i Q
	S g=GL_"("_NS_")" Q:$D(@g)'>1 1
	S g="%ww("_NS_")" I $D(@g)#10 D ZKill(g)
	E  D Setww(NS)
	Q 0
Find(S,I,r,d,b) ;if r=1 - case sensitive; if d=0 - search direction = Up
	N i,%S,err,nn,pp,NS,%kkk S NS=$G(%ss(I)),%kkk=""
	I d S nn="nns" D
	.D  I b S:NS=%p1 NS="" D:NS'="" kns
	..N NS S NS=$G(%pp2) D @("kns"_%dm) S pp=NS
	E  S nn="kns",pp=%p1 D
	.I b S:NS=%p2 NS="" D:NS'="" nns
	S err=0 F  D @(nn_%dm) Q:NS=""  D  Q:err!(NS=pp)
	.S %S=GL_"("_NS_")",%S=%S_$G(@%S)
	.S:'r %S=$TR(%S,rl,ru),S=$TR(S,rl,ru)
	.S:%S[S err=1
	Q:'err 1  K %kkk S i=$$GoTo(NS) Q "0^"_NS
GoTo(NS) ;Expand Link
	;S $ZT="GoToErr"
	N $es,$et S $et="G GoToErr"
	N i,%S S i=$QL("%ww("_NS_")") D:i>1  Q 0
	.F i=1:1:(i-1) S %S=$$QS(NS,1,i) I %S'="" D:'$D(@("%ww("_%S_")")) Setww(%S)
GoToErr	S $ec="" Q 1
Delete(g,I) ;
	N i S:g["("&(g'[")") g=g_")"
	S i=$S($D(@g):0,1:1) D  K @g S g=$P(g,"(",1) S:'i&($D(@g)<10) i=3 ;Q i
	.N NS I $G(I)'="" S NS=$G(%ss(I)),%Ici=I D nns,kns S %ci=NS
	Q i
Set(g,S,W) ;
	N $es,$et S $et="G SetErr"
	N i,j,G S W=$G(W) S:g["("&(g'[")") g=g_")"
	S G=$P(g,"(",1),j=$D(@G) I W=""&(S["_") S i=1 D  Q:i 4
	.N j,%s,ost S ost="" F j=1:1:$L(S,"_") S %s=$P(S,"_",j) D  Q:'i
	..S %s=ost_%s I '($L(%s,"""")#2) S ost=%s Q
	..Q:$E(%s,1)=""""&($E(%s,$L(%s))="""")
	..Q:$E(%s,1,3)="$C("&($E(%s,$L(%s))=")")
	..Q:%s&((+%s_"")=(%s_""))
	..S i=0
	S i=$S($D(@g):0,1:1) D
	.I W'="X" S @g=S Q
	.X "S @g="_S
	S:(j<10)&($D(@G)'<10) i=3 Q i
SetErr	S $ec="" Q 2
Copy(G,g) ;
	N i,NS S $ZT="CopyErr",i=0
	S:G?.N NS=$G(%ss(G)),G=GL_"("_NS_")" I G'=g I $D(@g) M @G=@g S i=1
	Q i
CopyErr	Q 3_"^"_$ZE
Write(i)	;
	N NS,ci,nn,%kkk,end,g
	S (ci,NS)=$G(%ss(i)),nn=$S(ci'="":$QL(GL_"("_ci_")"),1:0)
	I 'nn W:($D(@GL)#10) GL_"="_$$Do^%dWFn(%conv,@GL),!
	S %kkk="" D:NS'="" kns S end=0 F  D  Q:end
	.D @("nns"_%dm) I NS=""!(ci'=""&($$QS(NS,1,nn)'=ci)) S end=1 Q
	.S g=GL_"("_NS_")" Q:'($D(@g)#10)
	.W GL_"("_$$Do^%dWFn(%conv,NS)_")="_$$Do^%dWFn(%conv,@g),!
	Q
LastInd() Q $$LastInd^%dWList
QS(S,I,J) Q $$QS^%dWFn(S,$G(I),$G(J))
	;
