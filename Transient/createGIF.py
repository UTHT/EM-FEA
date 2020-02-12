import imageio,os

images = []
imagesPath = 'Images/'
numImg = 0

print("Adding frames")
for filename in os.listdir(imagesPath):
    if(filename.endswith(".jpg")):
        numImg += 1
        images.append(imageio.imread(imagesPath+filename))
        print(filename)

print("Saving GIF")
kargs={'duration':1/60}
imageio.mimsave('DLIMSimulation.gif', images,'GIF',**kargs)
print("Done")
