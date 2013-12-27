#RMeCabとwordcloudパッケージをインストールしてない場合、インストールする
#install.packages ("RMeCab", repos = "http://rmecab.jp/R")
#install.packages("wordcloud", dependencies = TRUE)


library(RMeCab)
library(wordcloud)

#readcsvで文字化けしてしまったので、readLine経由で読み込み
tweetList <-readLines("tweetList.csv", encoding="UTF-8")
tweetList <- read.csv(text=tweetList)

#2013年を含むものを抽出
colNum<-grep("2013",tweetList$timestamp)
tweetList.2013<-tweetList[colNum[1: length(colNum)],]

#現在の作業ディレクトリに単語リストを出力
write.table(tweetList.2013$text, "rrtweetList2013.txt", quote=F,col.names=F, append=T)

#形態素解析して、単語抽出
txtFreq <- RMeCabFreq("tweetList2013.txt")

#40以上、100未満の固有名詞OR一般名詞を選別
wordList <- txtFreq[txtFreq$Freq>=40 & txtFreq$Freq<100 & txtFreq$Info1 == "名詞" & (txtFreq$Info2 =="固有名詞"  | txtFreq$Info2 == "一般"),]

#1文字の単語を除外
wordList$wordNum <- nchar(wordList$Term)
wordList <- wordList[wordList$wordNum >1,]

#その他、htttpなどの不要な単語を削除
wordList <- wordList[wordList$Term != "jp" &
                       wordList$Term != "https"&
                       wordList$Term != "RT",]

#降順に並び替え
wordList<- wordList[order(wordList$Freq, decreasing=T),]
# フォントリストに Meiryo UI を追加
windowsFonts(MeiryoUI = "Meiryo UI")
# カラースケールを Dark2 に設定
pal <- brewer.pal(8, "Dark2")
#ワードクラウドを出力
wordcloud(wordList$Term,wordList$Freq,colors=pal,scale = c(2,-1))
