
void writeFiles()
{

}


void readFiles()
{
  // Open the file from the createWriter() example
  readerA = createReader("veronikaA.txt"); 
  readerB = createReader("veronikaB.txt");
  playerA=new IntList();
  playerB=new IntList();
  do
  {
    try {
      lineA = readerA.readLine();
    } 
    catch (IOException e) 
    {
      e.printStackTrace();
      lineA = null;
    }
  if (lineA == null) 
    {
    // Stop reading because of an error or file is empty
      break;
    } 
  else 
  {
    String pieces = lineA;
    int theNum=int(pieces);
    playerA.append(theNum);
    //println(theNum);
  }
  }while(lineA!=null);
  
  println("veronikaA is:"+playerA.size()+"  "+playerA.get(playerA.size()-2));
  
    do
  {
    try {
      lineB = readerB.readLine();
    } 
    catch (IOException e) 
    {
      e.printStackTrace();
      lineB = null;
    }
  if (lineB == null) 
    {
    // Stop reading because of an error or file is empty
      break;
    } 
  else 
  {
    String pieces = lineB;
    int theNum=int(pieces);
    playerB.append(theNum);
    //println(theNum);
  }
  }while(lineB!=null);
  println("veronikaB is:"+playerB.get(playerB.size()-2));
  
  theTimeDiff=playerA.get(692)-playerB.get(399);
  println("the Time difference is: "+theTimeDiff);
} 
