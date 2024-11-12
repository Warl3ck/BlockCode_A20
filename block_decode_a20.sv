`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2024 14:20:20
// Design Name: 
// Module Name: block_decode_a20
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


module block_decode_a20 #(

		parameter DATA_WIDTH = 8,
		localparam NUM_SYMBOLS = 20
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
    input [3:0] code_length;
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



    reg pucch_mask [4096] = '{4096{1'b0}};

    initial begin // -1 index matlab 
        pucch_mask[36] =   1'b1;	pucch_mask[38] =   1'b1;    pucch_mask[39] =   1'b1;	pucch_mask[41] =   1'b1;	pucch_mask[42] =   1'b1;	pucch_mask[44] =   1'b1;	pucch_mask[45] =   1'b1;	pucch_mask[46] =   1'b1;	pucch_mask[50] =   1'b1;	pucch_mask[51] =   1'b1;	pucch_mask[52] =   1'b1;	pucch_mask[53] =   1'b1;	pucch_mask[56] =   1'b1;	pucch_mask[57] =   1'b1;	pucch_mask[59] =   1'b1;	pucch_mask[60] =   1'b1;	    
        pucch_mask[65] =   1'b1;	pucch_mask[67] =   1'b1;    pucch_mask[68] =   1'b1;	pucch_mask[70] =   1'b1;	pucch_mask[71] =   1'b1;	pucch_mask[73] =   1'b1;	pucch_mask[74] =   1'b1;	pucch_mask[76] =   1'b1;	pucch_mask[77] =   1'b1;	pucch_mask[78] =   1'b1;	pucch_mask[82] =   1'b1;	pucch_mask[83] =   1'b1;	pucch_mask[84] =   1'b1;	pucch_mask[85] =   1'b1;	pucch_mask[91] =   1'b1;	pucch_mask[92] =   1'b1;
        pucch_mask[97] =   1'b1;	pucch_mask[99] =   1'b1;    pucch_mask[120] =  1'b1;	pucch_mask[121] =  1'b1;	pucch_mask[129] =  1'b1;	pucch_mask[131] =  1'b1;	pucch_mask[132] =  1'b1;	pucch_mask[134] =  1'b1;	pucch_mask[135] =  1'b1;	pucch_mask[137] =  1'b1;	pucch_mask[138] =  1'b1;	pucch_mask[140] =  1'b1;	pucch_mask[141] =  1'b1;	pucch_mask[142] =  1'b1;	pucch_mask[146] =  1'b1;	pucch_mask[147] =  1'b1;
        pucch_mask[148] =  1'b1;	pucch_mask[149] =  1'b1;    pucch_mask[152] =  1'b1;	pucch_mask[153] =  1'b1;	pucch_mask[161] =  1'b1;	pucch_mask[163] =  1'b1;	pucch_mask[187] =  1'b1;	pucch_mask[188] =  1'b1;	pucch_mask[216] =  1'b1;	pucch_mask[217] =  1'b1;	pucch_mask[219] =  1'b1;	pucch_mask[220] =  1'b1;	pucch_mask[228] =  1'b1;	pucch_mask[230] =  1'b1;	pucch_mask[231] =  1'b1;	pucch_mask[233] =  1'b1;
        pucch_mask[234] =  1'b1;	pucch_mask[236] =  1'b1;    pucch_mask[237] =  1'b1;	pucch_mask[238] =  1'b1;	pucch_mask[242] =  1'b1;	pucch_mask[243] =  1'b1;	pucch_mask[244] =  1'b1;	pucch_mask[245] =  1'b1;	pucch_mask[259] =  1'b1;	pucch_mask[260] =  1'b1;	pucch_mask[266] =  1'b1;	pucch_mask[269] =  1'b1;	pucch_mask[270] =  1'b1;	pucch_mask[274] =  1'b1;	pucch_mask[276] =  1'b1;	pucch_mask[277] =  1'b1;
        pucch_mask[281] =  1'b1;	pucch_mask[283] =  1'b1;    pucch_mask[291] =  1'b1;	pucch_mask[294] =  1'b1;	pucch_mask[295] =  1'b1;	pucch_mask[297] =  1'b1;	pucch_mask[300] =  1'b1;	pucch_mask[307] =  1'b1;	pucch_mask[312] =  1'b1;	pucch_mask[316] =  1'b1;	pucch_mask[321] =  1'b1;	pucch_mask[326] =  1'b1;	pucch_mask[327] =  1'b1;	pucch_mask[329] =  1'b1;	pucch_mask[332] =  1'b1;	pucch_mask[339] =  1'b1;
        pucch_mask[345] =  1'b1;	pucch_mask[348] =  1'b1;    pucch_mask[353] =  1'b1;	pucch_mask[356] =  1'b1;	pucch_mask[362] =  1'b1;	pucch_mask[365] =  1'b1;	pucch_mask[366] =  1'b1;	pucch_mask[370] =  1'b1;	pucch_mask[372] =  1'b1;	pucch_mask[373] =  1'b1;	pucch_mask[376] =  1'b1;	pucch_mask[379] =  1'b1;	pucch_mask[385] =  1'b1;	pucch_mask[390] =  1'b1;	pucch_mask[391] =  1'b1;	pucch_mask[393] =  1'b1;
        pucch_mask[396] =  1'b1;	pucch_mask[403] =  1'b1;    pucch_mask[408] =  1'b1;	pucch_mask[411] =  1'b1;	pucch_mask[417] =  1'b1;	pucch_mask[420] =  1'b1;	pucch_mask[426] =  1'b1;	pucch_mask[429] =  1'b1;	pucch_mask[430] =  1'b1;	pucch_mask[434] =  1'b1;	pucch_mask[436] =  1'b1;	pucch_mask[437] =  1'b1;	pucch_mask[441] =  1'b1;    pucch_mask[444] =  1'b1;	pucch_mask[451] =  1'b1;	pucch_mask[452] =  1'b1;
        pucch_mask[458] =  1'b1;	pucch_mask[461] =  1'b1;    pucch_mask[462] =  1'b1;	pucch_mask[466] =  1'b1;	pucch_mask[468] =  1'b1;	pucch_mask[469] =  1'b1;	pucch_mask[472] =  1'b1;	pucch_mask[476] =  1'b1;	pucch_mask[483] =  1'b1;	pucch_mask[486] =  1'b1;	pucch_mask[487] =  1'b1;	pucch_mask[489] =  1'b1;	pucch_mask[492] =  1'b1;	pucch_mask[499] =  1'b1;	pucch_mask[505] =  1'b1;	pucch_mask[507] =  1'b1;
        pucch_mask[516] =  1'b1; 	pucch_mask[518] =  1'b1;    pucch_mask[521] =  1'b1;	pucch_mask[522] =  1'b1;	pucch_mask[524] =  1'b1;	pucch_mask[531] =  1'b1;	pucch_mask[532] =  1'b1;	pucch_mask[540] =  1'b1;	pucch_mask[551] =  1'b1;	pucch_mask[557] =  1'b1;	pucch_mask[558] =  1'b1;	pucch_mask[562] =  1'b1;	pucch_mask[565] =  1'b1;	pucch_mask[568] =  1'b1;	pucch_mask[569] =  1'b1;	pucch_mask[571] =  1'b1;
        pucch_mask[577] =  1'b1;	pucch_mask[579] =  1'b1;    pucch_mask[583] =  1'b1;	pucch_mask[589] =  1'b1;	pucch_mask[590] =  1'b1;	pucch_mask[594] =  1'b1;	pucch_mask[597] =  1'b1;	pucch_mask[603] =  1'b1;	pucch_mask[609] =  1'b1;	pucch_mask[611] =  1'b1;	pucch_mask[612] =  1'b1;	pucch_mask[614] =  1'b1;	pucch_mask[617] =  1'b1;	pucch_mask[618] =  1'b1;	pucch_mask[620] =  1'b1;	pucch_mask[627] =  1'b1;
        pucch_mask[628] =  1'b1;	pucch_mask[632] =  1'b1;    pucch_mask[633] =  1'b1;	pucch_mask[636] =  1'b1;	pucch_mask[641] =  1'b1;	pucch_mask[643] =  1'b1;	pucch_mask[647] =  1'b1;	pucch_mask[653] =  1'b1;	pucch_mask[654] =  1'b1;	pucch_mask[658] =  1'b1;	pucch_mask[661] =  1'b1;	pucch_mask[664] =  1'b1;	pucch_mask[665] =  1'b1;	pucch_mask[668] =  1'b1;	pucch_mask[673] =  1'b1;	pucch_mask[675] =  1'b1;
        pucch_mask[676] =  1'b1;	pucch_mask[678] =  1'b1;    pucch_mask[681] =  1'b1;	pucch_mask[682] =  1'b1;	pucch_mask[684] =  1'b1;	pucch_mask[691] =  1'b1;	pucch_mask[692] =  1'b1;	pucch_mask[699] =  1'b1;	pucch_mask[708] =  1'b1;	pucch_mask[710] =  1'b1;	pucch_mask[713] =  1'b1;	pucch_mask[714] =  1'b1;	pucch_mask[716] =  1'b1;	pucch_mask[723] =  1'b1;	pucch_mask[724] =  1'b1;	pucch_mask[728] =  1'b1;
        pucch_mask[729] =  1'b1;	pucch_mask[731] =  1'b1;    pucch_mask[743] =  1'b1;	pucch_mask[749] =  1'b1;	pucch_mask[750] =  1'b1;	pucch_mask[754] =  1'b1;	pucch_mask[757] =  1'b1;	pucch_mask[764] =  1'b1;	pucch_mask[771] =  1'b1;	pucch_mask[774] =  1'b1;	pucch_mask[777] =  1'b1;	pucch_mask[780] =  1'b1;	pucch_mask[781] =  1'b1;	pucch_mask[782] =  1'b1;	pucch_mask[786] =  1'b1;	pucch_mask[787] =  1'b1;
        pucch_mask[789] =  1'b1;	pucch_mask[793] =  1'b1;    pucch_mask[795] =  1'b1;	pucch_mask[796] =  1'b1;	pucch_mask[803] =  1'b1;	pucch_mask[804] =  1'b1;	pucch_mask[807] =  1'b1;	pucch_mask[810] =  1'b1;	pucch_mask[820] =  1'b1;	pucch_mask[824] =  1'b1;	pucch_mask[833] =  1'b1;	pucch_mask[836] =  1'b1;	pucch_mask[839] =  1'b1;	pucch_mask[842] =  1'b1;	pucch_mask[852] =  1'b1;	pucch_mask[857] =  1'b1;
        pucch_mask[865] =  1'b1;	pucch_mask[870] =  1'b1;    pucch_mask[873] =  1'b1;	pucch_mask[876] =  1'b1;	pucch_mask[877] =  1'b1;	pucch_mask[878] =  1'b1;	pucch_mask[882] =  1'b1;	pucch_mask[883] =  1'b1;	pucch_mask[885] =  1'b1;	pucch_mask[888] =  1'b1;	pucch_mask[891] =  1'b1;	pucch_mask[892] =  1'b1;	pucch_mask[897] =  1'b1;	pucch_mask[900] =  1'b1;	pucch_mask[903] =  1'b1;	pucch_mask[906] =  1'b1;
        pucch_mask[916] =  1'b1;	pucch_mask[920] =  1'b1;    pucch_mask[923] =  1'b1;	pucch_mask[924] =  1'b1;	pucch_mask[929] =  1'b1;	pucch_mask[934] =  1'b1;	pucch_mask[937] =  1'b1;	pucch_mask[940] =  1'b1;	pucch_mask[941] =  1'b1;	pucch_mask[942] =  1'b1;	pucch_mask[946] =  1'b1;	pucch_mask[947] =  1'b1;	pucch_mask[949] =  1'b1;	pucch_mask[953] =  1'b1;	pucch_mask[963] =  1'b1;	pucch_mask[966] =  1'b1;
        pucch_mask[969] =  1'b1;	pucch_mask[972] =  1'b1;    pucch_mask[973] =  1'b1;	pucch_mask[974] =  1'b1;	pucch_mask[978] =  1'b1;	pucch_mask[979] =  1'b1;	pucch_mask[981] =  1'b1;	pucch_mask[984] =  1'b1;	pucch_mask[995] =  1'b1;	pucch_mask[996] =  1'b1;	pucch_mask[999] =  1'b1;	pucch_mask[1002] = 1'b1;	pucch_mask[1012] = 1'b1;	pucch_mask[1017] = 1'b1;	pucch_mask[1019] = 1'b1;	pucch_mask[1020] = 1'b1;
        pucch_mask[1031] = 1'b1;	pucch_mask[1033] = 1'b1;	pucch_mask[1036] = 1'b1;	pucch_mask[1037] = 1'b1;	pucch_mask[1042] = 1'b1;	pucch_mask[1044] = 1'b1;	pucch_mask[1045] = 1'b1;	pucch_mask[1048] = 1'b1;	pucch_mask[1049] = 1'b1;	pucch_mask[1053] = 1'b1;	pucch_mask[1060] = 1'b1;	pucch_mask[1062] = 1'b1;	pucch_mask[1066] = 1'b1;	pucch_mask[1070] = 1'b1;	pucch_mask[1075] = 1'b1;	pucch_mask[1083] = 1'b1;
        pucch_mask[1084] = 1'b1;	pucch_mask[1085] = 1'b1;	pucch_mask[1089] = 1'b1;	pucch_mask[1091] = 1'b1;	pucch_mask[1092] = 1'b1;	pucch_mask[1094] = 1'b1;	pucch_mask[1098] = 1'b1;	pucch_mask[1102] = 1'b1;	pucch_mask[1107] = 1'b1;	pucch_mask[1112] = 1'b1;	pucch_mask[1113] = 1'b1;	pucch_mask[1115] = 1'b1;	pucch_mask[1116] = 1'b1;	pucch_mask[1117] = 1'b1;	pucch_mask[1121] = 1'b1;	pucch_mask[1123] = 1'b1;
        pucch_mask[1127] = 1'b1;	pucch_mask[1129] = 1'b1;	pucch_mask[1132] = 1'b1;	pucch_mask[1133] = 1'b1;	pucch_mask[1138] = 1'b1;	pucch_mask[1140] = 1'b1;	pucch_mask[1141] = 1'b1;	pucch_mask[1149] = 1'b1;	pucch_mask[1153] = 1'b1;	pucch_mask[1155] = 1'b1;	pucch_mask[1156] = 1'b1;	pucch_mask[1158] = 1'b1;	pucch_mask[1162] = 1'b1;	pucch_mask[1166] = 1'b1;	pucch_mask[1171] = 1'b1;	pucch_mask[1181] = 1'b1;
        pucch_mask[1185] = 1'b1;	pucch_mask[1187] = 1'b1;	pucch_mask[1191] = 1'b1;	pucch_mask[1193] = 1'b1;	pucch_mask[1196] = 1'b1;	pucch_mask[1197] = 1'b1;	pucch_mask[1202] = 1'b1;	pucch_mask[1204] = 1'b1;	pucch_mask[1205] = 1'b1;	pucch_mask[1208] = 1'b1;	pucch_mask[1209] = 1'b1;	pucch_mask[1211] = 1'b1;	pucch_mask[1212] = 1'b1;	pucch_mask[1213] = 1'b1;	pucch_mask[1223] = 1'b1;	pucch_mask[1225] = 1'b1;
        pucch_mask[1228] = 1'b1;	pucch_mask[1229] = 1'b1;	pucch_mask[1234] = 1'b1;	pucch_mask[1236] = 1'b1;	pucch_mask[1237] = 1'b1;	pucch_mask[1243] = 1'b1;	pucch_mask[1244] = 1'b1;	pucch_mask[1245] = 1'b1;	pucch_mask[1252] = 1'b1;	pucch_mask[1254] = 1'b1;	pucch_mask[1258] = 1'b1;	pucch_mask[1262] = 1'b1;	pucch_mask[1267] = 1'b1;	pucch_mask[1272] = 1'b1;	pucch_mask[1273] = 1'b1;	pucch_mask[1277] = 1'b1;
        pucch_mask[1283] = 1'b1;	pucch_mask[1284] = 1'b1;	pucch_mask[1287] = 1'b1;	pucch_mask[1289] = 1'b1;	pucch_mask[1290] = 1'b1;	pucch_mask[1292] = 1'b1;	pucch_mask[1294] = 1'b1;	pucch_mask[1304] = 1'b1;	pucch_mask[1307] = 1'b1;	pucch_mask[1309] = 1'b1;	pucch_mask[1315] = 1'b1;	pucch_mask[1318] = 1'b1;	pucch_mask[1325] = 1'b1;	pucch_mask[1330] = 1'b1;	pucch_mask[1331] = 1'b1;	pucch_mask[1332] = 1'b1;
        pucch_mask[1333] = 1'b1;	pucch_mask[1337] = 1'b1;	pucch_mask[1340] = 1'b1;	pucch_mask[1341] = 1'b1;	pucch_mask[1345] = 1'b1;	pucch_mask[1350] = 1'b1;	pucch_mask[1357] = 1'b1;	pucch_mask[1362] = 1'b1;	pucch_mask[1363] = 1'b1;	pucch_mask[1364] = 1'b1;	pucch_mask[1365] = 1'b1;	pucch_mask[1368] = 1'b1;	pucch_mask[1372] = 1'b1;	pucch_mask[1373] = 1'b1;	pucch_mask[1377] = 1'b1;	pucch_mask[1380] = 1'b1;
        pucch_mask[1383] = 1'b1;	pucch_mask[1385] = 1'b1;	pucch_mask[1386] = 1'b1;	pucch_mask[1388] = 1'b1;	pucch_mask[1390] = 1'b1;	pucch_mask[1401] = 1'b1;	pucch_mask[1403] = 1'b1;	pucch_mask[1405] = 1'b1;	pucch_mask[1409] = 1'b1;	pucch_mask[1414] = 1'b1;	pucch_mask[1421] = 1'b1;	pucch_mask[1426] = 1'b1;	pucch_mask[1427] = 1'b1;	pucch_mask[1428] = 1'b1;	pucch_mask[1429] = 1'b1;	pucch_mask[1433] = 1'b1;
        pucch_mask[1435] = 1'b1;	pucch_mask[1437] = 1'b1;	pucch_mask[1441] = 1'b1;	pucch_mask[1444] = 1'b1;    pucch_mask[1447] = 1'b1;	pucch_mask[1449] = 1'b1;	pucch_mask[1450] = 1'b1;	pucch_mask[1452] = 1'b1;	pucch_mask[1454] = 1'b1;	pucch_mask[1464] = 1'b1;	pucch_mask[1468] = 1'b1;	pucch_mask[1469] = 1'b1;	pucch_mask[1475] = 1'b1;	pucch_mask[1476] = 1'b1;	pucch_mask[1479] = 1'b1;	pucch_mask[1481] = 1'b1;
        pucch_mask[1482] = 1'b1;	pucch_mask[1484] = 1'b1;	pucch_mask[1486] = 1'b1;	pucch_mask[1497] = 1'b1;	pucch_mask[1500] = 1'b1;	pucch_mask[1501] = 1'b1;	pucch_mask[1507] = 1'b1;	pucch_mask[1510] = 1'b1;	pucch_mask[1517] = 1'b1;	pucch_mask[1522] = 1'b1;	pucch_mask[1523] = 1'b1;	pucch_mask[1524] = 1'b1;	pucch_mask[1525] = 1'b1;	pucch_mask[1528] = 1'b1;	pucch_mask[1531] = 1'b1;	pucch_mask[1533] = 1'b1;
        pucch_mask[1540] = 1'b1;	pucch_mask[1542] = 1'b1;	pucch_mask[1543] = 1'b1;	pucch_mask[1546] = 1'b1;	pucch_mask[1549] = 1'b1;	pucch_mask[1554] = 1'b1;	pucch_mask[1555] = 1'b1;	pucch_mask[1557] = 1'b1;	pucch_mask[1560] = 1'b1;	pucch_mask[1561] = 1'b1;	pucch_mask[1564] = 1'b1;	pucch_mask[1565] = 1'b1;	pucch_mask[1577] = 1'b1;	pucch_mask[1580] = 1'b1;	pucch_mask[1582] = 1'b1;	pucch_mask[1588] = 1'b1;
        pucch_mask[1595] = 1'b1;	pucch_mask[1597] = 1'b1;	pucch_mask[1601] = 1'b1;	pucch_mask[1603] = 1'b1;	pucch_mask[1609] = 1'b1;	pucch_mask[1612] = 1'b1;	pucch_mask[1614] = 1'b1;	pucch_mask[1620] = 1'b1;	pucch_mask[1624] = 1'b1;	pucch_mask[1625] = 1'b1;	pucch_mask[1627] = 1'b1;	pucch_mask[1629] = 1'b1;	pucch_mask[1633] = 1'b1;	pucch_mask[1635] = 1'b1;	pucch_mask[1636] = 1'b1;	pucch_mask[1638] = 1'b1;
        pucch_mask[1639] = 1'b1;	pucch_mask[1642] = 1'b1;	pucch_mask[1645] = 1'b1;	pucch_mask[1650] = 1'b1;	pucch_mask[1651] = 1'b1;	pucch_mask[1653] = 1'b1;	pucch_mask[1660] = 1'b1;	pucch_mask[1661] = 1'b1;	pucch_mask[1665] = 1'b1;	pucch_mask[1667] = 1'b1;	pucch_mask[1673] = 1'b1;	pucch_mask[1676] = 1'b1;	pucch_mask[1678] = 1'b1;	pucch_mask[1684] = 1'b1;	pucch_mask[1692] = 1'b1;	pucch_mask[1693] = 1'b1;
        pucch_mask[1697] = 1'b1;	pucch_mask[1699] = 1'b1;	pucch_mask[1700] = 1'b1;	pucch_mask[1702] = 1'b1;	pucch_mask[1703] = 1'b1;	pucch_mask[1706] = 1'b1;	pucch_mask[1709] = 1'b1;	pucch_mask[1714] = 1'b1;	pucch_mask[1715] = 1'b1;	pucch_mask[1717] = 1'b1;	pucch_mask[1720] = 1'b1;	pucch_mask[1721] = 1'b1;	pucch_mask[1723] = 1'b1;	pucch_mask[1725] = 1'b1;	pucch_mask[1732] = 1'b1;	pucch_mask[1734] = 1'b1;
        pucch_mask[1735] = 1'b1;	pucch_mask[1738] = 1'b1;	pucch_mask[1741] = 1'b1;	pucch_mask[1746] = 1'b1;	pucch_mask[1747] = 1'b1;	pucch_mask[1749] = 1'b1;	pucch_mask[1755] = 1'b1;	pucch_mask[1757] = 1'b1;	pucch_mask[1769] = 1'b1;	pucch_mask[1772] = 1'b1;	pucch_mask[1774] = 1'b1;	pucch_mask[1780] = 1'b1;	pucch_mask[1784] = 1'b1;	pucch_mask[1785] = 1'b1;	pucch_mask[1788] = 1'b1;	pucch_mask[1789] = 1'b1;
        pucch_mask[1795] = 1'b1;	pucch_mask[1798] = 1'b1;	pucch_mask[1799] = 1'b1;	pucch_mask[1806] = 1'b1;	pucch_mask[1811] = 1'b1;	pucch_mask[1812] = 1'b1;	pucch_mask[1816] = 1'b1;	pucch_mask[1819] = 1'b1;	pucch_mask[1820] = 1'b1;	pucch_mask[1821] = 1'b1;	pucch_mask[1827] = 1'b1;	pucch_mask[1828] = 1'b1;	pucch_mask[1833] = 1'b1;	pucch_mask[1834] = 1'b1;	pucch_mask[1836] = 1'b1;	pucch_mask[1837] = 1'b1;
        pucch_mask[1842] = 1'b1;	pucch_mask[1845] = 1'b1;	pucch_mask[1849] = 1'b1;	pucch_mask[1853] = 1'b1;	pucch_mask[1857] = 1'b1;	pucch_mask[1860] = 1'b1;	pucch_mask[1865] = 1'b1;	pucch_mask[1866] = 1'b1;	pucch_mask[1868] = 1'b1;	pucch_mask[1869] = 1'b1;	pucch_mask[1874] = 1'b1;	pucch_mask[1877] = 1'b1;	pucch_mask[1880] = 1'b1;	pucch_mask[1885] = 1'b1;	pucch_mask[1889] = 1'b1;	pucch_mask[1894] = 1'b1;
        pucch_mask[1895] = 1'b1;	pucch_mask[1902] = 1'b1;	pucch_mask[1907] = 1'b1;	pucch_mask[1908] = 1'b1;	pucch_mask[1913] = 1'b1;	pucch_mask[1915] = 1'b1;	pucch_mask[1916] = 1'b1;	pucch_mask[1917] = 1'b1;	pucch_mask[1921] = 1'b1;	pucch_mask[1924] = 1'b1;	pucch_mask[1929] = 1'b1;	pucch_mask[1930] = 1'b1;	pucch_mask[1932] = 1'b1;	pucch_mask[1933] = 1'b1;	pucch_mask[1938] = 1'b1;	pucch_mask[1941] = 1'b1;
        pucch_mask[1945] = 1'b1;	pucch_mask[1947] = 1'b1;	pucch_mask[1948] = 1'b1;	pucch_mask[1949] = 1'b1;	pucch_mask[1953] = 1'b1;	pucch_mask[1958] = 1'b1;	pucch_mask[1959] = 1'b1;	pucch_mask[1966] = 1'b1;	pucch_mask[1971] = 1'b1;	pucch_mask[1972] = 1'b1;	pucch_mask[1976] = 1'b1;	pucch_mask[1981] = 1'b1;	pucch_mask[1987] = 1'b1;	pucch_mask[1990] = 1'b1;	pucch_mask[1991] = 1'b1;	pucch_mask[1998] = 1'b1;
        pucch_mask[2003] = 1'b1;	pucch_mask[2004] = 1'b1;	pucch_mask[2009] = 1'b1;	pucch_mask[2013] = 1'b1;	pucch_mask[2019] = 1'b1;	pucch_mask[2020] = 1'b1;	pucch_mask[2025] = 1'b1;	pucch_mask[2026] = 1'b1;	pucch_mask[2028] = 1'b1;	pucch_mask[2029] = 1'b1;	pucch_mask[2034] = 1'b1;	pucch_mask[2037] = 1'b1;	pucch_mask[2040] = 1'b1;	pucch_mask[2043] = 1'b1;	pucch_mask[2044] = 1'b1;	pucch_mask[2045] = 1'b1;
        pucch_mask[2052] = 1'b1;	pucch_mask[2057] = 1'b1;	pucch_mask[2058] = 1'b1;	pucch_mask[2062] = 1'b1;	pucch_mask[2064] = 1'b1;	pucch_mask[2066] = 1'b1;	pucch_mask[2067] = 1'b1;	pucch_mask[2073] = 1'b1;	pucch_mask[2075] = 1'b1;	pucch_mask[2077] = 1'b1;	pucch_mask[2086] = 1'b1;	pucch_mask[2087] = 1'b1;	pucch_mask[2092] = 1'b1;	pucch_mask[2093] = 1'b1;	pucch_mask[2096] = 1'b1;	pucch_mask[2100] = 1'b1;
        pucch_mask[2101] = 1'b1;	pucch_mask[2104] = 1'b1;	pucch_mask[2108] = 1'b1;	pucch_mask[2109] = 1'b1;	pucch_mask[2113] = 1'b1;	pucch_mask[2115] = 1'b1;	pucch_mask[2118] = 1'b1;	pucch_mask[2119] = 1'b1;	pucch_mask[2124] = 1'b1;	pucch_mask[2125] = 1'b1;	pucch_mask[2128] = 1'b1;	pucch_mask[2132] = 1'b1;	pucch_mask[2133] = 1'b1;	pucch_mask[2137] = 1'b1;	pucch_mask[2140] = 1'b1;	pucch_mask[2141] = 1'b1;
        pucch_mask[2145] = 1'b1;	pucch_mask[2147] = 1'b1;	pucch_mask[2148] = 1'b1;	pucch_mask[2153] = 1'b1;	pucch_mask[2154] = 1'b1;	pucch_mask[2158] = 1'b1;	pucch_mask[2160] = 1'b1;	pucch_mask[2162] = 1'b1;	pucch_mask[2163] = 1'b1;	pucch_mask[2168] = 1'b1;	pucch_mask[2171] = 1'b1;	pucch_mask[2173] = 1'b1;	pucch_mask[2177] = 1'b1;	pucch_mask[2179] = 1'b1;	pucch_mask[2182] = 1'b1;	pucch_mask[2183] = 1'b1;
        pucch_mask[2188] = 1'b1;	pucch_mask[2189] = 1'b1;	pucch_mask[2192] = 1'b1;	pucch_mask[2196] = 1'b1;	pucch_mask[2197] = 1'b1;	pucch_mask[2200] = 1'b1;	pucch_mask[2203] = 1'b1;	pucch_mask[2205] = 1'b1;	pucch_mask[2209] = 1'b1;	pucch_mask[2211] = 1'b1;	pucch_mask[2212] = 1'b1;	pucch_mask[2217] = 1'b1;	pucch_mask[2218] = 1'b1;	pucch_mask[2222] = 1'b1;	pucch_mask[2224] = 1'b1;	pucch_mask[2226] = 1'b1;
        pucch_mask[2227] = 1'b1;	pucch_mask[2233] = 1'b1;	pucch_mask[2236] = 1'b1;	pucch_mask[2237] = 1'b1;	pucch_mask[2244] = 1'b1;	pucch_mask[2249] = 1'b1;	pucch_mask[2250] = 1'b1;	pucch_mask[2254] = 1'b1;	pucch_mask[2256] = 1'b1;	pucch_mask[2258] = 1'b1;	pucch_mask[2259] = 1'b1;	pucch_mask[2264] = 1'b1;	pucch_mask[2268] = 1'b1;	pucch_mask[2269] = 1'b1;	pucch_mask[2278] = 1'b1;	pucch_mask[2279] = 1'b1;
        pucch_mask[2284] = 1'b1;	pucch_mask[2285] = 1'b1;	pucch_mask[2288] = 1'b1;	pucch_mask[2292] = 1'b1;	pucch_mask[2293] = 1'b1;	pucch_mask[2297] = 1'b1;	pucch_mask[2299] = 1'b1;	pucch_mask[2301] = 1'b1;	pucch_mask[2307] = 1'b1;	pucch_mask[2313] = 1'b1;	pucch_mask[2317] = 1'b1;	pucch_mask[2320] = 1'b1;	pucch_mask[2323] = 1'b1;	pucch_mask[2324] = 1'b1;	pucch_mask[2325] = 1'b1;	pucch_mask[2333] = 1'b1;
        pucch_mask[2339] = 1'b1;	pucch_mask[2340] = 1'b1;	pucch_mask[2342] = 1'b1;	pucch_mask[2343] = 1'b1;	pucch_mask[2346] = 1'b1;    pucch_mask[2348] = 1'b1;	pucch_mask[2350] = 1'b1;	pucch_mask[2352] = 1'b1;	pucch_mask[2354] = 1'b1;	pucch_mask[2360] = 1'b1;	pucch_mask[2361] = 1'b1;	pucch_mask[2363] = 1'b1;	pucch_mask[2364] = 1'b1;	pucch_mask[2365] = 1'b1;	pucch_mask[2369] = 1'b1;	pucch_mask[2372] = 1'b1;
        pucch_mask[2374] = 1'b1;	pucch_mask[2375] = 1'b1;	pucch_mask[2378] = 1'b1;	pucch_mask[2380] = 1'b1;	pucch_mask[2382] = 1'b1;	pucch_mask[2384] = 1'b1;	pucch_mask[2386] = 1'b1;	pucch_mask[2395] = 1'b1;	pucch_mask[2396] = 1'b1;	pucch_mask[2397] = 1'b1;	pucch_mask[2401] = 1'b1;	pucch_mask[2409] = 1'b1;	pucch_mask[2413] = 1'b1;	pucch_mask[2416] = 1'b1;	pucch_mask[2419] = 1'b1;	pucch_mask[2420] = 1'b1;
        pucch_mask[2421] = 1'b1;	pucch_mask[2424] = 1'b1;	pucch_mask[2425] = 1'b1;	pucch_mask[2429] = 1'b1;	pucch_mask[2433] = 1'b1;	pucch_mask[2436] = 1'b1;	pucch_mask[2438] = 1'b1;	pucch_mask[2439] = 1'b1;	pucch_mask[2442] = 1'b1;	pucch_mask[2444] = 1'b1;	pucch_mask[2446] = 1'b1;	pucch_mask[2448] = 1'b1;	pucch_mask[2450] = 1'b1;	pucch_mask[2456] = 1'b1;	pucch_mask[2457] = 1'b1;	pucch_mask[2461] = 1'b1;
        pucch_mask[2465] = 1'b1;	pucch_mask[2473] = 1'b1;	pucch_mask[2477] = 1'b1;	pucch_mask[2480] = 1'b1;	pucch_mask[2483] = 1'b1;	pucch_mask[2484] = 1'b1;	pucch_mask[2485] = 1'b1;	pucch_mask[2491] = 1'b1;	pucch_mask[2492] = 1'b1;	pucch_mask[2493] = 1'b1;	pucch_mask[2499] = 1'b1;	pucch_mask[2505] = 1'b1;	pucch_mask[2509] = 1'b1;	pucch_mask[2512] = 1'b1;	pucch_mask[2515] = 1'b1;	pucch_mask[2516] = 1'b1;
        pucch_mask[2517] = 1'b1;	pucch_mask[2520] = 1'b1;	pucch_mask[2521] = 1'b1;	pucch_mask[2523] = 1'b1;	pucch_mask[2524] = 1'b1;	pucch_mask[2525] = 1'b1;	pucch_mask[2531] = 1'b1;	pucch_mask[2532] = 1'b1;	pucch_mask[2534] = 1'b1;	pucch_mask[2535] = 1'b1;	pucch_mask[2538] = 1'b1;	pucch_mask[2540] = 1'b1;	pucch_mask[2542] = 1'b1;	pucch_mask[2544] = 1'b1;	pucch_mask[2546] = 1'b1;	pucch_mask[2557] = 1'b1;
        pucch_mask[2566] = 1'b1;	pucch_mask[2572] = 1'b1;	pucch_mask[2574] = 1'b1;	pucch_mask[2576] = 1'b1;	pucch_mask[2578] = 1'b1;	pucch_mask[2580] = 1'b1;	pucch_mask[2585] = 1'b1;	pucch_mask[2587] = 1'b1;	pucch_mask[2588] = 1'b1;	pucch_mask[2589] = 1'b1;	pucch_mask[2596] = 1'b1;	pucch_mask[2599] = 1'b1;	pucch_mask[2601] = 1'b1;	pucch_mask[2602] = 1'b1;	pucch_mask[2605] = 1'b1;	pucch_mask[2608] = 1'b1;
        pucch_mask[2611] = 1'b1;	pucch_mask[2613] = 1'b1;	pucch_mask[2616] = 1'b1;	pucch_mask[2621] = 1'b1;	pucch_mask[2625] = 1'b1;	pucch_mask[2627] = 1'b1;	pucch_mask[2628] = 1'b1;	pucch_mask[2631] = 1'b1;	pucch_mask[2633] = 1'b1;	pucch_mask[2634] = 1'b1;	pucch_mask[2637] = 1'b1;	pucch_mask[2640] = 1'b1;	pucch_mask[2643] = 1'b1;	pucch_mask[2645] = 1'b1;	pucch_mask[2649] = 1'b1;	pucch_mask[2653] = 1'b1;
        pucch_mask[2657] = 1'b1;	pucch_mask[2659] = 1'b1;	pucch_mask[2662] = 1'b1;	pucch_mask[2668] = 1'b1;	pucch_mask[2670] = 1'b1;	pucch_mask[2672] = 1'b1;	pucch_mask[2674] = 1'b1;	pucch_mask[2676] = 1'b1;	pucch_mask[2680] = 1'b1;	pucch_mask[2683] = 1'b1;	pucch_mask[2684] = 1'b1;	pucch_mask[2685] = 1'b1;	pucch_mask[2689] = 1'b1;	pucch_mask[2691] = 1'b1;	pucch_mask[2692] = 1'b1;	pucch_mask[2695] = 1'b1;
        pucch_mask[2697] = 1'b1;	pucch_mask[2698] = 1'b1;	pucch_mask[2701] = 1'b1;	pucch_mask[2704] = 1'b1;	pucch_mask[2707] = 1'b1;	pucch_mask[2709] = 1'b1;	pucch_mask[2712] = 1'b1;	pucch_mask[2715] = 1'b1;	pucch_mask[2716] = 1'b1;	pucch_mask[2717] = 1'b1;	pucch_mask[2721] = 1'b1;	pucch_mask[2723] = 1'b1;	pucch_mask[2726] = 1'b1;	pucch_mask[2732] = 1'b1;	pucch_mask[2734] = 1'b1;	pucch_mask[2736] = 1'b1;
        pucch_mask[2738] = 1'b1;	pucch_mask[2740] = 1'b1;	pucch_mask[2745] = 1'b1;	pucch_mask[2749] = 1'b1;	pucch_mask[2758] = 1'b1;	pucch_mask[2764] = 1'b1;	pucch_mask[2766] = 1'b1;	pucch_mask[2768] = 1'b1;	pucch_mask[2770] = 1'b1;	pucch_mask[2772] = 1'b1;	pucch_mask[2776] = 1'b1;	pucch_mask[2781] = 1'b1;	pucch_mask[2788] = 1'b1;	pucch_mask[2791] = 1'b1;	pucch_mask[2793] = 1'b1;	pucch_mask[2794] = 1'b1;
        pucch_mask[2797] = 1'b1;	pucch_mask[2800] = 1'b1;	pucch_mask[2803] = 1'b1;	pucch_mask[2805] = 1'b1;	pucch_mask[2809] = 1'b1;	pucch_mask[2811] = 1'b1;	pucch_mask[2812] = 1'b1;	pucch_mask[2813] = 1'b1;	pucch_mask[2819] = 1'b1;	pucch_mask[2820] = 1'b1;	pucch_mask[2822] = 1'b1;	pucch_mask[2826] = 1'b1;	pucch_mask[2828] = 1'b1;	pucch_mask[2829] = 1'b1;	pucch_mask[2832] = 1'b1;	pucch_mask[2837] = 1'b1;
        pucch_mask[2844] = 1'b1;	pucch_mask[2845] = 1'b1;	pucch_mask[2851] = 1'b1;	pucch_mask[2855] = 1'b1;	pucch_mask[2857] = 1'b1;	pucch_mask[2862] = 1'b1;	pucch_mask[2864] = 1'b1;	pucch_mask[2866] = 1'b1;	pucch_mask[2867] = 1'b1;	pucch_mask[2868] = 1'b1;	pucch_mask[2872] = 1'b1;	pucch_mask[2873] = 1'b1;	pucch_mask[2875] = 1'b1;	pucch_mask[2877] = 1'b1;	pucch_mask[2881] = 1'b1;	pucch_mask[2887] = 1'b1;
        pucch_mask[2889] = 1'b1;	pucch_mask[2894] = 1'b1;	pucch_mask[2896] = 1'b1;	pucch_mask[2898] = 1'b1;	pucch_mask[2899] = 1'b1;	pucch_mask[2900] = 1'b1;	pucch_mask[2907] = 1'b1;	pucch_mask[2909] = 1'b1;	pucch_mask[2913] = 1'b1;	pucch_mask[2916] = 1'b1;	pucch_mask[2918] = 1'b1;	pucch_mask[2922] = 1'b1;	pucch_mask[2924] = 1'b1;	pucch_mask[2925] = 1'b1;	pucch_mask[2928] = 1'b1;	pucch_mask[2933] = 1'b1;
        pucch_mask[2936] = 1'b1;	pucch_mask[2937] = 1'b1;	pucch_mask[2940] = 1'b1;	pucch_mask[2941] = 1'b1;	pucch_mask[2945] = 1'b1;	pucch_mask[2951] = 1'b1;	pucch_mask[2953] = 1'b1;	pucch_mask[2958] = 1'b1;	pucch_mask[2960] = 1'b1;	pucch_mask[2962] = 1'b1;	pucch_mask[2963] = 1'b1;	pucch_mask[2964] = 1'b1;	pucch_mask[2968] = 1'b1;	pucch_mask[2969] = 1'b1;	pucch_mask[2972] = 1'b1;	pucch_mask[2973] = 1'b1;
        pucch_mask[2977] = 1'b1;	pucch_mask[2980] = 1'b1;	pucch_mask[2982] = 1'b1;	pucch_mask[2986] = 1'b1;	pucch_mask[2988] = 1'b1;	pucch_mask[2989] = 1'b1;	pucch_mask[2992] = 1'b1;	pucch_mask[2997] = 1'b1;	pucch_mask[3003] = 1'b1;	pucch_mask[3005] = 1'b1;	pucch_mask[3011] = 1'b1;	pucch_mask[3012] = 1'b1;	pucch_mask[3014] = 1'b1;	pucch_mask[3018] = 1'b1;	pucch_mask[3020] = 1'b1;	pucch_mask[3021] = 1'b1;
        pucch_mask[3024] = 1'b1;	pucch_mask[3029] = 1'b1;	pucch_mask[3032] = 1'b1;	pucch_mask[3033] = 1'b1;	pucch_mask[3035] = 1'b1;	pucch_mask[3037] = 1'b1;	pucch_mask[3043] = 1'b1;	pucch_mask[3047] = 1'b1;	pucch_mask[3049] = 1'b1;	pucch_mask[3054] = 1'b1;	pucch_mask[3056] = 1'b1;	pucch_mask[3058] = 1'b1;	pucch_mask[3059] = 1'b1;	pucch_mask[3060] = 1'b1;	pucch_mask[3068] = 1'b1;	pucch_mask[3069] = 1'b1;
        pucch_mask[3076] = 1'b1;	pucch_mask[3079] = 1'b1;	pucch_mask[3082] = 1'b1;	pucch_mask[3084] = 1'b1;	pucch_mask[3085] = 1'b1;	pucch_mask[3086] = 1'b1;	pucch_mask[3088] = 1'b1;	pucch_mask[3091] = 1'b1;	pucch_mask[3092] = 1'b1;	pucch_mask[3093] = 1'b1;	pucch_mask[3096] = 1'b1;	pucch_mask[3099] = 1'b1;	pucch_mask[3110] = 1'b1;	pucch_mask[3113] = 1'b1;	pucch_mask[3120] = 1'b1;	pucch_mask[3122] = 1'b1;
        pucch_mask[3129] = 1'b1;	pucch_mask[3132] = 1'b1;	pucch_mask[3137] = 1'b1;	pucch_mask[3139] = 1'b1;	pucch_mask[3142] = 1'b1;	pucch_mask[3145] = 1'b1;	pucch_mask[3152] = 1'b1;	pucch_mask[3154] = 1'b1;	pucch_mask[3160] = 1'b1;	pucch_mask[3164] = 1'b1;	pucch_mask[3169] = 1'b1;	pucch_mask[3171] = 1'b1;	pucch_mask[3172] = 1'b1;	pucch_mask[3175] = 1'b1;	pucch_mask[3178] = 1'b1;	pucch_mask[3180] = 1'b1;
        pucch_mask[3181] = 1'b1;	pucch_mask[3182] = 1'b1;	pucch_mask[3184] = 1'b1;	pucch_mask[3187] = 1'b1;	pucch_mask[3188] = 1'b1;	pucch_mask[3189] = 1'b1;	pucch_mask[3193] = 1'b1;	pucch_mask[3195] = 1'b1;	pucch_mask[3201] = 1'b1;	pucch_mask[3203] = 1'b1;	pucch_mask[3206] = 1'b1;	pucch_mask[3209] = 1'b1;	pucch_mask[3216] = 1'b1;	pucch_mask[3218] = 1'b1;	pucch_mask[3225] = 1'b1;	pucch_mask[3227] = 1'b1;
        pucch_mask[3233] = 1'b1;	pucch_mask[3235] = 1'b1;	pucch_mask[3236] = 1'b1;	pucch_mask[3239] = 1'b1;	pucch_mask[3242] = 1'b1;	pucch_mask[3244] = 1'b1;	pucch_mask[3245] = 1'b1;	pucch_mask[3246] = 1'b1;	pucch_mask[3248] = 1'b1;	pucch_mask[3251] = 1'b1;	pucch_mask[3252] = 1'b1;	pucch_mask[3253] = 1'b1;	pucch_mask[3256] = 1'b1;	pucch_mask[3260] = 1'b1;	pucch_mask[3268] = 1'b1;	pucch_mask[3271] = 1'b1;
        pucch_mask[3274] = 1'b1;	pucch_mask[3276] = 1'b1;	pucch_mask[3277] = 1'b1;	pucch_mask[3278] = 1'b1;	pucch_mask[3280] = 1'b1;	pucch_mask[3283] = 1'b1;	pucch_mask[3284] = 1'b1;	pucch_mask[3285] = 1'b1;	pucch_mask[3289] = 1'b1;	pucch_mask[3292] = 1'b1;	pucch_mask[3302] = 1'b1;	pucch_mask[3305] = 1'b1;	pucch_mask[3312] = 1'b1;	pucch_mask[3314] = 1'b1;	pucch_mask[3320] = 1'b1;	pucch_mask[3323] = 1'b1;
        pucch_mask[3331] = 1'b1;	pucch_mask[3335] = 1'b1;	pucch_mask[3340] = 1'b1;	pucch_mask[3344] = 1'b1;	pucch_mask[3346] = 1'b1;	pucch_mask[3347] = 1'b1;	pucch_mask[3352] = 1'b1;	pucch_mask[3353] = 1'b1;	pucch_mask[3363] = 1'b1;	pucch_mask[3364] = 1'b1;	pucch_mask[3366] = 1'b1;	pucch_mask[3369] = 1'b1;	pucch_mask[3370] = 1'b1;	pucch_mask[3373] = 1'b1;	pucch_mask[3374] = 1'b1;	pucch_mask[3376] = 1'b1;
        pucch_mask[3380] = 1'b1;	pucch_mask[3381] = 1'b1;	pucch_mask[3387] = 1'b1;	pucch_mask[3388] = 1'b1;	pucch_mask[3393] = 1'b1;	pucch_mask[3396] = 1'b1;	pucch_mask[3398] = 1'b1;	pucch_mask[3401] = 1'b1;	pucch_mask[3402] = 1'b1;	pucch_mask[3405] = 1'b1;	pucch_mask[3406] = 1'b1;	pucch_mask[3408] = 1'b1;	pucch_mask[3412] = 1'b1;	pucch_mask[3413] = 1'b1;	pucch_mask[3416] = 1'b1;    pucch_mask[3417] = 1'b1;
        pucch_mask[3419] = 1'b1;	pucch_mask[3420] = 1'b1;	pucch_mask[3425] = 1'b1;	pucch_mask[3431] = 1'b1;	pucch_mask[3436] = 1'b1;	pucch_mask[3440] = 1'b1;	pucch_mask[3442] = 1'b1;	pucch_mask[3443] = 1'b1;	pucch_mask[3457] = 1'b1;	pucch_mask[3460] = 1'b1;	pucch_mask[3462] = 1'b1;	pucch_mask[3465] = 1'b1;	pucch_mask[3466] = 1'b1;	pucch_mask[3469] = 1'b1;	pucch_mask[3470] = 1'b1;	pucch_mask[3472] = 1'b1;
        pucch_mask[3476] = 1'b1;	pucch_mask[3477] = 1'b1;	pucch_mask[3489] = 1'b1;	pucch_mask[3495] = 1'b1;	pucch_mask[3500] = 1'b1;	pucch_mask[3504] = 1'b1;	pucch_mask[3506] = 1'b1;	pucch_mask[3507] = 1'b1;	pucch_mask[3512] = 1'b1;	pucch_mask[3513] = 1'b1;	pucch_mask[3515] = 1'b1;	pucch_mask[3516] = 1'b1;	pucch_mask[3523] = 1'b1;	pucch_mask[3527] = 1'b1;	pucch_mask[3532] = 1'b1;	pucch_mask[3536] = 1'b1;
        pucch_mask[3538] = 1'b1;	pucch_mask[3539] = 1'b1;	pucch_mask[3547] = 1'b1;	pucch_mask[3548] = 1'b1;	pucch_mask[3555] = 1'b1;	pucch_mask[3556] = 1'b1;	pucch_mask[3558] = 1'b1;	pucch_mask[3561] = 1'b1;	pucch_mask[3562] = 1'b1;	pucch_mask[3565] = 1'b1;	pucch_mask[3566] = 1'b1;	pucch_mask[3568] = 1'b1;	pucch_mask[3572] = 1'b1;	pucch_mask[3573] = 1'b1;	pucch_mask[3576] = 1'b1;	pucch_mask[3577] = 1'b1;
        pucch_mask[3590] = 1'b1;	pucch_mask[3591] = 1'b1;	pucch_mask[3593] = 1'b1;	pucch_mask[3597] = 1'b1;	pucch_mask[3598] = 1'b1;	pucch_mask[3600] = 1'b1;	pucch_mask[3605] = 1'b1;	pucch_mask[3608] = 1'b1;	pucch_mask[3611] = 1'b1;	pucch_mask[3612] = 1'b1;	pucch_mask[3620] = 1'b1;	pucch_mask[3626] = 1'b1;	pucch_mask[3628] = 1'b1;	pucch_mask[3632] = 1'b1;	pucch_mask[3634] = 1'b1;	pucch_mask[3635] = 1'b1;
        pucch_mask[3636] = 1'b1;	pucch_mask[3641] = 1'b1;	pucch_mask[3649] = 1'b1;	pucch_mask[3651] = 1'b1;	pucch_mask[3652] = 1'b1;	pucch_mask[3658] = 1'b1;	pucch_mask[3660] = 1'b1;	pucch_mask[3664] = 1'b1;	pucch_mask[3666] = 1'b1;	pucch_mask[3667] = 1'b1;	pucch_mask[3668] = 1'b1;	pucch_mask[3672] = 1'b1;	pucch_mask[3681] = 1'b1;	pucch_mask[3683] = 1'b1;	pucch_mask[3686] = 1'b1;	pucch_mask[3687] = 1'b1;
        pucch_mask[3689] = 1'b1;	pucch_mask[3693] = 1'b1;	pucch_mask[3694] = 1'b1;	pucch_mask[3696] = 1'b1;	pucch_mask[3701] = 1'b1;	pucch_mask[3705] = 1'b1;	pucch_mask[3707] = 1'b1;	pucch_mask[3708] = 1'b1;	pucch_mask[3713] = 1'b1;	pucch_mask[3715] = 1'b1;	pucch_mask[3716] = 1'b1;	pucch_mask[3722] = 1'b1;	pucch_mask[3724] = 1'b1;	pucch_mask[3728] = 1'b1;	pucch_mask[3730] = 1'b1;	pucch_mask[3731] = 1'b1;
        pucch_mask[3732] = 1'b1;	pucch_mask[3737] = 1'b1;	pucch_mask[3739] = 1'b1;	pucch_mask[3740] = 1'b1;	pucch_mask[3745] = 1'b1;	pucch_mask[3747] = 1'b1;	pucch_mask[3750] = 1'b1;	pucch_mask[3751] = 1'b1;	pucch_mask[3753] = 1'b1;	pucch_mask[3757] = 1'b1;	pucch_mask[3758] = 1'b1;	pucch_mask[3760] = 1'b1;	pucch_mask[3765] = 1'b1;	pucch_mask[3768] = 1'b1;	pucch_mask[3782] = 1'b1;	pucch_mask[3783] = 1'b1;
        pucch_mask[3785] = 1'b1;	pucch_mask[3789] = 1'b1;	pucch_mask[3790] = 1'b1;	pucch_mask[3792] = 1'b1;	pucch_mask[3797] = 1'b1;	pucch_mask[3801] = 1'b1;	pucch_mask[3812] = 1'b1;	pucch_mask[3818] = 1'b1;	pucch_mask[3820] = 1'b1;	pucch_mask[3824] = 1'b1;	pucch_mask[3826] = 1'b1;	pucch_mask[3827] = 1'b1;	pucch_mask[3828] = 1'b1;	pucch_mask[3832] = 1'b1;	pucch_mask[3835] = 1'b1;	pucch_mask[3836] = 1'b1;
        pucch_mask[3843] = 1'b1;	pucch_mask[3844] = 1'b1;	pucch_mask[3846] = 1'b1;	pucch_mask[3847] = 1'b1;	pucch_mask[3849] = 1'b1;	pucch_mask[3850] = 1'b1;	pucch_mask[3856] = 1'b1;	pucch_mask[3858] = 1'b1;	pucch_mask[3860] = 1'b1;	pucch_mask[3864] = 1'b1;	pucch_mask[3865] = 1'b1;	pucch_mask[3868] = 1'b1;	pucch_mask[3875] = 1'b1;	pucch_mask[3884] = 1'b1;	pucch_mask[3885] = 1'b1;	pucch_mask[3886] = 1'b1;
        pucch_mask[3888] = 1'b1;	pucch_mask[3891] = 1'b1;	pucch_mask[3893] = 1'b1;	pucch_mask[3899] = 1'b1;	pucch_mask[3905] = 1'b1;	pucch_mask[3916] = 1'b1;	pucch_mask[3917] = 1'b1;	pucch_mask[3918] = 1'b1;	pucch_mask[3920] = 1'b1;	pucch_mask[3923] = 1'b1;	pucch_mask[3925] = 1'b1;	pucch_mask[3928] = 1'b1;	pucch_mask[3929] = 1'b1;	pucch_mask[3931] = 1'b1;	pucch_mask[3937] = 1'b1;	pucch_mask[3940] = 1'b1;
        pucch_mask[3942] = 1'b1;	pucch_mask[3943] = 1'b1;	pucch_mask[3945] = 1'b1;	pucch_mask[3946] = 1'b1;	pucch_mask[3952] = 1'b1;	pucch_mask[3954] = 1'b1;	pucch_mask[3956] = 1'b1;	pucch_mask[3964] = 1'b1;	pucch_mask[3969] = 1'b1;	pucch_mask[3980] = 1'b1;	pucch_mask[3981] = 1'b1;	pucch_mask[3982] = 1'b1;	pucch_mask[3984] = 1'b1;	pucch_mask[3987] = 1'b1;	pucch_mask[3989] = 1'b1;	pucch_mask[3996] = 1'b1;
        pucch_mask[4001] = 1'b1;	pucch_mask[4004] = 1'b1;	pucch_mask[4006] = 1'b1;	pucch_mask[4007] = 1'b1;	pucch_mask[4009] = 1'b1;	pucch_mask[4010] = 1'b1;	pucch_mask[4016] = 1'b1;	pucch_mask[4018] = 1'b1;	pucch_mask[4020] = 1'b1;	pucch_mask[4024] = 1'b1;	pucch_mask[4025] = 1'b1;	pucch_mask[4027] = 1'b1;	pucch_mask[4035] = 1'b1;	pucch_mask[4036] = 1'b1;	pucch_mask[4038] = 1'b1;	pucch_mask[4039] = 1'b1;
        pucch_mask[4041] = 1'b1;	pucch_mask[4042] = 1'b1;	pucch_mask[4048] = 1'b1;	pucch_mask[4050] = 1'b1;	pucch_mask[4052] = 1'b1;	pucch_mask[4059] = 1'b1;	pucch_mask[4067] = 1'b1;	pucch_mask[4076] = 1'b1;	pucch_mask[4077] = 1'b1;	pucch_mask[4078] = 1'b1;	pucch_mask[4080] = 1'b1;	pucch_mask[4083] = 1'b1;	pucch_mask[4085] = 1'b1;	pucch_mask[4088] = 1'b1;	pucch_mask[4089] = 1'b1;	pucch_mask[4092] = 1'b1;
    end

   
    reg [4:0] permutation_for_A20 [32];

    initial begin
        permutation_for_A20[0] =    5'h20;    permutation_for_A20[1] = 5'h01;     permutation_for_A20[2] =  5'h15;    permutation_for_A20[3] = 5'h02;
        permutation_for_A20[4] =    5'h03;    permutation_for_A20[5] = 5'h16;     permutation_for_A20[6] =  5'h04;    permutation_for_A20[7] = 5'h05;
        permutation_for_A20[8] =    5'h17;    permutation_for_A20[9] = 5'h06;     permutation_for_A20[10] = 5'h07;    permutation_for_A20[11] = 5'h18;
        permutation_for_A20[12] =   5'h08;    permutation_for_A20[13] = 5'h09;    permutation_for_A20[14] = 5'h0A;    permutation_for_A20[15] = 5'h19;
        permutation_for_A20[16] =   5'h14;    permutation_for_A20[17] = 5'h1A;    permutation_for_A20[18] = 5'h0B;    permutation_for_A20[19] = 5'h0C;
        permutation_for_A20[20] =   5'h0D;    permutation_for_A20[21] = 5'h0E;    permutation_for_A20[22] = 5'h1B;    permutation_for_A20[23] = 5'h1C;
        permutation_for_A20[24] =   5'h0F;    permutation_for_A20[25] = 5'h10;    permutation_for_A20[26] = 5'h1D;    permutation_for_A20[27] = 5'h11;
        permutation_for_A20[28] =   5'h12;    permutation_for_A20[29] = 5'h13;    permutation_for_A20[30] = 5'h1E;    permutation_for_A20[31] = 5'h1F;
    end

   
	reg [11:0] j = 0; 
	reg [7:0] count = 0;

 	reg 		[DATA_WIDTH - 1:0] rx_symbols_extended [32] = '{32{0}};
    reg signed  [DATA_WIDTH - 1:0] rx_symbols_interleaved [32] = '{32{0}};
    reg signed  [DATA_WIDTH - 1:0] rx_symbols_interleaved_delay [32] = '{32{0}};
	reg signed  [DATA_WIDTH - 1:0] de_masked [32]; 
	reg signed  [DATA_WIDTH - 1:0] de_masked_reg [32]; 
    reg signed  [DATA_WIDTH + 1:0] vec [32]; 
    reg signed  [DATA_WIDTH + 2:0] vec1 [32]; 
    reg signed  [DATA_WIDTH + 3:0] vec2 [32];
    reg signed  [DATA_WIDTH + 3:0] vec2_reg [32];
    reg signed  [DATA_WIDTH + 4:0] vec3 [32];  
    reg signed  [DATA_WIDTH + 5:0] vec4 [32]; 
    reg signed  [DATA_WIDTH + 5:0] vec4_reg [32]; 
    reg signed  [DATA_WIDTH + 5:0] absolute [32]; 
    reg         [DATA_WIDTH + 5:0] max_i;
    reg         [DATA_WIDTH + 5:0] max_val;
	//
    reg [3:0] counter_right = 0;
    reg [3:0] code_length_latch;
	reg [3:0] count_code_length_latch;
    reg [6:0] index_i;
    reg [6:0] max_row;
    reg [6:0] max_column;
    reg sign;
    reg s_axis_tready_i;

	reg s_axis_tlast_delay;

    reg [12:0] decoded_bits;
    reg decoded_bit_srl;

    reg m_axis_tvalid_i;
    reg m_axis_tlast_i;
    
	// FSM
	typedef enum { IDLE, DECODE_START, INTERLEAVED_REG, DE_MASK, DE_MASK_REG, HADAMARD_STAGE_0, HADAMARD_REG_0, HADAMARD_STAGE_1, HADAMARD_REG_1, FIND_MAX, SEND_DATA, XXX } statetype;
	statetype state, next_state;


    // latch code_length
    always_latch begin
        if (code_length_valid)
            code_length_latch <= code_length;
    end 

    // extend symbols
    always_ff @(posedge clk) begin
		if (s_axis_tvalid && s_axis_tready_i) begin
			rx_symbols_extended[NUM_SYMBOLS - 1] <= s_axis_tdata;
            for (int i = (NUM_SYMBOLS - 1); i > 0 ; i--) begin
                rx_symbols_extended[i-1] <= rx_symbols_extended[i];
            end
        end
    end

    // permution data
	always_ff @(posedge clk) begin
		rx_symbols_interleaved_delay <= rx_symbols_interleaved;
		if (s_axis_tlast_delay) 
			for (int i = 1; i < 32; i++) 
				rx_symbols_interleaved[i] <= rx_symbols_extended[permutation_for_A20[i] - 1];
	end 

	always_ff @(posedge clk) begin
		if (!s_axis_aresetn)
			s_axis_tlast_delay <= {1'b0};
		else if (s_axis_tvalid && s_axis_tlast) 
			s_axis_tlast_delay <= s_axis_tlast;
		else
			s_axis_tlast_delay <= 1'b0;
	end

	// pipeline regs
	always_ff @(posedge clk) begin
		count_code_length_latch <= code_length_latch - 1; 
		de_masked_reg <= de_masked;
		vec2_reg <= vec2;
		vec4_reg <= vec4;
	end
	
	always @(state) begin
		if (state == DE_MASK && code_length_latch > 6 && count != 0)
			j = j + 32;
		else if (state == HADAMARD_STAGE_0)
			count = count + 1;
		else if (state == SEND_DATA) begin
			j = 0;
			count = 0;
		end
	end



	// FSM processing
	always_ff @(posedge clk)
		if (!s_axis_aresetn) state <= IDLE;
		else state <= next_state;

    always_comb begin
		next_state = XXX;
		case (state)
		    IDLE 			    :   if (s_axis_tlast_delay)
                                        next_state = DECODE_START;
		    					    else
                                        next_state = IDLE;
			DECODE_START		:		next_state = INTERLEAVED_REG;
			INTERLEAVED_REG		: 		next_state = DE_MASK;
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
		    default 		    : 	    next_state = XXX;
		endcase
	end

    always_comb begin
		case (state)
		IDLE	: begin

                max_i = 0;
                max_val = 0;
                m_axis_tvalid_i = 0;
                m_axis_tlast_i = 1'b0;
				decoded_bit_srl = 1'b0;
				s_axis_tready_i = 1'b1;
		end

		DECODE_START : begin
			s_axis_tready_i = 1'b0;
		end
		
		DE_MASK	: begin

			if (code_length_latch > 6) begin
        	    for (int i = 0; i < 32; i++) begin
        	        de_masked[i] = (pucch_mask[i+j]) ? (~rx_symbols_interleaved_delay[i] + 1) : rx_symbols_interleaved_delay[i]; // mult on pucch_mask
        	    end
        	end
			else
        	    for (int i = 0; i < 32; i++) begin
        	        de_masked[i] = rx_symbols_interleaved_delay[i];
        	    end
        end 

        HADAMARD_STAGE_0	: begin

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
                end else
                    m_axis_tvalid_i = 1'b0;

                if (m_axis_tready && (counter_right == count_code_length_latch)) 
                    m_axis_tlast_i = 1'b1;
                else
                    m_axis_tlast_i = 1'b0;

            end
		endcase
	end

    always_ff @(posedge clk) begin
        if (m_axis_tready && m_axis_tvalid_i) begin
            counter_right <= (counter_right == count_code_length_latch) ? {4{1'b0}} : counter_right + 1;  
        end
    end


    assign m_axis_tdata = decoded_bit_srl;
    assign s_axis_tready = s_axis_tready_i;
    assign m_axis_tvalid = m_axis_tvalid_i;
    assign m_axis_tlast = m_axis_tlast_i;

endmodule
