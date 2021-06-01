#Reading the data from .csv file

csv_Data<-read.csv('Conditions_contributing_to_deaths_involving_coronavirus_disease_2019__COVID-19___by_age_group_and_state__United_States.csv', stringsAsFactors = FALSE,fileEncoding="UTF-8-BOM")
View(csv_Data)

##Pre-Processing of the Dataset

#Using sapply function to check for NA values

sapply(csv_Data, function(x)sum(is.na(x)))

#Taking appropriate predictors in the Data set

csv_Data<-csv_Data[-c(1,3,9,10,14)]

#Analyzing the missing values:

#Checking the missing values percentage
apply(csv_Data,2,function(x){sum(is.na(x))/length(x)*100})

#Using descriptive analysis to analyze the missing values

#Using library(naniar) to check for the missing data
library(naniar)
gg_miss_var(csv_Data)

#Using library(VIM) to analyze any patterns in missing values
library(VIM)
res=summary(aggr(csv_Data,sortVar=TRUE))$combinations

#Cleaning the dataset

#Plotting the Histogram to check for normality

hist(csv_Data$Year)
hist(csv_Data$Month)
hist(csv_Data$COVID.19.Deaths)
hist(csv_Data$Number.of.Mentions)

#Removing Year NA Values as data may become distorted if replaced with mean or median.
csv_Data<-csv_Data[complete.cases(csv_Data$Year),]

##Replacing Null values for other attributes:
library(dplyr)
csv_Data<-csv_Data%>%mutate(Month=replace(Month,is.na(Month),median(Month,na.rm=TRUE)))

csv_Data<-csv_Data%>%mutate(COVID.19.Deaths=replace(COVID.19.Deaths,is.na(COVID.19.Deaths),mean(COVID.19.Deaths,na.rm = TRUE)))

csv_Data<-csv_Data%>%mutate(Number.of.Mentions=replace(Number.of.Mentions,is.na(Number.of.Mentions),mean(Number.of.Mentions,na.rm = TRUE)))

#Storing the data frame
stored_csv_data=csv_Data

#Encoding the Group:
csv_Data$Group<-factor(csv_Data$Group,levels=c("By Year","By Month"),labels=c(1,2))

#Encoding Year as it has 2 Years 2020 and 2021, which even if scaled can cause some distortions in the model:

csv_Data$Year<-factor(csv_Data$Year,levels=c("2020","2021"),labels=c(1,2))

#Encoding the Age Group:
csv_Data$Age.Group<-factor(csv_Data$Age.Group,levels=c("0-24","25-34","35-44","45-54","55-64","65-74",
                                                    "75-84","85+","Not stated","All Ages"),
                                                    labels=c(1,2,3,4,5,6,7,8,9,10))
#Encoding the Conditions Group
csv_Data$Condition.Group<-factor(csv_Data$Condition.Group,levels=c("Respiratory diseases","Circulatory diseases","Sepsis","Malignant neoplasms","Diabetes",
                                                                   "Obesity","Alzheimer disease","Vascular and unspecified dementia","Renal failure","Intentional and unintentional injury, poisoning, and other adverse events"
                                                                    ,"All other conditions and causes (residual)","COVID-19"),
                                                                    labels=c(1,2,3,4,5,6,7,8,9,10,11,12))

#Converting Factors to Numeric:

csv_Data$Group<-as.numeric(csv_Data$Group)
csv_Data$Year<-as.numeric(csv_Data$Year)
csv_Data$Age.Group<-as.numeric(csv_Data$Age.Group)
csv_Data$Condition.Group<-as.numeric(csv_Data$Condition.Group)

#Using sapply function to check for NA values

sapply(csv_Data, function(x)sum(is.na(x)))

#Reordering the columns
csv_Data<-csv_Data[,c(1,5,2,3,4,6,7,8,9)]

#Splitting into Training and test set:
library(caTools)
split=sample.split(csv_Data$Number.of.Mentions,SplitRatio = 0.60)
training_set=subset(csv_Data,split==TRUE)
test_set=subset(csv_Data,split==FALSE)

#Using XGBOOST

#install.packages("xgboost")
library(xgboost)
set.seed(13123)

xgb <- xgboost(data = as.matrix(training_set[,3:8]),
               label = training_set[,9], 
               nround=100,eval_metric=c("rmse","mae"),objective="reg:squarederror",eta=.3,booster="gbtree",verbose=TRUE,gamma=0)

#Applying xgboost CV:

cv.res <- xgb.cv(data = as.matrix(training_set[,3:8]), label = training_set[,9], nfold = 5,
                 nrounds = 100, objective = "reg:squarederror",eta=0.3,booster="gbtree")

