import random


def gen_random_id():
    first = str(random.randint(100,999))
    second = str(random.randint(1,888)).zfill(3)

    last = (str(random.randint(1,9998)).zfill(4))

    return '{}-{}-{}'.format(first,second, last)