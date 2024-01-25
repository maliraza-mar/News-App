import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news/models/categories_news_model.dart';

import '../view_model/news_view_model.dart';
import 'home_screen.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MM dd yyyy');
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: (){
                        categoryName = categoryList[index];
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: categoryName == categoryList[index] ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(child: Text(categoryList[index], style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.white
                          ),)),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
            const SizedBox(height: 20,),

            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                  future: newsViewModel.fetchCategoriesNewsApi(categoryName),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: SpinKitCircle(size: 50, color: Colors.blue,),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                          itemCount: snapshot.data!.articles.length,
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
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
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
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                    color: Colors.black45
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  )
                                ],
                              ),
                            );
                          }
                      );
                    }
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
