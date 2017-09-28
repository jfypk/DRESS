import guru.ttslib.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.effects.*;
import java.util.*;
import java.io.*;

Minim minim;
AudioPlayer sound;
TTS tts = new TTS();
;
PrintWriter cw, cw1, cw2;
FileWriter fw, fw1;
import TUIO.*;
TuioProcessing tuioClient;
int s1=0, s5=0, s22=0, s23=0, btwo=0, a=0, b=0;
int countvalue=0, complete=0;
Vector tuioObjectList;
boolean oneSide = false;
boolean bothComplete = false, detected=false;
String state, lastMsg="", name1, name2;
int[] numbers;

void setup()
{
  minim = new Minim(this);
  cw = createWriter("shirt.txt");
  String fileName = "P4_B2_";
  String condition = "SH_I_";
  String dateTime = month() + "-" + day() + "-" + year() + "_" + hour()+"-"+minute() + ".txt";
  name1 = "/Users/GALLAG/Gallag/Processing/ForExperiment/shirt/logs/fiducialsLog/" + fileName + condition + dateTime;
  cw = createWriter(name1);
  cw.close();
  fileName = fileName + condition + dateTime;
  name2 = "/Users/GALLAG/Gallag/Processing/ForExperiment/shirt/logs/testData/" + fileName;
  cw2 = createWriter(name2);
  cw2.close();
  loop();
  frameRate(120);
  tuioClient  = new TuioProcessing(this, 3333);
  try{
    fw1 = new FileWriter(name2, true);
    fw1.close();
    fw = new FileWriter(name1, true);
    fw.write("ID  Xpos    Ypos    Visible  Date      Time\n");
    fw.close();
  }catch(IOException ie)
  {  
    println("IO exception");
  }
  //exit();
}
void draw()
{  
  background(255);
  boolean detected=false;
  tuioObjectList = tuioClient.getTuioObjects();

  //Check independent or dependent status
  state = ReadFile("mode.txt");
  if (state == null) {
    // Stop reading because of an error or file is empty
    noLoop();
  } 
  else {
    String[] sts = splitTokens(state);
    state=sts[0];
    println(state);
  }  ////Check independent or dependent status ends  

  checkMarker();
  numbers = initialize();
  checkFrontSide();
  alignShirt();
  pushButtons();
  cw.flush();
  cw.print("TT");
  cw.close();
  
  //fw.close();
  exit();
}
  //Function to check if some ID is detected
  void checkMarker()
  {
      //code to run until some Marker is detected
      while (tuioObjectList.size ()==0)
      {
        tuioObjectList = tuioClient.getTuioObjects();
      }
  }
  
  //Function to check if front side is detected n first part is worn properly
  void checkFrontSide()
  {
      boolean front=false, right=false, wrong=false, said=true, said1=true, check=false;
      detected=false;
      complete=0;
      String msg="";
      int startTime = millis();
      println("seen markers");
      while(!detected)
      {         
         trackMarkers(); 
          for (int k=0;k<tuioObjectList.size();k++) 
          { 
            /*
            try{ //tracking marker data to file
                fw = new FileWriter(name1, true);
                TuioObject tobj = (TuioObject)tuioObjectList.elementAt(k);
                
                fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" + tobj.getScreenX(width) + "\t"
                + tobj.getScreenY(height) + "\t" + tobj.getAngleDegrees()+"\t"+tobj.getMotionSpeed()+"\t\t"+
                tobj.getRotationSpeed()+"\t\t"+tobj.getMotionAccel() + "\t\t" + tobj.getRotationAccel() + "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
        
                fw.close();
              }catch(IOException ie)
              {  
                println("IO exception in fw");
              }
              */
            if (numbers[k]==7)
            {
                right=true;
                wrong=false;
                println("back side");
                msg="back side";
                if (!msg.equals(lastMsg))
                {
                  try{
                    fw1 = new FileWriter(name2, true);
                    fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Back side ID of the shirt detected\n");
                    fw1.close();
                  }catch(IOException ie)
                  {  
                    println("IO exception in fw1");
                  }
                  lastMsg = msg;
                }
                if(millis()-startTime > 3000)
                {
                  //println("inside check set");
                  delay(2000);
                  check=true;
                  startTime = millis();
                  //break;
                }
                if(check)
                { //println("inside check");
                  //if(said1)
                    //tts.speak("you have worn the shirt in the reverse direction");
                  said1= false;
                  msg="worn reverse";
                  if (!msg.equals(lastMsg))
                  {
                    try{
                      fw1 = new FileWriter(name2, true);
                      fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Back side of the shirt is in front side\n");
                      fw1.close();
                      }catch(IOException ie)
                      {  
                        println("IO exception in fw1");
                      }
                    lastMsg = msg;
                  }
                }
            }
            
            else if (numbers[k]==8)
            {
                //tts.speak("turn the shirt around");
                wrong=true; 
                startTime = millis();
                msg="inside center";
                println("inside center found");
                if (!msg.equals(lastMsg))
                {
                  try{
                    fw1 = new FileWriter(name2, true);
                      fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Inside part of the shirt detected\n");
                      fw1.close();
                    }catch(IOException ie)
                    {  
                      println("IO exception in fw1");
                    }
                  //once = true;
                  lastMsg = msg;
                }  
            }
                
            else if (numbers[k]==209 || numbers[k]==208 || numbers[k]==211 || numbers[k]==212 || numbers[k]==30 || numbers[k]==10 || numbers[k]==5|| numbers[k]==6)// && (!wrong))
            {
              detected=true;
              println("detected front IDS");
              msg = "front side";
              if (!msg.equals(lastMsg))
              {
                try{
                  fw1 = new FileWriter(name2, true);
                    fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "front side IDs of the shirt detected\n");
                    fw1.close();
                    }catch(IOException ie)
                    {    
                      println("IO exception in fw1");
                    }
                lastMsg = msg;
              }
              break;
            }
            
            else if(numbers[k]==9)
            {
              wrong=true; 
              startTime = millis();
              msg="inside out";
              println("inside out");
              //if(said)
              //tts.speak("Shirt is worn inside out");
              //said = false;
              if (!msg.equals(lastMsg))
              {
                try{
                  fw1 = new FileWriter(name2, true);
                    fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + 
                    "Shirt has been worn Inside out\n");
                    fw1.close();
                    }catch(IOException ie)
                    {  
                      println("IO exception in fw1");
                    }
                //once = true;
                lastMsg = msg;
              } 
            }
            else
            {
              println("No ids or diff ids");
              break;
            }
          }
          //println("detected val:"+detected);
          /*
          if (wrong && (!detected))
          {
            
            if(said)
              tts.speak("You are holding the Shirt in the wrong side. Turn it around");
            said = false;
            //println("inside 22");
            if(millis()-startTime > 10000)
            {
              tts.speak("You are holding the Shirt in the wrong side. Turn it around");
              startTime = millis();
              //println("New ST:" + startTime);
            }
          }*/
          numbers=initialize();
      }
      //exit();
  }
  
  //Function to align the shirt
  void alignShirt()
  {
      boolean left=false, right=false;
      detected = false;
      complete=0;
      String msg="";
      boolean said =true;
      int startTime = millis();
      println("inside align shirt");
      while(!detected)
      {  
        trackMarkers();
        if (tuioObjectList.size()==0 && (left || right))
        {
          msg="incomplete dressing";
          if (!msg.equals(lastMsg))
          {
            try{
              fw1 = new FileWriter(name2, true);
                fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Incomplete dressing\n");
                fw1.close();
                }catch(IOException ie)
                {  
                  println("IO exception");
                }
            lastMsg = msg;
          }
          /*if(said && (millis()-startTime > 1000))//was 10secs
          {
              tts.speak("Please complete dressing, you did not push your arms on both sides of the shirt");
              startTime = millis();
          }*/
           said = false;
           //startTime = millis();
          if(millis()-startTime > 5000)// was 15secs
            {
              //tts.speak("Please complete dressing, you did not push your arms on both sides of the shirt");
              startTime = millis();
              //println("New ST:" + startTime);
            }
        }
        for (int k=0;k<tuioObjectList.size();k++) 
        {   
          /*
          try{ //tracking marker data to file
              fw = new FileWriter(name1, true);
              TuioObject tobj = (TuioObject)tuioObjectList.elementAt(k);
              
              fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" + tobj.getScreenX(width) + "\t"
              + tobj.getScreenY(height) + "\t" + tobj.getAngleDegrees()+"\t"+tobj.getMotionSpeed()+"\t\t"+
              tobj.getRotationSpeed()+"\t\t"+tobj.getMotionAccel() + "\t\t" + tobj.getRotationAccel() + "\t" + year()+
              "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      
              fw.close();
            }catch(IOException ie)
            {  
              println("IO exception");
            }
              */
          if(left && right)
          {
              detected = true;
              msg="both arms worn";
              if (!msg.equals(lastMsg))
              {
                try{
                  fw1 = new FileWriter(name2, true);
                    fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Both arms of the shirt worn\n");
                    fw1.close();
                    }catch(IOException ie)
                    {  
                      println("IO exception");
                    }
                //once = true;
                lastMsg = msg;
              }
              break;
          }
          if(numbers[k]==6 || numbers[k]==209 || numbers[k]==212)
          {
            left=true;
            msg="left arm worn";
            if (!msg.equals(lastMsg))
            {
              try{
                fw1 = new FileWriter(name2, true);
                  fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Left arm of the shirt is worn\n");
                  fw1.close();
                  }catch(IOException ie)
                  {  
                    println("IO exception");
                  }
              lastMsg = msg;
            }
          }
            
          if(numbers[k]==5 || numbers[k]==208 || numbers[k]==211)
          {
            right=true;  
            msg="right arm worn";
            if (!msg.equals(lastMsg))
            {
              try{
                fw1 = new FileWriter(name2, true);
                  fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Right arm of the shirt is worn\n");
                fw1.close();  
                }catch(IOException ie)
                  {  
                    println("IO exception");
                  }
              lastMsg = msg;
            }
          }
          
          if(numbers[k]==9)
          {
            //wrong=true; 
            startTime = millis();
            msg="inside out";
            println("inside out");
            if(said)
              //tts.speak("Shirt is worn inside out");
            said = false;
            if (!msg.equals(lastMsg))
            {
              try{
                fw1 = new FileWriter(name2, true);
                  fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + 
                  "Shirt has been worn Inside out\n");
                  fw1.close();
                  }catch(IOException ie)
                  {  
                    println("IO exception");
                  }
              //once = true;
              lastMsg = msg;
            } 
          }
            
        }
        
        numbers=initialize(); 
      }
  }
  
  void pushButtons()
  {
      detected=false;
      complete=0;
      int startTime1=millis();
      boolean said=false; 
      boolean said1=false;
      println("inside pushButtons");
      int cnt=0;
      float ax=0.0, ay=0.0, bx=0.0, by=0.0, cx=0.0, cy=0.0, dx=0.0, dy=0.0;
      String msg="";
    
      while (!detected)
      {
        trackMarkers();
        if (cnt==4)
        {
          for (int k=0;k<tuioObjectList.size();k++) 
          {  
            
            TuioObject tobj = (TuioObject)tuioObjectList.elementAt(k);
            /*try{ //tracking marker data to file
                fw = new FileWriter(name1, true);
                
                fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" + tobj.getScreenX(width) + "\t"
                + tobj.getScreenY(height) + "\t" + tobj.getAngleDegrees()+"\t"+tobj.getMotionSpeed()+"\t\t"+
                tobj.getRotationSpeed()+"\t\t"+tobj.getMotionAccel() + "\t\t" + tobj.getRotationAccel() + "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
        
                fw.close();
              }catch(IOException ie)
              {  
                println("IO exception");
              }
              */
            if (numbers[k]==208)
            {
              ay=tobj.getX();
              ax=tobj.getY();
              println("208: " + ax + " " + ay);
            }
            if (numbers[k]==209)
            {
              by=tobj.getX();
              bx=tobj.getY();
              println("209: " + bx + " " + by);
            }
            if (numbers[k]==211)
            {
              cy=tobj.getX();
              cx=tobj.getY();
              println("211: " + cx + " " + cy);
            }
            if (numbers[k]==212)
            {
              dy=tobj.getX();
              dx=tobj.getY();
              println("212: " + dx + " " + dy);
            }
          }
          if ((abs(ax-bx) < .05) && (abs(ay-by) < .18) && (abs(cx-dx) < .05) && (abs(cy-dy) < .18))
          {
            detected = true;
            msg="Shirt is complete";
            if (!msg.equals(lastMsg))
            {
              try{
                fw1 = new FileWriter(name2, true);
                  fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Wearing Shirt is complete\n");
                  fw1.close();
                  }catch(IOException ie)
                  {  
                    println("IO exception");
                  }
              lastMsg = msg;
            }
            //tts.speak("Good Job");
            break;
          }
          else
          {
            if ((!said1) && (millis()-startTime1>5000))
            {
              //tts.speak("two sides of the Shirt are uneven");
              //tts.speak("please align the velcro and attach the parts together");
              said1 =true;
              msg="velcro uneven";
              if (!msg.equals(lastMsg))
              {
                try{
                    fw1 = new FileWriter(name2, true);
                    fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Velcro Unevenly fastened\n");
                    fw1.close();  
                  }catch(IOException ie)
                    {  
                      println("IO exception");
                    }
                lastMsg = msg;
              }
            }
    
            if (millis()-startTime1>5000)//was 25secs
            {
              //tts.speak("two sides of the Shirt are uneven");
              //tts.speak("please align the velcro and attach the parts together");
              startTime1=millis();
            }
            //delay(10000);
          }
        }
        else {
          cnt=0;
          for (int k=0;k<tuioObjectList.size();k++) 
          {
            if (numbers[k]==208)
              cnt++;
    
            if (numbers[k]==209)
              cnt++;
    
            if (numbers[k]==211)
              cnt++;
    
            if (numbers[k]==212)
              cnt++;
              
            if(numbers[k]==9)
            {
              //wrong=true; 
              startTime1 = millis();
              msg="inside out";
              println("inside out");
              if(said)
                //tts.speak("Shirt is worn inside out");
              said = false;
              if (!msg.equals(lastMsg))
              {
                try{
                    fw1 = new FileWriter(name2, true);
                    fw1.write(year()+"-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second() + "\t" + "Shirt has been worn Inside out\n");
                    fw1.close();
                    }catch(IOException ie)
                    {  
                      println("IO exception");
                    }
                //once = true;
                lastMsg = msg;
              } 
            }
          }
        }
        numbers=initialize();
      }
  }
          
//Function to track markers and write it to a file
void trackMarkers()
{
    tuioObjectList = tuioClient.getTuioObjects();
     numbers = initialize();
     try{ //tracking marker data to file
         fw = new FileWriter(name1, true);
     for (int k=0;k<tuioObjectList.size();k++) 
     {
         TuioObject tobj = (TuioObject)tuioObjectList.elementAt(k);
         if(numbers[k] == 5)
         {
            fw.write(5 + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" + "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(5 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +   "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
         if(numbers[k] == 6)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(6 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +   "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
         if(numbers[k] == 7)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(7 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +   "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
         if(numbers[k] == 8)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(8 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
        
        if(numbers[k] == 9)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(9 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
        if(numbers[k] == 10)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(10 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
        if(numbers[k] == 11)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(11 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
        
        if(numbers[k] == 12)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(12 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
        if(numbers[k] == 13)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(13 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
        if(numbers[k] == 14)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(14 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
        if(numbers[k] == 30)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(30 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
        if(numbers[k] == 31)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(31 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
        if(numbers[k] == 32)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(32 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
        if(numbers[k] == 33)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(33 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
        if(numbers[k] == 34)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(34 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
        
        if(numbers[k] == 208)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(208 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
        
        if(numbers[k] == 209)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(209 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
        if(numbers[k] == 211)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(211 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
                
        if(numbers[k] == 212)
         {
            fw.write(tobj.getSymbolID() + "\t" + tobj.getX() + "\t" + tobj.getY() + "\t" +  "YES" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
         }
         else
             fw.write(212 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
        
        //delay(1000);
     }
      fw.write(5 + "\t" + 0 + "\t" + 0 + "\t" + "NO" + "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(6 + "\t" + 0 + "\t" + 0 + "\t" + "NO" + "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(7 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(8 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(9 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(10 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");          
      fw.write(11 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(12 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(13 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(14 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(30 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(31 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(32 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(33 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(34 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(208 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(209 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(211 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      fw.write(212 + "\t" + 0 + "\t" + 0 + "\t" + "NO" +  "\t" + year()+
                "-"+month()+"-"+day() + "\t" + hour()+":"+ minute()+":"+second()+"\n");
      delay(1000);
     fw.close();
   
   }
   catch(IOException ie)
   {  
      println("IO exception in fw");
   }
}

//Given a file, read its contents
String ReadFile(String file)
{
  BufferedReader readertwo;
  String txt;  
  try {
    readertwo = createReader(file);
    txt = readertwo.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    txt = null;
  }
  return txt;
}

//re-examine objects and assign
int[] initialize()
{
  tuioObjectList = tuioClient.getTuioObjects(); 
  int[] numbers = new int[tuioObjectList.size()];

  for (int i=0;i<tuioObjectList.size();i++)
  {
    TuioObject tobj = (TuioObject)tuioObjectList.elementAt(i);
    numbers[i]=tobj.getSymbolID();
  }
  return numbers;
}

