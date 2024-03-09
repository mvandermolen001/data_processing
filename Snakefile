configfile: "config/config.yaml"

rule all:
    input:
        "multiqc_report.html"

rule multiqc:
    input:
        expand("{sample}", sample=config["SAMPLES"])
    output:
        "multiqc_report.html"
    wrapper:
        "v3.4.1/bio/multiqc"

rule fastqc:
    input:
        "{sample}.fastqsanger"
    output:
        "{sample}_fastqc.html", "{sample}_fastqc.zip"
    params:
        extra = "--quiet"
    wrapper:
        "v3.4.1/bio/fastqc"
