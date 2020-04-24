BEGIN {print "\\begin{circuitikz}"}
$1=="WIRE" {
	printf("	\\draw (%f, %f) to (%f, %f); 	%% %s\n", $4/60, -$5/60, $2/60, -$3/60, $0)
}
$1=="SYMBOL" {
	do {
		rep=0;
		switch($2) {
			case "res": 	len=5; h=1; v=1; sym="R"; break;
			case "ind": 	len=5; h=1; v=1; sym="L"; break;
			case "cap": 	len=4; h=1; v=0; sym="C"; break;
			case "voltage": len=5; h=0; v=1; sym="american voltage source"; break;
			case "current": len=5; h=0; v=0; sym="american current source"; break;
			case "diode": len=4; h=1; v=0; sym="diode"; break;
			case "zener": len=4; h=1; v=0; sym="zzDo"; break;
			case "LED": len=4; h=1; v=0; sym="empty led"; break;
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

		printf("\\draw (%f, %f) to[%s, l_=$%s$", x_beg, y_beg, sym, $3)
		if(mirror == 1) printf(", mirror");
		getline; 
		if($1=="SYMATTR" && $2=="Value") printf(", a^=$%s$", $3);
		else if($1=="SYMBOL") rep=1;
		printf("] (%f, %f); \n", x_end, y_end)
	} while(rep)
}
END {print "\\end{circuitikz}"}
