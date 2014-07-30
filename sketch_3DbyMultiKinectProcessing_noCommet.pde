
import SimpleOpenNI.*;


SimpleOpenNI context;
SimpleOpenNI context1;
SimpleOpenNI cam;

PrintWriter output;

boolean isPlaying=true;
float        zoomF =0.3f;
float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
                                   // the data from openni comes upside down
float        rotY = radians(0);
PShape       pointCloud;
int          steps = 2;//the increment for skipping pixel in case it gets slower
float        theSpeed=1.0;//the speed for recording playback

//two point clouds to merge both
int theZ=5070;
int theX=130;
int theY=-20;

//the current frame number for recording playback
int curFrame=0;

int thresholdLowA=0;
int thresholdHighA=5000;
int thresholdLowB=0;
int thresholdHighB=5000;

Boolean recording=false;

String recordingName="veronika1A";
String recordPath=recordingName+".oni";//.oni is a openNI file

//this is to load videos -- two video files from two cameras to be merged together
String videoPath=recordingName+".oni";//test.oni
String videoPath1="veronika1B.oni";

void setup()
{
  size(1024,768,P3D);//P3D is the wrapper for renderer OpenGL
  
  output=createWriter(recordingName+".txt");
  
  cam=new SimpleOpenNI(this);
  
  if (recording)//if it is recording
  {
    initRecording();
  }
  else//not recording, playingback
  {
    initPlayback();
  }
  
  //context = new SimpleOpenNI(this,SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  
  //stroke(r,g,b) controls the color of the pixels
  stroke(255,255,255);
  
  //to smooth the display of everything on screen
  smooth();
  
  
  //perspective(radians(45),float(width)/float(height),10,150000);
              
  //deg = constrain(deg,-15,15);
  //kinect.tilt(-5);
}

void draw()
{
  // update the cam
  
  if (recording)
  {
    context.setPlaybackSpeedPlayer(theSpeed);
    context.update();
    output.println(millis());
    background(0);

    //to postion the first point cloud
    //setting the new reference origin point
    translate(width/2, height/2, 0);
    rotateX(rotX);
    rotateY(rotY);
    scale(zoomF);


    PImage  rgbImage = context.rgbImage();
    int[]   depthMap = context.depthMap();

    int     steps   = 4;  // to speed up the drawing, draw every third point
    int     index;
    PVector realWorldPoint;//point cloud
    color   pixelColor;//the color of pixels
 
    /******* to draw the map********/
    strokeWeight((float)steps/2);//the weight of the points pixels
    //translate(0,0,-1000);  // set the rotation center of the scene 1000 infront of the camera
    
    //create a xyz locative vector for each pixel
    PVector[] realWorldMap = context.depthMapRealWorld();

    /******draw the point map*******/
    beginShape(POINTS);
    for(int y=0;y < context.depthHeight();y+=steps)
    {
      for(int x=0;x < context.depthWidth();x+=steps)
      {
        index = x + y * context.depthWidth();
        if(depthMap[index] > thresholdLowA&& depthMap[index] < thresholdHighA)
        { 
          // get the color of the point
          pixelColor = rgbImage.pixels[index];
          stroke(pixelColor);
          
          // draw the projected point
          realWorldPoint = realWorldMap[index];
          vertex(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);  // make realworld z negative, in the 3d drawing coordsystem +z points in the direction of the eye
        }//end if
      }//end for x
    }//end for y
    endShape();
    /**end drawing the point map****/

  }
  else //(not recording)
  {
    
    /**********BUG**********************/
    //setting the speed everytime because
    //the playbackspeed weirdly changes itself(video speeds up crazily)
    //after about 10 seconds
    
    context.setPlaybackSpeedPlayer(theSpeed);//theSpeed is controlled by UP and DOWN in the program
    
    //context.update is to get a new frame
    context.update();
    
    /*
    if (context.curFramePlayer()>=frameNum[theFrameIndex])
    {
      context1.seekPlayer(frameNum1[theFrameIndex]);
      theFrameIndex++;
      if (theFrameIndex==5)
      {
        theFrameIndex=0;
        context.seekPlayer(frameNum[0]);
      }
    }
    */
    context1.setPlaybackSpeedPlayer(theSpeed);
    context1.update();
    
    background(0);


    //to postion the first point cloud
    //setting the new reference origin point
    translate(width/2, height/2, 0);
    rotateX(rotX);
    rotateY(rotY);
    scale(zoomF);

    PImage  rgbImage = context.rgbImage();
    int[]   depthMap = context.depthMap();

    int     steps   = 5;  // to speed up the drawing, draw every third point
    int     index;
    PVector realWorldPoint;
    color   pixelColor;
 
    strokeWeight((float)steps/2);

    //translate(0,0,-1000);  // set the rotation center of the scene 1000 infront of the camera
    box(10,10,10);
    PVector[] realWorldMap = context.depthMapRealWorld();

     /*************draw map1 ************/
    beginShape(POINTS);
    for(int y=0;y < context.depthHeight();y+=steps)
    {
      for(int x=0;x < context.depthWidth();x+=steps)
      {
        //every image is stored as a one dimensional array
        
        index = x + y * context.depthWidth();
        
        if(depthMap[index] > thresholdLowA && depthMap[index] < thresholdHighA)//only display 1000-3000mm range images, which is where the person is
        { 
          // get the color of the point
          pixelColor = rgbImage.pixels[index];
          stroke(pixelColor);
        
          // draw the projected point
          realWorldPoint = realWorldMap[index];
          vertex(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);  // make realworld z negative, in the 3d drawing coordsystem +z points in the direction of the eye
        }//end if
      }//end for x
    }//end for y
    endShape();
  
  
 /*****draw map2***********/
       
    pushMatrix();
    
    //to merge the second image to the first image
    //x,y,z can be controlled with keys, assume the rotation is 180 degress
    //since the cameras are placed facing each other
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
        if(depthMap1[index] > thresholdLowB && depthMap1[index]<thresholdHighB)//only display 1000-3000mm range images, which is where the person is
        { 
          // get the color of the point
          pixelColor = rgbImage1.pixels[index];
          stroke(pixelColor);
          
          // draw the projected point
          realWorldPoint = realWorldMap1[index];
          vertex(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);  // make realworld z negative, in the 3d drawing coordsystem +z points in the direction of the eye
        }//end if
      }//end for x
    }//end for y
    endShape();
    popMatrix();//end translate xyz and rotateY
    
    hint(DISABLE_DEPTH_TEST);
    stroke(255);
    println(context.curFramePlayer());
    println(context1.curFramePlayer());
    hint(ENABLE_DEPTH_TEST);
  }
  
  // draw the kinect cam in the frame
  strokeWeight(3);
  context.drawCamFrustum();
}

