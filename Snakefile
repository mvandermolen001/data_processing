configfile: "config/config.yaml"

rule all:
    input:
        "result/multiqc/multiqc_report.html",
        expand("result/trimmed/{sample}.fastq", sample=config["forward_sample"]),
        expand("result/trimmed/{sample}.fastq", sample=config["reverse_sample"]),
        # expand("result/sort/{sample}.fastq.gz", sample=config["forward_sample"]),
        # expand("result/sort/{sample}.fastq.gz", sample=config["reverse_sample"]),

rule multiqc:
    input:
        expand("result/fastqc/{sample}_fastqc.html", sample=config["SAMPLES"])
    output:
        "result/multiqc/multiqc_report.html"
    wrapper:
        "v3.4.1/bio/multiqc"

rule cutadapt:
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

rule fastqc:
    input:
        "data/{sample}.fastq"
    output:
        html="result/fastqc/{sample}_fastqc.html",
        zip="result/fastqc/{sample}_fastqc.zip"
    params:
        extra = "--quiet"
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

