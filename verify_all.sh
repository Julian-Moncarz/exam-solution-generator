#!/bin/bash
# Verifier script - runs headless Claude to verify each solution IN PARALLEL

PROJ_DIR="/Users/julianmoncarz/Projects/esc194-exam-solver"
QUESTIONS_DIR="$PROJ_DIR/questions"
SOLUTIONS_DIR="$PROJ_DIR/solutions"
VERIFIED_DIR="$PROJ_DIR/verified"

VERIFIER_PROMPT='You are a rigorous mathematics verifier checking exam solutions for ESC194 Calculus I.

Your task:
1. Check every mathematical step for correctness
2. Verify the final answer is correct
3. Check for any logical gaps or errors

If the solution is CORRECT:
- Output "VERIFIED" on the first line
- Then output the original solution unchanged

If there are ERRORS:
- Output "ERRORS FOUND" on the first line
- Briefly explain what was wrong
- Then provide the CORRECTED complete solution in LaTeX format

ORIGINAL QUESTION:
'

verify_solution() {
    local i=$1
    local QFILE="$QUESTIONS_DIR/q${i}.txt"
    local SOLFILE="$SOLUTIONS_DIR/q${i}_solution.tex"
    local OUTFILE="$VERIFIED_DIR/q${i}_verified.tex"
    
    if [ -f "$SOLFILE" ]; then
        QUESTION=$(cat "$QFILE")
        SOLUTION=$(cat "$SOLFILE")
        
        FULL_PROMPT="${VERIFIER_PROMPT}${QUESTION}

SOLUTION TO VERIFY:
${SOLUTION}"
        
        claude -p "$FULL_PROMPT" --output-format text > "$OUTFILE" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            FIRST_LINE=$(head -1 "$OUTFILE")
            if [[ "$FIRST_LINE" == *"VERIFIED"* ]]; then
                echo "  Q$i: VERIFIED"
            else
                echo "  Q$i: CORRECTED"
            fi
        else
            echo "  Q$i: ERROR"
        fi
    fi
}

export -f verify_solution
export PROJ_DIR QUESTIONS_DIR SOLUTIONS_DIR VERIFIED_DIR VERIFIER_PROMPT

echo "Verifying all 12 solutions in parallel..."

# Run all 12 in parallel
for i in $(seq -w 1 12); do
    verify_solution "$i" &
done

# Wait for all to complete
wait

echo "All verifications complete!"
