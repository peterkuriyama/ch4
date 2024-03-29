#Whitefish Runs
#---------------------------------------------------------------------------------
#Specify Computer
setwd('/Users/peterkuriyama/Dropbox/phd/Research/ch4')
# setwd('c://Users//Peter//ch4')

# list.files("//udrive.uw.edu//udrive//file_clusts_dist.Rdata")
setwd("C://Users//Peter//Dropbox//phd//research//ch4")

#
setwd("//netid.washington.edu//csde//other//desktop//ptrkrym//Desktop//ch4")
#---------------------------------------------------------------------------------
#Start of obs_dat, work off this script
#Load Packages
library(ggplot2)
library(plyr)
library(dplyr)
library(lubridate)
library(reshape2)
library(devtools)
library(maps)
library(doParallel)
library(lubridate)
library(GGally)
library(nnet)
library(tidyr)
library(mlogit)
library(parallel)
library(sendmailR)

#Install ch4 package
devtools::install_github("peterkuriyama/ch4", auth_token = "83f947b716e40172803f0ff798c46f5ff9ca3cd1")
library("ch4")

#Install delta plot functions
devtools::install_github("peterkuriyama/ch2vms/ch2vms")
library(ch2vms)

#States Map
states_map <- map_data("state")

#---------------------------------------------------------------------------------
#Load and format data
#More formatting in ch4_movement
# load("//udrive.uw.edu//udrive//obs_data1.Rdata")
# load("//udrive.uw.edu//udrive//file_clusts_dist.Rdata")
# load("//udrive.uw.edu//udrive//filt_clusts_w_monthly_prices.Rdata")
# load("//udrive.uw.edu//udrive//tows_clust_921.Rdata")
# load("//udrive.uw.edu//udrive//tows_clust_925_depth_bin.Rdata")
load("//udrive.uw.edu//udrive//tows_clust_1010.Rdata")

# load("/Volumes/udrive/tows_clust_1010.Rdata")
# load_all()

#------------------------------------------------------------------------------
#Sensitivity Runs with different quota species
#Canary only
the_ports <- list("EUREKA", "CHARLESTON (COOS BAY)", 
  "NEWPORT", "ASTORIA / WARRENTON")

the_seed <- 1022
the_days <- 30
the_hd <- 5.1 #habit distance

quota_species = c("Canary Rockfish", "Darkblotched Rockfish",
  "Pacific Ocean Perch", "Yelloweye Rockfish", "Bocaccio Rockfish")

#-----------------------------------------

##1: CSDE Cluster: Run with Coefficient of 1 and total revenues for all years 
a_l <- arg_list(ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports,
                     h_d = the_hd, dyz = the_days, quota_species = quota_species, 
                     n_c = 'trev',
                nhauls_sampled = 50)
run_six_years(the_args = a_l, years = 2009:2014)

##2: Blackfish Run: with Coefficient of 100 and quota costs for 2011:2014 for all 
#constraining species
a_l <- arg_list(ncores = 8, seed = the_seed, r_c = 100, r_s = 100, ports = the_ports,
                     h_d = the_hd, dyz = the_days, quota_species = quota_species, 
                     n_c = 'qcos',
                nhauls_sampled = 50)
run_six_years(the_args = a_l, years = 2011:2014)
#Because there's no difference in the model looking at Canary only


##3: Some computer: Run with a different seed to see if results change
a_l <- arg_list(ncores = 10, seed = the_seed + 10, r_c = 1, r_s = 100, 
      ports = the_ports,
                     h_d = the_hd, dyz = the_days, quota_species = quota_species, 
                     n_c = 'trev',
                nhauls_sampled = 50)
run_six_years(the_args = a_l, years = 2009:2014)

#4: Run with 75 hauls - CSDE
a_l <- arg_list(ncores = 10, seed = the_seed + 10, r_c = 1, r_s = 100, 
                ports = the_ports,
                h_d = the_hd, dyz = the_days, quota_species = quota_species, 
                n_c = 'trev',
                nhauls_sampled = 75)
run_six_years(the_args = a_l, years = 2009:2014)

#####
####Run with these years
#####
# run_six_years(the_args = a_l, years = 2013:2014)

#5: Run with 75 hauls and different seed - Whitefish
a_l <- arg_list(ncores = 10, seed = the_seed, r_c = 1, r_s = 100, 
                ports = the_ports,
                h_d = the_hd, dyz = the_days, quota_species = quota_species, 
                n_c = 'trev',
                nhauls_sampled = 75)
run_six_years(the_args = a_l, years = 2009:2014)

#6: Run with coefficient of 50 and quota costs for species - Blackfish
a_l <- arg_list(ncores = 8, seed = the_seed, r_c = 50, r_s = 100, ports = the_ports,
                     h_d = the_hd, dyz = the_days, quota_species = quota_species, 
                     n_c = 'qcos',
                nhauls_sampled = 50)
