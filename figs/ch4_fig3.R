#-------------------------------------------------------------------------------------
#Figure 3, look at changes by depth and latitude

tows_clust_bin_depth <- bin_data(tc_unq_hauls, x_col = 'avg_depth', y_col = 'avg_lat', group = 'set_year', 
  grid_size = c(25, .25),
  group_vec = 2007:2014)


slopies <- tows_clust_bin_depth %>% group_by(unq) %>% mutate(nyears = length(unique(year))) %>%
  filter(nyears > 1) %>% arrange(year) %>%
  group_by(unq) %>%
  do({
    mod <- lm(count ~ year, data = .)
    slope <- mod$coefficients[2]
    names(slope) <- NULL
    data.frame(., slope)
  }) %>% as.data.frame

slopies$abs_slope <- abs(slopies$slope)
slopies1 <- slopies
spos <- slopies1 %>% filter(slope >= 0)
sneg <- slopies1 %>% filter(slope < 0)

# max_value <- 15
slopies1$plot_value <- slopies1$abs_slope

slopies1[which(slopies1$abs_slope >= max_value), 'plot_value'] <- max_value

slopies1$scaled_value <- round(slopies1$plot_value / max(slopies1$plot_value) * 100, 
  digits = 0)
greys <- paste0('grey', 100 - slopies1$scaled_value)
slopies1$greys <- rgb(t(col2rgb(greys)), maxColorValue = 255)

slopies1 <- slopies1 %>% distinct(unq, .keep_all = T)
slopies1$xmin <- round(slopies1$xmin)

spos <- slopies1 %>% filter(slope >= 0)
sneg <- slopies1 %>% filter(slope < 0)
spos$xmin <- round(spos$xmin)
nrow(spos)
nrow(sneg)


ch4_fig2(mv = 20, lev = 20)

ch4_fig2 <- function(mv, lev){
  par(mfcol = c(1, 3), mar = c(0, 0, 0, 0), oma = c(3.5, 3.5, 1, 0), mgp = c(0, .5, 0))
  
  #-------------------------------------------------------------------------------------
  #Positive Slopes
  format_fc_plot(spos, max_value = mv, the_levels = lev, xlims = c(0, 700),
    ylims = c(34, 49))
  box()
  mtext(paste0(letters[1], ")", " Positive Slopes"), side = 3, line = -1.5, adj = .03, cex = .8)
  mtext(paste0("n = ", nrow(spos) ), side = 3, line = -2.75, adj = .03, cex = .8)
  axis(side = 1, at = c(100, 300, 500, 700), labels = c(600, 400, 200, 0), cex.axis = 1.2)
  axis(side = 2, las = 2, cex.axis = 1.2)
  mtext(side = 2,  expression("Latitude" ~degree ~ N), outer = T, line = 1.7, cex = 1)
  
  #-------------------------------------------------------------------------------------
  #Negative slopes
  format_fc_plot(sneg, max_value = mv, the_levels = lev, xlims = c(0, 700), ylims = c(34, 49))
  box()
  axis(side = 1, at = c(100, 300, 500, 700), labels = c(600, 400, 200, 0), cex.axis = 1.2)
  mtext(paste0(letters[2], ")", " Negative Slopes"), side = 3, line = -1.5, adj = .03, cex = .8)
  mtext(paste0("n = ", nrow(sneg) ), side = 3, line = -2.75, adj = .03, cex = .8)
  
  #-------------------------------------------------------------------------------------
  #Map
  map('state', fill = TRUE, col = 'gray95', xlim = c(-126, -120.5), asp = 1.3, ylim = c(34, 49),
      mar = c(0, 0, 0, 0))
  box()
  mtext(paste0(letters[3], ")"), side = 3, line = -1.5, adj = .03, cex = .8)
  mtext(side = 1, outer = T, "Depth (fathoms)", adj = .3, line = 2)
}





# unique(spos$xmin)
# unique(spos$ymin)

#Need to flip the x axis

