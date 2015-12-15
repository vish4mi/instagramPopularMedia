# instagramPopularMedia
Showing instagram popular media

1.In this application I have hit the most popular APIs of instagram and shown the images I am getting in response.
2.Instagram media/popular API is depricated and not working with any application created after 17 Nov, 2015 as per instagram documentation. However, hardcoding the token I got from apigee, its working. I could figure out that the access token for both the request were different. And even appending client id dont work. It was working some times back but now its not working for new applications.
3. I have mentioned couple of APIs I have tried and put those commented. So currently there are two working APIs.
4. I have used SDWebImage for caching images in documents directory of application bundle.
