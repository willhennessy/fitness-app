import Foundation

// Existing exercises retain their original IDs and presentation metadata. A routine
// may change only the prescription by calling `prescribed(sets:reps:)`.
private enum ExerciseCatalog {
    static let romanianDeadlift = Exercise(
        id: "romanian-deadlift", name: "Romanian Deadlift", sets: 4, reps: "6-8",
        images: ["https://weighttraining.guide/wp-content/uploads/2016/10/Barbell-Romanian-Deadlift.png"],
        cues: [
            "Soft knees; push hips back (hinge) instead of squatting down",
            "Keep spine neutral; lats tight; bar stays close to legs",
            "Lower until hamstrings are loaded; stand by driving hips forward"
        ],
        why: "Builds hamstrings/glutes and reinforces safe hinging mechanics that protect the low back and support running/lifting."
    )
    static let hipThrust = Exercise(
        id: "hip-thrust", name: "Hip Thrust", sets: 3, reps: "10",
        images: [
            "https://weighttraining.guide/wp-content/uploads/2021/06/Hip-thrust.png",
            "https://weighttraining.guide/wp-content/uploads/2021/08/barbell-glute-bridge.png"
        ],
        cues: [
            "Chin tucked; ribs down; core engaged",
            "Drive through heels; fully extend hips without low-back arch",
            "Hard glute squeeze for 1-2 seconds at the top"
        ],
        why: "Direct glute overload to support weak/tight hips and improve pelvis control for both lifting and running."
    )
    static let inclineDumbbellBenchPress = Exercise(
        id: "incline-db-press", name: "Incline Dumbbell Bench Press", sets: 4, reps: "6-8",
        images: ["https://weighttraining.guide/wp-content/uploads/2016/11/incline-dumbbell-bench-press-resized.png"],
        cues: [
            "Bench ~30-45°; wrists stacked over elbows",
            "Shoulder blades gently back/down; ribs not flared",
            "Lower with control; press up and slightly in"
        ],
        why: "Big upper-body builder with a shoulder-friendly angle; supports muscle gain and posture."
    )
    static let oneArmDumbbellRow = Exercise(
        id: "one-arm-db-row", name: "One-Arm Dumbbell Row", sets: 4, reps: "6-8 each side",
        images: ["https://weighttraining.guide/wp-content/uploads/2016/10/bent-over-one-arm-dumbbell-row-resized.png"],
        cues: [
            "Pull elbow toward hip; pause briefly at top",
            "Keep torso stable; avoid rotating open",
            "Control the lowering phase"
        ],
        why: "Balances pressing volume; builds mid-back/lats for shoulder health and strong posture."
    )
    static let latPulldown = Exercise(
        id: "lat-pulldown", name: "Lat Pulldowns", sets: 3, reps: "6-10",
        images: ["https://weighttraining.guide/wp-content/uploads/2017/01/Lat-pull-down-resized.png"],
        cues: [
            "Start from full stretch; pull elbows down to ribs",
            "Chest tall; avoid shrugging shoulders up",
            "Control the return; don't slam the stack"
        ],
        why: "Vertical pulling for lats and shoulder mechanics; improves durability and back development."
    )
    static let pallofPress = Exercise(
        id: "pallof-press", name: "Pallof Press", sets: 3, reps: "10 each side",
        images: ["https://weighttraining.guide/wp-content/uploads/2018/01/Cable-horizontal-Pallof-Press-2-resized.png"],
        cues: [
            "Ribs down, glutes lightly engaged",
            "Press straight out; resist rotation",
            "Move slow; hold 1 second extended"
        ],
        why: "Anti-rotation core stability—helps protect spine and improves force transfer in big lifts."
    )
    static let farmersCarry = Exercise(
        id: "farmers-carry", name: "Farmer's Carry", sets: 5, reps: "30-45s",
        images: ["https://weighttraining.guide/wp-content/uploads/2021/04/Dumbbell-farmers-walk-2.png"],
        cues: [
            "Stand tall: ribs stacked over pelvis",
            "Shoulders packed (don't shrug)",
            "Slow, controlled steps; no leaning"
        ],
        why: "Trains grip, posture, trunk stiffness, and calm strength—excellent for functional fitness and durability."
    )
    static let walk = Exercise(
        id: "walk", name: "Walk", sets: 1, reps: "30 mins",
        images: ["https://media.timeout.com/images/105305488/750/422/image.jpg"],
        cues: ["Easy pace — conversational effort", "Stay off your phone; let your mind rest too"],
        why: "Low-impact movement promotes blood flow, speeds recovery, and supports aerobic base without adding training stress.",
        isTimedOnly: true
    )
    static let hipFlexorStretch = Exercise(
        id: "hip-flexor-stretch", name: "Hip Flexor Stretch", sets: 1, reps: "60-120s each side",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Kneeling_Hip_Flexor/0.jpg"],
        cues: [
            "Posteriorly tilt pelvis slightly (glute on)",
            "Ribs down; don't arch low back to fake range",
            "Breathe slowly"
        ],
        why: "Opens hip flexors/quads to offset sitting and support hip mechanics for squats/running."
    )
    static let thoracicRotation = Exercise(
        id: "thoracic-rotation", name: "Thoracic Rotation", sets: 2, reps: "8-10 each side",
        images: ["https://homephysiotherapyexercises.com/wp-content/uploads/2026/09/open-book-ratotion.webp"],
        cues: [
            "Knees stacked; hips stacked", "Rotate through upper back, not lower spine",
            "Let breath drive the rotation", "Keep shoulder relaxed away from ear"
        ],
        why: "Improves posture, breathing, and shoulder mechanics — especially helpful with desk work."
    )

