void drawFirstMap()
{
  
    int index=0;
    
    
    PImage  rgbImage = context.rgbImage();
    int[]   depthMap = context.depthMap();

    int     steps   = 4;  // to speed up the drawing, draw every third point

    PVector realWorldPoint;//point cloud
    color   pixelColor;//the color of pixels
 
    /******* to draw the map********/
    strokeWeight((float)steps/2);//the weight of the points pixels
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

void drawSecondMap()
{
  
    int index=0;
    
    
    PImage  rgbImage = context1.rgbImage();
    int[]   depthMap = context1.depthMap();

    int     steps   = 4;  // to speed up the drawing, draw every third point

    PVector realWorldPoint;//point cloud
    color   pixelColor;//the color of pixels
 
    /******* to draw the map********/
    strokeWeight((float)steps/2);//the weight of the points pixels
    PVector[] realWorldMap = context1.depthMapRealWorld();
    /******draw the point map*******/
    beginShape(POINTS);
    for(int y=0;y < context1.depthHeight();y+=steps)
    {
      for(int x=0;x < context1.depthWidth();x+=steps)
      {
        index = x + y * context1.depthWidth();
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
