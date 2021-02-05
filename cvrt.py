from sys import argv
from os import getenv
from PIL import Image

home = getenv('HOME')
outpath = f"{home}/Desktop/{argv[1]}"
imgs = argv[3:]

print('converting images from /tmp/scanfiles folder...')
pdf = Image.open(argv[2])
pdf = pdf.convert('RGB')

converted = []
for image in imgs:
    pil_img = Image.open(image)
    pil_img = pil_img.convert("RGB")
    converted.append(pil_img)

pdf.save(outpath, save_all=True, append_images=converted)
print('converted successfully!')