## Kat Sullivan
## ITP Camp 2017
## github.com/katsully

from sklearn import tree
import csv
import random
import DecisionTreeToCpp as to_cpp
# import joblib
# from joblib import dump


labels = []
features = []
test_labels = []
test_features = []

# open our csv file - change name to match your file!!
with open('../KinectRecordingMovement/data/test1559684077463.csv', 'r') as csvfile:
	csvreader = csv.reader(csvfile)

	# skip the headers
	next(csvreader)
	for row in csvreader:
		# random 10% becomes test data
		if random.randint(0,100) < 10:
			test_features.append(row[1:])
			test_labels.append(row[0])
		else:
			features.append(row[1:])
			labels.append(row[0])

# create the classifying tree
clf = tree.DecisionTreeClassifier()
clf = clf.fit(features, labels)
# test the accuracy of the tree 
predictions = clf.predict(test_features)
truths = [x==y for x, y in zip(predictions, test_labels)]
# # print truths
print(float(sum(truths))/float(len(truths)))

# export our tree
# joblib.dump(clf, 'machinelearning.pkl')

label_names = ["Pose 1", "Pose 2", "Pose 3"]
feature_names = ["Feature " + str(i+1) for i in range(25)]
#convert our tree into java
to_cpp.save_code(clf, feature_names, label_names, function_name="classify")