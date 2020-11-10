#file: base_analysis.py
import os
import sys
import pandas as pd
  
def write_stat(ddir, filename, suffix, value):
  f = open(ddir + filename + "_" + suffix, "w")  
  out_str = " " + format(value,".2f")
  f.write(out_str)
  f.close()

analysis_dir ="../data/analysis/"
for filepath in sys.argv[1:]:
    try:
        filename = os.path.basename(filepath)
        series = pd.read_csv(filepath, header=0) 
        write_stat(analysis_dir, filename, "mean", series.mean()[0])
        write_stat(analysis_dir, filename, "min",  series.min()[0])
        write_stat(analysis_dir, filename, "max",  series.max()[0])
        write_stat(analysis_dir, filename, "std",  series.std()[0])
        write_stat(analysis_dir, filename, "var",  series.var()[0])
        write_stat(analysis_dir, filename, "skew", series.skew()[0])  
        write_stat(analysis_dir, filename, "kurt", series.kurt()[0])
        write_stat(analysis_dir, filename, "smin", series.size-series.idxmin()[0])  
        write_stat(analysis_dir, filename, "smax", series.size-series.idxmax()[0])
        #print("base analysis done:",filename) 
    except:
        filename = os.path.basename(filepath)
        series = pd.read_csv(filepath, header=0) 
        write_stat(analysis_dir, filename, "mean", 0); 
        write_stat(analysis_dir, filename, "min",  0); 
        write_stat(analysis_dir, filename, "max",  0); 
        write_stat(analysis_dir, filename, "std",  0); 
        write_stat(analysis_dir, filename, "var",  0); 
        write_stat(analysis_dir, filename, "skew", 0); 
        write_stat(analysis_dir, filename, "kurt", 0); 
        write_stat(analysis_dir, filename, "smin", 0); 
        write_stat(analysis_dir, filename, "smax", 0); 
        #print("base analysis fail:",filepath)
        continue 
