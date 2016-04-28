#!/usr/bin/python

import pytumblr
import os.path
import time
from datetime import datetime


client = pytumblr.TumblrRestClient('JCjSWTWd7E2yMT4WYSm58rXHNvYklkaD9DdMX64tazeBMOB9J7','7SZjA15dB8f0LepqNaZsnOJ0M5wsj4rmiQaVuJ723pUtL4LUKy','L1a0znpVYNlwxxQz3wI7GySBfpYb48BdwACB4KMDwTDy4AxKUz','0eBdLnsBIffhuQJbJi6FxyoxQPSRW0xBbhgQ8qOsuCxpZM9osn',)

#Posts an image to your tumblr.
#Make sure you point an image in your hard drive. Here, 'image.jpg' must be in the
#same folder where your script is saved.
#From yourBlogName.tumblr.com should just use 'yourBlogName'
#The default state is set to "queue", to publish use "published"

lastSent = 0

while (lastSent > -1):
	
	next = lastSent+1
	if(os.path.isfile("saved_images/glitch-"+str(next)+".jpg")):
		cap = datetime.now().strftime('%Y-%m-%d %I:%M:%S %p')
		file = "/Users/leecody/Desktop/glitchbooth/data/saved_images/glitch-"+str(next)+".jpg"
		
		time.sleep(5)
		result = client.create_photo('MDPGlitchBooth', state="published", tags=["glitch", "ohmdp", "mdpglitchbooth"], data=file,caption=cap)
		
		print result
		
		lastSent += 1
