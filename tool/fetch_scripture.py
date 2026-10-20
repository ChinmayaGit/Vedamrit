#!/usr/bin/env python3
from pathlib import Path
import urllib.request

ROOT = Path(__file__).resolve().parents[1] / 'assets' / 'scripture'
ROOT.mkdir(parents=True, exist_ok=True)

BOOKS = {
    'rig_veda.txt': 'https://www.gutenberg.org/cache/epub/27973/pg27973.txt',
    'sama_veda.txt': 'https://www.gutenberg.org/cache/epub/37570/pg37570.txt',
    'white_yajur_veda.txt': 'https://www.gutenberg.org/cache/epub/37571/pg37571.txt',
    'black_yajur_veda.txt': 'https://archive.org/download/vedaofblackyajus01keit/vedaofblackyajus01keit_djvu.txt',
    'atharva_veda.txt': 'https://www.gutenberg.org/cache/epub/37572/pg37572.txt',
    'atharva_veda_bloomfield.txt': 'https://archive.org/download/mlbd.hymnsofatharvave0001unse/mlbd.hymnsofatharvave0001unse_djvu.txt',
    'vedic_reader.txt': 'https://archive.org/download/in.ernet.dli.2015.383604/2015.383604.A-Vedic_djvu.txt',
    'upanishads.txt': 'https://www.gutenberg.org/cache/epub/3283/pg3283.txt',
    'minor_upanishads.txt': 'https://archive.org/download/thirtyminorupani00naraiala/thirtyminorupani00naraiala_djvu.txt',
    'ramayana.txt': 'https://www.gutenberg.org/cache/epub/24869/pg24869.txt',
    'mahabharata.txt': 'https://www.gutenberg.org/cache/epub/19630/pg19630.txt',
    'indian_idylls.txt': 'https://www.gutenberg.org/cache/epub/128/pg128.txt',
    'dharma_sutras.txt': 'https://archive.org/download/wg902/WG902-1879%20-The%20Sacred%20Books%20of%20East%20-%20Vol%202%20of%2050%20-%20%20The%20Sacred%20Laws%20Of%20The%20Aryas%20Dharma%C5%9B%C4%81stra%20Part%20%201%20Of%202_djvu.txt',
    'laws_of_manu.txt': 'https://www.gutenberg.org/cache/epub/26157/pg26157.txt',
    'grihya_sutras.txt': 'https://www.gutenberg.org/cache/epub/26003/pg26003.txt',
    'sankhya.txt': 'https://www.gutenberg.org/cache/epub/25126/pg25126.txt',
    'arthashastra.txt': 'https://archive.org/download/kautilyas-arthashastra/Kautilya%27s%20Arthashastra_R%20Shamasastri_djvu.txt',
    'vimanika_shastra.txt': 'https://archive.org/download/the_vimanika_shastra/the_vimanika_shastra_djvu.txt',
    'yoga_sutras.txt': 'https://www.gutenberg.org/cache/epub/2526/pg2526.txt',
    'great_systems_of_yoga.txt': 'https://archive.org/download/akhf_great-systems-of-yoga-by-ernest-wood-1954-new-york-philosophical-library/Great%20Systems%20Of%20Yoga%20By%20Ernest%20Wood%201954%20New%20York%20-%20Philosophical%20Library_djvu.txt',
    'vishnu_purana.txt': 'https://archive.org/download/TheVishnuPuranaVolI/TheVishnuPuranaVolI_djvu.txt',
    'shiva_purana.txt': 'https://archive.org/download/dli.bengal.10689.20655/10689.20655_djvu.txt',
    'garuda_purana.txt': 'https://archive.org/download/sacredbooksofthehindusvol09thegarudapuranasaroddhara1974_202002/Sacred%20Books%20of%20the%20Hindus%20Vol%2009%20-%20The%20Garuda%20purana%20%28Saroddhara%29%201974_djvu.txt',
    'markandeya_purana.txt': 'https://archive.org/download/the-markandeya-purana/The%20Ma%CC%84rkan%CC%A3d%CC%A3eya%20Pura%CC%84n%CC%A3a_djvu.txt',
}


def download(name, url):
    dest = ROOT / name
    if dest.exists() and dest.stat().st_size > 1000:
        print(f'already have {name} ({dest.stat().st_size} bytes)')
        return True
    print(f'downloading {name} from {url}')
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)'})
    try:
        with urllib.request.urlopen(req, timeout=180) as response:
            data = response.read()
    except Exception as err:
        print(f'  FAIL {err}')
        return False
    dest.write_bytes(data)
    print(f'  ok {len(data)} bytes')
    return True


def main():
    ok = True
    for name, url in BOOKS.items():
        if not download(name, url):
            ok = False
    raise SystemExit(0 if ok else 1)


if __name__ == '__main__':
    main()
