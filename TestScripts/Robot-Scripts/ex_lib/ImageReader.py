import easyocr

def IMAGE_TO_TEXT(image_path):
    reader = easyocr.Reader(['en'])
    result = reader.readtext(image_path)

    return result[0][1]