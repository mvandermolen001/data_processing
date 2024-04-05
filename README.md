# Data processing: The ASaiM-MT pipeline for snakemake

In this repository you will the start of implementing part of the [ASaiM-MT pipeline](https://doi.org/10.12688/f1000research.28608.2). This concerns the 
trimming, quality control, alignment and counting off, and visualising paired end metatranscriptome data.

## Overview

The sequencing of microbiomes can often provide a wealth of knowledge on how such a community is build up.
This wealth of knowledge needs to be processed in a clear, reproducible, but still efficient way. The snakemake
library provides on all three fronts. It makes workflows easy to use and clear to reproduce. 


### Project structure

The file follows the following structure:

```bash
├───config
│   └───config.yaml
│   └───visual.yaml
├───data
├───logs
│   └───cutadapt
│   └───fastqc
│   └───mutliqc
├───result
│   └───fastq
│   └───krona
│   └───metaphlan
│   └───mutliqc
│   └───trimmed
├───workflow
│   └───alignment.smk
│   └───preprocess.smk
│   └───visualisations.smk
├───dag.pdf
├───README.md
├───Snakefile
```
The results of each tool gets put into its own designated directory, along with a log for each tool.
What will be the main interest here is the data map, where you put the data you want to process inside. In the config directory
you'll find the main config.yaml file where you put in your own configurations, this is explained further in the [usage](#-Usage) section.

## Requirements
Before you run this pipeline, make sure you have the following installed as conda environments.

- [Conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html) [version 24.1.2]
- [Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) [version 8.9.0]
- [MetaPhlan](https://huttenhower.sph.harvard.edu/metaphlan/) [version 4.1.0]

Be warned ahead of time though, MetaPhlan has databases provided which are quite big. It is best you store these
on a remote system rather than on your personal device. Another quick heads-up that you should make sure metaphlan is 
installed under the environment name "mpa".

With this in mind, for further installation I point to the provided documentation of these tools.

## Usage
Once all the requirements have been taken care off, you can make into the config directory and find the
config.yaml file. In here you will find two variables SAMPLES and path_to_database, put the start of the samples you want
to process in SAMPLES. This means if you have T1A_reverse.fastq and T1A_forward.fastq, you use T1A in the SAMPLES.
Put the absolute path to you database folder in the path_to_database. It might
look like the following.


```bash
path_to_database: /absolute/path/to/database
SAMPLES:
      -T1A
      -C3B
```

Now that you have the configurations set, the requirements have been met, move yourself inside the repository and
run the following command:

```bash
snakemake -c [INSERT AMOUNT OF CORES YOU DESIRE TO USE] --use-conda --conda-frontend conda
```

And that's it, your workflow should now be running. Depending on your data, the amount of cores, and other variables
this may take quite a bit. So please, make sure you run this workflow with the provided test data first. You
can find this in the /data folder.

## Contact
For any questions or feedback, you can email me at: m.van.der.molen@st.hanze.nl
