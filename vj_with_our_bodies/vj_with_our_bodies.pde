/*
Kat Sullivan
 Brooklyn Research 2017
 github.com/katsully
 */

import KinectPV2.KJoint;
import KinectPV2.*;
import oscP5.*;
import netP5.*;

OscP5 oscp5;
NetAddress myRemoteLocation;
KinectPV2 kinect;

int depth = 600;
float zVal = 1;
float rotX = PI;

String pose;

boolean showBody = true;

void setup() {
  size(1024, 768, P3D);

  kinect = new KinectPV2(this);

  kinect.enableColorImg(true);

  //enable 3d  with (x,y,z) position
  kinect.enableSkeleton3DMap(true);

  kinect.init();

  oscp5 = new OscP5(this, 9000);
  myRemoteLocation = new NetAddress("127.0.0.1", 8000);
}

void oscEvent(OscMessage message) {
  println("~~received message~~");
  if (message.checkAddrPattern("/prediction") == true) {
    println(message.get(0));
    //come on and work: 
    pose = message.get(0).stringValue();
    return;
  }
  println(message.addrPattern());
  println(message.typetag());
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
      if (showBody) {
        drawBody(joints);
      }

      sendData(joints);
    }
  }
  popMatrix();
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

void sendData(KJoint[] joints) {
  OscMessage newMessage = new OscMessage("/skeletal_data");
  for (int i=0; i<joints.length-1; i++) {
    newMessage.add(joints[i].getX());
    newMessage.add(joints[i].getY());
    newMessage.add(joints[i].getZ());
    newMessage.add(joints[i].getOrientation().getW());
    newMessage.add(joints[i].getOrientation().getX());
    newMessage.add(joints[i].getOrientation().getY());
    newMessage.add(joints[i].getOrientation().getZ());
  }
  oscp5.send(newMessage, myRemoteLocation);
  println(newMessage);
}