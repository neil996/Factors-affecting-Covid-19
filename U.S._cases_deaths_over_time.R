#Reading the data from .csv file

csv_Data<-read.csv('United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv', stringsAsFactors = FALSE,fileEncoding="UTF-8-BOM")
View(csv_Data)

##Pre-Processing of the Dataset

#Using sapply function to check for NA values

sapply(csv_Data, function(x)sum(is.na(x)))

#Removing the rows with empty spaces in Consent cases and consent death column.

#install.packages("stringr")
library("stringr")

#Replacing the empty spaces with NA, so as to evaluate on this missing data
library(dplyr)
csv_Data<-csv_Data%>%mutate(consent_deaths=replace(consent_deaths,consent_deaths=="",NA))
csv_Data<-csv_Data%>%mutate(consent_cases=replace(consent_cases,consent_cases=="",NA))

#Taking the indexes for NA values and then removing it consecutively
null_indexes=which(is.na(csv_Data$consent_cases))
csv_Data<-csv_Data[-c(null_indexes),]
null_consent=str_which(csv_Data$consent_cases,"N/A")
csv_Data<-csv_Data[-c(null_consent),]
null_deaths=str_which(csv_Data$consent_deaths,"N/A")
csv_Data<-csv_Data[-c(null_deaths),]

#Taking appropriate predictors in the Data set

csv_Data<-csv_Data[-c(1,13)]

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

#Cleaning the data frame
#Dropping the columns which are irrelevant to the desired model:

#Dropping columns "conf_cases","prob_cases" as these have missing values close to 50 percent

csv_Data<-csv_Data[-c(3,4,12)]

#Plotting the Histogram to check for normality

hist(csv_Data$pnew_case)
hist(csv_Data$conf_death)#Right skewed
hist(csv_Data$prob_death)#Right skewed
hist(csv_Data$pnew_death)

##Replacing the NA values in pnew_case
csv_Data<-csv_Data%>%mutate(pnew_case=replace(pnew_case,is.na(pnew_case),mean(pnew_case,na.rm = TRUE)))

##Replacing the NA values in conf_death
csv_Data<-csv_Data%>%mutate(conf_death=replace(conf_death,is.na(conf_death),median(conf_death,na.rm = TRUE)))

##Replacing the NA values in prob_death
csv_Data<-csv_Data%>%mutate(prob_death=replace(prob_death,is.na(prob_death),median(prob_death,na.rm = TRUE)))

##Replacing the NA values in pnew_death
csv_Data<-csv_Data%>%mutate(pnew_death=replace(pnew_death,is.na(pnew_death),mean(pnew_death,na.rm = TRUE)))

#outliers
library(dplyr)
boxplot(csv_Data$new_case,ylab="new_case")
outliers=boxplot.stats(csv_Data$new_case)$out
outliers_index=which(csv_Data$new_case %in% c(outliers))
length(outliers)#Getting number of outliers
#removing
csv_Data<-csv_Data%>%slice(-c(outliers_index))

#outliers
boxplot(csv_Data$tot_cases,ylab="tot_cases")
outliers=boxplot.stats(csv_Data$tot_cases)$out
outliers_index=which(csv_Data$tot_cases %in% c(outliers))
length(outliers)#Getting number of outliers
#removing
csv_Data<-csv_Data%>%slice(-c(outliers_index))

#outlier
boxplot(csv_Data$pnew_case,ylab="pnew_case")
outliers=boxplot.stats(csv_Data$pnew_case)$out
outliers_index=which(csv_Data$pnew_case %in% c(outliers))
length(outliers)#Getting number of outliers
#removing
csv_Data<-csv_Data%>%slice(-c(outliers_index))

#outlier
boxplot(csv_Data$tot_death,ylab="tot_death")
outliers=boxplot.stats(csv_Data$tot_death)$out
outliers_index=which(csv_Data$tot_death %in% c(outliers))
length(outliers)#Getting number of outliers
#removing
csv_Data<-csv_Data%>%slice(-c(outliers_index))

#outlier
boxplot(csv_Data$new_death,ylab="new_death")
outliers=boxplot.stats(csv_Data$new_death)$out
outliers_index=which(csv_Data$new_death %in% c(outliers))
length(outliers)#Getting number of outliers
#removing
csv_Data<-csv_Data%>%slice(-c(outliers_index))

#outlier
boxplot(csv_Data$pnew_death,ylab="pnew_death")
outliers=boxplot.stats(csv_Data$pnew_death)$out
outliers_index=which(csv_Data$pnew_death %in% c(outliers))
length(outliers)#Getting number of outliers
#removing
csv_Data<-csv_Data%>%slice(-c(outliers_index))

