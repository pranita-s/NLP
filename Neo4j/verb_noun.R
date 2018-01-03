## Not run: 
library(RNeo4j)

setwd("D:/NLP/Divay/edgelist_creation")

data <- as.data.frame(read.csv("edge_list.csv", stringsAsFactors = F))

data <- full_gr_edge_attr2
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

# data = data.frame(Origin = c("boy", "Sam", "Stanford"),
#                   verb = c("reading", "riding", "located"),
#                   Destination = c("book", "bike", "California"))

# 
# query = "
# MERGE (origin:firstNode {name:{origin_name}})
# MERGE (destination:secondNode {name:{dest_name}})
# CREATE (origin)<-[:ORIGIN]-(:Flight {number:{flight_num}})-[:DESTINATION]->(destination)
# "

t = newTransaction(graph)

for (i in 1:nrow(data)) {
  origin_name = data[i, ]$from
  type_name = data[i, ]$type
  dest_name = data[i, ]$to
  query = paste0("
                 MERGE (origin:Noun {name:{origin_name}})
                 MERGE (destination:Noun {name:{dest_name}})
                 CREATE (origin)-[:",type_name,"]->(destination)")
  
  appendCypher(t,
               query,
               origin_name = origin_name,
               dest_name = dest_name)
}

commit(t)



## End(Not run)