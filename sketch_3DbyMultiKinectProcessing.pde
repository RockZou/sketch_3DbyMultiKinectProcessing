import org.openkinect.*;
import org.openkinect.processing.tests.*;
import org.openkinect.processing.*;

import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

/* --------------------------------------------------------------------------
 * SimpleOpenNI AlternativeViewpoint3d Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect 2 library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / Zhdk / http://iad.zhdk.ch/
 * date:  12/12/2012 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;
PeasyCam cam;

Kinect kinect;

SimpleOpenNI context;
SimpleOpenNI context1;

int deg=0;

float        zoomF =0.3f;
float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
                                   // the data from openni comes upside down
float        rotY = radians(0);
PShape       pointCloud;
int          steps = 2;

int theZ=3500;
int theX=-120;
int theY=10;


Boolean recording=false;
String recordPath="presentation1.oni";
String videoPath="presentation0.oni";
String videoPath1="presentation1.oni";

void setup()
{
  size(1024,768,P3D);
  
  //kinect = new Kinect(this);
  //kinect.start();
  cam = new PeasyCam(this, width/2,height/2,-500,1000);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(5000);
  
  if (recording)
  {
    context= new SimpleOpenNI(this);
    context.enableRecorder(recordPath);
    initKinect(context);
    context.addNodeToRecording(SimpleOpenNI.NODE_DEPTH,true);
    context.addNodeToRecording(SimpleOpenNI.NODE_IMAGE,true);
    
  }
  else
  {
    context = new SimpleOpenNI(this,videoPath);
    context1 = new SimpleOpenNI(this,videoPath1);
    initKinect(context);
    initKinect(context1);
  }
  //context = new SimpleOpenNI(this,SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  
  
  stroke(255,255,255);
  smooth();
  perspective(radians(45),
              float(width)/float(height), 
              10,150000);
              
  //deg = constrain(deg,-15,15);
  //kinect.tilt(-5);
}

void draw()
{
  // update the cam
  context.update();
  if (!recording)
  context1.update();

  background(0,0,0);

  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);

  PImage  rgbImage = context.rgbImage();
  int[]   depthMap = context.depthMap();

  int     steps   = 4;  // to speed up the drawing, draw every third point
  int     index;
  PVector realWorldPoint;
  color   pixelColor;
 
  strokeWeight((float)steps/2);

  //translate(0,0,-1000);  // set the rotation center of the scene 1000 infront of the camera
  box(10,10,10);
  PVector[] realWorldMap = context.depthMapRealWorld();

  beginShape(POINTS);
  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      if(depthMap[index] > 0&& depthMap[index] < 2500)
      { 
        // get the color of the point
        pixelColor = rgbImage.pixels[index];
        stroke(pixelColor);
        
        // draw the projected point
        realWorldPoint = realWorldMap[index];
        vertex(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);  // make realworld z negative, in the 3d drawing coordsystem +z points in the direction of the eye
      }
    }
  }
  endShape();
  
  
  if (!recording)
  {
    pushMatrix();
    translate(theX,theY,theZ);
    rotateY(PI);
  PImage  rgbImage1 = context1.rgbImage();
  int[]   depthMap1 = context1.depthMap();
  PVector[] realWorldMap1 = context1.depthMapRealWorld();
    beginShape(POINTS);
    for(int y=0;y < context1.depthHeight();y+=steps)
    {
      for(int x=0;x < context1.depthWidth();x+=steps)
      {
        index = x + y * context1.depthWidth();
        if(depthMap1[index] > 1500 && depthMap1[index]<2500)
        { 
          // get the color of the point
          pixelColor = rgbImage1.pixels[index];
          stroke(pixelColor);
          
          // draw the projected point
          realWorldPoint = realWorldMap1[index];
          vertex(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);  // make realworld z negative, in the 3d drawing coordsystem +z points in the direction of the eye
        }
      }
    } 
    endShape();
    popMatrix();
  }
  
  // draw the kinect cam
  strokeWeight(3);
  context.drawCamFrustum();
}


void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  case 's':
  theZ+=100;
  println("theZ ",theZ);
  break;
  case 'w':
  theZ-=100;
  println("theZ ",theZ);
  break;
  case 'a':
  theZ+=10;
  println("theZ ",theZ);
  break;
  case 'q':
  theZ-=10;
  println("theZ ",theZ);
  break;
  case 'd':
  deg--;
  //deg = constrain(deg,-15,15);
  //kinect.tilt(deg);
  break;
  case 'e':
  //deg++;
  //deg = constrain(deg,-15,15);
  //kinect.tilt(deg);
  break;
  case 'j':
  theX-=10;
  println("theX ",theX);
  break;
  case 'l':
  theX+=10;
  println("theX ",theX);
  break;
  case 'k':
  theY-=10;
  println("theY ",theY);
  break;
  case 'i':
  theY+=10;
  println("theY ",theY);
  break;
  }

  switch(keyCode)
  {
  case LEFT:
    rotY += 0.1f;
    break;
  case RIGHT:
    // zoom out
    rotY -= 0.1f;
    break;
  case UP:
    if(keyEvent.isShiftDown())
      zoomF += 0.02f;
    else
      rotX += 0.1f;
    break;
  case DOWN:
    if(keyEvent.isShiftDown())
    {
      zoomF -= 0.02f;
      if(zoomF < 0.01)
        zoomF = 0.01;
    }
    else
      rotX -= 0.1f;
    break;
  }
}

void initKinect(SimpleOpenNI theContext)
{
  if(theContext.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  // disable mirror
  theContext.setMirror(false);

  // enable depthMap generation 
  theContext.enableDepth();

  theContext.enableRGB();

  // setup the recording 
  //context.enableRecorder(recordPath); 
  
  
  
  // align depth data to image data
  theContext.alternativeViewPointDepthToImage();
  theContext.setDepthColorSyncEnabled(true); 
}


void snow()
{
  
}