format_fc_plot <- function(input, max_value = 10, the_levels = 10, 
  xlims = c(0, 700), ylims = c(34, 49), flip_x_axis = TRUE, xint = 25, yint = .25){  
  
  #Flip x axis values
  input$x <- input$xmin
  input$y <- input$ymin

  if(flip_x_axis == T){
    input$x <- xlims[2] - input$x
  }

  #Scale the slope values to the plotted value
  input$plot_value <- input$abs_slope
  input[which(input$abs_slope >= max_value), 'plot_value'] <- max_value
  
  #Format matrices for filled_contour plot
  input$x <- round(input$x)
  input$y <- round(input$y, digits = 3)
  
  xx <- seq(xlims[1], xlims[2], by = xint)
  yy <- seq(ylims[1], ylims[2], by = yint)
  
  pos <- expand.grid(xx, yy)
  pos <- data.frame(x = pos[, 1], y = pos[, 2])
  pos$x <- round(pos$x, digits = 0)
  pos$y <- round(pos$y, digits = 3)
    
  pos1 <- pos %>% left_join(input %>% select(x, y, abs_slope, plot_value, greys), by = c('x', 'y'),
    fill = 0)
  
  na_inds <- is.na(pos1$abs_slope)
  pos1[na_inds, 'abs_slope'] <- 0
  pos1[na_inds, 'plot_value'] <- 0
  pos1[na_inds, 'greys'] <- 'white'

  zz <- matrix(pos1$plot_value, nrow = length(xx), ncol = length(yy))
  
  filled.contour2(xx, yy, zz, nlevels = the_levels, 
    col = grey.colors(n = the_levels , start = 1, end = 0), ann = F,
    axes = F, ylim = ylims, xlim = xlims )
  
}



filled.contour2 <-
  function (x = seq(0, 1, length.out = nrow(z)),
            y = seq(0, 1, length.out = ncol(z)), z, xlim = range(x, finite = TRUE), 
            ylim = range(y, finite = TRUE), zlim = range(z, finite = TRUE), 
            levels = pretty(zlim, nlevels), nlevels = 20, color.palette = cm.colors, 
            col = color.palette(length(levels) - 1), plot.title, plot.axes, 
            key.title, key.axes, asp = NA, xaxs = "i", yaxs = "i", las = 1, 
            axes = TRUE, frame.plot = axes,mar, ...) 
{
  # modification by Ian Taylor of the filled.contour function
  # to remove the key and facilitate overplotting with contour()
  # further modified by Carey McGilliard and Bridget Ferris
  # to allow multiple plots on one page

  if (missing(z)) {
    if (!missing(x)) {
      if (is.list(x)) {
        z <- x$z
        y <- x$y
        x <- x$x
      }
      else {
        z <- x
        x <- seq.int(0, 1, length.out = nrow(z))
      }
    }
    else stop("no 'z' matrix specified")
  }
  else if (is.list(x)) {
    y <- x$y
    x <- x$x
  }
  if (any(diff(x) <= 0) || any(diff(y) <= 0)) 
    stop("increasing 'x' and 'y' values expected")
 # mar.orig <- (par.orig <- par(c("mar", "las", "mfrow")))$mar
 # on.exit(par(par.orig))
 # w <- (3 + mar.orig[2]) * par("csi") * 2.54
 # par(las = las)
 # mar <- mar.orig

 plot.new()
 # par(mar=mar)
  plot.window(xlim, ylim, "", xaxs = xaxs, yaxs = yaxs, asp = asp)
  if (!is.matrix(z) || nrow(z) <= 1 || ncol(z) <= 1) 
    stop("no proper 'z' matrix specified")
  if (!is.double(z)) 
    storage.mode(z) <- "double"

  .filled.contour(x, y , z, levels, col)
  #22222222
  # .Internal(filledcontour(as.double(x), as.double(y), z, as.double(levels), 
  #                         col = col))
  if (missing(plot.axes)) {
    if (axes) {
      title(main = "", xlab = "", ylab = "")
      Axis(x, side = 1)
      Axis(y, side = 2)
    }
  }
  else plot.axes
  if (frame.plot) 
    box()
  if (missing(plot.title)) 
    title(...)
  else plot.title
  invisible()
}