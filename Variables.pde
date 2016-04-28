import processing.video.*;


int numGlitches = 6;
Capture cam;

boolean isInitted = false;

String filename = "saved_images";
String fileext = ".jpg";
String foldername = "./";

int lastCaptured = 0;
int startedCapture = -10000;
boolean isCapturing = false;
boolean takePhoto = false;
boolean flash = true;

int camX = 0;

int count = 1;

// logic below

boolean do_hsb = false; // do operate on HSB channels

float scalingfactorin;
float scalingfactorout;

final static float sqrt05 = sqrt(0.5);

float[] raw, raw1,raw2,raw3;
float[] in, w, out;
float[] in1,in2,in3,out1,out2,out3;
int n,n2,s;

boolean option1 = false;
float sc = 180;

PImage theImage;

// working buffer
PGraphics buffer;

String sessionid;





static final int[] blends = {ADD, SUBTRACT, DARKEST, LIGHTEST, DIFFERENCE, EXCLUSION, MULTIPLY, SCREEN, OVERLAY, HARD_LIGHT, SOFT_LIGHT, DODGE, BURN};

static final boolean L = true;
static final boolean R = false;

boolean mode = L; // L or R, which sort part is broken 

boolean do_blend2 = true; // blend image after process
int blend_mode = OVERLAY; // blend type
float random_point = 0.5;





float tol = 30.0; // tolerance
int streakMode = 0; // EXCLUSIVE, LESSER, GREATER
int sum = 0; // CLASSIC, RGBSUM, BRIGHT
int lim = 1; // move divisor
float rand = 30;
boolean h = false;
boolean v = true;
boolean Hrev = true;
boolean Vrev = false;
boolean active = false;
boolean toggle = true; // toggle or run continuously





LZ77 comp1, comp2, comp3;
byte[] cr,cb,cg;

boolean do_blend = false; // blend image after process

// choose colorspace
int colorspace = RGB; // HSB or RGB
// set compressor attributes for each channel in chosen colorspace
//   first number is length of dictionary in LZ77 - values 100 - 4000
//   second number is length of word (ahead buffer) in LZ77 - about 5% - 50% of dictionary size 
int[][] compressor_attributes = { {2000, 250},   // channel 1 (H or R)
                                  {50, 10},   // channel 2 (S or G)
                                  {100, 100} };  // channel 3 (B or B)
// set number of glitches made for each channel
//   first number is actual number of random change in compressed channel
//   second number is amount of change (values from 0.01 to 4)
float[][] number_of_glitches = { {5000,2},       // channel 1
                                 {500, 1},     // channel 2
                                 {50, 0.1} };   // channel 3




int type;
int variant;
float fact1;
float fact2;
int chan1,chan2,chan3,chan4,chan5;
int[] order = {0,1,2};
int[] blendmethods = {ADD, SUBTRACT, DARKEST, LIGHTEST, DIFFERENCE, EXCLUSION, MULTIPLY, SCREEN, OVERLAY, HARD_LIGHT, SOFT_LIGHT, DODGE, BURN};
boolean doblend, doposterize;
boolean negative;




boolean bright = true;
boolean greyScale;
int shiftAmount = 3;
int grid = 1;