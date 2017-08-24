from setuptools import setup

setup(
	name='Stuff',
	version='0.2dev',
	author='Kat Sullivan',
	author_email='kmsullivan012@gmail.com',
	description='Take a csv file containing movement and run it through a classifer',
	url='https://github.com/katsully/machines-learning-movement',
	packages=['stuff'],
	install_requires=['nltk'],
	license='Something',
	long_description=open('../README.txt').read,
)