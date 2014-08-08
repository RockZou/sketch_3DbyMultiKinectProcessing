import peasy.*;

PeasyCam peasyCam;


void initPeasyCam()
{
  peasyCam = new PeasyCam(this,0,0,3000,4000);
  peasyCam.setMinimumDistance(5);
  peasyCam.setMaximumDistance(5000);
}
