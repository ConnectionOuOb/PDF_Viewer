import os
import multiprocessing as mp
from PIL import Image
from pdf2image import convert_from_path

PATH_PDF = "assets/pdfs"
PATH_PNG = "assets/images/full"
Image.MAX_IMAGE_PIXELS = None


def main():
    if not os.path.exists(PATH_PNG):
        raise FileNotFoundError(f"Path {PATH_PNG} not found")

    all_pdfs = os.listdir(PATH_PDF)
    for pdf in all_pdfs:
        pdf_index = pdf.split(".")[0]
        path_png = os.path.join(PATH_PNG, pdf_index)

        if not os.path.exists(path_png):
            os.makedirs(path_png)

        images = convert_from_path(os.path.join(PATH_PDF, pdf), dpi=300)
        for i, img in enumerate(images):
            img.save(os.path.join(path_png, f"{i+1}.png"), "PNG")
            print(f"Converted {pdf} to {path_png}/{i+1}.png")


if __name__ == "__main__":
    main()
