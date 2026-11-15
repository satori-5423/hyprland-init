#!/usr/bin/env python3

import sys

FINALS = {
    "iang": "l", "iong": "s", "uang": "l", "uai": "k", "ian": "m", "iao": "n",
    "ing": "k", "uan": "r", "ang": "h", "eng": "g", "ong": "s", "ue": "t",
    "ve": "t", "un": "y", "uo": "o", "ui": "v", "ua": "x", "iu": "q", "in": "b",
    "ie": "p", "ia": "x", "an": "j", "en": "f", "ai": "d", "ei": "w", "ao": "c",
    "ou": "z", "er": "r", "a": "a", "o": "o", "e": "e", "i": "i", "u": "u",
    "v": "v",
}
ORDER = sorted(FINALS, key=len, reverse=True)
INITIALS2 = {"zh": "v", "ch": "i", "sh": "u"}
INITIALS1 = set("bpmfdtnlgkhjqxrzcsyw")
CJK_MIN, CJK_MAX = 0x4E00, 0x9FFF


def flypy(syllable):
    s = syllable.lower()
    if not s.isascii() or not s.isalpha():
        return None
    if s[:2] in INITIALS2:
        rest = s[2:]
        for f in ORDER:
            if rest == f:
                return INITIALS2[s[:2]] + FINALS[f]
        return None
    if s[0] in INITIALS1:
        rest = s[1:]
        for f in ORDER:
            if rest == f:
                return s[0] + FINALS[f]
        return None
    for f in ORDER:
        if s == f:
            return s[0] + FINALS[f]
    return None


def main(src, limit, dst):
    limit = int(limit)
    rows = []
    with open(src, encoding="utf-8") as fh:
        for line in fh:
            if line.startswith("#"):
                continue
            parts = line.rstrip("\n").split("\t")
            if len(parts) < 2:
                continue
            word, pinyin = parts[0], parts[1]
            if not 1 < len(word) <= 4:
                continue
            if not all(CJK_MIN <= ord(c) <= CJK_MAX for c in word):
                continue
            syllables = pinyin.split()
            if len(syllables) != len(word):
                continue
            codes = [flypy(s) for s in syllables]
            if any(c is None or len(c) != 2 for c in codes):
                continue
            weight = int(parts[2]) if len(parts) > 2 and parts[2].isdigit() else 0
            rows.append((weight, "".join(codes), word))

    rows.sort(key=lambda r: -r[0])
    rows = rows[:limit]
    with open(dst, "w", encoding="utf-8") as out:
        out.write("(define flypy-words\n  '(\n")
        for _, code, word in rows:
            keys = " ".join('"%s"' % c for c in code)
            out.write('    (((%s)) ("%s"))\n' % (keys, word))
        out.write("  ))\n")
    print("gen-words: %d entries" % len(rows))


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], sys.argv[3])
