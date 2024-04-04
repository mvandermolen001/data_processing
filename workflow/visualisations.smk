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


rule export2graphlan:
    input:
        "result/metaphlan/{sample}_profiled_metagenome.txt"
    output:
        annotation = temporary("result/graphlan/{sample}_annot.txt"),
        tree = temporary("result/graphlan/{sample}_outm.txt")
    conda:
        "../config/visual.yaml"
    shell:
        "export2graphlan.py -i {input} -a {output.annotation} -t {output.tree} --annotations 1,2 --external_annotations 3,4,5 --background_levels 1"

rule graphlan_annotate:
    input:
        annotation= "result/graphlan/{sample}_annot.txt",
        tree = "result/graphlan/{sample}_outm.txt"
    output:
        temporary("result/graphlan/{sample}_output_tree.phyloxml")
    conda:
        "../config/visual.yaml"
    shell:
       "graphlan_annotate.py --annot {input.annotation} {input.tree} {output}"

rule graphlan_visual:
    input:
        "result/graphlan/{sample}_output_tree.phyloxml"
    output:
        "result/graphlan/{sample}_visual_tree.pdf"
    conda:
        "../config/visual.yaml"
    shell:
        "graphlan.py {input} {output}"
