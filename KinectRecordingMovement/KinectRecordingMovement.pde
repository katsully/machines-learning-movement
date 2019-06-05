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
  table.addColumn("Label");
  for (int i=1; i<=25; i++) {
    table.addColumn("Feature " + i);
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
  // To keep everything relative and disregard differences in size amoung users, make all position information in relation to the base of the spine
  // normalize data 
  PVector spineBase = joints[KinectPV2.JointType_SpineBase].getPosition();
  PVector normHead = joints[KinectPV2.JointType_Head].getPosition().sub(spineBase);
  PVector normSpineMid = joints[KinectPV2.JointType_SpineMid].getPosition().sub(spineBase);
  PVector normHipLeft = joints[KinectPV2.JointType_HipLeft].getPosition().sub(spineBase);
  PVector normHipRight = joints[KinectPV2.JointType_HipRight].getPosition().sub(spineBase);
  PVector normSpineShoulder = joints[KinectPV2.JointType_SpineShoulder].getPosition().sub(spineBase);
  PVector normWristLeft = joints[KinectPV2.JointType_WristLeft].getPosition().sub(spineBase);
  PVector normWristRight = joints[KinectPV2.JointType_WristRight].getPosition().sub(spineBase);
  PVector normElbowLeft = joints[KinectPV2.JointType_ElbowLeft].getPosition().sub(spineBase);
  PVector normElbowRight = joints[KinectPV2.JointType_ElbowRight].getPosition().sub(spineBase);
  PVector normShoulderLeft = joints[KinectPV2.JointType_ShoulderLeft].getPosition().sub(spineBase);
  PVector normShoulderRight = joints[KinectPV2.JointType_ShoulderRight].getPosition().sub(spineBase);
  PVector normKneeLeft = joints[KinectPV2.JointType_KneeLeft].getPosition().sub(spineBase);
  PVector normKneeRight = joints[KinectPV2.JointType_KneeRight].getPosition().sub(spineBase);
  PVector normAnkleLeft = joints[KinectPV2.JointType_AnkleLeft].getPosition().sub(spineBase);
  PVector normAnkleRight = joints[KinectPV2.JointType_AnkleRight].getPosition().sub(spineBase);

  //// vertex1 = (head + shoulderCenter) / 2
  //vertex1.set(joints[KinectPV2.JointType_Head].getPosition().add(joints[KinectPV2.JointType_SpineShoulder].getPosition()).div(2));
  //// vertex2 = (shoulderRight + elbowRight + wristRight + handRight) / 4
  //vertex2.set(joints[KinectPV2.JointType_ShoulderRight].getPosition().add(joints[KinectPV2.JointType_ElbowRight].getPosition()).add(joints[KinectPV2.JointType_WristRight].getPosition()).add(joints[KinectPV2.JointType_HandRight].getPosition()).div(4));
  //// vertex3 = (shoulderLeft + elbowLeft + wristLeft + handLeft) / 4
  //vertex3.set(joints[KinectPV2.JointType_ShoulderLeft].getPosition().add(joints[KinectPV2.JointType_ElbowLeft].getPosition()).add(joints[KinectPV2.JointType_WristLeft].getPosition()).add(joints[KinectPV2.JointType_HandLeft].getPosition()).div(4));
  //// vertex4 = (hipRight + kneeRight + ankleRight + footRight) / 4
  //vertex4.set(joints[KinectPV2.JointType_HipRight].getPosition().add(joints[KinectPV2.JointType_KneeRight].getPosition()).add(joints[KinectPV2.JointType_AnkleRight].getPosition()).add(joints[KinectPV2.JointType_FootRight].getPosition()).div(4));
  //// vertex5 = (hipLeft + kneeLeft + ankleLeft + footLeft) / 4
  //vertex5.set(joints[KinectPV2.JointType_HipLeft].getPosition().add(joints[KinectPV2.JointType_KneeLeft].getPosition()).add(joints[KinectPV2.JointType_AnkleLeft].getPosition()).add(joints[KinectPV2.JointType_FootLeft].getPosition()).div(4));
  TableRow newRow = table.addRow();
  
  // What is the label?
  newRow.setString("Label", "Pose " + poseNum);
  
  // Feature 1: dist between spine base and head
  newRow.setFloat("Feature 1", normHead.dist(spineBase));
  
  // Feature 2-4: avg pos between spineMid, hipLeft, and hipRight
  PVector hipAvg = (normSpineMid.add(normHipLeft).add(normHipRight)).div(3);
  newRow.setFloat("Feature 2", hipAvg.x);
  newRow.setFloat("Feature 3", hipAvg.y);
  newRow.setFloat("Feature 4", hipAvg.z);
  
  // Feature 5-13:  position of the torso joints
  newRow.setFloat("Feature 5", normSpineShoulder.x);
  newRow.setFloat("Feature 6", normSpineShoulder.y);
  newRow.setFloat("Feature 7", normSpineShoulder.z);
  newRow.setFloat("Feature 8", normSpineMid.x);
  newRow.setFloat("Feature 9", normSpineMid.y);
  newRow.setFloat("Feature 10", normSpineMid.z);
  newRow.setFloat("Feature 11", spineBase.x);
  newRow.setFloat("Feature 12", spineBase.y);
  newRow.setFloat("Feature 13", spineBase.z);
  
  // Feature 14-25: avg between wrist, elbow, and shoulder (left and right) and hip, knee, and ankle (left and right)
  PVector leftArmAvg = (normWristLeft.add(normElbowLeft).add(normShoulderLeft)).div(3);
  newRow.setFloat("Feature 14", leftArmAvg.x);
  newRow.setFloat("Feature 15", leftArmAvg.y);
  newRow.setFloat("Feature 16", leftArmAvg.z);
  PVector rightArmAvg = (normWristRight.add(normElbowRight).add(normShoulderRight)).div(3);
  newRow.setFloat("Feature 17", rightArmAvg.x);
  newRow.setFloat("Feature 18", rightArmAvg.y);
  newRow.setFloat("Feature 19", rightArmAvg.z);
  PVector leftLegAvg = (normHipLeft.add(normKneeLeft).add(normAnkleLeft)).div(3);
  newRow.setFloat("Feature 20", leftLegAvg.x);
  newRow.setFloat("Feature 21", leftLegAvg.y);
  newRow.setFloat("Feature 22", leftLegAvg.z);
  PVector rightLegAvg = (normHipRight.add(normKneeRight).add(normAnkleRight)).div(3);
  newRow.setFloat("Feature 23", rightLegAvg.x);
  newRow.setFloat("Feature 24", rightLegAvg.y);
  newRow.setFloat("Feature 25", rightLegAvg.z);
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
   // TableRow newRow = table.addRow(); 
   // newRow.setString("SpineBase_x", "NEW RECORDING"); 
  } else if(key == '1') {
    poseNum = 1;
   // TableRow newRow = table.addRow();
   // newRow.setString("SpineBase_x", "POSE 1");
  } else if(key == '2') {
    poseNum = 2;
   // TableRow newRow = table.addRow();
   // newRow.setString("SpineBase_x", "POSE 2");
  } else if(key == '3') {
    poseNum = 3;
   // TableRow newRow = table.addRow();
   // newRow.setString("SpineBase_x", "POSE 3");
  }
}