elog<-cv.res$evaluation_log

#Calculating the number of trees
elog %>% 
  summarize(ntrees.train = which.min(train_rmse_mean),   
            ntrees.test  =which.min(test_rmse_mean) )

#Applying xgboost with minimum number of trees as 94
xg_pred=predict(best_ntreelimit=ntrees.test,xgb,newdata = as.matrix(test_set[,3:8]))

library(Metrics)
#Analyzing the results of xgboost:
print(paste("xgb", rmse(test_set[,9], xg_pred)))
print(paste("xgb", mae(test_set[,9], xg_pred)))

#Getting the importance of each parameter:
importance_matrix <- xgb.importance(colnames(training_set[,3:8]), model = xgb)
xgb.plot.importance(importance_matrix = importance_matrix[1:20])

#Using Random Forest:

library(randomForest)
set.seed(1234)
library(caret)

random_forest_regressor = randomForest(x = training_set[-9],
                         y = training_set$Number.of.Mentions,
                         ntree = 50)

y_pred=predict(random_forest_regressor,data=test_set[,3:9])
y_pred

#Calculating RMSE,MAE,MASE:
print(paste("RMSE :-",sqrt(mean((test_set$Number.of.Mentions - y_pred)^2))))
print(paste("MAE :-",mean(abs(test_set$Number.of.Mentions - y_pred))))
print(mase(test_set$Number.of.Mentions, y_pred))


#Grouping the data and filtering so as to get interesting results:
#Below code will group the data based on State,Age, conditions and will take all the results in a cumulative manner for better understanding of the data:
csv_Data_Grouped = stored_csv_data%>%
  select(Start.Date,Group,Year,Month,State,Condition.Group,Age.Group,COVID.19.Deaths,Number.of.Mentions) %>%
  group_by(Start.Date,Condition.Group=Condition.Group,State,Age.Group) %>%
  summarise(Group = Group[1],
            Year = Year[1],
            Month=Month[1],
            COVID.19.Deaths=sum(COVID.19.Deaths,na.rm = TRUE),
            Number.of.Mentions=sum(Number.of.Mentions,na.rm=TRUE))
View(csv_Data_Grouped)

#Filtering top 10 states with mentions of each age group and condition group more than 10000 registered in Year 2020:

csv_Data_Grouped%>%filter(Number.of.Mentions>10000,Year==2020)%>%top_n(10,Number.of.Mentions)

#Filtering top 10 Condition Groups with mentions of each age group, more than 10000 registered in Year 2021:

csv_Data_Grouped%>%filter(Number.of.Mentions>10000,Year==2021)%>%top_n(10,Number.of.Mentions)

#Filtering by Elder Age groups for Conditions group and mentions under each condition:

csv_Data_Grouped%>%filter(Age.Group%in%c("85+","65-74","75-84"))%>%filter(Number.of.Mentions>50000)%>%top_n(20,Number.of.Mentions)

#Filtering by Younger Age groups for Conditions group and mentions greater than 1000 under each condition:

csv_Data_Grouped%>%filter(Age.Group%in%c("0-24","25-34","35-44"))%>%filter(Number.of.Mentions>1000)%>%top_n(10,COVID.19.Deaths)

##Plotly Pie chart showing Different Condition Groups with Number of Mentioned Cases:
library(plotly)
fig<-plot_ly()
fig<-fig%>%add_pie(values=csv_Data_Grouped$Number.of.Mentions,labels=csv_Data_Grouped$Condition.Group,
                  textposition='inside')
fig<-fig%>%layout(title="Pie Chart showing Different Condition Groups with Number of Mentioned Cases")
fig

#Pie Chart showing Covid deaths among different Age Groups
fig<-plot_ly()
fig<-fig%>%add_pie(values=csv_Data_Grouped$COVID.19.Deaths,labels=csv_Data_Grouped$Age.Group,
                   textposition='inside')
fig<-fig%>%layout(title="Covid deaths among different Age Groups")
fig

##Heatmap

fig <- plot_ly(x =csv_Data_Grouped$Age.Group ,y=csv_Data_Grouped$Condition.Group,
  z = csv_Data_Grouped$COVID.19.Deaths, type = "heatmap")

fig

##Violin Graph

fig <- csv_Data_Grouped %>%
  plot_ly(
    x = ~Condition.Group,
    y = ~Number.of.Mentions,
    split = ~Condition.Group,
    type = 'violin',
    box = list(
      visible = T
    ),
    meanline = list(
      visible = T
    )
  ) 

fig <- fig %>%
  layout(
    xaxis = list(
      title = "Different Conditions"
    ),
    yaxis = list(
      title = "Number of Cases in each Condition",
      zeroline = F
    )
  )

fig
