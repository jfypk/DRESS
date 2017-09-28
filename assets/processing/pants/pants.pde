import guru.ttslib.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.effects.*;
import java.io.*;
import java.util.*;
Minim minim;
AudioPlayer sound;

TTS tts = new TTS();
PrintWriter cw, cw1, cw2;
FileWriter fw, fw1;
BufferedReader mode;
BufferedWriter bw;
import TUIO.*;
TuioProcessing tuioClient;

String txt;
String[] sts ;
int t0=0, t1=0, t2=0, t3=0, p6=0, count=0, count1=0, counter=0, speak=0, p7=0, p8=0;
int complete = 0, cond = 999;
int[] numbers;
int mindiff=0, minone=0, mintwo=0, secone=0, sectwo=0, done = 0, lastVal=999;
boolean rLeg = false, lLeg = false, rleg = false, lleg = false, isSitting=false;
String state, lastMsg="", name1, name2;
ArrayList<TuioObject> tuioObjectList;

void setup()
{ 
  loop();
  frameRate(120);
  minim = new Minim(this);
  tuioClient  = new TuioProcessing(this);
  cw = createWriter("/Users/GALLAG/Gallag/DRESS/processing/pants/pants.txt");
  String fileName = "P4_B2_";
  String condition = "P-B_";
  String dateTime = month() + "-" + day() + "-" + year() + "_" + hour() + "-" + minute() + ".txt";
  name1 = "/Users/GALLAG/Gallag/DRESS/processing/pants/logs/" + fileName + condition + dateTime;
  fileName = fileName + condition + dateTime;
  name2 = "/Users/GALLAG/Gallag/DRESS/processing/pants/logs/" + fileName;
  cw2 = createWriter(name2);
  cw2.close();
 
  cw1 = createWriter(name1);
  cw1.close();
  
  try{
    fw1 = new FileWriter(name2, true);
    bw = new BufferedWriter(fw1);
    bw.write("Pants part initiated");
    bw.newLine();
    bw.close();
    fw1 = new FileWriter(name1, true);
    bw = new BufferedWriter(fw1);
    bw.write("ID\tXpos\tYpos\tVisible\tDate\tTime");
    bw.newLine();
    bw.close();
  }catch(IOException ie)
  {  
    println("IO exception");
  }
}

void draw()
{  
  background(255);
  tuioObjectList = tuioClient.getTuioObjectList();
  //loop to make sure the user sat on the chair
  String chair = "TT";//ReadFile("Y:/Gallag/Processing/ForExperiment/pants/chair.txt");
  if (chair.equals("FF"))
    isSitting = false;
  else
    isSitting = true;

  //checkMarker();
  if(isSitting)
  {
    numbers = initialize();
    done = checkPants();
  }
  
  if (done == 1)
  {
    tts.speak("Good Job");
    try{
              fw1 = new FileWriter(name2, true);
              bw = new BufferedWriter(fw1);
              bw.write("Pants part Completed");
              bw.newLine();
              bw.write("***********************************");
              bw.newLine();
              bw.close();  
              }
          catch(IOException ie)
          {  
            println("IO exception");
          }
    cw.flush();
    cw.print("TT");
    cw.close();
    exit();
  }
  
}// VOID DRAW ENDS HERE

//Function to check if a marker is detected
void checkMarker()
{
  complete = 0;
  boolean said = false, detected=false;
  //isSitting=false;
  int startTime = millis();

  //Loop to run until some marker is detected
  while (tuioObjectList.size ()==0)
  {          
    tuioObjectList = tuioClient.getTuioObjectList();
  }
  println("out of loop");
}

