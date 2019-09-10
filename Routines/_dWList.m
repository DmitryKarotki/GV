%dWList	;ListView  ;;[ Last editing 27 APR 2018 at 17:32:52 ]
	Q
Begin(par,kol,%i) ;
	N $es,$et S $et="G BegErr"
	S KOL=kol D Var(par)
	K %ss Q:'$D(GL) 1
	N J S r=$G(r,$C(250))
	S %kk=$G(%kk),%S=$G(%S),%usl=$G(%usl,"$$UppCase($G(@(GL_""(""_NS_"")"")))[$$UppCase(%S)"),%q=0
	I '$D(%pst) S SS=GL S:SS["(" SS=SS_")" Q:'$D(@SS) 2
	I $D(%k) S NS="" F  S NS=$O(%k(NS)) Q:NS=""  D
	.S:$$List^%dWFn(%k(NS),3)="" %k(NS)=$$List^%dWFn(%k(NS),1,2)_$$ListBd^%dWFn(-999999999)_$$List^%dWFn(%k(NS),4)
	.S:$$List^%dWFn(%k(NS),4)="" %k(NS)=$$List^%dWFn(%k(NS),1,3)_$$ListBd^%dWFn(""""_$$LastInd_"""")
	S %nns=$G(%nns,"S NS=$S(NS="""":GL,1:GL_""(""_NS_"")""),NS=$Q(@NS),NS=$P($E(NS,1,$L(NS)-1),""("",2,99)")
	;S %kns=$G(%kns,"S NS=$S(NS="""":GL_""("""""""")"",1:GL_""(""_NS_"")""),NS=$Q(@NS,-1),NS=$P($E(NS,1,$L(NS)-1),""("",2,99)")
	S %kns=$G(%kns,"S NS=$S(NS="""":GL,1:GL_""(""_NS_"")""),NS=$$QR^%dWFn(NS),NS=$P($E(NS,1,$L(NS)-1),""("",2,99)")
	S (%p1,%p2)="" I $D(%pp2) S NS=%pp2 X %kns X %nns S %p2=NS
	S NS=$G(%pp1) D nns I '$D(%pst) Q:NS="" 1
	S %p1=NS,NS=$G(%pp2)
	I NS'=""&(%p1'=NS) K S S @("S("_%p1_")")="",@("S("_NS_")")="" Q:$Q(@("S("_%p1_")"))="" 1
	D kns S %p2=NS
	I %p1'=%p2 K S S @("S("_%p1_")")="",@("S("_%p2_")")="" Q:$Q(@("S("_%p1_")"))="" 1
	K S S NS=%p1 X %kns D NNS
	S:J'>KOL KOL=J
	S %ci=$G(%ci) S:$TR(%ci," ")=""!(%p1=%p2) %ci=%p1
	I %ci'=%p1&(%ci'=%p2) K S S @("S("_%p1_")")="",@("S("_%ci_")")="",@("S("_%p2_")")="" S:$Q(@("S("_%p1_")"))=("S("_%p2_")") %ci=%p1 K S
	S %i=1,NS=%p1 X %kns D:%ci'=%p1
	.N z I %ci'=%p2 I $D(%Ici) S %i=%Ici K %Ici S:%i>KOL %i=KOL D  Q
	..N k,j S k=KOL,NS=%ci X %nns S KOL=%i D KNS S:J %i=%i-J+1 K z
	..D  S (J,KOL)=k-%i I KOL S NS=%ss($O(%ss(""),-1)) D NNS D
	...S j="" F  S j=$O(%ss(j)) Q:j=""  S z($O(z(""),-1)+1)=%ss(j)
	..K %ss I J<KOL S KOL=KOL-J,%i=%i+KOL,NS=z(1) D KNS
	..S j="" F  S j=$O(z(j)) Q:j=""  S %ss($O(%ss(""),-1)+1)=z(j)
	..S KOL=k
	.S NS=%ci D kns S z=NS D NNS
	.S NS=z I J'>KOL S NS=%p2 X %nns D  Q
	..K %ss F J=KOL:-1  Q:J<1  D kns S %ss(J)=NS S:NS=%ci %i=J Q:NS=%p1
	S kol=KOL Q 0
BegErr	;
	S $ec=""
	Q:$Q 3 Q
ci(i,%p) N NS S NS=$G(%ss(i))
	S %p=$S(NS=%p1&(NS=%p2):3,NS=%p2:2,NS=%p1:1,1:0) Q NS
gl(NS,i) S:$G(i)'="" NS=$G(%ss(i)) Q $G(@(GL_"("_NS_")"))
doLab(Lab,NS) D @Lab Q 0
Dn(i)	S NS=$G(%ss(i)) Q:NS=%p2 1
	F J=1:1:KOL-1 S %ss(J)=$G(%ss(J+1))
	S NS=$G(%ss(J)) D nns Q:NS="" 2 S %ss(KOL)=NS Q 0
Up(i)	S NS=$G(%ss(i)) Q:NS=%p1 1
	F J=KOL:-1:2 S %ss(J)=$G(%ss(J-1))
	S NS=$G(%ss(J)) D kns Q:NS="" 2 S %ss(1)=NS Q 0
End(i)	S NS=$G(%ss(i)) Q:NS=%p2 1
	S NS=%p2 X %nns D KNS Q $S(J'<1:2,1:0)
Home(i)	S NS=$G(%ss(i)) Q:NS=%p1 1
	S NS=%p1 X %kns D NNS Q $S(J'>KOL:2,1:0)
PgDn(i)	S NS=$G(%ss(i)) Q:NS=%p2 1
	D NNS I J'>KOL S NS=%p2 X %nns D KNS Q:J'<1 2
	Q 0
PgUp(i)	S NS=$G(%ss(i)) Q:NS=%p1 1
	D KNS I J'<1 S NS=%p1 X %kns D NNS Q:J'>KOL 2
	Q 0
NNS	K %ss F J=1:1  Q:J>KOL  D nns S %ss(J)=NS Q:NS=%p2!(NS="")
	Q
KNS	K %ss F J=KOL:-1  Q:J<1  D kns S %ss(J)=NS Q:NS=%p1!(NS="")
	Q
nns	N i
	X %nns Q:NS=%p2!(NS="")
	I %kk'="" S i=$QL(GL_"("_NS_")") I i'=%kk S:i>%kk NS=$$QS(NS,1,%kk)_","""_$$LastInd_"""" G nns+1
	S q=0,%1="" F  S %1=$O(%k(%1)) Q:%1=""  S q=$$cmpS(%1) Q:q
	I q S $P(NS,",",%1)=$$List^%dWFn(%k(%1),q),q=0 D  Q:q  G nns+1
	.F  S %1=$O(%k(%1)) Q:%1=""  S $P(NS,",",%1)=$$List^%dWFn(%k(%1),4)
	.Q:%p2=""  K S S @("S("_NS_")")="",@("S("_%p2_")")=""
	.S:$Q(@("S("_NS_")"))="" q=1,NS=%p2 K S Q
	D:$D(%uslo) @%uslo I @%usl Q
	G nns+1
kns	N i
	X %kns Q:NS=%p1!(NS="")
	I %kk'="" S i=$QL(GL_"("_NS_")") I i'=%kk S:i>%kk NS=$$QS(NS,1,%kk)_",-999999999" G kns+1
	S q=0,%1="" F  S %1=$O(%k(%1)) Q:%1=""  S q=$$cmpS(%1) Q:q
	I q S $P(NS,",",%1)=$$List^%dWFn(%k(%1),q+10#4),q=0 D  Q:q  G kns+1
	.N S F  S %1=$O(%k(%1)) Q:%1=""  S $P(NS,",",%1)=$$List^%dWFn(%k(%1),3)
	.Q:%p1=""  K S S @("S("_NS_")")="",@("S("_%p1_")")=""
	.S:$Q(@("S("_%p1_")"))="" q=1,NS=%p1 K S Q
	D:$D(%uslo) @%uslo I @%usl Q
	G kns+1
cmpS(%1) N S S %2=$$List^%dWFn(%k(%1),1),%3=$$List^%dWFn(%k(%1),2),%4=$P(NS,",",%1)
	K S S @("S("_%2_")")="",@("S("_%3_")")="",@("S("_%4_")")=""
	I %4'=%3 I $Q(@("S("_%2_")"))=("S("_%4_")") K S Q 0
	S q=$S($Q(@("S("_%4_")"))="":4,1:1) K S Q q
Var(par) ;
	N p1,p2,p3 S p1=$E(par,1),par=$E(par,2,$L(par))
	S p2=$L(par,p1) F p2=1:2:p2 S p3=$P(par,p1,p2) S:p3'="" @p3=$P(par,p1,p2+1)
	Q
LastInd() Q $TR($J("",3)," ",$S($ZCH="M":$C(255),1:$C(1114109)))
UppCase(s) ;UpperCase
	Q $ZCO(s,"U")
QS(S,I,J) Q $$QS^%dWFn(S,$G(I),$G(J))
