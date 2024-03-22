configfile: "config/config.yaml"

rule all:
    """Rule that defines the outputs you want and the wildcards used in the creation of said outputs"""
    input:
        "result/multiqc/multiqc_report.html",
        expand("result/trimmed/{sample}_forward.fastq", sample=config["SAMPLES"]),
        "result/metaphlan/metagenome.bowtie2.bz2",
        # expand("result/sort/{sample}_aligned_1.fastq.gz", sample=config["SAMPLES"]),
        # expand("result/sort/{sample}_aligned_2.fastq.gz", sample=config["SAMPLES"]),
        # expand("sortmerna_pe_stats_{sample}.log", sample=config["SAMPLES"]),

rule multiqc:
    """Rule that creates a multiqc file of the fastqc files"""
    input:
        expand("result/fastqc/{sample}_forward_fastqc.html", sample=config["SAMPLES"]),
        expand("result/fastqc/{sample}_reverse_fastqc.html", sample=config["SAMPLES"])
    output:
        "result/multiqc/multiqc_report.html"
    wrapper:
        "v3.4.1/bio/multiqc"

rule cutadapt:
    """Rule that trims the fastq files"""
    input:
        ["data/{sample}_forward.fastq", "data/{sample}_reverse.fastq"],
    output:
        fastq1="result/trimmed/{sample}_forward.fastq",
        fastq2="result/trimmed/{sample}_reverse.fastq",
        qc="result/trimmed/{sample}.qc.txt",
    params:
        extra="-m 150 -q 20",
    log:
        "logs/cutadapt/{sample}.log"
    wrapper:
        "v3.5.0/bio/cutadapt/pe"

rule fastqc_forward:
    """Rule that creates the fastqc files for the forward samples"""
    input:
        "data/{sample}_forward.fastq",
    output:
        html="result/fastqc/{sample}_forward_fastqc.html",
        zip="result/fastqc/{sample}_forward_fastqc.zip"
    params:
        extra = "--quiet"
    wrapper:
        "v3.4.1/bio/fastqc"

rule fastqc_reverse:
    """Rule that creates the fastqc files for the reverse samples"""
    input: "data/{sample}_reverse.fastq",
    output:
        html="result/fastqc/{sample}_reverse_fastqc.html",
        zip="result/fastqc/{sample}_reverse_fastqc.zip"
    params:
        extra="--quiet"
    wrapper:
        "v3.4.1/bio/fastqc"

## TODO: Check how those databases work with this tool and this wrapper

# rule sortmerna_pe:
#     input:
#         ref=["rfam-5s-database-id98.fasta", "silva-arc-23s-id98.fasta", "silva-euk-28s-id98.fasta", "silva-bac-23s-id98.fasta",
#              "silva-euk-18s-id95.fasta", "silva-bac-16s-id90.fasta", "rfam-5.8s-database-id98.fasta", "silva-arc-16s-id95.fasta"],
#         reads=["result/trimmed/{sample}_forward.fastq", "result/trimmed/{sample}_reverse.fastq"],
#     output:
#         aligned=["result/sort/{sample}_aligned_1.fastq.gz", "result/sort/{sample}_aligned_2.fastq.gz"],
#         other=["result/sort/{sample}_unpaired_1.fastq.gz", "result/sort/{sample}_unpaired_2.fastq.gz"],
#         stats="sortmerna_pe_stats_{sample}.log",
#     params:
#         extra="--paired_out",
#     threads: 8,
#     log:
#         "logs/sortmerna/reads_pe_{sample}.log",
#     wrapper:
#         "v3.5.0/bio/sortmerna"

rule metaphlan:
    input:
        fastq_forward = expand("result/trimmed/{sample}_forward.fastq", sample=config["SAMPLES"]),
        fastq_reverse = expand("result/trimmed/{sample}_reverse.fastq", sample=config["SAMPLES"])
    output:
        "result/metaphlan/metagenome.bowtie2.bz2",
        "profiled_metagenome.txt"
    conda:
        "config/trimming.yaml",
    shell:
        """
            metaphlan2.py {input.fastq_forward}, {input.fastq_reverse} --bowtie2out result/metaphlan/metagenome.bowtie2.bz2 --input_type fastq > profiled_metagenome.txt
        """

