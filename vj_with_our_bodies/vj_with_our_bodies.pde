/*
Kat Sullivan
 Brooklyn Research 2017
 github.com/katsully
 */

import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

int depth = 600;
float zVal = 1;
float rotX = PI;

int pose;

boolean showBody = true;
color col;

int interval = 0;

void setup() {
  size(1024, 768, P3D);

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
      // if doing the first pose, the body will be red
      if(pose == 0) {
        col = color(255,0,0);
       // if doing the second pose, the body will be green
      } else if(pose == 1) {
        col = color(0,255,0);
        // if doing the third pose, the body will be blue
      } else if(pose == 2) {
        col = color(0,0,255);
      } else {
        col  = color(255, 105, 180);
      }
      stroke(col);
      if (showBody) {
        drawBody(joints);
      }

      if(interval % 100 == 0) {
        sendData(joints);
      }
      interval++;
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

  ArrayList<Float> features = new ArrayList<Float>();
  
  // Feature 1: dist between spine base and head
  features.add(normHead.dist(spineBase));
  
  // Feature 2-4: avg pos between spineMid, hipLeft, and hipRight
  PVector hipAvg = (normSpineMid.add(normHipLeft).add(normHipRight)).div(3);
  features.add(hipAvg.x);
  features.add(hipAvg.y);
  features.add(hipAvg.z);
  
  // Feature 5-13:  position of the torso joints
  features.add(normSpineShoulder.x);
  features.add(normSpineShoulder.y);
  features.add(normSpineShoulder.z);
  features.add(normSpineMid.x);
  features.add(normSpineMid.y);
  features.add(normSpineMid.z);
  features.add(spineBase.x);
  features.add(spineBase.y);
  features.add(spineBase.z);
  
  // Feature 14-25: avg between wrist, elbow, and shoulder (left and right) and hip, knee, and ankle (left and right)
  PVector leftArmAvg = (normWristLeft.add(normElbowLeft).add(normShoulderLeft)).div(3);
  features.add(leftArmAvg.x);
  features.add(leftArmAvg.y);
  features.add(leftArmAvg.z);
  PVector rightArmAvg = (normWristRight.add(normElbowRight).add(normShoulderRight)).div(3);
  features.add(rightArmAvg.x);
  features.add(rightArmAvg.y);
  features.add(rightArmAvg.z);
  PVector leftLegAvg = (normHipLeft.add(normKneeLeft).add(normAnkleLeft)).div(3);
  features.add(leftLegAvg.x);
  features.add(leftLegAvg.y);
  features.add(leftLegAvg.z);
  PVector rightLegAvg = (normHipRight.add(normKneeRight).add(normAnkleRight)).div(3);
  features.add(rightLegAvg.x);
  features.add(rightLegAvg.y);
  features.add(rightLegAvg.z);
  
  pose = classify(features);
}

// ADD YOUR NEW CODE HERE!!!!!!!!
