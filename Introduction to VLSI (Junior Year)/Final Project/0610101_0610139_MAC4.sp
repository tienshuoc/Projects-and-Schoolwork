************************************************************************
* auCdl Netlist:
* 
* Library Name:  VLSI
* Top Cell Name: MAC_v14_134
* View Name:     schematic
* Netlisted on:  Jan  1 04:52:39 2020
************************************************************************

*.BIPOLAR
*.RESI = 2000 
*.RESVAL
*.CAPVAL
*.DIOPERI
*.DIOAREA
*.EQUATION
*.SCALE METER
*.MEGA
.PARAM

.GLOBAL VDD
+        GND

*.PIN VDD
*+    GND

************************************************************************
* Library Name: VLSI
* Cell Name:    INV
* View Name:    schematic
************************************************************************

.SUBCKT INV INA OUT
*.PININFO INA:I OUT:O
MM8 OUT INA VDD VDD P_18_G2 W=1400.00n L=180.00n
MM7 OUT INA GND GND N_18_G2 W=900.00n L=180.00n
.ENDS

************************************************************************
* Library Name: VLSI
* Cell Name:    FA
* View Name:    schematic
************************************************************************

.SUBCKT FA A B C COUT SUM
*.PININFO A:I B:I C:I COUT:O SUM:O
MM31 net33 A VDD VDD P_18_G2 W=940n L=180n
MM30 net40 B VDD VDD P_18_G2 W=940n L=180n
MM3 net12 B VDD VDD P_18_G2 W=940n L=180n
MM2 net12 A VDD VDD P_18_G2 W=940n L=180n
MM29 net22 C VDD VDD P_18_G2 W=940n L=180n
MM28 net22 B VDD VDD P_18_G2 W=940n L=180n
MM21 net22 A VDD VDD P_18_G2 W=940n L=180n
MM20 net34 B net33 VDD P_18_G2 W=940n L=180n
MM14 net23 net13 net22 VDD P_18_G2 W=940n L=180n
MM13 net13 A net40 VDD P_18_G2 W=940n L=180n
MM0 net13 C net12 VDD P_18_G2 W=940n L=180n
MM25 SUM net23 VDD VDD P_18_G2 W=940n L=180n
MM19 net23 C net34 VDD P_18_G2 W=940n L=180n
MM27 COUT net13 VDD VDD P_18_G2 W=940n L=180n
MM12 net13 A net50 GND N_18_G2 W=470n L=180n
MM1 net13 C net10 GND N_18_G2 W=470n L=180n
MM11 net23 net13 net20 GND N_18_G2 W=470n L=180n
MM24 SUM net23 GND GND N_18_G2 W=470n L=180n
MM18 net23 C net44 GND N_18_G2 W=470n L=180n
MM22 net44 B net43 GND N_18_G2 W=470n L=180n
MM17 net20 C GND GND N_18_G2 W=470n L=180n
MM16 net20 B GND GND N_18_G2 W=470n L=180n
MM15 net20 A GND GND N_18_G2 W=470n L=180n
MM10 net50 B GND GND N_18_G2 W=470n L=180n
MM5 net10 B GND GND N_18_G2 W=470n L=180n
MM4 net10 A GND GND N_18_G2 W=470n L=180n
MM23 net43 A GND GND N_18_G2 W=470n L=180n
MM26 COUT net13 GND GND N_18_G2 W=470n L=180n
.ENDS

************************************************************************
* Library Name: VLSI
* Cell Name:    nand
* View Name:    schematic
************************************************************************

.SUBCKT nand A B out
*.PININFO A:I B:I out:O
MM1 net4 A GND GND N_18_G2 W=470.00n L=180.00n
MM7 out B net4 GND N_18_G2 W=470.00n L=180.00n
MM0 out A VDD VDD P_18_G2 W=940.00n L=180.00n
MM8 out B VDD VDD P_18_G2 W=940.00n L=180.00n
.ENDS

************************************************************************
* Library Name: VLSI
* Cell Name:    DFF_faster
* View Name:    schematic
************************************************************************

