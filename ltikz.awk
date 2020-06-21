BEGIN {print "\\begin{circuitikz}"}
$1=="WIRE" {
	printf("	\\draw (%f, %f) to (%f, %f); 	%% %s\n", $4/60, -$5/60, $2/60, -$3/60, $0)
}
$1=="SYMBOL" {
	do {
		rep=0;
		switch($2) {
	case "res2": 	case "res": 	node=0; h=1; v=1; len=5; sym="to[R"; break;
			case "ind": 	node=0; h=1; v=1; len=5; sym="to[L"; break;
			case "cap": 	node=0; h=1; v=0; len=4; sym="to[C"; break;
			case "voltage": node=0; h=0; v=1; len=5; sym="to[american voltage source"; break;
			case "current": node=0; h=0; v=0; len=5; sym="to[american current source"; break;
			case "diode": 	node=0; h=1; v=0; len=4; sym="to[diode"; break;
			case "zener": 	node=0; h=1; v=0; len=4; sym="to[zzDo"; break;
			case "LED": 	node=0; h=1; v=0; len=4; sym="to[empty led"; break;

			case "npn": 	node=1; h=4; v=3; sym="node[npn, scale=1.25"; break;
			case "nmos": 	node=1; h=3; v=3; sym="node[nigfete, scale=1.97"; break;
		}
		mirror=0;
		switch($NF) {
			case "M0": 
			mirror=1;
			h*=-1;
			case "R0": 
			x_beg=x_end=($3+h*16)/60; 
			y_beg=(-$4-v*16)/60; 
			y_end=y_beg-len*16/60; break;

			case "M90": 
			mirror=1;
			h*=-1;
			case "R90": 
			x_beg=($3-v*16)/60; 
			x_end=x_beg-len*16/60;
			y_beg=y_end=(-$4-h*16)/60; break;

			case "M180": 
			mirror=1;
			h*=-1;
			case "R180": 
			x_beg=x_end=($3-h*16)/60; 
			y_beg=(-$4+v*16)/60; 
			y_end=y_beg+len*16/60; break;

			case "M270": 
			mirror=1;
			h*=-1;
			case "R270": 
			x_beg=($3+v*16)/60; 
			x_end=x_beg+len*16/60;
			y_beg=y_end=(-$4+h*16)/60; break;
		}
		getline
		while($1 != "SYMATTR" || $2 != "InstName") getline;

		printf("\\draw (%f, %f) %s", x_beg, y_beg, sym)
		if(!node) printf(", l_=$%s$", $3);
		if(mirror == 1) printf(", mirror");
		getline; 
		if($1=="SYMATTR" && $2=="Value") printf(", a^=$%s$", $3);
		else if($1=="SYMBOL") rep=1;
		if(!node) printf("] (%f, %f); \n", x_end, y_end)
		else printf("] {}; \n");
	} while(rep)
}
$1=="FLAG" {
	x=$2*16/60;
	y=-$3*16/60;
	printf("\\draw (0, 0) node[ground] {}; \n", x, y);
}
	
END {print "\\end{circuitikz}"}
