configfile: "config/config.yaml"

rule all:
    input:
        "multiqc_report.html"

rule multiqc:
    input:
        expand("{sample}_fastqc.html", sample=config["SAMPLES"])
    output:
        "multiqc_report.html"
    wrapper:
        "v3.4.1/bio/multiqc"

rule cutadapt:
    input:
        ["data/{sample}.forward.fastqsanger", "data/{sample}.reverse.fastqsanger"],
    output:
        fastq1="trimmed/{sample}.1.fastq",
        fastq2="trimmed/{sample}.2.fastq"
    params:
        extra="-m 150 -q 20",
    log:
        "logs/cutadapt/{sample}.log"
    wrapper:
        "v3.5.0/bio/cutadapt/pe"

rule fastqc:
    input:
        "data/{sample}.fastqsanger"
    output:
        "{sample}_fastqc.html", "{sample}_fastqc.zip"
    params:
        extra = "--quiet"
    wrapper:
        "v3.4.1/bio/fastqc"

rule sortmerna_pe:
    input:
        ref=["database1.fa", "database2.fa"],
        reads=["trimmed/{sample}.1.fastq", "trimmed/{sample}.2.fastq"],
    output:
        aligned=["aligned_1.fastq.gz", "aligned_2.fastq.gz"],
        other=["unpaired_1.fastq.gz", "unpaired_2.fastq.gz"],
        stats="sortmerna_pe_stats.log",
    params:
        extra="--paired_out",
    log:
        "logs/sortmerna/reads_pe.log",
    wrapper:
        "v3.5.0/bio/sortmerna"

