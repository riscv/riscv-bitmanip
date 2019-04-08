#!/usr/bin/env python3

def gunzip_perm(i, a, b):
    assert a < b
    if i < a or i > b:
        return i
    if i == a:
        return b
    return i-1

def gunzip(s, b, a):
    return "".join([s[gunzip_perm(i, len(s)-1-b, len(s)-1-a)] for i in range(len(s))])

def gzip_perm(i, a, b):
    assert a < b
    if i < a or i > b:
        return i
    if i == b:
        return a
    return i+1

def gzip(s, b, a):
    return "".join([s[gzip_perm(i, len(s)-1-b, len(s)-1-a)] for i in range(len(s))])

def runzips(s):
    assert 1 < len(s) < 7

    r = [
        (gzip  (s, 1, 0), "zip.n"),
    ]

    if len(s) > 2:
        r += [
            (gzip  (s, 2, 1), "zip2.b"),
            (gzip  (s, 2, 0), "zip.b"),
            (gunzip(s, 2, 0), "unzip.b"),
        ]

    if len(s) > 3:
        r += [
            (gzip  (s, 3, 2), "zip4.h"),
            (gzip  (s, 3, 1), "zip2.h"),
            (gunzip(s, 3, 1), "unzip2.h"),
            (gzip  (s, 3, 0), "zip.h"),
            (gunzip(s, 3, 0), "unzip.h"),
        ]

    if len(s) > 4:
        r += [
            (gzip  (s, 4, 3), "zip8"   if len(s) == 5 else "zip8.w"),
            (gzip  (s, 4, 2), "zip4"   if len(s) == 5 else "zip4.w"),
            (gunzip(s, 4, 2), "unzip4" if len(s) == 5 else "unzip4.w"),
            (gzip  (s, 4, 1), "zip2"   if len(s) == 5 else "zip2.w"),
            (gunzip(s, 4, 1), "unzip2" if len(s) == 5 else "unzip2.w"),
            (gzip  (s, 4, 0), "zip"    if len(s) == 5 else "zip.w"),
            (gunzip(s, 4, 0), "unzip"  if len(s) == 5 else "unzip.w"),
        ]

    if len(s) > 5:
        r += [
            (gzip  (s, 5, 4), "zip16"),
            (gzip  (s, 5, 3), "zip8"),
            (gunzip(s, 5, 3), "unzip8"),
            (gzip  (s, 5, 2), "zip4"),
            (gunzip(s, 5, 2), "unzip4"),
            (gzip  (s, 5, 1), "zip2"),
            (gunzip(s, 5, 1), "unzip2"),
            (gzip  (s, 5, 0), "zip"),
            (gunzip(s, 5, 0), "unzip"),
        ]

    return r


queue = set(["543210"])
database = {"543210": dict()}
marked = set()

while len(queue):
    next_queue = set()

    for s in queue:
        for next_s, cmd in runzips(s):
            if next_s not in database:
                next_queue.add(next_s)
                database[next_s] = dict()
            if next_s in next_queue:
                database[next_s][s] = cmd

    queue = next_queue

def reverse_mark(s):
    marked.add(s)
    for next_s in database[s].keys():
        if next_s not in marked:
            reverse_mark(next_s)

reverse_mark("210543")

print("digraph gzipgraph {")
print("  rankdir=LR;")
for s, cmds in sorted(database.items()):
    if s not in marked: continue
    for src, cmd in sorted(cmds.items()):
        print("  %s -> %s [label=\"%s\"];" % (src, s, cmd))

print("}")
