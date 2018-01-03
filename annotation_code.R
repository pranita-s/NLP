options(java.parameters = "-Xmx1024m")
library(coreNLP)
coreNLP::initCoreNLP()
library(data.table)
library(sqldf)
#text <- "Jouppi joined Google in late 2013 to work on what became the TPU, after serving as a hardware researcher at places like HP and DEC, a kind of breeding ground for many Google's top hardware designers. He says the company considered moving its neural networks onto FPGAs, the kind of programmable chip that Microsoft uses."

text <- "Obama was elected to the Illinois state senate in 1996 and served there for eight years. In 2004, he was elected by a record majority to the U.S. Senate from Illinois and, in February 2007, announced his candidacy for President."
text1 <- "Obama was elected to the Illinois state senate in 1996 and served there for eight years. In 2004, he was elected by a record majority to the U.S. Senate from Illinois and, in February 2007, announced his candidacy for President."

#q1 <- "A car starts from rest and accelerates uniformly over a time of 5.21 seconds for a distance of 110.0 m. Determine the acceleration of the car"

pronouns <- c("he","she","it")
possessive <- c("his","her")

annotation <- coreNLP::annotateString(text)
coref <- as.data.frame(annotation[6])
colnames(coref) <- c("corefid","sentence","start","endc","head","text")
token <- as.data.frame(annotation[1])
colnames(token) <- c("sentence","id","token","lemma","begin","end","pos","NER","speaker")

coref_pos <- sqldf("Select token.begin,token.end,token.pos,coref.text,coref.corefid from coref,token where coref.text = token.token")

max_corefid <- max(coref_pos$corefid)

for(i in 1:max_corefid){
  
  query <- paste0("select * from coref_pos where corefid = ",i)
  temp <- sqldf(query)
  if(TRUE %in% (temp$pos %in% c("PRP","PRP$")) & TRUE %in% (temp$pos %in% c("NNP","NNPS"))){
    pronoun_seq <- which((temp$pos %in% c("PRP","PRP$")))
    for(j in 1:length(pronoun_seq)){
      if(temp$text[pronoun_seq[j]] %in% pronouns){
        noun_index <- which(temp$pos %in% c("NNP","NNPS"))
        #replacement <- 
        pronoun <- paste0(" ",temp$text[pronoun_seq[j]]," ")
        final <-  gsub(pronoun,temp$text[noun_index],text1)
      }
      else if(temp$text[pronoun_seq[j]] %in% possessive){
        noun_index <- which(temp$pos %in% c("NNP","NNPS"))
        replacement <- paste0(" ",temp$text[noun_index],"'s ")
        pronoun <- paste0(" ",temp$text[pronoun_seq[j]]," ")
        final <-  gsub(pronoun,replacement,text1)
      }
    }
    
    
  }
 
  
}



# Annotation:
# 1.Token
# 2.Parse
# 3.Basic Dependencies
# 4.Collapsed Dependencies
# 5.Collapsed ProcDependencies
# 6.Coreference Resolution
# 7.Sentiment
