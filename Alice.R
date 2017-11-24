alice<-gutenberg_download(11)

alice<-alice%>%
  filter(!str_detect(alice$text,'^CHAPTER'))

alice<-alice[10:3339,]

alice_words<-alice%>%
  unnest_tokens(word,text)

bing<-get_sentiments('bing')

alice_words<-inner_join(alice_words,bing)

alice_words$gutenberg_id<-NULL

alice_words<-alice_words%>%
  group_by(word)%>%
  summarize(freq=n(),sentiment=first(sentiment))

wordcloud(alice_words$word,alice_words$freq, min.freq = 3)

#Can't get this to work
wordcloud2(alice_words,fig='A,jpg',size=.5,backgroundColor ='black')

alice_matrix<-acast(alice_words,word~sentiment,value.var='freq',fill=0)

comparison.cloud(alice_matrix,colors=c('red','green'))

