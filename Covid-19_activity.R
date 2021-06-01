#Installing the packages
install.packages("dplyr")
install.packages("naniar")
install.packages("VIM")
install.packages("rpart")
install.packages("rjson")
install.packages("plotly")

#Reading the data from .csv file

covid_activity<-read.csv('covid_19_activity.csv', stringsAsFactors = F,fileEncoding="UTF-8-BOM")
View(covid_activity)

#Taking appropriate predictors in the Data set

covid_activity<-covid_activity[-c(5,6,9,10,11)]

#Checking the missing values percentage
apply(covid_activity,2,function(x){sum(is.na(x))/length(x)*100})

#Using descriptive analysis to analyze the missing values

#Using library(naniar) to check for the missing data
library(naniar)
gg_miss_var(covid_activity)

#Using library(VIM) to analyze any patterns in missing values
library(VIM)
res=summary(aggr(covid_activity,sortVar=TRUE))$combinations

#Using sapply function to check for NA values

sapply(covid_activity, function(x)sum(is.na(x)))

#Cleaning the data frame
#Replacing the NA values in people_positive_cases_count,people_positive_new_cases_count,people_death_count,people_death_new_count
library(dplyr)
##Replacing the NA values in people_positive_cases_count
covid_activity<-covid_activity%>%mutate(people_positive_cases_count=
                                          replace(people_positive_cases_count,is.na(people_positive_cases_count),mean(people_positive_cases_count,na.rm=TRUE)))

covid_activity<-covid_activity%>%mutate(county_fips_number=
                                          replace(county_fips_number,is.na(county_fips_number),median(county_fips_number,na.rm=TRUE)))

##Replacing the NA values in people_positive_new_cases_count
covid_activity<-covid_activity%>%mutate(people_positive_new_cases_count=
                                          replace(people_positive_new_cases_count,is.na(people_positive_new_cases_count),mean(people_positive_new_cases_count,na.rm=TRUE)))

##Replacing the NA values in people_death_count
covid_activity<-covid_activity%>%mutate(people_death_count=
                                          replace(people_death_count,is.na(people_death_count),mean(people_death_count,na.rm=TRUE)))

##Replacing the NA values in people_death_new_count
covid_activity<-covid_activity%>%mutate(people_death_new_count=
                                          replace(people_death_new_count,is.na(people_death_new_count),mean(people_death_new_count,na.rm=TRUE)))

#Grouping the rows based on distinct states:

updated_covid_activity = covid_activity%>%
  select(report_date,county_fips_number,people_positive_cases_count,county_name,province_state_name,people_death_new_count,people_positive_new_cases_count,people_death_count) %>%
  group_by(county_name) %>%
  summarise(grouped_Date=report_date[1],grouped_fips=county_fips_number[1],total_Positive=mean(people_positive_cases_count,na.rm=TRUE),
            grouped_states = province_state_name[1],
            total_new_deaths =sum(people_death_new_count,na.rm=TRUE),
            total_new_cases = sum(people_positive_new_cases_count,na.rm=TRUE),
            total_deaths = sum(people_death_count,na.rm=TRUE))

View(updated_covid_activity)

#Removing the coloumns unwanted county names with null values and some unwanted integer values

updated_covid_activity<-updated_covid_activity%>%slice(-c(1,2,3))

#Using sapply function to check for NA values

sapply(covid_activity, function(x)sum(is.na(x)))

##Reordering the coloumn names 

updated_covid_activity<-updated_covid_activity[,c(2,1,5,3,4,6,8,7)]

#Detecting outliers and Removing the same:
boxplot(updated_covid_activity$total_Positive,ylab="total_Positive")
outliers=boxplot.stats(updated_covid_activity$total_Positive)$out
outliers_index=which(updated_covid_activity$total_Positive %in% c(outliers))
#Getting number of outliers
length(outliers)
#Removing the Outliers
updated_covid_activity<-updated_covid_activity%>%slice(-c(outliers_index))


#Detecting outliers and Removing the same:
boxplot(updated_covid_activity$total_new_deaths,ylab="total_new_deaths")
outliers=boxplot.stats(updated_covid_activity$total_new_deaths)$out
outliers_index=which(updated_covid_activity$total_new_deaths %in% c(outliers))
#Getting number of outliers
length(outliers)
#Removing the Outliers
updated_covid_activity<-updated_covid_activity%>%slice(-c(outliers_index))