    // New catalog records introduced by this routine.
    static let barbellBackSquat = Exercise(
        id: "barbell-back-squat", name: "Barbell Back Squat", sets: 3, reps: "6-8",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Squat/0.jpg"],
        cues: ["Brace before every rep", "Keep a balanced tripod foot", "Drive knees in line with toes"],
        why: "Builds full-body strength with an emphasis on the quads, glutes, and trunk."
    )
    static let seatedCableRow = Exercise(
        id: "seated-cable-row", name: "Seated Cable Row", sets: 3, reps: "8-12",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Seated_Cable_Rows/0.jpg"],
        cues: ["Sit tall with ribs stacked", "Drive elbows back without shrugging", "Control the return to full reach"],
        why: "Develops the mid-back and lats while reinforcing stable, upright pulling mechanics."
    )
    static let easyCardio = Exercise(
        id: "easy-cardio", name: "Easy Cardio", sets: 1, reps: "10-15 min",
        images: ["https://media.timeout.com/images/105305488/750/422/image.jpg"],
        cues: ["Keep a conversational pace", "Choose a low-impact mode you enjoy", "Finish feeling refreshed"],
        why: "Adds low-intensity aerobic work without compromising recovery from strength training.",
        isTimedOnly: true
    )
    static let reverseLunge = Exercise(
        id: "reverse-lunge", name: "Reverse Lunge", sets: 2, reps: "8 per leg",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dumbbell_Rear_Lunge/0.jpg"],
        cues: ["Step back far enough to stay balanced", "Keep the front foot planted", "Drive through the front leg"],
        why: "Builds unilateral leg strength and hip stability with a controlled, knee-friendly pattern."
    )
    static let walkingLunge = Exercise(
        id: "walking-lunge", name: "Walking Lunge", sets: 2, reps: "8-10 steps per leg",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Bodyweight_Walking_Lunge/0.jpg"],
        cues: ["Step forward and lower with control", "Keep the front knee tracking with the toes", "Push through the front foot and step into the next lunge"],
        why: "Trains each leg through forward-moving lunges, building leg strength and balance."
    )
    static let bulgarianSplitSquat = Exercise(
        id: "bulgarian-split-squat", name: "Bulgarian Split Squat", sets: 2, reps: "8-10 per leg",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Split_Squat_with_Dumbbells/1.jpg"],
        cues: ["Rest your rear foot on a bench and keep the front foot planted", "Lower with control, keeping the front knee in line with the toes", "Drive through the front leg to stand; repeat on the other side"],
        why: "Builds single-leg strength and balance with an emphasis on the quads and glutes."
    )
    static let seatedHamstringCurl = Exercise(
        id: "seated-hamstring-curl", name: "Seated Hamstring Curl", sets: 3, reps: "10-12",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Seated_Leg_Curl/0.jpg"],
        cues: ["Align knees with the machine pivot and secure the thigh pad", "Curl the heels down and back while keeping hips against the seat", "Return slowly without letting the weight stack slam"],
        why: "Trains the hamstrings by bending the knees against resistance with the torso supported."
    )
    static let pushUps = Exercise(
        id: "push-ups", name: "Push-Ups", sets: 3, reps: "8-15",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Pushups/0.jpg"],
        cues: ["Keep head, hips, and heels aligned", "Lower with elbows at a comfortable angle", "Press the floor away"],
        why: "Trains horizontal pressing strength while challenging whole-body tension and shoulder-blade control."
    )
    static let facePull = Exercise(
        id: "face-pull", name: "Face Pull", sets: 2, reps: "12-15",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Face_Pull/1.jpg"],
        cues: ["Pull toward eye level", "Keep shoulders down", "Finish with hands outside elbows"],
        why: "Strengthens the rear shoulders and upper back to support balanced shoulder mechanics."
    )
    static let deadBug = Exercise(
        id: "dead-bug", name: "Dead Bug", sets: 2, reps: "8-10 per side",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dead_Bug/1.jpg"],
        cues: ["Keep the low back gently pressed down", "Move opposite arm and leg slowly", "Exhale as you extend"],
        why: "Builds coordinated core control while teaching the trunk to resist unwanted extension."
    )
    static let legPress = Exercise(
        id: "leg-press", name: "Leg Press", sets: 2, reps: "8-12",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Leg_Press/0.jpg"],
        cues: ["Keep hips and back against the pad", "Track knees with toes", "Use a controlled depth"],
        why: "Trains the quads and glutes with external stability and manageable whole-body fatigue."
    )
    static let dumbbellOverheadPress = Exercise(
        id: "dumbbell-overhead-press", name: "Dumbbell Overhead Press", sets: 3, reps: "8-10",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Dumbbell_Shoulder_Press/0.jpg"],
        cues: ["Stack ribs over pelvis", "Press without shrugging", "Lower under control"],
        why: "Builds shoulder and triceps strength through a stable vertical pressing pattern."
    )
    static let externalRotation = Exercise(
        id: "cable-band-external-rotation", name: "Cable/Band External Rotation", sets: 2, reps: "12-15",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/External_Rotation_with_Cable/0.jpg"],
        cues: ["Keep elbow lightly pinned to your side", "Use a light resistance", "Rotate without twisting your torso"],
        why: "Strengthens the rotator cuff to support shoulder control and pressing durability."
    )
    static let sidePlank = Exercise(
        id: "side-plank", name: "Side Plank", sets: 2, reps: "30-45 sec per side",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Side_Bridge/1.jpg"],
        cues: ["Make a straight line from head to feet", "Push the floor away", "Keep hips stacked"],
        why: "Develops lateral core endurance and resistance to unwanted side bending."
    )
    static let doorwayPecStretch = Exercise(
        id: "doorway-pec-stretch", name: "Doorway Pec Stretch", sets: 1, reps: "30 sec per side",
        images: ["https://homephysiotherapyexercises.com/wp-content/uploads/2025/09/The-Doorway-Shoulder-Stretch.webp"],
        cues: ["Keep the shoulder down", "Turn away gently", "Stop before any shoulder pinching"],
        why: "Gently opens the chest after sitting and pressing without turning recovery into another workout."
    )
    static let childsPoseSideReach = Exercise(
        id: "childs-pose-side-reach", name: "Child's Pose with Side Reach", sets: 1, reps: "30 sec per side",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Childs_Pose/0.jpg"],
        cues: ["Sit hips back comfortably", "Walk hands to one side", "Breathe into the side ribs"],
        why: "Provides a gentle lat, shoulder, and side-body stretch while encouraging relaxed breathing."
    )
    static let calfStretch = Exercise(
        id: "calf-stretch", name: "Calf Stretch", sets: 1, reps: "30 sec per side",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Calf_Stretch_Hands_Against_Wall/0.jpg"],
        cues: ["Keep the back heel down", "Point toes forward", "Use a gentle, steady stretch"],
        why: "Maintains comfortable ankle and calf mobility for walking, squatting, and lunging."
    )
    static let bodyweightSquats = Exercise(
        id: "bodyweight-squats", name: "Slow Bodyweight Squats", sets: 1, reps: "8-10",
        images: ["https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Bodyweight_Squat/1.jpg"],
        cues: ["Move slowly and comfortably", "Keep the whole foot grounded", "Use an easy pain-free depth"],
        why: "Moves the hips, knees, and ankles through a relaxed range without adding meaningful training fatigue."
    )
    static let longExhaleBreathing = Exercise(
        id: "long-exhale-breathing", name: "Long-Exhale Breathing", sets: 1, reps: "5 slow breaths",
        images: ["https://homephysiotherapyexercises.com/wp-content/uploads/2025/08/Breathing-1.webp"],
        cues: ["Inhale quietly through the nose", "Let the exhale last longer than the inhale", "Relax the jaw and shoulders"],
        why: "Finishes the mobility sequence with calm breathing that supports relaxation and recovery."
    )
}

