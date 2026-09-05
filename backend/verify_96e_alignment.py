import spacy

nlp = spacy.load("en_core_web_sm")
transcript = "If this day and now I'm just checking our app, so as I'm getting the wise option is working properly or not, so I have to record for me 10 -12 seconds and check."

doc = nlp(transcript)

# Let's inspect tokens
tokens = [t for t in doc if not t.is_punct and not t.is_space]
print("All non-punct tokens (len={}):".format(len(tokens)))
for idx, t in enumerate(tokens, 1):
    print(f"  {idx:2d}. {t.text:12s} POS={t.pos_:6s} Tag={t.tag_:6s} Lemma={t.lemma_:12s}")

word_num = 34

# 1. Nouns: NOUN, PROPN
nouns = [t for t in tokens if t.pos_ in ("NOUN", "PROPN")]
print(f"\nNouns ({len(nouns)}): {[t.text for t in nouns]} -> {len(nouns)/word_num:.6f}")

# 2. Verbs: All verbs excluding contracted clitic auxiliaries ("'m", "'s", "'re", "'ve", "'d", "'ll")
verbs = [t for t in tokens if t.pos_ == "VERB" or (t.pos_ == "AUX" and not t.text.startswith("'"))]
print(f"Verbs ({len(verbs)}): {[t.text for t in verbs]} -> {len(verbs)/word_num:.6f}")

# 3. Adverbs: ADV
adverbs = [t for t in tokens if t.pos_ == "ADV"]
print(f"Adverbs ({len(adverbs)}): {[t.text for t in adverbs]} -> {len(adverbs)/word_num:.6f}")

# 4. Pronouns: PRON
pronouns = [t for t in tokens if t.pos_ == "PRON"]
print(f"Pronouns ({len(pronouns)}): {[t.text for t in pronouns]} -> {len(pronouns)/word_num:.6f}")

# 5. Noun to verb
noun_to_verb = len(nouns) / len(verbs)
print(f"Noun to verb: {noun_to_verb:.6f}")

# 6. Word Rate
speech_end_time = 12.28
word_rate = word_num / speech_end_time
print(f"Word Rate (34 / {speech_end_time}s): {word_rate:.6f}")

# 7. Keywords (Content Words: NOUN, PROPN, VERB, ADJ, ADV) lemmatized
keywords = [t.lemma_.lower() for t in tokens if t.pos_ in ("NOUN", "PROPN", "VERB", "ADJ", "ADV")]
unique_keywords = set(keywords)
print(f"\nKeywords ({len(keywords)}): {keywords}")
print(f"Unique Keywords ({len(unique_keywords)}): {sorted(list(unique_keywords))}")

iu_efficiency = len(unique_keywords) / word_num
kw_ttr = len(unique_keywords) / len(keywords)

print(f"CTP_unique_IU_efficiency: {iu_efficiency:.6f}")
print(f"CTP_ keyword_TTR:         {kw_ttr:.6f}")

print("\n--- COMPARISON WITH STEP 96E VALIDATED TARGETS ---")
print(f"CTP_noun_ratio:           {len(nouns)/word_num:.6f} vs 0.117647 (Diff: {abs(len(nouns)/word_num - 0.117647):.6f})")
print(f"CTP_verb_ratio:           {len(verbs)/word_num:.6f} vs 0.205882 (Diff: {abs(len(verbs)/word_num - 0.205882):.6f})")
print(f"CTP_adv_ratio:            {len(adverbs)/word_num:.6f} vs 0.117647 (Diff: {abs(len(adverbs)/word_num - 0.117647):.6f})")
print(f"CTP_Pronouns_ratio:       {len(pronouns)/word_num:.6f} vs 0.147059 (Diff: {abs(len(pronouns)/word_num - 0.147059):.6f})")
print(f"CTP_noun to verb:         {noun_to_verb:.6f} vs 0.571429 (Diff: {abs(noun_to_verb - 0.571429):.6f})")
print(f"CTP_Word Rate(-/s):       {word_rate:.6f} vs 2.768730 (Diff: {abs(word_rate - 2.768730):.6f})")
print(f"CTP_unique_IU_efficiency: {iu_efficiency:.6f} vs 0.411765 (Diff: {abs(iu_efficiency - 0.411765):.6f})")
print(f"CTP_ keyword_TTR:         {kw_ttr:.6f} vs 0.933333 (Diff: {abs(kw_ttr - 0.933333):.6f})")
