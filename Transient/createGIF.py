import imageio,os
import time

images = []
imagesPath = 'temp_images/'
numImg = 0
fps = 15

print("Adding frames")
for filename in os.listdir(imagesPath):
    if(filename.endswith(".jpg")):
        numImg += 1
        images.append(imageio.imread(imagesPath+filename))
        print(filename)
        os.remove(filename)

output = "ZeroFreq.gif"

print("Saving GIF's")
kargs={'duration':1/fps}
imageio.mimsave(output, images,'GIF',**kargs)
print("Done")
