#' Function to run the catch resampling

#' Order of functions is: 1) Fit RUM, 2) Calculate number of trips and tows for each vessel
#' 3) Resample catches based on the probabilities in parallel

#' @param ctl_list List of arguments generated by function ch4_ctl
#' @param the_dat Data input, defaults to filt_clusts

#' @export

sample_catches <- function(ctl_list, the_dat = filt_clusts){
  #Fit RUM to estimate probabilities of fishing in each place
the_probs <- ctl_list$rum_func(rc = ctl_list$rc, port = ctl_list$port,
  years = ctl_list$years, fc = the_dat, ndays1 = ctl_list$ndays1)
# browser()
  #Specify probabilities for first tow and later tows
  first_probs <- the_probs[[1]]
  second_probs <- the_probs[[2]]

  #Calculate the average number of trips and tows for each vessel
  year_values <- the_dat %>% filter(dport_desc == ctl_list$port, set_year >= 2011) %>% 
    group_by(drvid, set_year) %>%
    summarize(ntrips = length(unique(trip_id)), nhauls = length(unique(haul_id))) 

  #Values to use for resampling
  vess_vals <- year_values %>% group_by(drvid) %>% summarize(avg_ntrips = round(mean(ntrips), digits = 0), 
    avg_nhauls = round(mean(nhauls), digits = 0)) %>% 
    mutate(hauls_per_trip = round(avg_nhauls / avg_ntrips, digits = 0))

  #Run the simulation and store run times
  start_time <- Sys.time()

  port_dat <- the_dat %>% filter(dport_desc == ctl_list$port, set_year %in% ctl_list$years)

  the_reps <- mclapply(ctl_list$the_seeds, FUN = function(seeds){
    fish_fleet(fleet_chars = vess_vals, rum_res = the_probs, seed = seeds, the_dat = port_dat)
  }, mc.cores = ctl_list$ncores)
  
  run_time <- Sys.time() - start_time; run_time

  #Conver the samples to a data frame
  the_reps1 <- list_to_df(the_reps, ind_name = ctl_list$the_seeds, col_ind_name = "rep")

  #Add in distinct trip and tow IDs for each replicate and drvid_id
  the_reps1$trip_id <- as.integer(the_reps1$trip_id)
  the_reps1$tow_index <- as.integer(the_reps1$tow_index)
  
  #trip_tow id values
  tt_ids <- the_reps1 %>% distinct(trip_id, tow_index) %>% arrange(trip_id, tow_index) 
  tt_ids$trip_tow_id <- 1:nrow(tt_ids)

  the_reps1 <- the_reps1 %>% left_join(tt_ids, by = c("trip_id", "tow_index"))
  outs <- list(catch_samples = the_reps1, run_time = run_time, first_tow_model = the_probs[[3]],
    second_tow_model = the_probs[[4]], first_tow_probs = the_probs[[1]], second_tow_probs = the_probs[[2]])
  return(outs)
}
