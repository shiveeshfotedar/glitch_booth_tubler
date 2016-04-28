


/////////////////////////////////// glitch1


void setupLogic(PImage img){
    raw = new float[s*3];
    raw1 = new float[s];
    raw2 = new float[s];
    raw3 = new float[s];
    
    
    option1 = random(1)<0.5;
    do_hsb  = random(1)<0.5;

    if(do_hsb) colorMode(HSB,255); else colorMode(RGB,255);
    
    int iter=0;
    int iter2 = 0;
    for(int y=0;y<img.height;y++) {
      for(int x=0;x<img.width;x++) {
        color c = img.get(x,y);
        float r,g,b;
        if(do_hsb) {
          r = hue(c)>127?hue(c)-256:hue(c);
          g = saturation(c)>127?saturation(c)-256:saturation(c);
          b = brightness(c)>127?brightness(c)-256:brightness(c);
        } else {
          r = red(c)>127?red(c)-256:red(c);
          g = green(c)>127?green(c)-256:green(c);
          b = blue(c)>127?blue(c)-256:blue(c);
        }
        raw[iter++] = r;
        raw[iter++] = g;
        raw[iter++] = b;
        raw1[iter2] = r;
        raw2[iter2] = g;
        raw3[iter2] = b;
        iter2++;
      }
    }
    
    n = (int)pow(2,ceil(log(s*3)/log(2)));
    n2 = (int)pow(2,ceil(log(s)/log(2)));
  
    in = new float[n];
    w = new float[n];
    out = new float[n];  
    out1 = new float[n2];
    out2 = new float[n2];
    out3 = new float[n2];
    in1 = new float[n2];
    in2 = new float[n2];
    in3 = new float[n2];
  
    arrayCopy(raw,0,in,0,raw.length);
    for(int i=raw.length;i<n;i++) in[i] = raw[raw.length-1];
  
    arrayCopy(raw1,0,in1,0,s);
    arrayCopy(raw2,0,in2,0,s);
    arrayCopy(raw3,0,in3,0,s);
  
    for(int i=s;i<n2;i++) {
      in1[i] = raw1[s-1];
      in2[i] = raw2[s-1];
      in3[i] = raw3[s-1];
    }
}


void wbtrafo(float[] y, int n) {
  float[] d = new float[n];
  d[n-2] = w[n-1];
  int b1 = n-4;
  int b2 = n-2;
  int a=1;
  while(a<n/2) {
    for(int i=0;i<a;i++) {
      d[2*i+b1]=(d[i+b2]+w[i+b2])*sqrt05;
      d[2*i+1+b1]=(d[i+b2]-w[i+b2])*sqrt05;
    }
    b2=b1;
    b1=b1-4*a;
    a*=2;
  }
  
  for(int i=0;i<a;i++) {
      y[2*i]=(d[i]+w[i])*sqrt05;
      y[2*i+1]=(d[i]-w[i])*sqrt05;
  }
  
  for(int i=0;i<n;i++) y[i] *= scalingfactorout;
}



float clamp(float c) {
  return(abs(c<0?256+c:c)%255.0);
}


void wtrafo(float[] y, int n) {
  float[] d = new float[n];
  int a = n/2;
  for(int i=0;i<a;i++) {
    w[i] = (y[2*i]-y[2*i+1])*sqrt05;
    d[i] = (y[2*i]+y[2*i+1])*sqrt05;
  }
  int b1 = 0;
  int b2 = a;
  a/=2;
  while(a>0) {
    for(int i=0;i<a;i++) {
      w[i+b2]=(d[2*i+b1]-d[2*i+1+b1])*sqrt05;
      d[i+b2]=(d[2*i+b1]+d[2*i+1+b1])*sqrt05;
    }
    b1=b2;
    b2=b2+a;
    a/=2;
  }
  w[b2] = d[b1];
  
  for(int i=0;i<n-1;i++) w[i] = (int)(w[i]/scalingfactorin);
  if(w[n-1]>0) w[n-1] = (int)(w[n-1]/scalingfactorin+0.5);
  else w[n-1] = (int)(w[n-1]/scalingfactorin-0.5);
}


