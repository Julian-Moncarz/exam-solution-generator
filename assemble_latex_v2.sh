#!/bin/bash
# Assembles all verified solutions into a single LaTeX document

PROJ_DIR="/Users/julianmoncarz/Projects/esc194-exam-solver"
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

# Process each question
for QNUM in 1 2 3 4 5 6 7 8 9 10 11 12; do
    # Pad with zero for file names
    if [ $QNUM -lt 10 ]; then
        PADDED="0$QNUM"
    else
        PADDED="$QNUM"
    fi
    
    SOLFILE="$PROJ_DIR/solutions/q${PADDED}_solution.tex"
    
    echo "" >> "$OUTPUT_FILE"
    echo "\\section*{Question $QNUM}" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    if [ -f "$SOLFILE" ]; then
        echo "  Adding Q$QNUM from $SOLFILE"
        # Remove markdown code fences and add content
        grep -v '```' "$SOLFILE" >> "$OUTPUT_FILE"
    else
        echo "  WARNING: $SOLFILE not found!"
        echo "\\textit{Solution not available.}" >> "$OUTPUT_FILE"
    fi
    
    echo "" >> "$OUTPUT_FILE"
    echo "\\newpage" >> "$OUTPUT_FILE"
done

echo "\\end{document}" >> "$OUTPUT_FILE"

echo "LaTeX document assembled: $OUTPUT_FILE"
echo "Line count: $(wc -l < "$OUTPUT_FILE")"
