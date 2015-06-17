class PerlinColorRenderer extends AudioRenderer {

  
// Perlin Noise Demo - Jim Bumgardner
  //dje mod
  
  float perlinColor;
float kNoiseDetail = 0.01;
float r;
float speed = .01;
float ox = 200;
float oy = 200;
float cX = 0;
float cY = 0;
 
int rotations;

 PerlinColorRenderer(AudioSource source) {
    //rotations =  (int) source.sampleRate() / source.bufferSize();
  } 
 
void setup()
{
  //size(256,256);
  r = width/PI;
  
  smooth();
     
  noiseDetail(3,.6);
  colorMode(HSB, 1); //setupPixelPusher();
  setcolorMode = 205;
  vFader2 = 255;
  vFader3 = 125;
  vFader4 = 128;
  vFader5 = 10;
  vFader6 = 200;
}
 
 
synchronized void draw()
{
  colorMode(HSB, 1);
  //ox += max(-speed,min(speed,(mouseX-width/2)*speed/r));
  //oy += max(-speed,min(speed,(mouseY-height/2)*speed/r));
 float setSpeedModeF = (float)map(vFader5, 0, 255, .0001, .08);
 speed = setSpeedModeF;
  ox += max(-speed,min(speed,(width/2-cX)*speed/r));
  oy += max(-speed,min(speed,(height/2-cY)*speed/r));
 
 
  for (int y = 0; y < height; ++y)
  {
    for (int x = 0; x < width; ++x)
    {
      //change colors
      //setcolorMode
      //set(x,y,color(.1-y*.1/height,4-v,.7+v*v));
     float setcolorModeF = (float)map(setcolorMode, 0, 255, 0.01, .98);
     float setSatModeF = (float)map(vFader2, 0, 255, 0, 1);
     float setBrightModeF = (float)map(vFader3, 0, 255, 0, 1);
     float setContrastModeF = (float)map(vFader4, 0, 255, 0.1, .6);
     
     //float setSpeedModeF = (float)map(vFader5, 0, 255, .0001, .0008);
     float setNoiseDetailF = (float)map(vFader6, 0, 255, .0001, .06);
     

      //float v = noise(ox+x*kNoiseDetail,oy+y*kNoiseDetail,millis()*setSpeedModeF);     
      //float v = noise(ox+x*kNoiseDetail,oy+y*kNoiseDetail,millis()*.0001);     
      //set(x,y,color(setcolorModeF-y*.05/height,(4-v)*setSatModeF,(setContrastModeF+v*v)*setBrightModeF));    
      float v = noise(ox+x*(kNoiseDetail+setNoiseDetailF),oy+y*(kNoiseDetail+setNoiseDetailF),millis()*.00005);
      set(x,y,color(setcolorModeF-setContrastModeF*v,setSatModeF,(v+v)*setBrightModeF));    
    }
  }
    colorMode(RGB,255);
 
//drawPixelPusher();
}

public void onClick(float mX, float mY) {
    cX = mX * canvasW;
    cY = mY * canvasH;
    //int oX = (int)cX;
    //int oY = (int)cY;
    //ox += max(-speed,min(speed,(cX-width/2)*speed/r));
    //oy += max(-speed,min(speed,(cY-height/2)*speed/r));
    
    //move_clouds(oX, oY, 25, .25);
  }

/*  
void move_clouds(int i, int j, int r, float delta)
  {
    ox += max(-speed,min(speed,(ox-width/2)*speed/r));
    oy += max(-speed,min(speed,(oy-height/2)*speed/r));
  //ox += max(-speed,min(speed,(ox-width/2)*speed/r));
  //oy += max(-speed,min(speed,(oy-height/2)*speed/r));
 
 
    for (int y = 0; y < height; ++y)
    {
      for (int x = 0; x < width; ++x)
      {
        float v = noise(ox+x*kNoiseDetail,oy+y*kNoiseDetail,millis()*.0002);
      //change colors
      //setcolorMode
      //set(x,y,color(.1-y*.1/height,4-v,.7+v*v)); 
        set(x,y,color(.1-y*.1/height,4-v,.3+v*v));    
      }
    }
  }*/
  

}
