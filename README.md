# UNDynamic Local Sequence Alignment

Local sequence alignment using the Smith-Waterman algorithm.

## Usage

There are three ways you can use the tool, through a command line interface, manually running the R script through R studio, or a graphical user interface. The first one is preferred as it's more portable.

### Command Line Interface

- In the **BEAR Portal** launch an R session and in the terminal tab run the commands below (do **not** open the repository as a project as somehow it crashes).
- On your own machine just open a terminal window and run the commands below.

First, install the dependencies to use the tool. For UNIX systems:

```
./install.sh
```

or (Windows and UNIX):

```
Rscript install.R
```

If none of the above work, please install the packages manually in R:

```
deps = readLines("dependencies.txt")
install.packages(deps)
```

Then you can use the tool as follows:

```
Rscript seqalign.R ATTGC ATACGACT --gap_open_penalty 12 --gap_extend_penalty 3 --subst_matrix examples/substitution-matrix
```

You can also provide sequences from text files:

```
Rscript seqalign.R examples/example1-seq1 examples/example1-seq2
```

In this case since we didn't provide the substitution matrix and the gap penalties, the default ones are used (see "Arguments and options").

#### Arguments and options

The mandatory arguments are the two sequences.

The options are as follows:

| Name                         | Description                              | Type               | Default |
|------------------------------|------------------------------------------|--------------------|---------|
| `-p`, `--gap_open_penalty`   | The gap opening penalty                  | float              | 10      |
| `-e`, `--gap_extend_penalty` | The gap extension penalty                | float              | 0.5     |
| `-s`, `--subst_matrix`       | The substitution matrix used for scoring | string or filename | DNAFull |
| `-l`, `--parallel`           | Whether to run the algorithm in parallel | boolean            | false   |
| `-h`, `--help`               | Display the help page for the tool       | /                  | /       |

### Manual

You can run `seqalign_manual.R` through RStudio instead of the script through command line.

### Graphical user interface

The graphical user interface, is deployed as a web application at the following URL: https://undynamic.shinyapps.io/sequence-alignment

## Testing

To run the tests use:

```
./run-tests.sh
```
