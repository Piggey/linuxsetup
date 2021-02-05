from sys import argv
from os import getenv
from PIL import Image

home = getenv('HOME')
outpath = f"{home}/Desktop/{argv[1]}"
imgs = argv[3:]

print(f'converting image {argv[2]}')
pdf = Image.open(argv[2])
pdf = pdf.convert('RGB')

print(f'appending images {imgs}\nsaving to {outpath}...')
converted = []
for image in imgs:
    pil_img = Image.open(image)
    print(f'converting {image}')
    pil_img = pil_img.convert("RGB")
    converted.append(pil_img)

pdf.save(outpath, save_all=True, append_images=converted)
print("done!")