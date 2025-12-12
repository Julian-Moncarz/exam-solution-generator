#!/bin/bash
# Solver script - runs headless Claude to solve each question IN PARALLEL

PROJ_DIR="/Users/julianmoncarz/Projects/esc194-exam-solver"
QUESTIONS_DIR="$PROJ_DIR/questions"
SOLUTIONS_DIR="$PROJ_DIR/solutions"

SOLVER_PROMPT='You are a calculus professor writing official exam solutions for ESC194 Calculus I at University of Toronto. 

Write a complete, step-by-step solution in LaTeX format. Include:
- Clear explanation of the approach
- All mathematical steps shown
- Brief justification for key steps
- Final answer boxed with \boxed{}

Use standard LaTeX math environments. Do NOT include document preamble - just the solution content starting from the question.

Format your response as pure LaTeX code that can be inserted into a document.

QUESTION:
'

solve_question() {
    local i=$1
    local QFILE="$QUESTIONS_DIR/q${i}.txt"
    local OUTFILE="$SOLUTIONS_DIR/q${i}_solution.tex"
    
    if [ -f "$QFILE" ]; then
        QUESTION=$(cat "$QFILE")
        claude -p "${SOLVER_PROMPT}${QUESTION}" --output-format text > "$OUTFILE" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "  Q$i: DONE"
        else
            echo "  Q$i: ERROR"
        fi
    fi
}

export -f solve_question
export PROJ_DIR QUESTIONS_DIR SOLUTIONS_DIR SOLVER_PROMPT

echo "Solving all 12 questions in parallel..."

# Run all 12 in parallel
for i in $(seq -w 1 12); do
    solve_question "$i" &
done

# Wait for all to complete
wait

echo "All questions solved!"
