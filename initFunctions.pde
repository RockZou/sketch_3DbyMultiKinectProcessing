void initRecording()
{  
    frameRate(15);
    context= new SimpleOpenNI(this);
    context.enableRecorder(recordPath);
    initKinect(context);
    
    context.addNodeToRecording(SimpleOpenNI.NODE_DEPTH,true);//to store data from the camera stream to the recorder
    context.addNodeToRecording(SimpleOpenNI.NODE_IMAGE,true); 
    
}

void initPlayback()
{
    frameRate(15);
    context = new SimpleOpenNI(this,videoPath);
    context1 = new SimpleOpenNI(this,videoPath1);//second video stream to be merged with context video stream
    initKinect(context);
    initKinect(context1);
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

  theContext.alternativeViewPointDepthToImage();
  theContext.setDepthColorSyncEnabled(true); 
}
