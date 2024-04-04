rule metaphlan:
    """Aligns and classifies the data, creates a bowtie2 output and a tabular view of the metagenomes profile"""
    input:
        fastq_forward = expand("result/trimmed/{sample}_forward.fastq", sample=config["SAMPLES"]),
        fastq_reverse = expand("result/trimmed/{sample}_reverse.fastq", sample=config["SAMPLES"]),
    output:
        align = "result/metaphlan/{sample}_metagenome.bowtie2.bz2",
        profile = "result/metaphlan/{sample}_profiled_metagenome.txt"
    conda:
        "mpa"
    threads:
        20
    log:
        "/logs/metaphlan/{sample}_metaphlan.txt"
    shell:
        """
        metaphlan {input.fastq_forward},{input.fastq_reverse} --bowtie2out {output.align} --input_type fastq -o {output.profile} --bowtie2db {config[path_to_database]} 2> {log}
        """

rule metaphlan2krona:
    """Converts the metaphlan output to krona so that krona can easily use it in visualisation"""
    input:
        "result/metaphlan/{sample}_profiled_metagenome.txt"
    output:
        "result/metaphlan/{sample}_profiled_meta_to_krona.txt"
    log:
        "/logs/metaphlan/{sample}_metaphlan_krona.txt"
    threads:
        20
    conda:
        "mpa"
    shell:
        "metaphlan2krona.py -p {input} -k {output} 2> {log}"