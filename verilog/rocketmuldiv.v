module rocketmuldiv ( // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111247.2]
  input         clock, // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111248.4]
  input         reset, // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111249.4]
  output        io_req_ready, // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111250.4]
  input         io_req_valid, // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111250.4]
  input  [3:0]  io_req_bits_fn, // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111250.4]
  input  [31:0] io_req_bits_in1, // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111250.4]
  input  [31:0] io_req_bits_in2, // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111250.4]
  input  [4:0]  io_req_bits_tag, // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111250.4]
  input         io_kill, // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111250.4]
  input         io_resp_ready, // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111250.4]
  output        io_resp_valid, // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111250.4]
  output [31:0] io_resp_bits_data, // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111250.4]
  output [4:0]  io_resp_bits_tag // @[:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111250.4]
);
  reg [2:0] state; // @[Multiplier.scala 46:18:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111255.4]
  reg [31:0] _RAND_0;
  reg [4:0] req_tag; // @[Multiplier.scala 48:16:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111256.4]
  reg [31:0] _RAND_1;
  reg [5:0] count; // @[Multiplier.scala 49:18:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111257.4]
  reg [31:0] _RAND_2;
  reg  neg_out; // @[Multiplier.scala 52:20:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111258.4]
  reg [31:0] _RAND_3;
  reg  isHi; // @[Multiplier.scala 53:17:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111259.4]
  reg [31:0] _RAND_4;
  reg  resHi; // @[Multiplier.scala 54:18:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111260.4]
  reg [31:0] _RAND_5;
  reg [32:0] divisor; // @[Multiplier.scala 55:20:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111261.4]
  reg [63:0] _RAND_6;
  reg [65:0] remainder; // @[Multiplier.scala 56:22:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111262.4]
  reg [95:0] _RAND_7;
  wire [3:0] _T_32; // @[Decode.scala 14:65:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111263.4]
  wire  cmdMul; // @[Decode.scala 14:121:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111264.4]
  wire [3:0] _T_38; // @[Decode.scala 14:65:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111266.4]
  wire  _T_40; // @[Decode.scala 14:121:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111267.4]
  wire [3:0] _T_42; // @[Decode.scala 14:65:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111268.4]
  wire  _T_44; // @[Decode.scala 14:121:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111269.4]
  wire  cmdHi; // @[Decode.scala 15:30:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111271.4]
  wire [3:0] _T_49; // @[Decode.scala 14:65:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111272.4]
  wire  _T_51; // @[Decode.scala 14:121:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111273.4]
  wire [3:0] _T_53; // @[Decode.scala 14:65:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111274.4]
  wire  _T_55; // @[Decode.scala 14:121:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111275.4]
  wire  lhsSigned; // @[Decode.scala 15:30:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111277.4]
  wire  _T_62; // @[Decode.scala 14:121:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111279.4]
  wire  rhsSigned; // @[Decode.scala 15:30:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111281.4]
  wire  _T_71; // @[Multiplier.scala 76:48:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111289.4]
  wire  lhs_sign; // @[Multiplier.scala 76:23:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111291.4]
  wire [15:0] _T_77; // @[Multiplier.scala 77:43:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111294.4]
  wire [15:0] _T_79; // @[Multiplier.scala 78:15:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111296.4]
  wire [31:0] lhs_in; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111297.4]
  wire  _T_85; // @[Multiplier.scala 76:48:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111301.4]
  wire  rhs_sign; // @[Multiplier.scala 76:23:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111303.4]
  wire [15:0] _T_91; // @[Multiplier.scala 77:43:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111306.4]
  wire [15:0] _T_93; // @[Multiplier.scala 78:15:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111308.4]
  wire [31:0] rhs_in; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111309.4]
  wire [32:0] _T_94; // @[Multiplier.scala 83:29:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111310.4]
  wire [33:0] _T_95; // @[Multiplier.scala 83:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111311.4]
  wire [33:0] _T_96; // @[Multiplier.scala 83:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111312.4]
  wire [32:0] subtractor; // @[Multiplier.scala 83:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111313.4]
  wire [31:0] _T_97; // @[Multiplier.scala 84:36:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111314.4]
  wire [31:0] _T_98; // @[Multiplier.scala 84:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111315.4]
  wire [31:0] result; // @[Multiplier.scala 84:19:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111316.4]
  wire [32:0] _T_100; // @[Multiplier.scala 85:27:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111317.4]
  wire [32:0] _T_101; // @[Multiplier.scala 85:27:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111318.4]
  wire [31:0] negated_remainder; // @[Multiplier.scala 85:27:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111319.4]
  wire  _T_102; // @[Multiplier.scala 87:39:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111320.4]
  wire  _T_103; // @[Multiplier.scala 88:20:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111322.6]
  wire [65:0] _GEN_0; // @[Multiplier.scala 88:27:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111323.6]
  wire  _T_104; // @[Multiplier.scala 91:18:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111326.6]
  wire [32:0] _GEN_1; // @[Multiplier.scala 91:25:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111327.6]
  wire [65:0] _GEN_2; // @[Multiplier.scala 87:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111321.4]
  wire [32:0] _GEN_3; // @[Multiplier.scala 87:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111321.4]
  wire [2:0] _GEN_4; // @[Multiplier.scala 87:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111321.4]
  wire  _T_105; // @[Multiplier.scala 96:39:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111332.4]
  wire [65:0] _GEN_5; // @[Multiplier.scala 96:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111333.4]
  wire [2:0] _GEN_6; // @[Multiplier.scala 96:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111333.4]
  wire  _GEN_7; // @[Multiplier.scala 96:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111333.4]
  wire  _T_107; // @[Multiplier.scala 101:39:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111338.4]
  wire [32:0] _T_108; // @[Multiplier.scala 102:31:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111340.6]
  wire [64:0] _T_110; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111342.6]
  wire  _T_111; // @[Multiplier.scala 103:31:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111343.6]
  wire [31:0] _T_112; // @[Multiplier.scala 104:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111344.6]
  wire [32:0] _T_113; // @[Multiplier.scala 105:23:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111345.6]
  wire [32:0] _T_114; // @[Multiplier.scala 105:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111346.6]
  wire [32:0] _T_115; // @[Multiplier.scala 106:26:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111347.6]
  wire [7:0] _T_116; // @[Multiplier.scala 107:38:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111348.6]
  wire [8:0] _T_117; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111349.6]
  wire [8:0] _T_118; // @[Multiplier.scala 107:60:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111350.6]
  wire [32:0] _GEN_35; // @[Multiplier.scala 107:67:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111351.6]
  wire [41:0] _T_119; // @[Multiplier.scala 107:67:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111351.6]
  wire [41:0] _GEN_36; // @[Multiplier.scala 107:76:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111352.6]
  wire [42:0] _T_120; // @[Multiplier.scala 107:76:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111352.6]
  wire [41:0] _T_121; // @[Multiplier.scala 107:76:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111353.6]
  wire [41:0] _T_122; // @[Multiplier.scala 107:76:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111354.6]
  wire [23:0] _T_123; // @[Multiplier.scala 108:38:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111355.6]
  wire [41:0] _T_124; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111356.6]
  wire [65:0] _T_125; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111357.6]
  wire  _T_127; // @[Multiplier.scala 109:32:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111358.6]
  wire  _T_128; // @[Multiplier.scala 109:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111359.6]
  wire  _T_143; // @[Multiplier.scala 113:7:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111368.6]
  wire [32:0] _T_158; // @[Multiplier.scala 115:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111380.6]
  wire [31:0] _T_160; // @[Multiplier.scala 115:82:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111382.6]
  wire [64:0] _T_161; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111383.6]
  wire [32:0] _T_162; // @[Multiplier.scala 116:34:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111384.6]
  wire [31:0] _T_163; // @[Multiplier.scala 116:67:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111385.6]
  wire [33:0] _T_164; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111386.6]
  wire [65:0] _T_165; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111387.6]
  wire [6:0] _T_167; // @[Multiplier.scala 118:20:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111389.6]
  wire [5:0] _T_168; // @[Multiplier.scala 118:20:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111390.6]
  wire  _T_170; // @[Multiplier.scala 119:25:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111392.6]
  wire [2:0] _GEN_8; // @[Multiplier.scala 119:51:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111394.6]
  wire  _GEN_9; // @[Multiplier.scala 119:51:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111394.6]
  wire [65:0] _GEN_10; // @[Multiplier.scala 101:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111339.4]
  wire [5:0] _GEN_11; // @[Multiplier.scala 101:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111339.4]
  wire [2:0] _GEN_12; // @[Multiplier.scala 101:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111339.4]
  wire  _GEN_13; // @[Multiplier.scala 101:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111339.4]
  wire  _T_172; // @[Multiplier.scala 124:39:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111399.4]
  wire  _T_173; // @[Multiplier.scala 128:28:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111401.6]
  wire [31:0] _T_174; // @[Multiplier.scala 129:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111402.6]
  wire [31:0] _T_175; // @[Multiplier.scala 129:45:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111403.6]
  wire [31:0] _T_176; // @[Multiplier.scala 129:14:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111404.6]
  wire  _T_179; // @[Multiplier.scala 129:67:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111406.6]
  wire [63:0] _T_180; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111407.6]
  wire [64:0] _T_181; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111408.6]
  wire  _T_183; // @[Multiplier.scala 133:17:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111410.6]
  wire [2:0] _T_184; // @[Multiplier.scala 134:19:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111412.8]
  wire [2:0] _GEN_14; // @[Multiplier.scala 133:38:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111411.6]
  wire  _GEN_15; // @[Multiplier.scala 133:38:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111411.6]
  wire  _T_189; // @[Multiplier.scala 141:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111419.6]
  wire  _T_193; // @[Multiplier.scala 141:30:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111422.6]
  wire  _T_196; // @[Multiplier.scala 155:18:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111424.6]
  wire  _GEN_16; // @[Multiplier.scala 155:28:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111425.6]
  wire [65:0] _GEN_17; // @[Multiplier.scala 124:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111400.4]
  wire [2:0] _GEN_18; // @[Multiplier.scala 124:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111400.4]
  wire  _GEN_19; // @[Multiplier.scala 124:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111400.4]
  wire [5:0] _GEN_20; // @[Multiplier.scala 124:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111400.4]
  wire  _GEN_21; // @[Multiplier.scala 124:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111400.4]
  wire  _T_198; // @[Decoupled.scala 30:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111429.4]
  wire  _T_199; // @[Multiplier.scala 157:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111430.4]
  wire [2:0] _GEN_22; // @[Multiplier.scala 157:36:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111431.4]
  wire  _T_200; // @[Decoupled.scala 30:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111434.4]
  wire  _T_201; // @[Multiplier.scala 161:46:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111436.6]
  wire [2:0] _T_202; // @[Multiplier.scala 161:36:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111437.6]
  wire [2:0] _T_203; // @[Multiplier.scala 161:17:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111438.6]
  wire  _T_213; // @[Multiplier.scala 165:46:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111447.6]
  wire  _T_214; // @[Multiplier.scala 165:19:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111448.6]
  wire [32:0] _T_215; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111450.6]
  wire [2:0] _GEN_23; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  wire  _GEN_24; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  wire  _GEN_25; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  wire [5:0] _GEN_26; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  wire  _GEN_27; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  wire [32:0] _GEN_28; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  wire [65:0] _GEN_29; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  wire [4:0] _GEN_34; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  wire [15:0] _T_227; // @[Multiplier.scala 172:69:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111464.4]
  wire [15:0] loOut; // @[Multiplier.scala 172:86:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111465.4]
  wire [31:0] _T_239; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111475.4]
  wire  _T_240; // @[Multiplier.scala 176:27:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111477.4]
  wire  _T_241; // @[Multiplier.scala 176:51:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111478.4]
  wire  _T_242; // @[Multiplier.scala 176:42:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111479.4]
  wire  _T_243; // @[Multiplier.scala 177:25:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111481.4]
  assign _T_32 = io_req_bits_fn & 4'h4; // @[Decode.scala 14:65:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111263.4]
  assign cmdMul = _T_32 == 4'h0; // @[Decode.scala 14:121:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111264.4]
  assign _T_38 = io_req_bits_fn & 4'h5; // @[Decode.scala 14:65:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111266.4]
  assign _T_40 = _T_38 == 4'h1; // @[Decode.scala 14:121:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111267.4]
  assign _T_42 = io_req_bits_fn & 4'h2; // @[Decode.scala 14:65:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111268.4]
  assign _T_44 = _T_42 == 4'h2; // @[Decode.scala 14:121:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111269.4]
  assign cmdHi = _T_40 | _T_44; // @[Decode.scala 15:30:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111271.4]
  assign _T_49 = io_req_bits_fn & 4'h6; // @[Decode.scala 14:65:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111272.4]
  assign _T_51 = _T_49 == 4'h0; // @[Decode.scala 14:121:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111273.4]
  assign _T_53 = io_req_bits_fn & 4'h1; // @[Decode.scala 14:65:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111274.4]
  assign _T_55 = _T_53 == 4'h0; // @[Decode.scala 14:121:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111275.4]
  assign lhsSigned = _T_51 | _T_55; // @[Decode.scala 15:30:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111277.4]
  assign _T_62 = _T_38 == 4'h4; // @[Decode.scala 14:121:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111279.4]
  assign rhsSigned = _T_51 | _T_62; // @[Decode.scala 15:30:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111281.4]
  assign _T_71 = io_req_bits_in1[31]; // @[Multiplier.scala 76:48:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111289.4]
  assign lhs_sign = lhsSigned & _T_71; // @[Multiplier.scala 76:23:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111291.4]
  assign _T_77 = io_req_bits_in1[31:16]; // @[Multiplier.scala 77:43:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111294.4]
  assign _T_79 = io_req_bits_in1[15:0]; // @[Multiplier.scala 78:15:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111296.4]
  assign lhs_in = {_T_77,_T_79}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111297.4]
  assign _T_85 = io_req_bits_in2[31]; // @[Multiplier.scala 76:48:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111301.4]
  assign rhs_sign = rhsSigned & _T_85; // @[Multiplier.scala 76:23:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111303.4]
  assign _T_91 = io_req_bits_in2[31:16]; // @[Multiplier.scala 77:43:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111306.4]
  assign _T_93 = io_req_bits_in2[15:0]; // @[Multiplier.scala 78:15:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111308.4]
  assign rhs_in = {_T_91,_T_93}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111309.4]
  assign _T_94 = remainder[64:32]; // @[Multiplier.scala 83:29:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111310.4]
  assign _T_95 = _T_94 - divisor; // @[Multiplier.scala 83:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111311.4]
  assign _T_96 = $unsigned(_T_95); // @[Multiplier.scala 83:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111312.4]
  assign subtractor = _T_96[32:0]; // @[Multiplier.scala 83:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111313.4]
  assign _T_97 = remainder[64:33]; // @[Multiplier.scala 84:36:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111314.4]
  assign _T_98 = remainder[31:0]; // @[Multiplier.scala 84:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111315.4]
  assign result = resHi ? _T_97 : _T_98; // @[Multiplier.scala 84:19:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111316.4]
  assign _T_100 = 32'h0 - result; // @[Multiplier.scala 85:27:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111317.4]
  assign _T_101 = $unsigned(_T_100); // @[Multiplier.scala 85:27:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111318.4]
  assign negated_remainder = _T_101[31:0]; // @[Multiplier.scala 85:27:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111319.4]
  assign _T_102 = state == 3'h1; // @[Multiplier.scala 87:39:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111320.4]
  assign _T_103 = remainder[31]; // @[Multiplier.scala 88:20:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111322.6]
  assign _GEN_0 = _T_103 ? {{34'd0}, negated_remainder} : remainder; // @[Multiplier.scala 88:27:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111323.6]
  assign _T_104 = divisor[31]; // @[Multiplier.scala 91:18:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111326.6]
  assign _GEN_1 = _T_104 ? subtractor : divisor; // @[Multiplier.scala 91:25:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111327.6]
  assign _GEN_2 = _T_102 ? _GEN_0 : remainder; // @[Multiplier.scala 87:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111321.4]
  assign _GEN_3 = _T_102 ? _GEN_1 : divisor; // @[Multiplier.scala 87:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111321.4]
  assign _GEN_4 = _T_102 ? 3'h3 : state; // @[Multiplier.scala 87:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111321.4]
  assign _T_105 = state == 3'h5; // @[Multiplier.scala 96:39:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111332.4]
  assign _GEN_5 = _T_105 ? {{34'd0}, negated_remainder} : _GEN_2; // @[Multiplier.scala 96:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111333.4]
  assign _GEN_6 = _T_105 ? 3'h7 : _GEN_4; // @[Multiplier.scala 96:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111333.4]
  assign _GEN_7 = _T_105 ? 1'h0 : resHi; // @[Multiplier.scala 96:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111333.4]
  assign _T_107 = state == 3'h2; // @[Multiplier.scala 101:39:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111338.4]
  assign _T_108 = remainder[65:33]; // @[Multiplier.scala 102:31:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111340.6]
  assign _T_110 = {_T_108,_T_98}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111342.6]
  assign _T_111 = remainder[32]; // @[Multiplier.scala 103:31:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111343.6]
  assign _T_112 = _T_110[31:0]; // @[Multiplier.scala 104:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111344.6]
  assign _T_113 = _T_110[64:32]; // @[Multiplier.scala 105:23:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111345.6]
  assign _T_114 = $signed(_T_113); // @[Multiplier.scala 105:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111346.6]
  assign _T_115 = $signed(divisor); // @[Multiplier.scala 106:26:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111347.6]
  assign _T_116 = _T_112[7:0]; // @[Multiplier.scala 107:38:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111348.6]
  assign _T_117 = {_T_111,_T_116}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111349.6]
  assign _T_118 = $signed(_T_117); // @[Multiplier.scala 107:60:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111350.6]
  assign _GEN_35 = {{24{_T_118[8]}},_T_118}; // @[Multiplier.scala 107:67:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111351.6]
  assign _T_119 = $signed(_GEN_35) * $signed(_T_115); // @[Multiplier.scala 107:67:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111351.6]
  assign _GEN_36 = {{9{_T_114[32]}},_T_114}; // @[Multiplier.scala 107:76:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111352.6]
  assign _T_120 = $signed(_T_119) + $signed(_GEN_36); // @[Multiplier.scala 107:76:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111352.6]
  assign _T_121 = _T_120[41:0]; // @[Multiplier.scala 107:76:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111353.6]
  assign _T_122 = $signed(_T_121); // @[Multiplier.scala 107:76:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111354.6]
  assign _T_123 = _T_112[31:8]; // @[Multiplier.scala 108:38:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111355.6]
  assign _T_124 = $unsigned(_T_122); // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111356.6]
  assign _T_125 = {_T_124,_T_123}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111357.6]
  assign _T_127 = count == 6'h2; // @[Multiplier.scala 109:32:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111358.6]
  assign _T_128 = _T_127 & neg_out; // @[Multiplier.scala 109:57:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111359.6]
  assign _T_143 = isHi == 1'h0; // @[Multiplier.scala 113:7:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111368.6]
  assign _T_158 = _T_125[64:32]; // @[Multiplier.scala 115:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111380.6]
  assign _T_160 = _T_125[31:0]; // @[Multiplier.scala 115:82:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111382.6]
  assign _T_161 = {_T_158,_T_160}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111383.6]
  assign _T_162 = _T_161[64:32]; // @[Multiplier.scala 116:34:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111384.6]
  assign _T_163 = _T_161[31:0]; // @[Multiplier.scala 116:67:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111385.6]
  assign _T_164 = {_T_162,_T_128}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111386.6]
  assign _T_165 = {_T_164,_T_163}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111387.6]
  assign _T_167 = count + 6'h1; // @[Multiplier.scala 118:20:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111389.6]
  assign _T_168 = _T_167[5:0]; // @[Multiplier.scala 118:20:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111390.6]
  assign _T_170 = count == 6'h3; // @[Multiplier.scala 119:25:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111392.6]
  assign _GEN_8 = _T_170 ? 3'h6 : _GEN_6; // @[Multiplier.scala 119:51:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111394.6]
  assign _GEN_9 = _T_170 ? isHi : _GEN_7; // @[Multiplier.scala 119:51:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111394.6]
  assign _GEN_10 = _T_107 ? _T_165 : _GEN_5; // @[Multiplier.scala 101:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111339.4]
  assign _GEN_11 = _T_107 ? _T_168 : count; // @[Multiplier.scala 101:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111339.4]
  assign _GEN_12 = _T_107 ? _GEN_8 : _GEN_6; // @[Multiplier.scala 101:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111339.4]
  assign _GEN_13 = _T_107 ? _GEN_9 : _GEN_7; // @[Multiplier.scala 101:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111339.4]
  assign _T_172 = state == 3'h3; // @[Multiplier.scala 124:39:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111399.4]
  assign _T_173 = subtractor[32]; // @[Multiplier.scala 128:28:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111401.6]
  assign _T_174 = remainder[63:32]; // @[Multiplier.scala 129:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111402.6]
  assign _T_175 = subtractor[31:0]; // @[Multiplier.scala 129:45:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111403.6]
  assign _T_176 = _T_173 ? _T_174 : _T_175; // @[Multiplier.scala 129:14:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111404.6]
  assign _T_179 = _T_173 == 1'h0; // @[Multiplier.scala 129:67:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111406.6]
  assign _T_180 = {_T_176,_T_98}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111407.6]
  assign _T_181 = {_T_180,_T_179}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111408.6]
  assign _T_183 = count == 6'h20; // @[Multiplier.scala 133:17:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111410.6]
  assign _T_184 = neg_out ? 3'h5 : 3'h7; // @[Multiplier.scala 134:19:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111412.8]
  assign _GEN_14 = _T_183 ? _T_184 : _GEN_12; // @[Multiplier.scala 133:38:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111411.6]
  assign _GEN_15 = _T_183 ? isHi : _GEN_13; // @[Multiplier.scala 133:38:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111411.6]
  assign _T_189 = count == 6'h0; // @[Multiplier.scala 141:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111419.6]
  assign _T_193 = _T_189 & _T_179; // @[Multiplier.scala 141:30:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111422.6]
  assign _T_196 = _T_193 & _T_143; // @[Multiplier.scala 155:18:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111424.6]
  assign _GEN_16 = _T_196 ? 1'h0 : neg_out; // @[Multiplier.scala 155:28:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111425.6]
  assign _GEN_17 = _T_172 ? {{1'd0}, _T_181} : _GEN_10; // @[Multiplier.scala 124:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111400.4]
  assign _GEN_18 = _T_172 ? _GEN_14 : _GEN_12; // @[Multiplier.scala 124:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111400.4]
  assign _GEN_19 = _T_172 ? _GEN_15 : _GEN_13; // @[Multiplier.scala 124:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111400.4]
  assign _GEN_20 = _T_172 ? _T_168 : _GEN_11; // @[Multiplier.scala 124:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111400.4]
  assign _GEN_21 = _T_172 ? _GEN_16 : neg_out; // @[Multiplier.scala 124:50:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111400.4]
  assign _T_198 = io_resp_ready & io_resp_valid; // @[Decoupled.scala 30:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111429.4]
  assign _T_199 = _T_198 | io_kill; // @[Multiplier.scala 157:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111430.4]
  assign _GEN_22 = _T_199 ? 3'h0 : _GEN_18; // @[Multiplier.scala 157:36:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111431.4]
  assign _T_200 = io_req_ready & io_req_valid; // @[Decoupled.scala 30:37:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111434.4]
  assign _T_201 = lhs_sign | rhs_sign; // @[Multiplier.scala 161:46:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111436.6]
  assign _T_202 = _T_201 ? 3'h1 : 3'h3; // @[Multiplier.scala 161:36:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111437.6]
  assign _T_203 = cmdMul ? 3'h2 : _T_202; // @[Multiplier.scala 161:17:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111438.6]
  assign _T_213 = lhs_sign != rhs_sign; // @[Multiplier.scala 165:46:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111447.6]
  assign _T_214 = cmdHi ? lhs_sign : _T_213; // @[Multiplier.scala 165:19:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111448.6]
  assign _T_215 = {rhs_sign,rhs_in}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111450.6]
  assign _GEN_23 = _T_200 ? _T_203 : _GEN_22; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  assign _GEN_24 = _T_200 ? cmdHi : isHi; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  assign _GEN_25 = _T_200 ? 1'h0 : _GEN_19; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  assign _GEN_26 = _T_200 ? 6'h0 : _GEN_20; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  assign _GEN_27 = _T_200 ? _T_214 : _GEN_21; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  assign _GEN_28 = _T_200 ? _T_215 : _GEN_3; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  assign _GEN_29 = _T_200 ? {{34'd0}, lhs_in} : _GEN_17; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  assign _GEN_34 = _T_200 ? io_req_bits_tag : req_tag; // @[Multiplier.scala 160:24:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111435.4]
  assign _T_227 = result[31:16]; // @[Multiplier.scala 172:69:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111464.4]
  assign loOut = result[15:0]; // @[Multiplier.scala 172:86:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111465.4]
  assign _T_239 = {_T_227,loOut}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111475.4]
  assign _T_240 = state == 3'h6; // @[Multiplier.scala 176:27:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111477.4]
  assign _T_241 = state == 3'h7; // @[Multiplier.scala 176:51:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111478.4]
  assign _T_242 = _T_240 | _T_241; // @[Multiplier.scala 176:42:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111479.4]
  assign _T_243 = state == 3'h0; // @[Multiplier.scala 177:25:freechips.rocketchip.system.DefaultConfigWithRVFIMonitors.fir@111481.4]
  assign io_req_ready = _T_243;
  assign io_resp_valid = _T_242;
  assign io_resp_bits_data = _T_239;
  assign io_resp_bits_tag = req_tag;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  state = _RAND_0[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  req_tag = _RAND_1[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{$random}};
  count = _RAND_2[5:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{$random}};
  neg_out = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{$random}};
  isHi = _RAND_4[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{$random}};
  resHi = _RAND_5[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {2{$random}};
  divisor = _RAND_6[32:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {3{$random}};
  remainder = _RAND_7[65:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      state <= 3'h0;
    end else begin
      if (_T_200) begin
        if (cmdMul) begin
          state <= 3'h2;
        end else begin
          if (_T_201) begin
            state <= 3'h1;
          end else begin
            state <= 3'h3;
          end
        end
      end else begin
        if (_T_199) begin
          state <= 3'h0;
        end else begin
          if (_T_172) begin
            if (_T_183) begin
              if (neg_out) begin
                state <= 3'h5;
              end else begin
                state <= 3'h7;
              end
            end else begin
              if (_T_107) begin
                if (_T_170) begin
                  state <= 3'h6;
                end else begin
                  if (_T_105) begin
                    state <= 3'h7;
                  end else begin
                    if (_T_102) begin
                      state <= 3'h3;
                    end
                  end
                end
              end else begin
                if (_T_105) begin
                  state <= 3'h7;
                end else begin
                  if (_T_102) begin
                    state <= 3'h3;
                  end
                end
              end
            end
          end else begin
            if (_T_107) begin
              if (_T_170) begin
                state <= 3'h6;
              end else begin
                if (_T_105) begin
                  state <= 3'h7;
                end else begin
                  if (_T_102) begin
                    state <= 3'h3;
                  end
                end
              end
            end else begin
              if (_T_105) begin
                state <= 3'h7;
              end else begin
                if (_T_102) begin
                  state <= 3'h3;
                end
              end
            end
          end
        end
      end
    end
    if (_T_200) begin
      req_tag <= io_req_bits_tag;
    end
    if (_T_200) begin
      count <= 6'h0;
    end else begin
      if (_T_172) begin
        count <= _T_168;
      end else begin
        if (_T_107) begin
          count <= _T_168;
        end
      end
    end
    if (_T_200) begin
      if (cmdHi) begin
        neg_out <= lhs_sign;
      end else begin
        neg_out <= _T_213;
      end
    end else begin
      if (_T_172) begin
        if (_T_196) begin
          neg_out <= 1'h0;
        end
      end
    end
    if (_T_200) begin
      isHi <= cmdHi;
    end
    if (_T_200) begin
      resHi <= 1'h0;
    end else begin
      if (_T_172) begin
        if (_T_183) begin
          resHi <= isHi;
        end else begin
          if (_T_107) begin
            if (_T_170) begin
              resHi <= isHi;
            end else begin
              if (_T_105) begin
                resHi <= 1'h0;
              end
            end
          end else begin
            if (_T_105) begin
              resHi <= 1'h0;
            end
          end
        end
      end else begin
        if (_T_107) begin
          if (_T_170) begin
            resHi <= isHi;
          end else begin
            if (_T_105) begin
              resHi <= 1'h0;
            end
          end
        end else begin
          if (_T_105) begin
            resHi <= 1'h0;
          end
        end
      end
    end
    if (_T_200) begin
      divisor <= _T_215;
    end else begin
      if (_T_102) begin
        if (_T_104) begin
          divisor <= subtractor;
        end
      end
    end
    if (_T_200) begin
      remainder <= {{34'd0}, lhs_in};
    end else begin
      if (_T_172) begin
        remainder <= {{1'd0}, _T_181};
      end else begin
        if (_T_107) begin
          remainder <= _T_165;
        end else begin
          if (_T_105) begin
            remainder <= {{34'd0}, negated_remainder};
          end else begin
            if (_T_102) begin
              if (_T_103) begin
                remainder <= {{34'd0}, negated_remainder};
              end
            end
          end
        end
      end
    end
  end
endmodule
