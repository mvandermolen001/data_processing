rule krona:
    """Krona visualisation plot in the form of a .HTML file"""
    input:
        "result/metaphlan/{sample}_profiled_meta_to_krona.txt"
    output:
        "result/krona/{sample}_piechart.html"
    conda:
        "../config/visual.yaml"
    shell:
        "ktImportText {input} -o {output}"
