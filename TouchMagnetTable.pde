import com.heroicrobot.dropbit.devices.*;
import com.heroicrobot.dropbit.common.*;
import com.heroicrobot.dropbit.discovery.*;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.*;

import ddf.minim.*;

import dmxP512.*;
import processing.serial.*;

import javax.swing.JColorChooser;
import java.awt.Color; 

import hypermedia.net.*;
/*
import com.heroicrobot.dropbit.registry.*;
 import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
 import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
 */
import processing.core.*;
import java.util.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
OscP5 oscP5B;
NetAddress myRemoteLocation;
NetAddress stripApp;

DeviceRegistry registry;

TestObserver testObserver;

boolean dmxEnable =false;
boolean pixEnable = true;


int ledsW = 200;
int ledsH = 1;
int dmxAddr = 100;
int dmxUniv = 1;
int[] ledPos;
int[] dmxPos;
int thisLedPos;
int thisDmxPos;

int canvasW = 50;
int canvasH = 100;

int setcolorMode = 220;
int vFader2 = 255;
int vFader3 = 120;
int vFader4 = 228;
int vFader5 = 1;
int vFader6 = 200;
int vFader7 = 0;
int vFader8 = 0;
int vFaderB1 = 200;
int vFaderB2 = 255;
int vFaderB3 = 155;
int vFaderB4 = 28;
int vFaderB5 = 25;
int vFaderB6 = 128;

int dimmer1 = 0;
int dimmer2 = 0;
int dimmer3 = 0;
int dimmer4 = 0;
int dimmer5 = 0;
int dimmer6 = 0;
int dimmer7 = 0;
int dimmer8 = 0;
int dimmer9 = 0;
int dimmer10 = 0;

float randomTouchState;
float audioResponseState;

int faderWait = 0;
int resetPixelsWait = 0;

OscMessage faderOut;
OscMessage buttonOut;
float faderOutFloat;


Minim minim;

AudioInput in;
AudioRenderer radar;
HeatmapRenderer heatmap;
NoiseParticlesRenderer noiseParticles;
FluidRenderer fluidje;
PerlinColorRenderer perlincolor;
NoiseFieldRenderer noisefield;
FitzhughRenderer fitzhugh;
TuringRenderer turing;
stainedglassRenderer stainedglass;
AudioRenderer[] visuals; 


int select;

int preset = 0;
int turingpreset = 0;

