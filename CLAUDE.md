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

## DayView Gesture System

`DayView` has a horizontal day-swipe gesture that must co-exist with the vertical `ScrollView`. The system is built around four state flags and a generation counter:

- `isDaySwipeActive` — horizontal swipe is in progress; drives `daySwipeOffset`
- `isDayScrollLocked` — vertical intent was detected first; blocks horizontal for this gesture
- `swipeConsumedTouch` — set when a swipe commits; blocks `Button` actions from firing on touch-up
- `isDayNavigating` — a commit animation is running (does NOT block new gestures)
- `navigationGeneration` — incremented whenever a navigation is interrupted; stale `withAnimation` completion blocks check this and no-op

**Rendering adjacent days:** Both the current and incoming day content are rendered simultaneously in a `ZStack`, driven by the same `daySwipeOffset`. The incoming view sits at `daySwipeOffset + incomingOffsetSign * screenWidth`. When the animation finishes at `±screenWidth`, the incoming view has landed at `0`. Then `currentDate` and `incomingDate` are updated atomically — no second animation phase, no visible jump.

**Gesture rules:**
- Direction is decided on the first `onChanged` sample where one axis is clearly dominant
- Vertical lock fires immediately when `abs(v) > abs(h)` (any angle > 45° from horizontal)
- Horizontal activates only when `abs(h) > abs(v) * 2.4` (≈ within ±22.5° of horizontal)
- This asymmetry is intentional — vertical scrolling is easy to start, horizontal swiping requires clear intent

## Common Pitfalls

**`onEnded` fires for all gestures, including vertical scrolls.**
`isDaySwipeActive` is reset to `false` at the top of `onEnded`. Never check it after resetting — capture it first: `let wasSwipeActive = isDaySwipeActive`. Gate all navigation commits and snap-back animations on `wasSwipeActive`. Without this, a long vertical scroll that drifts horizontally will trigger day navigation.

**Button tap fires in the same event cycle as `onEnded`.**
When a horizontal swipe ends, the `Button` underneath fires its action on the same touch-up event. `isDaySwipeActive` is already `false` by then, so it cannot be used as a gate. Instead, set a `swipeConsumedTouch` flag when the swipe activates, and reset it with `DispatchQueue.main.async { swipeConsumedTouch = false }` in `onEnded`. The deferred reset runs after the button action fires, blocking it. Gate the button action with `guard !swipeConsumedTouch else { return }`.

**Never block new gestures with `guard !isDayNavigating`.**
Users expect to be able to start the next swipe while the animation is still playing. Instead, when `onChanged` fires with `!isDaySwipeActive && !isDayScrollLocked && isDayNavigating`, snap the in-progress navigation to completion: increment `navigationGeneration`, set `currentDate = incomingDate`, clear `incomingDate`, zero `daySwipeOffset`, set `isDayNavigating = false`. The stale `withAnimation` completion block will fire but must no-op via the generation check.

**`withAnimation { } completion:` fires even when the animation is interrupted.**
Always guard completion blocks that mutate shared state: capture `let generation = navigationGeneration` before the animation, then `guard navigationGeneration == generation else { return }` at the top of the completion.

**`Range requires lowerBound <= upperBound` in `handleExerciseSave`.**
After `guard let exercises = routine?.exercises`, always also guard `selectedExerciseIndex < exercises.count` before using the index in ranges or array lookups. If the day changes while a detail view is open, `selectedExerciseIndex` can be stale and out-of-bounds for the new day's exercise list.

**Swift `Range` (`a..<b`) traps when `a > b` — it does not produce an empty range.**
This is unlike Python's `range()`. Always guard before constructing a range from runtime values.

## Build

```
xcodebuild -scheme FitnessApp -destination 'platform=iOS Simulator,name=iPhone 17'
```
