

void mousePressed() {
  isCapturing = true;
  
  theImage = cam;
  startedCapture = millis();
}


void checkCapture(){
  
    
  if(millis()-startedCapture > 3000 && isCapturing){
    takePhoto = true;
    isCapturing = false;
  }else if(millis()-startedCapture > 2500 && isCapturing){
    if(flash){
      fill(255); noStroke();
      rect(0, 0, width, height);
    }
  }else if(millis()-startedCapture > 2000 && isCapturing){
    textSize(50);
    fill(255);
    textAlign(CENTER);
    text("1", width/2, height/2);
  }else if(millis()-startedCapture > 1000 && isCapturing){
    textSize(50);
    fill(255);
    textAlign(CENTER);
    text("2", width/2, height/2);
  }else if(millis()-startedCapture > 10 && isCapturing){
    textSize(50);
    fill(255);
    textAlign(CENTER);
    text("3", width/2, height/2);
  }else if(takePhoto){
    
    int whichGlitch = (int)random(0, numGlitches);
//    whichGlitch = 5;
    
    println("glitch "+whichGlitch);
    switch(whichGlitch){
      case 0:
        theImage = applyGlitch1(theImage);
        break;
      case 1:
        theImage = applyGlitch2(theImage);
        break;
      case 2:
        theImage = applyGlitch3(theImage);
        break;
      case 3:
        theImage = applyGlitch4(theImage);
        break;
      case 4:
        theImage = applyGlitch5(theImage);
        break;
      case 5:
        theImage = applyGlitch6(theImage);
        break;
      default:
        break;
    }
  
    String file = "data/"+foldername + filename + "/glitch-"+count+fileext;
    
    theImage.save(file);
    
    count++;
    delay(300);
    theImage = loadImage(file);
    
    lastCaptured = millis();
    startedCapture = -10000;
    takePhoto = false;
  }

}