# Tracking SARS-CoV-2 mutations across the world

### Directory


### Workflow:
  1. Subsetting the data.R
      > Takes data from <em>sequences.csv</em><br> 
      > Filters data by completeness, trims unused columns<br>
      > Subsets and samples the data by country (50 samples x 5 countries = 250 sequences)<br>
      > OUTPUT: <strong>countries</strong> dataframe w/ cols for: Accession, Length, Geo_Location, Collection_date
  2. Fasta_functions.R
      > Initializes functions: <br>
      > &nbsp;&nbsp;&nbsp;&nbsp; > Separate FASTA file by sequence & header<br>
      > &nbsp;&nbsp;&nbsp;&nbsp; > Isolate target sequence between a start & end moitf <br>
  3. spike_reference_test.R
      > Loads in FASTA from <em>spike_reference.txt</em> <br>
      > Isolates <em>start_motif</em> & <em>end_motif</em> of spike protein from reference sequence (12bp in length each)
  4. Full Data.R
      > INPUT: <strong>countries</strong>, from <em>Subsetting the data.R</em> <br>
      > Uses countries$Accession to download all 250 full sequences from NCBI genback <br>
      > OUTPUT: <strong>df_isolate<strong> dataframe
  5. Mutations_functions.R
      > 
  6. 
