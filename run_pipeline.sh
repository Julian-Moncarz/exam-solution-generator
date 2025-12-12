#!/bin/bash
# Master script to run the entire exam solving pipeline

PROJ_DIR="/Users/julianmoncarz/Projects/esc194-exam-solver"
DOWNLOADS_DIR="/Users/julianmoncarz/Downloads"

echo "============================================"
echo "ESC194 Exam Solution Generator"
echo "============================================"
echo ""

# Step 1: Solve all questions
echo "STEP 1: Solving all questions with Claude..."
echo "--------------------------------------------"
bash "$PROJ_DIR/solve_all.sh"
echo ""

# Step 2: Verify all solutions
echo "STEP 2: Verifying all solutions..."
echo "--------------------------------------------"
bash "$PROJ_DIR/verify_all.sh"
echo ""

# Step 3: Assemble LaTeX
echo "STEP 3: Assembling LaTeX document..."
echo "--------------------------------------------"
bash "$PROJ_DIR/assemble_latex.sh"
echo ""

# Step 4: Compile PDF
echo "STEP 4: Compiling PDF..."
echo "--------------------------------------------"
cd "$PROJ_DIR"

# Use tectonic to compile
tectonic ESC194_2024_Exam_Solutions.tex 2>&1 | tail -5

if [ -f "$PROJ_DIR/ESC194_2024_Exam_Solutions.pdf" ]; then
    # Copy to Downloads
    cp "$PROJ_DIR/ESC194_2024_Exam_Solutions.pdf" "$DOWNLOADS_DIR/"
    echo "SUCCESS! PDF saved to: $DOWNLOADS_DIR/ESC194_2024_Exam_Solutions.pdf"
else
    echo "ERROR: PDF compilation failed. Check LaTeX file for errors."
    echo "LaTeX file location: $PROJ_DIR/ESC194_2024_Exam_Solutions.tex"
fi

echo ""
echo "============================================"
echo "Pipeline complete!"
echo "============================================"
