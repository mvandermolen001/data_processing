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
    log:
        "logs/fastqc/{sample}_forward.log"
    params:
        extra = "--quiet"
    wrapper:
        "v3.4.1/bio/fastqc"

rule fastqc_reverse:
    """Rule that creates the fastqc files for the forward samples"""
    input:
        "data/{sample}_reverse.fastq",
    output:
        html="result/fastqc/{sample}_reverse_fastqc.html",
        zip="result/fastqc/{sample}_reverse_fastqc.zip"
    params:
        extra = "--quiet"
    log:
        "logs/fastqc/{sample}_reverse.log"
    wrapper:
        "v3.4.1/bio/fastqc"

rule multiqc:
    """Rule that creates a multiqc file of the fastqc files"""
    input:
        expand("result/fastqc/{sample}_forward_fastqc.html", sample=config["SAMPLES"]),
        expand("result/fastqc/{sample}_reverse_fastqc.html", sample=config["SAMPLES"])
    log:
        "logs/multiqc/multiqc.log"
    output:
        "result/multiqc/multiqc_report.html"
    wrapper:
        "v3.4.1/bio/multiqc"

