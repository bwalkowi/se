import argparse
from itertools import chain

from pyswip import Prolog


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'words',
        nargs='+',
        help='words for cryptoarithmetic'
    )

    args = parser.parse_args()

    prolog = Prolog()
    prolog.consult("cryptoarithmetic.pl")

    words = [word.upper() for word in args.words]
    letters = list(set(chain(*words)))

    letters_str = '[' + ','.join(letters) + ']'
    words_str = '['
    words_str += ','.join('[' + ','.join(char for char in word) + ']'
                          for word in words)
    words_str += ']'

    query_str = 'puzzle({},{})'.format(words_str, letters_str)
    solutions = prolog.query(query_str)

    for solution in solutions:
        print(solution)


if __name__ == '__main__':
    main()
