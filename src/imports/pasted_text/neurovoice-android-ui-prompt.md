Yes — this time I’d make the prompt **strictly for the mobile app UI**, not the entire product/system. The Figma AI should understand that it is designing an **actual usable Android app for elderly rural users**, with the doctor/AI complexity kept out of the patient experience.

Copy-paste this as the main Figma prompt:

```text
DESIGN A COMPLETE MOBILE ANDROID APP UI FOR “NEUROVOICE”

NeuroVoice is a voice-first mobile application for the EARLY SCREENING of Alzheimer’s disease.

The app is designed primarily for elderly people across India, especially users in rural and semi-urban areas. It should be usable by people with limited digital literacy, limited English proficiency, poor eyesight, and little experience with smartphones.

IMPORTANT:
This is a SCREENING application, NOT a diagnostic application.
Never tell a user that they “have Alzheimer’s”.
The app identifies whether further professional evaluation may be recommended based on voice and speech patterns.

The core experience is:

LANGUAGE → LISTEN → SPEAK → COMPLETE → SCREENING RESULT

The app uses AI and a hybrid quantum-classical ML backend to analyze voice biomarkers. However, the patient-facing app should NOT expose technical terms such as quantum computing, XGBoost, Xception, neural networks, SHAP, feature vectors, or model architecture.

The app should feel like a real healthcare product, NOT a college project.

==================================================
1. TARGET DEVICE
==================================================

Design a mobile Android application.

Primary design frame:
390 × 844 px

Create a responsive mobile design using Auto Layout and reusable components.

The app should work well on:
- low/mid-range Android phones
- smaller screens
- poor internet connections
- users with large system font settings

Design for one-handed use where possible.

==================================================
2. DESIGN PHILOSOPHY
==================================================

The most important principle is:

“Listen → Speak → Done”

The elderly user should NOT need to:
- type long answers
- read long paragraphs
- understand technical terminology
- navigate complicated menus
- perform gestures such as swiping or dragging
- understand medical terminology

The user should primarily:
1. Listen to an instruction
2. Speak naturally
3. Tap a large button
4. Continue

The application should feel calm, friendly, trustworthy, and reassuring.

DO NOT make it look futuristic or overly technical.

Avoid:
- neon colors
- excessive gradients
- glassmorphism
- dark cyberpunk aesthetics
- 3D AI graphics
- excessive cards
- complicated dashboards
- tiny text
- excessive animations
- generic “AI brain” imagery

==================================================
3. VISUAL STYLE
==================================================

Create a modern healthcare aesthetic.

Use:
- clean light background
- soft blue/teal primary accent
- subtle secondary colors
- high contrast
- large rounded buttons
- rounded cards
- generous whitespace
- simple illustrations
- familiar icons
- large microphone interactions
- clear visual hierarchy

The overall visual personality should communicate:

TRUST
SIMPLICITY
SAFETY
ACCESSIBILITY
HUMAN-CENTRIC HEALTHCARE

Use approximately:
- 16–20px corner radius
- 48–60px minimum touch targets
- 8px spacing system
- large typography
- clear hierarchy

Do not make the interface visually childish.

It should feel respectful toward elderly users.

==================================================
4. BRAND
==================================================

App name:

NEUROVOICE

Tagline:

“Listen. Speak. Screen Early.”

Create a simple logo concept combining:
- speech waveform
- subtle human/cognitive element

The logo should be minimal and recognizable.

Do not use an obvious brain illustration with circuits.

==================================================
5. LANGUAGE SUPPORT
==================================================

This is a CORE feature.

The application is intended for users throughout India.

The UI should support:

English
Hindi
Bengali
Marathi
Tamil
Telugu
Gujarati
Kannada
Malayalam

At minimum, visually demonstrate:
English + Hindi + Bengali.

The layout must be designed so that longer Indian-language text does not break the UI.

IMPORTANT:
Language changes BOTH:
- written UI
- spoken instructions

Every important instruction should have:

🔊 Listen

The user should be able to tap the speaker icon and hear the instruction in their selected language.

The interface should remain visually consistent regardless of language.

==================================================
6. SCREEN 01 — SPLASH
==================================================

Create a minimal splash screen.

Center:
NeuroVoice logo

Below:
“Listen. Speak. Screen Early.”

Very subtle voice waveform animation.

Keep it clean.

==================================================
7. SCREEN 02 — LANGUAGE SELECTION
==================================================

This is the first meaningful screen.

Heading:

“Choose your language”

Subtext:

“You can change this later.”

Display large selectable language cards.

Examples:

हिन्दी
বাংলা
मराठी
தமிழ்
తెలుగు
English

Each card should have:
- language name
- optional small regional indicator
- selected state

Include a speaker icon:

🔊 “Listen”

The user can hear the language name.

Primary button:

“Continue”

Do not make the language selector look like a settings page.

==================================================
8. SCREEN 03 — WELCOME
==================================================

Create a very friendly welcome screen.

Example:

“नमस्ते 👋”

“चलिये एक छोटा Voice Check करते हैं।”

Below:

“इसमें लगभग 3–5 मिनट लगेंगे।”

Use a warm, realistic illustration of an elderly Indian person comfortably speaking into a smartphone.

Primary button:

“Start Voice Check”

Secondary option:

“Someone is helping me”

Speaker button:

🔊 “Listen”

Keep the screen extremely uncluttered.

==================================================
9. SCREEN 04 — SIMPLE CONSENT
==================================================

Heading:

“Before we begin”

Use very simple language.

Example:

“We will record your voice for a short health screening.”

“Your information will be handled securely.”

Show three simple icons:

🎙 Voice
🔒 Secure
❤️ Health screening

Primary:

“I Understand & Continue”

Secondary:

“Listen to explanation”

Avoid long legal text.

Include a small link:

“Privacy information”

==================================================
10. SCREEN 05 — BASIC PROFILE
==================================================

Create a simple profile form.

Required:
Name
Age
Preferred language

Optional:
Caregiver name

Large input fields.

Do not ask for unnecessary information.

Important:
Minimize typing.

Include:

“Someone is helping me”

If selected, activate caregiver-assisted input.

Primary:

“Continue”

==================================================
11. SCREEN 06 — HOME
==================================================

This is the MAIN PATIENT SCREEN.

It should be extremely simple.

Top:

“नमस्ते, [Name] 👋”

Main hero card:

🎙️

“Voice Check”

“Take a short 3–5 minute screening.”

Large button:

“START”

Below:

“Previous Checks”

Show only the latest screening:

“Last check”
“12 Aug 2026”
“Completed”

Additional large actions:

“History”

“Help”

“Caregiver Mode”

Bottom navigation:
Home
History
Help
Profile

Do NOT add:
Analytics
AI Dashboard
Biomarkers
Settings-heavy navigation
Technical information

==================================================
12. SCREEN 07 — VOICE CHECK INTRO
==================================================

Heading:

“Let’s begin”

Subtext:

“There are no right or wrong answers. Speak naturally.”

Show three large illustrated steps:

1. 👂 Listen
2. 🎙 Speak
3. ✓ Finish

Primary:

“Begin”

Speaker:

🔊 “Listen”

==================================================
13. SCREEN 08 — INSTRUCTION
==================================================

The app should communicate primarily through AUDIO.

Large speaker icon in the center.

Example:

🔊

“Please listen to the question.”

Below show the question in the selected language.

Example:

“आज आपने क्या किया?
अपने दिन के बारे में बताइए।”

Button:

“🔊 Play Again”

Primary:

“Start Speaking”

Keep text large.

==================================================
14. SCREEN 09 — FREE SPEECH RECORDING
==================================================

This is the HERO SCREEN of the app.

Make this interaction visually excellent.

Before recording:

Large microphone icon.

“Tap to speak”

Primary circular microphone button.

After tapping:

Red recording indicator.

“Recording…”

Timer:

00:27

Large simple waveform.

Text:

“Speak naturally…”

Buttons:

“Pause”

“Finish”

The microphone must be impossible to miss.

Do not use tiny recording controls.

==================================================
15. SCREEN 10 — RECORDING REVIEW
==================================================

Heading:

“Your recording is ready”

Show:
Waveform
Play button
Duration

Large actions:

“▶ Play”

“Record Again”

“Continue”

Make Continue the primary action.

==================================================
16. SCREEN 11 — PICTURE DESCRIPTION
==================================================

Create a simple picture-description task.

Heading:

“What do you see?”

Large image in the center.

Instruction:

“Tell us what you see in the picture.”

Speaker:

🔊 Listen

Primary:

“Start Speaking”

Recording interface should reuse the same microphone component.

The picture should be:
- culturally neutral
- easy to describe
- visually clear
- not frightening
- not overly complex

==================================================
17. SCREEN 12 — MEMORY / RECALL TASK
==================================================

Create a simple voice-based memory activity.

Screen:

“Listen carefully.”

Large speaker button:

🔊 Play

The application reads several simple words in the selected language.

Do NOT require the user to type them.

After the appropriate task interval:

Heading:

“What do you remember?”

Primary:

“Start Speaking”

Secondary:

“Listen Again”

Keep it extremely simple.

==================================================
18. SCREEN 13 — CONVERSATIONAL TASK
==================================================

Create another natural speech task.

Example:

“Tell us about something you enjoy doing.”

Speaker:

🔊 Listen

Primary:

“Start Speaking”

Use the same recording component.

The experience should feel like a friendly conversation rather than an examination.

==================================================
19. SCREEN 14 — TEST COMPLETION
==================================================

Heading:

“You’re done!”

Friendly illustration.

Text:

“Thank you. We’re now checking your voice recording.”

Primary:

“Continue”

Do not use scary medical imagery.

==================================================
20. SCREEN 15 — AI PROCESSING
==================================================

Create a processing state.

Heading:

“Analyzing your voice…”

Show an elegant animated waveform.

Supporting:

“This may take a moment.”

Do not display:
Quantum
AI model
XGBoost
Xception
Neural network

Those belong in the technical backend.

If there is no internet:

“Your recording is safely saved. We’ll continue when the internet connection is available.”

Show:

“Offline — will sync later”

==================================================
21. SCREEN 16 — RESULT: LOW CONCERN
==================================================

Create a calm result screen.

Use a green/neutral visual indicator with an icon AND text.

Heading:

“Your Voice Check is complete”

Result:

“No immediate concern detected”

Supporting:

“Continue regular health check-ups and consider repeating the Voice Check later.”

Primary:

“Done”

Secondary:

“View History”

IMPORTANT:
Never say:
“You are healthy.”
“You do not have Alzheimer’s.”

This is only a screening result.

==================================================
22. SCREEN 17 — RESULT: ELEVATED
==================================================

Create a separate elevated-risk result.

Use an orange/warning visual system rather than alarming red.

Heading:

“Further evaluation recommended”

Supporting:

“The screening found some patterns that may need professional assessment.”

Main action:

“Talk to a Healthcare Professional”

Secondary:

“View Screening Details”

Small disclaimer:

“This screening does not replace a medical diagnosis.”

Do NOT say:
“You have Alzheimer’s.”

Do NOT create an alarming emergency-style design.

==================================================
23. SCREEN 18 — RESULT: UNCERTAIN
==================================================

Create an uncertain result.

Heading:

“We need a clearer recording”

Supporting:

“We could not confidently analyze the recording.”

Actions:

“Try Again”

“Talk to a Healthcare Professional”

Use a neutral yellow/amber visual.

==================================================
24. SCREEN 19 — SCREENING HISTORY
==================================================

Heading:

“Your Voice Check History”

Show a simple timeline.

Example:

August 2026
Completed
Elevated screening risk

July 2026
Completed
Low screening risk

June 2026
Completed
Low screening risk

Allow:

“Share with Doctor”

Do not overwhelm the patient with technical metrics.

==================================================
25. SCREEN 20 — RISK TREND
==================================================

Create a simple longitudinal view.

Heading:

“Your Progress”

Show a simple line chart representing screening results over time.

Example:

June → 22%
July → 25%
August → 31%
September → 39%

Label:

“Screening trend”

Supporting:

“Changes over time can help healthcare professionals understand your progress.”

Avoid claiming that the graph itself proves disease progression.

==================================================
26. SCREEN 21 — HELP
==================================================

Create a large-button help screen.

Heading:

“How can we help?”

Large options:

🔊 Listen to instructions

👨‍👩‍👧 Someone help me

🌐 Change language

📞 Contact support

❓ How Voice Check works

Everything should be accessible without typing.

==================================================
27. SCREEN 22 — CAREGIVER MODE
==================================================

Create a separate caregiver-assisted experience.

Heading:

“Who are you helping?”

Options:

“Family Member”

“Caregiver”

“Health Worker”

Caregiver can:
- select patient
- add patient
- choose language
- start Voice Check
- assist during recording
- view screening result
- connect to healthcare professional

Caregiver mode can contain slightly more information than patient mode.

==================================================
28. SCREEN 23 — HEALTH WORKER MODE
==================================================

Create a simple field-health-worker screen.

Heading:

“Today’s Screenings”

Patient cards:

✓ Completed
✓ Completed
🟠 Follow-up recommended
⏳ Waiting to sync

Primary:

“Add Person”

Show connectivity:

“Offline”

“3 recordings waiting to sync”

The health worker should be able to continue screening even with poor connectivity.

==================================================
29. SCREEN 24 — OFFLINE STATE
==================================================

Create an offline experience.

Top banner:

“Offline”

Explain:

“You can continue the Voice Check. Your recording will sync when internet is available.”

Allow:
- cached instructions
- language audio
- recording
- completing the test
- secure local storage
- later synchronization

Do not show a technical error screen.

==================================================
30. SCREEN 25 — PROFILE / SETTINGS
==================================================

Keep settings simple.

Sections:

Language
Audio Instructions
Data Saver
Privacy
Caregiver
Help

Toggle:

“Data Saver”

Description:

“Use less mobile data by syncing recordings when a better connection is available.”

Privacy option:

“Manage Voice Recordings”

“Delete my recordings”

==================================================
31. NAVIGATION
==================================================

Patient bottom navigation should contain ONLY:

Home
History
Help
Profile

Use large icons + labels.

Do not hide critical functions behind menus.

==================================================
32. VOICE INTERACTION COMPONENT
==================================================

Create a reusable “Voice Interaction” component.

States:

1. Ready
2. Listening
3. Recording
4. Paused
5. Recording complete
6. Processing
7. Error
8. Offline

Make all states visually consistent.

The microphone should be the strongest visual element during recording.

==================================================
33. ACCESSIBILITY
==================================================

Design specifically for elderly users.

Use:
- large text
- large buttons
- high contrast
- simple icons
- short sentences
- audio instructions
- obvious states
- minimal scrolling
- minimal typing
- no swipe-only interactions
- no complex gestures

Critical actions must never depend only on color.

For example:

Do not use only green.

Use:
🟢 + “No immediate concern”

Do not use only orange.

Use:
🟠 + “Further evaluation recommended”

==================================================
34. MULTILINGUAL UI
==================================================

Create language variants for important screens.

Demonstrate the same screen in:

English
Hindi
Bengali

Example English:

“Tell us about your day.”

Hindi:

“हमें अपने दिन के बारे में बताइए।”

Bengali:

“আপনার দিন সম্পর্কে আমাদের বলুন।”

Ensure buttons and cards adapt to longer text.

Every important instruction has:

🔊 Listen

==================================================
35. MICROCOPY
==================================================

Use human, reassuring language.

GOOD:
“Speak naturally.”
“Take your time.”
“There are no right or wrong answers.”
“Let’s begin.”
“Your Voice Check is complete.”
“Further evaluation recommended.”

AVOID:
“Disease probability”
“Classification”
“Model prediction”
“Cognitive impairment detected”
“Quantum analysis”
“AI confidence score”
“Diagnosis”

The patient should feel like they are completing a simple health check, not taking an AI exam.

==================================================
36. TECHNICAL INFORMATION MUST STAY HIDDEN FROM PATIENT
==================================================

The underlying system may use:

Voice preprocessing
Acoustic features
Speech/language features
Feature selection
Xception
XGBoost
Quantum machine learning
Bayesian uncertainty
Confidence estimation

Do NOT expose these in the patient app.

The patient only sees:

Voice Check
→ Analysis
→ Screening Result

==================================================
37. PROTOTYPE FLOW
==================================================

Connect the screens into a clickable prototype:

Splash
↓
Language Selection
↓
Welcome
↓
Consent
↓
Basic Profile
↓
Home
↓
Voice Check Introduction
↓
Listen to Instruction
↓
Free Speech Recording
↓
Recording Review
↓
Picture Description
↓
Memory / Recall
↓
Conversational Task
↓
Completion
↓
AI Processing
↓
Screening Result
↓
History

Create alternative flows:

Elevated Result
↓
Healthcare Professional

Uncertain Result
↓
Try Again

Offline
↓
Save Recording
↓
Sync Later

Caregiver
↓
Caregiver Mode
↓
Patient Selection
↓
Voice Check

==================================================
38. DESIGN SYSTEM
==================================================

Create a reusable component library.

Components:

Primary Button
Secondary Button
Large CTA Button
Voice Button
Recording Button
Audio Button
Language Card
Task Card
Result Card
Patient Card
Status Indicator
Offline Banner
Progress Indicator
Waveform
Audio Player
Bottom Navigation
Top Navigation
Input Field
Toggle
Modal
Toast
Loading State
Error State
Success State

Create variants for:

Default
Pressed
Disabled
Loading
Success
Warning
Error
Offline

Use Auto Layout throughout.

==================================================
39. FIGMA FILE STRUCTURE
==================================================

Organize the file into pages:

01 — Cover
02 — Design System
03 — Patient App
04 — Caregiver Mode
05 — Health Worker Mode
06 — Prototype Flow

Use named components and consistent styles.

==================================================
40. FINAL PRODUCT FEEL
==================================================

The final application should look like a real product ready for an Indian healthcare pilot.

Imagine this exact scenario:

An elderly person in a rural Indian village receives an Android phone from a health worker.

They open NeuroVoice.

They choose Bengali/Hindi/Tamil/etc.

The app speaks to them.

They listen.

They answer naturally.

They finish in a few minutes.

The system analyzes the voice.

They receive a calm screening result.

If further evaluation is recommended, a family member or health worker can connect them with a healthcare professional.

The user should be able to understand the entire experience WITHOUT needing technical knowledge.

FINAL DESIGN PRINCIPLE:

“Make the AI complicated behind the scenes.
Make the experience simple in front of the user.”

The finished Figma prototype should prioritize:
1. Extremely simple elderly-friendly UX
2. Voice-first interaction
3. Indian multilingual support
4. Rural/low-connectivity usability
5. Caregiver assistance
6. Clear non-diagnostic screening results
7. Trust and accessibility
8. Professional healthcare visual design

Do not make it look like a student project.
Make it look like a scalable Indian digital-health product.
```
