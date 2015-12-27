# download necessary libs{commented}
#install.packages("devtools"); library(devtools)

#install_github("geoffjentry/twitteR")
#install.package("NLP")
#install.package("TM")
#install.packages("RColorBrewer")
#install.packages("wordcloud")
#install.packages("SnowballC")
library(twitteR)
library(NLP)
library(tm)
library(RColorBrewer)
library(wordcloud)
library(SnowballC)
# save credentials
requestURL = "https://api.twitter.com/oauth/request_token"
accessURL = "https://api.twitter.com/oauth/access_token"
authURL = "https://api.twitter.com/oauth/authorize"
consumerKey = "ggXVtM4ivy0nQ50Rc3nqIDAkw"
consumerSecret = "gtPQEweYwxdkSXpQnWi2T5NuzkDgmJR6TWGGzceLemKmxrAgxs"

accessToken = "109808141-Y2PTNwhv5aoKG63kP7FV0DYq7L1LTriMdZw5xolX"
accessSecret = "kHwoQJWMR1D0wFXrmc05LvQlC2d8nps3d922041BlkOKE"

setup_twitter_oauth(consumerKey,
                    consumerSecret,
                    accessToken,
                    accessSecret)

##irantalks <- searchTwitter("#irandeal", n = 9800,lang='en')
##head(irantalks)
##save(twitterdata, file = "twitterdata-irandeal-en.Rdata")
load("twitterdata-en.Rdata")
irantalks_text = sapply(irantalks, function(x) x$getText())
irantalks_corpus = Corpus(VectorSource(irantalks_text))

tdm = TermDocumentMatrix(
  irantalks_corpus,
  control = list(
    removePunctuation = TRUE,
    stopwords = c("irantrorrism", "iranwar", stopwords("english")),
    removeNumbers = TRUE, tolower = TRUE)
)
# remove extra whitespace 
irantalks_corpus <- tm_map(irantalks_corpus, stripWhitespace)
# keep a copy of corpus to use later as a dictionary for stem completion 
irantalks_corpus_copy <- irantalks_corpus 
# stem words 
irantalks_corpus <- tm_map(irantalks_corpus, stemDocument)
m = as.matrix(tdm)
##inspect(m)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing = TRUE) 
# create a data frame with words and their frequencies
dm = data.frame(word = names(word_freqs), freq = word_freqs)

wordcloud(dm$word, dm$freq, random.order = FALSE, colors = brewer.pal(8, "Dark2"))

