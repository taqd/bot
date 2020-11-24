#!/bin/bash

root=~/bot/1_analyze
data=$root/../data

cd $data/output/
btcusd_l=XXBTZUSD_ohlc_lowprice.png 
btceur_l=XXBTZEUR_ohlc_lowprice.png 
btccad_l=XXBTZCAD_ohlc_lowprice.png 
btceth_l=XETHXXBT_ohlc_lowprice.png 

btcusd_h=XXBTZUSD_ohlc_highprice.png 
btceur_h=XXBTZEUR_ohlc_highprice.png 
btccad_h=XXBTZCAD_ohlc_highprice.png 
btceth_h=XETHXXBT_ohlc_highprice.png 
       
    
btcusd_c=XXBTZUSD_ohlc_closepric.png 
btceur_c=XXBTZEUR_ohlc_closepric.png 
btccad_c=XXBTZCAD_ohlc_closepric.png 
btceth_c=XETHXXBT_ohlc_closepric.png 
        
btcusd_v=XXBTZUSD_ohlc_volprice.png 
btceur_v=XXBTZEUR_ohlc_volprice.png 
btccad_v=XXBTZCAD_ohlc_volprice.png 
btceth_v=XETHXXBT_ohlc_volprice.png 
     
btcusd_m=XXBTZUSD_ohlc_count.png
btceur_m=XXBTZEUR_ohlc_count.png
btccad_m=XXBTZCAD_ohlc_count.png 
btceth_m=XETHXXBT_ohlc_count.png 
     

btcusd_blv=XXBTZUSD_trade_blvolume.png 
btcusd_bmv=XXBTZUSD_trade_bmvolume.png 
btcusd_slv=XXBTZUSD_trade_slvolume.png 
btcusd_smv=XXBTZUSD_trade_smvolume.png 

btceur_blv=XXBTZEUR_trade_blvolume.png 
btceur_bmv=XXBTZEUR_trade_bmvolume.png 
btceur_slv=XXBTZEUR_trade_slvolume.png 
btceur_smv=XXBTZEUR_trade_smvolume.png 
        
btccad_blv=XXBTZCAD_trade_blvolume.png 
btccad_bmv=XXBTZCAD_trade_bmvolume.png 
btccad_slv=XXBTZCAD_trade_slvolume.png 
btccad_smv=XXBTZCAD_trade_smvolume.png 
        
btceth_blv=XETHXXBT_trade_blvolume.png 
btceth_bmv=XETHXXBT_trade_bmvolume.png
btceth_slv=XETHXXBT_trade_slvolume.png
btceth_smv=XETHXXBT_trade_smvolume.png
     
btcusd_blc=XXBTZUSD_trade_blcount.png 
btcusd_bmc=XXBTZUSD_trade_bmcount.png 
btcusd_slc=XXBTZUSD_trade_slcount.png 
btcusd_smc=XXBTZUSD_trade_smcount.png 
    
btceur_blc=XXBTZEUR_trade_blcount.png 
btceur_bmc=XXBTZEUR_trade_bmcount.png 
btceur_slc=XXBTZEUR_trade_slcount.png 
btceur_smc=XXBTZEUR_trade_smcount.png 
        
btccad_blc=XXBTZCAD_trade_blcount.png 
btccad_bmc=XXBTZCAD_trade_bmcount.png 
btccad_slc=XXBTZCAD_trade_slcount.png 
btccad_smc=XXBTZCAD_trade_smcount.png 
        
btceth_blc=XETHXXBT_trade_blcount.png 
btceth_bmc=XETHXXBT_trade_bmcount.png
btceth_slc=XETHXXBT_trade_slcount.png
btceth_smc=XETHXXBT_trade_smcount.png

 

      
convert $btccad_l     $btcusd_l     $btceur_l     $btceth_l     +append stream1_l0.png
convert $btccad_h     $btcusd_h     $btceur_h     $btceth_h     +append stream1_l1.png
convert $btccad_c     $btcusd_c     $btceur_c     $btceth_c     +append stream1_l2.png
convert $btccad_v     $btcusd_v     $btceur_v     $btceth_v     +append stream1_l3.png
convert $btccad_m     $btcusd_m     $btceur_m     $btceth_m     +append stream1_l4.png
convert $btccad_blv   $btcusd_blv   $btceur_blv   $btceth_blv   +append stream1_l5.png
convert $btccad_bmv   $btcusd_bmv   $btceur_bmv   $btceth_bmv   +append stream1_l6.png
convert $btccad_slv   $btcusd_slv   $btceur_slv   $btceth_slv   +append stream1_l7.png
convert $btccad_smv   $btcusd_smv   $btceur_smv   $btceth_smv   +append stream1_l8.png
convert stream1_l0.png stream1_l1.png stream1_l2.png stream1_l3.png stream1_l4.png \
  stream1_l5.png stream1_l6.png stream1_l7.png stream1_l8.png \
  -append $data/stream/stream1.png


exit
#convert stream1_main stream1_stdout +append stream1_full.png

#cd -
btcusd_dask=XXBTZUSD_depth_askprice.png 
btceur_dask=XXBTZEUR_depth_askprice.png 
btccad_dask=XXBTZCAD_depth_askprice.png
btceth_dask=XETHXXBT_depth_askprice.png

btcusd_daskv=XXBTZUSD_depth_askvolum.png
btceur_daskv=XXBTZEUR_depth_askvolum.png 
btccad_daskv=XXBTZCAD_depth_askvolum.png 
btceth_daskv=XETHXXBT_depth_askvolum.png 

btcusd_bid=XXBTZUSD_tick_bidprice.png 
btceur_bid=XXBTZEUR_tick_bidprice.png 
btccad_bid=XXBTZCAD_tick_bidprice.png 
btceth_bid=XETHXXBT_tick_bidprice.png 

btcusd_dbid=XXBTZUSD_depth_bidprice.png 
btceur_dbid=XXBTZEUR_depth_bidprice.png 
btccad_dbid=XXBTZCAD_depth_bidprice.png 
btceth_dbid=XETHXXBT_depth_bidprice.png 
    
btcusd_dbidv=XXBTZUSD_depth_bidvolum.png
btceur_dbidv=XXBTZEUR_depth_bidvolum.png
btccad_dbidv=XXBTZCAD_depth_bidvolum.png
btceth_dbidv=XETHXXBT_depth_bidvolum.png