void option1(PImage img) {
  wtrafo(in,n);
  wbtrafo(out,n);
  
  float r=0,g=0,b=0;
  int state = 0;
  
  for(int i=0;i<raw.length;i++) {
    float c = clamp(out[i]);
    switch(state) {
      case 0: r = c; break;
      case 1: g = c; break;
      case 2: b = c; break;
      default: {
        r = c;
        buffer.fill(r,g,b);
        buffer.rect(floor(i/3.0)%img.width,floor(i/3.0)/img.width,1,1);
        state = 0;
      }
    }
    state++;    
  }
}

void option2(PImage img) {
  wtrafo(in1,n2);
  wbtrafo(out1,n2);
  
  wtrafo(in2,n2);
  wbtrafo(out2,n2);
  
  wtrafo(in3,n2);
  wbtrafo(out3,n2);
  
  for(int i=0;i<s;i++) {
    float r = clamp(out1[i]);
    float g = clamp(out2[i]);
    float b = clamp(out3[i]);
    buffer.fill(r,g,b);
    buffer.rect(i%img.width,i/img.width,1,1); 
  }
  
}



/////////////////////// glitch2

 
void quicksort(int x[], int left, int right) {
  if(left<right) {
    int index = partition(x, left, right);
    if(mode) {
      if(left < index-1) quicksort(x, left, index-1);
      if(right < index) quicksort(x, index, right);
    } else {
      if(left > index-1) quicksort(x, left, index-1);
      if(right > index) quicksort(x, index, right);
    }
  }
}


int partition(int x[], int left, int right) {
  int i = left;
  int j = right;
  int temp;
  int pivot = x [(int)map(random_point,0,1,left,right)];
  while (i<= j) {
    while(x[i] < pivot) {
      i++;
    }
    while (x[j] > pivot) {
      j--;
    }
    if (i <= j) {
      temp = x[i];
      x[i] = x [j];
      x[j] = temp;
      i++;
      j--;
    }
  }
  return i;
}





/////////////////////// glitch3


