configfile: "config/config.yaml"

rule all:
    """Rule that defines the outputs you want and the wildcards used in the creation of said outputs"""
    input:
        "result/multiqc/multiqc_report.html",
        expand("result/trimmed/{sample}_forward.fastq", sample=config["SAMPLES"]),
        expand("result/trimmed/{sample}_reverse.fastq", sample=config["SAMPLES"]),
        expand("result/trimmed/{sample}.qc.txt", sample=config["SAMPLES"]),

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


## TODO: Wonder if sortmerna is truly needed as the next step uses the cutadapt results

# rule sortmerna_pe:
#     input:
#         ref=["rfam-5s-database-id98.fa", "silva-arc-23s-id98", "silva-euk-28s-id98", "silva-bac-23s-id98",
#              "silva-euk-18s-id95", "silva-bac-16s-id90", "rfam-5.8s-database-id98", "silva-arc-16s-id95"],
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

