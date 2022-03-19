import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final String imageUrl = 'https://static7.depositphotos.com/1044234/755/i/600/depositphotos_7553041-stock-photo-road-tripping.jpg';
  final String imageUrl2 = 'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg';

  final CacheManager cacheManager = CacheManager(
    Config(
      'images_Key',
      maxNrOfCacheObjects: 20,
      stalePeriod: const Duration(days: 3)
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cached Network Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CachedNetworkImage(
              cacheKey: 'first_image',
              cacheManager: cacheManager,
              key: UniqueKey(),
              imageUrl: imageUrl,
              width: MediaQuery.of(context).size.width,
              height: 250,
              progressIndicatorBuilder: (context, url, progress){
                return ColoredBox(
                  color: Colors.black12,
                  child: Center(child: CircularProgressIndicator(value: progress.progress,)),
                );
              },
              // placeholder: (context, url) => const ColoredBox(
              //   color: Colors.black12,
              //   child: Center(child: CircularProgressIndicator()),
              // ),
              fit: BoxFit.cover,
              // fadeInCurve: Curves.bounceOut,
              // fadeInDuration: const Duration(seconds: 3),
              errorWidget: (context, url, error) => const ColoredBox(
                color: Colors.black12,
                child: Icon(Icons.error, size: 50, color: Colors.red,),
              ),
            ),
            const SizedBox(height: 20,),
            CircleAvatar(
              key: UniqueKey(),
              radius: 100,
              backgroundColor: Colors.black12,
              backgroundImage: CachedNetworkImageProvider(
                imageUrl2,
                cacheManager: cacheManager,
                cacheKey: 'second_image'
              ),
            ),

            const SizedBox(height: 20,),

            ElevatedButton(onPressed: clearCache, child: const Text('Clear cache')),
            ElevatedButton(onPressed: ()=> clearCache(index: 0), child: const Text('Clear First Image')),
            ElevatedButton(onPressed: ()=> clearCache(index: 1), child: const Text('Clear Second Image')),

          ],
        ),
      )
    );
  }

  void clearCache({int? index}) {
    imageCache?.clear();
    imageCache?.clearLiveImages();



    if(index != null){
      cacheManager.removeFile(index == 0 ? 'first_image' : 'second_image');
    }else {
      cacheManager.emptyCache();
    }


    // DefaultCacheManager().emptyCache();
    setState(() {

    });
  }
}
