# Tracking SARS-CoV-2 mutations across the world

### Directory


### Dataset Construction Workflow:
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
      > OUTPUT: <strong>df_isolate</strong> dataframe w/ cols for: Name, Sequence, Target, seq_len, Geo_Location, Date, Mutations
  5. <strong>Mutations_functions.R</strong>
      > Loads data from <em>mutations.csv</em> as <em>mutations</em> dataframe<br> 
      > Cleans mutations the Change column to match format in df_isolate$Mutations <br>
      > \- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - <br>
      > INPUT: <strong>df_isolate</strong> from <em>Full data.R</em><br>
      > Cleans mutations of String formatting & separates mutations into lists: 1 list of mutatations/sequence<br>
      > OUPUT: <strong>df_isolate</strong> dataframe w/ cols for: Name, Sequence, Target, seq_len, Geo_Location, Date, Mutations (as lists)

### Visualizations:

  1. <strong>Mutation Accumulation.R</strong>
  2. <strong>Phylogeny.RMD</strong>
  3. 











