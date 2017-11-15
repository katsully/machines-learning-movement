## Kat Sullivan
## ITP Camp 2017
## github.com/katsully

from sklearn import tree
import csv
import re
import random
from sklearn.externals import joblib

# check if the row contains numerical data
def hasNumbers(inputString):
     return bool(re.search(r'\d', inputString))

features = []
test_data = []
test_poses = []
labels = []
currPose = ""

# open our csv file 
with open('../KinectRecordingMovement/data/test.csv', 'rt') as inp:
	# keep track of what row we're at
	counter = 0
	for row in csv.reader(inp):
		if counter < 2:
			counter += 1
			continue
		if hasNumbers(row[0]) and "POSE" not in row[0]:
			# get test data
			if random.randint(0,100) < 10:
				test_data.append(row[:])
				test_poses.append(currPose)
			else:
				features.append(row[:])
				labels.append(currPose)
		if "POSE" in row[0]:
			currPose = row[0];
			continue
		

# features2 = [[3,4,5,6],[2,4,6,7]]
# labels2 = ['happy', 'sad']
clf = tree.DecisionTreeClassifier()
clf = clf.fit(features, labels)
predictions = clf.predict(test_data)
# # print predictions
# # print test_emotions
truths = [x==y for x, y in zip(predictions, test_poses)]
# # print truths
print(float(sum(truths))/float(len(truths)))

# export our tree
joblib.dump(clf, 'machinelearning.pkl')