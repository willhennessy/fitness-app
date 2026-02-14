# Fitness App

iOS app for logging daily workouts — weight, sets, and reps. Built with SwiftUI, targeting iOS 17+. Single-user, no backend.

## Architecture

- **SwiftUI + @StateObject** — `StorageManager` is the single source of truth, injected via `.environmentObject()`
- **UserDefaults persistence** — workout logs stored as JSON via `Codable`. No Core Data or SwiftData
- **Static routine data** — the weekly routine lives in `Data/Routine.swift` as a hardcoded array. Only logged exercises are persisted
- **Manual navigation** — uses `@State` + conditional views with custom transitions, not `NavigationStack`

## Project Structure

```
FitnessApp/
├── FitnessApp.swift        # App entry point, splash screen logic
├── Models/                  # Data types: Exercise, DayRoutine, LoggedExercise, DayEntry
├── Views/                   # All UI: DayView (main), ExerciseDetail, ExerciseCard, WorkoutStepper
├── Services/                # StorageManager (persistence + state)
├── Data/                    # Routine.swift (hardcoded weekly workout plan)
├── Utilities/               # DateHelpers (formatting, last-week lookup)
└── Extensions/              # Color+App (theme colors via hex)
```

## Key Patterns

- Colors are defined as static extensions on `Color` in `Extensions/Color+App.swift` — always use `Color.appPrimary`, `Color.appBackground`, etc. Never use raw hex values in views
- Exercise images are remote URLs loaded via `AsyncImage`, not bundled assets
- `getLastWeekValues()` in `DateHelpers.swift` pre-fills form inputs from the last 4 weeks of history
- Rest days are detected by `exercises.isEmpty` on a `DayRoutine`, not a separate flag
- Date keys use ISO 8601 format (`formatISO()`) for storage lookups

## Style

- Dark mode only (forced via `.preferredColorScheme(.dark)`)
- Solarized-inspired color palette
- System fonts with explicit size/weight — no custom fonts
- 16px horizontal padding is the standard content margin

## Build

```
xcodebuild -scheme FitnessApp -destination 'platform=iOS Simulator,name=iPhone 16'
```
