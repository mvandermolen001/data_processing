configfile: "config/config.yaml"
report: "report/workflow.rst"

rule all:
    """Rule that defines the outputs you want and the wildcards used in the creation of said outputs"""
    input:
        "result/multiqc/multiqc_report.html",
        expand("result/trimmed/{sample}_forward.fastq", sample=config["SAMPLES"]),
        expand("result/trimmed/{sample}_reverse.fastq", sample=config["SAMPLES"]),
        expand("result/metaphlan/{sample}_metagenome.bowtie2.bz2", sample=config["SAMPLES"]),
        expand("result/metaphlan/{sample}_profiled_metagenome.txt", sample=config["SAMPLES"]),
        expand("result/metaphlan/{sample}_profiled_meta_to_krona.txt", sample=config["SAMPLES"]),
        expand("result/krona/{sample}_piechart.html", sample=config["SAMPLES"])

include: "workflow/preprocess.smk"
include: "workflow/alignment.smk"
include: "workflow/visualisations.smk"


