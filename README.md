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

First, install the dependencies to use the tool (currently `optparse` is the only one):

```
Rscript install.R
```

Then you can use the tool as follows:

```
Rscript seqalign.R ATTGC ATACGACT --gap_open_penalty 12 --gap_extend_penalty 3 --subst_matrix "my_subst_matrix.txt"
```

The mandatory arguments are the two sequences.

The options are as follows:

| Name                 | Description                              | Type               | Default |
|----------------------|------------------------------------------|--------------------|---------|
| `gap_open_penalty`   | The gap opening penalty                  | float              | 10      |
| `gap_extend_penalty` | The gap extension penalty                | float              | 0.5     |
| `subst_matrix`       | The substitution matrix used for scoring | string or filename | DNAFull |
