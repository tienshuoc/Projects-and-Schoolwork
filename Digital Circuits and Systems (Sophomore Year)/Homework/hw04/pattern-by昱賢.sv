`timescale 100ps/10ps
//############################################################################
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2019 DCS Spring Course
//   HW04			: CONV
//   Author         : Yu-Sian Liu (thomasysliu@gmail.com)
//
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : PATTERN.sv
//   Module Name : PATTERN
//   Release version : v1.0
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module PATTERN(
  // Input signals
  clk,
  rst_n,
  image_valid,
  filter_valid,
  in_data,
  // Output signals
  out_valid,
  out_data
);

`define CYCLE_TIME 7.0
`define PATNUM 20000

output reg clk;
output reg rst_n;
output reg image_valid;
output reg filter_valid;
output reg [3:0] in_data;
input out_valid;
input [10:0] out_data;



//================================================================
// parameters & integer
//================================================================
real	CYCLE = `CYCLE_TIME;
`protect

integer filter_file;
integer input_file;
integer output_file;
integer ret;
integer count;
integer i;
integer lat;
integer total_lat;
integer x;
integer y;
integer patcount;
reg signed [10:0] gold_out;
reg signed [10:0] ans_out [4:0][4:0];
reg signed [3:0] filter [2:0][2:0];
reg signed [3:0] img_data [6:0][6:0];

//================================================================
// clock
//================================================================
always	#(CYCLE/2.0) clk = ~clk;
//================================================================
// initial
//================================================================
initial begin
	rst_n = 1;
	clk = 0;
	lat = 0;
    image_valid = 1'b0;
    filter_valid = 1'b0;
	in_data = 'bx;
	force clk = 0;
	
	reset_signal_task;
	init;
	wait_random_cycles;
	check_output_zero;
	gen_pattern;
	for(patcount=0;patcount<`PATNUM;patcount=patcount+1)
	begin
		gen_pattern;
		send_pattern;
		//$display("gen_pattern %d", patcount);
		check_output;
	end
	wait_random_cycles;
	repeat(20) @(negedge clk);
	YOU_PASS_task;
	$finish();
end