#Detecting outliers and Removing the same:
boxplot(updated_covid_activity$total_deaths,ylab="total_deaths")
outliers=boxplot.stats(updated_covid_activity$total_deaths)$out
outliers_index=which(updated_covid_activity$total_deaths %in% c(outliers))
#Getting number of outliers
length(outliers)
#Removing the Outliers
updated_covid_activity<-updated_covid_activity%>%slice(-c(outliers_index))

#Detecting outliers and Removing the same:

boxplot(updated_covid_activity$total_new_cases,ylab="total_new_cases")
outliers=boxplot.stats(updated_covid_activity$total_new_cases)$out
outliers_index=which(updated_covid_activity$total_new_cases %in% c(outliers))

#Getting number of outliers

length(outliers)

#Removing the Outliers

updated_covid_activity<-updated_covid_activity%>%slice(-c(outliers_index))

#Taking the Data Frame in a New Data Frame for later usage:

new_updated_covid_activity<-updated_covid_activity

#Encoding the categorical variables

updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Louisiana"]<-1
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Virginia"]<-2
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Idaho"]<-3
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Oklahoma"]<-4
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Nebraska"]<-5
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Vermont"]<-6
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Puerto Rico"]<-7
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="South Carolina"]<-8
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Minnesota"]<-9
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Florida"]<-10
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="North Carolina"]<-11
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="California"]<-12
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Colorado"]<-13
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Mississippi"]<-14
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Alaska"]<-15
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Michigan"]<-16
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="New York"]<-17
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Pennsylvania"]<-18
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Kentucky"]<-19
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Maine"]<-20
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Texas"]<-21
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Maryland"]<-22
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Arizona"]<-23
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Iowa"]<-24
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Georgia"]<-25
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Arkansas"]<-26
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Ohio"]<-27
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Kansas"]<-28
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="New Jersey"]<-29
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Alabama"]<-30
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="North Dakota"]<-31
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Massachusetts"]<-32
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Indiana"]<-33
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Missouri"]<-34
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Wisconsin"]<-35
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="South Dakota"]<-36
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Montana"]<-37
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Oregon"]<-38
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="New Mexico"]<-39
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Tennessee"]<-40
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Illinois"]<-41
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Utah"]<-42
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="West Virginia"]<-43
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Nevada"]<-44
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Washington"]<-45
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Wyoming"]<-46
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="New Hampshire"]<-47
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="District of Columbia"]<-48
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Connecticut"]<-49
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Hawaii"]<-50
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Delaware"]<-51
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Rhode Island"]<-52
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Northern Mariana Islands"]<-53
updated_covid_activity$county_name[updated_covid_activity$grouped_states=="Virgin Islands"]<-54

#Encoding the states

