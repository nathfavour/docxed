# Tadlete Telegram Android Contest Plan

1. **Preparation**
   - Review the provided mockups and animated demos for the new profile screens.
   - Study the Telegram Android codebase structure (see `tree.md`).
   - Ensure your development environment matches the requirements (Java, no third-party UI frameworks, Android Studio 3.4+, NDK r20, SDK 8.1).

2. **Design & Architecture**
   - Identify all profile-related screens: user, business, group, channel, including groups with topics and gift displays.
   - Plan new layouts and transitions for these screens, supporting both day and night themes.
   - Decide which existing components can be reused and which should be rebuilt from scratch for better maintainability and to avoid legacy bugs.

3. **Implementation**
   - Implement the new profile screens and flows, strictly following the mockups and animated transitions.
   - Ensure all profile tabs and related instances are covered.
   - Integrate floating icons logic (custom appearance, active gifts) as per clarifications.
   - Support camera cutout and device-specific UI nuances.
   - Optionally, redesign the Settings screen as a bonus.

4. **Testing & Validation**
   - Test all new screens for stability, performance, and visual correctness on various Android devices.
   - Check for and fix any crashes, glitches, or layout errors.
   - Validate that all transitions and UI behaviors match the provided demos.

5. **Finalization**
   - Replace any placeholder assets (keystore, google-services.json, BuildVars) with your own before publishing.
   - Prepare a clean commit history and documentation for submission.
   - Build the APK and push your code to a public GitHub repository.

6. **Submission**
   - Submit both the APK and the GitHub repository link as per contest instructions.

> Focus on code quality, UI polish, and strict adherence to the contest requirements and mockups.

this codebase is used by a billion people so we want to ensrure professionalism.we also don't want to reimplement; instead integrate. infact, we want to implement our changes as modularly as possible so we can revert back to previous state if so needed. we want to integrate seamlessly, as though we owned the codebase.