require("RCurl")
require("jsonlite")
require("dplyr")

# Read in data from DB
df <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select walmart_train.store_id, 
walmart_train.dept, 
                                           walmart_train.date_of_week, 
                                           walmart_train.isholiday, 
                                           walmart_train.weekly_sales, 
                                           walmart_stores.type_of_store, 
                                           walmart_stores.size_of_store, 
                                           walmart_features.fuel_price,
                                           walmart_features.temperature,
                                           walmart_features.cpi,
                                           walmart_features.unemployment
                                           from walmart_train, walmart_stores, walmart_features
                                           where walmart_train.store_id = walmart_stores.store_id
                                           and walmart_train.store_id = walmart_features.store_id
                                           and walmart_train.date_of_week = walmart_features.date_of_week"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))


#Display column names
names(df)

# Display a subset and summary of the data frame 
summary(df)
head(df)

## Get only data for store 5
subset <- subset(df, STORE_ID = 5)
head(subset)

## Get only data where Temperature is less than 60
subset <- subset(df, TEMPERATURE < 60)
head(subset)