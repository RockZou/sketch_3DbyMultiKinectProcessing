BufferedReader readerA;
BufferedReader readerB;
String lineA,lineB;
IntList veronikaA;
IntList veronikaB;

int indexA;
int lenA;

int indexB;
int lenB;

int theTimeDiff;

void readFiles()
{
  // Open the file from the createWriter() example
  readerA = createReader("veronikaA.txt"); 
  readerB = createReader("veronikaB.txt");
  veronikaA=new IntList();
  veronikaB=new IntList();
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
    veronikaA.append(theNum);
    //println(theNum);
  }
  }while(lineA!=null);
  
  println("veronikaA is:"+veronikaA.size()+"  "+veronikaA.get(veronikaA.size()-2));
  
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
    veronikaB.append(theNum);
    //println(theNum);
  }
  }while(lineB!=null);
  println("veronikaB is:"+veronikaB.get(veronikaB.size()-2));
  
  theTimeDiff=veronikaA.get(692)-veronikaB.get(399);
} 
