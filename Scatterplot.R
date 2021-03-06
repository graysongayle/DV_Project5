

require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)

# The following is equivalent to "04 Blending 2 Data Sources.twb"

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                                """select   b.measure_name as measure_names, a.profit || \\\' \\\' || b.raw_value as measure_values
                                                from superstore a inner join countyhealth b on a.state_or_province = b.state
                                                where b.measure_name = \\\'Violent crime rate\\\' and a.profit > \\\'0\\\' and rownum < 15000"""
                                                ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gmg954', PASS='orcl_gmg954', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE))); 

View(df)

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  #scale_y_continuous() +
  #facet_wrap(~CLARITY, ncol=1) +
  labs(title='Blending 2 Data Sources') +
  labs(x=paste("Profit"), y=paste("Raw Value")) +
  layer(data=df, 
        mapping=aes(x=MEASURE_NAMES, y=MEASURE_VALUES), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(colour=NA), 
        position=position_identity()
  ) 
  





