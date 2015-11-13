

require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)

# The following is equivalent to "04 Blending 2 Data Sources.twb"
KPI_Low_Max_value = 100000 


df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                                """select State, Measure_Name as Measure_Name, kpi as val
                                                from
                                                (select  a.state_or_province as State, b.measure_name as Measure_Name, sum(b.raw_value) as kpi
                                                from superstore a inner join countyhealth b on a.state_or_province = b.state
                                                where b.measure_name in (\\\'Adult obesity\\\',\\\'Diabetic screening\\\',\\\'Mammography screening\\\',\\\'Physical inactivity\\\') 
                                                group by a.state_or_province, b.measure_name
                                                order by a.state_or_province)"""
                                                ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gmg954', PASS='orcl_gmg954', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON',p1=KPI_Low_Max_value), verbose = TRUE))); 


View(df)

spread(df, MEASURE_NAME, STATE) %>% View

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_discrete() +
  labs(title='Testing') +
  #labs(x=paste(Measure_Name), y=paste("State")) +
  layer(data=df, 
        mapping=aes(x=MEASURE_NAME, y=STATE, label=VAL), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black"), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=MEASURE_NAME, y=STATE, fill=VAL), 
        stat="identity", 
        stat_params=list(), 
        geom="tile",
        geom_params=list(alpha=0.50), 
        position=position_identity()
  )