PImage streak(PImage img, int stage) {
  
  if(stage == 1){
    tol = 30.0; // tolerance
    streakMode = 0; // EXCLUSIVE, LESSER, GREATER
    sum = 0; // CLASSIC, RGBSUM, BRIGHT
    lim = 1; // move divisor
    rand = 30;
    h = true;
    v = false;
    Hrev = true;
    Vrev = false;
    active = false;
    toggle = true; // toggle or run continuously
  }else if(stage == 2){
    tol = 30.0; // tolerance
    streakMode = 1; // EXCLUSIVE, LESSER, GREATER
    sum = 0; // CLASSIC, RGBSUM, BRIGHT
    lim = 10; // move divisor
    rand = 1000;
    h = true;
    v = false;
    Hrev = false;
    Vrev = false;
    active = false;
    toggle = true; // toggle or run continuously
    
  }
  
  PGraphics temp = createGraphics(img.width, img.height);
  int off = 0;
  color c;
  boolean a = false;
  temp.beginDraw();
  temp.image(img, 0, 0);
  if (h) {
    if (!Hrev) {
      for (int y = 0; y < img.height-1; y++) {
        for (int x = 0; x < img.width-1; x++) {
          c = img.pixels[x+(y*img.width)];
          while (check (x, y, x+off+1, y, img) == true && x+off+1 < img.width) {
            off++;
            a = true;
          }
          if (a) {
            temp.stroke(c);
            temp.line(x, y, x+(off/lim), y);
            x = x+(off/lim);
            a = false;
            off = 0;
          }
        }
      }
    } else { // hrev
      for (int y = 0; y < img.height-1; y++) {
        for (int x = img.width-1; x > 1; x--) {
          c = img.pixels[x+(y*img.width)];
          while (check (x, y, x-off-1, y, img) == true && x-off-1 > 0) {
            off++;
            a = true;
          }
          if (a) {
            temp.stroke(c);
            temp.line(x, y, x-(off/lim), y);
            x = x-(off/lim);
            a = false;
            off = 0;
          }
        }
      }
    }
  }//h

  if (v) {
    if (!Vrev) {
      for (int x = 0; x < img.width-1; x++) {
        for (int y = 0; y < img.height-1; y++) {
          c = img.pixels[x+(y*img.width)];
          while (check (x, y, x, y+off+1, img) == true && y+off+1 < img.height-1 ) {
            off++;
            a = true;
          }
          if (a) {
            temp.stroke(c);
            temp.line(x, y, x, y+(off/lim));
            y = y+(off/lim);
            a = false;
            off = 0;
          }
        }
      }
    } else { //Vrev
      for (int x = 0; x < img.width-1; x++) {
        for (int y = img.height-1; y > 1; y--) {
          c = img.pixels[x+(y*img.width)];
          while (check (x, y, x, y-off-1, img) == true && y-off-1 > 0) {
            off++;
            a = true;
          }
          if (a) {
            temp.stroke(c);
            temp.line(x, y, x, y-(off/lim));
            y = y-(off/lim);
            a = false;
            off = 0;
          }
        }
      }
    }
  }//v
  temp.endDraw();
  img = temp.get();
  img.updatePixels();
  return img;
}
boolean check(int x, int y, int xc, int yc, PImage img) {  
  float src, dst, r;
  r = (rand != 0) ? random(0, rand) : 0;
  switch(sum) {
  case 1: //rgbsum 
    src = rgbsum(x, y, img);
    dst = rgbsum(xc, yc, img);
    break;
  case 2: // brightness
    src = brightness(img.pixels[x+(y*img.width)]);
    dst = brightness(img.pixels[xc+(yc*img.width)]);
    break;
  default: // 'classic' or asdfish
    src = map(img.pixels[x+(y*img.width)], 0, 0xFFFFFF, 0.0, 255.0);
    dst = map(img.pixels[xc+(yc*img.width)], 0, 0xFFFFFF, 0.0, 255.0);
    break;
  }

  if (streakMode == 0 && (src < dst-tol-r || src > dst+tol+r)) return true;
  else if (streakMode == 1 && src > dst+tol-r) return true;
  else if (streakMode == 2 && src < dst-tol+r) return true;
  else return false;
}

float rgbsum(int x, int y, PImage img) {
  int r = img.pixels[x+(y*img.width)] >> 24 & 0xff;
  int g = img.pixels[x+(y*img.width)] >> 16 & 0xff;
  int b = img.pixels[x+(y*img.width)] & 0xff;
  float result = (r + g + b) / 3;
  return result;
}




/////////////////////// glitch4

PImage lz77(PImage img){
 
  cr = new byte[img.width*img.height];
  cb = new byte[img.width*img.height];
  cg = new byte[img.width*img.height];
  
  buffer.beginDraw();
  
  comp1 = new LZ77( compressor_attributes[0][0], compressor_attributes[0][1] );
  comp2 = new LZ77( compressor_attributes[1][0], compressor_attributes[1][1] );
  comp3 = new LZ77( compressor_attributes[2][0], compressor_attributes[2][1] );
  
  img.loadPixels();
  int iter=0;
  for(int i=0;i<img.pixels.length;i++) {
    color c = img.pixels[i];
    if(colorspace == HSB) {
      cr[iter]= (byte)hue(c);
      cg[iter]= (byte)saturation(c);
      cb[iter]= (byte)brightness(c);
    } else {
      cr[iter]= (byte)red(c);
      cg[iter]= (byte)green(c);
      cb[iter]= (byte)blue(c);
    }
    iter++;
  }
  println("done");
  
  print("Glitching channel 1... ");
  comp1.doCompress(cr);  
  comp1.glitch( (int)number_of_glitches[0][0], number_of_glitches[0][1] );
  comp1.doDecompress(cr);
  println("done");
  
  print("Glitching channel 2... ");
  comp2.doCompress(cg);  
  comp2.glitch( (int)number_of_glitches[1][0], number_of_glitches[1][1] );
  comp2.doDecompress(cg);
  println("done");
  
  print("Glitching channel 3... ");
  comp3.doCompress(cb);  
  comp3.glitch( (int)number_of_glitches[2][0], number_of_glitches[2][1] );
  comp3.doDecompress(cb);
  println("done");
  
  buffer.loadPixels();
  if(colorspace == HSB) colorMode(HSB); else colorMode(RGB);
  iter=0;
  for(int i=0;i<buffer.pixels.length;i++) {
    float r = cr[iter];
    r = r>=0?r:r+256;
    float g = cg[iter];
    g = g>=0?g:g+256;
    float b = cb[iter];
    b = b>=0?b:b+256;
    
    buffer.pixels[i] = color(r,g,b);
    iter++;
  }
  
  buffer.updatePixels();
  
  if(do_blend)
    buffer.blend(img,0,0,img.width,img.height,0,0,buffer.width,buffer.height,blend_mode);
    
  buffer.endDraw();
  return buffer;
  
}

