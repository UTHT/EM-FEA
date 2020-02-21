import imageio,os
import time

images = []
imagesPath = 'Images/'
numImg = 0
fps = 60

print("Adding frames")
for filename in os.listdir(imagesPath):
    if(filename.endswith(".jpg")):
        numImg += 1
        images.append(imageio.imread(imagesPath+filename))
        print(filename)

output = 'DLIMSimulation'+str(time.time())+'step1.gif'

print("Saving GIF's")
kargs={'duration':1/fps}
imageio.mimsave(output, images,'GIF',**kargs)
print("Done")
