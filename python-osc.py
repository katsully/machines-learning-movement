from sklearn.externals import joblib
from pythonosc import dispatcher
from pythonosc import osc_server
from pythonosc import osc_message_builder
from pythonosc import udp_client
import argparse
import time
import random

def print_click(unused_addr, *args):
	pose = args
	pred = clf.predict([pose])
	print(pred)
	client.send_message("/prediction", pred)

if __name__ == "__main__":
	clf = joblib.load('classifer/machinelearning.pkl')

	# needs to be 9000 for beginning loop
	client = udp_client.SimpleUDPClient("127.0.0.1", 9000)

	parser = argparse.ArgumentParser()
	parser.add_argument("--ip", default="127.0.0.1",
		help="the ip of the osc server")
	parser.add_argument("--port", type=int, default=8000,
		help="The port the OSC server is listening on")
	args = parser.parse_args()

	dispatcher = dispatcher.Dispatcher()
	dispatcher.map("/skeletal_data", print_click)

	# needs to be port 9000 to receive data from processing
	server = osc_server.ThreadingOSCUDPServer(
		(args.ip, 8000), dispatcher)
	print("Serving on {}".format(server.server_address))
	server.serve_forever()

