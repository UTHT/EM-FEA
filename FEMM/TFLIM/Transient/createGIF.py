import imageio,os
import datetime

images = []
imagesPath = 'temp_images/'
numImg = 0
fps = 60

print("Adding frames")
for filename in os.listdir(imagesPath):
    if(filename.endswith(".jpg")):
        numImg += 1
        print("Reading"+filename)
        images.append(imageio.imread(imagesPath+filename))


output = "TFLIM "+str(datetime.datetime.now())+".gif"

print("Saving GIF's")
kargs={'duration':1/fps}
imageio.mimsave(output, images,'GIF',**kargs)
print("Done")

a = input("Delete temporary image files?")
if((a=="Y")|(a=='y')):
    for filename in os.listdir(imagesPath):
        if(filename.endswith(".jpg")):
            numImg += 1
            print("Deleting"+filename)
            os.remove(imagesPath+filename)
