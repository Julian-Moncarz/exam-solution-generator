# Exam Solution Generator

No solutions are posted for ESC194 past exams - this makes it hard to check your answers. To fix that: this is an automated pipeline that uses Claude Code headlessly to solve exam questions and generate step-by-step solution PDFs.
## How It Works

1. **Solve**: Runs 12 parallel Claude CLI calls to solve each question
2. **Verify**: Runs 12 parallel Claude CLI calls to verify each solution
3. **Assemble**: Combines all solutions into a LaTeX document
4. **Compile**: Generates a PDF with professional formatting

## Requirements

- [Claude Code]([https://docs.anthropic.com/en/docs/claude-cli](https://claude.com/product/claude-code)) (`claude` command)
- LaTeX compiler (`tectonic` or `pdflatex`)
- `pdftotext` (optional, for extracting questions from PDFs)

## Usage

### 1. Prepare Questions

Create question files in `questions/` directory:
```
questions/q01.txt
questions/q02.txt
...
questions/q12.txt
```

Each file should contain one exam question in plain text.

### 2. Run the Pipeline

```bash
bash run_pipeline.sh
```

This will:
- Solve all questions in parallel (~2-3 min)
- Verify all solutions in parallel (~2-3 min)
- Compile to PDF

### 3. Get Your Solutions

The final PDF will be saved to `~/Downloads/ESC194_2024_Exam_Solutions.pdf`

## Scripts

| Script | Description |
|--------|-------------|
| `run_pipeline.sh` | Master script - runs everything |
| `solve_all.sh` | Parallel solver using Claude CLI |
| `verify_all.sh` | Parallel verifier using Claude CLI |
| `assemble_latex_v2.sh` | Combines solutions into LaTeX |

## Directory Structure

```
.
├── questions/          # Input: exam questions (one per file)
├── solutions/          # Output: raw solutions from Claude
├── verified/           # Output: verified solutions
├── *.sh               # Pipeline scripts
└── *.tex / *.pdf      # Final output
```

## Customization

To adapt for different exams:

1. Extract questions from your exam PDF using `pdftotext`
2. Create `q01.txt` through `qNN.txt` files in `questions/`
3. Modify the solver prompt in `solve_all.sh` for subject-specific context
4. Run `bash run_pipeline.sh`

## Example

Originally built to solve University of Toronto ESC194 Calculus I final exams, but works for any subject where Claude can solve the problems.
