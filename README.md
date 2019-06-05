# Machines Learning Movement

## ITP Camp 2019

#### Intro
In the past several years, Machine Learning has been the buzzword, from the new algorithms Netflix and Amazon use to recommend you products to the latest technical intervention/disruption to the art world. 

Here's are some awesome artists using Machine Learning in their practice:

[Ross Goodwin](http://rossgoodwin.com/)<br>
[Kyle McDonald](https://medium.com/@kcimc/a-return-to-machine-learning-2de3728558eb)<br>
[Gene Kogan](https://medium.com/@genekogan/machine-learning-for-artists-e93d20fdb097)

These artists feed their algorithms images and words to create pieces completely unique. But as a movement practitioner, I wondered what the role of movement had in this new exciting world. 

Can machines learn movement? <br>
If so, what can we do?

#### Agenda

Today we will accomplish the following:

1. Record and label our movements using the Kinect and Processing
2. Use a classifier to teach our computers how to identify our movements
3. Trigger something fun with our movements!

Already feel a little lost? It's ok, just roll with it. Today is a day to try something new, make mistakes (or completely mess up), and get out of your comfort zone! This will be very technical (which is why I included all the code), but don't forget to have fun and don't be afraid to get a little creative with the instructions!

### Step 1: Processing & the Kinect
To start, download the entire github repo and unzip it. You many also clone the repo if you feel comfortable doing that, if not, no worries. It doesn't matter where you save it.

Next, we'll be using KinectRecordingMovement.pde file inside the KinectRecordingMovement folder. 

We'll be using the Kinect 2 for this part so you'll need a Windows computer and [Processing](https://processing.org/download/). 

At this point, it may be a good idea to see if your computer is running 32 bit or 64 bit. To do this, go to Control Panel -> System and Security -> System. Under System Type, it should way whether you have a 32-bit Operating System or 64-bit Operating System. This will be important to know moving forward!

If the KinectPV2 object is underlined in red, you also need to install the KinectPV2 library which can be installed in the Processing IDE by going to Sketch->Import Library->Add Library.

**Note, when running this Processing sketch, it might take a minute or two before you see anything.

##### Recording Instructions
1. Press 1 for Pose 1
2. Make a pose and hit record (r)
3. Stop recording (r)
4. Repeat steps 2 and 3 with a few of your partners doing the same pose from step 2
5. Repeat steps 1-4 but press 2 or 3 to record data for new poses!
6. Hit save (s)

### Step 2: Let the Machine Learn!
Step 2 can be done on a Windows or a Mac.

First, we need to make sure Python has been installed. (This is only for Window users, Python comes standard in Mac).
Open the Command Prompt and type Python. If it says Python 3.x.xx ...., you're all set! If not, please download [Python](https://www.python.org/downloads/windows). We want the 3.7.3 release, and use the Windows x86-64 executable installer (scroll down). Open the installer and <b>make sure the "Add Python 3.7 to PATH" is selected</b>. Click Install Now. You'll need to close and reopen Command Prompt after installation.

**If you have both python2 and python3, the trick is to rename the python3 executable to python3.

Install sklearn by entering this into the console:
```pip3 install scikit-learn```

Once python and sklearn are installed we'll be using the movement\_machine\_learning.py file inside the clasifier folder. 

Open the movement\_machine\_learning.py file with a text editor (ie [Sublime Text](https://www.sublimetext.com/3). Change the .csv file to match your file name on line 16.

In Command Prompt, cd to the correct folder (ie your classifier folder) and run

```python movement_machine_learning.py```

OR

```python3 movement_machine_learning.py```
if you have both python2 and python3 on your machine.

This code will also convert our classifying tree into java via the magic of Github user [papkov's](https://github.com/papkov) code. This will appear as a .java file inside the classifier folder.

### Step 3: Make something cool!
For this step we'll be using the file vj\_with\_our\_bodies.pde inside the vj\_with\_our\_bodies folder.

The code will be broken because we need to add our new classify function. Add your classify function at the bottom where it says, "Add your new code here!"

Run vj\_with\_our\_bodies.pde with the Kinect for some Machine Learning magic!




