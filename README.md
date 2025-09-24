# social_network_system_design


# Функциональные требования

- публикация постов из путешествий с фотографиями, небольшим описанием и привязкой к конкретному месту путешествия;
- оценка и комментарии постов других путешественников;
- подписка на других путешественников, чтобы следить за их активностью;
- поиск популярных мест для путешествий и просмотр постов с этих мест;
- просмотр ленты других путешественников и ленты пользователя, основанной на подписках в обратном хронологическом порядке;

# Не функциональные требования

- ограничения:
    - максимум 10 фото в посте;
    - среднее кол-во фото 6 в посте;
    - максимальный вес фото 10 Мб;
    - средний вес фото при создании поста 1,6 Мб;
    - средний вес фото при получении поста 0,4 Мб;
    - описание максимум 100 символов;
    - комментарии максимум 250 символов;
    - максимум подписчиков 1 000 000;
    - максимум комментарий 10 000;
    - среднее кол-во комментарий к посту 500;

- география и аудитория:
    - DAU 10 000 000;
    - только СНГ;
    - сезонность отпусков(x2 на создание постов);

- доступность и надежность:
    - доступность 99,95%;
    - данные храним всегда;
    - фото храним и отдаем в сжатом виде и до fullHD;

- платформы:
    - мобильные устройства и ВЕБ;

- пользовательская активность:
    - пользователь создает 1 пост в день;
    - пользователь смотрит посты по 10 раз в день;
    - средняя длина ленты 20 постов;

    - ленту грузим без комментарий;
    - пользователь в среднем оставляет 10 комментария в день;
    - пользователь в среднем читает комментарии к 10 постам в день по 100 комментарий за запрос;

    - реакции лайк-дизлайк на пост;
    - пользователь ставит реакции на половину постов которые смотрит, в среднем 100 реакций

    - поиск мест по тегу и имени города/страны;
    - пользователь в среднем ищет места 1 раз в день и получает ленту на 20 постов;

    - пользователь может подписываться и отписываться, среднее кол-во действий 1 в неделю;
    - среднее кол-во подписчиков 10 00;

- время отклика:
    - время запроса на создание поста до 2 секунд;
    - время запроса на чтение ленты до 2 секунд;
    - поиск популярных мест до 5 секунд;


# Load

  - RPS
      - RPS(read posts) = 10 000 000 * 3 / 86400 = **350**
      - RPS(write posts) = 10 000 000 / 2 / 86400 = **60**

      - RPS(read comments) = 10 000 000 * 10 / 86400 = **1 200**
      - RPS(write comments) = 10 000 000 * 10 / 86400 = **1 200**

      - RPS(reactions write) = 10 000 000 * 100 / 86400 = **11 600**

      - RPS(search places) = 10 000 000 / 86400 = **120**

      - RPS(subscribe) = 10 000 000 * 0.15 / 86400 = **18**

  - Traffic
      - traffic(read post meta) = rps * avgPostMetaSize *  postsPerRead = 350 * 900 bytes * 20 = **6.3 gb/s**
      - traffic(write post meta) = rps * avgPostMetaSize = 60 * 900 bytes = 54 mb/s

      - traffic(read post media) = rps * avgPhotoSize * amountPhotos * postsPerRead = 350 * 400 000 bytes * 6 * 20 = **16.8 gb/s**
      - traffic(write post media) = rps * avgUploadPhotoSize * amountPhotos = 60 * 1 600 000 bytes * 6 = **576 mb/s**

      - traffic(write comments) =rps * commentSize =  1200 * 500 bytes = **600 kb/s**
      - traffic(read comments) =rps * commentSize * commentsAmountPerPost  =  1200 * 500 * 100  = **60 mb/s**

      - reactions(react write) = rps * reactionSize = 11 600 * 40  = 23 200 bytes/s = **23 kb/s**

      - search place(places read meta) = rps * avgPostMetaSize * postsPerRead = 120 * 900 bytes * 20 = **2.2 mb/s**
      - search place(places read media) = rps * avgPhotoSize * amountPhotos * postsPerRead = 120 * 400 000 bytes * 6 *20 = **23 gb/s**

      - subscribe (write) = rps * subSize = 18 * 24 bytes = 432 B/s = 0,000432 mb/s

  - Required memory:

      - Replication factor = 2
      - Service operation time = 1 years

      - Post: postSize * PRS create * 86400 * 365 = 1090 bytes * 60 * 86400 * 365 = 2 TB
  
      - Comments: commentSize * PRS create * 86400 * 365 = 173 bytes * 1 200 * 86400 * 365 = 6,6 TB

      - Reactions:  reactSize * PRS create * 86400 * 365 = 42 bytes * 11 600 * 86400 * 365 = 15,4 TB

      - Subs: subsSize * avgSubs * DAU * 365 = 24 bytes * 1000 * 10 000 000 = 240 GB

      Precalculated feed for user under 10 000 subs (80% of users) with 20 post. If the values are higher, the feed is calculated at the time of the request.
    - PreCalcFeed: rowSize * Rps create post * 0.8 * amount of post in feed  := 32 bytes * 60 * 0.8 * 20 * 86400 * 365 = 1 TB

    - Photos(S3): avgPhotoSizeCompressed * avgPhotoAmount* RPS create post * 86400 * 365 = 400 000 bytes * 6 * 60 * 86400 * 365 = 4 582 368 TB
  
    Required memory for 1 year = 25 TB * 2 replicas + 30% = 65 TB

