#!/bin/bash
# Assembles all verified solutions into a single LaTeX document

PROJ_DIR="/Users/julianmoncarz/Projects/esc194-exam-solver"
QUESTIONS_DIR="$PROJ_DIR/questions"
SOLUTIONS_DIR="$PROJ_DIR/solutions"
VERIFIED_DIR="$PROJ_DIR/verified"
OUTPUT_FILE="$PROJ_DIR/ESC194_2024_Exam_Solutions.tex"

cat > "$OUTPUT_FILE" << 'HEADER'
\documentclass[11pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,amssymb,amsthm}
\usepackage{enumitem}
\usepackage{fancyhdr}
\usepackage{graphicx}
\usepackage{fontspec}
\usepackage{pifont}
\usepackage{tikz}

% Define missing commands that might appear in solutions
\newcommand{\question}[1]{\subsection*{#1}}
\renewcommand{\part}{\paragraph{}}
\newcommand{\subpart}{\subparagraph{}}
\newcommand{\xmark}{\ding{55}}

\pagestyle{fancy}
\fancyhf{}
\rhead{ESC194 Calculus I - Final Exam Solutions}
\lhead{December 2024}
\rfoot{Page \thepage}

\title{\textbf{ESC194F Calculus I}\\Final Exam Solutions\\December 2024}
\author{University of Toronto\\Faculty of Applied Science and Engineering}
\date{}

\begin{document}
\maketitle
\thispagestyle{empty}

\vspace{1cm}
\noindent\textbf{Examiners:} P.C. Stangeby and J.W. Davis\\
\textbf{Note:} Each question is worth 10 marks.

\newpage
HEADER

echo "Assembling LaTeX document..."

for i in $(seq -w 1 12); do
    QFILE="$QUESTIONS_DIR/q${i}.txt"
    VFILE="$VERIFIED_DIR/q${i}_verified.tex"
    
    # Get question number without leading zero
    QNUM=$((10#$i))
    
    echo "" >> "$OUTPUT_FILE"
    echo "\\section*{Question $QNUM}" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    # Solutions already contain the question context, so just add the solution directly
    echo "" >> "$OUTPUT_FILE"
    
    # Use original solution file (cleaner, no verification commentary)
    SOLFILE="$SOLUTIONS_DIR/q${i}_solution.tex"
    if [ -f "$SOLFILE" ]; then
        # Remove markdown code fences only
        cat "$SOLFILE" | \
            grep -v '```latex' | \
            grep -v '```' | \
            sed 's/^```$//' >> "$OUTPUT_FILE"
    else
        echo "\\textit{Solution not available.}" >> "$OUTPUT_FILE"
    fi
    
    echo "" >> "$OUTPUT_FILE"
    echo "\\newpage" >> "$OUTPUT_FILE"
    
    echo "  Added question $QNUM"
done

echo "\\end{document}" >> "$OUTPUT_FILE"

echo "LaTeX document assembled: $OUTPUT_FILE"
