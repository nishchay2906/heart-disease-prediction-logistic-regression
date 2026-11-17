library(readr)
library(corrplot)
library(randomForest)
library(rsample)
library(caret)
library(ranger)
library(pROC)

args <- commandArgs(trailingOnly = TRUE)
data_path <- if (length(args) > 0) args[1] else "heart_failure_clinical_records_dataset (1).csv"
data <- read_csv(data_path, col_types = "nfnfnfnnnffnf")

set.seed(235)
#split test data
data_split <- initial_split(data)
data_test <- testing(data_split)

data_train <- training(data_split)

str(data_train)

numericVars <- data_train[vapply(data_train, is.numeric, logical(1))]
factorVars <- data_train[vapply(data_train, is.factor, logical(1))]
cat("There are ", length(numericVars),"numerical Variables and ", length(factorVars),"Categorical Variables in this dataset" )

corrplot(cor(numericVars))

Log1 = glm(DEATH_EVENT ~ age+log(ejection_fraction+1)+log(serum_creatinine+1)+sex,data=data_train, family=binomial)

summary(Log1)

testPredict = predict(Log1, newdata=data_test, type="response")

hist(sqrt(data_train$platelets))

confusion.matrix<-table(data_test$DEATH_EVENT, factor(testPredict >= 0.388, levels = c(FALSE, TRUE)))

confusion.matrix

Count.correct<-confusion.matrix[1,1]+confusion.matrix[2,2]

Count.wrong<-confusion.matrix[1,2]+confusion.matrix[2,1]

Accuracy.rate<-Count.correct/(Count.correct+Count.wrong)
Accuracy.rate

library(pROC)

test_prob = predict(Log1, newdata = data_test, type = "response")

test_prob

test_roc = roc(data_test$DEATH_EVENT ~ testPredict, plot = TRUE, print.auc = TRUE)

rf <- randomForest(DEATH_EVENT ~ . - time, data = data_train, proximity = TRUE)
print(rf)

rf <- ranger(DEATH_EVENT ~ age+ejection_fraction+serum_creatinine+sex+platelets,
              data = data_train,
              mtry = 2, num.trees = 500, write.forest=TRUE, importance = "permutation")
summary(rf)
rf$confusion.matrix

pred <- predict(rf, data=data_test)$predictions

confusionMatrix(pred, data_test$DEATH_EVENT, positive = "1")