//CODE TO CHECK IF PANTS IS WORN PROPERLY 
int checkPants()
{   
  println("Inside checkpants");
  boolean secondleg = false, t1 =false, t2=false, t3=false, t4=false;
  boolean oneLeg = false, seen = false, lleg=false,rleg=false;  
  boolean said = false;
  boolean detected=false, test=false;
  int finish = 0, markers=0;
  int startTime1 = millis();
  String msg="";

  while (!detected) {
    tuioObjectList = tuioClient.getTuioObjectList();
    numbers = initialize();
    //tracks markers and writes them to a log file
    trackMarkers();
    
      for (int k=0;k<tuioObjectList.size();k++) 
      {     
        println("Count val:" + count1);
        complete = 0;
            
        if (numbers[k]==25 || numbers[k]==26)
        {
            if((!seen && (count1<2)) || (!rleg))
            {
              seen = true;
              rleg=true;
              count1++;
              try{
                fw1 = new FileWriter(name2, true);
                bw = new BufferedWriter(fw1);
                bw.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Right leg of the pants is worn");
                bw.newLine();
                bw.close();  
              }
              catch(IOException ie)
              {  
                println("IO exception");
              }
            }
        }
        
        if (numbers[k]==28 || numbers[k]==29)
        {
            if((!seen && (count1<2)) || (!lleg))
            {
              seen = true;
              lleg=true;
              count1++;
              try{
                fw1 = new FileWriter(name2, true);
                bw = new BufferedWriter(fw1);
                bw.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Left leg of the pants is worn");
                bw.newLine();
                bw.close();  
              }
              catch(IOException ie)
              {  
                println("IO exception");
              }
            }
        }

        if (numbers[k]==22)
        {
          tts.speak("pants is in reverse direction");
          try{
              fw1 = new FileWriter(name2, true);
              bw = new BufferedWriter(fw1);
              bw.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Pants is in reverse direction (back side front)");
              bw.newLine();
              bw.close();  
              }
          catch(IOException ie)
          {  
            println("IO exception");
          }
          break;
        }

        if (numbers[k]==17)
        {
           tts.speak("pants is inside out");
           try{
              fw1 = new FileWriter(name2, true);
              bw = new BufferedWriter(fw1);
              bw.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Pants is inside out");
              bw.newLine();
              bw.close();  
              }
          catch(IOException ie)
          {  
            println("IO exception");
          }
          break;
        }

        if (numbers[k]==19)
        {
          tts.speak("pants is inside out and in the reverse direction");
          try{
              fw1 = new FileWriter(name2, true);
              fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Pants is inside out and in reverse direction (back side front)\r\n");
              fw1.close();  
              }
          catch(IOException ie)
          {  
            println("IO exception");
          }
          break;
        }
        println("markers seen:" + markers);
        if((count1==2) && (markers<5))
        {
          //tts.speak("Pants is worn correctly");
          if(markers==4)
          {
            println("inside pants worn");
            tts.speak("pants worn correctly");
            try{
              fw1 = new FileWriter(name2, true);
              bw = new BufferedWriter(fw1);
              bw.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Pants is worn correctly");
              bw.newLine();
              bw.close();  
              }
            catch(IOException ie)
            {  
              println("IO exception");
            }
            detected= true;
            break;
          }
          
          if(finish==0)
          {
              delay(2000);
              finish = 1;
              break;
          }
          
          if(numbers[k]==24)
          {
            markers++;
            continue;
          }
            
          if(numbers[k]==27)
          {
            markers++;
            continue;
          }
          if(numbers[k]==15)
          {
            markers++;
            continue;
          }
          if(numbers[k]==16)
          {
            markers++;
            continue;
          }
          
        }
      }//FOR LOOP ENDS HERE
      delay(1000);
    }//while loop ends
  return finish;
}
    
//Function to write markers visible to a file
void trackMarkers()
  {
    
   // while(true)
   //{ 
     tuioObjectList = tuioClient.getTuioObjectList();
     numbers = initialize();
     try{ //tracking marker data to file
         fw = new FileWriter(name1, true);
     for (int k=0;k<tuioObjectList.size();k++) 
     {
         TuioObject tobj = tuioObjectList.get(k);
         if(numbers[k] == 15)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" + "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         }
         else
             fw.write(15 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +   "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
                
         if(numbers[k] == 16)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         }
         else
             fw.write(16 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +   "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
                
         if(numbers[k] == 17)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         }
         else
             fw.write(17 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +   "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
                
         if(numbers[k] == 24)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         }
         else
             fw.write(24 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
        
        if(numbers[k] == 19)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         }
         else
             fw.write(19 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
                
        if(numbers[k] == 25)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         }
         else
             fw.write(25 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
                
        if(numbers[k] == 22)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         }
         else
             fw.write(22 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
        
        if(numbers[k] == 26)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         }
         else
             fw.write(26 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         
         if(numbers[k] == 27)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         }
         else
             fw.write(27 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         
         if(numbers[k] == 28)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         }
         else
             fw.write(28 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
                
         if(numbers[k] == 29)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
         }
         else
             fw.write(29 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
        
        //delay(1000);
     }
      fw.write(15 + "\t" + 0 + "\t" + 0 + "\t" + "NO" + "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
      fw.write(16 + "\t" + 0 + "\t" + 0 + "\t" + "NO" + "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
      fw.write(17 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
      fw.write(24 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
      fw.write(19 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
      fw.write(25 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");          
      fw.write(22 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
      fw.write(26 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
      fw.write(27 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
      fw.write(28 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");
      fw.write(29 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\r\n");          
      

      delay(1000);
     fw.close();
   
   }catch(IOException ie)
      {  
         println("IO exception in fw");
      }
 // }
}  

//Given a file, read its contents
String ReadFile(String file)
{
  BufferedReader readertwo;
  String txt;  
  try {
    readertwo = createReader(file);
    txt = readertwo.readLine();
    readertwo.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
    txt = null;
  }

  return txt;
}

//read a string and return the value and calculate time
String checkTime(String txt)
{
  String res = "";
  int val=0;

  if (txt != null) {
    // There is something written in the file
    String[] str = splitTokens(txt);
    int L=0;
    L=int(str[1]);
    minone= minute();  // processing time in minValues from 0 - 59
    secone= second();  // processing time sec
    mintwo=L/100;      // double digit txt min
    sectwo=L%100;      // double digit txt seconds

    if (mintwo==0) {
      mintwo=L/10; 
      sectwo=L%10;// txt file min
    }
    mindiff=minone-mintwo;

    if (mindiff == 1) //case where difference between leg lifted(min) and ID detected(min) is 1
        cond = (60-sectwo) + secone;

    if (mindiff == 0)  //case where difference between leg lifted(min) and ID detected(min) is 0
        cond = secone-sectwo;

    val = cond;
    if (val!=lastVal)
    {
      println("Condition:" + cond); 
      lastVal = val;
    }

    res = str[0];
  }  
  return res;
}

//re-examine objects and assign
int[] initialize()
{
  tuioObjectList = tuioClient.getTuioObjectList(); 
  int[] numbers = new int[tuioObjectList.size()];

  for (int i=0;i<tuioObjectList.size();i++)
  {
    TuioObject tobj = tuioObjectList.get(i);
    numbers[i]=tobj.getSymbolID();
  }
  return numbers;
}