//================================================================
// task
//================================================================
task reset_signal_task; begin 
    #(0.5);   rst_n=0;
	
	#(2.0);
	if((out_valid !== 0)||(out_data !== 'b0)) begin
		fail;
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                                        FAIL!                                                               ");
		$display ("                                                  Output signal should be 0 after initial RESET at %t                                 ",$time);
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");

		repeat(20) @(negedge clk);
		$finish;
	end
	#(10);   rst_n=1;
	#(3);   release clk;	
	repeat(5) @(negedge clk);
	check_output_zero;
end endtask


task check_output; begin
	lat = 0;
	while(1)begin
		if(lat == 100)begin
			fail;
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                        FAIL!                                                               ");
			$display ("                                                     The execution latency are over 100   cycles                                            ");
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");

			repeat(20)@(negedge clk);
			$finish;
		end
		if(out_valid === 1'b1)begin
			break;
		end
		@(negedge clk);
		lat = lat + 1;
	end
	i = 0;
	while(i < 25)begin
		gold_out = ans_out[i/5][i%5];
		if(out_valid !== 1'b1) begin
			fail;
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                        FAIL!                                                               ");
			$display ("                                                  Out_valid is less than 25 cycles                                                          ");
			$display ("                                                  Out_valid signal should be exact 25 cycles at %t                                 ",$time);
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			repeat(20) @(negedge clk);
			$finish;
		end
		if( out_data !== ans_out[i/5][i%5] || out_valid !== 1'b1)begin
			fail;
			print_filter;
			print_img;
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                        FAIL!                                                               ");
			$display ("                                                                   PATTERN NO.%4d                                                      ", patcount);
			$display ("                                                     Ans(out_valid): %d,  Your output : %d  at %8t                                              ", 1, out_valid, $time);
			$display ("                                                     Ans(out_data): %d,  Your output : %d  at %8t                                              ", ans_out[i/5][i%5], out_data,$time);
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			repeat(30) @(negedge clk);
			$finish;
		end
		@(negedge clk);
		i = i + 1;
	end
	if(out_valid !== 0) begin
		fail;
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                                        FAIL!                                                               ");
		$display ("                                                  Out_valid is more than 25 cycles                                                          ");
		$display ("                                                  Out_valid signal should be exact 25 cycles at %t                                 ",$time);
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		repeat(20) @(negedge clk);
		$finish;
	end
	check_output_zero;
	
end endtask

task check_output_zero; begin 
	if((out_valid !== 0)||(out_data !== 'b0)) begin
		fail;
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                                        FAIL!                                                               ");
		$display ("                                                  Output signal should be 0 at %t                                 ",$time);
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");

		repeat(20) @(negedge clk);
		$finish;
	end
end endtask

task print_filter; begin
	$display("filter: %3d %3d %3d", filter[0][0], filter[0][1], filter[0][2]);
	$display("        %3d %3d %3d", filter[1][0], filter[1][1], filter[1][2]);
	$display("        %3d %3d %3d", filter[2][0], filter[2][1], filter[2][2]);
	$display("");
end endtask

task print_img; begin
	$display("img_data: %3d %3d %3d %3d %3d %3d %3d", img_data[0][0], img_data[0][1], img_data[0][2], img_data[0][3], img_data[0][4], img_data[0][5], img_data[0][6]);
	$display("          %3d %3d %3d %3d %3d %3d %3d", img_data[1][0], img_data[1][1], img_data[1][2], img_data[1][3], img_data[1][4], img_data[1][5], img_data[1][6]);
	$display("          %3d %3d %3d %3d %3d %3d %3d", img_data[2][0], img_data[2][1], img_data[2][2], img_data[2][3], img_data[2][4], img_data[2][5], img_data[2][6]);
	$display("          %3d %3d %3d %3d %3d %3d %3d", img_data[3][0], img_data[3][1], img_data[3][2], img_data[3][3], img_data[3][4], img_data[3][5], img_data[3][6]);
	$display("          %3d %3d %3d %3d %3d %3d %3d", img_data[4][0], img_data[4][1], img_data[4][2], img_data[4][3], img_data[4][4], img_data[4][5], img_data[4][6]);
	$display("          %3d %3d %3d %3d %3d %3d %3d", img_data[5][0], img_data[5][1], img_data[5][2], img_data[5][3], img_data[5][4], img_data[5][5], img_data[5][6]);
	$display("          %3d %3d %3d %3d %3d %3d %3d", img_data[6][0], img_data[6][1], img_data[6][2], img_data[6][3], img_data[6][4], img_data[6][5], img_data[6][6]);
	$display("");
end endtask


task init; begin 
	total_lat = 0;
end endtask

task wait_random_cycles; begin
    i = $urandom_range(0, 10);
    repeat(i) begin
        @(negedge clk);
        check_output_zero;
		image_valid = 1'b0;
    end
    
end endtask

task gen_pattern; begin
	for( i = 0; i < 9 ; i = i + 1)begin
		//ret = $fscanf(filter_file, "%d", filter[i/3][i%3]);
		filter[i/3][i%3] = $urandom_range(0, 15);
	end
	for( i = 0; i < 49 ; i = i + 1)begin
		//ret = $fscanf(input_file, "%d", img_data[i/7][i%7]);
		img_data[i/7][i%7] = $urandom_range(0, 15);
	end
	cal_ans;
	//$finish();
end endtask

task send_pattern; begin
	for(count=0;count<9;count=count+1)begin
		@(negedge clk);
		filter_valid = 1'b1;
		image_valid = 1'b0;
		in_data = filter[count/3][count%3];
		check_output_zero;
	end
	@(negedge clk);
	filter_valid = 1'b0;
	image_valid = 1'b0;
	in_data = 'bx;
	check_output_zero;
	for(count=0;count<49;count=count+1)begin
		@(negedge clk);
		filter_valid = 1'b0;
		image_valid = 1'b1;
		in_data = img_data[count/7][count%7];
		check_output_zero;
	end
	@(negedge clk);
	filter_valid = 1'b0;
	image_valid = 1'b0;
	in_data = 'bx;
end endtask

task cal_ans; begin
	for( i = 0; i < 25 ; i = i + 1)begin
		ans_out[i/5][i%5] = 0;
		for( x = 0; x < 3 ; x = x + 1)begin
			for( y = 0; y < 3 ; y = y + 1)begin
				ans_out[i/5][i%5] = ans_out[i/5][i%5] + filter[x][y] * img_data[i/5+x][i%5+y];
			end
		end
	end
end endtask
task check_ans; begin
	
end endtask

task fail; begin


$display("\033[33m	                                                         .:                                                                                         ");      
$display("                                                   .:                                                                                                 ");
$display("                                                  --`                                                                                                 ");
$display("                                                `--`                                                                                                  ");
$display("                 `-.                            -..        .-//-                                                                                      ");
$display("                  `.:.`                        -.-     `:+yhddddo.                                                                                    ");
$display("                    `-:-`             `       .-.`   -ohdddddddddh:                                                                                   ");
$display("                      `---`       `.://:-.    :`- `:ydddddhhsshdddh-                       \033[31m.yhhhhhhhhhs       /yyyyy`       .yhhy`   +yhyo           \033[33m");
$display("                        `--.     ./////:-::` `-.--yddddhs+//::/hdddy`                      \033[31m-MMMMNNNNNNh      -NMMMMMs       .MMMM.   sMMMh           \033[33m");
$display("                          .-..   ////:-..-// :.:oddddho:----:::+dddd+                      \033[31m-MMMM-......     `dMMmhMMM/      .MMMM.   sMMMh           \033[33m");
$display("                           `-.-` ///::::/::/:/`odddho:-------:::sdddh`                     \033[31m-MMMM.           sMMM/.NMMN.     .MMMM.   sMMMh           \033[33m");
$display("             `:/+++//:--.``  .--..+----::://o:`osss/-.--------::/dddd/             ..`     \033[31m-MMMMysssss.    /MMMh  oMMMh     .MMMM.   sMMMh           \033[33m");
$display("             oddddddddddhhhyo///.-/:-::--//+o-`:``````...------::dddds          `.-.`      \033[31m-MMMMMMMMMM-   .NMMN-``.mMMM+    .MMMM.   sMMMh           \033[33m");
$display("            .ddddhhhhhddddddddddo.//::--:///+/`.````````..``...-:ddddh       `.-.`         \033[31m-MMMM:.....`  `hMMMMmmmmNMMMN-   .MMMM.   sMMMh           \033[33m");
$display("            /dddd//::///+syhhdy+:-`-/--/////+o```````.-.......``./yddd`   `.--.`           \033[31m-MMMM.        oMMMmhhhhhhdMMMd`  .MMMM.   sMMMh```````    \033[33m");
$display("            /dddd:/------:://-.`````-/+////+o:`````..``     `.-.``./ym.`..--`              \033[31m-MMMM.       :NMMM:      .NMMMs  .MMMM.   sMMMNmmmmmms    \033[33m");
$display("            :dddd//--------.`````````.:/+++/.`````.` `.-      `-:.``.o:---`                \033[31m.dddd`       yddds        /dddh. .dddd`   +ddddddddddo    \033[33m");
$display("            .ddddo/-----..`........`````..```````..  .-o`       `:.`.--/-      ``````````` \033[31m ````        ````          ````   ````     ``````````     \033[33m");
$display("             ydddh/:---..--.````.`.-.````````````-   `yd:        `:.`...:` `................`                                                         ");
$display("             :dddds:--..:.     `.:  .-``````````.:    +ys         :-````.:...```````````````..`                                                       ");
$display("              sdddds:.`/`      ``s.  `-`````````-/.   .sy`      .:.``````-`````..-.-:-.````..`-                                                       ");
$display("              `ydddd-`.:       `sh+   /:``````````..`` +y`   `.--````````-..---..``.+::-.-``--:                                                       ");
$display("               .yddh``-.        oys`  /.``````````````.-:.`.-..`..```````/--.`      /:::-:..--`                                                       ");
$display("                .sdo``:`        .sy. .:``````````````````````````.:```...+.``       -::::-`.`                                                         ");
$display(" ````.........```.++``-:`        :y:.-``````````````....``.......-.```..::::----.```  ``                                                              ");
$display("`...````..`....----:.``...````  ``::.``````.-:/+oosssyyy:`.yyh-..`````.:` ````...-----..`                                                             ");
$display("                 `.+.``````........````.:+syhdddddddddddhoyddh.``````--              `..--.`                                                          ");
$display("            ``.....--```````.```````.../ddddddhhyyyyyyyhhhddds````.--`             ````   ``                                                          ");
$display("         `.-..``````-.`````.-.`.../ss/.oddhhyssssooooooossyyd:``.-:.         `-//::/++/:::.`                                                          ");
$display("       `..```````...-::`````.-....+hddhhhyssoo+++//////++osss.-:-.           /++++o++//s+++/                                                          ");
$display("     `-.```````-:-....-/-``````````:hddhsso++/////////////+oo+:`             +++::/o:::s+::o            \033[31m     `-/++++:-`                              \033[33m");
$display("    `:````````./`  `.----:..````````.oysso+///////////////++:::.             :++//+++/+++/+-            \033[31m   :ymMMMMMMMMms-                            \033[33m");
$display("    :.`-`..```./.`----.`  .----..`````-oo+////////////////o:-.`-.            `+++++++++++/.             \033[31m `yMMMNho++odMMMNo                           \033[33m");
$display("    ..`:..-.`.-:-::.`        `..-:::::--/+++////////////++:-.```-`            +++++++++o:               \033[31m hMMMm-      /MMMMo  .ssss`/yh+.syyyyyyyyss. \033[33m");
$display("     `.-::-:..-:-.`                 ```.+::/++//++++++++:..``````:`          -++++++++oo                \033[31m:MMMM:        yMMMN  -MMMMdMNNs-mNNNNNMMMMd` \033[33m");
$display("        `   `--`                        /``...-::///::-.`````````.: `......` ++++++++oy-                \033[31m+MMMM`        +MMMN` -MMMMh:--. ````:mMMNs`  \033[33m");
$display("           --`                          /`````````````````````````/-.``````.::-::::::/+                 \033[31m:MMMM:        yMMMm  -MMMM`       `oNMMd:    \033[33m");
$display("          .`                            :```````````````````````--.`````````..````.``/-                 \033[31m dMMMm:`    `+MMMN/  -MMMN       :dMMNs`     \033[33m");
$display("                                        :``````````````````````-.``.....````.```-::-.+                  \033[31m `yNMMMdsooymMMMm/   -MMMN     `sMMMMy/////` \033[33m");
$display("                                        :.````````````````````````-:::-::.`````-:::::+::-.`             \033[31m   -smNMMMMMNNd+`    -NNNN     hNNNNNNNNNNN- \033[33m");
$display("                                `......../```````````````````````-:/:   `--.```.://.o++++++/.           \033[31m      .:///:-`       `----     ------------` \033[33m");
$display("                              `:.``````````````````````````````.-:-`      `/````..`+sssso++++:                                                        ");
$display("                              :`````.---...`````````````````.--:-`         :-````./ysoooss++++.                                                       ");
$display("                              -.````-:/.`.--:--....````...--:/-`            /-..-+oo+++++o++++.                                                       ");
$display("             `:++/:.`          -.```.::      `.--:::::://:::::.              -:/o++++++++s++++                                                        ");
$display("           `-+++++++++////:::/-.:.```.:-.`              :::::-.-`               -+++++++o++++.                                                        ");
$display("           /++osoooo+++++++++:`````````.-::.             .::::.`-.`              `/oooo+++++.                                                         ");
$display("           ++oysssosyssssooo/.........---:::               -:::.``.....`     `.:/+++++++++:                                                           ");
$display("           -+syoooyssssssyo/::/+++++/+::::-`                 -::.``````....../++++++++++:`                                                            ");
$display("             .:///-....---.-..-.----..`                        `.--.``````````++++++/:.                                                               ");
$display("                                                                   `........-:+/:-.`                                                            \033[37m      ");


		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                                  FAIL                                                                      ");
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");


end endtask






task YOU_PASS_task;begin
  $display("                                                             \033[33m`-                                                                            ");        
  $display("                                                             /NN.                                                                           ");        
  $display("                                                            sMMM+                                                                           ");        
  $display(" .``                                                       sMMMMy                                                                           ");        
  $display(" oNNmhs+:-`                                               oMMMMMh                                                                           ");        
  $display("  /mMMMMMNNd/:-`                                         :+smMMMh                                                                           ");        
  $display("   .sNMMMMMN::://:-`                                    .o--:sNMy                                                                           ");        
  $display("     -yNMMMM:----::/:-.                                 o:----/mo                                                                           ");        
  $display("       -yNMMo--------://:.                             -+------+/                                                                           ");        
  $display("         .omd/::--------://:`                          o-------o.                                                                           ");        
  $display("           `/+o+//::-------:+:`                       .+-------y                                                                            ");        
  $display("              .:+++//::------:+/.---------.`          +:------/+                                                                            ");        
  $display("                 `-/+++/::----:/:::::::::::://:-.     o------:s.          \033[37m:::::----.           -::::.          `-:////:-`     `.:////:-.    \033[33m");        
  $display("                    `.:///+/------------------:::/:- `o-----:/o          \033[37m.NNNNNNNNNNds-       -NNNNNd`       -smNMMMMMMNy   .smNNMMMMMNh    \033[33m");        
  $display("                         :+:----------------------::/:s-----/s.          \033[37m.MMMMo++sdMMMN-     `mMMmMMMs      -NMMMh+///oys  `mMMMdo///oyy    \033[33m");        
  $display("                        :/---------------------------:++:--/++           \033[37m.MMMM.   `mMMMy     yMMM:dMMM/     +MMMM:      `  :MMMM+`     `    \033[33m");        
  $display("                       :/---///:-----------------------::-/+o`           \033[37m.MMMM.   -NMMMo    +MMMs -NMMm.    .mMMMNdo:.     `dMMMNds/-`      \033[33m");        
  $display("                      -+--/dNs-o/------------------------:+o`            \033[37m.MMMMyyyhNMMNy`   -NMMm`  sMMMh     .odNMMMMNd+`   `+dNMMMMNdo.    \033[33m");        
  $display("                     .o---yMMdsdo------------------------:s`             \033[37m.MMMMNmmmdho-    `dMMMdooosMMMM+      `./sdNMMMd.    `.:ohNMMMm-   \033[33m");        
  $display("                    -yo:--/hmmds:----------------//:------o              \033[37m.MMMM:...`       sMMMMMMMMMMMMMN-  ``     `:MMMM+ ``      -NMMMs   \033[33m");        
  $display("                   /yssy----:::-------o+-------/h/-hy:---:+              \033[37m.MMMM.          /MMMN:------hMMMd` +dy+:::/yMMMN- :my+:::/sMMMM/   \033[33m");        
  $display("                  :ysssh:------//////++/-------sMdyNMo---o.              \033[37m.MMMM.         .mMMMs       .NMMMs /NMMMMMMMMmh:  -NMMMMMMMMNh/    \033[33m");        
  $display("                  ossssh:-------ddddmmmds/:----:hmNNh:---o               \033[37m`::::`         .::::`        -:::: `-:/++++/-.     .:/++++/-.      \033[33m");        
  $display("                  /yssyo--------dhhyyhhdmmhy+:---://----+-                                                                                  ");        
  $display("                  `yss+---------hoo++oosydms----------::s    `.....-.                                                                       ");        
  $display("                   :+-----------y+++++++oho--------:+sssy.://:::://+o.                                                                      ");        
  $display("                    //----------y++++++os/--------+yssssy/:--------:/s-                                                                     ");        
  $display("             `..:::::s+//:::----+s+++ooo:--------+yssssy:-----------++                                                                      ");        
  $display("           `://::------::///+/:--+soo+:----------ssssys/---------:o+s.``                                                                    ");        
  $display("          .+:----------------/++/:---------------:sys+----------:o/////////::::-...`                                                        ");        
  $display("          o---------------------oo::----------::/+//---------::o+--------------:/ohdhyo/-.``                                                ");        
  $display("          o---------------------/s+////:----:://:---------::/+h/------------------:oNMMMMNmhs+:.`                                           ");        
  $display("          -+:::::--------------:s+-:::-----------------:://++:s--::------------::://sMMMMMMMMMMNds/`                                        ");        
  $display("           .+++/////////////+++s/:------------------:://+++- :+--////::------/ydmNNMMMMMMMMMMMMMMmo`                                        ");        
  $display("             ./+oo+++oooo++/:---------------------:///++/-   o--:///////::----sNMMMMMMMMMMMMMMMmo.                                          ");        
  $display("                o::::::--------------------------:/+++:`    .o--////////////:--+mMMMMMMMMMMMMmo`                                            ");        
  $display("               :+--------------------------------/so.       +:-:////+++++///++//+mMMMMMMMMMmo`                                              ");        
  $display("              .s----------------------------------+: ````` `s--////o:.-:/+syddmNMMMMMMMMMmo`                                                ");        
  $display("              o:----------------------------------s. :s+/////--//+o-       `-:+shmNNMMMNs.                                                  ");        
  $display("             //-----------------------------------s` .s///:---:/+o.               `-/+o.                                                    ");        
  $display("            .o------------------------------------o.  y///+//:/+o`                                                                          ");        
  $display("            o-------------------------------------:/  o+//s//+++`                                                                           ");        
  $display("           //--------------------------------------s+/o+//s`                                                                                ");        
  $display("          -+---------------------------------------:y++///s                                                                                 ");        
  $display("          o-----------------------------------------oo/+++o                                                                                 ");        
  $display("         `s-----------------------------------------:s   ``                                                                                 ");        
  $display("          o-:::::------------------:::::-------------o.                                                                                     ");        
  $display("          .+//////////::::::://///////////////:::----o`                                                                                     ");        
  $display("          `:soo+///////////+++oooooo+/////////////:-//                                                                                      ");        
  $display("       -/os/--:++/+ooo:::---..:://+ooooo++///////++so-`                                                                                     ");        
  $display("      syyooo+o++//::-                 ``-::/yoooo+/:::+s/.                                                                                  ");        
  $display("       `..``                                `-::::///:++sys:                                                                                ");        
  $display("                                                    `.:::/o+  \033[37m                                                                              ");											  
	$display ("--------------------------------------------------------------------------------------------------------------------------------------------");                                                                      
	$display ("                                                            Congratulations!                                                                ");
	$display ("                                                     You have passed all patterns!                                                          ");
    $display ("                                                       latency:  %d                                      ",total_lat*CYCLE);
	$display ("--------------------------------------------------------------------------------------------------------------------------------------------");    
	$finish;	
end endtask



endmodule