//key board interface
void keyPressed()
{
  /*
  switch(key)
  {
  case ' ':
    //context.setMirror(!context.mirror());
    
    //synchronization offsets for two videos
    context.seekPlayer(92);
    context1.seekPlayer(100);
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
  
    /*************start kinect tilting interface******/
  //case 'd':
  //deg--;
  //deg = constrain(deg,-15,15);
  //kinect.tilt(deg);//it tilts the kinect by accessing the motor
  
  //break;
  //case 'e':
  //deg++;
  //deg = constrain(deg,-15,15);
  //kinect.tilt(deg);
  //break;
  /********end kinect tilting interface*************/
  
  switch(key)
  {
    
  case 'q':
  case 'Q':
  if(recording)
  {
    output.flush();
    output.close();
    exit();  
  }
  break;
  case ' ':
  isPlaying=!isPlaying;
  context.playbackPlay(isPlaying);
  context1.playbackPlay(isPlaying);
  break;
  case CODED:
    switch(keyCode)
    {
    case LEFT:
      // jump back
      context.playbackPlay(false);
      curFrame=context.curFramePlayer();
      curFrame--;
      if (curFrame<1)
      curFrame=context.framesPlayer();
      context.seekPlayer(curFrame);
      break;
    case RIGHT:
      // jump forward
      context.playbackPlay(false);
      curFrame=context.curFramePlayer();
      curFrame++;      
      if (curFrame>context.framesPlayer())
      curFrame=1;      
      context.seekPlayer(curFrame);
      break;
    case UP:
      // slow down
      theSpeed=theSpeed*2.0;
      println("playbackSpeedPlayer: " + context.playbackSpeedPlayer());
      break;
    case DOWN:
      // speed up
      theSpeed=theSpeed/2.0;
       println("playbackSpeedPlayer: " + context.playbackSpeedPlayer());
     break;
    }
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


