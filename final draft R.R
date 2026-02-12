library(dplyr)
library(corrplot)
library(ggplot2)

setwd('C:/Users/minna/OneDrive/Desktop')
getwd()

df <- read.csv('dataset proj.csv')
df


df_clean <- df[!apply(df == "unknown", 1, any), ]
df_clean <- na.omit(df_clean)


colnames(df_clean)[1] <- 'age'
colnames(df_clean)[ncol(df_clean)] <- 'subscribed'

write.csv(df_clean, "df_cleaned_R_proj.csv", row.names = FALSE)

cat('original number of rows: ', nrow(df), '\n')
cat('cleaned dataset number of rows: ', nrow(df_clean), '\n')
cat('removed rows: ', nrow(df)-nrow(df_clean), '\n')

cleandf_numeric <- df_clean[sapply(df_clean, is.numeric)]

summary(cleandf_numeric)

print('frequency distribution: ')
print('job: ')
table(df_clean$job)
print('martial: ')
table(df_clean$marital)
print('education: ')
table(df_clean$education)
print('contact: ')
table(df_clean$contact)
print('outcome of the previous marketing campaign : ')
table(df_clean$poutcome)


print('correlation matrix: ')

cor(cleandf_numeric)

heatmapCorNum <- corrplot(cor(cleandf_numeric), method = 'number', type='upper')

singleSampple_T_test <- t.test(df_clean$balance, mu=1250)

twoSample_T_test <- t.test(df_clean$previous, df_clean$campaign, paired=TRUE)

anova_one_way <- aov(balance~marital, data=df_clean)
print(anova_one_way)
summary(anova_one_way) 

ggplot(df_clean, aes(x = marital, y = balance, fill = marital)) +
  geom_boxplot() +
  labs(
    title = "Account Balance by marital status",
    x = "marital status",
    y = "Balance"
  ) +
  theme_minimal() 

edu_sub_table<- table(df_clean$education, df_clean$subscribed)
chi_test<- chisq.test(edu_sub_table)

ggplot(df_clean, aes(x=factor(marital), fill = factor(marital)))+
  geom_bar(width=.8)+
  theme_classic()+
  labs(title = 'barchart representing marital status', x= 'marital status', y='frequncy of marital status')+
  geom_text(stat = 'count', aes(label = ..count..), vjust=-0.5)


grouped_df <- df_clean %>%
  group_by(job) %>%
  summarise(mean_age = round(mean(age)))

ggplot(grouped_df, aes(x=factor(job), y= mean_age, fill = factor(job)))+
  geom_bar(stat="identity",width=0.5)+
  theme_classic()+
  labs(title="histogram for job and the mean of age",x="job",y="mean age")+
  geom_text(aes(label=mean_age),vjust=-0.5,color='red',size=5)


ggplot(df_clean, aes(x=duration, y=balance))+
  geom_point()+
  theme_minimal()

df_dur <- df_clean %>%
  group_by(month) %>%
  summarise(mean_balance = mean(balance), mean_duration = mean(duration))

ggplot(df_dur, aes(x=month, y=mean_balance, group = 1))+
  geom_line()+
  theme_minimal()


ggplot(df_dur, aes(x=month, y=mean_duration, group = 1))+
  geom_line()+
  theme_minimal()


ggplot(df_clean, aes(x=contact, fill = factor(contact)))+
  geom_bar(width=0.8, alpha= 0.8)+
  theme_minimal()+
  labs(title = 'barchat', x='ways of contact', y= 'frequency of contact method')+
  geom_text(stat='count', aes(label=..count..), vjust=-0.5)


ggplot(df_clean, aes(x=contact, y= balance, fill = factor(contact)))+
  geom_bar(stat='identity', width= 0.6)+
  theme_minimal()+
  labs(title = 'histo', x='cintact', y='balance')+
  geom_text(aes(label='balance'), vjust=-0.5)
         