SimpleOpenNI cam;

void initHeadTrack()
{
  cam=new SimpleOpenNI(this);
  
  // enable depthMap generation 
  cam.enableDepth();
   
  // enable skeleton generation for all joints
  cam.enableUser();
  
  smooth();
  camera(0,0,0,0,0,4000,0,1,0);
}

void headTrack()
{
    cam.update();
    
    
    
    
    int[] userList = cam.getUsers();
    for(int i=0;i<userList.length;i++)
    {
      println("the i is:"+i);
      if(cam.isTrackingSkeleton(userList[i]))
      {
        println("isTracking user "+i);
        PVector jointPos = new PVector();
        cam.getJointPositionSkeleton(userList[i],SimpleOpenNI.SKEL_HEAD,jointPos);
        println("head x is:"+jointPos.x);
        println("head y is:"+jointPos.y);
        camera(-jointPos.x/1.2,jointPos.y-500,1000-jointPos.z,0,0,4000,0,-1,0);
      }
    }
    
    
}