updated_covid_activity$grouped_states[updated_covid_activity$county_name==1]<-1
updated_covid_activity$grouped_states[updated_covid_activity$county_name==2]<-2
updated_covid_activity$grouped_states[updated_covid_activity$county_name==3]<-3
updated_covid_activity$grouped_states[updated_covid_activity$county_name==4]<-4
updated_covid_activity$grouped_states[updated_covid_activity$county_name==5]<-5
updated_covid_activity$grouped_states[updated_covid_activity$county_name==6]<-6
updated_covid_activity$grouped_states[updated_covid_activity$county_name==7]<-7
updated_covid_activity$grouped_states[updated_covid_activity$county_name==8]<-8
updated_covid_activity$grouped_states[updated_covid_activity$county_name==9]<-9
updated_covid_activity$grouped_states[updated_covid_activity$county_name==10]<-10
updated_covid_activity$grouped_states[updated_covid_activity$county_name==11]<-11
updated_covid_activity$grouped_states[updated_covid_activity$county_name==12]<-12
updated_covid_activity$grouped_states[updated_covid_activity$county_name==13]<-13
updated_covid_activity$grouped_states[updated_covid_activity$county_name==14]<-14
updated_covid_activity$grouped_states[updated_covid_activity$county_name==15]<-15
updated_covid_activity$grouped_states[updated_covid_activity$county_name==16]<-16
updated_covid_activity$grouped_states[updated_covid_activity$county_name==17]<-17
updated_covid_activity$grouped_states[updated_covid_activity$county_name==18]<-18
updated_covid_activity$grouped_states[updated_covid_activity$county_name==19]<-19
updated_covid_activity$grouped_states[updated_covid_activity$county_name==20]<-20
updated_covid_activity$grouped_states[updated_covid_activity$county_name==21]<-21
updated_covid_activity$grouped_states[updated_covid_activity$county_name==22]<-22
updated_covid_activity$grouped_states[updated_covid_activity$county_name==23]<-23
updated_covid_activity$grouped_states[updated_covid_activity$county_name==24]<-24
updated_covid_activity$grouped_states[updated_covid_activity$county_name==25]<-25
updated_covid_activity$grouped_states[updated_covid_activity$county_name==26]<-26
updated_covid_activity$grouped_states[updated_covid_activity$county_name==27]<-27
updated_covid_activity$grouped_states[updated_covid_activity$county_name==28]<-28
updated_covid_activity$grouped_states[updated_covid_activity$county_name==29]<-29
updated_covid_activity$grouped_states[updated_covid_activity$county_name==30]<-30
updated_covid_activity$grouped_states[updated_covid_activity$county_name==31]<-31
updated_covid_activity$grouped_states[updated_covid_activity$county_name==32]<-32
updated_covid_activity$grouped_states[updated_covid_activity$county_name==33]<-33
updated_covid_activity$grouped_states[updated_covid_activity$county_name==34]<-34
updated_covid_activity$grouped_states[updated_covid_activity$county_name==35]<-35
updated_covid_activity$grouped_states[updated_covid_activity$county_name==36]<-36
updated_covid_activity$grouped_states[updated_covid_activity$county_name==37]<-37
updated_covid_activity$grouped_states[updated_covid_activity$county_name==38]<-38
updated_covid_activity$grouped_states[updated_covid_activity$county_name==39]<-39
updated_covid_activity$grouped_states[updated_covid_activity$county_name==40]<-40
updated_covid_activity$grouped_states[updated_covid_activity$county_name==41]<-41
updated_covid_activity$grouped_states[updated_covid_activity$county_name==42]<-42
updated_covid_activity$grouped_states[updated_covid_activity$county_name==43]<-43
updated_covid_activity$grouped_states[updated_covid_activity$county_name==44]<-44
updated_covid_activity$grouped_states[updated_covid_activity$county_name==45]<-45
updated_covid_activity$grouped_states[updated_covid_activity$county_name==46]<-46
updated_covid_activity$grouped_states[updated_covid_activity$county_name==47]<-47
updated_covid_activity$grouped_states[updated_covid_activity$county_name==48]<-48
updated_covid_activity$grouped_states[updated_covid_activity$county_name==49]<-49
updated_covid_activity$grouped_states[updated_covid_activity$county_name==50]<-50
updated_covid_activity$grouped_states[updated_covid_activity$county_name==51]<-51
updated_covid_activity$grouped_states[updated_covid_activity$county_name==52]<-52
updated_covid_activity$grouped_states[updated_covid_activity$county_name==53]<-53
updated_covid_activity$grouped_states[updated_covid_activity$county_name==54]<-54


##Splitting the data
library(caTools)
set.seed(123)
split = sample.split(updated_covid_activity$total_new_cases, SplitRatio = 0.65)
training_set = subset(updated_covid_activity, split == TRUE)
test_set = subset(updated_covid_activity, split == FALSE)

##Implementing Decision Tree

library(rpart)

regressor = rpart(formula = total_new_cases ~ .,
                  data = training_set[,2:8],
                  control = rpart.control(minsplit = 10),method="anova")

#Predicting with regressor:
pred=predict(regressor,newdata = test_set)

#Getting the summary and other plots:
summary(regressor)
printcp(regressor)
plotcp(regressor)

##Pruning the tree with minimal Complexity Parameter:
pruned=prune(regressor,cp=regressor$cptable[which.min(regressor$cptable[,"xerror"]), "CP"])

#Predicting with pruned regressor:
pruned_pred=predict(pruned,newdata = test_set)

#Getting the summary and other plots:
summary(pruned)
printcp(pruned)
plotcp(pruned)

