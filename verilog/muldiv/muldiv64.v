module MulDiv64 ( // @[:freechips.rocketchip.system.MulDivConfig64.fir@157101.2]
  input         clock, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157102.4]
  input         reset, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157103.4]
  output        io_req_ready, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157104.4]
  input         io_req_valid, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157104.4]
  input  [3:0]  io_req_bits_fn, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157104.4]
  input         io_req_bits_dw, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157104.4]
  input  [63:0] io_req_bits_in1, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157104.4]
  input  [63:0] io_req_bits_in2, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157104.4]
  input  [4:0]  io_req_bits_tag, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157104.4]
  input         io_kill, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157104.4]
  input         io_resp_ready, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157104.4]
  output        io_resp_valid, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157104.4]
  output [63:0] io_resp_bits_data, // @[:freechips.rocketchip.system.MulDivConfig64.fir@157104.4]
  output [4:0]  io_resp_bits_tag // @[:freechips.rocketchip.system.MulDivConfig64.fir@157104.4]
);
  reg [2:0] state; // @[Multiplier.scala 51:18:freechips.rocketchip.system.MulDivConfig64.fir@157109.4]
  reg [31:0] _RAND_0;
  reg  req_dw; // @[Multiplier.scala 53:16:freechips.rocketchip.system.MulDivConfig64.fir@157110.4]
  reg [31:0] _RAND_1;
  reg [4:0] req_tag; // @[Multiplier.scala 53:16:freechips.rocketchip.system.MulDivConfig64.fir@157110.4]
  reg [31:0] _RAND_2;
  reg [6:0] count; // @[Multiplier.scala 54:18:freechips.rocketchip.system.MulDivConfig64.fir@157111.4]
  reg [31:0] _RAND_3;
  reg  neg_out; // @[Multiplier.scala 57:20:freechips.rocketchip.system.MulDivConfig64.fir@157112.4]
  reg [31:0] _RAND_4;
  reg  isHi; // @[Multiplier.scala 58:17:freechips.rocketchip.system.MulDivConfig64.fir@157113.4]
  reg [31:0] _RAND_5;
  reg  resHi; // @[Multiplier.scala 59:18:freechips.rocketchip.system.MulDivConfig64.fir@157114.4]
  reg [31:0] _RAND_6;
  reg [64:0] divisor; // @[Multiplier.scala 60:20:freechips.rocketchip.system.MulDivConfig64.fir@157115.4]
  reg [95:0] _RAND_7;
  reg [129:0] remainder; // @[Multiplier.scala 61:22:freechips.rocketchip.system.MulDivConfig64.fir@157116.4]
  reg [159:0] _RAND_8;
  wire [3:0] _T; // @[Decode.scala 14:65:freechips.rocketchip.system.MulDivConfig64.fir@157117.4]
  wire  cmdMul; // @[Decode.scala 14:121:freechips.rocketchip.system.MulDivConfig64.fir@157118.4]
  wire [3:0] _T_3; // @[Decode.scala 14:65:freechips.rocketchip.system.MulDivConfig64.fir@157120.4]
  wire  _T_4; // @[Decode.scala 14:121:freechips.rocketchip.system.MulDivConfig64.fir@157121.4]
  wire [3:0] _T_5; // @[Decode.scala 14:65:freechips.rocketchip.system.MulDivConfig64.fir@157122.4]
  wire  _T_6; // @[Decode.scala 14:121:freechips.rocketchip.system.MulDivConfig64.fir@157123.4]
  wire  cmdHi; // @[Decode.scala 15:30:freechips.rocketchip.system.MulDivConfig64.fir@157125.4]
  wire [3:0] _T_9; // @[Decode.scala 14:65:freechips.rocketchip.system.MulDivConfig64.fir@157126.4]
  wire  _T_10; // @[Decode.scala 14:121:freechips.rocketchip.system.MulDivConfig64.fir@157127.4]
  wire [3:0] _T_11; // @[Decode.scala 14:65:freechips.rocketchip.system.MulDivConfig64.fir@157128.4]
  wire  _T_12; // @[Decode.scala 14:121:freechips.rocketchip.system.MulDivConfig64.fir@157129.4]
  wire  lhsSigned; // @[Decode.scala 15:30:freechips.rocketchip.system.MulDivConfig64.fir@157131.4]
  wire  _T_16; // @[Decode.scala 14:121:freechips.rocketchip.system.MulDivConfig64.fir@157133.4]
  wire  rhsSigned; // @[Decode.scala 15:30:freechips.rocketchip.system.MulDivConfig64.fir@157135.4]
  wire  _T_19; // @[Multiplier.scala 78:62:freechips.rocketchip.system.MulDivConfig64.fir@157140.4]
  wire  _T_21; // @[Multiplier.scala 81:38:freechips.rocketchip.system.MulDivConfig64.fir@157142.4]
  wire  _T_22; // @[Multiplier.scala 81:48:freechips.rocketchip.system.MulDivConfig64.fir@157143.4]
  wire  _T_23; // @[Multiplier.scala 81:29:freechips.rocketchip.system.MulDivConfig64.fir@157144.4]
  wire  lhs_sign; // @[Multiplier.scala 81:23:freechips.rocketchip.system.MulDivConfig64.fir@157145.4]
  wire [31:0] _T_25; // @[Bitwise.scala 72:12:freechips.rocketchip.system.MulDivConfig64.fir@157147.4]
  wire [31:0] _T_26; // @[Multiplier.scala 82:43:freechips.rocketchip.system.MulDivConfig64.fir@157148.4]
  wire [31:0] _T_27; // @[Multiplier.scala 82:17:freechips.rocketchip.system.MulDivConfig64.fir@157149.4]
  wire [31:0] _T_28; // @[Multiplier.scala 83:15:freechips.rocketchip.system.MulDivConfig64.fir@157150.4]
  wire [63:0] lhs_in; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157151.4]
  wire  _T_31; // @[Multiplier.scala 81:38:freechips.rocketchip.system.MulDivConfig64.fir@157154.4]
  wire  _T_32; // @[Multiplier.scala 81:48:freechips.rocketchip.system.MulDivConfig64.fir@157155.4]
  wire  _T_33; // @[Multiplier.scala 81:29:freechips.rocketchip.system.MulDivConfig64.fir@157156.4]
  wire  rhs_sign; // @[Multiplier.scala 81:23:freechips.rocketchip.system.MulDivConfig64.fir@157157.4]
  wire [31:0] _T_35; // @[Bitwise.scala 72:12:freechips.rocketchip.system.MulDivConfig64.fir@157159.4]
  wire [31:0] _T_36; // @[Multiplier.scala 82:43:freechips.rocketchip.system.MulDivConfig64.fir@157160.4]
  wire [31:0] _T_37; // @[Multiplier.scala 82:17:freechips.rocketchip.system.MulDivConfig64.fir@157161.4]
  wire [31:0] _T_38; // @[Multiplier.scala 83:15:freechips.rocketchip.system.MulDivConfig64.fir@157162.4]
  wire [64:0] _T_39; // @[Multiplier.scala 88:29:freechips.rocketchip.system.MulDivConfig64.fir@157164.4]
  wire [64:0] subtractor; // @[Multiplier.scala 88:37:freechips.rocketchip.system.MulDivConfig64.fir@157166.4]
  wire [63:0] _T_41; // @[Multiplier.scala 89:36:freechips.rocketchip.system.MulDivConfig64.fir@157167.4]
  wire [63:0] _T_42; // @[Multiplier.scala 89:57:freechips.rocketchip.system.MulDivConfig64.fir@157168.4]
  wire [63:0] result; // @[Multiplier.scala 89:19:freechips.rocketchip.system.MulDivConfig64.fir@157169.4]
  wire [63:0] negated_remainder; // @[Multiplier.scala 90:27:freechips.rocketchip.system.MulDivConfig64.fir@157171.4]
  wire  _T_44; // @[Multiplier.scala 92:39:freechips.rocketchip.system.MulDivConfig64.fir@157172.4]
  wire  _T_45; // @[Multiplier.scala 93:20:freechips.rocketchip.system.MulDivConfig64.fir@157174.6]
  wire  _T_46; // @[Multiplier.scala 96:18:freechips.rocketchip.system.MulDivConfig64.fir@157178.6]
  wire  _T_47; // @[Multiplier.scala 101:39:freechips.rocketchip.system.MulDivConfig64.fir@157184.4]
  wire  _T_48; // @[Multiplier.scala 106:39:freechips.rocketchip.system.MulDivConfig64.fir@157190.4]
  wire [64:0] _T_49; // @[Multiplier.scala 107:31:freechips.rocketchip.system.MulDivConfig64.fir@157192.6]
  wire [128:0] _T_51; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157194.6]
  wire  _T_52; // @[Multiplier.scala 108:31:freechips.rocketchip.system.MulDivConfig64.fir@157195.6]
  wire [63:0] _T_53; // @[Multiplier.scala 109:24:freechips.rocketchip.system.MulDivConfig64.fir@157196.6]
  wire [64:0] _T_54; // @[Multiplier.scala 110:23:freechips.rocketchip.system.MulDivConfig64.fir@157197.6]
  wire [64:0] _T_55; // @[Multiplier.scala 110:37:freechips.rocketchip.system.MulDivConfig64.fir@157198.6]
  wire [64:0] _T_56; // @[Multiplier.scala 111:26:freechips.rocketchip.system.MulDivConfig64.fir@157199.6]
  wire [7:0] _T_57; // @[Multiplier.scala 112:38:freechips.rocketchip.system.MulDivConfig64.fir@157200.6]
  wire [8:0] _T_58; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157201.6]
  wire [8:0] _T_59; // @[Multiplier.scala 112:60:freechips.rocketchip.system.MulDivConfig64.fir@157202.6]
  wire [64:0] _GEN_37; // @[Multiplier.scala 112:67:freechips.rocketchip.system.MulDivConfig64.fir@157203.6]
  wire [73:0] _T_60; // @[Multiplier.scala 112:67:freechips.rocketchip.system.MulDivConfig64.fir@157203.6]
  wire [73:0] _GEN_38; // @[Multiplier.scala 112:76:freechips.rocketchip.system.MulDivConfig64.fir@157204.6]
  wire [73:0] _T_62; // @[Multiplier.scala 112:76:freechips.rocketchip.system.MulDivConfig64.fir@157205.6]
  wire [73:0] _T_63; // @[Multiplier.scala 112:76:freechips.rocketchip.system.MulDivConfig64.fir@157206.6]
  wire [55:0] _T_64; // @[Multiplier.scala 113:38:freechips.rocketchip.system.MulDivConfig64.fir@157207.6]
  wire [73:0] _T_65; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157208.6]
  wire [129:0] _T_66; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157209.6]
  wire  _T_67; // @[Multiplier.scala 114:32:freechips.rocketchip.system.MulDivConfig64.fir@157210.6]
  wire  _T_68; // @[Multiplier.scala 114:57:freechips.rocketchip.system.MulDivConfig64.fir@157211.6]
  wire [10:0] _T_69; // @[Multiplier.scala 116:56:freechips.rocketchip.system.MulDivConfig64.fir@157212.6]
  wire [5:0] _T_70; // @[Multiplier.scala 116:72:freechips.rocketchip.system.MulDivConfig64.fir@157213.6]
  wire [64:0] _T_71; // @[Multiplier.scala 116:46:freechips.rocketchip.system.MulDivConfig64.fir@157214.6]
  wire [63:0] _T_72; // @[Multiplier.scala 116:91:freechips.rocketchip.system.MulDivConfig64.fir@157215.6]
  wire  _T_73; // @[Multiplier.scala 117:47:freechips.rocketchip.system.MulDivConfig64.fir@157216.6]
  wire  _T_75; // @[Multiplier.scala 117:81:freechips.rocketchip.system.MulDivConfig64.fir@157218.6]
  wire  _T_76; // @[Multiplier.scala 117:72:freechips.rocketchip.system.MulDivConfig64.fir@157219.6]
  wire  _T_77; // @[Multiplier.scala 118:7:freechips.rocketchip.system.MulDivConfig64.fir@157220.6]
  wire  _T_78; // @[Multiplier.scala 117:87:freechips.rocketchip.system.MulDivConfig64.fir@157221.6]
  wire [63:0] _T_79; // @[Multiplier.scala 118:26:freechips.rocketchip.system.MulDivConfig64.fir@157222.6]
  wire [63:0] _T_80; // @[Multiplier.scala 118:24:freechips.rocketchip.system.MulDivConfig64.fir@157223.6]
  wire  _T_81; // @[Multiplier.scala 118:37:freechips.rocketchip.system.MulDivConfig64.fir@157224.6]
  wire  _T_82; // @[Multiplier.scala 118:13:freechips.rocketchip.system.MulDivConfig64.fir@157225.6]
  wire [10:0] _T_85; // @[Multiplier.scala 119:36:freechips.rocketchip.system.MulDivConfig64.fir@157228.6]
  wire [5:0] _T_86; // @[Multiplier.scala 119:60:freechips.rocketchip.system.MulDivConfig64.fir@157229.6]
  wire [128:0] _T_87; // @[Multiplier.scala 119:27:freechips.rocketchip.system.MulDivConfig64.fir@157230.6]
  wire [64:0] _T_88; // @[Multiplier.scala 120:37:freechips.rocketchip.system.MulDivConfig64.fir@157231.6]
  wire [129:0] _T_89; // @[Multiplier.scala 120:55:freechips.rocketchip.system.MulDivConfig64.fir@157232.6]
  wire [63:0] _T_90; // @[Multiplier.scala 120:82:freechips.rocketchip.system.MulDivConfig64.fir@157233.6]
  wire [128:0] _T_91; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157234.6]
  wire [64:0] _T_92; // @[Multiplier.scala 121:34:freechips.rocketchip.system.MulDivConfig64.fir@157235.6]
  wire [63:0] _T_93; // @[Multiplier.scala 121:67:freechips.rocketchip.system.MulDivConfig64.fir@157236.6]
  wire [129:0] _T_95; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157238.6]
  wire [6:0] _T_97; // @[Multiplier.scala 123:20:freechips.rocketchip.system.MulDivConfig64.fir@157241.6]
  wire  _T_98; // @[Multiplier.scala 124:25:freechips.rocketchip.system.MulDivConfig64.fir@157243.6]
  wire  _T_99; // @[Multiplier.scala 124:16:freechips.rocketchip.system.MulDivConfig64.fir@157244.6]
  wire  _T_100; // @[Multiplier.scala 129:39:freechips.rocketchip.system.MulDivConfig64.fir@157250.4]
  wire  _T_101; // @[Multiplier.scala 133:28:freechips.rocketchip.system.MulDivConfig64.fir@157252.6]
  wire [63:0] _T_102; // @[Multiplier.scala 134:24:freechips.rocketchip.system.MulDivConfig64.fir@157253.6]
  wire [63:0] _T_103; // @[Multiplier.scala 134:45:freechips.rocketchip.system.MulDivConfig64.fir@157254.6]
  wire [63:0] _T_104; // @[Multiplier.scala 134:14:freechips.rocketchip.system.MulDivConfig64.fir@157255.6]
  wire  _T_106; // @[Multiplier.scala 134:67:freechips.rocketchip.system.MulDivConfig64.fir@157257.6]
  wire [128:0] _T_108; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157259.6]
  wire  _T_109; // @[Multiplier.scala 138:17:freechips.rocketchip.system.MulDivConfig64.fir@157261.6]
  wire  _T_113; // @[Multiplier.scala 146:24:freechips.rocketchip.system.MulDivConfig64.fir@157270.6]
  wire  _T_116; // @[Multiplier.scala 146:30:freechips.rocketchip.system.MulDivConfig64.fir@157273.6]
  wire [63:0] _T_118; // @[Multiplier.scala 150:36:freechips.rocketchip.system.MulDivConfig64.fir@157275.6]
  wire [31:0] _T_119; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157276.6]
  wire [31:0] _T_120; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157277.6]
  wire  _T_121; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157278.6]
  wire [15:0] _T_122; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157279.6]
  wire [15:0] _T_123; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157280.6]
  wire  _T_124; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157281.6]
  wire [7:0] _T_125; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157282.6]
  wire [7:0] _T_126; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157283.6]
  wire  _T_127; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157284.6]
  wire [3:0] _T_128; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157285.6]
  wire [3:0] _T_129; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157286.6]
  wire  _T_130; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157287.6]
  wire  _T_131; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157288.6]
  wire  _T_132; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157289.6]
  wire  _T_133; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157290.6]
  wire [1:0] _T_134; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157291.6]
  wire [1:0] _T_135; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157292.6]
  wire  _T_136; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157293.6]
  wire  _T_137; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157294.6]
  wire  _T_138; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157295.6]
  wire [1:0] _T_139; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157296.6]
  wire [1:0] _T_140; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157297.6]
  wire [1:0] _T_141; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157298.6]
  wire [2:0] _T_142; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157299.6]
  wire [3:0] _T_143; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157300.6]
  wire [3:0] _T_144; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157301.6]
  wire  _T_145; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157302.6]
  wire  _T_146; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157303.6]
  wire  _T_147; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157304.6]
  wire  _T_148; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157305.6]
  wire [1:0] _T_149; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157306.6]
  wire [1:0] _T_150; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157307.6]
  wire  _T_151; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157308.6]
  wire  _T_152; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157309.6]
  wire  _T_153; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157310.6]
  wire [1:0] _T_154; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157311.6]
  wire [1:0] _T_155; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157312.6]
  wire [1:0] _T_156; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157313.6]
  wire [2:0] _T_157; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157314.6]
  wire [2:0] _T_158; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157315.6]
  wire [3:0] _T_159; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157316.6]
  wire [7:0] _T_160; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157317.6]
  wire [7:0] _T_161; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157318.6]
  wire  _T_162; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157319.6]
  wire [3:0] _T_163; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157320.6]
  wire [3:0] _T_164; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157321.6]
  wire  _T_165; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157322.6]
  wire  _T_166; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157323.6]
  wire  _T_167; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157324.6]
  wire  _T_168; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157325.6]
  wire [1:0] _T_169; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157326.6]
  wire [1:0] _T_170; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157327.6]
  wire  _T_171; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157328.6]
  wire  _T_172; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157329.6]
  wire  _T_173; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157330.6]
  wire [1:0] _T_174; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157331.6]
  wire [1:0] _T_175; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157332.6]
  wire [1:0] _T_176; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157333.6]
  wire [2:0] _T_177; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157334.6]
  wire [3:0] _T_178; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157335.6]
  wire [3:0] _T_179; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157336.6]
  wire  _T_180; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157337.6]
  wire  _T_181; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157338.6]
  wire  _T_182; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157339.6]
  wire  _T_183; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157340.6]
  wire [1:0] _T_184; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157341.6]
  wire [1:0] _T_185; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157342.6]
  wire  _T_186; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157343.6]
  wire  _T_187; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157344.6]
  wire  _T_188; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157345.6]
  wire [1:0] _T_189; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157346.6]
  wire [1:0] _T_190; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157347.6]
  wire [1:0] _T_191; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157348.6]
  wire [2:0] _T_192; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157349.6]
  wire [2:0] _T_193; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157350.6]
  wire [3:0] _T_194; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157351.6]
  wire [3:0] _T_195; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157352.6]
  wire [4:0] _T_196; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157353.6]
  wire [15:0] _T_197; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157354.6]
  wire [15:0] _T_198; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157355.6]
  wire  _T_199; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157356.6]
  wire [7:0] _T_200; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157357.6]
  wire [7:0] _T_201; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157358.6]
  wire  _T_202; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157359.6]
  wire [3:0] _T_203; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157360.6]
  wire [3:0] _T_204; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157361.6]
  wire  _T_205; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157362.6]
  wire  _T_206; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157363.6]
  wire  _T_207; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157364.6]
  wire  _T_208; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157365.6]
  wire [1:0] _T_209; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157366.6]
  wire [1:0] _T_210; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157367.6]
  wire  _T_211; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157368.6]
  wire  _T_212; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157369.6]
  wire  _T_213; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157370.6]
  wire [1:0] _T_214; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157371.6]
  wire [1:0] _T_215; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157372.6]
  wire [1:0] _T_216; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157373.6]
  wire [2:0] _T_217; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157374.6]
  wire [3:0] _T_218; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157375.6]
  wire [3:0] _T_219; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157376.6]
  wire  _T_220; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157377.6]
  wire  _T_221; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157378.6]
  wire  _T_222; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157379.6]
  wire  _T_223; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157380.6]
  wire [1:0] _T_224; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157381.6]
  wire [1:0] _T_225; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157382.6]
  wire  _T_226; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157383.6]
  wire  _T_227; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157384.6]
  wire  _T_228; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157385.6]
  wire [1:0] _T_229; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157386.6]
  wire [1:0] _T_230; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157387.6]
  wire [1:0] _T_231; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157388.6]
  wire [2:0] _T_232; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157389.6]
  wire [2:0] _T_233; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157390.6]
  wire [3:0] _T_234; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157391.6]
  wire [7:0] _T_235; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157392.6]
  wire [7:0] _T_236; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157393.6]
  wire  _T_237; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157394.6]
  wire [3:0] _T_238; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157395.6]
  wire [3:0] _T_239; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157396.6]
  wire  _T_240; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157397.6]
  wire  _T_241; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157398.6]
  wire  _T_242; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157399.6]
  wire  _T_243; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157400.6]
  wire [1:0] _T_244; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157401.6]
  wire [1:0] _T_245; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157402.6]
  wire  _T_246; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157403.6]
  wire  _T_247; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157404.6]
  wire  _T_248; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157405.6]
  wire [1:0] _T_249; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157406.6]
  wire [1:0] _T_250; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157407.6]
  wire [1:0] _T_251; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157408.6]
  wire [2:0] _T_252; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157409.6]
  wire [3:0] _T_253; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157410.6]
  wire [3:0] _T_254; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157411.6]
  wire  _T_255; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157412.6]
  wire  _T_256; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157413.6]
  wire  _T_257; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157414.6]
  wire  _T_258; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157415.6]
  wire [1:0] _T_259; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157416.6]
  wire [1:0] _T_260; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157417.6]
  wire  _T_261; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157418.6]
  wire  _T_262; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157419.6]
  wire  _T_263; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157420.6]
  wire [1:0] _T_264; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157421.6]
  wire [1:0] _T_265; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157422.6]
  wire [1:0] _T_266; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157423.6]
  wire [2:0] _T_267; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157424.6]
  wire [2:0] _T_268; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157425.6]
  wire [3:0] _T_269; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157426.6]
  wire [3:0] _T_270; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157427.6]
  wire [4:0] _T_271; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157428.6]
  wire [4:0] _T_272; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157429.6]
  wire [5:0] _T_273; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157430.6]
  wire [31:0] _T_276; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157433.6]
  wire [31:0] _T_277; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157434.6]
  wire  _T_278; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157435.6]
  wire [15:0] _T_279; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157436.6]
  wire [15:0] _T_280; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157437.6]
  wire  _T_281; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157438.6]
  wire [7:0] _T_282; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157439.6]
  wire [7:0] _T_283; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157440.6]
  wire  _T_284; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157441.6]
  wire [3:0] _T_285; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157442.6]
  wire [3:0] _T_286; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157443.6]
  wire  _T_287; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157444.6]
  wire  _T_288; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157445.6]
  wire  _T_289; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157446.6]
  wire  _T_290; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157447.6]
  wire [1:0] _T_291; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157448.6]
  wire [1:0] _T_292; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157449.6]
  wire  _T_293; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157450.6]
  wire  _T_294; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157451.6]
  wire  _T_295; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157452.6]
  wire [1:0] _T_296; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157453.6]
  wire [1:0] _T_297; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157454.6]
  wire [1:0] _T_298; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157455.6]
  wire [2:0] _T_299; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157456.6]
  wire [3:0] _T_300; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157457.6]
  wire [3:0] _T_301; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157458.6]
  wire  _T_302; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157459.6]
  wire  _T_303; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157460.6]
  wire  _T_304; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157461.6]
  wire  _T_305; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157462.6]
  wire [1:0] _T_306; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157463.6]
  wire [1:0] _T_307; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157464.6]
  wire  _T_308; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157465.6]
  wire  _T_309; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157466.6]
  wire  _T_310; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157467.6]
  wire [1:0] _T_311; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157468.6]
  wire [1:0] _T_312; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157469.6]
  wire [1:0] _T_313; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157470.6]
  wire [2:0] _T_314; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157471.6]
  wire [2:0] _T_315; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157472.6]
  wire [3:0] _T_316; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157473.6]
  wire [7:0] _T_317; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157474.6]
  wire [7:0] _T_318; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157475.6]
  wire  _T_319; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157476.6]
  wire [3:0] _T_320; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157477.6]
  wire [3:0] _T_321; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157478.6]
  wire  _T_322; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157479.6]
  wire  _T_323; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157480.6]
  wire  _T_324; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157481.6]
  wire  _T_325; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157482.6]
  wire [1:0] _T_326; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157483.6]
  wire [1:0] _T_327; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157484.6]
  wire  _T_328; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157485.6]
  wire  _T_329; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157486.6]
  wire  _T_330; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157487.6]
  wire [1:0] _T_331; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157488.6]
  wire [1:0] _T_332; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157489.6]
  wire [1:0] _T_333; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157490.6]
  wire [2:0] _T_334; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157491.6]
  wire [3:0] _T_335; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157492.6]
  wire [3:0] _T_336; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157493.6]
  wire  _T_337; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157494.6]
  wire  _T_338; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157495.6]
  wire  _T_339; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157496.6]
  wire  _T_340; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157497.6]
  wire [1:0] _T_341; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157498.6]
  wire [1:0] _T_342; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157499.6]
  wire  _T_343; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157500.6]
  wire  _T_344; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157501.6]
  wire  _T_345; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157502.6]
  wire [1:0] _T_346; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157503.6]
  wire [1:0] _T_347; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157504.6]
  wire [1:0] _T_348; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157505.6]
  wire [2:0] _T_349; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157506.6]
  wire [2:0] _T_350; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157507.6]
  wire [3:0] _T_351; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157508.6]
  wire [3:0] _T_352; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157509.6]
  wire [4:0] _T_353; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157510.6]
  wire [15:0] _T_354; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157511.6]
  wire [15:0] _T_355; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157512.6]
  wire  _T_356; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157513.6]
  wire [7:0] _T_357; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157514.6]
  wire [7:0] _T_358; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157515.6]
  wire  _T_359; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157516.6]
  wire [3:0] _T_360; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157517.6]
  wire [3:0] _T_361; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157518.6]
  wire  _T_362; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157519.6]
  wire  _T_363; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157520.6]
  wire  _T_364; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157521.6]
  wire  _T_365; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157522.6]
  wire [1:0] _T_366; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157523.6]
  wire [1:0] _T_367; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157524.6]
  wire  _T_368; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157525.6]
  wire  _T_369; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157526.6]
  wire  _T_370; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157527.6]
  wire [1:0] _T_371; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157528.6]
  wire [1:0] _T_372; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157529.6]
  wire [1:0] _T_373; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157530.6]
  wire [2:0] _T_374; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157531.6]
  wire [3:0] _T_375; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157532.6]
  wire [3:0] _T_376; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157533.6]
  wire  _T_377; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157534.6]
  wire  _T_378; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157535.6]
  wire  _T_379; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157536.6]
  wire  _T_380; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157537.6]
  wire [1:0] _T_381; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157538.6]
  wire [1:0] _T_382; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157539.6]
  wire  _T_383; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157540.6]
  wire  _T_384; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157541.6]
  wire  _T_385; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157542.6]
  wire [1:0] _T_386; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157543.6]
  wire [1:0] _T_387; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157544.6]
  wire [1:0] _T_388; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157545.6]
  wire [2:0] _T_389; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157546.6]
  wire [2:0] _T_390; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157547.6]
  wire [3:0] _T_391; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157548.6]
  wire [7:0] _T_392; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157549.6]
  wire [7:0] _T_393; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157550.6]
  wire  _T_394; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157551.6]
  wire [3:0] _T_395; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157552.6]
  wire [3:0] _T_396; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157553.6]
  wire  _T_397; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157554.6]
  wire  _T_398; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157555.6]
  wire  _T_399; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157556.6]
  wire  _T_400; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157557.6]
  wire [1:0] _T_401; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157558.6]
  wire [1:0] _T_402; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157559.6]
  wire  _T_403; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157560.6]
  wire  _T_404; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157561.6]
  wire  _T_405; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157562.6]
  wire [1:0] _T_406; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157563.6]
  wire [1:0] _T_407; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157564.6]
  wire [1:0] _T_408; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157565.6]
  wire [2:0] _T_409; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157566.6]
  wire [3:0] _T_410; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157567.6]
  wire [3:0] _T_411; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157568.6]
  wire  _T_412; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157569.6]
  wire  _T_413; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157570.6]
  wire  _T_414; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157571.6]
  wire  _T_415; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157572.6]
  wire [1:0] _T_416; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157573.6]
  wire [1:0] _T_417; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157574.6]
  wire  _T_418; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157575.6]
  wire  _T_419; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157576.6]
  wire  _T_420; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157577.6]
  wire [1:0] _T_421; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157578.6]
  wire [1:0] _T_422; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157579.6]
  wire [1:0] _T_423; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157580.6]
  wire [2:0] _T_424; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157581.6]
  wire [2:0] _T_425; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157582.6]
  wire [3:0] _T_426; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157583.6]
  wire [3:0] _T_427; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157584.6]
  wire [4:0] _T_428; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157585.6]
  wire [4:0] _T_429; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157586.6]
  wire [5:0] _T_430; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157587.6]
  wire [5:0] _T_434; // @[Multiplier.scala 152:35:freechips.rocketchip.system.MulDivConfig64.fir@157591.6]
  wire [5:0] _T_435; // @[Multiplier.scala 152:21:freechips.rocketchip.system.MulDivConfig64.fir@157592.6]
  wire  _T_437; // @[Multiplier.scala 153:33:freechips.rocketchip.system.MulDivConfig64.fir@157594.6]
  wire  _T_438; // @[Multiplier.scala 153:30:freechips.rocketchip.system.MulDivConfig64.fir@157595.6]
  wire  _T_439; // @[Multiplier.scala 153:52:freechips.rocketchip.system.MulDivConfig64.fir@157596.6]
  wire  _T_440; // @[Multiplier.scala 153:41:freechips.rocketchip.system.MulDivConfig64.fir@157597.6]
  wire [126:0] _GEN_39; // @[Multiplier.scala 155:39:freechips.rocketchip.system.MulDivConfig64.fir@157600.8]
  wire [126:0] _T_442; // @[Multiplier.scala 155:39:freechips.rocketchip.system.MulDivConfig64.fir@157600.8]
  wire [128:0] _GEN_16; // @[Multiplier.scala 154:19:freechips.rocketchip.system.MulDivConfig64.fir@157598.6]
  wire  _T_445; // @[Multiplier.scala 159:18:freechips.rocketchip.system.MulDivConfig64.fir@157606.6]
  wire  _T_446; // @[Decoupled.scala 37:37:freechips.rocketchip.system.MulDivConfig64.fir@157611.4]
  wire  _T_447; // @[Multiplier.scala 161:24:freechips.rocketchip.system.MulDivConfig64.fir@157612.4]
  wire  _T_448; // @[Decoupled.scala 37:37:freechips.rocketchip.system.MulDivConfig64.fir@157616.4]
  wire  _T_449; // @[Multiplier.scala 165:46:freechips.rocketchip.system.MulDivConfig64.fir@157618.6]
  wire  _T_454; // @[Multiplier.scala 168:46:freechips.rocketchip.system.MulDivConfig64.fir@157626.6]
  wire [2:0] _T_455; // @[Multiplier.scala 168:38:freechips.rocketchip.system.MulDivConfig64.fir@157627.6]
  wire  _T_456; // @[Multiplier.scala 169:46:freechips.rocketchip.system.MulDivConfig64.fir@157629.6]
  wire [64:0] _T_458; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157632.6]
  wire [2:0] _T_460; // @[Multiplier.scala 175:23:freechips.rocketchip.system.MulDivConfig64.fir@157638.4]
  wire  outMul; // @[Multiplier.scala 175:52:freechips.rocketchip.system.MulDivConfig64.fir@157641.4]
  wire  _T_463; // @[Multiplier.scala 78:62:freechips.rocketchip.system.MulDivConfig64.fir@157642.4]
  wire  _T_466; // @[Multiplier.scala 176:52:freechips.rocketchip.system.MulDivConfig64.fir@157645.4]
  wire [31:0] _T_467; // @[Multiplier.scala 176:69:freechips.rocketchip.system.MulDivConfig64.fir@157646.4]
  wire [31:0] _T_468; // @[Multiplier.scala 176:86:freechips.rocketchip.system.MulDivConfig64.fir@157647.4]
  wire [31:0] loOut; // @[Multiplier.scala 176:18:freechips.rocketchip.system.MulDivConfig64.fir@157648.4]
  wire  _T_471; // @[Multiplier.scala 177:50:freechips.rocketchip.system.MulDivConfig64.fir@157651.4]
  wire [31:0] _T_473; // @[Bitwise.scala 72:12:freechips.rocketchip.system.MulDivConfig64.fir@157653.4]
  wire [31:0] hiOut; // @[Multiplier.scala 177:18:freechips.rocketchip.system.MulDivConfig64.fir@157655.4]
  wire  _T_476; // @[Multiplier.scala 180:27:freechips.rocketchip.system.MulDivConfig64.fir@157659.4]
  wire  _T_477; // @[Multiplier.scala 180:51:freechips.rocketchip.system.MulDivConfig64.fir@157660.4]
  assign _T = io_req_bits_fn & 4'h4; // @[Decode.scala 14:65:freechips.rocketchip.system.MulDivConfig64.fir@157117.4]
  assign cmdMul = _T == 4'h0; // @[Decode.scala 14:121:freechips.rocketchip.system.MulDivConfig64.fir@157118.4]
  assign _T_3 = io_req_bits_fn & 4'h5; // @[Decode.scala 14:65:freechips.rocketchip.system.MulDivConfig64.fir@157120.4]
  assign _T_4 = _T_3 == 4'h1; // @[Decode.scala 14:121:freechips.rocketchip.system.MulDivConfig64.fir@157121.4]
  assign _T_5 = io_req_bits_fn & 4'h2; // @[Decode.scala 14:65:freechips.rocketchip.system.MulDivConfig64.fir@157122.4]
  assign _T_6 = _T_5 == 4'h2; // @[Decode.scala 14:121:freechips.rocketchip.system.MulDivConfig64.fir@157123.4]
  assign cmdHi = _T_4 | _T_6; // @[Decode.scala 15:30:freechips.rocketchip.system.MulDivConfig64.fir@157125.4]
  assign _T_9 = io_req_bits_fn & 4'h6; // @[Decode.scala 14:65:freechips.rocketchip.system.MulDivConfig64.fir@157126.4]
  assign _T_10 = _T_9 == 4'h0; // @[Decode.scala 14:121:freechips.rocketchip.system.MulDivConfig64.fir@157127.4]
  assign _T_11 = io_req_bits_fn & 4'h1; // @[Decode.scala 14:65:freechips.rocketchip.system.MulDivConfig64.fir@157128.4]
  assign _T_12 = _T_11 == 4'h0; // @[Decode.scala 14:121:freechips.rocketchip.system.MulDivConfig64.fir@157129.4]
  assign lhsSigned = _T_10 | _T_12; // @[Decode.scala 15:30:freechips.rocketchip.system.MulDivConfig64.fir@157131.4]
  assign _T_16 = _T_3 == 4'h4; // @[Decode.scala 14:121:freechips.rocketchip.system.MulDivConfig64.fir@157133.4]
  assign rhsSigned = _T_10 | _T_16; // @[Decode.scala 15:30:freechips.rocketchip.system.MulDivConfig64.fir@157135.4]
  assign _T_19 = io_req_bits_dw == 1'h0; // @[Multiplier.scala 78:62:freechips.rocketchip.system.MulDivConfig64.fir@157140.4]
  assign _T_21 = io_req_bits_in1[31]; // @[Multiplier.scala 81:38:freechips.rocketchip.system.MulDivConfig64.fir@157142.4]
  assign _T_22 = io_req_bits_in1[63]; // @[Multiplier.scala 81:48:freechips.rocketchip.system.MulDivConfig64.fir@157143.4]
  assign _T_23 = _T_19 ? _T_21 : _T_22; // @[Multiplier.scala 81:29:freechips.rocketchip.system.MulDivConfig64.fir@157144.4]
  assign lhs_sign = lhsSigned & _T_23; // @[Multiplier.scala 81:23:freechips.rocketchip.system.MulDivConfig64.fir@157145.4]
  assign _T_25 = lhs_sign ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12:freechips.rocketchip.system.MulDivConfig64.fir@157147.4]
  assign _T_26 = io_req_bits_in1[63:32]; // @[Multiplier.scala 82:43:freechips.rocketchip.system.MulDivConfig64.fir@157148.4]
  assign _T_27 = _T_19 ? _T_25 : _T_26; // @[Multiplier.scala 82:17:freechips.rocketchip.system.MulDivConfig64.fir@157149.4]
  assign _T_28 = io_req_bits_in1[31:0]; // @[Multiplier.scala 83:15:freechips.rocketchip.system.MulDivConfig64.fir@157150.4]
  assign lhs_in = {_T_27,_T_28}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157151.4]
  assign _T_31 = io_req_bits_in2[31]; // @[Multiplier.scala 81:38:freechips.rocketchip.system.MulDivConfig64.fir@157154.4]
  assign _T_32 = io_req_bits_in2[63]; // @[Multiplier.scala 81:48:freechips.rocketchip.system.MulDivConfig64.fir@157155.4]
  assign _T_33 = _T_19 ? _T_31 : _T_32; // @[Multiplier.scala 81:29:freechips.rocketchip.system.MulDivConfig64.fir@157156.4]
  assign rhs_sign = rhsSigned & _T_33; // @[Multiplier.scala 81:23:freechips.rocketchip.system.MulDivConfig64.fir@157157.4]
  assign _T_35 = rhs_sign ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12:freechips.rocketchip.system.MulDivConfig64.fir@157159.4]
  assign _T_36 = io_req_bits_in2[63:32]; // @[Multiplier.scala 82:43:freechips.rocketchip.system.MulDivConfig64.fir@157160.4]
  assign _T_37 = _T_19 ? _T_35 : _T_36; // @[Multiplier.scala 82:17:freechips.rocketchip.system.MulDivConfig64.fir@157161.4]
  assign _T_38 = io_req_bits_in2[31:0]; // @[Multiplier.scala 83:15:freechips.rocketchip.system.MulDivConfig64.fir@157162.4]
  assign _T_39 = remainder[128:64]; // @[Multiplier.scala 88:29:freechips.rocketchip.system.MulDivConfig64.fir@157164.4]
  assign subtractor = _T_39 - divisor; // @[Multiplier.scala 88:37:freechips.rocketchip.system.MulDivConfig64.fir@157166.4]
  assign _T_41 = remainder[128:65]; // @[Multiplier.scala 89:36:freechips.rocketchip.system.MulDivConfig64.fir@157167.4]
  assign _T_42 = remainder[63:0]; // @[Multiplier.scala 89:57:freechips.rocketchip.system.MulDivConfig64.fir@157168.4]
  assign result = resHi ? _T_41 : _T_42; // @[Multiplier.scala 89:19:freechips.rocketchip.system.MulDivConfig64.fir@157169.4]
  assign negated_remainder = 64'h0 - result; // @[Multiplier.scala 90:27:freechips.rocketchip.system.MulDivConfig64.fir@157171.4]
  assign _T_44 = state == 3'h1; // @[Multiplier.scala 92:39:freechips.rocketchip.system.MulDivConfig64.fir@157172.4]
  assign _T_45 = remainder[63]; // @[Multiplier.scala 93:20:freechips.rocketchip.system.MulDivConfig64.fir@157174.6]
  assign _T_46 = divisor[63]; // @[Multiplier.scala 96:18:freechips.rocketchip.system.MulDivConfig64.fir@157178.6]
  assign _T_47 = state == 3'h5; // @[Multiplier.scala 101:39:freechips.rocketchip.system.MulDivConfig64.fir@157184.4]
  assign _T_48 = state == 3'h2; // @[Multiplier.scala 106:39:freechips.rocketchip.system.MulDivConfig64.fir@157190.4]
  assign _T_49 = remainder[129:65]; // @[Multiplier.scala 107:31:freechips.rocketchip.system.MulDivConfig64.fir@157192.6]
  assign _T_51 = {_T_49,_T_42}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157194.6]
  assign _T_52 = remainder[64]; // @[Multiplier.scala 108:31:freechips.rocketchip.system.MulDivConfig64.fir@157195.6]
  assign _T_53 = _T_51[63:0]; // @[Multiplier.scala 109:24:freechips.rocketchip.system.MulDivConfig64.fir@157196.6]
  assign _T_54 = _T_51[128:64]; // @[Multiplier.scala 110:23:freechips.rocketchip.system.MulDivConfig64.fir@157197.6]
  assign _T_55 = $signed(_T_54); // @[Multiplier.scala 110:37:freechips.rocketchip.system.MulDivConfig64.fir@157198.6]
  assign _T_56 = $signed(divisor); // @[Multiplier.scala 111:26:freechips.rocketchip.system.MulDivConfig64.fir@157199.6]
  assign _T_57 = _T_53[7:0]; // @[Multiplier.scala 112:38:freechips.rocketchip.system.MulDivConfig64.fir@157200.6]
  assign _T_58 = {_T_52,_T_57}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157201.6]
  assign _T_59 = $signed(_T_58); // @[Multiplier.scala 112:60:freechips.rocketchip.system.MulDivConfig64.fir@157202.6]
  assign _GEN_37 = {{56{_T_59[8]}},_T_59}; // @[Multiplier.scala 112:67:freechips.rocketchip.system.MulDivConfig64.fir@157203.6]
  assign _T_60 = $signed(_GEN_37) * $signed(_T_56); // @[Multiplier.scala 112:67:freechips.rocketchip.system.MulDivConfig64.fir@157203.6]
  assign _GEN_38 = {{9{_T_55[64]}},_T_55}; // @[Multiplier.scala 112:76:freechips.rocketchip.system.MulDivConfig64.fir@157204.6]
  assign _T_62 = $signed(_T_60) + $signed(_GEN_38); // @[Multiplier.scala 112:76:freechips.rocketchip.system.MulDivConfig64.fir@157205.6]
  assign _T_63 = $signed(_T_62); // @[Multiplier.scala 112:76:freechips.rocketchip.system.MulDivConfig64.fir@157206.6]
  assign _T_64 = _T_53[63:8]; // @[Multiplier.scala 113:38:freechips.rocketchip.system.MulDivConfig64.fir@157207.6]
  assign _T_65 = $unsigned(_T_63); // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157208.6]
  assign _T_66 = {_T_65,_T_64}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157209.6]
  assign _T_67 = count == 7'h6; // @[Multiplier.scala 114:32:freechips.rocketchip.system.MulDivConfig64.fir@157210.6]
  assign _T_68 = _T_67 & neg_out; // @[Multiplier.scala 114:57:freechips.rocketchip.system.MulDivConfig64.fir@157211.6]
  assign _T_69 = count * 7'h8; // @[Multiplier.scala 116:56:freechips.rocketchip.system.MulDivConfig64.fir@157212.6]
  assign _T_70 = _T_69[5:0]; // @[Multiplier.scala 116:72:freechips.rocketchip.system.MulDivConfig64.fir@157213.6]
  assign _T_71 = $signed(-65'sh10000000000000000) >>> _T_70; // @[Multiplier.scala 116:46:freechips.rocketchip.system.MulDivConfig64.fir@157214.6]
  assign _T_72 = _T_71[63:0]; // @[Multiplier.scala 116:91:freechips.rocketchip.system.MulDivConfig64.fir@157215.6]
  assign _T_73 = count != 7'h7; // @[Multiplier.scala 117:47:freechips.rocketchip.system.MulDivConfig64.fir@157216.6]
  assign _T_75 = count != 7'h0; // @[Multiplier.scala 117:81:freechips.rocketchip.system.MulDivConfig64.fir@157218.6]
  assign _T_76 = _T_73 & _T_75; // @[Multiplier.scala 117:72:freechips.rocketchip.system.MulDivConfig64.fir@157219.6]
  assign _T_77 = isHi == 1'h0; // @[Multiplier.scala 118:7:freechips.rocketchip.system.MulDivConfig64.fir@157220.6]
  assign _T_78 = _T_76 & _T_77; // @[Multiplier.scala 117:87:freechips.rocketchip.system.MulDivConfig64.fir@157221.6]
  assign _T_79 = ~ _T_72; // @[Multiplier.scala 118:26:freechips.rocketchip.system.MulDivConfig64.fir@157222.6]
  assign _T_80 = _T_53 & _T_79; // @[Multiplier.scala 118:24:freechips.rocketchip.system.MulDivConfig64.fir@157223.6]
  assign _T_81 = _T_80 == 64'h0; // @[Multiplier.scala 118:37:freechips.rocketchip.system.MulDivConfig64.fir@157224.6]
  assign _T_82 = _T_78 & _T_81; // @[Multiplier.scala 118:13:freechips.rocketchip.system.MulDivConfig64.fir@157225.6]
  assign _T_85 = 11'h40 - _T_69; // @[Multiplier.scala 119:36:freechips.rocketchip.system.MulDivConfig64.fir@157228.6]
  assign _T_86 = _T_85[5:0]; // @[Multiplier.scala 119:60:freechips.rocketchip.system.MulDivConfig64.fir@157229.6]
  assign _T_87 = _T_51 >> _T_86; // @[Multiplier.scala 119:27:freechips.rocketchip.system.MulDivConfig64.fir@157230.6]
  assign _T_88 = _T_66[128:64]; // @[Multiplier.scala 120:37:freechips.rocketchip.system.MulDivConfig64.fir@157231.6]
  assign _T_89 = _T_82 ? {{1'd0}, _T_87} : _T_66; // @[Multiplier.scala 120:55:freechips.rocketchip.system.MulDivConfig64.fir@157232.6]
  assign _T_90 = _T_89[63:0]; // @[Multiplier.scala 120:82:freechips.rocketchip.system.MulDivConfig64.fir@157233.6]
  assign _T_91 = {_T_88,_T_90}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157234.6]
  assign _T_92 = _T_91[128:64]; // @[Multiplier.scala 121:34:freechips.rocketchip.system.MulDivConfig64.fir@157235.6]
  assign _T_93 = _T_91[63:0]; // @[Multiplier.scala 121:67:freechips.rocketchip.system.MulDivConfig64.fir@157236.6]
  assign _T_95 = {_T_92,_T_68,_T_93}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157238.6]
  assign _T_97 = count + 7'h1; // @[Multiplier.scala 123:20:freechips.rocketchip.system.MulDivConfig64.fir@157241.6]
  assign _T_98 = count == 7'h7; // @[Multiplier.scala 124:25:freechips.rocketchip.system.MulDivConfig64.fir@157243.6]
  assign _T_99 = _T_82 | _T_98; // @[Multiplier.scala 124:16:freechips.rocketchip.system.MulDivConfig64.fir@157244.6]
  assign _T_100 = state == 3'h3; // @[Multiplier.scala 129:39:freechips.rocketchip.system.MulDivConfig64.fir@157250.4]
  assign _T_101 = subtractor[64]; // @[Multiplier.scala 133:28:freechips.rocketchip.system.MulDivConfig64.fir@157252.6]
  assign _T_102 = remainder[127:64]; // @[Multiplier.scala 134:24:freechips.rocketchip.system.MulDivConfig64.fir@157253.6]
  assign _T_103 = subtractor[63:0]; // @[Multiplier.scala 134:45:freechips.rocketchip.system.MulDivConfig64.fir@157254.6]
  assign _T_104 = _T_101 ? _T_102 : _T_103; // @[Multiplier.scala 134:14:freechips.rocketchip.system.MulDivConfig64.fir@157255.6]
  assign _T_106 = _T_101 == 1'h0; // @[Multiplier.scala 134:67:freechips.rocketchip.system.MulDivConfig64.fir@157257.6]
  assign _T_108 = {_T_104,_T_42,_T_106}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157259.6]
  assign _T_109 = count == 7'h40; // @[Multiplier.scala 138:17:freechips.rocketchip.system.MulDivConfig64.fir@157261.6]
  assign _T_113 = count == 7'h0; // @[Multiplier.scala 146:24:freechips.rocketchip.system.MulDivConfig64.fir@157270.6]
  assign _T_116 = _T_113 & _T_106; // @[Multiplier.scala 146:30:freechips.rocketchip.system.MulDivConfig64.fir@157273.6]
  assign _T_118 = divisor[63:0]; // @[Multiplier.scala 150:36:freechips.rocketchip.system.MulDivConfig64.fir@157275.6]
  assign _T_119 = _T_118[63:32]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157276.6]
  assign _T_120 = _T_118[31:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157277.6]
  assign _T_121 = _T_119 != 32'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157278.6]
  assign _T_122 = _T_119[31:16]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157279.6]
  assign _T_123 = _T_119[15:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157280.6]
  assign _T_124 = _T_122 != 16'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157281.6]
  assign _T_125 = _T_122[15:8]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157282.6]
  assign _T_126 = _T_122[7:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157283.6]
  assign _T_127 = _T_125 != 8'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157284.6]
  assign _T_128 = _T_125[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157285.6]
  assign _T_129 = _T_125[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157286.6]
  assign _T_130 = _T_128 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157287.6]
  assign _T_131 = _T_128[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157288.6]
  assign _T_132 = _T_128[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157289.6]
  assign _T_133 = _T_128[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157290.6]
  assign _T_134 = _T_132 ? 2'h2 : {{1'd0}, _T_133}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157291.6]
  assign _T_135 = _T_131 ? 2'h3 : _T_134; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157292.6]
  assign _T_136 = _T_129[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157293.6]
  assign _T_137 = _T_129[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157294.6]
  assign _T_138 = _T_129[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157295.6]
  assign _T_139 = _T_137 ? 2'h2 : {{1'd0}, _T_138}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157296.6]
  assign _T_140 = _T_136 ? 2'h3 : _T_139; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157297.6]
  assign _T_141 = _T_130 ? _T_135 : _T_140; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157298.6]
  assign _T_142 = {_T_130,_T_141}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157299.6]
  assign _T_143 = _T_126[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157300.6]
  assign _T_144 = _T_126[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157301.6]
  assign _T_145 = _T_143 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157302.6]
  assign _T_146 = _T_143[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157303.6]
  assign _T_147 = _T_143[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157304.6]
  assign _T_148 = _T_143[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157305.6]
  assign _T_149 = _T_147 ? 2'h2 : {{1'd0}, _T_148}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157306.6]
  assign _T_150 = _T_146 ? 2'h3 : _T_149; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157307.6]
  assign _T_151 = _T_144[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157308.6]
  assign _T_152 = _T_144[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157309.6]
  assign _T_153 = _T_144[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157310.6]
  assign _T_154 = _T_152 ? 2'h2 : {{1'd0}, _T_153}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157311.6]
  assign _T_155 = _T_151 ? 2'h3 : _T_154; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157312.6]
  assign _T_156 = _T_145 ? _T_150 : _T_155; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157313.6]
  assign _T_157 = {_T_145,_T_156}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157314.6]
  assign _T_158 = _T_127 ? _T_142 : _T_157; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157315.6]
  assign _T_159 = {_T_127,_T_158}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157316.6]
  assign _T_160 = _T_123[15:8]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157317.6]
  assign _T_161 = _T_123[7:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157318.6]
  assign _T_162 = _T_160 != 8'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157319.6]
  assign _T_163 = _T_160[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157320.6]
  assign _T_164 = _T_160[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157321.6]
  assign _T_165 = _T_163 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157322.6]
  assign _T_166 = _T_163[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157323.6]
  assign _T_167 = _T_163[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157324.6]
  assign _T_168 = _T_163[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157325.6]
  assign _T_169 = _T_167 ? 2'h2 : {{1'd0}, _T_168}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157326.6]
  assign _T_170 = _T_166 ? 2'h3 : _T_169; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157327.6]
  assign _T_171 = _T_164[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157328.6]
  assign _T_172 = _T_164[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157329.6]
  assign _T_173 = _T_164[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157330.6]
  assign _T_174 = _T_172 ? 2'h2 : {{1'd0}, _T_173}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157331.6]
  assign _T_175 = _T_171 ? 2'h3 : _T_174; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157332.6]
  assign _T_176 = _T_165 ? _T_170 : _T_175; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157333.6]
  assign _T_177 = {_T_165,_T_176}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157334.6]
  assign _T_178 = _T_161[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157335.6]
  assign _T_179 = _T_161[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157336.6]
  assign _T_180 = _T_178 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157337.6]
  assign _T_181 = _T_178[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157338.6]
  assign _T_182 = _T_178[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157339.6]
  assign _T_183 = _T_178[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157340.6]
  assign _T_184 = _T_182 ? 2'h2 : {{1'd0}, _T_183}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157341.6]
  assign _T_185 = _T_181 ? 2'h3 : _T_184; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157342.6]
  assign _T_186 = _T_179[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157343.6]
  assign _T_187 = _T_179[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157344.6]
  assign _T_188 = _T_179[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157345.6]
  assign _T_189 = _T_187 ? 2'h2 : {{1'd0}, _T_188}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157346.6]
  assign _T_190 = _T_186 ? 2'h3 : _T_189; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157347.6]
  assign _T_191 = _T_180 ? _T_185 : _T_190; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157348.6]
  assign _T_192 = {_T_180,_T_191}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157349.6]
  assign _T_193 = _T_162 ? _T_177 : _T_192; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157350.6]
  assign _T_194 = {_T_162,_T_193}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157351.6]
  assign _T_195 = _T_124 ? _T_159 : _T_194; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157352.6]
  assign _T_196 = {_T_124,_T_195}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157353.6]
  assign _T_197 = _T_120[31:16]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157354.6]
  assign _T_198 = _T_120[15:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157355.6]
  assign _T_199 = _T_197 != 16'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157356.6]
  assign _T_200 = _T_197[15:8]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157357.6]
  assign _T_201 = _T_197[7:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157358.6]
  assign _T_202 = _T_200 != 8'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157359.6]
  assign _T_203 = _T_200[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157360.6]
  assign _T_204 = _T_200[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157361.6]
  assign _T_205 = _T_203 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157362.6]
  assign _T_206 = _T_203[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157363.6]
  assign _T_207 = _T_203[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157364.6]
  assign _T_208 = _T_203[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157365.6]
  assign _T_209 = _T_207 ? 2'h2 : {{1'd0}, _T_208}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157366.6]
  assign _T_210 = _T_206 ? 2'h3 : _T_209; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157367.6]
  assign _T_211 = _T_204[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157368.6]
  assign _T_212 = _T_204[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157369.6]
  assign _T_213 = _T_204[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157370.6]
  assign _T_214 = _T_212 ? 2'h2 : {{1'd0}, _T_213}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157371.6]
  assign _T_215 = _T_211 ? 2'h3 : _T_214; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157372.6]
  assign _T_216 = _T_205 ? _T_210 : _T_215; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157373.6]
  assign _T_217 = {_T_205,_T_216}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157374.6]
  assign _T_218 = _T_201[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157375.6]
  assign _T_219 = _T_201[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157376.6]
  assign _T_220 = _T_218 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157377.6]
  assign _T_221 = _T_218[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157378.6]
  assign _T_222 = _T_218[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157379.6]
  assign _T_223 = _T_218[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157380.6]
  assign _T_224 = _T_222 ? 2'h2 : {{1'd0}, _T_223}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157381.6]
  assign _T_225 = _T_221 ? 2'h3 : _T_224; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157382.6]
  assign _T_226 = _T_219[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157383.6]
  assign _T_227 = _T_219[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157384.6]
  assign _T_228 = _T_219[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157385.6]
  assign _T_229 = _T_227 ? 2'h2 : {{1'd0}, _T_228}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157386.6]
  assign _T_230 = _T_226 ? 2'h3 : _T_229; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157387.6]
  assign _T_231 = _T_220 ? _T_225 : _T_230; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157388.6]
  assign _T_232 = {_T_220,_T_231}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157389.6]
  assign _T_233 = _T_202 ? _T_217 : _T_232; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157390.6]
  assign _T_234 = {_T_202,_T_233}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157391.6]
  assign _T_235 = _T_198[15:8]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157392.6]
  assign _T_236 = _T_198[7:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157393.6]
  assign _T_237 = _T_235 != 8'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157394.6]
  assign _T_238 = _T_235[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157395.6]
  assign _T_239 = _T_235[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157396.6]
  assign _T_240 = _T_238 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157397.6]
  assign _T_241 = _T_238[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157398.6]
  assign _T_242 = _T_238[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157399.6]
  assign _T_243 = _T_238[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157400.6]
  assign _T_244 = _T_242 ? 2'h2 : {{1'd0}, _T_243}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157401.6]
  assign _T_245 = _T_241 ? 2'h3 : _T_244; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157402.6]
  assign _T_246 = _T_239[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157403.6]
  assign _T_247 = _T_239[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157404.6]
  assign _T_248 = _T_239[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157405.6]
  assign _T_249 = _T_247 ? 2'h2 : {{1'd0}, _T_248}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157406.6]
  assign _T_250 = _T_246 ? 2'h3 : _T_249; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157407.6]
  assign _T_251 = _T_240 ? _T_245 : _T_250; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157408.6]
  assign _T_252 = {_T_240,_T_251}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157409.6]
  assign _T_253 = _T_236[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157410.6]
  assign _T_254 = _T_236[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157411.6]
  assign _T_255 = _T_253 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157412.6]
  assign _T_256 = _T_253[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157413.6]
  assign _T_257 = _T_253[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157414.6]
  assign _T_258 = _T_253[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157415.6]
  assign _T_259 = _T_257 ? 2'h2 : {{1'd0}, _T_258}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157416.6]
  assign _T_260 = _T_256 ? 2'h3 : _T_259; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157417.6]
  assign _T_261 = _T_254[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157418.6]
  assign _T_262 = _T_254[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157419.6]
  assign _T_263 = _T_254[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157420.6]
  assign _T_264 = _T_262 ? 2'h2 : {{1'd0}, _T_263}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157421.6]
  assign _T_265 = _T_261 ? 2'h3 : _T_264; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157422.6]
  assign _T_266 = _T_255 ? _T_260 : _T_265; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157423.6]
  assign _T_267 = {_T_255,_T_266}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157424.6]
  assign _T_268 = _T_237 ? _T_252 : _T_267; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157425.6]
  assign _T_269 = {_T_237,_T_268}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157426.6]
  assign _T_270 = _T_199 ? _T_234 : _T_269; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157427.6]
  assign _T_271 = {_T_199,_T_270}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157428.6]
  assign _T_272 = _T_121 ? _T_196 : _T_271; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157429.6]
  assign _T_273 = {_T_121,_T_272}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157430.6]
  assign _T_276 = _T_42[63:32]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157433.6]
  assign _T_277 = _T_42[31:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157434.6]
  assign _T_278 = _T_276 != 32'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157435.6]
  assign _T_279 = _T_276[31:16]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157436.6]
  assign _T_280 = _T_276[15:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157437.6]
  assign _T_281 = _T_279 != 16'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157438.6]
  assign _T_282 = _T_279[15:8]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157439.6]
  assign _T_283 = _T_279[7:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157440.6]
  assign _T_284 = _T_282 != 8'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157441.6]
  assign _T_285 = _T_282[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157442.6]
  assign _T_286 = _T_282[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157443.6]
  assign _T_287 = _T_285 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157444.6]
  assign _T_288 = _T_285[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157445.6]
  assign _T_289 = _T_285[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157446.6]
  assign _T_290 = _T_285[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157447.6]
  assign _T_291 = _T_289 ? 2'h2 : {{1'd0}, _T_290}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157448.6]
  assign _T_292 = _T_288 ? 2'h3 : _T_291; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157449.6]
  assign _T_293 = _T_286[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157450.6]
  assign _T_294 = _T_286[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157451.6]
  assign _T_295 = _T_286[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157452.6]
  assign _T_296 = _T_294 ? 2'h2 : {{1'd0}, _T_295}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157453.6]
  assign _T_297 = _T_293 ? 2'h3 : _T_296; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157454.6]
  assign _T_298 = _T_287 ? _T_292 : _T_297; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157455.6]
  assign _T_299 = {_T_287,_T_298}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157456.6]
  assign _T_300 = _T_283[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157457.6]
  assign _T_301 = _T_283[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157458.6]
  assign _T_302 = _T_300 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157459.6]
  assign _T_303 = _T_300[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157460.6]
  assign _T_304 = _T_300[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157461.6]
  assign _T_305 = _T_300[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157462.6]
  assign _T_306 = _T_304 ? 2'h2 : {{1'd0}, _T_305}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157463.6]
  assign _T_307 = _T_303 ? 2'h3 : _T_306; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157464.6]
  assign _T_308 = _T_301[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157465.6]
  assign _T_309 = _T_301[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157466.6]
  assign _T_310 = _T_301[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157467.6]
  assign _T_311 = _T_309 ? 2'h2 : {{1'd0}, _T_310}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157468.6]
  assign _T_312 = _T_308 ? 2'h3 : _T_311; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157469.6]
  assign _T_313 = _T_302 ? _T_307 : _T_312; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157470.6]
  assign _T_314 = {_T_302,_T_313}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157471.6]
  assign _T_315 = _T_284 ? _T_299 : _T_314; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157472.6]
  assign _T_316 = {_T_284,_T_315}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157473.6]
  assign _T_317 = _T_280[15:8]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157474.6]
  assign _T_318 = _T_280[7:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157475.6]
  assign _T_319 = _T_317 != 8'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157476.6]
  assign _T_320 = _T_317[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157477.6]
  assign _T_321 = _T_317[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157478.6]
  assign _T_322 = _T_320 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157479.6]
  assign _T_323 = _T_320[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157480.6]
  assign _T_324 = _T_320[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157481.6]
  assign _T_325 = _T_320[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157482.6]
  assign _T_326 = _T_324 ? 2'h2 : {{1'd0}, _T_325}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157483.6]
  assign _T_327 = _T_323 ? 2'h3 : _T_326; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157484.6]
  assign _T_328 = _T_321[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157485.6]
  assign _T_329 = _T_321[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157486.6]
  assign _T_330 = _T_321[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157487.6]
  assign _T_331 = _T_329 ? 2'h2 : {{1'd0}, _T_330}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157488.6]
  assign _T_332 = _T_328 ? 2'h3 : _T_331; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157489.6]
  assign _T_333 = _T_322 ? _T_327 : _T_332; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157490.6]
  assign _T_334 = {_T_322,_T_333}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157491.6]
  assign _T_335 = _T_318[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157492.6]
  assign _T_336 = _T_318[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157493.6]
  assign _T_337 = _T_335 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157494.6]
  assign _T_338 = _T_335[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157495.6]
  assign _T_339 = _T_335[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157496.6]
  assign _T_340 = _T_335[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157497.6]
  assign _T_341 = _T_339 ? 2'h2 : {{1'd0}, _T_340}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157498.6]
  assign _T_342 = _T_338 ? 2'h3 : _T_341; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157499.6]
  assign _T_343 = _T_336[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157500.6]
  assign _T_344 = _T_336[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157501.6]
  assign _T_345 = _T_336[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157502.6]
  assign _T_346 = _T_344 ? 2'h2 : {{1'd0}, _T_345}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157503.6]
  assign _T_347 = _T_343 ? 2'h3 : _T_346; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157504.6]
  assign _T_348 = _T_337 ? _T_342 : _T_347; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157505.6]
  assign _T_349 = {_T_337,_T_348}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157506.6]
  assign _T_350 = _T_319 ? _T_334 : _T_349; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157507.6]
  assign _T_351 = {_T_319,_T_350}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157508.6]
  assign _T_352 = _T_281 ? _T_316 : _T_351; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157509.6]
  assign _T_353 = {_T_281,_T_352}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157510.6]
  assign _T_354 = _T_277[31:16]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157511.6]
  assign _T_355 = _T_277[15:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157512.6]
  assign _T_356 = _T_354 != 16'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157513.6]
  assign _T_357 = _T_354[15:8]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157514.6]
  assign _T_358 = _T_354[7:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157515.6]
  assign _T_359 = _T_357 != 8'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157516.6]
  assign _T_360 = _T_357[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157517.6]
  assign _T_361 = _T_357[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157518.6]
  assign _T_362 = _T_360 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157519.6]
  assign _T_363 = _T_360[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157520.6]
  assign _T_364 = _T_360[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157521.6]
  assign _T_365 = _T_360[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157522.6]
  assign _T_366 = _T_364 ? 2'h2 : {{1'd0}, _T_365}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157523.6]
  assign _T_367 = _T_363 ? 2'h3 : _T_366; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157524.6]
  assign _T_368 = _T_361[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157525.6]
  assign _T_369 = _T_361[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157526.6]
  assign _T_370 = _T_361[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157527.6]
  assign _T_371 = _T_369 ? 2'h2 : {{1'd0}, _T_370}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157528.6]
  assign _T_372 = _T_368 ? 2'h3 : _T_371; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157529.6]
  assign _T_373 = _T_362 ? _T_367 : _T_372; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157530.6]
  assign _T_374 = {_T_362,_T_373}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157531.6]
  assign _T_375 = _T_358[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157532.6]
  assign _T_376 = _T_358[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157533.6]
  assign _T_377 = _T_375 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157534.6]
  assign _T_378 = _T_375[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157535.6]
  assign _T_379 = _T_375[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157536.6]
  assign _T_380 = _T_375[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157537.6]
  assign _T_381 = _T_379 ? 2'h2 : {{1'd0}, _T_380}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157538.6]
  assign _T_382 = _T_378 ? 2'h3 : _T_381; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157539.6]
  assign _T_383 = _T_376[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157540.6]
  assign _T_384 = _T_376[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157541.6]
  assign _T_385 = _T_376[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157542.6]
  assign _T_386 = _T_384 ? 2'h2 : {{1'd0}, _T_385}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157543.6]
  assign _T_387 = _T_383 ? 2'h3 : _T_386; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157544.6]
  assign _T_388 = _T_377 ? _T_382 : _T_387; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157545.6]
  assign _T_389 = {_T_377,_T_388}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157546.6]
  assign _T_390 = _T_359 ? _T_374 : _T_389; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157547.6]
  assign _T_391 = {_T_359,_T_390}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157548.6]
  assign _T_392 = _T_355[15:8]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157549.6]
  assign _T_393 = _T_355[7:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157550.6]
  assign _T_394 = _T_392 != 8'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157551.6]
  assign _T_395 = _T_392[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157552.6]
  assign _T_396 = _T_392[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157553.6]
  assign _T_397 = _T_395 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157554.6]
  assign _T_398 = _T_395[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157555.6]
  assign _T_399 = _T_395[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157556.6]
  assign _T_400 = _T_395[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157557.6]
  assign _T_401 = _T_399 ? 2'h2 : {{1'd0}, _T_400}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157558.6]
  assign _T_402 = _T_398 ? 2'h3 : _T_401; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157559.6]
  assign _T_403 = _T_396[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157560.6]
  assign _T_404 = _T_396[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157561.6]
  assign _T_405 = _T_396[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157562.6]
  assign _T_406 = _T_404 ? 2'h2 : {{1'd0}, _T_405}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157563.6]
  assign _T_407 = _T_403 ? 2'h3 : _T_406; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157564.6]
  assign _T_408 = _T_397 ? _T_402 : _T_407; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157565.6]
  assign _T_409 = {_T_397,_T_408}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157566.6]
  assign _T_410 = _T_393[7:4]; // @[CircuitMath.scala 35:17:freechips.rocketchip.system.MulDivConfig64.fir@157567.6]
  assign _T_411 = _T_393[3:0]; // @[CircuitMath.scala 36:17:freechips.rocketchip.system.MulDivConfig64.fir@157568.6]
  assign _T_412 = _T_410 != 4'h0; // @[CircuitMath.scala 37:22:freechips.rocketchip.system.MulDivConfig64.fir@157569.6]
  assign _T_413 = _T_410[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157570.6]
  assign _T_414 = _T_410[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157571.6]
  assign _T_415 = _T_410[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157572.6]
  assign _T_416 = _T_414 ? 2'h2 : {{1'd0}, _T_415}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157573.6]
  assign _T_417 = _T_413 ? 2'h3 : _T_416; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157574.6]
  assign _T_418 = _T_411[3]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157575.6]
  assign _T_419 = _T_411[2]; // @[CircuitMath.scala 32:12:freechips.rocketchip.system.MulDivConfig64.fir@157576.6]
  assign _T_420 = _T_411[1]; // @[CircuitMath.scala 30:8:freechips.rocketchip.system.MulDivConfig64.fir@157577.6]
  assign _T_421 = _T_419 ? 2'h2 : {{1'd0}, _T_420}; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157578.6]
  assign _T_422 = _T_418 ? 2'h3 : _T_421; // @[CircuitMath.scala 32:10:freechips.rocketchip.system.MulDivConfig64.fir@157579.6]
  assign _T_423 = _T_412 ? _T_417 : _T_422; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157580.6]
  assign _T_424 = {_T_412,_T_423}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157581.6]
  assign _T_425 = _T_394 ? _T_409 : _T_424; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157582.6]
  assign _T_426 = {_T_394,_T_425}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157583.6]
  assign _T_427 = _T_356 ? _T_391 : _T_426; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157584.6]
  assign _T_428 = {_T_356,_T_427}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157585.6]
  assign _T_429 = _T_278 ? _T_353 : _T_428; // @[CircuitMath.scala 38:21:freechips.rocketchip.system.MulDivConfig64.fir@157586.6]
  assign _T_430 = {_T_278,_T_429}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157587.6]
  assign _T_434 = _T_430 - _T_273; // @[Multiplier.scala 152:35:freechips.rocketchip.system.MulDivConfig64.fir@157591.6]
  assign _T_435 = ~ _T_434; // @[Multiplier.scala 152:21:freechips.rocketchip.system.MulDivConfig64.fir@157592.6]
  assign _T_437 = _T_116 == 1'h0; // @[Multiplier.scala 153:33:freechips.rocketchip.system.MulDivConfig64.fir@157594.6]
  assign _T_438 = _T_113 & _T_437; // @[Multiplier.scala 153:30:freechips.rocketchip.system.MulDivConfig64.fir@157595.6]
  assign _T_439 = _T_435 >= 6'h1; // @[Multiplier.scala 153:52:freechips.rocketchip.system.MulDivConfig64.fir@157596.6]
  assign _T_440 = _T_438 & _T_439; // @[Multiplier.scala 153:41:freechips.rocketchip.system.MulDivConfig64.fir@157597.6]
  assign _GEN_39 = {{63'd0}, _T_42}; // @[Multiplier.scala 155:39:freechips.rocketchip.system.MulDivConfig64.fir@157600.8]
  assign _T_442 = _GEN_39 << _T_435; // @[Multiplier.scala 155:39:freechips.rocketchip.system.MulDivConfig64.fir@157600.8]
  assign _GEN_16 = _T_440 ? {{2'd0}, _T_442} : _T_108; // @[Multiplier.scala 154:19:freechips.rocketchip.system.MulDivConfig64.fir@157598.6]
  assign _T_445 = _T_116 & _T_77; // @[Multiplier.scala 159:18:freechips.rocketchip.system.MulDivConfig64.fir@157606.6]
  assign _T_446 = io_resp_ready & io_resp_valid; // @[Decoupled.scala 37:37:freechips.rocketchip.system.MulDivConfig64.fir@157611.4]
  assign _T_447 = _T_446 | io_kill; // @[Multiplier.scala 161:24:freechips.rocketchip.system.MulDivConfig64.fir@157612.4]
  assign _T_448 = io_req_ready & io_req_valid; // @[Decoupled.scala 37:37:freechips.rocketchip.system.MulDivConfig64.fir@157616.4]
  assign _T_449 = lhs_sign | rhs_sign; // @[Multiplier.scala 165:46:freechips.rocketchip.system.MulDivConfig64.fir@157618.6]
  assign _T_454 = cmdMul & _T_19; // @[Multiplier.scala 168:46:freechips.rocketchip.system.MulDivConfig64.fir@157626.6]
  assign _T_455 = _T_454 ? 3'h4 : 3'h0; // @[Multiplier.scala 168:38:freechips.rocketchip.system.MulDivConfig64.fir@157627.6]
  assign _T_456 = lhs_sign != rhs_sign; // @[Multiplier.scala 169:46:freechips.rocketchip.system.MulDivConfig64.fir@157629.6]
  assign _T_458 = {rhs_sign,_T_37,_T_38}; // @[Cat.scala 30:58:freechips.rocketchip.system.MulDivConfig64.fir@157632.6]
  assign _T_460 = state & 3'h1; // @[Multiplier.scala 175:23:freechips.rocketchip.system.MulDivConfig64.fir@157638.4]
  assign outMul = _T_460 == 3'h0; // @[Multiplier.scala 175:52:freechips.rocketchip.system.MulDivConfig64.fir@157641.4]
  assign _T_463 = req_dw == 1'h0; // @[Multiplier.scala 78:62:freechips.rocketchip.system.MulDivConfig64.fir@157642.4]
  assign _T_466 = _T_463 & outMul; // @[Multiplier.scala 176:52:freechips.rocketchip.system.MulDivConfig64.fir@157645.4]
  assign _T_467 = result[63:32]; // @[Multiplier.scala 176:69:freechips.rocketchip.system.MulDivConfig64.fir@157646.4]
  assign _T_468 = result[31:0]; // @[Multiplier.scala 176:86:freechips.rocketchip.system.MulDivConfig64.fir@157647.4]
  assign loOut = _T_466 ? _T_467 : _T_468; // @[Multiplier.scala 176:18:freechips.rocketchip.system.MulDivConfig64.fir@157648.4]
  assign _T_471 = loOut[31]; // @[Multiplier.scala 177:50:freechips.rocketchip.system.MulDivConfig64.fir@157651.4]
  assign _T_473 = _T_471 ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12:freechips.rocketchip.system.MulDivConfig64.fir@157653.4]
  assign hiOut = _T_463 ? _T_473 : _T_467; // @[Multiplier.scala 177:18:freechips.rocketchip.system.MulDivConfig64.fir@157655.4]
  assign _T_476 = state == 3'h6; // @[Multiplier.scala 180:27:freechips.rocketchip.system.MulDivConfig64.fir@157659.4]
  assign _T_477 = state == 3'h7; // @[Multiplier.scala 180:51:freechips.rocketchip.system.MulDivConfig64.fir@157660.4]
  assign io_req_ready = state == 3'h0; // @[Multiplier.scala 181:16:freechips.rocketchip.system.MulDivConfig64.fir@157664.4]
  assign io_resp_valid = _T_476 | _T_477; // @[Multiplier.scala 180:17:freechips.rocketchip.system.MulDivConfig64.fir@157662.4]
  assign io_resp_bits_data = {hiOut,loOut}; // @[Multiplier.scala 179:21:freechips.rocketchip.system.MulDivConfig64.fir@157658.4]
  assign io_resp_bits_tag = req_tag; // @[Multiplier.scala 178:16:freechips.rocketchip.system.MulDivConfig64.fir@157656.4]
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
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  req_dw = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  req_tag = _RAND_2[4:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  count = _RAND_3[6:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  neg_out = _RAND_4[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  isHi = _RAND_5[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  resHi = _RAND_6[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {3{`RANDOM}};
  divisor = _RAND_7[64:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {5{`RANDOM}};
  remainder = _RAND_8[129:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end
  always @(posedge clock) begin
    if (reset) begin
      state <= 3'h0;
    end else begin
      if (_T_448) begin
        if (cmdMul) begin
          state <= 3'h2;
        end else begin
          if (_T_449) begin
            state <= 3'h1;
          end else begin
            state <= 3'h3;
          end
        end
      end else begin
        if (_T_447) begin
          state <= 3'h0;
        end else begin
          if (_T_100) begin
            if (_T_109) begin
              if (neg_out) begin
                state <= 3'h5;
              end else begin
                state <= 3'h7;
              end
            end else begin
              if (_T_48) begin
                if (_T_99) begin
                  state <= 3'h6;
                end else begin
                  if (_T_47) begin
                    state <= 3'h7;
                  end else begin
                    if (_T_44) begin
                      state <= 3'h3;
                    end
                  end
                end
              end else begin
                if (_T_47) begin
                  state <= 3'h7;
                end else begin
                  if (_T_44) begin
                    state <= 3'h3;
                  end
                end
              end
            end
          end else begin
            if (_T_48) begin
              if (_T_99) begin
                state <= 3'h6;
              end else begin
                if (_T_47) begin
                  state <= 3'h7;
                end else begin
                  if (_T_44) begin
                    state <= 3'h3;
                  end
                end
              end
            end else begin
              if (_T_47) begin
                state <= 3'h7;
              end else begin
                if (_T_44) begin
                  state <= 3'h3;
                end
              end
            end
          end
        end
      end
    end
    if (_T_448) begin
      req_dw <= io_req_bits_dw;
    end
    if (_T_448) begin
      req_tag <= io_req_bits_tag;
    end
    if (_T_448) begin
      count <= {{4'd0}, _T_455};
    end else begin
      if (_T_100) begin
        if (_T_440) begin
          count <= {{1'd0}, _T_435};
        end else begin
          count <= _T_97;
        end
      end else begin
        if (_T_48) begin
          count <= _T_97;
        end
      end
    end
    if (_T_448) begin
      if (cmdHi) begin
        neg_out <= lhs_sign;
      end else begin
        neg_out <= _T_456;
      end
    end else begin
      if (_T_100) begin
        if (_T_445) begin
          neg_out <= 1'h0;
        end
      end
    end
    if (_T_448) begin
      isHi <= cmdHi;
    end
    if (_T_448) begin
      resHi <= 1'h0;
    end else begin
      if (_T_100) begin
        if (_T_109) begin
          resHi <= isHi;
        end else begin
          if (_T_48) begin
            if (_T_99) begin
              resHi <= isHi;
            end else begin
              if (_T_47) begin
                resHi <= 1'h0;
              end
            end
          end else begin
            if (_T_47) begin
              resHi <= 1'h0;
            end
          end
        end
      end else begin
        if (_T_48) begin
          if (_T_99) begin
            resHi <= isHi;
          end else begin
            if (_T_47) begin
              resHi <= 1'h0;
            end
          end
        end else begin
          if (_T_47) begin
            resHi <= 1'h0;
          end
        end
      end
    end
    if (_T_448) begin
      divisor <= _T_458;
    end else begin
      if (_T_44) begin
        if (_T_46) begin
          divisor <= subtractor;
        end
      end
    end
    if (_T_448) begin
      remainder <= {{66'd0}, lhs_in};
    end else begin
      if (_T_100) begin
        remainder <= {{1'd0}, _GEN_16};
      end else begin
        if (_T_48) begin
          remainder <= _T_95;
        end else begin
          if (_T_47) begin
            remainder <= {{66'd0}, negated_remainder};
          end else begin
            if (_T_44) begin
              if (_T_45) begin
                remainder <= {{66'd0}, negated_remainder};
              end
            end
          end
        end
      end
    end
  end
endmodule