run_six_years(the_args = a_l, years = 2011:2014)

#7: Run with coefficient of 10 and quota costs for species - CSDE
a_l <- arg_list(ncores = 10, seed = the_seed, r_c = 10, r_s = 100, ports = the_ports,
                     h_d = the_hd, dyz = the_days, quota_species = quota_species, 
                     n_c = 'qcos',
                nhauls_sampled = 50)
run_six_years(the_args = a_l, years = 2011:2014)

#8: Run with coefficient of 5 and quota costs for species - Blackfish
a_l <- arg_list(ncores = 8, seed = the_seed, r_c = 5, r_s = 100, ports = the_ports,
                     h_d = the_hd, dyz = the_days, quota_species = quota_species, 
                     n_c = 'qcos',
                nhauls_sampled = 50)
run_six_years(the_args = a_l, years = 2011:2014)

#9: Run with coefficient of 1 and quota costs for species - Whitefish
a_l <- arg_list(ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports,
                     h_d = the_hd, dyz = the_days, quota_species = quota_species, 
                     n_c = 'qcos',
                nhauls_sampled = 50)
run_six_years(the_args = a_l, years = 2011:2014)

####To RUN Scenarios


#9: Run with coefficient of 5 and quota costs for Canary only?

#-----------------------------------------
#Risk coefficient of 2009

