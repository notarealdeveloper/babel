import os

def test_babel():
    langs = 'c|asm|rust|cython'
    num_langs_double = os.popen(f"""babel | strings | grep -E '({langs})_function' | wc -l""").read().strip()
    a = int(num_langs_double)
    b = 2*len(langs.split('|'))
    assert a == b, f"{a} != {b}"
