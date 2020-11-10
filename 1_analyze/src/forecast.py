#file: forecast.py 
import os
import sys
import warnings
import pandas as pd
import statsmodels.api as sm

def write_stat(ddir, filename, suffix, value):
    f = open(ddir + filename + "_" + suffix, "w")  
    out_str = " " + format(value,".2f") 
    f.write(out_str)
    f.close()
   
warnings.filterwarnings("ignore")
fdir="../data/forecast/"; 
for filepath in sys.argv[1:]:
    try:
        filename = os.path.basename(filepath)
        series = pd.read_csv(filepath, header=0) 
        mod = sm.tsa.SARIMAX(series, order=(0, 1, 2), trend='c')
        res = mod.fit(disp=0)
        fcast = res.forecast(steps=10)
        write_stat(fdir, filename, "sarimax012c",  fcast.values[-1])
        mod = sm.tsa.statespace.ExponentialSmoothing(series)
        res = mod.fit(disp=0)
        fcast = res.forecast(steps=10)
        write_stat(fdir, filename, "expsmooth",    fcast.values[-1])
        mod = sm.tsa.arima.ARIMA(series, order=(1, 0, 0))
        res = mod.fit()
        fcast = res.forecast(steps=10)
        write_stat(fdir, filename, "arima100",     fcast.values[-1])
        mod = mod_dfm = sm.tsa.DynamicFactorMQ(series, k_factors=1, factor_order=2)
        res = mod.fit()
        fcast = res.forecast(steps=10)
        write_stat(fdir, filename, "dynamicfmq12", fcast.values[-1])
        #print("forecast done: ",filename)
    except:
        filename = os.path.basename(filepath)
        series = pd.read_csv(filepath, header=0) 
        write_stat(fdir, filename, "sarimax012c",  0)  
        write_stat(fdir, filename, "expsmooth",    0)  
        write_stat(fdir, filename, "arima100",     0)  
        write_stat(fdir, filename, "dynamicfmq12", 0)  
        #print("forecast fail:", filepath)
        continue 