#5
rums_09 <- port_rums(m_y = 2007, f_y = 2009, nhauls_sampled = 50,
                     ncores = 6, seed = the_seed, r_c = 5, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2010
rums_10 <- port_rums(m_y = 2007, f_y = 2010, nhauls_sampled = 50,
                     ncores = 6, seed = the_seed, r_c = 5, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2011
rums_11 <- port_rums(m_y = 2007, f_y = 2011, nhauls_sampled = 50,
                     ncores = 6, seed = the_seed, r_c = 5, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2012
rums_12 <- port_rums(m_y = 2007, f_y = 2012, nhauls_sampled = 50,
                     ncores = 6, seed = the_seed, r_c = 5, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2013
rums_13 <- port_rums(m_y = 2007, f_y = 2013, nhauls_sampled = 50,
                     ncores = 6, seed = the_seed, r_c = 5, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2014
rums_14 <- port_rums(m_y = 2007, f_y = 2014, nhauls_sampled = 50,
                     ncores = 6, seed = the_seed, r_c = 5, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

 #-----------------------------------------
#Risk coefficient of 10
#2009
rums_09 <- port_rums(m_y = 2007, f_y = 2009, nhauls_sampled = 50,
                     ncores = 8, seed = the_seed, r_c = 10, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2010
rums_10 <- port_rums(m_y = 2007, f_y = 2010, nhauls_sampled = 50,
                     ncores = 8, seed = the_seed, r_c = 10, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2011
rums_11 <- port_rums(m_y = 2007, f_y = 2011, nhauls_sampled = 50,
                     ncores = 8, seed = the_seed, r_c = 10, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2012
rums_12 <- port_rums(m_y = 2007, f_y = 2012, nhauls_sampled = 50,
                     ncores = 8, seed = the_seed, r_c = 10, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2013
rums_13 <- port_rums(m_y = 2007, f_y = 2013, nhauls_sampled = 50,
                     ncores = 8, seed = the_seed, r_c = 10, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2014
rums_14 <- port_rums(m_y = 2007, f_y = 2014, nhauls_sampled = 50,
                     ncores = 8, seed = the_seed, r_c = 10, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#-----------------------------------------
#Risk coefficient of 50
#2009
rums_09 <- port_rums(m_y = 2007, f_y = 2009, nhauls_sampled = 50,
                     ncores = 8, seed = the_seed, r_c = 50, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2010
rums_10 <- port_rums(m_y = 2007, f_y = 2010, nhauls_sampled = 50,
                     ncores = 8, seed = the_seed, r_c = 50, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2011
rums_11 <- port_rums(m_y = 2007, f_y = 2011, nhauls_sampled = 50,
                     ncores = 8, seed = the_seed, r_c = 50, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2012
rums_12 <- port_rums(m_y = 2007, f_y = 2012, nhauls_sampled = 50,
                     ncores = 8, seed = the_seed, r_c = 50, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2013
rums_13 <- port_rums(m_y = 2007, f_y = 2013, nhauls_sampled = 50,
                     ncores = 8, seed = the_seed, r_c = 50, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

#2014
rums_14 <- port_rums(m_y = 2007, f_y = 2014, nhauls_sampled = 50,
                     ncores = 8, seed = the_seed, r_c = 50, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish"), n_c = "trev")

  



#------------------------------------------------------------------------------
#Run for years in succession
#--------------------------Runs with risk coefficient of 1

the_ports <- list("FORT BRAGG", "EUREKA", c("CRESCENT CITY", 'BROOKINGS'),
                  "CHARLESTON (COOS BAY)", "NEWPORT", "ASTORIA / WARRENTON")

rums_12 <- port_rums(m_y = 2007, f_y = 2012, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days, quota_species = c("Canary Rockfish", "Pacific Ocean Perch"))

#Specify the seed,
the_seed <- 10
the_days <- 30
the_hd <- 8.05 #habit distance

#--------------------------------------------------------------------------------------------------------
#Model fitting 

the_seed <- 10
#30 days, 5 mile radius
the_days <- 30
the_hd <- 8.05 #habit distance

rums_12 <- port_rums(m_y = 2007, f_y = 2012, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days)

#30 days, 10 mile radius
the_days <- 30
the_hd <- 16.1 #habit distance

rums_12 <- port_rums(m_y = 2007, f_y = 2012, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days)

#14 days, 3 mile radius
the_days <- 14
the_hd <- 5.1 #habit distance

rums_12 <- port_rums(m_y = 2007, f_y = 2012, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days)

#14 days, 5 mile radius
the_days <- 14
the_hd <- 8.05 #habit distance

rums_12 <- port_rums(m_y = 2007, f_y = 2012, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days)

#30 days, 5 mile radius
the_days <- 14
the_hd <- 16.1 #habit distance

rums_12 <- port_rums(m_y = 2007, f_y = 2012, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days)

#30 days, 3 mile radius
the_days <- 14
the_hd <- 5.1 #habit distance

rums_12 <- port_rums(m_y = 2007, f_y = 2012, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days)

#--------------------------------------------------------------------------------------------------------
#Full Run

the_seed <- 10
the_days <- 30
the_hd <- 8.05 #habit distance


#2009
rums_09 <- port_rums(m_y = 2007, f_y = 2009, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days)

#2010
rums_10 <- port_rums(m_y = 2007, f_y = 2010, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days)

#2011
rums_11 <- port_rums(m_y = 2007, f_y = 2011, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days)

#2012
rums_12 <- port_rums(m_y = 2007, f_y = 2012, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days)

#2013
rums_13 <- port_rums(m_y = 2007, f_y = 2013, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days)

#2014
rums_14 <- port_rums(m_y = 2007, f_y = 2014, nhauls_sampled = 50,
                     ncores = 10, seed = the_seed, r_c = 1, r_s = 100, ports = the_ports, h_d = the_hd,
                     dyz = the_days)


#------------------------------------------------------------------------------
#Test ILWACO
#Check the sensitivity to seeds for Crescent City
start_time <- Sys.time()
eur <- sampled_rums(data_in = tows_clust, the_port = "EUREKA",
                   min_year = 2009, max_year = 2011,
                   risk_coefficient = 1, ndays = 30, focus_year = 2011,
                   nhauls_sampled = 50, seed = 300, ncores = 10, rev_scale = 100)
run_time <- Sys.time() - start_time; run_time
#Eureka took 53 minutes

start_time <- Sys.time()
ccb50 <- sampled_rums(data_in = tows_clust, the_port = c("CRESCENT CITY", "BROOKINGS"),
                    min_year = 2010, max_year = 2012,
                    risk_coefficient = 50, ndays = 30, focus_year = 2011,
                    nhauls_sampled = 50, seed = 300, ncores = 10, rev_scale = 10)
run_time <- Sys.time() - start_time; run_time
#Takes 5 minutes



start_time <- Sys.time()
ast_7 <- sampled_rums(data_in = tows_clust, the_port = "ASTORIA / WARRENTON",
                   min_year = 2007, max_year = 2009,
                   risk_coefficient = 1, ndays = 30, focus_year = 2009,
                   nhauls_sampled = 50, seed = 7, ncores = 10, rev_scale = 10)
run_time <- Sys.time() - start_time; run_time

coefs <- ast_7[[1]]
save(coefs, file = "//udrive.uw.edu//udrive//AST_coefs1_rev100_minyr2007_focyr_2009_seed7.Rdata")

rum <- ast_7[[2]]
save(rum, file = "//udrive.uw.edu//udrive//AST_runs1_rev100_minyr2007_focyr_2009_seed7.Rdata")


ast_10_7 <- sampled_rums(data_in = tows_clust, the_port = "ASTORIA / WARRENTON",
                      min_year = 2007, max_year = 2010,
                      risk_coefficient = 1, ndays = 30, focus_year = 2009,
                      nhauls_sampled = 50, seed = 7, ncores = 10, rev_scale = 10)
coefs <- ast_10_7[[1]]
save(coefs, file = "//udrive.uw.edu//udrive//AST_coefs1_rev100_minyr2007_focyr_2010_seed7.Rdata")

rum <- ast_10_7[[2]]
save(rum, file = "//udrive.uw.edu//udrive//AST_runs1_rev100_minyr2007_focyr_2010_seed7.Rdata")