.SUBCKT DFF_faster CLK CLK~ D Q
*.PININFO CLK:I D:I Q:O CLK~:B
MM32 Q net24 VDD VDD P_18_G2 W=940.00n L=180.00n
MM7 net23 Q VDD VDD P_18_G2 W=940.00n L=180.00n
MM5 net14 net19 VDD VDD P_18_G2 W=940.00n L=180.00n
MM30 net19 CLK~ net24 VDD P_18_G2 W=940.00n L=180.00n
MM2 net16 CLK~ net14 VDD P_18_G2 W=940.00n L=180.00n
MM22 net19 net16 VDD VDD P_18_G2 W=940.00n L=180.00n
MM1 net24 CLK net23 VDD P_18_G2 W=940.00n L=180.00n
MM19 D CLK net16 VDD P_18_G2 W=940.00n L=180.00n
MM6 net23 Q GND GND N_18_G2 W=470.00n L=180.00n
MM31 Q net24 GND GND N_18_G2 W=470.00n L=180.00n
MM4 net14 net19 GND GND N_18_G2 W=470.00n L=180.00n
MM29 net19 CLK net24 GND N_18_G2 W=470.00n L=180.00n
MM3 net16 CLK net14 GND N_18_G2 W=470.00n L=180.00n
MM21 net19 net16 GND GND N_18_G2 W=470.00n L=180.00n
MM0 net24 CLK~ net23 GND N_18_G2 W=470.00n L=180.00n
MM20 D CLK~ net16 GND N_18_G2 W=470.00n L=180.00n
.ENDS

************************************************************************
* Library Name: VLSI
* Cell Name:    XOR_transimit
* View Name:    schematic
************************************************************************

.SUBCKT XOR_transimit INA INB OUT
*.PININFO INA:I INB:I OUT:O
MM14 net07 INB VDD VDD P_18_G2 W=940.00n L=180.00n
MM16 INB INA OUT VDD P_18_G2 W=940.00n L=180.00n
MM12 net07 net09 OUT VDD P_18_G2 W=940.00n L=180.00n
MM8 net09 INA VDD VDD P_18_G2 W=940.00n L=180.00n
MM15 INB net09 OUT GND N_18_G2 W=470.00n L=180.00n
MM13 net07 INB GND GND N_18_G2 W=470.00n L=180.00n
MM11 net07 INA OUT GND N_18_G2 W=470.00n L=180.00n
MM7 net09 INA GND GND N_18_G2 W=470.00n L=180.00n
.ENDS

************************************************************************
* Library Name: VLSI
* Cell Name:    MUX
* View Name:    schematic
************************************************************************

.SUBCKT MUX Data OUT S
*.PININFO Data:I S:I OUT:O
MM19 Sbar S VDD VDD P_18_G2 W=940.00n L=180.00n
MM15 net8 Sbar VDD VDD P_18_G2 W=940.00n L=180.00n
MM13 OUT S net8 VDD P_18_G2 W=940.00n L=180.00n
MM14 net8 VDD VDD VDD P_18_G2 W=940.00n L=180.00n
MM12 OUT Data net8 VDD P_18_G2 W=940.00n L=180.00n
MM18 Sbar S GND GND N_18_G2 W=470.00n L=180.00n
MM22 net11 S GND GND N_18_G2 W=470.00n L=180.00n
MM21 OUT Data net11 GND N_18_G2 W=470.00n L=180.00n
MM23 net10 VDD GND GND N_18_G2 W=470.00n L=180.00n
MM20 OUT Sbar net10 GND N_18_G2 W=470.00n L=180.00n
.ENDS

************************************************************************
* Library Name: VLSI
* Cell Name:    MAC_v14_134
* View Name:    schematic
************************************************************************

