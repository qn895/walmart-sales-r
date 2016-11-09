require("RCurl")
require("jsonlite")
require("dplyr")

# Read in data from DB

walmart_features <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from WALMART_FEATURES"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

walmart_stores <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from WALMART_STORES"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

walmart_train1 <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from WALMART_TRAIN where store_id in (1,2,3,4,5,6)"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
walmart_train2 <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from WALMART_TRAIN where store_id in (7,8,9,10,11,12)"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
walmart_train3 <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from WALMART_TRAIN where store_id in (13,14,15,16,17,18)"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
walmart_train4 <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from WALMART_TRAIN where store_id in (19,20,21,22,23,24)"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
walmart_train5 <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from WALMART_TRAIN where store_id in (25,26,27,28,29,30)"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

walmart_train = rbind(walmart_train1, walmart_train2, walmart_train3, walmart_train4, walmart_train5)

walmart_features$DATE_OF_WEEK <- as.Date(walmart_features$DATE_OF_WEEK, "%m/%d/%Y")
walmart_train$DATE_OF_WEEK <- as.Date(walmart_train$DATE_OF_WEEK, "%Y-%m-%d")

data = merge(merge(walmart_train, walmart_features, by=c("STORE_ID","DATE_OF_WEEK"), all=FALSE),walmart_stores, by="STORE_ID")

data$ISHOLIDAY = data$ISHOLIDAY.x
data$ISHOLIDAY.x = NULL
data$ISHOLIDAY.y = NULL
data

saveRDS(data, file = "/Users/markmetzger/dv_tproject5/01 Data/walmart_data.rds")
data <- readRDS("/Users/markmetzger/dv_tproject5/01 Data/walmart_data.rds")
data
d1 <- data %>% group_by(STORE_ID, TYPE_OF_STORE, ISHOLIDAY) %>% 
  filter(substring(DATE_OF_WEEK, 0, 4) == '2010') %>% 
  summarise(SUM_OF_SALES = mean(WEEKLY_SALES))

d1


require('ggplot2')

p1 <- ggplot() +
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  facet_grid(ISHOLIDAY~TYPE_OF_STORE, labeller=label_both) +
  labs(title='Titanic') +
  labs(x="Age", y=paste("Fare")) +
  layer(data=d1, 
        mapping=aes(x=reorder(STORE_ID, SUM_OF_SALES), y=as.numeric(as.character(SUM_OF_SALES))), 
        stat="identity", 
        geom="bar",
        position=position_jitter(width=0, height=0)
  )+theme(axis.text=element_text(size=5))
p1


d2 <- data %>% filter(TYPE_OF_STORE == 'A') %>% group_by(DATE_OF_WEEK, ISHOLIDAY) %>% summarise(SUM_OF_SALES = sum(WEEKLY_SALES))
d2


p2 <- ggplot() +
  coord_cartesian() + 
  scale_x_date() +
  scale_y_continuous() +
  labs(title='Titanic') +
  labs(x="Age", y=paste("Fare")) +
  layer(data=d2, 
        mapping=aes(color=ISHOLIDAY, x=DATE_OF_WEEK, y=as.numeric(as.character(SUM_OF_SALES))), 
        stat="identity", 
        geom="point",
        position=position_jitter(width=0, height=0)
  )
p2

filterMin = min(data$WEEKLY_SALES)
filterMin
filterMax = max(data$WEEKLY_SALES) - 600000
filterMax
d_ <- data %>% filter(WEEKLY_SALES >= filterMin & WEEKLY_SALES <= filterMax) %>%
  group_by(STORE_ID, TYPE_OF_STORE, ISHOLIDAY) %>%
  summarise(SUM_OF_SALES = mean(WEEKLY_SALES))

d_

d3 = filter(d_, TYPE_OF_STORE == 'A')
d3
d4 = filter(d_, TYPE_OF_STORE == 'B')
d4
MIN <- min(d_$SUM_OF_SALES)
MAX <- max(d_$SUM_OF_SALES)
MIN
MAX

ggplot(d3, aes(ISHOLIDAY, STORE_ID)) +
  geom_tile(aes(fill = SUM_OF_SALES), colour = "grey50") +
  scale_fill_gradientn(limits = c(MIN, MAX), colors=c("white", "steelblue")) +
  geom_text(size = 3, aes(fill = floor(SUM_OF_SALES), label = floor(SUM_OF_SALES)))
ggplot(d4, aes(ISHOLIDAY, STORE_ID)) +
  geom_tile(aes(fill = SUM_OF_SALES), colour = "grey50") +
  scale_fill_gradientn(limits = c(MIN, MAX), colors=c("white", "steelblue")) +
  geom_text(size = 3, aes(fill = floor(SUM_OF_SALES), label = floor(SUM_OF_SALES)))
