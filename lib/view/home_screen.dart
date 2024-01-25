import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news/models/news_channel_headlines_model.dart';
import 'package:news/view/categories.dart';
import 'package:news/view/news_detail.dart';
import 'package:news/view_model/news_view_model.dart';

import '../models/categories_news_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum NewsFilterList{bbcNews, aryNews, independent, reuters, cnn, alJazeera }
class _HomeScreenState extends State<HomeScreen> {

  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MM dd yyyy');
  NewsFilterList? selectedItem;
  String name = 'bbc-news';
  String categoryName = 'General';

  List<String> categoryList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen()));
          },
          icon: Image.asset('images/category_icon.png',
            height: 25,
            width: 25,
          )
        ),
        title: Text('News', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),),
        centerTitle: true,
        actions: [
          PopupMenuButton<NewsFilterList>(
            initialValue: selectedItem,
            onSelected: (NewsFilterList item){

              if(NewsFilterList.bbcNews.name == item.name){
                name = 'bbc-news';
              } else if (NewsFilterList.aryNews.name == item.name){
                name = 'ary-news';
              } else if (NewsFilterList.alJazeera.name == item.name){
                name = 'al-jazeera-english';
              } else if (NewsFilterList.reuters.name == item.name){
                name = 'reuters';
              } else if (NewsFilterList.cnn.name == item.name){
                name = 'cnn';
              }

              setState(() {
                selectedItem = item;      // part 6 start
              });
            },
            itemBuilder: (context) => <PopupMenuEntry<NewsFilterList>>[
              const PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.bbcNews,
                child: Text('BBC News'),
              ),
              const PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.aryNews,
                child: Text('ARY News'),
              ),
              const PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.alJazeera,
                child: Text('Al-Jazeera'),
              ),
              const PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.reuters,
                child: Text('Reuters'),
              ),
              const PopupMenuItem<NewsFilterList>(
                value: NewsFilterList.cnn,
                child: Text('CNN News'),
              ),
            ]
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * .55,
              width: size.width,
              child: Container(
                height: size.height * .55,
                width: size.width,
                child: FutureBuilder<NewsChannelsHeadlinesModel>(
                    future: newsViewModel.fetchNewsChannelsHeadlinesApi(name),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(
                          child: SpinKitCircle(size: 50, color: Colors.blue,),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.articles!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index){
                              DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

                              return InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(
                                      newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                      newsTitle: snapshot.data!.articles![index].title.toString(),
                                      newsDate: format.format(dateTime),
                                      author: snapshot.data!.articles![index].author.toString(),
                                      description: snapshot.data!.articles![index].description.toString(),
                                      content: snapshot.data!.articles![index].content.toString(),
                                      source: snapshot.data!.articles![index].source!.name.toString())
                                  ));
                                },
                                child: SizedBox(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: size.height * .6,
                                        width: size.width * .9,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.height * .02
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(child: spinkit2,),
                                            errorWidget: (context, url, error)
                                            => const Icon(Icons.error_outline, color: Colors.red,),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 15,
                                        child: Card(
                                          elevation: 5,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12)
                                          ),
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(15),
                                            height: size.height *.22,
                                            width: size.width * .75,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: size.width * 0.7,
                                                  child: Text(snapshot.data!.articles![index].title.toString(),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
                                                  ),
                                                ),
                                                const Spacer(),

                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(snapshot.data!.articles![index].source!.name.toString(),
                                                        style: GoogleFonts.poppins(fontSize: 13,
                                                            color: Colors.blue,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                    Text(format.format(dateTime),
                                                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      }
                    }
                ),
              ),
            ),

            FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi('General'),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: SpinKitCircle(size: 50, color: Colors.blue,),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.articles.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index){
                            DateTime dateTime = DateTime.parse(snapshot.data!.articles[index].publishedAt.toString());

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      height: size.height * .18,
                                      width: size.width * .3,
                                      imageUrl: snapshot.data!.articles[index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                          child: const Center(
                                            child: SpinKitCircle(size: 50, color: Colors.blue,),
                                          )
                                      ),
                                      errorWidget: (context, url, error)
                                      => const Icon(Icons.error_outline, color: Colors.red,),
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      height: size.height * .18,
                                      width: size.width * .9,
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Column(
                                        children: [
                                          Text(snapshot.data!.articles![index].title.toString(),
                                            maxLines: 3,
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black45
                                            ),
                                          ),
                                          const Spacer(),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(snapshot.data!.articles[index].source.name.toString(),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.blue
                                                  ),
                                                ),
                                              ),
                                              Text(format.format(dateTime),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                      ),
                    );
                  }
                }
            )
          ],
        ),
      )
    );
  }
}


const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);