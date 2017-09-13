# Machines Learning Movement

## ITP Camp 2017

#### Intro
In the past several years, Machine Learning has been the buzzword, from the new algorithms Netflix and Amazon use to reccommend you products to the latest technical intervention/disruption to the art world. 

Here's are some awesome artists using Machine Learning in their practice:

[Ross Goodwin](http://rossgoodwin.com/)<br>
[Kyle Mcdonald](https://medium.com/@kcimc/a-return-to-machine-learning-2de3728558eb)<br>
[Gene Kogan](https://medium.com/@genekogan/machine-learning-for-artists-e93d20fdb097)

These artists feed their algorithms images and words to create pieces completely unique. But as a movement practioner, I wondered what the role of movement had in this new exciting world. 

Can machines learn movement? <br>
If so, what can we do?

#### Agenda

Today we will accomplish the following:

1. Record and label our movements using the Kinect and Processing
2. Use a classifer to teach our computers how to identify our movements
3. Trigger something fun with our movements!

Already feel a little lost? It's ok, just roll with it. Today is a day to try something new, make mistakes (or completely mess up), and get out of your confort zone! This will be very technical (which is why I included all the code), but don't forget to have fun and don't be afraid to get a little creative with the instructions!

### Step 1: Processing & the Kinnect
To start, download the entire github repo and unzip it. You many also clone the repo if you feel comfortable doing that, if not, no worries. It doesn't matter where you save it.

Next, we'll be using KinectRecordingMovement.pde file inside the KinectRecordingMovement folder. 

We'll be using the Kinect 2 for this part so you'll need a Windows computer and [Processing](https://processing.org/download/). 

If the KinectPV2 object is underlined in red, you also need to install the KinectPV2 library which can be installed in the Processing IDE by going to Sketch->Import Library->Add Library.

**Note, when running this Processing sketch, it might take a minute or two before you see anything.

### Step 2: Let the Machine Learn!
First, we need to make sure Python has been installed. (This is only for Window users, Python comes standard in Mac).
Open the Command Prompt and type Python. If it says Python 2.7.xx ...., you're all set! If not, please download [Python](https://www.python.org/downloads/windows). We want the 2.7.13 release, and use the Windows x86-64 MSI installer. Once installed, add C:\Python27 to your PATH.

**If you have both python2 and python3, the trick is to rename the python3 executable to python3.

Run setup.py in classifers folder. May need to install Microsoft Visual Studio C++ 9.0 first.

(This has only been tested on Python2.7)
For this step we'll be using the movement\_machine\_learning.py file.

For window users you'll need the get\_pip.py file if you don't already have pip installed. The get\_pip.py is included in this repo. Run ```python get\_pip.py```

Once this is complete add C:\Python27\Scripts to your PATH, then close and reopen your terminal.

In terminal type
```python -m pip install scikit-learn```

To install numpy+mlk libraries download the numpy+mkl [file](http://www.lfd.uci.edu/~gohlke/pythonlibs/#numpy). Again cd into downloads and ```pip install numpy‑1.11.3+mkl‑cp27‑cp27m‑win_amd64.whl```

**If you get an error filename.whl is not supported wheel on this platform, rename the file to numpy‑1.11.3+mkl‑cp27‑none-any.whl and rerun pip install.
OR you may be using a 32bit version of Python, to double check out the python interpreter and write

```
import platform
platform.architecture()[0]
```

This will either print 32bit or 64bit. Obviously, if it says 32bit you'll need to download the appropriate wheel file.

You'll also want to install scipy. To do so, download the whl file [here](http://www.lfd.uci.edu/~gohlke/pythonlibs/#scipy) I downloaded the 64 bit for Python 2.7. Then cd into downloads and ```pip install scipy-0.19.1-cp27-cp27m-win_amd64.whl```


### Step 3: Make something cool!
For this step we'll be using the files

For the processing sketch you'll want to install the oscp5 library, which you can do via Sketch->Install Library.

For Python, we'll need Python 3.4+. Go to the downloads of Python, download 3.5, NOT 3.6. Use the executable and click the option to add to path. cd to where Python35 is installed and change python.exe to python3.exe

When you do python --version you'll get 2.7 and when you do python3 --version you'll get 3.5. From now on we'll be using python3.

To use the pythonosc libray do ```python3 -m pip install python-osc```

To install numpy+mlk libraries download the numpy+mkl [file](http://www.lfd.uci.edu/~gohlke/pythonlibs/#numpy). cd into downloads and ```python3 -m pip install numpy‑1.11.3+mkl‑cp35‑cp35m-win_amd64.whl```

You'll also want to install scipy. To do so, download the whl file [here](http://www.lfd.uci.edu/~gohlke/pythonlibs/#scipy) I downloaded the 64 bit for Python 3.5. Then cd into downloads and ```python3 -m pip install scipy-0.15.1-cp35-cp35m-win_amd64.whl```

```python3 -m pip install sklearn```




