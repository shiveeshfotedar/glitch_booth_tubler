// wzip - a preprocessor for lossy data compression, originally: Copyright (C) 1997 Andreas Franzen
// Processing port, Tomasz Sulej, generateme.blog@gmail.com
// Haar wavelet transformation to glitch your raw images, operates on bytes, use different scaling factors (see below)

// Licence GNU GPL 2.0

// move mouse around the image
// * press ENTER/RETURN to change scale for scaling factors
// * press SPACE to toggle between RGBRGB... (HSBHSB...) or RRR...GGG...BBB... (HHH...SSS...BBB...) raws
// * click to save


void setup() {
  background(0);
  
  sessionid = hex((int)random(0xffff),4);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }   
  theImage = cam;
  lastCaptured = -20000;
  
  
  
  fullScreen(2);
  
}


void draw() {
  
  if (cam.available() == true) {
    cam.read();
    
    if(millis()-lastCaptured > 5000){
      image(cam, camX, 0, width, height);
      
      
      if(!isCapturing){
        fill(#fc4600);
        noStroke();
        ellipseMode(CENTER);
        
        ellipse(width/2, height/2, cam.height/2, cam.height/2);
        
        textAlign(CENTER);
        textSize(30);
        text(" ", width, height/2);
      }
    }else{
      image(theImage, 0, 0, width, height);
    }
    
    
    checkCapture();
    
    if(!isInitted){
      resetBuffer();
      s = cam.width*cam.height;
      
      isInitted = true;
    }
  }
  

}


void resetBuffer(){
  buffer = createGraphics(cam.width, cam.height);
  buffer.beginDraw();
  buffer.background(0);
  buffer.image(cam,0,0);
  buffer.noStroke();
  buffer.endDraw();  
}


PImage applyGlitch1(PImage img){
  resetBuffer();
    
  setupLogic(img);

  buffer.beginDraw();
  scalingfactorin = random(sc/2,sc);
  scalingfactorout = random(sc/2,sc);
  
  if(option1) option1(img);
  else option2(img);  
  
  buffer.endDraw();
  
  return buffer;
}


PImage applyGlitch2(PImage img) {
  int v = (int)random(1,s-1);
  resetBuffer();

  buffer.loadPixels();
  
  int x = 0;
  while(x<s) {
    if(x+v<s) quicksort(buffer.pixels, x, x+v);
    else quicksort(buffer.pixels, x, s-1);
    x += v;
  }
  
  buffer.updatePixels();
  
  if(do_blend2) {
    buffer.beginDraw();
    buffer.blend(img,0,0,img.width,img.height,0,0,buffer.width,buffer.height,LIGHTEST);
    buffer.blend(buffer,0,0,img.width,img.height,0,0,buffer.width,buffer.height,OVERLAY);
    buffer.endDraw();
  }
    
  return buffer;
}



PImage applyGlitch3(PImage img) {
  resetBuffer();
  
  PImage temp = streak(buffer, 2);
  //temp = streak(temp, 2);
  
  return temp;
}

PImage applyGlitch4(PImage img){
  resetBuffer();
  
  colorspace = random(1)<0.4?RGB:HSB;
  //do_blend = random(1)<0.2;
  blend_mode = blends[(int)random(blends.length)];
  for(int i=0;i<3;i++) {
    compressor_attributes[i][0] = (int)random(10,200);
    compressor_attributes[i][1] = (int)(random(0.1,0.5)*compressor_attributes[i][0]);
    number_of_glitches[i][0] = (int)random(10,50);
    number_of_glitches[i][1] = random(3,4);
  } 
  return lz77(img);
}


PImage applyGlitch5(PImage img){
  resetBuffer();
  
  type=1;
  variant=0;
  fact1 = random(1,2.5);
  fact2 = random(0.3,1);
  chan1 = (int)random(6);
  chan2 = (int)random(6);
  chan3 = (int)random(6);
  chan4 = (int)random(6);
  chan5 = (int)random(6);
  doblend = true;
  doposterize = true;
  negative = false;
  randomOrder();
  
  return fractalify(img);
}

PImage applyGlitch6(PImage img){
  
  return bitShifter(img);
}