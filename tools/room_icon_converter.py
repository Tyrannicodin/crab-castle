from PIL import Image

im = Image.open("assets\\rooms\\freezer.png").convert("RGBA")

target = Image.new("RGBA", (im.width, im.width))

diff_height = (target.height - im.height) // 2
target.paste(
    im,
    (0, diff_height, im.width, im.height + diff_height)
)

final = Image.new("RGBA", (240, 181))

target = target.resize((120, 120))
final.paste(target, (60, 10, 240-60, 130))

final.save("assets\\rooms\\freezer_scaled.png")