void setup() {
  //size(canvasW, canvasH);
  size(canvasW, canvasH);
  
  frameRate(60);
  colorMode(HSB, 255);

  // setup player
  //minim = new Minim(this);

  // get a line in from Minim, default bit depth is 16
  //in = minim.getLineIn(Minim.STEREO, 512);

  // setup renderers
  noiseParticles = new NoiseParticlesRenderer(in);
  perlincolor = new PerlinColorRenderer(in);
  //radar = new RadarRenderer(in);
  fluidje = new FluidRenderer(in);
  heatmap = new HeatmapRenderer(in);
  noisefield = new NoiseFieldRenderer(in);
  fitzhugh = new FitzhughRenderer(in);
  turing = new TuringRenderer(in);
  stainedglass = new stainedglassRenderer(in);


  visuals = new AudioRenderer[] {
    noiseParticles, perlincolor, heatmap, fluidje, noisefield, fitzhugh, stainedglass, turing
  };

  // activate first renderer in list
  select = 0;
  //in.addListener(visuals[select]);
  visuals[select].setup();

  if (pixEnable == true)
    setupPixelPusher();
  if (dmxEnable == true)
    setupDMX();


  //setup oscp5
  oscP5 = new OscP5(this, 12000);
  oscP5B = new OscP5(this, 9001);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("255.255.255.255", 9000);
  stripApp = new NetAddress("127.0.0.1", 12001);

  /* osc plug service
   * osc messages with a specific address pattern can be automatically
   * forwarded to a specific method of an object. in this example 
   * a message with address pattern /test will be forwarded to a method
   * test(). below the method test takes 2 arguments - 2 ints. therefore each
   * message with address pattern /test and typetag ii will be forwarded to
   * the method test(int theA, int theB)
   */
  oscP5.plug(this, "oscOnClick", "/luminous/xy");
  oscP5.plug(this, "oscOnClick2", "/luminous/xyB");

  oscP5.plug(this, "oscSketch1", "/luminous/sketch1");
  oscP5.plug(this, "oscSketch2", "/luminous/sketch2");
  oscP5.plug(this, "oscSketch3", "/luminous/sketch3");
  oscP5.plug(this, "oscSketch4", "/luminous/sketch4");
  oscP5.plug(this, "oscSketch5", "/luminous/sketch5");
  oscP5.plug(this, "oscSketch6", "/luminous/sketch6");
  oscP5.plug(this, "oscSketch7", "/luminous/sketch7");
  oscP5.plug(this, "oscSketch8", "/luminous/sketch8");
  oscP5.plug(this, "oscSketch9", "/luminous/sketch9");
  oscP5.plug(this, "oscSketch10", "/luminous/sketch10");
  oscP5.plug(this, "oscSketch11", "/luminous/sketch11");
  oscP5.plug(this, "oscSketch12", "/luminous/sketch12");

  oscP5.plug(this, "oscSketchB1", "/luminous/sketchB1");
  oscP5.plug(this, "oscSketchB2", "/luminous/sketchB2");
  oscP5.plug(this, "oscSketchB3", "/luminous/sketchB3");
  oscP5.plug(this, "oscSketchB4", "/luminous/sketchB4");
  oscP5.plug(this, "oscSketchB5", "/luminous/sketchB5");
  oscP5.plug(this, "oscSketchB6", "/luminous/sketchB6");
  oscP5.plug(this, "oscSketchB7", "/luminous/sketchB7");
  oscP5.plug(this, "oscSketchB8", "/luminous/sketchB8");
  oscP5.plug(this, "oscSketchB9", "/luminous/sketchB9");
  oscP5.plug(this, "oscSketchB10", "/luminous/sketchB10");
  oscP5.plug(this, "oscSketchB11", "/luminous/sketchB11");
  oscP5.plug(this, "oscSketchB12", "/luminous/sketchB12");  

  oscP5.plug(this, "oscEffect1", "/luminous/effect1");
  oscP5.plug(this, "oscEffect2", "/luminous/effect2");
  oscP5.plug(this, "oscEffect3", "/luminous/effect3");
  oscP5.plug(this, "oscEffect4", "/luminous/effect4");
  oscP5.plug(this, "oscEffect5", "/luminous/effect5");

  oscP5.plug(this, "oscEffectB1", "/luminous/effectB1");
  oscP5.plug(this, "oscEffectB2", "/luminous/effectB2");
  oscP5.plug(this, "oscEffectB3", "/luminous/effectB3");

  //faders
  oscP5.plug(this, "oscFader1", "/luminous/fader1");
  oscP5.plug(this, "oscFader2", "/luminous/fader2");
  oscP5.plug(this, "oscFader3", "/luminous/fader3");
  oscP5.plug(this, "oscFader4", "/luminous/fader4");
  oscP5.plug(this, "oscFader5", "/luminous/fader5");
  oscP5.plug(this, "oscFader6", "/luminous/fader6");
  oscP5.plug(this, "oscFader7", "/luminous/fader7");
  oscP5.plug(this, "oscFader8", "/luminous/fader8");

  oscP5.plug(this, "oscFaderB1", "/luminous/faderB1");
  oscP5.plug(this, "oscFaderB2", "/luminous/faderB2");
  oscP5.plug(this, "oscFaderB3", "/luminous/faderB3");
  oscP5.plug(this, "oscFaderB4", "/luminous/faderB4");
  oscP5.plug(this, "oscFaderB5", "/luminous/faderB5");
  oscP5.plug(this, "oscFaderB6", "/luminous/faderB6");

  oscP5B.plug(this, "oscFaderB1", "/luminous/fader1");
  oscP5B.plug(this, "oscFaderB2", "/luminous/fader2");
  oscP5B.plug(this, "oscFaderB3", "/luminous/fader3");
  oscP5B.plug(this, "oscFaderB4", "/luminous/fader4");
  oscP5B.plug(this, "oscFaderB5", "/luminous/fader5");
  oscP5B.plug(this, "oscFaderB6", "/luminous/fader6");


  //dimmers
  oscP5.plug(this, "oscDimmer1", "/luminous/dimmer1");
  oscP5.plug(this, "oscDimmer2", "/luminous/dimmer2");
  oscP5.plug(this, "oscDimmer3", "/luminous/dimmer3");
  oscP5.plug(this, "oscDimmer4", "/luminous/dimmer4");
  oscP5.plug(this, "oscDimmer5", "/luminous/dimmer5");
  oscP5.plug(this, "oscDimmer6", "/luminous/dimmer6");
  oscP5.plug(this, "oscDimmer7", "/luminous/dimmer7");
  oscP5.plug(this, "oscDimmer8", "/luminous/dimmer8");
  oscP5.plug(this, "oscDimmer9", "/luminous/dimmer9");
  oscP5.plug(this, "oscDimmer10", "/luminous/dimmer10");
}