# Disks

  - Post HDD
    - Disks_for_capacity = capacity / disk_capacity = 2 TB / 32 TB = 0,65 disk
    - Disks_for_throughput = traffic / disk_throughput= 6 300 mb/s (no photo in DB) / 100 mb/s = 63 disks
    - Disks_for_iops = iops / disk_iops = 410 / 100 = 4.1 disks
    - Disks = 63

  - Post SSD (SATA)
    - Disks_for_capacity = capacity / disk_capacity = 2 TB / 100 TB = 0,021 disk
    - Disks_for_throughput = traffic / disk_throughput= 6 300 mb/s (no photo in DB) / 500 mb/s = 12,6 disks
    - Disks_for_iops = iops / disk_iops = 410 / 1000 = 0.41 disks
    - Disks = 13 disks

  - Post SSD (nVME)
    - Disks_for_capacity = capacity / disk_capacity = 2 TB / 30 TB = 0,067 disk
    - Disks_for_throughput = traffic / disk_throughput= 6 300 mb/s (no photo in DB) / 3 000 mb/s = 2,1 disks
    - Disks_for_iops = iops / disk_iops = 410 / 10 000 = 0.041 disks
    - Disks = 3 disks

 ____

  - Comments HDD
    - Disks_for_capacity = capacity / disk_capacity = 6.6 TB / 32 TB = 0,20625 disk
    - Disks_for_throughput = traffic / disk_throughput= 60.6 mb/s / 100 mb/s = 0,606 disks
    - Disks_for_iops = iops / disk_iops = 2400 / 100 = 24 disks
    - Disks = 24

  - Comments SSD (SATA)
    - Disks_for_capacity = capacity / disk_capacity = 6.6 TB / 100 TB = 0,066 disk
    - Disks_for_throughput = traffic / disk_throughput= 60.6 mb/s / 500 mb/s = 0,1212 disks
    - Disks_for_iops = iops / disk_iops = 2400 / 1000= 2.4 disks
    - Disks = 3
-------

  - Reactions HDD
    - Disks_for_capacity = capacity / disk_capacity = 15,4 TB / 32 TB = 0,481 disk
    - Disks_for_throughput = traffic / disk_throughput= 0.023 mb/s / 100 mb/s = 0,00023 disks
    - Disks_for_iops = iops / disk_iops = 11 600 / 100 = 116 disks
    - Disks = 116
    
  - Reactions SSD (SATA)
    - Disks_for_capacity = capacity / disk_capacity = 15,4 TB / 100 TB = 0,154 disk
    - Disks_for_throughput = traffic / disk_throughput= 0.023 mb/s / 500 mb/s = 0,000046 disks
    - Disks_for_iops = iops / disk_iops = 11 600 / 1000 = 11.6 disks
    - Disks = 12   
    
  - Reactions SSD (nVME)
    - Disks_for_capacity = capacity / disk_capacity = 15,4 TB / 30 TB = 0,5133333333 disk
    - Disks_for_throughput = traffic / disk_throughput= 0.023 mb/s / 3 000 mb/s = 0,0000076667 disks
    - Disks_for_iops = iops / disk_iops = 11 600 / 10 000 = 1.16 disks
    - Disks = 2
 ------

  - Subs HDD
    - Disks_for_capacity = capacity / disk_capacity = 0.24 TB / 32 TB = 0,0075 disk
    - Disks_for_throughput = traffic / disk_throughput= 0,000576 mb/s / 100 mb/s = 0,00000576 disks
    - Disks_for_iops = iops / disk_iops = 18 / 100 = 0.18 disks
    - Disks = 1

  - Subs SSD (SATA)
    - Disks_for_capacity = capacity / disk_capacity = 0.24 TB / 1000 TB = 0,0075 disk
    - Disks_for_throughput = traffic / disk_throughput= 0,000576 mb/s / 500 mb/s = 0,00000576 disks
    - Disks_for_iops = iops / disk_iops = 18 / 1000 = 0.018 disks
    - Disks = 1
-------   

  - Precalculated Feed HDD
    - Disks_for_capacity = capacity / disk_capacity = 2 TB / 32 TB = 0,0625 disk
    - Disks_for_throughput = traffic / disk_throughput= 2.2 mb/s / 100 mb/s = 0,022 disks
    - Disks_for_iops = iops ((new posts + rps read)* 0.8)/ disk_iops = 328 / 100 = 0.328 disks
    - Disks = 1
    
  - Precalculated Feed SSD (SATA) 
    - Disks_for_capacity = capacity / disk_capacity = 2 TB / 100 TB = 0,02 disk
    - Disks_for_throughput = traffic / disk_throughput= 2.2 mb/s / 500 mb/s = 0,0044 disks
    - Disks_for_iops = iops ((new posts + rps read)* 0.8) / disk_iops = 328 / 1000 = 0.0328 disks
    - Disks = 1