#outlier
boxplot(csv_Data$conf_death,ylab="conf_death")
outliers=boxplot.stats(csv_Data$conf_death)$out
outliers_index=which(csv_Data$conf_death %in% c(outliers))
length(outliers)#Getting number of outliers
#removing
csv_Data<-csv_Data%>%slice(-c(outliers_index))

#outlier
boxplot(csv_Data$prob_death,ylab="prob_death")
outliers=boxplot.stats(csv_Data$prob_death)$out
outliers_index=which(csv_Data$prob_death %in% c(outliers))
length(outliers)#Getting number of outliers
#removing
csv_Data<-csv_Data%>%slice(-c(outliers_index))

#Storing the dataframe into another datframe for later usage:

stored_csv_data<-csv_Data

#Encoding the categorical variables i.e. consent cases and consent deaths

csv_Data$consent_deaths<-factor(csv_Data$consent_deaths,levels=c("Agree","Not agree"),labels=c(1,0))

#Encoding the categorical variable i.e. state:

csv_Data$state<-factor(csv_Data$state,levels=c("AL","AR","AZ","CA","CO","CT","DE","FL","FSM","GA",
                                               "GU","HI","IA","ID","IL","IN",
                                               "KY","LA","MA","ME","MI","MO",
                                               "MP","MS","MT","NC","ND","NE",
                                               "NH","NJ","NY","NYC",
                                               "OH","OK","OR","PA","PR","RMI","SC","TN",
                                               "TX","UT","VA","VT","WI","WV","WY"),
                       labels=c(1,2,3,4,5,6,7,8,9,10,11,12,13,
                                14,15,16,17,18,19,20,21,22,23,24,25,26,27,
                                28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47))

##Splitting the data

library(caTools)
set.seed(123)
split = sample.split(csv_Data$consent_deaths, SplitRatio = 0.35)
training_set = subset(csv_Data, split == TRUE)
test_set = subset(csv_Data, split == FALSE)

##Scaling the data

training_set[,2:9]=scale(training_set[2:9])
test_set[,2:9]=scale(test_set[2:9])

#Using Grid Search

grid_search=train(form=consent_deaths ~ tot_cases+new_case+pnew_case+tot_death+conf_death+prob_death+new_death+pnew_death,
                  data=training_set, method = 'knn')
grid_search$bestTune#Getting k=9 after tuning.

#Using KNN algorithm with k=9

library(class)
y_pred = knn(train = training_set[, 2:9],
             test = test_set[, 2:9],
             cl = training_set[, 10],
             k = 9,
             prob = TRUE)

#Making the confusion matrix
cm = table( test_set[, 10],y_pred )
cm
confusionMatrix(test_set[, 10],y_pred)


#Using K-Fold CV on KNN

library(caret)

#Creating the different folds
folds=createFolds(training_set$consent_deaths,k=10)

#Applying KCV with folds calculated above.
cv=lapply(folds, function(x){
  training_fold=training_set[-x,]
  test_fold=training_set[x,]
  y_pred = knn(train = training_fold[, -10],
               test = test_fold[, -10],
               cl = training_fold[, 10],
               k = 9,
               prob = TRUE)
  cm = table( test_fold[, 10],y_pred )
  accuracy=(cm[1,1]+cm[2,2])/(cm[1,1]+cm[2,2]+cm[1,2]+cm[2,1])
  return(accuracy)
})
knn_accuracy = mean(as.numeric(cv))
print(paste("The average accuracy of KNN came to be: ",knn_accuracy))

#Using Grid Search on SVC to get the best parameters:

grid_search=train(form=consent_deaths ~ tot_cases+new_case+pnew_case+tot_death+conf_death+prob_death+new_death+pnew_death,
                  data=training_set, method = 'svmRadial')
grid_search$bestTune

#Using SVC with Tuned Parameters as obtained above:

library(e1071)

classifier=svm(formula = consent_deaths ~ tot_cases+new_case+pnew_case+tot_death+conf_death+prob_death+new_death+pnew_death,
               data=training_set,type='C-classification',kernel='radial',sigma=0.3796175)

#Predicting the Test set results
prob_pred = predict(classifier, newdata = test_set[-10])

#Making the Confusion Matrix
cm = table( test_set[, 10],prob_pred )
cm
confusionMatrix(prob_pred,test_set[,10])

#Using K-Fold CV on SVC

