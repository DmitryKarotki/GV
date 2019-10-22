%dWFn	;Functions  ;;[ Last editing 27 APR 2018 at 17:46:28 ]
	Q
ListBd(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10) ;$$ListBuild()
	N p,j F j=1:1:10 Q:'$D(@("p"_j))  S p(j)=@("p"_j)
	Q $$ListB(.p)
ListB(p) ;$$ListBuild()
	N S,i,j,l S S="",i=$O(p(""),-1) Q:i="" $C(1)
	F j=1:1:i D
	.I '$D(p(j)) S S=S_$C(1) Q
	.S l=$L(p(j)) I l<254 S l=l+2,S=S_$C(l)_$C(1)_p(j) Q
	.S l=l+1,S=S_$C(0)_$C(l#256)_$C(l\256)_$C(1)_p(j) Q
	Q S
List(S,i1,i2) ;$$List()
	N i,j,j1,l S j=1 F i=1:1:$S($G(i2):i2,1:i1) D
	.S:i=i1 j1=j D
	..S l=$A($E(S,j)) I l S j=j+l Q
	..S j=j+1,l=$A($E(S,j+1))*256+$A($E(S,j)),j=j+l+2
	S S=$E(S,j1,j-1) S:'$D(i2) l=$A($E(S,1)),l=('l)*2+3,S=$E(S,l,$L(S))
	Q S