private let mobilityRoutine = [
    ExerciseCatalog.walk.prescribed(sets: 1, reps: "20-30 min outdoors"),
    ExerciseCatalog.doorwayPecStretch,
    ExerciseCatalog.thoracicRotation.prescribed(sets: 1, reps: "6 per side"),
    ExerciseCatalog.childsPoseSideReach,
    ExerciseCatalog.hipFlexorStretch.prescribed(sets: 1, reps: "30 sec per side"),
    ExerciseCatalog.calfStretch,
    ExerciseCatalog.bodyweightSquats,
    ExerciseCatalog.longExhaleBreathing
]

let weeklyRoutine: [DayRoutine] = [
    DayRoutine(dayOfWeek: 0, name: "Main Full-Body Workout", exercises: [
        ExerciseCatalog.barbellBackSquat,
        ExerciseCatalog.inclineDumbbellBenchPress.prescribed(sets: 3, reps: "8-10"),
        ExerciseCatalog.seatedCableRow,
        ExerciseCatalog.romanianDeadlift.prescribed(sets: 2, reps: "8"),
        ExerciseCatalog.latPulldown.prescribed(sets: 2, reps: "8-12"),
        ExerciseCatalog.pallofPress.prescribed(sets: 2, reps: "10 per side"),
        ExerciseCatalog.farmersCarry.prescribed(sets: 2, reps: "30-45 sec"),
        ExerciseCatalog.easyCardio
    ]),
    DayRoutine(dayOfWeek: 1, name: "Walk + Mobility", exercises: mobilityRoutine),
    DayRoutine(dayOfWeek: 2, name: "Glutes + Unilateral Legs + Upper Body", exercises: [
        ExerciseCatalog.hipThrust.prescribed(sets: 3, reps: "8-10"),
        ExerciseCatalog.walkingLunge,
        ExerciseCatalog.pushUps,
        ExerciseCatalog.oneArmDumbbellRow.prescribed(sets: 3, reps: "8-12 per side"),
        ExerciseCatalog.facePull,
        ExerciseCatalog.deadBug
    ]),
    DayRoutine(dayOfWeek: 3, name: "Walk + Mobility", exercises: mobilityRoutine),
    DayRoutine(dayOfWeek: 4, name: "Shoulders + Posterior Chain + Lighter Legs", exercises: [
        ExerciseCatalog.legPress,
        ExerciseCatalog.latPulldown.prescribed(sets: 3, reps: "8-12"),
        ExerciseCatalog.dumbbellOverheadPress,
        ExerciseCatalog.bulgarianSplitSquat,
        ExerciseCatalog.externalRotation,
        ExerciseCatalog.sidePlank,
        ExerciseCatalog.easyCardio.prescribed(sets: 1, reps: "10 min")
    ]),
    DayRoutine(dayOfWeek: 5, name: "Walk + Mobility", exercises: mobilityRoutine),
    DayRoutine(dayOfWeek: 6, name: "Rest Day", exercises: [])
]

func getRoutineForDay(_ dayOfWeek: Int) -> DayRoutine? {
    weeklyRoutine.first { $0.dayOfWeek == dayOfWeek }
}

func isRestDay(_ dayOfWeek: Int) -> Bool {
    guard let routine = getRoutineForDay(dayOfWeek) else { return true }
    return routine.exercises.isEmpty
}
