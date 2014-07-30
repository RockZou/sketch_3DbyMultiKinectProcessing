

import SimpleOpenNI.*;


SimpleOpenNI context;
SimpleOpenNI context1;
SimpleOpenNI cam;

PrintWriter output;

int xEyePlus=5;
int xEye=0;

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

int thresholdLowA=2000;
int thresholdHighA=4000;
int thresholdLowB=2000;
int thresholdHighB=4000;

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
  
  // enable depthMap generation 
  cam.enableDepth();
   
  // enable skeleton generation for all joints
  cam.enableUser();
  
  if (recording)//if it is recording
  {
    initRecording();
  }
  else//not recording, playingback
  {
    initPlayback();
  }
  
  smooth();
  
  camera(0,0,0,0,0,-4000,0,1,0);
}

void draw()
{
  if (recording)
  {
    context.setPlaybackSpeedPlayer(theSpeed);
    context.update();
    output.println(millis());
    background(0);

    translate(width/2, height/2, 0);
    rotateX(rotX);
    rotateY(rotY);
    scale(zoomF);
    
    drawFirstMap();

  }
  else //(not recording)
  {
    
    context1.setPlaybackSpeedPlayer(1.0);
    context1.update();
    
    context.setPlaybackSpeedPlayer(1.0);//theSpeed is controlled by UP and DOWN in the program
    context.update();
    
    cam.update();
    if (cam.getUsers()!=null)
    {
      if(cam.isTrackingSkeleton(1))
      {
        println("is tracking user 0");
        PVector jointPos = new PVector();
        cam.getJointPositionSkeleton(1,SimpleOpenNI.SKEL_HEAD,jointPos);
        println("head x is:"+jointPos.x);
        println("head y is:"+jointPos.y);
        camera(-jointPos.x/2.0,0,0,0,0,-4000,0,1,0);
        stroke(255);
        strokeWeight(10);
        noFill();
        box(300);
      }
    }
    
    background(0);
    
    /*
    if (xEye>500)
    xEyePlus=-5;
    else if (xEye<-500)
    xEyePlus=5;
    xEye+=xEyePlus;
    //camera(xEye,0,100,0,0,-2000,0,1,0);
    println("the Eye x-position is" + xEye);
    */
    
    //translate(width/2, height/2, 0);
    rotateX(rotX);
    rotateY(rotY);
    //scale(zoomF);
    
      drawFirstMap();
       
    pushMatrix();
    translate(theX,theY,theZ);
    rotateY(PI);
    
      drawSecondMap();
    
    popMatrix();//end translate xyz and rotateY
    
  }
  
  // draw the kinect cam in the frame
  //strokeWeight(3);
  //context.drawCamFrustum();
}

//key board interface
void keyPressed()
{
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
  /*
  isPlaying=!isPlaying;
  context.playbackPlay(isPlaying);
  context1.playbackPlay(isPlaying);
  */
  
    context.seekPlayer(1011);
    context1.seekPlayer(649);
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



void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}


void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}
