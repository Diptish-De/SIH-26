import spacy

nlp = spacy.load("en_core_web_sm")
transcript = "If this day and now I'm just checking our app, so as I'm getting the wise option is working properly or not, so I have to record for me 10 -12 seconds and check."

doc = nlp(transcript)

print("Tokens with POS and tags:")
for t in doc:
    if not t.is_punct and not t.is_space:
        print(f"  {t.text:12s} POS={t.pos_:6s} Tag={t.tag_:6s} Lemma={t.lemma_:12s} Dep={t.dep_:8s}")

# Check main verbs vs AUX:
# Main verbs: t.pos_ == "VERB" (excludes AUX like "'m", "is")
# Nouns: t.pos_ in ("NOUN", "PROPN")
# Adverbs: t.pos_ == "ADV"
# Pronouns: t.pos_ == "PRON"
# Adjectives: t.pos_ == "ADJ"

word_num = 34

nouns = [t for t in doc if not t.is_punct and not t.is_space and t.pos_ in ("NOUN", "PROPN")]
verbs_main = [t for t in doc if not t.is_punct and not t.is_space and t.pos_ == "VERB"]
verbs_all = [t for t in doc if not t.is_punct and not t.is_space and t.pos_ in ("VERB", "AUX")]
adverbs = [t for t in doc if not t.is_punct and not t.is_space and t.pos_ == "ADV"]
pronouns = [t for t in doc if not t.is_punct and not t.is_space and t.pos_ == "PRON"]
adjectives = [t for t in doc if not t.is_punct and not t.is_space and t.pos_ == "ADJ"]

print("\nCounts:")
print(f"Nouns (pos in NOUN, PROPN): {len(nouns)} -> ratio: {len(nouns)/word_num:.6f}")
print(f"Verbs (pos == VERB):        {len(verbs_main)} -> ratio: {len(verbs_main)/word_num:.6f}")
print(f"Verbs (pos in VERB, AUX):   {len(verbs_all)} -> ratio: {len(verbs_all)/word_num:.6f}")
print(f"Adverbs (pos == ADV):       {len(adverbs)} -> ratio: {len(adverbs)/word_num:.6f}")
print(f"Pronouns (pos == PRON):     {len(pronouns)} -> ratio: {len(pronouns)/word_num:.6f}")
print(f"Noun to Verb (nouns/verbs_main): {len(nouns)/len(verbs_main):.6f}")
print(f"Noun to Verb (nouns/verbs_all):  {len(nouns)/len(verbs_all):.6f}")

# Keywords / Content words (NOUN, PROPN, VERB, ADJ, ADV) - using pos == VERB (main verbs) or lemmas:
keywords = [t.lemma_.lower() for t in doc if not t.is_punct and not t.is_space and t.pos_ in ("NOUN", "PROPN", "VERB", "ADJ", "ADV")]
unique_keywords = set(keywords)

print(f"\nKeywords (lemmatized content words): Count = {len(keywords)}")
print(f"Keywords: {keywords}")
print(f"Unique Keywords: Count = {len(unique_keywords)}")
print(f"Unique Keywords: {sorted(list(unique_keywords))}")

iu_eff = len(unique_keywords) / word_num
kw_ttr = len(unique_keywords) / len(keywords)

print(f"\nCTP_unique_IU_efficiency (unique_kw / word_num): {iu_eff:.6f} (Expected: 0.411765)")
print(f"CTP_ keyword_TTR (unique_kw / total_kw):         {kw_ttr:.6f} (Expected: 0.933333)")