void oscSketch1(float iA) {
  //in.removeListener(visuals[select]);
  select = 0;
  vFader5 = 30;
  vFader6 = 50;
  //in.addListener(visuals[select]);
  //visuals[select].setup();
  colorMode(HSB, 255);
}
void oscSketch2(float iA) {
  //in.removeListener(visuals[select]);
  select = 1;
  //in.addListener(visuals[select]);
  visuals[select].setup();
  //add code to prevent double tap
}
void oscSketch3(float iA) {
  //in.removeListener(visuals[select]);
  select = 2;
  //in.addListener(visuals[select]);
  visuals[select].setup();
  colorMode(HSB, 255);
}
void oscSketch4(float iA) {
  //in.removeListener(visuals[select]);
  select = 3;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
void oscSketch5(float iA) {
  //in.removeListener(visuals[select]);
  select = 4;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
void oscSketch6(float iA) {
  //in.removeListener(visuals[select]);
  select = 5;
  //int setcolorMode = 140;
  //int vFader3 = 255;
  //int vFader4 = 0;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
void oscSketch7(float iA) { 
  //in.removeListener(visuals[select]);
  select = 6;
  preset = 0;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}  

void oscSketch8(float iA) {
  //in.removeListener(visuals[select]);
  select = 6;
  preset = 1;
  //in.addListener(visuals[select]);
  visuals[select].setup();

  //colorMode(RGB);
}
void oscSketch9(float iA) {
  //in.removeListener(visuals[select]);
  select = 6;
  preset = 3;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}

void oscSketch10(float iA) {
  //in.removeListener(visuals[select]);
  select = 6;
  preset = 2;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
void oscSketch11(float iA) {
  //in.removeListener(visuals[select]);
  select = 7;
  turingpreset = 2;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
void oscSketch12(float iA) {
  //in.removeListener(visuals[select]);
  select = 7;
  turingpreset = 0;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}


void oscSketchB1(float iA) {
  buttonOut = new OscMessage("/luminous/sketch1");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscSketchB2(float iA) {
  buttonOut = new OscMessage("/luminous/sketch2");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscSketchB3(float iA) {
  buttonOut = new OscMessage("/luminous/sketch3");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscSketchB4(float iA) {
  buttonOut = new OscMessage("/luminous/sketch4");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscSketchB5(float iA) {
  buttonOut = new OscMessage("/luminous/sketch5");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscSketchB6(float iA) {
  buttonOut = new OscMessage("/luminous/sketch6");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscSketchB7(float iA) {
  buttonOut = new OscMessage("/luminous/sketch7");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscSketchB8(float iA) {
  buttonOut = new OscMessage("/luminous/sketch8");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscSketchB9(float iA) {
  buttonOut = new OscMessage("/luminous/sketch9");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscSketchB10(float iA) {
  buttonOut = new OscMessage("/luminous/sketch10");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscSketchB11(float iA) {
  buttonOut = new OscMessage("/luminous/sketch11");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscSketchB12(float iA) {
  buttonOut = new OscMessage("/luminous/sketch12");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscEffectB1(float iA) {
  buttonOut = new OscMessage("/luminous/effect1");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscEffectB2(float iA) {
  buttonOut = new OscMessage("/luminous/effect2");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}
void oscEffectB3(float iA) {
  buttonOut = new OscMessage("/luminous/effect3");
  buttonOut.add(1.0);
  oscP5.send(buttonOut, stripApp);
}


void oscOnClick(float iA, float iB) {
  if (select == 0)
    noiseParticles.onClick(iA, iB);
  if (select == 1)
    perlincolor.onClick(iA, iB);
  if (select == 2)
    heatmap.onClick(iA, iB);
  if (select == 3)
    fluidje.onClick(iA, iB);
  if (select == 4)
    noisefield.onClick(iA, iB);
  if (select == 5)
    fitzhugh.onClick(iA, iB);
  if (select == 6)
    stainedglass.onClick(iA, iB);
  if (select == 7)
    turing.onClick(iA, iB);
}

void oscOnClick2(float iA, float iB) {
  faderOut = new OscMessage("/luminous/xy");
  faderOut.add(iA);
  faderOut.add(iB);
  oscP5.send(faderOut, stripApp);
}

void oscEffect1(float iA) {
  if ((millis() - resetPixelsWait) > 100) {
    resetPixelsWait = millis();
    noiseParticles.clearParticles(iA);
  }
}
void oscEffect2(float iA) {
  heatmap.heattoggle(iA);
}
void oscEffect3(float iA) {
  turing.directiontoggle(iA);
  // simplegradient.directiontoggle(iA);
}
void oscEffect4(float iA) {
  randomTouchState = iA;
}
void oscEffect5(float iA) {
  audioResponseState = iA;
}

void oscFader1(float faderIn) {
  setcolorMode = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFader2(float faderIn) {
  vFader2 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFader3(float faderIn) {
  vFader3 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFader4(float faderIn) {
  vFader4 = (int)map(faderIn, 0, 1, 0, 255);
}  
public void oscFader5(float faderIn) {
  vFader5 = (int)map(faderIn, 0, 1, 0, 255);
}  
public void oscFader6(float faderIn) {
  vFader6 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFader7(float faderIn) {
  vFader7 = (int)map(faderIn, 0, 1, 0, 255);
}  
public void oscFader8(float faderIn) {
  vFader8 = (int)map(faderIn, 0, 1, 0, 255);
}    
public void oscFaderB1(float faderIn) {
  vFaderB1 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFaderB2(float faderIn) {
  vFaderB2 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFaderB3(float faderIn) {
  vFaderB3 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFaderB4(float faderIn) {
  vFaderB4 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFaderB5(float faderIn) {
  vFaderB5 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFaderB6(float faderIn) {
  vFaderB6 = (int)map(faderIn, 0, 1, 0, 255);
}

public void oscDimmer1(float faderIn) {
  dimmer1 = (int)map(faderIn, 0, 1, 0, 255);
}  
public void oscDimmer2(float faderIn) {
  dimmer2 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer3(float faderIn) {
  dimmer3 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer4(float faderIn) {
  dimmer4 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer5(float faderIn) {
  dimmer5 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer6(float faderIn) {
  dimmer6 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer7(float faderIn) {
  dimmer7 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer8(float faderIn) {
  dimmer8 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer9(float faderIn) {
  dimmer9 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer10(float faderIn) {
  dimmer10 = (int)map(faderIn, 0, 1, 0, 255);
}

void oscFaderSet() {

  if ((millis() - faderWait) > 750) {
    faderWait = millis();

    faderOut = new OscMessage("/luminous/fader1");
    faderOutFloat = (float)map(setcolorMode, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader2");
    faderOutFloat = (float)map(vFader2, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader3");
    faderOutFloat = (float)map(vFader3, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader4");
    faderOutFloat = (float)map(vFader4, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader5");
    faderOutFloat = (float)map(vFader5, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader6");
    faderOutFloat = (float)map(vFader6, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader7");
    faderOutFloat = (float)map(vFader7, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader8");
    faderOutFloat = (float)map(vFader8, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader1");
    faderOutFloat = (float)map(vFaderB1, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, stripApp);

    faderOut = new OscMessage("/luminous/faderB1");
    faderOutFloat = (float)map(vFaderB1, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader2");
    faderOutFloat = (float)map(vFaderB2, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, stripApp);

    faderOut = new OscMessage("/luminous/faderB2");
    faderOutFloat = (float)map(vFaderB2, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader3");
    faderOutFloat = (float)map(vFaderB3, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, stripApp);

    faderOut = new OscMessage("/luminous/faderB3");
    faderOutFloat = (float)map(vFaderB3, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader4");
    faderOutFloat = (float)map(vFaderB4, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, stripApp);

    faderOut = new OscMessage("/luminous/faderB4");
    faderOutFloat = (float)map(vFaderB4, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader5");
    faderOutFloat = (float)map(vFaderB5, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, stripApp);

    faderOut = new OscMessage("/luminous/faderB5");
    faderOutFloat = (float)map(vFaderB5, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader6");
    faderOutFloat = (float)map(vFaderB6, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, stripApp);

    faderOut = new OscMessage("/luminous/faderB6");
    faderOutFloat = (float)map(vFaderB6, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);


    faderOut = new OscMessage("/luminous/dimmer1");
    faderOutFloat = (float)map(dimmer1, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);
    oscP5.send(faderOut, stripApp);

    faderOut = new OscMessage("/luminous/dimmer2");
    faderOutFloat = (float)map(dimmer2, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/dimmer3");
    faderOutFloat = (float)map(dimmer3, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);
    oscP5.send(faderOut, stripApp);

    faderOut = new OscMessage("/luminous/dimmer4");
    faderOutFloat = (float)map(dimmer4, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);
    oscP5.send(faderOut, stripApp);

    faderOut = new OscMessage("/luminous/dimmer5");
    faderOutFloat = (float)map(dimmer5, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/dimmer6");
    faderOutFloat = (float)map(dimmer6, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/effect4");
    faderOutFloat = randomTouchState;
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/effect5");
    faderOutFloat = audioResponseState;
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);
  }
}


void draw() {    
  oscFaderSet();
  visuals[select].draw();
  if (pixEnable == true)
    drawPixelPusher();
  if (dmxEnable == true)
    drawDMX();

  //println(frameRate);
}




void keyPressed() {
  if (key == ' ') {
    //in.removeListener(visuals[select]);
    select++;
    select %= visuals.length;
    //in.addListener(visuals[select]);
    visuals[select].setup();
  } else {
    if (select == 7)
    {
      turing.keyPressed();
    }
  }
}


void stop()
{
  // always close Minim audio classes when you are done with them
  //in.close();
  minim.stop();
  super.stop();
}

void mouseClicked() {
  try {
    fluidje.mouseClicked();
    throw new NullPointerException();
  }
  catch (NullPointerException e) {
  }
}

void mouseDragged() {
  try {
    fluidje.mouseClicked();
    throw new NullPointerException();
  }
  catch (NullPointerException e) {
  }
}



/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
   */
  if (theOscMessage.isPlugged()==false) {
    /* print the address pattern and the typetag of the received OscMessage */
    println("### received an osc message.");
    println("### addrpattern\t"+theOscMessage.addrPattern());
    println("### typetag\t"+theOscMessage.typetag());
  }
}

