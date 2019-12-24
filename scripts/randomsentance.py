#Small script to make a random sentance based on a few text files.
import random

def random_line(fname):
    lines = open(fname).read().splitlines()
    return random.choice(lines)

NUM0 = str(random.randint(0,9))
NUM1 = str(random.randint(0,9))
ADJ = random_line('../fun/adjectives.txt')
NOUN = random_line('../fun/nouns.txt')
VERB = random_line('../fun/verbs.txt')
ADV = random_line('../fun/adverbs.txt')
SENTANCE = NUM0 + NUM1 + ' ' + ADJ + ' ' + NOUN + ' ' + VERB + ' ' + ADV
print(SENTANCE)
