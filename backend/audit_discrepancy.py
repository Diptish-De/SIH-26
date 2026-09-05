import sys
from pathlib import Path
BACKEND_DIR = Path(__file__).resolve().parent
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

import spacy
from faster_whisper import WhisperModel

print("=" * 80)
print("AUDIT SCRIPT: Token & POS Breakdown for Real WebM Recording")
print("=" * 80)

# 1. Faster-Whisper ASR
whisper = WhisperModel("tiny", device="cpu", compute_type="int8")
audio_path = str(BACKEND_DIR / "uploads" / "swarsanket_20260905_103216_dc24d59e.webm")

segments, info = whisper.transcribe(audio_path, word_timestamps=True, vad_filter=True)
words_list = []
text_parts = []
for s in segments:
    text_parts.append(s.text.strip())
    if s.words:
        for w in s.words:
            words_list.append({
                "word": w.word.strip(),
                "start": w.start,
                "end": w.end,
            })

transcript = " ".join(text_parts).strip()
print(f"Faster-Whisper Transcript: \"{transcript}\"")
print(f"Whisper Duration:          {info.duration:.3f}s")
if words_list:
    print(f"First word start:          {words_list[0]['start']:.2f}s")
    print(f"Last word end:             {words_list[-1]['end']:.2f}s")
    print(f"Word count:                {len(words_list)}")
    print(f"Rate using last word end:  {len(words_list) / words_list[-1]['end']:.6f}")
    print(f"Rate using info.duration:  {len(words_list) / info.duration:.6f}")

print("\n" + "-" * 80)
print("spaCy Inspection:")
nlp = spacy.load("en_core_web_sm")
print(f"spaCy version: {spacy.__version__}")
print(f"spaCy pipeline components: {nlp.pipe_names}")

doc = nlp(transcript)

print(f"\nTotal spaCy tokens: {len(doc)}")
print(f"{'Idx':<4} {'Text':<15} {'POS':<8} {'Tag':<8} {'Lemma':<15} {'is_alpha':<9} {'is_punct':<9} {'like_num':<9}")
print("-" * 80)
for idx, token in enumerate(doc, 1):
    print(f"{idx:<4} {token.text:<15} {token.pos_:<8} {token.tag_:<8} {token.lemma_:<15} {str(token.is_alpha):<9} {str(token.is_punct):<9} {str(token.like_num):<9}")

# Count POS categories on alpha/word tokens vs all
tokens_non_punct = [t for t in doc if not t.is_punct and not t.is_space]
print(f"\nNon-punct tokens count: {len(tokens_non_punct)}")

# Let's inspect different definitions of keywords / POS
print("\n--- POS Token Analysis ---")
nouns = [t for t in tokens_non_punct if t.pos_ in ("NOUN", "PROPN")]
verbs = [t for t in tokens_non_punct if t.pos_ in ("VERB", "AUX")]
adverbs = [t for t in tokens_non_punct if t.pos_ == "ADV"]
pronouns = [t for t in tokens_non_punct if t.pos_ == "PRON"]
adjectives = [t for t in tokens_non_punct if t.pos_ == "ADJ"]

print(f"Nouns ({len(nouns)}):     {[t.text for t in nouns]}")
print(f"Verbs ({len(verbs)}):     {[t.text for t in verbs]}")
print(f"Adverbs ({len(adverbs)}):   {[t.text for t in adverbs]}")
print(f"Pronouns ({len(pronouns)}):  {[t.text for t in pronouns]}")
print(f"Adjectives ({len(adjectives)}):{[t.text for t in adjectives]}")

# Content words / Keywords (N + V + ADJ + ADV)
content_words = [t for t in tokens_non_punct if t.pos_ in ("NOUN", "PROPN", "VERB", "ADJ", "ADV")]
content_lemmas_or_texts = [t.text.lower() for t in content_words]
unique_content = set(content_lemmas_or_texts)

print(f"\nContent words (Keywords) Count: {len(content_words)}")
print(f"Content words:                 {content_lemmas_or_texts}")
print(f"Unique Content words Count:    {len(unique_content)}")
print(f"Unique Content words:          {sorted(list(unique_content))}")
if len(words_list) > 0 and len(content_words) > 0:
    print(f"Unique IU efficiency (unique_kw / Word_Num): {len(unique_content) / len(words_list):.6f}")
    print(f"Keyword TTR (unique_kw / total_kw):          {len(unique_content) / len(content_words):.6f}")
