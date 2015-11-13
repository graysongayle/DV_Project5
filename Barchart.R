require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)

# The following is equivalent to "04 Blending 2 Data Sources.twb"

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                                """select c.country_name || \\\' \\\' || \\\'c.indicator_name\\\' || \\\' \\\' || \\\'avg(c.x2010)\\\' as MEASURE_VALUES, d.INCOMEGROUP as MEASURE_NAMES, 
                                                from countries c inner join COUNTRYMETADATA d on c.country_code = d.country_code
                                                where c.indicator_name = \\\'Patent applications, residents\\\' and (c.x2010) > \\\'10000\\\'  and d.incomegroup = \\\'High income; OECD\\\'
                                                group by c.country_name, c.indicator_name, d.incomegroup
                                                order by avg(c.x2010)"""
                                                ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_gmg954', PASS='orcl_gmg954', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE))); 

df
ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  #facet_wrap(~CLARITY, ncol=1) +
  labs(title='Blending 2 Data Sources') +
  labs(x=paste("Region Sales"), y=paste("Sum of Sales")) +
  layer(data=df, 
        mapping=aes(x=MEASURE_NAMES, y=MEASURE_VALUES), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="blue"), 
        position=position_identity()
  ) + coord_flip() +
  layer(data=df, 
        mapping=aes(x=MEASURE_NAMES, y=MEASURE_VALUES, label=round(MEASURE_VALUES)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", hjust=-0.5), 
        position=position_identity()
  ) 