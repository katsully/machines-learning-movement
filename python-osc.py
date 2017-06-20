from sklearn.externals import joblib
from pythonosc import dispatcher
from pythonosc import osc_server
from pythonosc import osc_message_builder
from pythonosc import udp_client
import argparse
import time
import random

def print_click(*params):
	poses = list(params[2:])
	#print (body_language)
	prediction  = clf.predict(poses)
	msg = osc_message_builder.OscMessageBuilder(address="/prediction")
	pred_string = str(prediction[0], 'utf-8')
	print (pred_string)
	msg.add_arg(pred_string)
	msg = msg.build()
	client.send(msg)

if __name__ == "__main__":
	clf = joblib.load('machinelearning.pkl')

	parser = argparse.ArgumentParser()
	parser.add_argument("--ip", default="127.0.0.1",
		help="the ip of the osc server")
	parser.add_argument("--port", type=int, default=8000,
		help="The port the OSC server is listening on")
	args = parser.parse_args()

	# needs to be 9000 for beginning loop
	client = udp_client.UDPClient(args.ip, 9000)

	dispatcher = dispatcher.Dispatcher()
	dispatcher.map("/skeletal_data", print_click, "Click")

	# needs to be port 9000 to receive data from processing
	server = osc_server.ThreadingOSCUDPServer(
		(args.ip, 8000), dispatcher)
	print("Serving on {}".format(server.server_address))
	for x in range(5):
		msg = osc_message_builder.OscMessageBuilder(address="/prediction")
		msg.add_arg(random.random())
		msg = msg.build()
		client.send(msg)
		time.sleep(1)
	server.serve_forever()

