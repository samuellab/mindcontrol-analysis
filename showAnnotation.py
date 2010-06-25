import string, sys, os

try:
	r=open('D:\\WormIllum\\100621\\index.yml','r')
except:
	print '\t Error! File not found!'
	exit()
searchStr= '20100621_1255'
contents = r.read()

#Location of the experiment of interest
loc=contents.find(searchStr)
print loc
print contents[contents.rfind('---\nExperiment:\n',0,loc):contents.find('---',loc)] 

