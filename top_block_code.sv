`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2024 14:20:20
// Design Name: 
// Module Name: top_block_code
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_block_code #(

		parameter DATA_WIDTH = 8,
		parameter NUM_SYMBOLS = 20
	)
    (
        clk,
        s_axis_aresetn,
        s_axis_tdata,
        s_axis_tvalid,
        s_axis_tready,
        s_axis_tlast,
        //
        code_length_valid,
        code_length,
        //
        m_axis_tdata,
        m_axis_tvalid,
        m_axis_tlast,
        m_axis_tready
    );

    input clk;
    input s_axis_aresetn;
    input [7:0] code_length;
    input code_length_valid;
    //
    input [DATA_WIDTH - 1:0] s_axis_tdata;
    input s_axis_tvalid;
    input s_axis_tlast;
    output s_axis_tready;
    //
    input m_axis_tready;
    output m_axis_tdata;
    output m_axis_tvalid;
    output m_axis_tlast;

    reg  [7:0] pucch_mask [4096] = '{4096{8'h01}};	


    initial begin // -1 index matlab 
        pucch_mask[36] = 8'hFF;	    pucch_mask[38] = 8'hFF;     pucch_mask[39] = 8'hFF;	    pucch_mask[41] = 8'hFF;	    pucch_mask[42] = 8'hFF;	    pucch_mask[44] = 8'hFF;	    pucch_mask[45] = 8'hFF;	    pucch_mask[46] = 8'hFF;	    pucch_mask[50] = 8'hFF;	    pucch_mask[51] = 8'hFF;	    pucch_mask[52] = 8'hFF;	    pucch_mask[53] = 8'hFF;	    pucch_mask[56] = 8'hFF;	    pucch_mask[57] = 8'hFF;	    pucch_mask[59] = 8'hFF;	    pucch_mask[60] = 8'hFF;	    
        pucch_mask[65] = 8'hFF;	    pucch_mask[67] = 8'hFF;     pucch_mask[68] = 8'hFF;	    pucch_mask[70] = 8'hFF;	    pucch_mask[71] = 8'hFF;	    pucch_mask[73] = 8'hFF;	    pucch_mask[74] = 8'hFF;	    pucch_mask[76] = 8'hFF;	    pucch_mask[77] = 8'hFF;	    pucch_mask[78] = 8'hFF;	    pucch_mask[82] = 8'hFF;	    pucch_mask[83] = 8'hFF;	    pucch_mask[84] = 8'hFF;	    pucch_mask[85] = 8'hFF;	    pucch_mask[91] = 8'hFF;	    pucch_mask[92] = 8'hFF;
        pucch_mask[97] = 8'hFF;	    pucch_mask[99] = 8'hFF;     pucch_mask[120] = 8'hFF;	pucch_mask[121] = 8'hFF;	pucch_mask[129] = 8'hFF;	pucch_mask[131] = 8'hFF;	pucch_mask[132] = 8'hFF;	pucch_mask[134] = 8'hFF;	pucch_mask[135] = 8'hFF;	pucch_mask[137] = 8'hFF;	pucch_mask[138] = 8'hFF;	pucch_mask[140] = 8'hFF;	pucch_mask[141] = 8'hFF;	pucch_mask[142] = 8'hFF;	pucch_mask[146] = 8'hFF;	pucch_mask[147] = 8'hFF;
        pucch_mask[148] = 8'hFF;	pucch_mask[149] = 8'hFF;    pucch_mask[152] = 8'hFF;	pucch_mask[153] = 8'hFF;	pucch_mask[161] = 8'hFF;	pucch_mask[163] = 8'hFF;	pucch_mask[187] = 8'hFF;	pucch_mask[188] = 8'hFF;	pucch_mask[216] = 8'hFF;	pucch_mask[217] = 8'hFF;	pucch_mask[219] = 8'hFF;	pucch_mask[220] = 8'hFF;	pucch_mask[228] = 8'hFF;	pucch_mask[230] = 8'hFF;	pucch_mask[231] = 8'hFF;	pucch_mask[233] = 8'hFF;
        pucch_mask[234] = 8'hFF;	pucch_mask[236] = 8'hFF;    pucch_mask[237] = 8'hFF;	pucch_mask[238] = 8'hFF;	pucch_mask[242] = 8'hFF;	pucch_mask[243] = 8'hFF;	pucch_mask[244] = 8'hFF;	pucch_mask[245] = 8'hFF;	pucch_mask[259] = 8'hFF;	pucch_mask[260] = 8'hFF;	pucch_mask[266] = 8'hFF;	pucch_mask[269] = 8'hFF;	pucch_mask[270] = 8'hFF;	pucch_mask[274] = 8'hFF;	pucch_mask[276] = 8'hFF;	pucch_mask[277] = 8'hFF;
        pucch_mask[281] = 8'hFF;	pucch_mask[283] = 8'hFF;    pucch_mask[291] = 8'hFF;	pucch_mask[294] = 8'hFF;	pucch_mask[295] = 8'hFF;	pucch_mask[297] = 8'hFF;	pucch_mask[300] = 8'hFF;	pucch_mask[307] = 8'hFF;	pucch_mask[312] = 8'hFF;	pucch_mask[316] = 8'hFF;	pucch_mask[321] = 8'hFF;	pucch_mask[326] = 8'hFF;	pucch_mask[327] = 8'hFF;	pucch_mask[329] = 8'hFF;	pucch_mask[332] = 8'hFF;	pucch_mask[339] = 8'hFF;
        pucch_mask[345] = 8'hFF;	pucch_mask[348] = 8'hFF;    pucch_mask[353] = 8'hFF;	pucch_mask[356] = 8'hFF;	pucch_mask[362] = 8'hFF;	pucch_mask[365] = 8'hFF;	pucch_mask[366] = 8'hFF;	pucch_mask[370] = 8'hFF;	pucch_mask[372] = 8'hFF;	pucch_mask[373] = 8'hFF;	pucch_mask[376] = 8'hFF;	pucch_mask[379] = 8'hFF;	pucch_mask[385] = 8'hFF;	pucch_mask[390] = 8'hFF;	pucch_mask[391] = 8'hFF;	pucch_mask[393] = 8'hFF;
        pucch_mask[396] = 8'hFF;	pucch_mask[403] = 8'hFF;    pucch_mask[408] = 8'hFF;	pucch_mask[411] = 8'hFF;	pucch_mask[417] = 8'hFF;	pucch_mask[420] = 8'hFF;	pucch_mask[426] = 8'hFF;	pucch_mask[429] = 8'hFF;	pucch_mask[430] = 8'hFF;	pucch_mask[434] = 8'hFF;	pucch_mask[436] = 8'hFF;	pucch_mask[437] = 8'hFF;	pucch_mask[441] = 8'hFF;    pucch_mask[444] = 8'hFF;	pucch_mask[451] = 8'hFF;	pucch_mask[452] = 8'hFF;
        pucch_mask[458] = 8'hFF;	pucch_mask[461] = 8'hFF;    pucch_mask[462] = 8'hFF;	pucch_mask[466] = 8'hFF;	pucch_mask[468] = 8'hFF;	pucch_mask[469] = 8'hFF;	pucch_mask[472] = 8'hFF;	pucch_mask[476] = 8'hFF;	pucch_mask[483] = 8'hFF;	pucch_mask[486] = 8'hFF;	pucch_mask[487] = 8'hFF;	pucch_mask[489] = 8'hFF;	pucch_mask[492] = 8'hFF;	pucch_mask[499] = 8'hFF;	pucch_mask[505] = 8'hFF;	pucch_mask[507] = 8'hFF;
        pucch_mask[516] = 8'hFF; 	pucch_mask[518] = 8'hFF;    pucch_mask[521] = 8'hFF;	pucch_mask[522] = 8'hFF;	pucch_mask[524] = 8'hFF;	pucch_mask[531] = 8'hFF;	pucch_mask[532] = 8'hFF;	pucch_mask[540] = 8'hFF;	pucch_mask[551] = 8'hFF;	pucch_mask[557] = 8'hFF;	pucch_mask[558] = 8'hFF;	pucch_mask[562] = 8'hFF;	pucch_mask[565] = 8'hFF;	pucch_mask[568] = 8'hFF;	pucch_mask[569] = 8'hFF;	pucch_mask[571] = 8'hFF;
        pucch_mask[577] = 8'hFF;	pucch_mask[579] = 8'hFF;    pucch_mask[583] = 8'hFF;	pucch_mask[589] = 8'hFF;	pucch_mask[590] = 8'hFF;	pucch_mask[594] = 8'hFF;	pucch_mask[597] = 8'hFF;	pucch_mask[603] = 8'hFF;	pucch_mask[609] = 8'hFF;	pucch_mask[611] = 8'hFF;	pucch_mask[612] = 8'hFF;	pucch_mask[614] = 8'hFF;	pucch_mask[617] = 8'hFF;	pucch_mask[618] = 8'hFF;	pucch_mask[620] = 8'hFF;	pucch_mask[627] = 8'hFF;
        pucch_mask[628] = 8'hFF;	pucch_mask[632] = 8'hFF;    pucch_mask[633] = 8'hFF;	pucch_mask[636] = 8'hFF;	pucch_mask[641] = 8'hFF;	pucch_mask[643] = 8'hFF;	pucch_mask[647] = 8'hFF;	pucch_mask[653] = 8'hFF;	pucch_mask[654] = 8'hFF;	pucch_mask[658] = 8'hFF;	pucch_mask[661] = 8'hFF;	pucch_mask[664] = 8'hFF;	pucch_mask[665] = 8'hFF;	pucch_mask[668] = 8'hFF;	pucch_mask[673] = 8'hFF;	pucch_mask[675] = 8'hFF;
        pucch_mask[676] = 8'hFF;	pucch_mask[678] = 8'hFF;    pucch_mask[681] = 8'hFF;	pucch_mask[682] = 8'hFF;	pucch_mask[684] = 8'hFF;	pucch_mask[691] = 8'hFF;	pucch_mask[692] = 8'hFF;	pucch_mask[699] = 8'hFF;	pucch_mask[708] = 8'hFF;	pucch_mask[710] = 8'hFF;	pucch_mask[713] = 8'hFF;	pucch_mask[714] = 8'hFF;	pucch_mask[716] = 8'hFF;	pucch_mask[723] = 8'hFF;	pucch_mask[724] = 8'hFF;	pucch_mask[728] = 8'hFF;
        pucch_mask[729] = 8'hFF;	pucch_mask[731] = 8'hFF;    pucch_mask[743] = 8'hFF;	pucch_mask[749] = 8'hFF;	pucch_mask[750] = 8'hFF;	pucch_mask[754] = 8'hFF;	pucch_mask[757] = 8'hFF;	pucch_mask[764] = 8'hFF;	pucch_mask[771] = 8'hFF;	pucch_mask[774] = 8'hFF;	pucch_mask[777] = 8'hFF;	pucch_mask[780] = 8'hFF;	pucch_mask[781] = 8'hFF;	pucch_mask[782] = 8'hFF;	pucch_mask[786] = 8'hFF;	pucch_mask[787] = 8'hFF;
        pucch_mask[789] = 8'hFF;	pucch_mask[793] = 8'hFF;    pucch_mask[795] = 8'hFF;	pucch_mask[796] = 8'hFF;	pucch_mask[803] = 8'hFF;	pucch_mask[804] = 8'hFF;	pucch_mask[807] = 8'hFF;	pucch_mask[810] = 8'hFF;	pucch_mask[820] = 8'hFF;	pucch_mask[824] = 8'hFF;	pucch_mask[833] = 8'hFF;	pucch_mask[836] = 8'hFF;	pucch_mask[839] = 8'hFF;	pucch_mask[842] = 8'hFF;	pucch_mask[852] = 8'hFF;	pucch_mask[857] = 8'hFF;
        pucch_mask[865] = 8'hFF;	pucch_mask[870] = 8'hFF;    pucch_mask[873] = 8'hFF;	pucch_mask[876] = 8'hFF;	pucch_mask[877] = 8'hFF;	pucch_mask[878] = 8'hFF;	pucch_mask[882] = 8'hFF;	pucch_mask[883] = 8'hFF;	pucch_mask[885] = 8'hFF;	pucch_mask[888] = 8'hFF;	pucch_mask[891] = 8'hFF;	pucch_mask[892] = 8'hFF;	pucch_mask[897] = 8'hFF;	pucch_mask[900] = 8'hFF;	pucch_mask[903] = 8'hFF;	pucch_mask[906] = 8'hFF;
        pucch_mask[916] = 8'hFF;	pucch_mask[920] = 8'hFF;    pucch_mask[923] = 8'hFF;	pucch_mask[924] = 8'hFF;	pucch_mask[929] = 8'hFF;	pucch_mask[934] = 8'hFF;	pucch_mask[937] = 8'hFF;	pucch_mask[940] = 8'hFF;	pucch_mask[941] = 8'hFF;	pucch_mask[942] = 8'hFF;	pucch_mask[946] = 8'hFF;	pucch_mask[947] = 8'hFF;	pucch_mask[949] = 8'hFF;	pucch_mask[953] = 8'hFF;	pucch_mask[963] = 8'hFF;	pucch_mask[966] = 8'hFF;
        pucch_mask[969] = 8'hFF;	pucch_mask[972] = 8'hFF;    pucch_mask[973] = 8'hFF;	pucch_mask[974] = 8'hFF;	pucch_mask[978] = 8'hFF;	pucch_mask[979] = 8'hFF;	pucch_mask[981] = 8'hFF;	pucch_mask[984] = 8'hFF;	pucch_mask[995] = 8'hFF;	pucch_mask[996] = 8'hFF;	pucch_mask[999] = 8'hFF;	pucch_mask[1002] = 8'hFF;	pucch_mask[1012] = 8'hFF;	pucch_mask[1017] = 8'hFF;	pucch_mask[1019] = 8'hFF;	pucch_mask[1020] = 8'hFF;
        pucch_mask[1031] = 8'hFF;	pucch_mask[1033] = 8'hFF;	pucch_mask[1036] = 8'hFF;	pucch_mask[1037] = 8'hFF;	pucch_mask[1042] = 8'hFF;	pucch_mask[1044] = 8'hFF;	pucch_mask[1045] = 8'hFF;	pucch_mask[1048] = 8'hFF;	pucch_mask[1049] = 8'hFF;	pucch_mask[1053] = 8'hFF;	pucch_mask[1060] = 8'hFF;	pucch_mask[1062] = 8'hFF;	pucch_mask[1066] = 8'hFF;	pucch_mask[1070] = 8'hFF;	pucch_mask[1075] = 8'hFF;	pucch_mask[1083] = 8'hFF;
        pucch_mask[1084] = 8'hFF;	pucch_mask[1085] = 8'hFF;	pucch_mask[1089] = 8'hFF;	pucch_mask[1091] = 8'hFF;	pucch_mask[1092] = 8'hFF;	pucch_mask[1094] = 8'hFF;	pucch_mask[1098] = 8'hFF;	pucch_mask[1102] = 8'hFF;	pucch_mask[1107] = 8'hFF;	pucch_mask[1112] = 8'hFF;	pucch_mask[1113] = 8'hFF;	pucch_mask[1115] = 8'hFF;	pucch_mask[1116] = 8'hFF;	pucch_mask[1117] = 8'hFF;	pucch_mask[1121] = 8'hFF;	pucch_mask[1123] = 8'hFF;
        pucch_mask[1127] = 8'hFF;	pucch_mask[1129] = 8'hFF;	pucch_mask[1132] = 8'hFF;	pucch_mask[1133] = 8'hFF;	pucch_mask[1138] = 8'hFF;	pucch_mask[1140] = 8'hFF;	pucch_mask[1141] = 8'hFF;	pucch_mask[1149] = 8'hFF;	pucch_mask[1153] = 8'hFF;	pucch_mask[1155] = 8'hFF;	pucch_mask[1156] = 8'hFF;	pucch_mask[1158] = 8'hFF;	pucch_mask[1162] = 8'hFF;	pucch_mask[1166] = 8'hFF;	pucch_mask[1171] = 8'hFF;	pucch_mask[1181] = 8'hFF;
        pucch_mask[1185] = 8'hFF;	pucch_mask[1187] = 8'hFF;	pucch_mask[1191] = 8'hFF;	pucch_mask[1193] = 8'hFF;	pucch_mask[1196] = 8'hFF;	pucch_mask[1197] = 8'hFF;	pucch_mask[1202] = 8'hFF;	pucch_mask[1204] = 8'hFF;	pucch_mask[1205] = 8'hFF;	pucch_mask[1208] = 8'hFF;	pucch_mask[1209] = 8'hFF;	pucch_mask[1211] = 8'hFF;	pucch_mask[1212] = 8'hFF;	pucch_mask[1213] = 8'hFF;	pucch_mask[1223] = 8'hFF;	pucch_mask[1225] = 8'hFF;
        pucch_mask[1228] = 8'hFF;	pucch_mask[1229] = 8'hFF;	pucch_mask[1234] = 8'hFF;	pucch_mask[1236] = 8'hFF;	pucch_mask[1237] = 8'hFF;	pucch_mask[1243] = 8'hFF;	pucch_mask[1244] = 8'hFF;	pucch_mask[1245] = 8'hFF;	pucch_mask[1252] = 8'hFF;	pucch_mask[1254] = 8'hFF;	pucch_mask[1258] = 8'hFF;	pucch_mask[1262] = 8'hFF;	pucch_mask[1267] = 8'hFF;	pucch_mask[1272] = 8'hFF;	pucch_mask[1273] = 8'hFF;	pucch_mask[1277] = 8'hFF;
        pucch_mask[1283] = 8'hFF;	pucch_mask[1284] = 8'hFF;	pucch_mask[1287] = 8'hFF;	pucch_mask[1289] = 8'hFF;	pucch_mask[1290] = 8'hFF;	pucch_mask[1292] = 8'hFF;	pucch_mask[1294] = 8'hFF;	pucch_mask[1304] = 8'hFF;	pucch_mask[1307] = 8'hFF;	pucch_mask[1309] = 8'hFF;	pucch_mask[1315] = 8'hFF;	pucch_mask[1318] = 8'hFF;	pucch_mask[1325] = 8'hFF;	pucch_mask[1330] = 8'hFF;	pucch_mask[1331] = 8'hFF;	pucch_mask[1332] = 8'hFF;
        pucch_mask[1333] = 8'hFF;	pucch_mask[1337] = 8'hFF;	pucch_mask[1340] = 8'hFF;	pucch_mask[1341] = 8'hFF;	pucch_mask[1345] = 8'hFF;	pucch_mask[1350] = 8'hFF;	pucch_mask[1357] = 8'hFF;	pucch_mask[1362] = 8'hFF;	pucch_mask[1363] = 8'hFF;	pucch_mask[1364] = 8'hFF;	pucch_mask[1365] = 8'hFF;	pucch_mask[1368] = 8'hFF;	pucch_mask[1372] = 8'hFF;	pucch_mask[1373] = 8'hFF;	pucch_mask[1377] = 8'hFF;	pucch_mask[1380] = 8'hFF;
        pucch_mask[1383] = 8'hFF;	pucch_mask[1385] = 8'hFF;	pucch_mask[1386] = 8'hFF;	pucch_mask[1388] = 8'hFF;	pucch_mask[1390] = 8'hFF;	pucch_mask[1401] = 8'hFF;	pucch_mask[1403] = 8'hFF;	pucch_mask[1405] = 8'hFF;	pucch_mask[1409] = 8'hFF;	pucch_mask[1414] = 8'hFF;	pucch_mask[1421] = 8'hFF;	pucch_mask[1426] = 8'hFF;	pucch_mask[1427] = 8'hFF;	pucch_mask[1428] = 8'hFF;	pucch_mask[1429] = 8'hFF;	pucch_mask[1433] = 8'hFF;
        pucch_mask[1435] = 8'hFF;	pucch_mask[1437] = 8'hFF;	pucch_mask[1441] = 8'hFF;	pucch_mask[1444] = 8'hFF;   pucch_mask[1447] = 8'hFF;	pucch_mask[1449] = 8'hFF;	pucch_mask[1450] = 8'hFF;	pucch_mask[1452] = 8'hFF;	pucch_mask[1454] = 8'hFF;	pucch_mask[1464] = 8'hFF;	pucch_mask[1468] = 8'hFF;	pucch_mask[1469] = 8'hFF;	pucch_mask[1475] = 8'hFF;	pucch_mask[1476] = 8'hFF;	pucch_mask[1479] = 8'hFF;	pucch_mask[1481] = 8'hFF;
        pucch_mask[1482] = 8'hFF;	pucch_mask[1484] = 8'hFF;	pucch_mask[1486] = 8'hFF;	pucch_mask[1497] = 8'hFF;	pucch_mask[1500] = 8'hFF;	pucch_mask[1501] = 8'hFF;	pucch_mask[1507] = 8'hFF;	pucch_mask[1510] = 8'hFF;	pucch_mask[1517] = 8'hFF;	pucch_mask[1522] = 8'hFF;	pucch_mask[1523] = 8'hFF;	pucch_mask[1524] = 8'hFF;	pucch_mask[1525] = 8'hFF;	pucch_mask[1528] = 8'hFF;	pucch_mask[1531] = 8'hFF;	pucch_mask[1533] = 8'hFF;
        pucch_mask[1540] = 8'hFF;	pucch_mask[1542] = 8'hFF;	pucch_mask[1543] = 8'hFF;	pucch_mask[1546] = 8'hFF;	pucch_mask[1549] = 8'hFF;	pucch_mask[1554] = 8'hFF;	pucch_mask[1555] = 8'hFF;	pucch_mask[1557] = 8'hFF;	pucch_mask[1560] = 8'hFF;	pucch_mask[1561] = 8'hFF;	pucch_mask[1564] = 8'hFF;	pucch_mask[1565] = 8'hFF;	pucch_mask[1577] = 8'hFF;	pucch_mask[1580] = 8'hFF;	pucch_mask[1582] = 8'hFF;	pucch_mask[1588] = 8'hFF;
        pucch_mask[1595] = 8'hFF;	pucch_mask[1597] = 8'hFF;	pucch_mask[1601] = 8'hFF;	pucch_mask[1603] = 8'hFF;	pucch_mask[1609] = 8'hFF;	pucch_mask[1612] = 8'hFF;	pucch_mask[1614] = 8'hFF;	pucch_mask[1620] = 8'hFF;	pucch_mask[1624] = 8'hFF;	pucch_mask[1625] = 8'hFF;	pucch_mask[1627] = 8'hFF;	pucch_mask[1629] = 8'hFF;	pucch_mask[1633] = 8'hFF;	pucch_mask[1635] = 8'hFF;	pucch_mask[1636] = 8'hFF;	pucch_mask[1638] = 8'hFF;
        pucch_mask[1639] = 8'hFF;	pucch_mask[1642] = 8'hFF;	pucch_mask[1645] = 8'hFF;	pucch_mask[1650] = 8'hFF;	pucch_mask[1651] = 8'hFF;	pucch_mask[1653] = 8'hFF;	pucch_mask[1660] = 8'hFF;	pucch_mask[1661] = 8'hFF;	pucch_mask[1665] = 8'hFF;	pucch_mask[1667] = 8'hFF;	pucch_mask[1673] = 8'hFF;	pucch_mask[1676] = 8'hFF;	pucch_mask[1678] = 8'hFF;	pucch_mask[1684] = 8'hFF;	pucch_mask[1692] = 8'hFF;	pucch_mask[1693] = 8'hFF;
        pucch_mask[1697] = 8'hFF;	pucch_mask[1699] = 8'hFF;	pucch_mask[1700] = 8'hFF;	pucch_mask[1702] = 8'hFF;	pucch_mask[1703] = 8'hFF;	pucch_mask[1706] = 8'hFF;	pucch_mask[1709] = 8'hFF;	pucch_mask[1714] = 8'hFF;	pucch_mask[1715] = 8'hFF;	pucch_mask[1717] = 8'hFF;	pucch_mask[1720] = 8'hFF;	pucch_mask[1721] = 8'hFF;	pucch_mask[1723] = 8'hFF;	pucch_mask[1725] = 8'hFF;	pucch_mask[1732] = 8'hFF;	pucch_mask[1734] = 8'hFF;
        pucch_mask[1735] = 8'hFF;	pucch_mask[1738] = 8'hFF;	pucch_mask[1741] = 8'hFF;	pucch_mask[1746] = 8'hFF;	pucch_mask[1747] = 8'hFF;	pucch_mask[1749] = 8'hFF;	pucch_mask[1755] = 8'hFF;	pucch_mask[1757] = 8'hFF;	pucch_mask[1769] = 8'hFF;	pucch_mask[1772] = 8'hFF;	pucch_mask[1774] = 8'hFF;	pucch_mask[1780] = 8'hFF;	pucch_mask[1784] = 8'hFF;	pucch_mask[1785] = 8'hFF;	pucch_mask[1788] = 8'hFF;	pucch_mask[1789] = 8'hFF;
        pucch_mask[1795] = 8'hFF;	pucch_mask[1798] = 8'hFF;	pucch_mask[1799] = 8'hFF;	pucch_mask[1806] = 8'hFF;	pucch_mask[1811] = 8'hFF;	pucch_mask[1812] = 8'hFF;	pucch_mask[1816] = 8'hFF;	pucch_mask[1819] = 8'hFF;	pucch_mask[1820] = 8'hFF;	pucch_mask[1821] = 8'hFF;	pucch_mask[1827] = 8'hFF;	pucch_mask[1828] = 8'hFF;	pucch_mask[1833] = 8'hFF;	pucch_mask[1834] = 8'hFF;	pucch_mask[1836] = 8'hFF;	pucch_mask[1837] = 8'hFF;
        pucch_mask[1842] = 8'hFF;	pucch_mask[1845] = 8'hFF;	pucch_mask[1849] = 8'hFF;	pucch_mask[1853] = 8'hFF;	pucch_mask[1857] = 8'hFF;	pucch_mask[1860] = 8'hFF;	pucch_mask[1865] = 8'hFF;	pucch_mask[1866] = 8'hFF;	pucch_mask[1868] = 8'hFF;	pucch_mask[1869] = 8'hFF;	pucch_mask[1874] = 8'hFF;	pucch_mask[1877] = 8'hFF;	pucch_mask[1880] = 8'hFF;	pucch_mask[1885] = 8'hFF;	pucch_mask[1889] = 8'hFF;	pucch_mask[1894] = 8'hFF;
        pucch_mask[1895] = 8'hFF;	pucch_mask[1902] = 8'hFF;	pucch_mask[1907] = 8'hFF;	pucch_mask[1908] = 8'hFF;	pucch_mask[1913] = 8'hFF;	pucch_mask[1915] = 8'hFF;	pucch_mask[1916] = 8'hFF;	pucch_mask[1917] = 8'hFF;	pucch_mask[1921] = 8'hFF;	pucch_mask[1924] = 8'hFF;	pucch_mask[1929] = 8'hFF;	pucch_mask[1930] = 8'hFF;	pucch_mask[1932] = 8'hFF;	pucch_mask[1933] = 8'hFF;	pucch_mask[1938] = 8'hFF;	pucch_mask[1941] = 8'hFF;
        pucch_mask[1945] = 8'hFF;	pucch_mask[1947] = 8'hFF;	pucch_mask[1948] = 8'hFF;	pucch_mask[1949] = 8'hFF;	pucch_mask[1953] = 8'hFF;	pucch_mask[1958] = 8'hFF;	pucch_mask[1959] = 8'hFF;	pucch_mask[1966] = 8'hFF;	pucch_mask[1971] = 8'hFF;	pucch_mask[1972] = 8'hFF;	pucch_mask[1976] = 8'hFF;	pucch_mask[1981] = 8'hFF;	pucch_mask[1987] = 8'hFF;	pucch_mask[1990] = 8'hFF;	pucch_mask[1991] = 8'hFF;	pucch_mask[1998] = 8'hFF;
        pucch_mask[2003] = 8'hFF;	pucch_mask[2004] = 8'hFF;	pucch_mask[2009] = 8'hFF;	pucch_mask[2013] = 8'hFF;	pucch_mask[2019] = 8'hFF;	pucch_mask[2020] = 8'hFF;	pucch_mask[2025] = 8'hFF;	pucch_mask[2026] = 8'hFF;	pucch_mask[2028] = 8'hFF;	pucch_mask[2029] = 8'hFF;	pucch_mask[2034] = 8'hFF;	pucch_mask[2037] = 8'hFF;	pucch_mask[2040] = 8'hFF;	pucch_mask[2043] = 8'hFF;	pucch_mask[2044] = 8'hFF;	pucch_mask[2045] = 8'hFF;
        pucch_mask[2052] = 8'hFF;	pucch_mask[2057] = 8'hFF;	pucch_mask[2058] = 8'hFF;	pucch_mask[2062] = 8'hFF;	pucch_mask[2064] = 8'hFF;	pucch_mask[2066] = 8'hFF;	pucch_mask[2067] = 8'hFF;	pucch_mask[2073] = 8'hFF;	pucch_mask[2075] = 8'hFF;	pucch_mask[2077] = 8'hFF;	pucch_mask[2086] = 8'hFF;	pucch_mask[2087] = 8'hFF;	pucch_mask[2092] = 8'hFF;	pucch_mask[2093] = 8'hFF;	pucch_mask[2096] = 8'hFF;	pucch_mask[2100] = 8'hFF;
        pucch_mask[2101] = 8'hFF;	pucch_mask[2104] = 8'hFF;	pucch_mask[2108] = 8'hFF;	pucch_mask[2109] = 8'hFF;	pucch_mask[2113] = 8'hFF;	pucch_mask[2115] = 8'hFF;	pucch_mask[2118] = 8'hFF;	pucch_mask[2119] = 8'hFF;	pucch_mask[2124] = 8'hFF;	pucch_mask[2125] = 8'hFF;	pucch_mask[2128] = 8'hFF;	pucch_mask[2132] = 8'hFF;	pucch_mask[2133] = 8'hFF;	pucch_mask[2137] = 8'hFF;	pucch_mask[2140] = 8'hFF;	pucch_mask[2141] = 8'hFF;
        pucch_mask[2145] = 8'hFF;	pucch_mask[2147] = 8'hFF;	pucch_mask[2148] = 8'hFF;	pucch_mask[2153] = 8'hFF;	pucch_mask[2154] = 8'hFF;	pucch_mask[2158] = 8'hFF;	pucch_mask[2160] = 8'hFF;	pucch_mask[2162] = 8'hFF;	pucch_mask[2163] = 8'hFF;	pucch_mask[2168] = 8'hFF;	pucch_mask[2171] = 8'hFF;	pucch_mask[2173] = 8'hFF;	pucch_mask[2177] = 8'hFF;	pucch_mask[2179] = 8'hFF;	pucch_mask[2182] = 8'hFF;	pucch_mask[2183] = 8'hFF;
        pucch_mask[2188] = 8'hFF;	pucch_mask[2189] = 8'hFF;	pucch_mask[2192] = 8'hFF;	pucch_mask[2196] = 8'hFF;	pucch_mask[2197] = 8'hFF;	pucch_mask[2200] = 8'hFF;	pucch_mask[2203] = 8'hFF;	pucch_mask[2205] = 8'hFF;	pucch_mask[2209] = 8'hFF;	pucch_mask[2211] = 8'hFF;	pucch_mask[2212] = 8'hFF;	pucch_mask[2217] = 8'hFF;	pucch_mask[2218] = 8'hFF;	pucch_mask[2222] = 8'hFF;	pucch_mask[2224] = 8'hFF;	pucch_mask[2226] = 8'hFF;
        pucch_mask[2227] = 8'hFF;	pucch_mask[2233] = 8'hFF;	pucch_mask[2236] = 8'hFF;	pucch_mask[2237] = 8'hFF;	pucch_mask[2244] = 8'hFF;	pucch_mask[2249] = 8'hFF;	pucch_mask[2250] = 8'hFF;	pucch_mask[2254] = 8'hFF;	pucch_mask[2256] = 8'hFF;	pucch_mask[2258] = 8'hFF;	pucch_mask[2259] = 8'hFF;	pucch_mask[2264] = 8'hFF;	pucch_mask[2268] = 8'hFF;	pucch_mask[2269] = 8'hFF;	pucch_mask[2278] = 8'hFF;	pucch_mask[2279] = 8'hFF;
        pucch_mask[2284] = 8'hFF;	pucch_mask[2285] = 8'hFF;	pucch_mask[2288] = 8'hFF;	pucch_mask[2292] = 8'hFF;	pucch_mask[2293] = 8'hFF;	pucch_mask[2297] = 8'hFF;	pucch_mask[2299] = 8'hFF;	pucch_mask[2301] = 8'hFF;	pucch_mask[2307] = 8'hFF;	pucch_mask[2313] = 8'hFF;	pucch_mask[2317] = 8'hFF;	pucch_mask[2320] = 8'hFF;	pucch_mask[2323] = 8'hFF;	pucch_mask[2324] = 8'hFF;	pucch_mask[2325] = 8'hFF;	pucch_mask[2333] = 8'hFF;
        pucch_mask[2339] = 8'hFF;	pucch_mask[2340] = 8'hFF;	pucch_mask[2342] = 8'hFF;	pucch_mask[2343] = 8'hFF;	pucch_mask[2346] = 8'hFF;   pucch_mask[2348] = 8'hFF;	pucch_mask[2350] = 8'hFF;	pucch_mask[2352] = 8'hFF;	pucch_mask[2354] = 8'hFF;	pucch_mask[2360] = 8'hFF;	pucch_mask[2361] = 8'hFF;	pucch_mask[2363] = 8'hFF;	pucch_mask[2364] = 8'hFF;	pucch_mask[2365] = 8'hFF;	pucch_mask[2369] = 8'hFF;	pucch_mask[2372] = 8'hFF;
        pucch_mask[2374] = 8'hFF;	pucch_mask[2375] = 8'hFF;	pucch_mask[2378] = 8'hFF;	pucch_mask[2380] = 8'hFF;	pucch_mask[2382] = 8'hFF;	pucch_mask[2384] = 8'hFF;	pucch_mask[2386] = 8'hFF;	pucch_mask[2395] = 8'hFF;	pucch_mask[2396] = 8'hFF;	pucch_mask[2397] = 8'hFF;	pucch_mask[2401] = 8'hFF;	pucch_mask[2409] = 8'hFF;	pucch_mask[2413] = 8'hFF;	pucch_mask[2416] = 8'hFF;	pucch_mask[2419] = 8'hFF;	pucch_mask[2420] = 8'hFF;
        pucch_mask[2421] = 8'hFF;	pucch_mask[2424] = 8'hFF;	pucch_mask[2425] = 8'hFF;	pucch_mask[2429] = 8'hFF;	pucch_mask[2433] = 8'hFF;	pucch_mask[2436] = 8'hFF;	pucch_mask[2438] = 8'hFF;	pucch_mask[2439] = 8'hFF;	pucch_mask[2442] = 8'hFF;	pucch_mask[2444] = 8'hFF;	pucch_mask[2446] = 8'hFF;	pucch_mask[2448] = 8'hFF;	pucch_mask[2450] = 8'hFF;	pucch_mask[2456] = 8'hFF;	pucch_mask[2457] = 8'hFF;	pucch_mask[2461] = 8'hFF;
        pucch_mask[2465] = 8'hFF;	pucch_mask[2473] = 8'hFF;	pucch_mask[2477] = 8'hFF;	pucch_mask[2480] = 8'hFF;	pucch_mask[2483] = 8'hFF;	pucch_mask[2484] = 8'hFF;	pucch_mask[2485] = 8'hFF;	pucch_mask[2491] = 8'hFF;	pucch_mask[2492] = 8'hFF;	pucch_mask[2493] = 8'hFF;	pucch_mask[2499] = 8'hFF;	pucch_mask[2505] = 8'hFF;	pucch_mask[2509] = 8'hFF;	pucch_mask[2512] = 8'hFF;	pucch_mask[2515] = 8'hFF;	pucch_mask[2516] = 8'hFF;
        pucch_mask[2517] = 8'hFF;	pucch_mask[2520] = 8'hFF;	pucch_mask[2521] = 8'hFF;	pucch_mask[2523] = 8'hFF;	pucch_mask[2524] = 8'hFF;	pucch_mask[2525] = 8'hFF;	pucch_mask[2531] = 8'hFF;	pucch_mask[2532] = 8'hFF;	pucch_mask[2534] = 8'hFF;	pucch_mask[2535] = 8'hFF;	pucch_mask[2538] = 8'hFF;	pucch_mask[2540] = 8'hFF;	pucch_mask[2542] = 8'hFF;	pucch_mask[2544] = 8'hFF;	pucch_mask[2546] = 8'hFF;	pucch_mask[2557] = 8'hFF;
        pucch_mask[2566] = 8'hFF;	pucch_mask[2572] = 8'hFF;	pucch_mask[2574] = 8'hFF;	pucch_mask[2576] = 8'hFF;	pucch_mask[2578] = 8'hFF;	pucch_mask[2580] = 8'hFF;	pucch_mask[2585] = 8'hFF;	pucch_mask[2587] = 8'hFF;	pucch_mask[2588] = 8'hFF;	pucch_mask[2589] = 8'hFF;	pucch_mask[2596] = 8'hFF;	pucch_mask[2599] = 8'hFF;	pucch_mask[2601] = 8'hFF;	pucch_mask[2602] = 8'hFF;	pucch_mask[2605] = 8'hFF;	pucch_mask[2608] = 8'hFF;
        pucch_mask[2611] = 8'hFF;	pucch_mask[2613] = 8'hFF;	pucch_mask[2616] = 8'hFF;	pucch_mask[2621] = 8'hFF;	pucch_mask[2625] = 8'hFF;	pucch_mask[2627] = 8'hFF;	pucch_mask[2628] = 8'hFF;	pucch_mask[2631] = 8'hFF;	pucch_mask[2633] = 8'hFF;	pucch_mask[2634] = 8'hFF;	pucch_mask[2637] = 8'hFF;	pucch_mask[2640] = 8'hFF;	pucch_mask[2643] = 8'hFF;	pucch_mask[2645] = 8'hFF;	pucch_mask[2649] = 8'hFF;	pucch_mask[2653] = 8'hFF;
        pucch_mask[2657] = 8'hFF;	pucch_mask[2659] = 8'hFF;	pucch_mask[2662] = 8'hFF;	pucch_mask[2668] = 8'hFF;	pucch_mask[2670] = 8'hFF;	pucch_mask[2672] = 8'hFF;	pucch_mask[2674] = 8'hFF;	pucch_mask[2676] = 8'hFF;	pucch_mask[2680] = 8'hFF;	pucch_mask[2683] = 8'hFF;	pucch_mask[2684] = 8'hFF;	pucch_mask[2685] = 8'hFF;	pucch_mask[2689] = 8'hFF;	pucch_mask[2691] = 8'hFF;	pucch_mask[2692] = 8'hFF;	pucch_mask[2695] = 8'hFF;
        pucch_mask[2697] = 8'hFF;	pucch_mask[2698] = 8'hFF;	pucch_mask[2701] = 8'hFF;	pucch_mask[2704] = 8'hFF;	pucch_mask[2707] = 8'hFF;	pucch_mask[2709] = 8'hFF;	pucch_mask[2712] = 8'hFF;	pucch_mask[2715] = 8'hFF;	pucch_mask[2716] = 8'hFF;	pucch_mask[2717] = 8'hFF;	pucch_mask[2721] = 8'hFF;	pucch_mask[2723] = 8'hFF;	pucch_mask[2726] = 8'hFF;	pucch_mask[2732] = 8'hFF;	pucch_mask[2734] = 8'hFF;	pucch_mask[2736] = 8'hFF;
        pucch_mask[2738] = 8'hFF;	pucch_mask[2740] = 8'hFF;	pucch_mask[2745] = 8'hFF;	pucch_mask[2749] = 8'hFF;	pucch_mask[2758] = 8'hFF;	pucch_mask[2764] = 8'hFF;	pucch_mask[2766] = 8'hFF;	pucch_mask[2768] = 8'hFF;	pucch_mask[2770] = 8'hFF;	pucch_mask[2772] = 8'hFF;	pucch_mask[2776] = 8'hFF;	pucch_mask[2781] = 8'hFF;	pucch_mask[2788] = 8'hFF;	pucch_mask[2791] = 8'hFF;	pucch_mask[2793] = 8'hFF;	pucch_mask[2794] = 8'hFF;
        pucch_mask[2797] = 8'hFF;	pucch_mask[2800] = 8'hFF;	pucch_mask[2803] = 8'hFF;	pucch_mask[2805] = 8'hFF;	pucch_mask[2809] = 8'hFF;	pucch_mask[2811] = 8'hFF;	pucch_mask[2812] = 8'hFF;	pucch_mask[2813] = 8'hFF;	pucch_mask[2819] = 8'hFF;	pucch_mask[2820] = 8'hFF;	pucch_mask[2822] = 8'hFF;	pucch_mask[2826] = 8'hFF;	pucch_mask[2828] = 8'hFF;	pucch_mask[2829] = 8'hFF;	pucch_mask[2832] = 8'hFF;	pucch_mask[2837] = 8'hFF;
        pucch_mask[2844] = 8'hFF;	pucch_mask[2845] = 8'hFF;	pucch_mask[2851] = 8'hFF;	pucch_mask[2855] = 8'hFF;	pucch_mask[2857] = 8'hFF;	pucch_mask[2862] = 8'hFF;	pucch_mask[2864] = 8'hFF;	pucch_mask[2866] = 8'hFF;	pucch_mask[2867] = 8'hFF;	pucch_mask[2868] = 8'hFF;	pucch_mask[2872] = 8'hFF;	pucch_mask[2873] = 8'hFF;	pucch_mask[2875] = 8'hFF;	pucch_mask[2877] = 8'hFF;	pucch_mask[2881] = 8'hFF;	pucch_mask[2887] = 8'hFF;
        pucch_mask[2889] = 8'hFF;	pucch_mask[2894] = 8'hFF;	pucch_mask[2896] = 8'hFF;	pucch_mask[2898] = 8'hFF;	pucch_mask[2899] = 8'hFF;	pucch_mask[2900] = 8'hFF;	pucch_mask[2907] = 8'hFF;	pucch_mask[2909] = 8'hFF;	pucch_mask[2913] = 8'hFF;	pucch_mask[2916] = 8'hFF;	pucch_mask[2918] = 8'hFF;	pucch_mask[2922] = 8'hFF;	pucch_mask[2924] = 8'hFF;	pucch_mask[2925] = 8'hFF;	pucch_mask[2928] = 8'hFF;	pucch_mask[2933] = 8'hFF;
        pucch_mask[2936] = 8'hFF;	pucch_mask[2937] = 8'hFF;	pucch_mask[2940] = 8'hFF;	pucch_mask[2941] = 8'hFF;	pucch_mask[2945] = 8'hFF;	pucch_mask[2951] = 8'hFF;	pucch_mask[2953] = 8'hFF;	pucch_mask[2958] = 8'hFF;	pucch_mask[2960] = 8'hFF;	pucch_mask[2962] = 8'hFF;	pucch_mask[2963] = 8'hFF;	pucch_mask[2964] = 8'hFF;	pucch_mask[2968] = 8'hFF;	pucch_mask[2969] = 8'hFF;	pucch_mask[2972] = 8'hFF;	pucch_mask[2973] = 8'hFF;
        pucch_mask[2977] = 8'hFF;	pucch_mask[2980] = 8'hFF;	pucch_mask[2982] = 8'hFF;	pucch_mask[2986] = 8'hFF;	pucch_mask[2988] = 8'hFF;	pucch_mask[2989] = 8'hFF;	pucch_mask[2992] = 8'hFF;	pucch_mask[2997] = 8'hFF;	pucch_mask[3003] = 8'hFF;	pucch_mask[3005] = 8'hFF;	pucch_mask[3011] = 8'hFF;	pucch_mask[3012] = 8'hFF;	pucch_mask[3014] = 8'hFF;	pucch_mask[3018] = 8'hFF;	pucch_mask[3020] = 8'hFF;	pucch_mask[3021] = 8'hFF;
        pucch_mask[3024] = 8'hFF;	pucch_mask[3029] = 8'hFF;	pucch_mask[3032] = 8'hFF;	pucch_mask[3033] = 8'hFF;	pucch_mask[3035] = 8'hFF;	pucch_mask[3037] = 8'hFF;	pucch_mask[3043] = 8'hFF;	pucch_mask[3047] = 8'hFF;	pucch_mask[3049] = 8'hFF;	pucch_mask[3054] = 8'hFF;	pucch_mask[3056] = 8'hFF;	pucch_mask[3058] = 8'hFF;	pucch_mask[3059] = 8'hFF;	pucch_mask[3060] = 8'hFF;	pucch_mask[3068] = 8'hFF;	pucch_mask[3069] = 8'hFF;
        pucch_mask[3076] = 8'hFF;	pucch_mask[3079] = 8'hFF;	pucch_mask[3082] = 8'hFF;	pucch_mask[3084] = 8'hFF;	pucch_mask[3085] = 8'hFF;	pucch_mask[3086] = 8'hFF;	pucch_mask[3088] = 8'hFF;	pucch_mask[3091] = 8'hFF;	pucch_mask[3092] = 8'hFF;	pucch_mask[3093] = 8'hFF;	pucch_mask[3096] = 8'hFF;	pucch_mask[3099] = 8'hFF;	pucch_mask[3110] = 8'hFF;	pucch_mask[3113] = 8'hFF;	pucch_mask[3120] = 8'hFF;	pucch_mask[3122] = 8'hFF;
        pucch_mask[3129] = 8'hFF;	pucch_mask[3132] = 8'hFF;	pucch_mask[3137] = 8'hFF;	pucch_mask[3139] = 8'hFF;	pucch_mask[3142] = 8'hFF;	pucch_mask[3145] = 8'hFF;	pucch_mask[3152] = 8'hFF;	pucch_mask[3154] = 8'hFF;	pucch_mask[3160] = 8'hFF;	pucch_mask[3164] = 8'hFF;	pucch_mask[3169] = 8'hFF;	pucch_mask[3171] = 8'hFF;	pucch_mask[3172] = 8'hFF;	pucch_mask[3175] = 8'hFF;	pucch_mask[3178] = 8'hFF;	pucch_mask[3180] = 8'hFF;
        pucch_mask[3181] = 8'hFF;	pucch_mask[3182] = 8'hFF;	pucch_mask[3184] = 8'hFF;	pucch_mask[3187] = 8'hFF;	pucch_mask[3188] = 8'hFF;	pucch_mask[3189] = 8'hFF;	pucch_mask[3193] = 8'hFF;	pucch_mask[3195] = 8'hFF;	pucch_mask[3201] = 8'hFF;	pucch_mask[3203] = 8'hFF;	pucch_mask[3206] = 8'hFF;	pucch_mask[3209] = 8'hFF;	pucch_mask[3216] = 8'hFF;	pucch_mask[3218] = 8'hFF;	pucch_mask[3225] = 8'hFF;	pucch_mask[3227] = 8'hFF;
        pucch_mask[3233] = 8'hFF;	pucch_mask[3235] = 8'hFF;	pucch_mask[3236] = 8'hFF;	pucch_mask[3239] = 8'hFF;	pucch_mask[3242] = 8'hFF;	pucch_mask[3244] = 8'hFF;	pucch_mask[3245] = 8'hFF;	pucch_mask[3246] = 8'hFF;	pucch_mask[3248] = 8'hFF;	pucch_mask[3251] = 8'hFF;	pucch_mask[3252] = 8'hFF;	pucch_mask[3253] = 8'hFF;	pucch_mask[3256] = 8'hFF;	pucch_mask[3260] = 8'hFF;	pucch_mask[3268] = 8'hFF;	pucch_mask[3271] = 8'hFF;
        pucch_mask[3274] = 8'hFF;	pucch_mask[3276] = 8'hFF;	pucch_mask[3277] = 8'hFF;	pucch_mask[3278] = 8'hFF;	pucch_mask[3280] = 8'hFF;	pucch_mask[3283] = 8'hFF;	pucch_mask[3284] = 8'hFF;	pucch_mask[3285] = 8'hFF;	pucch_mask[3289] = 8'hFF;	pucch_mask[3292] = 8'hFF;	pucch_mask[3302] = 8'hFF;	pucch_mask[3305] = 8'hFF;	pucch_mask[3312] = 8'hFF;	pucch_mask[3314] = 8'hFF;	pucch_mask[3320] = 8'hFF;	pucch_mask[3323] = 8'hFF;
        pucch_mask[3331] = 8'hFF;	pucch_mask[3335] = 8'hFF;	pucch_mask[3340] = 8'hFF;	pucch_mask[3344] = 8'hFF;	pucch_mask[3346] = 8'hFF;	pucch_mask[3347] = 8'hFF;	pucch_mask[3352] = 8'hFF;	pucch_mask[3353] = 8'hFF;	pucch_mask[3363] = 8'hFF;	pucch_mask[3364] = 8'hFF;	pucch_mask[3366] = 8'hFF;	pucch_mask[3369] = 8'hFF;	pucch_mask[3370] = 8'hFF;	pucch_mask[3373] = 8'hFF;	pucch_mask[3374] = 8'hFF;	pucch_mask[3376] = 8'hFF;
        pucch_mask[3380] = 8'hFF;	pucch_mask[3381] = 8'hFF;	pucch_mask[3387] = 8'hFF;	pucch_mask[3388] = 8'hFF;	pucch_mask[3393] = 8'hFF;	pucch_mask[3396] = 8'hFF;	pucch_mask[3398] = 8'hFF;	pucch_mask[3401] = 8'hFF;	pucch_mask[3402] = 8'hFF;	pucch_mask[3405] = 8'hFF;	pucch_mask[3406] = 8'hFF;	pucch_mask[3408] = 8'hFF;	pucch_mask[3412] = 8'hFF;	pucch_mask[3413] = 8'hFF;	pucch_mask[3416] = 8'hFF;   pucch_mask[3417] = 8'hFF;
        pucch_mask[3419] = 8'hFF;	pucch_mask[3420] = 8'hFF;	pucch_mask[3425] = 8'hFF;	pucch_mask[3431] = 8'hFF;	pucch_mask[3436] = 8'hFF;	pucch_mask[3440] = 8'hFF;	pucch_mask[3442] = 8'hFF;	pucch_mask[3443] = 8'hFF;	pucch_mask[3457] = 8'hFF;	pucch_mask[3460] = 8'hFF;	pucch_mask[3462] = 8'hFF;	pucch_mask[3465] = 8'hFF;	pucch_mask[3466] = 8'hFF;	pucch_mask[3469] = 8'hFF;	pucch_mask[3470] = 8'hFF;	pucch_mask[3472] = 8'hFF;
        pucch_mask[3476] = 8'hFF;	pucch_mask[3477] = 8'hFF;	pucch_mask[3489] = 8'hFF;	pucch_mask[3495] = 8'hFF;	pucch_mask[3500] = 8'hFF;	pucch_mask[3504] = 8'hFF;	pucch_mask[3506] = 8'hFF;	pucch_mask[3507] = 8'hFF;	pucch_mask[3512] = 8'hFF;	pucch_mask[3513] = 8'hFF;	pucch_mask[3515] = 8'hFF;	pucch_mask[3516] = 8'hFF;	pucch_mask[3523] = 8'hFF;	pucch_mask[3527] = 8'hFF;	pucch_mask[3532] = 8'hFF;	pucch_mask[3536] = 8'hFF;
        pucch_mask[3538] = 8'hFF;	pucch_mask[3539] = 8'hFF;	pucch_mask[3547] = 8'hFF;	pucch_mask[3548] = 8'hFF;	pucch_mask[3555] = 8'hFF;	pucch_mask[3556] = 8'hFF;	pucch_mask[3558] = 8'hFF;	pucch_mask[3561] = 8'hFF;	pucch_mask[3562] = 8'hFF;	pucch_mask[3565] = 8'hFF;	pucch_mask[3566] = 8'hFF;	pucch_mask[3568] = 8'hFF;	pucch_mask[3572] = 8'hFF;	pucch_mask[3573] = 8'hFF;	pucch_mask[3576] = 8'hFF;	pucch_mask[3577] = 8'hFF;
        pucch_mask[3590] = 8'hFF;	pucch_mask[3591] = 8'hFF;	pucch_mask[3593] = 8'hFF;	pucch_mask[3597] = 8'hFF;	pucch_mask[3598] = 8'hFF;	pucch_mask[3600] = 8'hFF;	pucch_mask[3605] = 8'hFF;	pucch_mask[3608] = 8'hFF;	pucch_mask[3611] = 8'hFF;	pucch_mask[3612] = 8'hFF;	pucch_mask[3620] = 8'hFF;	pucch_mask[3626] = 8'hFF;	pucch_mask[3628] = 8'hFF;	pucch_mask[3632] = 8'hFF;	pucch_mask[3634] = 8'hFF;	pucch_mask[3635] = 8'hFF;
        pucch_mask[3636] = 8'hFF;	pucch_mask[3641] = 8'hFF;	pucch_mask[3649] = 8'hFF;	pucch_mask[3651] = 8'hFF;	pucch_mask[3652] = 8'hFF;	pucch_mask[3658] = 8'hFF;	pucch_mask[3660] = 8'hFF;	pucch_mask[3664] = 8'hFF;	pucch_mask[3666] = 8'hFF;	pucch_mask[3667] = 8'hFF;	pucch_mask[3668] = 8'hFF;	pucch_mask[3672] = 8'hFF;	pucch_mask[3681] = 8'hFF;	pucch_mask[3683] = 8'hFF;	pucch_mask[3686] = 8'hFF;	pucch_mask[3687] = 8'hFF;
        pucch_mask[3689] = 8'hFF;	pucch_mask[3693] = 8'hFF;	pucch_mask[3694] = 8'hFF;	pucch_mask[3696] = 8'hFF;	pucch_mask[3701] = 8'hFF;	pucch_mask[3705] = 8'hFF;	pucch_mask[3707] = 8'hFF;	pucch_mask[3708] = 8'hFF;	pucch_mask[3713] = 8'hFF;	pucch_mask[3715] = 8'hFF;	pucch_mask[3716] = 8'hFF;	pucch_mask[3722] = 8'hFF;	pucch_mask[3724] = 8'hFF;	pucch_mask[3728] = 8'hFF;	pucch_mask[3730] = 8'hFF;	pucch_mask[3731] = 8'hFF;
        pucch_mask[3732] = 8'hFF;	pucch_mask[3737] = 8'hFF;	pucch_mask[3739] = 8'hFF;	pucch_mask[3740] = 8'hFF;	pucch_mask[3745] = 8'hFF;	pucch_mask[3747] = 8'hFF;	pucch_mask[3750] = 8'hFF;	pucch_mask[3751] = 8'hFF;	pucch_mask[3753] = 8'hFF;	pucch_mask[3757] = 8'hFF;	pucch_mask[3758] = 8'hFF;	pucch_mask[3760] = 8'hFF;	pucch_mask[3765] = 8'hFF;	pucch_mask[3768] = 8'hFF;	pucch_mask[3782] = 8'hFF;	pucch_mask[3783] = 8'hFF;
        pucch_mask[3785] = 8'hFF;	pucch_mask[3789] = 8'hFF;	pucch_mask[3790] = 8'hFF;	pucch_mask[3792] = 8'hFF;	pucch_mask[3797] = 8'hFF;	pucch_mask[3801] = 8'hFF;	pucch_mask[3812] = 8'hFF;	pucch_mask[3818] = 8'hFF;	pucch_mask[3820] = 8'hFF;	pucch_mask[3824] = 8'hFF;	pucch_mask[3826] = 8'hFF;	pucch_mask[3827] = 8'hFF;	pucch_mask[3828] = 8'hFF;	pucch_mask[3832] = 8'hFF;	pucch_mask[3835] = 8'hFF;	pucch_mask[3836] = 8'hFF;
        pucch_mask[3843] = 8'hFF;	pucch_mask[3844] = 8'hFF;	pucch_mask[3846] = 8'hFF;	pucch_mask[3847] = 8'hFF;	pucch_mask[3849] = 8'hFF;	pucch_mask[3850] = 8'hFF;	pucch_mask[3856] = 8'hFF;	pucch_mask[3858] = 8'hFF;	pucch_mask[3860] = 8'hFF;	pucch_mask[3864] = 8'hFF;	pucch_mask[3865] = 8'hFF;	pucch_mask[3868] = 8'hFF;	pucch_mask[3875] = 8'hFF;	pucch_mask[3884] = 8'hFF;	pucch_mask[3885] = 8'hFF;	pucch_mask[3886] = 8'hFF;
        pucch_mask[3888] = 8'hFF;	pucch_mask[3891] = 8'hFF;	pucch_mask[3893] = 8'hFF;	pucch_mask[3899] = 8'hFF;	pucch_mask[3905] = 8'hFF;	pucch_mask[3916] = 8'hFF;	pucch_mask[3917] = 8'hFF;	pucch_mask[3918] = 8'hFF;	pucch_mask[3920] = 8'hFF;	pucch_mask[3923] = 8'hFF;	pucch_mask[3925] = 8'hFF;	pucch_mask[3928] = 8'hFF;	pucch_mask[3929] = 8'hFF;	pucch_mask[3931] = 8'hFF;	pucch_mask[3937] = 8'hFF;	pucch_mask[3940] = 8'hFF;
        pucch_mask[3942] = 8'hFF;	pucch_mask[3943] = 8'hFF;	pucch_mask[3945] = 8'hFF;	pucch_mask[3946] = 8'hFF;	pucch_mask[3952] = 8'hFF;	pucch_mask[3954] = 8'hFF;	pucch_mask[3956] = 8'hFF;	pucch_mask[3964] = 8'hFF;	pucch_mask[3969] = 8'hFF;	pucch_mask[3980] = 8'hFF;	pucch_mask[3981] = 8'hFF;	pucch_mask[3982] = 8'hFF;	pucch_mask[3984] = 8'hFF;	pucch_mask[3987] = 8'hFF;	pucch_mask[3989] = 8'hFF;	pucch_mask[3996] = 8'hFF;
        pucch_mask[4001] = 8'hFF;	pucch_mask[4004] = 8'hFF;	pucch_mask[4006] = 8'hFF;	pucch_mask[4007] = 8'hFF;	pucch_mask[4009] = 8'hFF;	pucch_mask[4010] = 8'hFF;	pucch_mask[4016] = 8'hFF;	pucch_mask[4018] = 8'hFF;	pucch_mask[4020] = 8'hFF;	pucch_mask[4024] = 8'hFF;	pucch_mask[4025] = 8'hFF;	pucch_mask[4027] = 8'hFF;	pucch_mask[4035] = 8'hFF;	pucch_mask[4036] = 8'hFF;	pucch_mask[4038] = 8'hFF;	pucch_mask[4039] = 8'hFF;
        pucch_mask[4041] = 8'hFF;	pucch_mask[4042] = 8'hFF;	pucch_mask[4048] = 8'hFF;	pucch_mask[4050] = 8'hFF;	pucch_mask[4052] = 8'hFF;	pucch_mask[4059] = 8'hFF;	pucch_mask[4067] = 8'hFF;	pucch_mask[4076] = 8'hFF;	pucch_mask[4077] = 8'hFF;	pucch_mask[4078] = 8'hFF;	pucch_mask[4080] = 8'hFF;	pucch_mask[4083] = 8'hFF;	pucch_mask[4085] = 8'hFF;	pucch_mask[4088] = 8'hFF;	pucch_mask[4089] = 8'hFF;	pucch_mask[4092] = 8'hFF;
    end

   
    reg [7:0] permutation_for_A20 [32];

    initial begin
        permutation_for_A20[0] = 8'h20;     permutation_for_A20[1] = 8'h01;     permutation_for_A20[2] = 8'h15;     permutation_for_A20[3] = 8'h02;
        permutation_for_A20[4] = 8'h03;     permutation_for_A20[5] = 8'h16;     permutation_for_A20[6] = 8'h04;     permutation_for_A20[7] = 8'h05;
        permutation_for_A20[8] = 8'h17;     permutation_for_A20[9] = 8'h06;     permutation_for_A20[10] = 8'h07;    permutation_for_A20[11] = 8'h18;
        permutation_for_A20[12] = 8'h08;    permutation_for_A20[13] = 8'h09;    permutation_for_A20[14] = 8'h0A;    permutation_for_A20[15] = 8'h19;
        permutation_for_A20[16] = 8'h14;    permutation_for_A20[17] = 8'h1A;    permutation_for_A20[18] = 8'h0B;    permutation_for_A20[19] = 8'h0C;
        permutation_for_A20[20] = 8'h0D;    permutation_for_A20[21] = 8'h0E;    permutation_for_A20[22] = 8'h1B;    permutation_for_A20[23] = 8'h1C;
        permutation_for_A20[24] = 8'h0F;    permutation_for_A20[25] = 8'h10;    permutation_for_A20[26] = 8'h1D;    permutation_for_A20[27] = 8'h11;
        permutation_for_A20[28] = 8'h12;    permutation_for_A20[29] = 8'h13;    permutation_for_A20[30] = 8'h1E;    permutation_for_A20[31] = 8'h1F;
    end

   
	integer j = 0; 
	reg [7:0] count = 0;

 	reg 		[DATA_WIDTH - 1:0] rx_symbols_extended [32] = '{32{0}};
    reg signed  [DATA_WIDTH - 1:0] rx_symbols_interleaved [32] = '{32{0}};
	reg signed  [DATA_WIDTH - 1:0] de_masked [32]; 
	reg signed  [DATA_WIDTH - 1:0] de_masked_reg [32]; 
    reg signed  [DATA_WIDTH + 1:0] vec [32]; 
    reg signed  [DATA_WIDTH + 2:0] vec1 [32]; 
    reg signed  [DATA_WIDTH + 3:0] vec2 [32];
    reg signed  [DATA_WIDTH + 3:0] vec2_reg [32];
    reg signed  [DATA_WIDTH + 4:0] vec3 [32];  
    //
    reg signed  [DATA_WIDTH + 5:0] vec4 [32]; 
    reg signed  [DATA_WIDTH + 5:0] vec4_reg [32]; 
    reg signed  [DATA_WIDTH + 5:0] absolute [32]; 
    reg         [DATA_WIDTH + 5:0] max_i;
    reg         [DATA_WIDTH + 5:0] max_val;
    reg [3:0] counter_right = 0;
    reg [7:0] code_length_latch;
    
    //
    reg [7:0] index_i;
    reg [7:0] max_row;
    reg [7:0] max_column;
    reg sign;
    reg s_axis_tready_i;

	reg s_axis_tlast_delay;
	reg s_axis_tlast_delay0;

    reg [12:0] decoded_bits;
    reg decoded_bit_srl;

    reg m_axis_tvalid_i;
    reg m_axis_tlast_i;
    
    reg m_axis_tvalid_reg;
    reg m_axis_tlast_reg;
    reg m_axis_tdata_reg;

    // latch code_length
    always_ff @(posedge clk) begin
        if (code_length_valid)
            code_length_latch <= code_length;
    end 

    // extend symbols
    always_ff @(posedge clk) begin
		if (state == SEND_DATA) begin
			foreach (rx_symbols_extended[i]) begin
                rx_symbols_extended[i] <= {DATA_WIDTH{1'b0}};
            end
		end else if (s_axis_tvalid && s_axis_tready_i) begin
			rx_symbols_extended[NUM_SYMBOLS - 1] <= s_axis_tdata;
            for (int i = (NUM_SYMBOLS - 1); i > 0 ; i--) begin
                rx_symbols_extended[i-1] <= rx_symbols_extended[i];
            end
        end
    end

    // permution data
	always_ff @(posedge clk) begin
		if (state == SEND_DATA) 
			foreach (rx_symbols_interleaved[i]) 
                rx_symbols_interleaved[i] <= {DATA_WIDTH{1'b0}};
 		else if (s_axis_tlast_delay) 
			for (int i = 1; i < 32; i++) 
				rx_symbols_interleaved[i] <= rx_symbols_extended[(permutation_for_A20[i]) - 1];
	end 

	always_ff @(posedge clk) begin
		if (!s_axis_aresetn)
			s_axis_tlast_delay <= {1'b0};
		else if (s_axis_tvalid && s_axis_tlast) 
			s_axis_tlast_delay <= s_axis_tlast;
		else
			s_axis_tlast_delay <= 1'b0;
	end

	always_ff @(posedge clk) begin
		s_axis_tlast_delay0 <= s_axis_tlast_delay;
	end

	// FSM
	typedef enum { IDLE, DE_MASK, DE_MASK_REG, HADAMARD_STAGE_0, HADAMARD_REG_0, HADAMARD_STAGE_1, HADAMARD_REG_1, FIND_MAX, SEND_DATA, DLY, XXX } statetype;
	statetype state, next_state;


	always_ff @(posedge clk)
		if (!s_axis_aresetn) state <= IDLE;
		else state <= next_state;

    always_comb begin
		next_state = XXX;
		case (state)
		    IDLE 			    :   if (s_axis_tlast_delay0)  		
                                        next_state = DE_MASK;
		    					    else						
                                        next_state = IDLE;
		    DE_MASK		        : 	    next_state = DE_MASK_REG;
		    DE_MASK_REG		    : 	    next_state = HADAMARD_STAGE_0;
		    HADAMARD_STAGE_0	: 	    next_state = HADAMARD_REG_0;
            HADAMARD_REG_0      :       next_state = HADAMARD_STAGE_1;
            HADAMARD_STAGE_1	: 	    next_state = HADAMARD_REG_1;
            HADAMARD_REG_1	    : 	    next_state = FIND_MAX;    
            FIND_MAX            :   if (code_length_latch > 6 && count < 128) 
                                        next_state = DE_MASK;
                                    else if (count == 128 || code_length_latch <= 6)                      
                                        next_state = SEND_DATA;
                                    else
                                        next_state = FIND_MAX;
            SEND_DATA           :   if (counter_right == code_length_latch - 1 && m_axis_tready)                      
                                        next_state = IDLE;
                                    else
                                        next_state = SEND_DATA;
            DLY                 :       next_state = IDLE;
		    default 		    : 	    next_state = XXX;
		endcase
	end


    always_comb begin
		case (state)
		IDLE	: begin
                count = 0;
                j = 0;
                max_i = 0;
                max_val = 0;
                m_axis_tvalid_i = 0;
                // counter_right = {4{1'b0}};
                m_axis_tlast_i = 1'b0;
				decoded_bit_srl = 1'b0;

				foreach (de_masked[i]) begin
                    de_masked[i] = {DATA_WIDTH{1'b0}};
                end
				

		end
		DE_MASK	: begin
                if (code_length_latch > 6) begin
                    for (int i = 0; i < 32; i++) begin
                        de_masked[i] = (pucch_mask[i+j][7]) ? (~rx_symbols_interleaved[i] + 1) : rx_symbols_interleaved[i]; // mult on pucch_mask
                    end
                    j = j + 32;
                end
                else
                    for (int i = 0; i < 32; i++) begin
                        de_masked[i] = rx_symbols_interleaved[i];
                    end
        end 
		DE_MASK_REG : begin
		end
        HADAMARD_STAGE_0	: begin
                count = count + 1;

                for (int i = 0; i < 16; i++) begin
                    vec[i] = de_masked_reg[i] + de_masked_reg[i+16];
                    vec[i+16] = de_masked_reg[i] - de_masked_reg[i+16];
                end

                for (int i = 0; i < 8; i++) begin
                    vec1[i]    = vec[i] + vec[i+8];
                    vec1[i+8]  = vec[i] - vec[i+8];
                    vec1[i+16] = vec[i+16] + vec[i+24];
                    vec1[i+24] = vec[i+16] - vec[i+24];
                end

                for (int i = 0; i < 4; i++) begin // 8 matlab
                    // part 1
                    vec2[i]    = vec1[i] + vec1[i+4];
                    vec2[i+4]  = vec1[i] - vec1[i+4];
                    vec2[i+8]  = vec1[i+8] + vec1[i+12];
                    vec2[i+12] = vec1[i+8] - vec1[i+12];
                    // part 2 
                    vec2[i+16] = vec1[i+16] + vec1[i+20];
                    vec2[i+20] = vec1[i+16] - vec1[i+20];
                    vec2[i+24] = vec1[i+24] + vec1[i+28];
                    vec2[i+28] = vec1[i+24] - vec1[i+28];
                end
        end

        HADAMARD_REG_0 : begin
        end

        HADAMARD_STAGE_1 : begin

               for (int i = 0; i < 2; i++) begin // 4 matlab
                   vec3[i]    = vec2_reg[i]    + vec2_reg[i+2];
                   vec3[i+2]  = vec2_reg[i]    - vec2_reg[i+2];
                   vec3[i+4]  = vec2_reg[i+4]  + vec2_reg[i+6];
                   vec3[i+6]  = vec2_reg[i+4]  - vec2_reg[i+6];
                   vec3[i+8]  = vec2_reg[i+8]  + vec2_reg[i+10];
                   vec3[i+10] = vec2_reg[i+8]  - vec2_reg[i+10];
                   vec3[i+12] = vec2_reg[i+12] + vec2_reg[i+14];
                   vec3[i+14] = vec2_reg[i+12] - vec2_reg[i+14];
                   vec3[i+16] = vec2_reg[i+16] + vec2_reg[i+18];
                   vec3[i+18] = vec2_reg[i+16] - vec2_reg[i+18];
                   vec3[i+20] = vec2_reg[i+20] + vec2_reg[i+22];
                   vec3[i+22] = vec2_reg[i+20] - vec2_reg[i+22];
                   vec3[i+24] = vec2_reg[i+24] + vec2_reg[i+26];
                   vec3[i+26] = vec2_reg[i+24] - vec2_reg[i+26];
                   vec3[i+28] = vec2_reg[i+28] + vec2_reg[i+30];
                   vec3[i+30] = vec2_reg[i+28] - vec2_reg[i+30];
               end

               for (int i = 0; i < 1; i++) begin // 2 matlab
                   vec4[i]    = vec3[i]    + vec3[i+1];
                   vec4[i+1]  = vec3[i]    - vec3[i+1];
                   vec4[i+2]  = vec3[i+2]  + vec3[i+3];
                   vec4[i+3]  = vec3[i+2]  - vec3[i+3];
                   vec4[i+4]  = vec3[i+4]  + vec3[i+5];
                   vec4[i+5]  = vec3[i+4]  - vec3[i+5];
                   vec4[i+6]  = vec3[i+6]  + vec3[i+7];
                   vec4[i+7]  = vec3[i+6]  - vec3[i+7];
                   vec4[i+8]  = vec3[i+8]  + vec3[i+9];
                   vec4[i+9]  = vec3[i+8]  - vec3[i+9];
                   vec4[i+10] = vec3[i+10] + vec3[i+11];
                   vec4[i+11] = vec3[i+10] - vec3[i+11];
                   vec4[i+12] = vec3[i+12] + vec3[i+13];
                   vec4[i+13] = vec3[i+12] - vec3[i+13];
                   vec4[i+14] = vec3[i+14] + vec3[i+15];
                   vec4[i+15] = vec3[i+14] - vec3[i+15];
                   vec4[i+16] = vec3[i+16] + vec3[i+17];
                   vec4[i+17] = vec3[i+16] - vec3[i+17];
                   vec4[i+18] = vec3[i+18] + vec3[i+19];
                   vec4[i+19] = vec3[i+18] - vec3[i+19];
                   vec4[i+20] = vec3[i+20] + vec3[i+21];
                   vec4[i+21] = vec3[i+20] - vec3[i+21];
                   vec4[i+22] = vec3[i+22] + vec3[i+23];
                   vec4[i+23] = vec3[i+22] - vec3[i+23];
                   vec4[i+24] = vec3[i+24] + vec3[i+25];
                   vec4[i+25] = vec3[i+24] - vec3[i+25];
                   vec4[i+26] = vec3[i+26] + vec3[i+27];
                   vec4[i+27] = vec3[i+26] - vec3[i+27];
                   vec4[i+28] = vec3[i+28] + vec3[i+29];
                   vec4[i+29] = vec3[i+28] - vec3[i+29];
                   vec4[i+30] = vec3[i+30] + vec3[i+31];
                   vec4[i+31] = vec3[i+30] - vec3[i+31];
               end
            end 

            HADAMARD_REG_1 : begin
                max_i = 0;
            end

            FIND_MAX : begin
                // abs(A)
                for (int i = 0; i < 32; i++) begin
                    absolute[i] = (vec4_reg[i][DATA_WIDTH+4]) ? (~vec4_reg[i] + 1) : vec4_reg[i];
                end

                // Find max value in current array
                for (int i = 0; i < 32; i++) begin
                    if (max_i < absolute[i]) begin
                        max_i = absolute[i];
                        index_i = i;
                    end
                end

                if (max_i > max_val) begin
                    max_val = max_i;
                    max_row = (code_length_latch > 6 ) ? count - 1 : 0;
                    max_column = index_i;
                    sign = (vec4_reg[max_column] > 0) ? 1'b1 : 1'b0;
                end
                decoded_bits = {sign, max_column[0], max_column[1], max_column[2], max_column[3], max_column[4], max_row[6:0]};
            end

            SEND_DATA : begin
                if (m_axis_tready) begin
                    decoded_bit_srl = decoded_bits[13-counter_right-1]; 
                    m_axis_tvalid_i = 1'b1;
                    // m_axis_tlast_i = (counter_right == code_length_latch - 1) ? 1'b1 : 1'b0;
                end else
                    m_axis_tvalid_i = 1'b0;
                    // m_axis_tlast_i = 1'b0;

                if (m_axis_tready && (counter_right == code_length_latch - 1)) 
                    m_axis_tlast_i = 1'b1;
                else
                    m_axis_tlast_i = 1'b0;


                end
		endcase
	end

    always_ff @(posedge clk) begin
        if (m_axis_tready && m_axis_tvalid_i) begin
            counter_right <= (counter_right == code_length_latch - 1) ? {4{1'b0}} : counter_right + 1;  
        end

		de_masked_reg <= de_masked;
        vec2_reg <= vec2;
        vec4_reg <= vec4;
    end


    always_ff @(posedge clk) begin
        if (!s_axis_aresetn || state > IDLE)
            s_axis_tready_i <= 1'b0;
        else 
            s_axis_tready_i <= 1'b1;
    end

    always_ff @(posedge clk) begin
        if (!s_axis_aresetn) begin
            m_axis_tvalid_reg <= 1'b0;
            m_axis_tlast_reg <= 1'b0;
            m_axis_tdata_reg <= 1'b0;
        end else
            m_axis_tvalid_reg <= m_axis_tvalid_i;
            m_axis_tlast_reg <= m_axis_tlast_i;
            m_axis_tdata_reg <= decoded_bit_srl;
    end

    assign m_axis_tdata = decoded_bit_srl;
    assign s_axis_tready = s_axis_tready_i;
    assign m_axis_tvalid = m_axis_tvalid_i;
    assign m_axis_tlast = m_axis_tlast_i;


  	// debug
  	// integer hadamard_out, hadamard_check;
  	// string line, line_m;
  	// integer de_masked_check;
  	// integer k = 0;


	// initial begin
	// 	hadamard_check = $fopen("E:/Netlist/CRAT/8bit/BlockCode(A20)/test_data/hadamard_transform_check_8_bit.txt", "r");
	// 	de_masked_check = $fopen("E:/Netlist/CRAT/8bit/BlockCode(A20)/test_data/de_masked_check_8_bit.txt", "r");
	// end

//    always_comb begin
//        if (state == DE_MASK && code_length_latch == 7) begin
//            foreach(de_masked[i]) begin
//                $fgets(line_m, de_masked_check);
//                $display ((k+i),line_m.atoi(), de_masked[i]);
//                if (line_m.atoi() !== de_masked[i]) begin
// 	    			$display ("error");
//                    $finish;
//                end
//            end  
//            k = k + 32;
//        end
//    end

	// always_comb begin
	//     if (state == HADAMARD_REG_1 && code_length_latch == 7) begin
	//         foreach(vec4[i]) begin
	//             $fgets(line, hadamard_check);
	//             $display ((k+i),line.atoi(), vec4[i]);
	//             if (line.atoi() !== vec4[i]) begin
	//     			$display ("error");
	//                 $finish;
	//             end
	//         end  
	//         k = k + 32;
	//         $display("debug check complete");
	//     end
	// end

endmodule