// LZ77

class Tuple {
  public int offset, len;
  byte chr;
  public Tuple(int o, int l, byte c) {
    offset = o; len = l; chr = c;
  }
}

class LZ77 {
  int windowWidth;
  int lookAheadWidht;
  
  public LZ77(int ww, int law) {
    windowWidth = ww;
    lookAheadWidht = law;
  }
  
  ArrayList<Tuple> clist = new ArrayList<Tuple>();
  
  public void glitch(int no, float fac) {
    for(int i=0;i<no;i++) {
      Tuple r = clist.get( (int)random(clist.size()));
      int what = (int)random(3);
      switch(what) {
        case 0: r.chr = (byte)random(256); break;
        case 1: r.offset = (int)random(2*windowWidth*fac); break;
        default: r.len = (int)random(2*lookAheadWidht*fac);
      }
    }
  }
  
  public void doCompress(byte[] buff) {
    int currByte = 1;

    // first is always byte
    clist.add( new Tuple(0,0,buff[0]) );
    
    while(currByte < buff.length) {
      int bend = constrain(currByte-windowWidth,0,buff.length);
      int boff = 0;
      int blen = 0;
      
      if(currByte<buff.length-1)
      for(int i = currByte-1; i>=bend;i--) {
        if(buff[currByte] == buff[i]) {
          
          int tboff = abs(i-currByte);
          int tblen = 1;
          int laEnd = constrain(currByte+lookAheadWidht,0,buff.length-1);
          int mi = currByte+1;
          
          while(mi<laEnd && (i+mi-currByte)<currByte) {
            if(buff[mi] == buff[i+mi-currByte]) {
              mi++;
              tblen++;
            } else {
              break;
            }
          }
          
          if(tblen>blen) {
            blen = tblen;
            boff = tboff;
          }
          
        }
      }
      
      currByte +=blen+1;
     // println("currchar = " + (currByte-1)+",blen = " + blen);
      clist.add( new Tuple(boff,blen,buff[currByte-1]) );
     // println(boff + ", " + blen + ", " + buff[currByte-1]); 
    }
    //println("clist " + clist.size()*2);
  }

  void doDecompress(byte[] buff) {
    int i = 0;
    for(Tuple t: clist) {
      if(i>=buff.length) break;
      if(t.offset == 0) {
        buff[i++] = t.chr;
      } else {
        int start = i-t.offset;
        int end = start + t.len;
        for(int c = start; c<end;c++) {
          int pos = constrain(c,0,buff.length-1);
          buff[constrain(i++,0,buff.length-1)] = buff[pos];
          if(i>=buff.length) break;
        }
        if(i>=buff.length) break;
        buff[i++] = t.chr;
      }
    }
  }
 
}





///////////////////////////////// glitch5

