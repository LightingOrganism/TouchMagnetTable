//build a map of ledPos[logical led positions] = map of led positions on canvas


void mapper() {

  int internalX = 0;
  int internalY = 0;


  //canvasW = 300;
  //canvasH = 64;

  int s;
  boolean up;

  internalX = 40;
  internalY =  90;//starting point on canvas
  s=1;
  up = true;


  for (int x = 0; x < 200; x++) {//start and number of pixels on strip

    //v strip #
    ledPos[xyPixels(x, 0, ledsW)] = xyPixels(internalX, internalY, canvasW);
    println(internalX + " " + internalY + " " + s);
    //make grid
    s++;//going up or down
    if (s > 20) {//height in pixels
      s = 1;
      internalX -= 4;//distance for x
      up = !up;
      println("flipY" + up);
    } else {
      if (up == true) {
        internalY -= 4;//distance for y
      } else {
        internalY += 4;
      }
    }
  }
}






int xyPixels(int x, int y, int yScale) {
  return(x+(y*yScale));
}

int xPixels(int pxN, int yScale) {
  return(pxN % yScale);
}

int yPixels(int pxN, int yScale) {
  return(pxN / yScale);
}

void setupPixelPusher() {
  ledPos = new int[ledsW*ledsH]; //create array of positions of leds on canvas
  mapper();
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  //registry.setAntiLog(true);
  //registry.setAutoThrottle(true);
  //registry.setFrameLimit(1000);
  //frameRate(1000);
  background(0);
}

void drawPixelPusher() {
  loadPixels();

  // Pixel blackP = new Pixel((byte)0, (byte)0, (byte)0);

  if (testObserver.hasStrips) {
    registry.startPushing();
    List<Strip> strips = registry.getStrips( );
    //   List<Strip> strips1 = registry.getStrips(1);
    //   strips1.addAll(registry.getStrips(2));  
    //   strips1.addAll(registry.getStrips(3));  
    //List<Strip> strips2 = registry.getStrips(2);      

    colorMode(HSB, 255);

    for (int y = 0; y < ledsH; y++) {     
      for (int x = 0; x < ledsW; x++) {


        thisLedPos = ledPos[xyPixels(x, y, ledsW)];

        //  int lX = xPixels(thisLedPos, ledsW);
        //  int lY = yPixels(thisLedPos, ledsW);
        //   pixels[xyPixels(x,y,canvasW)] = color(r, g, b);
        color c = pixels[thisLedPos];


         
         c = color(hue(c), saturation(c), brightness(c) - dimmer1); 
         
         if (y >= 0 && y <= 1) //diffused wall
         c = color(hue(c), saturation(c), brightness(c) - dimmer2); 
         
         if (y >= 2 && y <= 5) //bar bottles
         c = color(hue(c), saturation(c), brightness(c) - dimmer3); 
         
         if (y >= 6 && y <= 7) //bar seats
         c = color(hue(c), saturation(c), brightness(c) - dimmer4);

        Pixel p = new Pixel((byte)red(c), (byte)green(c), (byte)blue(c));
        //if (y < strips.size()) {
        //if (y < strips.size() && y >= 2  && y <= 6) {
        if (y < strips.size() && y == 0) {

          //if (y < strips1.size() && y!=34) {
          //if (y < strips1.size() && y==65) {
          
//            if (x < 100){
            strips.get(y).setPixel(p, x);
//            }  
      }
        

        //if (y < strips2.size()) {
        //  strips2.get(y).setPixel(blackP, x);
        //}
      }
    }
  }
}