#Calculating RMSE,MAE:
print(paste("RMSE :-",sqrt(mean((test_set$total_new_cases - pred)^2))))
print(paste("MAE :-",mean(abs(test_set$total_new_cases - pred))))

##Implementing Multiple Linear Regression:

regressor<-lm(formula=total_new_cases~.,data=training_set[,2:8])
summary(regressor)

#Removing variables that are not affecting the model by using Backward Elimination:
regressor1<-lm(formula=total_new_cases~total_Positive+total_new_deaths+total_deaths,data = training_set[,2:8])
summary(regressor1)

#Predicting the results:
pred=predict(regressor1,newdata = test_set)
#Checking Auto-correlation and Influential points:
library(car)
durbinWatsonTest(regressor1)
cooks.distance(regressor1)

#Testing Multi-collinearity
vif(regressor1)

#Plotting regressor1
plot(regressor1)

#Evaluating the model:
print(paste("RMSE :-",sqrt(mean((test_set$total_new_cases - pred)^2))))
print(paste("MAE :-",mean(abs(test_set$total_new_cases - pred))))

#Filtering top 10 states with cases more than 3000 registered:

new_updated_covid_activity%>%filter_all(any_vars(.>3000))%>%top_n(10,total_new_cases)

#Filtering top 10 states with deaths more than 5000 registered:

new_updated_covid_activity%>%filter_all(any_vars(.>100))%>%top_n(10,total_new_deaths)

#Grouping the states with total positive cases and showing top 5 states for the same:

new_updated_covid_activity%>%group_by(grouped_states)%>%top_n(10,total_Positive )

library(rjson)
library(plotly)

#Map showing different counties with Total New cases:
#Code referenced from https://plotly.com/r/
url <- 'https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json'
counties <- rjson::fromJSON(file=url)
fig <- plot_ly() 
fig <- fig %>% add_trace(
  type="choroplethmapbox",
  geojson=counties,
  locations=new_updated_covid_activity$grouped_fips,
  z=new_updated_covid_activity$total_new_cases,
  colorscale="Viridis",
  zmin=0,
  zmax=12,
  marker=list(line=list(
    width=0),
    opacity=0.5
  )
)
fig <- fig %>% layout(
  mapbox=list(
    style="carto-positron",
    zoom =2,
    center=list(lon= -95.71, lat=37.09)))
fig

#Map showing different counties with Total New Deaths:
url <- 'https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json'
counties <- rjson::fromJSON(file=url)
fig <- plot_ly() 
fig <- fig %>% add_trace(
  type="choroplethmapbox",
  geojson=counties,
  locations=new_updated_covid_activity$grouped_fips,
  z=new_updated_covid_activity$total_new_deaths,
  colorscale="Viridis",
  zmin=0,
  zmax=12,
  marker=list(line=list(
    width=0),
    opacity=0.5
  )
)
fig <- fig %>% layout(
  mapbox=list(title="Map showing different counties with Total New Deaths",
    style="carto-positron",
    zoom =2,
    center=list(lon= -95.71, lat=37.09)))
fig

#Scatter plot Showing Death and New Cases across different counties:
library(plotly)
fig <- plot_ly(new_updated_covid_activity, x = ~total_new_cases, y = ~grouped_states, name = "New Cases", type = 'scatter',
               mode = "markers", marker = list(color = "pink"))
fig <- fig %>% add_trace(x = ~total_deaths, y = ~county_name, name = "Total Deaths",type = 'scatter',
                         mode = "markers", marker = list(color = "blue"))
fig <- fig %>% layout(
  title = "Deaths and New Cases In Different Counties",
  xaxis = list(title = "Total Cases and Total Deaths"),
  margin = list(l = 100))
fig


#Bar-Graph sowing Statewise Data Distribution of New Cases and Total Deaths
fig <- plot_ly(new_updated_covid_activity, x = ~grouped_states, y = ~total_new_cases, type = 'bar', name = 'New Cases')
fig <- fig %>% add_trace(y = ~total_deaths, name = 'Total Deaths')
fig <- fig %>% layout(yaxis = list(title = 'Count'), barmode = 'group',title="Statewise Data Distribution of New Cases and Total Deaths")
fig