QS(S,I,J) ;$QSUBSCRIPT
	N i,j,p,ps,p1 S J=$G(J,I) S:J<I J=I
	;S:$E(S,$L(S))=")" S=$P($E(S,1,$L(S)-1),"(",2,99)
	;With $C(),$ZCH()
	I $E(S,$L(S))=")" S:$P(S,"(",1)'["$" S=$P($E(S,1,$L(S)-1),"(",2,99)
	S p=1,p1=0 F i=1:1:J D  Q:'p
	.I $E(S,p)'=""""&($E(S,p)'="$") S ps=",",p=$F(S,ps,p)
	.E  I $E(S,p)="$" S ps="),",p=$F(S,ps,p)
	.E  S ps="""," F  S p=$F(S,ps,p) Q:$E(S,p-3)'=""""  S j=p-3 D  Q:(p-2-j#2)  Q:'p
	..F j=j+1:-1:1 Q:$E(S,j)'=""""
	..S:$E(S,j)="""" j=j-1
	.Q:'p  S:i=(I-1) p1=p
	Q:i<I&(i<J) ""
	S p=$S('p:$L(S),1:p-2) Q $E(S,p1,p)
Param(p0) ;Parameter with variables
	N p1,p2,p3 D:$G(p0)'=""  Q 0
	.S p3=$E(p0,1),p0=$E(p0,2,$L(p0))
	.S p1=$L(p0,p3) F p1=1:2:p1 S p2=$P(p0,p3,p1) S:p2'="" @p2=$P(p0,p3,p1+1)
Var()	;Variable list
	N NS,S S (S,NS)=""
	F  S NS=$O(Var(NS)) Q:NS=""  S S=S_$$ListBd(NS,Var(NS))
	Q S
Do(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10) ;
	Q:$G(p0)="" ""
	N %1,%2,%3 X "S %1=$T("_p0_")" Q:%1="" ""
	S %1=$P(%1," ",1),%1=$P($P(%1,"(",2),")",1),%3=$L(%1,",")
	S:$TR(%1," ")="" %3=0 S %2=1 F  Q:'$D(@("p"_%2))  S %2=%2+1 Q:%2>10
	S %2=%2-1 S:%3<%2 %2=%3
	S %1="S %1=$$"_p0_"(" F %3=1:1:%2 S %1=%1_".p"_%3_$S(%3'=%2:",",1:"")
	S %1=%1_")" X %1 Q %1
Func(p0,p1) ;
	N p3 S p3=$TR($P(p1,"(",1),"$") X "S p3=$T("_p3_"^"_p0_")" Q:p3="" ""
	I $E(p1,1,2)="$$" S p3="S p3="_$P(p1,"(",1)_"^"_p0_"("_$P(p1,"(",2) X p3
	E  D @($TR($P(p1,"(",1),"$")_"^"_p0_"("_$P(p1,"(",2)) S p3=""
	Q p3
	;
QR(g)	;$Query(g,-1)
	Q:g="" ""
	N i,j,S S i=$QL(g) Q:'i $$LastCh(g)
	S S=g,g=$QS(g,0) F j=1:1:i-1 S g=$NA(@g@($QS(S,j)))
	S j=$O(@g@($QS(S,i)),-1)
	I j'="" S g=$NA(@g@(j)) Q $S($D(@g)'>1:g,1:$$LastCh(g))
	Q:i=1 "" Q $S($D(@g)#10:g,1:$$QR(g))
LastCh(g) ;
	Q:g="" ""
	N i F  S i=$O(@g@(""),-1) Q:i=""  S g=$NA(@g@(i))
	Q g
UppCase(s) ;UpperCase
	Q $ZCO(s,"U")
Replace(str,from,to) ;
	N i S i=1
	F  S i=$F(str,from,i) Q:i=0  S $E(str,i-$L(from),i-1)=to,i=i-$L(from)+$L(to)
	Q str
Format(str,s1,s2,s3,s4,s5) ;
	N i F i=1:1:5 Q:'$D(@("s"_i))  S str=$$Replace(str,"%s"_i,@("s"_i))
	Q str
ListBW(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10) ;
	N str,s,i,c,num S str=""
	F i=1:1:10 Q:'$D(@("s"_i))  S s=@("s"_i) D
	.S num=0 D:$L(s)>0
	..I $L(s)=1 S num=(s?1N) Q
	..S num=($E(s,1)'=0&(s?.1"-".N.1".".N))
	.I $E(s,1)'="[" F c="\","""" S s=$$Replace(s,c,"\"_c)
	.S str=str_$S(str'="":",",1:"")_$S('num&($E(s,1)'="["):""""_s_"""",1:s)
	Q "["_str_"]"
Utf8(str)	;Is it UTF-8?
	; 0-127
	; 192-223 128-191
	; 224-239 128-191 128-191
	; 240-247 128-191 128-191 128-191
	N res,i,j,k,L,c S L=$L(str),res=1,i=0 F  D  Q:'res!(i>L)
	.S i=i+1 Q:i>L
	.S c=$A($E(str,i)) Q:c<128  I c<192!(c>247) S res=0 Q
	.S k=$S(c<224:1,c<240:2,1:3) F j=1:1:k D  Q:'res 
	..S i=i+1 I i>L S res=0 Q
	..S c=$A($E(str,i)) I c<128!(c>191) S res=0 Q
	Q res
EnUtf(c)	;Encode UTF8
	N s,b1,b2,b3 S c=$$FUNC^%HD(c),s="" D  Q s
	.I c<128 S s=$C(c) Q
	.I c<2048 S b1=c#64,b2=(c-b1)/64,s=$C(192+b2,128+b1) Q
	.I c<65536 S b1=c#64,b2=((c-b1)/64)#64,b3=(c-b1-(64*b2))/4096,s=$C(224+b3,128+b2,128+b1) Q
SetUtf(g,s)	;
	N c,i,j,n,u S c=$E(s,1),i=2,n=127
	;F  S j=i,i=$F(s,c,i) S:'i i=$L(s)+2  S n=n+1,u=$E(s,j,i-2) S:u'="" @g@(n)=$$EnUtf(u) Q:i>$L(s)
	F  S j=i,i=$F(s,c,i) S:'i i=$L(s)+2  S n=n+1,u=$E(s,j,i-2) S:u'="" u=$$EnUtf(u),@g@(n)=u,@g@(0,u)=n Q:i>$L(s)
	Q ""	
Ansi2Utf(S,charset)	;
	N i,j,c,s S s="",j=0 F i=1:1:$L(S) S c=$A($E(S,i)) S:'j&(c'>127) j=i D:c>127
	.S:j&(j<i) s=s_$E(S,j,i-1),j=0 S c=$G(@charset@(c)) S:c="" c="?" S s=s_c  
	S:j s=s_$E(S,j,i) Q s
Utf2Ansi(S,charset)	;
	N i,j,c,s,b,l
	S s="",j=0 F i=1:1:$L(S) S c=$A($E(S,i)),b=c>191&(c<247) S:'j&'b j=i D:b
	.S:j&(j<i) s=s_$E(S,j,i-1),j=0 S l=$S(c<224:1,c<240:2,1:3),i=i+l,c=$C(c)_$E(S,i-l+1,i)
	.S c=$G(@charset@(c)) I c S s=s_$C(c) Q
	.S j=i-l  
	S:j s=s_$E(S,j,i) Q s
	Q s
	;