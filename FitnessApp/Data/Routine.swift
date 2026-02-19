import Foundation

let weeklyRoutine: [DayRoutine] = [
    DayRoutine(
        dayOfWeek: 0, // Sunday - Mobility
        name: "Mobility",
        exercises: [
            Exercise(
                id: "hip-flexor-stretch",
                name: "Hip Flexor Stretch",
                sets: 1,
                reps: "60-120s each side",
                images: ["https://www.garagegymreviews.com/wp-content/uploads/2024/10/couch-stretch-cover.jpg"],
                cues: [
                    "Posteriorly tilt pelvis slightly (glute on)",
                    "Ribs down; don't arch low back to fake range",
                    "Breathe slowly"
                ],
                why: "Opens hip flexors/quads to offset sitting and support hip mechanics for squats/running."
            ),
            Exercise(
                id: "90-90-hip-rotations",
                name: "90/90 Hip Rotations",
                sets: 2,
                reps: "8-10 slow reps each side",
                images: ["https://cdn.muscleandstrength.com/sites/default/files/9090-hip-crossover.jpg"],
                cues: [
                    "Tall spine; move slowly",
                    "Try to rotate at the hips, not by twisting the low back",
                    "Stay pain-free; control over range"
                ],
                why: "Builds internal/external hip rotation—key for hip longevity and reducing groin/knee tension."
            ),
            Exercise(
                id: "pigeon-pose",
                name: "Pigeon Pose",
                sets: 1,
                reps: "60-120s each side",
                images: [
                    "https://cdn.shopify.com/s/files/1/0053/0114/1604/files/natural-force-blog-natural-force-blog-yoga-poses-recovery-featured_v1.jpg?v=1547164717"
                ],
                cues: [
                    "Relax into the stretch gradually",
                    "No forcing depth"
                ],
                why: "Opens glutes and deep hip muscles that get tight from lifting."
            ),
            Exercise(
                id: "thoracic-rotation",
                name: "Thoracic Rotation",
                sets: 2,
                reps: "8-10 each side",
                images: [
                    "https://cdn.muscleandstrength.com/sites/default/files/squat-to-stand-with-t-spine-rotation.jpg"
                ],
                cues: [
                    "Knees stacked; hips stacked",
                    "Rotate through upper back, not lower spine",
                    "Let breath drive the rotation",
                    "Keep shoulder relaxed away from ear"
                ],
                why: "Improves posture, breathing, and shoulder mechanics — especially helpful with desk work."
            ),
            Exercise(
                id: "ankle-dorsiflexion",
                name: "Ankle Dorsiflexion (Knee-to-Wall)",
                sets: 2,
                reps: "10-15 each side",
                images: [
                    "https://images.bannerbear.com/direct/4mGpW3zwpg0ZK0AxQw/requests/000/095/372/102/APW1bDp49YKOr2rLYjmVoORax/9b0e32bfe12e8bef9793ff408ffed724bf07cd08.jpg"
                ],
                cues: [
                    "Heel stays down",
                    "Knee tracks over toes (don't collapse inward)",
                    "Smooth reps; no pinching pain"
                ],
                why: "Ankle mobility supports better squat mechanics and reduces compensations that can show up as knee/hip issues."
            )
        ]
    ),
    DayRoutine(
        dayOfWeek: 1, // Monday - Lower Body
        name: "Lower Body",
        exercises: [
            Exercise(
                id: "squats",
                name: "Squats (Barbell OR Dumbbell Goblet)",
                sets: 4,
                reps: "6",
                images: [
                    "https://cdn.muscleandstrength.com/sites/default/files/barbell-back-squat.jpg",
                    "https://cdn.muscleandstrength.com/sites/default/files/dumbbell-goblet-squat-1.jpg"
                ],
                cues: [
                    "Brace: ribs down, 360° core tension before each rep",
                    "Tripod foot: big toe, little toe, heel all loaded",
                    "Knees track over mid-foot; don't cave inward",
                    "Controlled descent; drive up through the floor"
                ],
                why: "Primary leg builder for quads/glutes and full-body strength; foundational for longevity and athletic capacity."
            ),
            Exercise(
                id: "romanian-deadlift",
                name: "Romanian Deadlift",
                sets: 4,
                reps: "6-8",
                images: [
                    "https://weighttraining.guide/wp-content/uploads/2016/10/Barbell-Romanian-Deadlift.png"
                ],
                cues: [
                    "Soft knees; push hips back (hinge) instead of squatting down",
                    "Keep spine neutral; lats tight; bar stays close to legs",
                    "Lower until hamstrings are loaded; stand by driving hips forward"
                ],
                why: "Builds hamstrings/glutes and reinforces safe hinging mechanics that protect the low back and support running/lifting."
            ),
            Exercise(
                id: "bulgarian-split-squat",
                name: "Bulgarian Split Squat",
                sets: 3,
                reps: "8 each leg",
                images: [
                    "https://weighttraining.guide/wp-content/uploads/2021/10/Bulgarian-split-squat.png"
                ],
                cues: [
                    "Start with a stable stance; front foot far enough forward to keep balance",
                    "Torso tall; descend under control",
                    "Drive through full front foot; knee tracks with toes"
                ],
                why: "Single-leg strength + hip stability; reduces left/right imbalances and supports knee/hip longevity."
            ),
            Exercise(
                id: "hip-thrust",
                name: "Hip Thrust",
                sets: 3,
                reps: "10",
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
            ),
            Exercise(
                id: "hanging-knee-raises",
                name: "Hanging Knee Raises",
                sets: 3,
                reps: "8-12",
                images: [
                    "https://weighttraining.guide/wp-content/uploads/2016/10/Hanging-leg-hip-raise-resized.png"
                ],
                cues: [
                    "Start from a dead hang; shoulders down away from ears",
                    "Initiate by posteriorly tilting pelvis (curl, don't swing)",
                    "Control the lowering phase; no momentum"
                ],
                why: "Builds anterior core + hip flexor strength and improves trunk control under fatigue."
            )
        ]
    ),
    DayRoutine(
        dayOfWeek: 2, // Tuesday - Conditioning
        name: "Conditioning",
        exercises: [
            Exercise(
                id: "run-5k",
                name: "Run",
                sets: 1,
                reps: "3.1 mi",
                images: ["https://hips.hearstapps.com/hmg-prod/images/young-man-running-outdoors-in-morning-royalty-free-image-1717693611.jpg?crop=0.628xw:0.940xh;0.0705xw,0.0600xh&resize=1200:*"],
                cues: [
                    "You should be able to speak in full sentences",
                    "Nasal breathing most of the time if possible",
                    "Finish feeling better, not destroyed"
                ],
                why: "Aerobic base is a major lever for daily energy, stress tolerance, and long-term cardiovascular health.",
                isRun: true
            ),
            Exercise(
                id: "farmers-carry",
                name: "Farmer's Carry",
                sets: 5,
                reps: "30-45s",
                images: [
                    "https://weighttraining.guide/wp-content/uploads/2021/04/Dumbbell-farmers-walk-2.png"
                ],
                cues: [
                    "Stand tall: ribs stacked over pelvis",
                    "Shoulders packed (don't shrug)",
                    "Slow, controlled steps; no leaning"
                ],
                why: "Trains grip, posture, trunk stiffness, and calm strength—excellent for functional fitness and durability."
            )
        ]
    ),
    DayRoutine(
        dayOfWeek: 3, // Wednesday - Upper Body
        name: "Upper Body",
        exercises: [
            Exercise(
                id: "incline-db-press",
                name: "Incline Dumbbell Bench Press",
                sets: 4,
                reps: "6-8",
                images: [
                    "https://weighttraining.guide/wp-content/uploads/2016/11/incline-dumbbell-bench-press-resized.png"
                ],
                cues: [
                    "Bench ~30-45°; wrists stacked over elbows",
                    "Shoulder blades gently back/down; ribs not flared",
                    "Lower with control; press up and slightly in"
                ],
                why: "Big upper-body builder with a shoulder-friendly angle; supports muscle gain and posture."
            ),
            Exercise(
                id: "one-arm-db-row",
                name: "One-Arm Dumbbell Row",
                sets: 4,
                reps: "6-8 each side",
                images: [
                    "https://weighttraining.guide/wp-content/uploads/2016/10/bent-over-one-arm-dumbbell-row-resized.png"
                ],
                cues: [
                    "Pull elbow toward hip; pause briefly at top",
                    "Keep torso stable; avoid rotating open",
                    "Control the lowering phase"
                ],
                why: "Balances pressing volume; builds mid-back/lats for shoulder health and strong posture."
            ),
            Exercise(
                id: "lat-pulldown",
                name: "Lat Pulldowns",
                sets: 3,
                reps: "6-10",
                images: [
                    "https://weighttraining.guide/wp-content/uploads/2017/01/Lat-pull-down-resized.png"
                ],
                cues: [
                    "Start from full stretch; pull elbows down to ribs",
                    "Chest tall; avoid shrugging shoulders up",
                    "Control the return; don't slam the stack"
                ],
                why: "Vertical pulling for lats and shoulder mechanics; improves durability and back development."
            ),
            Exercise(
                id: "lateral-raise",
                name: "Dumbbell Lateral Raises",
                sets: 3,
                reps: "12-15",
                images: [
                    "https://weighttraining.guide/wp-content/uploads/2016/05/dumbbell-lateral-raise-resized.png"
                ],
                cues: [
                    "Use light weight; minimal body swing",
                    "Raise to ~shoulder height; slight elbow bend",
                    "Think 'reach out', not 'shrug up'"
                ],
                why: "Direct shoulder hypertrophy (side delts) with low joint stress; helps build frame."
            ),
            Exercise(
                id: "hammer-curl",
                name: "Dumbbell Hammer Curls",
                sets: 3,
                reps: "10-12",
                images: [
                    "https://weighttraining.guide/wp-content/uploads/2016/11/Dumbbell-Hammer-Curl-resized.png"
                ],
                cues: [
                    "Elbows stay near sides; no swinging",
                    "Full range; controlled lowering",
                    "Grip strong; keep wrists neutral"
                ],
                why: "Builds arms + forearms and supports elbow health; good complementary biceps work."
            ),
            Exercise(
                id: "pallof-press",
                name: "Pallof Press",
                sets: 3,
                reps: "10 each side",
                images: [
                    "https://weighttraining.guide/wp-content/uploads/2018/01/Cable-horizontal-Pallof-Press-2-resized.png"
                ],
                cues: [
                    "Ribs down, glutes lightly engaged",
                    "Press straight out; resist rotation",
                    "Move slow; hold 1 second extended"
                ],
                why: "Anti-rotation core stability—helps protect spine and improves force transfer in big lifts."
            )
        ]
    ),
    DayRoutine(
        dayOfWeek: 4, // Thursday - Rest
        name: "Rest Day",
        exercises: []
    ),
    DayRoutine(
        dayOfWeek: 5, // Friday - Full Body
        name: "Full Body",
        exercises: [
            Exercise(
                id: "trap-bar-deadlift",
                name: "Trap Bar Deadlift",
                sets: 4,
                reps: "5",
                images: [
                    "https://weighttraining.guide/wp-content/uploads/2019/11/Trap-bar-deadlift-resized.png"
                ],
                cues: [
                    "Brace before pull; shoulders packed",
                    "Drive through floor; stand tall at top (no lean-back)",
                    "Control the descent; keep spine neutral"
                ],
                why: "High-return total-body strength builder that's often easier on the low back than straight-bar deadlifts."
            ),
            Exercise(
                id: "walking-lunge",
                name: "Dumbbell Walking Lunges",
                sets: 3,
                reps: "10 steps each leg",
                images: [
                    "https://cdn.muscleandstrength.com/sites/default/files/dumbbell-walking-lunge.jpg"
                ],
                cues: [
                    "Tall torso; step long enough for control",
                    "Front knee tracks with toes",
                    "Drive through mid-foot; smooth rhythm"
                ],
                why: "Single-leg strength + conditioning effect; strong carryover to running and long-term hip/knee resilience."
            ),
            Exercise(
                id: "half-kneeling-press",
                name: "Half-Kneeling Dumbbell Shoulder Press",
                sets: 3,
                reps: "8-10",
                images: [
                    "https://cdn.muscleandstrength.com/sites/default/files/half-kneeling-dumbbell-press.jpg"
                ],
                cues: [
                    "Glute of kneeling leg on; ribs down",
                    "Press slightly forward, not straight back",
                    "No side-bending; stay stacked"
                ],
                why: "Shoulder-friendly pressing + core/hip stability; good replacement for landmine press in your program."
            ),
            Exercise(
                id: "chest-supported-row",
                name: "Chest-Supported Row",
                sets: 3,
                reps: "10",
                images: [
                    "https://i0.wp.com/www.strengthlog.com/wp-content/uploads/2024/11/chest-supported-dumbbell-row.gif?resize=600%2C600&ssl=1"
                ],
                cues: [
                    "Chest glued to pad; no lower-back cheating",
                    "Pull elbows back; brief squeeze at top",
                    "Control the lowering phase"
                ],
                why: "Builds back thickness while minimizing low-back fatigue—great pairing with deadlifts."
            ),
            Exercise(
                id: "incline-db-curl",
                name: "Incline Dumbbell Curl",
                sets: 3,
                reps: "10-12",
                images: [
                    "https://weighttraining.guide/wp-content/uploads/2017/01/Incline-Dumbbell-Curl-resized.png"
                ],
                cues: [
                    "Upper arm stays back; don't swing forward",
                    "Full stretch at bottom; slow eccentric",
                    "Supinate as you curl; squeeze at top"
                ],
                why: "Excellent hypertrophy stimulus because it loads biceps in a lengthened position and reduces cheating."
            ),
            Exercise(
                id: "battle-ropes",
                name: "Finisher: Battle Ropes",
                sets: 7,
                reps: "20-40s",
                images: [
                    "https://hips.hearstapps.com/hmg-prod/images/gettyimages-657495548-1527710829.jpg?crop=0.6674528301886793xw:1xh;center,top&resize=1200:*"
                ],
                cues: [
                    "Keep it snappy and technical — don't redline into sloppy form",
                    "Stop the finisher while you still feel coordinated"
                ],
                why: "Adds athletic conditioning without derailing strength progress; supports work capacity and energy."
            )
        ]
    ),
    DayRoutine(
        dayOfWeek: 6, // Saturday - Rest
        name: "Rest Day",
        exercises: []
    )
]

func getRoutineForDay(_ dayOfWeek: Int) -> DayRoutine? {
    weeklyRoutine.first { $0.dayOfWeek == dayOfWeek }
}

func isRestDay(_ dayOfWeek: Int) -> Bool {
    guard let routine = getRoutineForDay(dayOfWeek) else { return true }
    return routine.exercises.isEmpty
}
