import torch
import re
import os
import unicodedata

from config import MAX_LENGTH, save_dir

SOS_token = 0
EOS_token = 1
PAD_token = 2

class Voc: # handles vocabularies of corpus
    def __init__(self, name):
        self.name = name
        self.word2index = {} # index of word
        self.word2count = {} # occurences of word
        self.index2word = {0: "SOS", 1: "EOS", 2:"PAD"} # inverse of word2index
        self.n_words = 3  # Count SOS and EOS

    # def addSentence(self, sentence):
    #     for word in sentence.split(' '):
    #         self.addWord(word)
    def addSentence(self, sentence): # Chinese corpus has no spaces separating words
        for character in sentence:
            self.addWord(character)

    def addWord(self, word):
        if word not in self.word2index:
            self.word2index[word] = self.n_words
            self.word2count[word] = 1
            self.index2word[self.n_words] = word
            self.n_words += 1
        else:
            self.word2count[word] += 1

# Turn a Unicode string to plain ASCII, thanks to
# http://stackoverflow.com/a/518232/2809427
def unicodeToAscii(s):
    return ''.join(
        c for c in unicodedata.normalize('NFD', s)
        if unicodedata.category(c) != 'Mn'
    )

# Lowercase, trim, and remove non-letter characters
def normalizeString(s):
    s = unicodeToAscii(s.lower().strip())
    s = re.sub(r"([.!?])", r" \1", s)
    s = re.sub(r"[^a-zA-Z.!?]+", r" ", s)
    s = re.sub(r"\s+", r" ", s).strip()
    return s

# def readVocs(corpus, corpus_name):
#     print("Reading lines...")

#     # combine every two lines into pairs and normalize
#     with open(corpus) as f:
#         content = f.readlines() # returns list where each element is line in corpus
#     # import gzip
#     # content = gzip.open(corpus, 'rt')
#     lines = [x.strip() for x in content] # strip() removes spaces, '\n' at the beginning and the end of the string
#     it = iter(lines)
#     # pairs = [[normalizeString(x), normalizeString(next(it))] for x in it]
#     pairs = [[x, next(it)] for x in it] # pairs with next line in corpus (adjacent element in list 'content')

#     voc = Voc(corpus_name)
#     return voc, pairs

def readVocs(corpus, corpus_name): # new version for Chinese corpus
    print("READING LINES...")
    
    with open(corpus, encoding="utf-8") as f:
        content = f.readlines()

    lines = [x.strip() for x in content]
    pairs = [re.split(r'\t+', x) for x in lines]

    voc = Voc(corpus_name)
    return voc, pairs

# def filterPair(p):
#     # input sequences need to preserve the last word for EOS_token
#     return len(p[0].split(' ')) < MAX_LENGTH and \
#         len(p[1].split(' ')) < MAX_LENGTH

def filterPair(p): # Chinese corpus has no spaces separating words
    if(len(p) != 2):
        print("FOUND PAIR WITH ONLY ONE ITEM!")
        return False
    else:
        return len(p[0]) < MAX_LENGTH and \
        len(p[1]) < MAX_LENGTH and \
        p[1] != '沒有資料' # remove unanswered questions

def filterPairs(pairs):
    return [pair for pair in pairs if filterPair(pair)]

def prepareData(corpus, corpus_name):
    voc, pairs = readVocs(corpus, corpus_name)
    print("Read {!s} sentence pairs".format(len(pairs)))
    pairs = filterPairs(pairs)
    print("Trimmed to {!s} sentence pairs".format(len(pairs)))
    print("Counting words...")
    for pair in pairs:
        voc.addSentence(pair[0])
        voc.addSentence(pair[1])
    print("Counted words:", voc.n_words)
    directory = os.path.join(save_dir, 'training_data', corpus_name)
    if not os.path.exists(directory):
        os.makedirs(directory)
    torch.save(voc, os.path.join(directory, '{!s}.tar'.format('voc')))
    torch.save(pairs, os.path.join(directory, '{!s}.tar'.format('pairs')))
    return voc, pairs

def loadPrepareData(corpus):
    corpus_name = corpus.split('/')[-1].split('.')[0]
    try:
        print("Start loading training data ...")
        voc = torch.load(os.path.join(save_dir, 'training_data', corpus_name, 'voc.tar'))
        pairs = torch.load(os.path.join(save_dir, 'training_data', corpus_name, 'pairs.tar'))
    except FileNotFoundError:
        print("Saved data not found, start preparing training data ...")
        voc, pairs = prepareData(corpus, corpus_name)
    return voc, pairs
