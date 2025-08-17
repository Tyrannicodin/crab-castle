from PIL import Image

im = Image.open("assets\\rooms\\empty.png")

scale = 240/300

im.resize((round(im.width * scale), round(im.height * scale))).save("assets\\rooms\\empty_scaled.png")