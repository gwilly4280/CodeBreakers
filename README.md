# Tracking SARS-CoV-2 mutations across the world

This is the reposity for final project for group2 (name <em>Codebreakers</em>) in BIOL432 at Queen's University. Here we examine the geographic and temporal distribution of SARS-CoV-2 spike protein variants.<br>
<br>
Specificially, we're looking to answer the following biological questions:

1. Which regions are producing the greatest variety of strains?
2. What implications do these distributions have on vacine efficacy?

#### Dataset:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<em>mutation_accumulation.csv</em> - manually created file containing line-by-line mutation listing from df_isolate<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<em>mutations.csv</em> - reference file of known & studied mutations for comparison to df_isolate<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<em>sequences.csv</em> - original dataset of 80,000+ sequences<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<em>spike_reference.txt</em> - FASTA file of spike protein nucleotide sequence <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<em>seqs.afa</em> - FASTA file of multiple variants of the spike sequence; ouput of BASH script & remote computing<br>

#### Workflow:
  1. <strong>Subsetting the data.R</strong>
      > Takes data from <em>sequences.csv</em><br> 
      > Filters data by completeness, trims unused columns<br>
      > Subsets and samples the data by country (50 samples x 5 countries = 250 sequences)<br>
      > OUTPUT: <strong>countries</strong> dataframe w/ cols for: Accession, Length, Geo_Location, Collection_date
  2. <strong>Fasta_functions.R</strong>
      > Initializes functions: <br>
      > &nbsp;&nbsp;&nbsp;&nbsp; > Separate FASTA file by sequence & header<br>
      > &nbsp;&nbsp;&nbsp;&nbsp; > Isolate target sequence between a start & end moitf <br>
  3. <strong>spike_reference_test.R</strong>
      > Loads in FASTA from <em>spike_reference.txt</em> <br>
      > Isolates <em>start_motif</em> & <em>end_motif</em> of spike protein from reference sequence (12bp in length each)
  4. <strong>Full Data.R</strong>
      > INPUT: <strong>countries</strong>, from <em>Subsetting the data.R</em> <br>
      > Uses countries$Accession to download all 250 full sequences from NCBI genback as FASTA file<br>
      > Processes FASTA file & isolates spike proteins, using: <br>
      > &nbsp;&nbsp;&nbsp;&nbsp; > separate_fasta(countries) --> isolate & clean the raw sequences as <em>df_clean</em><br>
      > &nbsp;&nbsp;&nbsp;&nbsp; > isolate_seq(df_clean, start_motif, end_motif) --> isolate spike seq & add to new df as <em>df_isolate</em><br>
      > Uses ape & adegent packages to align spike seq, highlight mutations, add to dataframe as df_isolate$Mutations<br>
      > OUTPUT: <br>
      > &nbsp;&nbsp;&nbsp;&nbsp; > <strong>df_isolate</strong> dataframe w/ cols for: Name, Sequence, Target, seq_len, Geo_Location, Date, Mutations<br>
      > &nbsp;&nbsp;&nbsp;&nbsp; > <strong>seqalign</strong> DNAbin object to store results of spike-sequence alignment
  5. <strong>Mutations_functions.R</strong>
      > Loads data from <em>mutations.csv</em> as <em>mutations</em> dataframe<br> 
      > Cleans mutations the Change column to match format in df_isolate$Mutations <br>
      > \- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - <br>
      > INPUT: <strong>df_isolate</strong> from <em>Full data.R</em><br>
      > Cleans mutations of String formatting & separates mutations into lists: 1 list of mutatations/sequence<br>
      > OUPUT: <strong>df_isolate</strong> dataframe w/ cols for: Name, Sequence, Target, seq_len, Geo_Location, Date, Mutations (as lists
  6. <strong>Mutation Accumulation.R</strong>
      > Reads data from <em>mutation_accumulation.csv</em><br>
      > Creates timeline of mutation accumulation by date (coloured & stacked bar plot)<br>
      > OUTPUT: <strong>mut_acc</strong> dataframe 
  7. <strong>Phylogeny.RMD</strong>
      > INPUT: <strong>df_isolate</strong> for data, and <strong>seqalign</strong> for alignment information<br>
      > Uses ggtree, phylobase, ggimage, ggplot2, annotate, ape to create:<br>
      > &nbsp;&nbsp;&nbsp;&nbsp; a) A phylogeny of our sample based on the spike sequences labelled by country, with clades of interest highlighted<br>
      > &nbsp;&nbsp;&nbsp;&nbsp; b) A phylogeny of our sample based on the spike sequences labelled by mutations, with clades of interest highlighted<br>
      > OUTPUT: a) <strong>Phylogenetic_tree_country.tre</strong> b)<strong>Phylogenetic_tree_mutations.tre </strong>
  8.  <strong>Data_tables.RMD</strong>
      > INPUT: <strong>df_isolate</strong> & <strong> mut_acc</strong><br>
      > Uses dplyr to create useful summary functions
  9.  <strong>piemaps copy.R</strong>
      > Takes data from: <em>mutations.csv</em><br>
      > Uses mutation & location information from all known mutations to display relative frequencies of known spike protein variants, by country,
      > displayed as pie charts on a map.
  10. <strong>Bash Files</strong> (Code listed here)  
      > INPUT: <strong>input.fa</strong> as file from local R into <strong>fast.sh</strong> BASH script  
      > Uses <strong>muscle</strong> within CAC HPC Frontenac to align full sequences outputting: <strong>seq.afa</strong> & the phylip format <strong>first.phy</strong>
      > OUTPUT: <em>seqs.afa</em>
      > &nbsp;&nbsp;&nbsp;&nbsp; Bash Script:  

  ```
     **Script**
      #!/bin/bash  
      #SBATCH --partition=standard  
      #SBATCH --job-name=1fastatrial  
      #SBATCH -c 1  
      #SBATCH --mem=20G  
      #SBATCH --time=05:30:00  
  
      module load muscle  
      muscle -in input.fa -out seq.afa -maxiters 1 -tree1 first.phy    
```
The file is reintroduced to the local environment using FileZilla as recommended by CAC   

  11.  <strong>Full_phylo.R</strong>(listed as 9.2)
      > Takes data from: <em>seqs.afa</em><br>
      > Visualizes full alignment 
 



