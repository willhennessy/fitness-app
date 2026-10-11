# Decisions

### Historical workout defaults — 2026-10-11

**Context**  
The previous helper checked only the same weekday over four weeks and could select skipped entries. User requested typical historical defaults excluding days with zeros.

**Decision**  
Use the mode of complete workout tuples across all prior dates for the same exercise ID. Break frequency ties with the latest workout date, then log timestamp. Strength needs positive sets/reps and nonnegative weight; timed work needs positive minutes; runs need positive finite distance and positive minutes. Zero weight is valid bodyweight work. Same-day saved entries remain authoritative. Without valid history, use the prescribed routine defaults. Calculate on-device without rewriting history.

**Consequences**  
Exercise defaults follow actual logged combinations and are independent of weekday. Older history contributes; newer one-off changes do not outweigh repeated sessions. Existing helper names remain for compatibility. This intentionally supersedes the four-week behavior described in CLAUDE.md; that instruction file was left unchanged pending user approval.
