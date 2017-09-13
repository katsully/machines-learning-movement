/*
Kat Sullivan
 Brooklyn Research 2017
 github.com/katsully
 */

import KinectPV2.KJoint;
import KinectPV2.*;
import java.util.Date;

KinectPV2 kinect;

// where we will store the data
Table table;

// a list of all points in the body that the Kinect tracks
String[] bones = { "SpineBase", "SpineMid", "Neck", "Head", "ShoulderLeft", "ElbowLeft", "WristLeft", "HandLeft", 
  "ShoulderRight", "ElbowRight", "WristRight", "HandRight", "HipLeft", "KneeLeft", "AnkleLeft", "FootLeft", "HipRight", "KneeRight", 
  "AnkleRight", "FootRight", "SpineShoulder", "HandTipLeft", "ThumbLeft", "HandTipRight", "ThumbRight" };

// this will be used to let us know when we are recording
boolean recording = false;

// this will be used to let us know when we have saved the file
boolean saved = false;

Integer poseNum;

// we'll use this to timestamp our spreadsheet
Date date = new Date();

int depth = 600;
float zVal = 1;
float rotX = PI;

void setup() {
  size(1024, 768, P3D);

  table = new Table();

  for (String s : bones) {
    table.addColumn(s+"_x");
    table.addColumn(s+"_y");
    table.addColumn(s+"_z");
    table.addColumn(s+"_Orientation_w");
    table.addColumn(s+"_Orientation_x");
    table.addColumn(s+"_Orientation_y");
    table.addColumn(s+"_Orientation_z");
  }

  kinect = new KinectPV2(this);

  kinect.enableColorImg(true);

  //enable 3d  with (x,y,z) position
  kinect.enableSkeleton3DMap(true);

  kinect.init();
}

void draw() {
  background(0);

  image(kinect.getColorImage(), width-320, 0, 320, 240);

  //translate the scene to the center 
  pushMatrix();
  translate(width/2, height/2, depth);
  scale(zVal);
  rotateX(rotX);

  ArrayList skeletonArray =  kinect.getSkeleton3d();

  // if one or more body is tracked, loop through each body
  // NOTE - this code is meant to only track one body, modifications will be needed for multi-person recording
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      //draw different color for each hand state
      //  drawHandState(joints[KinectPV2.JointType_HandRight]);
      //drawHandState(joints[KinectPV2.JointType_HandLeft]);

      //Draw body
      color col  = color(255, 105, 180);
      stroke(col);
      drawBody(joints);
      // if we are recording send data to our data table
      if (recording) {
        recordData(joints);
      }
    }
  }
  popMatrix();

  // gives the text a red color
  fill(255, 0, 0);
  textSize(40);
  // extremely basic interface to let the user know when they're recording
  // when the file is saved, etc
  if(saved) {
    text("FILE SAVED", 50, 100);
  }
  if(recording) {
    text("RECORDING",50, 50);
  }
  if(poseNum != null) {
    text("POSE NUMBER: " + poseNum, 50, 150);
  }
}

// this is where Processing draws the skeleton
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);

  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm    
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

void drawJoint(KJoint[] joints, int jointType) {
  strokeWeight(2.0f + joints[jointType].getZ()*4);
  point(joints[jointType].getX()*40, joints[jointType].getY()*40, joints[jointType].getZ()*40);
}

void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  strokeWeight(1);
  line(joints[jointType1].getX()*40, joints[jointType1].getY()*40, joints[jointType1].getZ()*40, joints[jointType2].getX()*40, joints[jointType2].getY()*40, joints[jointType2].getZ()*40);
  strokeWeight(2.0f + joints[jointType2].getZ()*4);
  point(joints[jointType2].getX()*40, joints[jointType2].getY()*40, joints[jointType2].getZ()*40);
}

void drawHandState(KJoint joint) {
  handState(joint.getState());
  strokeWeight(5.0f + joint.getZ()*20);
  point(joint.getX()*40, joint.getY()*40, joint.getZ()*40);
}

void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    stroke(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    stroke(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    stroke(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    stroke(100, 100, 100);
    break;
  }
}

// sending each value for each joint to our data table
void recordData(KJoint[] joints){
  TableRow newRow = table.addRow();
  for(int i=0; i<joints.length-1; i++){
    newRow.setFloat(bones[i] + "_x", joints[i].getX());
    newRow.setFloat(bones[i] + "_y", joints[i].getY());
    newRow.setFloat(bones[i] + "_z", joints[i].getZ());
    newRow.setFloat(bones[i] + "_Orientation_w", joints[i].getOrientation().getW());
    newRow.setFloat(bones[i] + "_Orientation_x", joints[i].getOrientation().getX());
    newRow.setFloat(bones[i] + "_Orientation_y", joints[i].getOrientation().getY());
    newRow.setFloat(bones[i] + "_Orientation_z", joints[i].getOrientation().getZ());
  }
}

// this let's us interact with the program and tell it when we want to record, 
// which pose we want to record, and when to save the file
void keyPressed(){
  if(key == 's') {
    // save the table and give it a timestamp
    saveTable(table, "data/test" + date.getTime() +".csv");
    saved = true;
  } else if(key == 'r') {
    recording = !recording;
    TableRow newRow = table.addRow(); 
    newRow.setString("SpineBase_x", "NEW RECORDING"); 
  } else if(key == '1') {
    poseNum = 1;
    TableRow newRow = table.addRow();
    newRow.setString("SpineBase_x", "POSE 1");
  } else if(key == '2') {
    poseNum = 2;
    TableRow newRow = table.addRow();
    newRow.setString("SpineBase_x", "POSE 2");
  } else if(key == '3') {
    poseNum = 3;
    TableRow newRow = table.addRow();
    newRow.setString("SpineBase_x", "POSE 3");
  }
}