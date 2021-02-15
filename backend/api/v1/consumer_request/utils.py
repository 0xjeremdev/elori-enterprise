import random


def gen_random_id():
    first = str(random.randint(100, 999))
    second = str(random.randint(1, 888)).zfill(3)

    last = (str(random.randint(1, 9998)).zfill(4))

    return '{}-{}-{}'.format(first, second, last)


def validate_filename(file):
    filename = file.name
    valid_extensions = [
        ".jpg", ".jpeg", ".doc", ".docx", ".xls", ".xlsx", ".pdf"
    ]
    isNameValid = False
    for item in valid_extensions:
        if filename.endswith(item):
            isNameValid = True
            break
    print(file.size)
    return isNameValid


def validate_filesize(file):
    return file.size <= 3698688