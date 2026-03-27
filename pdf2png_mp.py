import os
from pdf2image import convert_from_path
from concurrent.futures import ThreadPoolExecutor, as_completed

PATH_PDF = "assets/pdfs"
PATH_PNG = "assets/images/preview"
MAX_WORKERS = 4


def convert_one_pdf(pdf: str) -> None:
    pdf_index = pdf.split(".")[0]
    path_png = os.path.join(PATH_PNG, pdf_index)

    if not os.path.exists(path_png):
        os.makedirs(path_png)

    images = convert_from_path(os.path.join(PATH_PDF, pdf), dpi=50)
    for i, img in enumerate(images):
        img.save(os.path.join(path_png, f"{i+1}.png"), "PNG")
        print(f"Converted {pdf} to {path_png}/{i+1}.png")


def main():
    if not os.path.exists(PATH_PNG):
        raise FileNotFoundError(f"Path {PATH_PNG} not found")

    all_pdfs = os.listdir(PATH_PDF)
    pdfs = [f for f in all_pdfs if f.lower().endswith(".pdf")]

    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = {executor.submit(convert_one_pdf, pdf): pdf for pdf in pdfs}
        for future in as_completed(futures):
            future.result()


if __name__ == "__main__":
    main()
