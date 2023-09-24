# Text Classification on Consumer Complaint Dataset

# Step 1: Explanatory Data Analysis and Feature Engineering
# Load the dataset
complaints <- read.csv("consumer_complaints.csv")

# Perform exploratory data analysis
summary(complaints)
head(complaints)

# Perform feature engineering if needed

# Step 2: Text Pre-Processing
# Clean and preprocess the text data
library(tm)
corpus <- Corpus(VectorSource(complaints$text))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stripWhitespace)

# Create a document-term matrix
dtm <- DocumentTermMatrix(corpus)

# Step 3: Selection of Multi Classification Model
# Select a suitable multi-classification model
# Example: Naive Bayes Classifier
library(e1071)
model <- naiveBayes(dtm, as.factor(complaints$category))

# Step 4: Comparison of Model Performance
# Compare the performance of different models
# Example: Cross-validation
library(caret)
ctrl <- trainControl(method = "cv", number = 5)
model_comparison <- train(as.matrix(dtm), as.factor(complaints$category), method = "nb", trControl = ctrl)

# Step 5: Model Evaluation
# Evaluate the selected model
# Example: Confusion Matrix
predictions <- predict(model, dtm)
confusionMatrix(predictions, as.factor(complaints$category))

# Step 6: Prediction
# Make predictions on new consumer complaints
# Example: New complaint text
new_complaint <- "I have been receiving debt collection calls for a loan I never took"
new_corpus <- Corpus(VectorSource(new_complaint))
new_corpus <- tm_map(new_corpus, content_transformer(tolower))
new_corpus <- tm_map(new_corpus, removePunctuation)
new_corpus <- tm_map(new_corpus, removeNumbers)
new_corpus <- tm_map(new_corpus, removeWords, stopwords("english"))
new_corpus <- tm_map(new_corpus, stripWhitespace)
new_dtm <- DocumentTermMatrix(new_corpus)
prediction <- predict(model, new_dtm)

# Print the predicted category
print(prediction)