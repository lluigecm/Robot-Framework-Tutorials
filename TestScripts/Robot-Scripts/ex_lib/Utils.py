import easyocr

def IMAGE_TO_TEXT(image_path):
    reader = easyocr.Reader(['en'])
    result = reader.readtext(image_path)

    return result[0][1]

def REMOVE_CHARS(string, chars_to_remove):
    translation_table = str.maketrans('', '', chars_to_remove)

    return string.translate(translation_table)

#print(IMAGE_TO_TEXT('../captcha.png'))