PImage fractalify(PImage img){
  PImage temp = img;
  float zx,zy,cx,cy;
  
   if(doposterize) img.filter(POSTERIZE,(int)random(5,13));   
  
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      color c = img.get(x,y);
      
      if(type == 0) {
        zx = fact1*map(sqrt(getChan(chan1,c)*getChan(chan2,c)),0,1,-1,1);
        zy = fact1*map(sqrt(getChan(chan3,c)*getChan(chan4,c)),0,1,-1,1);
        cx = map(x,0,img.width,-1.4,1.4);
        cy = map(y,0,img.height,1.4,1.4);
      } else {
        cx = fact1*map(sqrt(getChan(chan1,c)*getChan(chan2,c)),0,1,-1,1);
        cy = fact1*map(sqrt(getChan(chan3,c)*getChan(chan4,c)),0,1,-1,1);
        zx = map(x,0,img.width,-1.4,1.4);
        zy = map(y,0,img.height,-1.4,1.4);
      }
      
      if(variant == 0) {
        cx *= fact2*sin(getChan(chan5,c)*2*TWO_PI);
        cy *= fact2*cos(getChan(chan5,c)*2*TWO_PI);
      } else {
        zx *= sin(getChan(chan5,c)*2*TWO_PI);
        zy *= cos(getChan(chan5,c)*2*TWO_PI);
      }
      
      int iter = 500;
      while((sq(zx)+sq(zy))<4.0 && iter-->0) {
        float tmp = sq(zx)-sq(zy)+cx;
        zy = 4.0 * zx * zy + cy;
        zx = tmp*0.5;
      }
      zx = map(zx,0,1,0,255);
      zy = map(zy,0,1,0,255);
      
      float c1 = order[0]==0?zx%255:order[0]==1?zy%255:100*(iter%6);
      float c2 = order[1]==0?zx%255:order[1]==1?zy%255:100*(iter%6);
      float c3 = order[2]==0?zx%255:order[2]==1?zy%255:100*(iter%6);
      
      //buffer.fill();
      buffer.set(x,y,color(c1,c2,c3));
    }
  }
          
 if(doblend) temp.blend(buffer, 0,0,img.width,img.height,0,0,img.width,img.height,ADD);  
 if(doblend) temp.blend(buffer, 0,0,img.width,img.height,0,0,img.width,img.height,SOFT_LIGHT);  

 buffer.image(temp, 0, 0);
 
 buffer.endDraw();
 return buffer;
}


void randomOrder() {
  order[0] = (int)random(0.5, 2);
  order[1] = (int)random(0.5, 1);
  order[2] = (int)random(0.5, 4);
  
}

float getChan(int no, color c) {
  float t;
  switch(no) {
    case 0: t = red(c); break;
    case 1: t = green(c); break;
    case 2: t = blue(c); break;
    case 3: t = hue(c); break;
    case 4: t = saturation(c); break;
    default: t = brightness(c); break; 
  }
  return negative?map(t,0,255,1,0):map(t,0,255,0,1);
}




//////////////////////////////////// glitch6



PImage bitShifter(PImage img){
  PImage temp = img;
  
  temp.loadPixels(); // Fills pixelarray
  float thresh = random(100, 180); // Brightness threshold

if(shiftAmount > 24 || shiftAmount < 0){shiftAmount = 0;}

  for (int y = 0; y< temp.height; y++){
    for (int x = 0; x< temp.width; x++){
      color c = temp.pixels[y*temp.width+x]; 

      int a = (c >> 24) & 0xFF;
      int r = (c >> 16) & 0xFF;  
      int g = (c >> 8) & 0xFF;  
      int b = c & 0xFF; 

      if (y %grid == 0) {

        if (bright){
          if (r+g+b > thresh) {
            temp.pixels[y*temp.width+x] = c << shiftAmount; // Bit-shift based on shift amount
          }
        }else{
          if (r+g+b < thresh) {
            temp.pixels[y*temp.width+x] = c << shiftAmount; // Bit-shift based on shift amount
          }
        }
      }
    }
  }
  temp.updatePixels();
  
  return temp;
}