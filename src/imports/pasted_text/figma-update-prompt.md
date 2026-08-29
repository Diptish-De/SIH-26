Got it. **The app name is exactly `SwarSanket`** — preserve that capitalization everywhere. No `SWARSANKET`, `SwarSanket AI`, `Swar Sanket`, etc.

Since you're asking specifically for the **Figma update prompt**, here's a clean prompt focused **only on UI/UX changes and additions**, based on the app you already have.

```text
Update the existing Figma design for the mobile app.

IMPORTANT:
The app name is exactly:

SwarSanket

Always write it exactly as “SwarSanket”.
Do NOT change the capitalization or spacing.
Do NOT write:
- SWARSANKET
- SwarSANKET
- Swar Sanket
- SwarSanket AI
- NeuroVoice

SwarSanket is an AI-powered, voice-first mobile application for EARLY SCREENING of Alzheimer’s disease.

The existing Figma design is already established and working well. DO NOT redesign the application from scratch.

Preserve:
- Existing light blue background
- Existing cyan/teal primary color
- Existing typography
- Existing rounded cards
- Existing spacing system
- Existing button style
- Existing logo treatment
- Existing bottom navigation
- Existing overall clean and friendly aesthetic

The goal is to EXTEND and REFINE the current design into a complete SIH-ready product.

==================================================
1. BRANDING UPDATE
==================================================

Replace every occurrence of the old app name with:

SwarSanket

Use exactly this capitalization everywhere.

Update:
- Splash screen
- Logo
- Home
- Header
- About
- Settings
- Privacy
- Screening screens
- Doctor dashboard
- Caregiver screens
- Health Worker screens
- Reports
- Empty states
- Offline screens
- Error screens

Do not modify the visual identity unnecessarily.

==================================================
2. HOME SCREEN REFINEMENT
==================================================

Keep the existing Home screen structure.

The Home screen should remain extremely simple because the primary user may be elderly.

Maintain the hierarchy:

Greeting
↓
Voice Check
↓
Previous Screening
↓
Quick Actions
↓
Bottom Navigation

The Voice Check card must remain the largest and most prominent action.

Update the Voice Check card to:

Title:
“Voice Check”

Description:
“A short 3–5 minute voice screening.”

Primary button:
“Start Voice Check”

Secondary option:
“Someone is helping me”

Add a subtle connectivity indicator:

Online

Offline

Syncing

Do not make connectivity the main focus.

The Home screen should NOT display:
- complicated AI metrics
- technical model information
- graphs
- feature values
- quantum terminology

==================================================
3. LANGUAGE EXPERIENCE
==================================================

Keep the existing language selection screen.

Improve it as a complete multilingual experience.

Languages:

English
हिन्दी
বাংলা
मराठी
தமிழ்
తెలుగు
ગુજરાતી
ಕನ್ನಡ
മലയാളം

The selected language must affect:

- UI
- voice instructions
- screening prompts
- memory task
- result messages
- help
- onboarding

Add an obvious audio playback button beside important instructions:

🔊 Listen

The user should be able to hear instructions instead of reading long text.

Create example variants for:

English
Hindi
Bengali

Make sure the layout handles longer regional-language strings without breaking.

IMPORTANT:
Do not mix languages within the same selected-language experience.

==================================================
4. VOICE CHECK ENTRY
==================================================

Create/refine the screen shown after tapping:

“Start Voice Check”

Heading:

“Let’s begin”

Supporting text:

“This short voice check takes about 3–5 minutes.”

Add a simple three-step visual:

01
Listen

02
Speak

03
Complete

Add:

“🔊 Listen to instructions”

Primary:

“Begin Voice Check”

Secondary:

“Someone is helping me”

Reassuring message:

“There are no right or wrong answers. Speak naturally and take your time.”

==================================================
5. SCREENING NAVIGATION
==================================================

During the Voice Check, hide the normal bottom navigation.

The screening should use a dedicated navigation layout.

Top:

← Back

Voice Check

Step 1 of 4

Exit

Add a simple progress indicator.

Example:

● ━━━ ○ ━━━ ○ ━━━ ○

Do not make the progress indicator complicated.

If the user presses Exit, show a confirmation modal:

“Leave Voice Check?”

“You can continue the screening later.”

Buttons:

“Continue Check”

“Exit”

==================================================
6. STANDARD VOICE TASK COMPONENT
==================================================

Create ONE reusable voice-screening component.

Use the same component throughout all voice tasks.

States:

1. Ready
2. Listening
3. Recording
4. Paused
5. Finished
6. Review
7. Poor Audio
8. Processing
9. Offline
10. Error

The interaction should always feel like:

Listen
↓
Speak
↓
Review
↓
Continue

Do not create completely different recording interfaces for different tasks.

==================================================
7. TASK 1 — FREE SPEECH
==================================================

Create/refine:

“Tell us about your day”

Supporting:

“Speak naturally. Take your time.”

Audio button:

“Listen”

Primary:

“Start Speaking”

When recording:

Large microphone button

“Recording…”

Timer

Animated waveform

Buttons:

“Pause”

“Finish”

The microphone should be the most visually prominent element.

==================================================
8. REALISTIC RECORDING STATES
==================================================

Create variants for:

READY:

Microphone

“Tap to speak”

RECORDING:

Recording indicator

Timer

Waveform

Pause

Finish

PAUSED:

“Recording paused”

Resume

Finish

COMPLETED:

Playback

Record Again

Continue

ERROR:

“Something went wrong.”

“Try Again”

Keep the interface calm and non-threatening.

==================================================
9. VOICE QUALITY CHECK
==================================================

Add a dedicated voice quality state after each recording.

The UI should communicate that SwarSanket checks whether the recording is clear enough before analysis.

GOOD:

✓

“Recording looks good.”

“Ready to continue.”

Button:

“Continue”

POOR:

⚠

“We couldn’t hear you clearly.”

Possible explanation:

“Too much background noise.”

or

“Please speak a little closer to the phone.”

Buttons:

“Record Again”

“Continue Anyway”

INSUFFICIENT:

“We couldn’t detect enough speech.”

Primary:

“Record Again”

Do not display technical audio metrics to the patient.

==================================================
10. TASK 2 — PICTURE DESCRIPTION
==================================================

Create a picture-description screening screen.

Heading:

“What do you see?”

Display a large, clear, culturally neutral image containing several objects/actions that can naturally be described.

Supporting:

“Tell us what you see in the picture.”

Audio:

“Listen”

Primary:

“Start Speaking”

Then:

Recording
↓
Voice Quality Check
↓
Review
↓
Continue

Do not require typing.

IMPORTANT:
Use a properly licensed or permitted image for the final implementation. Do not assume a copyrighted clinical assessment image can be freely used.

==================================================
11. TASK 3 — MEMORY / RECALL
==================================================

Create a memory task.

Screen 1:

“Listen carefully”

Large audio control:

“Play”

The app reads a short set of words in the selected language.

Then:

“What do you remember?”

Supporting:

“Tell us the words you remember.”

Buttons:

“Listen Again”

“Start Speaking”

Then use the same recording component.

Do not use a keyboard.

==================================================
12. TASK 4 — CONVERSATIONAL SPEECH
==================================================

Create:

“Tell us about something you enjoy doing.”

Supporting:

“There are no right or wrong answers.”

Audio:

“Listen”

Primary:

“Start Speaking”

Use the same recording UI.

==================================================
13. TEST COMPLETION
==================================================

Create:

Large checkmark

“You’re done!”

“Thank you. We’re checking your voice now.”

Primary:

“Continue”

Do not mention:
- AI model
- quantum computing
- XGBoost
- Xception
- machine learning
- neural networks

==================================================
14. PROCESSING SCREEN
==================================================

Create a polished analysis screen.

Heading:

“Analyzing your voice…”

Show a subtle animated waveform.

Supporting:

“This may take a moment.”

Secondary:

“Your information is processed securely.”

Do not display technical AI information.

==================================================
15. SCREENING RESULT — LOW CONCERN
==================================================

Create a calm result screen.

Heading:

“Your Voice Check is complete”

Result:

“No immediate concern detected”

Supporting:

“This screening did not identify patterns that require immediate follow-up.”

Secondary:

“Continue regular health check-ups.”

Buttons:

“Done”

“View History”

Do not say:

“You do not have Alzheimer’s.”

==================================================
16. SCREENING RESULT — ELEVATED
==================================================

Create an amber/orange result state.

Do NOT make it look like an emergency.

Heading:

“Further evaluation recommended”

Supporting:

“The screening found some patterns that may benefit from professional assessment.”

Primary:

“Talk to a Healthcare Professional”

Secondary:

“View Screening Details”

Additional:

“Share with Caregiver”

Disclaimer:

“This screening does not replace a medical diagnosis.”

Do not say:

“You have Alzheimer’s.”

==================================================
17. SCREENING RESULT — UNCERTAIN
==================================================

Heading:

“We need a clearer recording”

Supporting:

“We couldn’t confidently analyze this recording.”

Possible reason:

“The audio quality was not sufficient.”

Buttons:

“Try Again”

“Talk to a Healthcare Professional”

==================================================
18. CONFIDENCE DISPLAY
==================================================

Add a simple confidence indicator.

Example:

“Screening confidence”

High confidence

or:

Moderate confidence

If low:

“Your result is uncertain. A clearer recording or professional assessment may help.”

Do not show complex probability numbers to elderly users.

Detailed uncertainty information can be shown on the doctor dashboard.

==================================================
19. SCREENING DETAILS
==================================================

Create a patient-friendly details screen.

Show:

Screening date

Screening result

Confidence

Recording quality

Example:

Screening result
Further evaluation recommended

Confidence
High

Recording
Good quality

Add:

“This is a screening assessment, not a diagnosis.”

Do not expose:
- MFCC
- jitter
- shimmer
- XGBoost
- Xception
- quantum circuits
- feature vectors
- SHAP values

==================================================
20. HISTORY UPDATE
==================================================

Keep the existing History screen.

Improve screening cards.

Example:

12 AUG 2026

✓ Completed

No immediate concern detected

or:

12 AUG 2026

⚠ Follow-up recommended

Add:

“View Screening Details”

Add a new CTA:

“View Progress Trend”

==================================================
21. LONGITUDINAL TREND
==================================================

Create a dedicated:

“Screening Trend”

screen.

Show a simple time-series chart.

Example:

June
22%

July
25%

August
31%

September
39%

Label:

“Screening trend over time”

Do NOT label it:

“Alzheimer’s progression”

Supporting:

“Your screening history can help healthcare professionals understand changes over time.”

Button:

“Share Trend with Doctor”

==================================================
22. CAREGIVER MODE
==================================================

The existing caregiver option should become a complete flow.

Entry:

“Someone is helping me”

Options:

Family Member
Caregiver
Health Worker

Caregiver Home:

“People I help”

Example card:

Rama Devi
Age 72

Last Voice Check:
12 Aug 2026

Status:
Follow-up recommended

Actions:

“Start Voice Check”

“View History”

“Share with Healthcare Professional”

Create:

“Add Person”

flow.

==================================================
23. CAREGIVER NOTIFICATION
==================================================

After an elevated result:

“Further evaluation recommended”

“Would you like to notify your caregiver?”

Buttons:

“Notify Caregiver”

“Not Now”

Privacy note:

“Shared only with permission.”

==================================================
24. HEALTH WORKER MODE
==================================================

Create a dedicated Health Worker experience.

Dashboard:

“Today’s Screenings”

Cards:

Rama Devi
✓ Completed

Suresh Das
✓ Completed

Anita Devi
⚠ Follow-up recommended

Mohan Singh
⏳ Waiting to sync

Primary:

“Add Person”

Secondary:

“Search Person”

Health Worker actions:

Add person
Select language
Start screening
Assist recording
View basic result
Mark follow-up
Sync offline records

Make this interface slightly more information-dense than the elderly patient UI.

==================================================
25. OFFLINE MODE
==================================================

Make offline functionality a core part of the UI.

When offline:

Top status:

“Offline”

Supporting:

“You can continue the Voice Check. Your recording will be saved and synced when internet is available.”

After recording:

“Saved safely”

“Waiting to sync”

Buttons:

“Continue”

“View Sync Status”

Create Sync Status screen:

“3 screenings waiting to sync”

When internet returns:

“Sync complete”

“3 screenings synced successfully.”

==================================================
26. LOW DATA MODE
==================================================

Add a setting:

“Data Saver”

Description:

“Use less mobile data by syncing recordings when a better connection is available.”

Toggle:

ON / OFF

When enabled:

“Data Saver is on.”

“Recordings will sync when a better connection is available.”

==================================================
27. PRIVACY SCREEN
==================================================

Create/refine:

“Your voice, your choice.”

Show:

Secure storage
Voice recordings
Sharing permission
Delete recordings

Simple explanation:

“Your voice recordings are sensitive information. They are used for the screening process and shared with healthcare professionals only with permission.”

Actions:

“Manage Recordings”

“Manage Sharing”

“Delete Voice Recordings”

Deletion confirmation:

“Delete voice recordings?”

“This cannot be undone.”

Buttons:

“Cancel”

“Delete”

==================================================
28. HELP SCREEN UPDATE
==================================================

Keep the existing Help screen structure.

Replace inconsistent emojis with the same professional icon system.

Cards:

Listen to Instructions

Someone Help Me

Change Language

Contact Support

How Voice Check Works

What if I don’t have internet?

Each card should be large and easy to tap.

==================================================
29. SETTINGS / PROFILE UPDATE
==================================================

Keep the current Settings/Profile structure.

Include:

Personal Information
Language
Audio Instructions
Data Saver
Caregiver
Privacy
Manage Voice Recordings
Help

Keep the interface simple.

==================================================
30. AUDIO INSTRUCTIONS
==================================================

Add a global audio instruction setting:

“Audio Instructions”

Options:

Always On
Ask Before Playing
Off

Default should prioritize accessibility.

Important instructions throughout the screening should still provide a manual:

“Listen”

button.

==================================================
31. ACCESSIBILITY
==================================================

Apply elderly-first accessibility across all screens.

Use:

Large text
Large buttons
Large touch targets
High contrast
Clear icons
Short sentences
Audio instructions
Minimal typing
Simple navigation

Do NOT rely on color alone.

Every status should include:
- icon
- text
- color

Examples:

✓ No immediate concern

⚠ Further evaluation recommended

? Uncertain result

==================================================
32. MICROPHONE PERMISSION
==================================================

Create a microphone permission screen.

Heading:

“Microphone access is needed”

Supporting:

“SwarSanket needs access to your microphone to record your voice.”

Primary:

“Allow Microphone”

Secondary:

“Not Now”

If denied:

“Microphone access is turned off.”

“Enable microphone access to continue.”

==================================================
33. ERROR STATES
==================================================

Create consistent error states for:

Microphone permission denied
Recording too short
No speech detected
Too much background noise
Upload failed
Sync failed
Internet unavailable

Keep error screens calm.

Do not use aggressive red layouts.

==================================================
34. EMPTY STATES
==================================================

Create:

No Screening History

“No Voice Checks yet.”

“Your first Voice Check takes about 3–5 minutes.”

Button:

“Start Voice Check”

No Caregiver:

“No caregiver added.”

Button:

“Add Caregiver”

No Healthcare Professional:

“No healthcare professional connected.”

Button:

“Find Healthcare Professional”

==================================================
35. HEALTHCARE PROFESSIONAL FLOW
==================================================

Create a separate professional interface.

Do not use the elderly patient UI for doctors.

Doctor Dashboard:

Dashboard
Patients
Screenings
Follow-ups
Teleconsultation

Patient profile:

Patient details
Current screening
Screening history
Risk
Confidence
Audio quality
Trend

==================================================
36. DOCTOR AI ANALYSIS
==================================================

Create a doctor-only analysis screen.

Show:

Screening Risk
Confidence
Audio Quality

Voice Analysis:

Speech Rate
Pause Patterns
Pitch Variation
Jitter
Shimmer
HNR
Acoustic Features
Speech/Language Features

AI Analysis:

Classical Model

Xception + XGBoost

Hybrid Model

Quantum-enhanced model

Create a comparison area for:

Accuracy
Precision
Recall
F1
AUC

Do not insert fake numbers.

Use:

—%

until real model results are available.

==================================================
37. EXPLAINABLE AI — DOCTOR ONLY
==================================================

Create:

“Factors influencing screening result”

Show simple visual indicators:

Pause Patterns
Speech Rate
Pitch Variation
Acoustic Features
Language Features

Label:

“Model-derived indicators — not a clinical diagnosis.”

==================================================
38. DOCTOR TREND VIEW
==================================================

Doctor can view:

Current Screening
Previous Screenings
Longitudinal Screening Trend

Use a clean graph.

Label:

“Longitudinal Screening Trend”

Do not claim definitive disease progression.

==================================================
39. SCREENING REPORT
==================================================

Create:

“SwarSanket Screening Report”

Include:

Patient Details
Screening Date
Language
Audio Quality
Screening Result
Confidence
Voice Feature Summary
AI Analysis
Previous Screening Trend
Recommendation

Actions:

“Download Report”

“Share”

“Add Clinical Note”

==================================================
40. REFERRAL FLOW
==================================================

For elevated results:

Result
↓
Screening Details
↓
Healthcare Professional
↓
Professional Review
↓
Teleconsultation / Appointment
↓
Follow-up

Healthcare professional cards:

General Physician
Neurologist
Healthcare Worker

Actions:

“Start Consultation”

“Schedule”

“Share Screening”

==================================================
41. TELECONSULTATION
==================================================

Create a simple telemedicine interface.

Patient sees:

Healthcare Professional

Specialization

Availability

“Start Video Consultation”

“Audio Consultation”

Keep it simple.

==================================================
42. FOLLOW-UP
==================================================

Doctor can select:

Repeat Voice Screening

Schedule Consultation

In-person Evaluation

No Immediate Follow-up

Add:

Follow-up Date

Patient then sees:

“Your next Voice Check is due on [date].”

==================================================
43. REMINDER
==================================================

Create reminder states.

Example:

“Your next Voice Check is due.”

“Regular screening can help track changes over time.”

Buttons:

“Start Voice Check”

“Remind Me Later”

Caregiver reminders can be shown with permission.

==================================================
44. DATA / SYNC STATUS
==================================================

Create reusable status components:

Online
Offline
Syncing
Synced
Waiting to Sync
Sync Failed

Use consistent icons and badges.

==================================================
45. COMPONENT SYSTEM
==================================================

Create reusable Figma components and variants for:

Primary Button
Secondary Button
Large CTA
Voice Button
Audio Button
Recording Button
Status Badge
Screening Card
Patient Card
Language Card
Risk Card
Offline Banner
Sync Status
Waveform
Audio Player
Progress Indicator
Bottom Navigation
Top Navigation
Toggle
Modal
Confirmation Dialog
Toast
Loading State
Success State
Warning State
Error State

Create component variants rather than separate unrelated designs.

==================================================
46. FIGMA FILE STRUCTURE
==================================================

Organize the updated Figma file as:

00 — Cover

01 — Design System

02 — Patient App

03 — Voice Screening

04 — Results

05 — History & Trends

06 — Caregiver

07 — Health Worker

08 — Doctor

09 — Telemedicine

10 — Privacy & Settings

11 — Offline & Error States

12 — Prototype Flow

==================================================
47. FINAL PROTOTYPE CONNECTION
==================================================

Connect the main clickable prototype:

HOME
↓
START VOICE CHECK
↓
INTRODUCTION
↓
LISTEN
↓
TASK 1
↓
RECORD
↓
VOICE QUALITY CHECK
↓
REVIEW
↓
TASK 2
↓
RECORD
↓
QUALITY CHECK
↓
REVIEW
↓
TASK 3 MEMORY
↓
RECALL
↓
RECORD
↓
QUALITY CHECK
↓
REVIEW
↓
TASK 4
↓
RECORD
↓
QUALITY CHECK
↓
REVIEW
↓
COMPLETION
↓
PROCESSING
↓
RESULT

RESULT BRANCH:

LOW CONCERN
→ History
→ Trend

ELEVATED
→ Details
→ Caregiver
→ Healthcare Professional
→ Teleconsultation

UNCERTAIN
→ Try Again

OFFLINE
→ Save
→ Waiting to Sync
→ Sync Later

CAREGIVER:

Home
→ Someone is helping me
→ Caregiver Mode
→ Select Person
→ Start Screening

HEALTH WORKER:

Health Worker
→ Add Person
→ Select Language
→ Screening
→ Result
→ Follow-up
→ Sync

==================================================
48. FINAL DESIGN PHILOSOPHY
==================================================

SwarSanket should feel:

Simple for the elderly user.
Professional for healthcare workers.
Data-rich for doctors.
Reliable in low-connectivity environments.
Inclusive across Indian languages.
Calm and reassuring.
Modern but not overly futuristic.

The patient experience should essentially be:

LISTEN
↓
SPEAK
↓
CONTINUE
↓
DONE

The healthcare workflow should be:

SCREEN
↓
ANALYZE
↓
REVIEW
↓
REFER
↓
MONITOR

Do not overdesign.

Do not add unnecessary dashboards to the patient experience.

Do not expose technical AI/quantum terminology to patients.

Do not use alarming medical language.

Do not claim diagnosis.

Keep the existing visual identity intact and make all new screens look like they belong to the same SwarSanket application.
```

**One correction from your current gist:** I would **not call the picture task “Cookie Theft” by default** in the Figma/product spec. Use a properly licensed/permitted standardized image once your team decides the exact validated assessment protocol. For SIH, you can show a placeholder cognitive-description image in the prototype and explain the final assessment protocol separately.
