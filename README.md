# Sequence Alignment

## Development instructions

First of all we need to clone the repository to our local machine:

```
git clone https://github.com/UNDynamic-M2/sequence-alignment.git
```

Then to make a change we follow these steps:

1. Make the change (e.g. add/remove/amend file)
2. `git add .`
3. `git commit -m "message explaining the change"`
4. `git push`

To pull changes from the remote repository use:

```
git pull
```

## Usage

First, install the dependencies to use the tool (two ways):

```
./install.sh
```

or

```
Rscript install.R
```

Then you can use the tool as follows:

```
Rscript seqalign.R ATTGC ATACGACT --gap_open_penalty 12 --gap_extend_penalty 3 --subst_matrix examples/substitution-matrix
```

You can also provide sequences from text files:

```
Rscript seqalign.R examples/sequence-1 examples/sequence-2
```

In this case since we didn't provide the substitution matrix and the gap penalties, the default ones are used (see "Arguments and options").

## Arguments and options

The mandatory arguments are the two sequences.

The options are as follows:

| Name                         | Description                              | Type               | Default |
|------------------------------|------------------------------------------|--------------------|---------|
| `-p`, `--gap_open_penalty`   | The gap opening penalty                  | float              | 10      |
| `-e`, `--gap_extend_penalty` | The gap extension penalty                | float              | 0.5     |
| `-s`, `--subst_matrix`       | The substitution matrix used for scoring | string or filename | DNAFull |
| `-h`, `--help`               | Display the help page for the tool       | /                  | /       |

## Testing

To run the tests use:

```
./run-tests.sh
```