library(caret)
#Creating the folds to implement in KCV:
folds=createFolds(training_set$consent_deaths,k=10)
#Creating function for KCV:
cv=lapply(folds, function(x){
  training_fold=training_set[-x,]
  test_fold=training_set[x,]
  classifier = svm(formula = consent_deaths ~ tot_cases+new_case+pnew_case+tot_death+conf_death+prob_death+new_death+pnew_death,
                   data = training_fold,
                   type = 'C-classification',
                   kernel = 'radial',sigma=0.3380878)
  prob_pred = predict(classifier, newdata = test_fold[-10])
  cm = table( test_fold[, 10],prob_pred )
  accuracy=(cm[1,1]+cm[2,2])/(cm[1,1]+cm[2,2]+cm[1,2]+cm[2,1])
  return(accuracy)
})
accuracy = mean(as.numeric(cv))
print(paste("The average accuracy of SVC came to be: ",accuracy))

#Grouping the dataframe state wise to get insights about the data:

csv_Data_Grouped = stored_csv_data%>%
  select(state,tot_cases,new_case,pnew_case,tot_death,conf_death,prob_death,new_death,pnew_death,consent_deaths) %>%
  group_by(state) %>%
  summarise(total_cases=sum(tot_cases,na.rm=TRUE),
            new_cases = sum(new_case,na.rm=TRUE),
            probablenew_cases = sum(pnew_case,na.rm=TRUE),
            total_deaths=sum(tot_death,na.rm=TRUE),
            new_deaths=sum(new_death,na.rm=TRUE),
            probablenew_deaths=sum(pnew_death,na.rm=TRUE),
            confirmed_deaths=sum(conf_death,na.rm = TRUE),
            consent_deaths=consent_deaths[1])
View(csv_Data_Grouped)

#Filtering the data based on Probable cases more than 20k and resulting deaths:

csv_Data_Grouped%>%filter(probablenew_cases>20000)%>%top_n(10,probablenew_deaths)

#Filtering top 10 states with total cases and confirmed deaths more than 1 lakh deaths:

csv_Data_Grouped%>%filter(total_cases>100000)%>%top_n(10,confirmed_deaths)

#Filtering entire dataset to check for states with confirmed deaths more than 5 lakh and high new probable deaths:

csv_Data_Grouped%>%filter(confirmed_deaths>500000)%>%top_n(20,probablenew_deaths)

#Subplot of Probable deaths and Confirmed Deaths
library(plotly)
fig1 <- plot_ly(csv_Data_Grouped, x = ~state, y = ~probablenew_deaths)
fig1 <- fig1 %>% add_lines(name = ~"probablenew_deaths")
fig2 <- plot_ly(csv_Data_Grouped, x = ~state, y = ~confirmed_deaths)
fig2 <- fig2 %>% add_lines(name = ~"confirmed_deaths")
fig <- subplot(fig1, fig2)
fig

#Pie Charts showing multiple attributes results across different states

fig<-plot_ly()
fig<-fig%>%add_pie(values=csv_Data_Grouped$total_deaths,labels=csv_Data_Grouped$state,
                   domain=list(row=0,column=0),textposition='inside',title="Total Deaths")
fig<-fig%>%add_pie(values=csv_Data_Grouped$total_cases,labels=csv_Data_Grouped$state,
                   domain=list(row=0,column=1),textposition='inside',title="Total Cases")
fig<-fig%>%add_pie(values=csv_Data_Grouped$new_cases,labels=csv_Data_Grouped$state,
                   domain=list(row=1,column=0),textposition='inside',title="New Cases")
fig<-fig%>%add_pie(values=csv_Data_Grouped$probablenew_deaths,labels=csv_Data_Grouped$state,
                   domain=list(row=1,column=1),textposition='inside',title="Probable Deaths")
fig<-fig%>%layout(title="Pie Charts showing Different States Covid Cases, Probable Cases, Deaths",
                  grid=list(rows=2,columns=2),title="Multiple Pie Charts For Different U.S. States")
fig

#Scatter plot showing "Increasing trend of Covid cases".
fig<-plot_ly(type = 'scatter',data=csv_Data_Grouped,
             x = ~total_cases,
             y = ~new_cases,
             text = paste(
                          "<br>State: ", csv_Data_Grouped$state,
                          "<br>Total Cases: ", csv_Data_Grouped$total_cases,
                          "<br>New Cases:",csv_Data_Grouped$new_cases,
                          "<br>Probable Cases: ", csv_Data_Grouped$probablenew_cases),
             hoverinfo = 'text',
             mode = 'markers',
             marker=list(size=10))
fig<-fig%>%layout(title="Increasing trend of Covid cases across different states")
fig
