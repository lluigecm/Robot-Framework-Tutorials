from pytesseract import pytesseract
from PIL import Image


def IMAGE_TO_TEXT(image_path):
    pytesseract.tesseract_cmd = r'C:/Program Files/Tesseract-OCR/tesseract.exe'
    text = pytesseract.image_to_string(Image.open(image_path))
    return text

print(IMAGE_TO_TEXT("./Robot-Scripts/captcha.png"))

# Testar EasyOCR
# Testar Keras-OCR