.SUBCKT MAC4  CLK A[3] A[2] A[1] A[0]
+ B[3] B[2] B[1] B[0] 
+ MODE 
+ ACC[7] ACC[6] ACC[5] ACC[4] ACC[3] ACC[2] ACC[1] ACC[0]
+ OUT[8] OUT[7] OUT[6] OUT[5] OUT[4] OUT[3] OUT[2] OUT[1] OUT[0] 
*.PININFO ACC[0]:I ACC[1]:I ACC[2]:I ACC[3]:I ACC[4]:I ACC[5]:I ACC[6]:I 
*.PININFO ACC[7]:I A[0]:I A[1]:I A[2]:I A[3]:I B[0]:I B[1]:I B[2]:I B[3]:I 
*.PININFO CLK:I A2:B A3:B ACC0_Q:B ACC1_Q:B ACC2_Q:B ACC3_Q:B ACC4_Q:B 
*.PININFO ACC5_Q:B ACC6_Q:B ACC7_Q:B B0:B B1:B B2:B B3:B CLK~:B COUT5:B 
*.PININFO COUT6:B COUT7:B OUT[0]:B OUT[1]:B OUT[2]:B OUT[3]:B OUT[4]:B 
*.PININFO OUT[5]:B OUT[6]:B OUT[7]:B OUT[8]:B SUM7:B cout_tmp:B mode:B 
*.PININFO mode_q:B p0:B p1:B p2:B p3:B p4:B p5:B p6:B p7:B sum0:B sum1:B 
*.PININFO sum2:B sum6:B
XI55 net088 net036 / INV
XI52 net087 net035 / INV
XI57 net086 net034 / INV
XI51 net085 net082 / INV
XI146 net172 net101 / INV
XI144 net173 net87 / INV
XI141 net176 net86 / INV
XI139 net177 net85 / INV
XI137 net174 net171 / INV
XI133 net179 net97 / INV
XI129 net178 net98 / INV
XI125 net175 net96 / INV
XI102 CLK CLK~ / INV
XI3 ACC0_Q p0 mode_q net133 sum0 / FA
XI2 ACC1_Q p1 net133 net132 sum1 / FA
XI1 ACC2_Q p2 net132 net055 sum2 / FA
XI169 GND net144 net146 net066 net061 / FA
XI61 net136 net026 net023 net146 p3 / FA
XI60 net138 net022 net025 net065 net144 / FA
XI166 ACC3_Q p3 net055 net060 net059 / FA
XI46 net036 net125 net111 net024 net022 / FA
XI45 net035 net129 net88 net025 net026 / FA
XI48 net082 net130 net032 net023 p2 / FA
XI47 net034 net125 net127 net020 net010 / FA
XI11 p4 net155 net163 net162 net167 / FA
XI10 p5 net158 net162 net161 net166 / FA
XI173 net069 sum6 COUT5 net070 p5 / FA
XI9 p6 net159 net161 net160 net165 / FA
XI62 COUT6 SUM7 net070 net150 p6 / FA
XI59 net135 net010 net024 net145 net064 / FA
XI58 net134 net010 net020 net140 net142 / FA
XI4 p7 net072 net160 net168 net164 / FA
XI21 COUT7 SUM7 net150 cout_tmp p7 / FA
XI135 net171 net87 GND net030 net100 / FA
XI131 net97 net86 GND net99 net0116 / FA
XI127 net98 net85 A[3] net0117 net105 / FA
XI123 net96 net85 GND net0127 net0128 / FA
XI53 A2 B1 net087 / nand
XI54 A2 B2 net088 / nand
XI56 A2 B3 net086 / nand
XI50 A2 B0 net085 / nand
XI145 A[0] B[0] net172 / nand
XI143 A[0] B[1] net173 / nand
XI140 A[0] B[2] net176 / nand
XI138 A[0] B[3] net177 / nand
XI136 A[1] B[0] net174 / nand
XI132 A[1] B[1] net179 / nand
XI128 A[1] B[2] net178 / nand
XI124 A[1] B[3] net175 / nand
XI91 CLK CLK~ net99 net88 / DFF_faster
XI86 CLK CLK~ net0116 net130 / DFF_faster
XI15 CLK CLK~ net0117 net111 / DFF_faster
XI14 CLK CLK~ net105 net129 / DFF_faster
XI13 CLK CLK~ net0127 net127 / DFF_faster
XI12 CLK CLK~ net0128 net125 / DFF_faster
XI20 CLK CLK~ sum0 net157 / DFF_faster
XI19 CLK CLK~ sum1 net156 / DFF_faster
XI18 CLK CLK~ sum2 net154 / DFF_faster
XI25 CLK CLK~ net060 net163 / DFF_faster
XI183 CLK CLK~ net031 ACC3_Q / DFF_faster
XI94 CLK CLK~ net101 p0 / DFF_faster
XI103 CLK CLK~ net100 p1 / DFF_faster
XI165 CLK CLK~ net030 net032 / DFF_faster
XI187 CLK CLK~ net0126 ACC1_Q / DFF_faster
XI104 CLK CLK~ A[2] A2 / DFF_faster
XI167 CLK CLK~ net059 net067 / DFF_faster
XI189 CLK CLK~ net0133 ACC0_Q / DFF_faster
XI105 CLK CLK~ A[3] A3 / DFF_faster
XI185 CLK CLK~ net0121 ACC2_Q / DFF_faster
XI106 CLK CLK~ B[0] B0 / DFF_faster
XI107 CLK CLK~ B[1] B1 / DFF_faster
XI108 CLK CLK~ B[2] B2 / DFF_faster
XI24 CLK CLK~ net157 OUT[0] / DFF_faster
XI23 CLK CLK~ net156 OUT[1] / DFF_faster
XI22 CLK CLK~ net154 OUT[2] / DFF_faster
XI16 CLK CLK~ net067 OUT[3] / DFF_faster
XI181 CLK CLK~ net0101 ACC4_Q / DFF_faster
XI64 CLK CLK~ net167 OUT[4] / DFF_faster
XI65 CLK CLK~ net166 OUT[5] / DFF_faster
XI66 CLK CLK~ net165 OUT[6] / DFF_faster
XI174 CLK CLK~ net066 net069 / DFF_faster
XI179 CLK CLK~ net0134 ACC5_Q / DFF_faster
XI81 CLK CLK~ net065 COUT5 / DFF_faster
XI76 CLK CLK~ net061 p4 / DFF_faster
XI177 CLK CLK~ net0100 ACC6_Q / DFF_faster
XI74 CLK CLK~ net145 COUT6 / DFF_faster
XI73 CLK CLK~ net064 sum6 / DFF_faster
XI109 CLK CLK~ B[3] B3 / DFF_faster
XI67 CLK CLK~ net164 OUT[7] / DFF_faster
XI118 CLK CLK~ net090 OUT[8] / DFF_faster
XI89 CLK CLK~ net140 COUT7 / DFF_faster
XI88 CLK CLK~ net142 SUM7 / DFF_faster
XI49 CLK CLK~ ACC4_Q net155 / DFF_faster
XI27 CLK CLK~ ACC5_Q net158 / DFF_faster
XI26 CLK CLK~ ACC6_Q net159 / DFF_faster
XI36 CLK CLK~ ACC7_Q net072 / DFF_faster
XI176 CLK CLK~ net038 ACC7_Q / DFF_faster
XI142 CLK CLK~ mode mode_q / DFF_faster
XI180 mode ACC[5] net0134 / XOR_transimit
XI188 mode ACC[1] net0126 / XOR_transimit
XI190 mode ACC[0] net0133 / XOR_transimit
XI186 mode ACC[2] net0121 / XOR_transimit
XI119 net168 net091 net090 / XOR_transimit
XI184 mode ACC[3] net031 / XOR_transimit
XI182 mode ACC[4] net0101 / XOR_transimit
XI178 mode ACC[6] net0100 / XOR_transimit
XI175 mode ACC[7] net038 / XOR_transimit
XI101 p7 net072 net091 / XOR_transimit
XI82 B0 net136 A3 / MUX
XI83 B1 net138 A3 / MUX
XI84 B2 net135 A3 / MUX
XI85 B3 net134 A3 / MUX
.ENDS

.END