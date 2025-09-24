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
    - среднее кол-во подписчиков 10 000;

- время отклика:
    - время запроса на создание поста до 2 секунд;
    - время запроса на чтение ленты до 2 секунд;
    - поиск популярных мест до 5 секунд;


# Нагрузка

- RPS
    - RPS(read posts) = 10 000 000 * 3 / 86400 = **350**
    - RPS(write posts) = 10 000 000 / 86400 = **120**

    - RPS(read comments) = 10 000 000 * 10 / 86400 = **1 200**
    - RPS(write comments) = 10 000 000 * 10 / 86400 = **1 200**

    - RPS(reactions write) = 10 000 000 * 100 / 86400 = **11 600**

    - RPS(search places) = 10 000 000 / 86400 = **120**
  
    - RPS(subscribe) = 10 000 000 * 0.15 / 86400 = **18**

- Traffic
    - traffic(read posts) = rps * ((avgPhoto + avgDownloadPhotoSz) + descSize) * postPerView = 350 * ((6 * 1 600 000) + 200) * 20 = 67 201 400 000 bytes/s = **67 gb/s**
    - traffic(write posts) = rps * ((avgPhoto + avgUploadPhotoSz) + descSize) = 120 * ((6 * 1 600 000) + 200) = 1 152 024 000 bytes/s = **1.2 gb/s**

    - traffic(write comments) =rps * commentSize =  1200 * 500 = 600 000 bytes/s = **600 kb/s**
    - traffic(read comments) =rps * commentSize * commentsAmountPerPost  =  1200 * 500 * 100 = 60 000 000 bytes/s = **60 mb/s**

    - reactions(react write) = rps * reactionSize = 11 600 * 2 = 23 200 bytes/s = **23 kb/s**

    - search place(places read) = rps * ((avgPhoto + avgDownloadPhotoSz) + descSize) * postPerView = 120 * ((6 * 1 600 000) + 200) * 20 =23 040 480 000 bytes/s = **23 gb/s**

    - subscribe (write) = rps * subSize = 18 * 32 bytes = 576 B/s = 0,000576 mb/s

- Required memory:

    - Replication factor = 3
    - Service operation time = 1 years

    - Post: postSize * PRS create * 86400 * 365 = 1090 bytes * 120 * 86400 * 365 = 4,2 TB
  
    - Comments: commentSize * PRS create * 86400 * 365 = 173 bytes * 1 200 * 86400 * 365 = 6,6 TB

    - Reactions:  reactSize * PRS create * 86400 * 365 = 42 bytes * 11 600 * 86400 * 365 = 15,4 TB

    - Subs: subsSize * avgSubs * DAU * 365 = 24 bytes * 1000 * 10 000 000 = 240 GB

    Precalculated feed for user under 1000 subs (80% of users) with 20 post. If the values are higher, the feed is calculated at the time of the request.
  - PreCalcFeed: rowSize * Rps create post * 0.8 * amount of post in feed  := 32 bytes * 120 * 0.8 * 20 * 86400 * 365 = 2 TB

  - Photos(S3): avgPhotoSizeCompressed * avgPhotoAmount* RPS create post * 86400 * 365 = 400 000 bytes * 6 * 120 * 86400 * 365 = 9 082 368 TB
  
  Required memory for 1 year = 28,44 TB * 3 replicas + 30% = 111 TB

#Disks


  - Post HDD
    - Disks_for_capacity = capacity / disk_capacity = 4.2 TB / 32 TB = 0,13 disk
    - Disks_for_throughput = traffic / disk_throughput= 10 mb/s (no photo in DB) / 100 mb/s = 0.1 disks
    - Disks_for_iops = iops / disk_iops = 470 / 100 = 4.7 disks
    - Disks = 5

  - Post SSD (SATA)
    - Disks_for_capacity = capacity / disk_capacity = 4.2 TB / 100 TB = 0,042 disk
    - Disks_for_throughput = traffic / disk_throughput= 10 mb/s (no photo in DB) / 500 mb/s = 0.02 disks
    - Disks_for_iops = iops / disk_iops = 470 / 1000 = 0.47 disks
    - Disks = 1
 ____

  - Comments HDD
    - Disks_for_capacity = capacity / disk_capacity = 6.6 TB / 32 TB = 0,20625 disk
    - Disks_for_throughput = traffic / disk_throughput= 60.6 mb/s / 100 mb/s = 0,606 disks
    - Disks_for_iops = iops / disk_iops = 2400 / 100 = 24
    - Disks = 24

  - Comments SSD (SATA)
    - Disks_for_capacity = capacity / disk_capacity = 6.6 TB / 100 TB = 0,066 disk
    - Disks_for_throughput = traffic / disk_throughput= 60.6 mb/s / 500 mb/s = 0,1212 disks
    - Disks_for_iops = iops / disk_iops = 2400 / 1000= 2.4
    - Disks = 3
-------

  - Reactions HDD
    - Disks_for_capacity = capacity / disk_capacity = 15,4 TB / 32 TB = 0,481 disk
    - Disks_for_throughput = traffic / disk_throughput= 0.023 mb/s / 100 mb/s = 0,00023 disks
    - Disks_for_iops = iops / disk_iops = 11 600 / 100 = 116
    - Disks = 116
    
  - Reactions SSD (SATA)
    - Disks_for_capacity = capacity / disk_capacity = 15,4 TB / 100 TB = 0,154 disk
    - Disks_for_throughput = traffic / disk_throughput= 0.023 mb/s / 500 mb/s = 0,000046 disks
    - Disks_for_iops = iops / disk_iops = 11 600 / 1000 = 11.6
    - Disks = 12   
    
  - Reactions SSD (nVME)
    - Disks_for_capacity = capacity / disk_capacity = 15,4 TB / 30 TB = 0,5133333333 disk
    - Disks_for_throughput = traffic / disk_throughput= 0.023 mb/s / 30000 mb/s = 0,0000007667 disks
    - Disks_for_iops = iops / disk_iops = 11 600 / 10 000 = 1.16
    - Disks = 2
 ------

  - Subs HDD
    - Disks_for_capacity = capacity / disk_capacity = 0.24 TB / 32 TB = 0,0075 disk
    - Disks_for_throughput = traffic / disk_throughput= 0,000576 mb/s / 100 mb/s = 0,00000576 disks
    - Disks_for_iops = iops / disk_iops = 18 / 100 = 0.18
    - Disks = 1

  - Subs SSD (SATA)
    - Disks_for_capacity = capacity / disk_capacity = 0.24 TB / 1000 TB = 0,0075 disk
    - Disks_for_throughput = traffic / disk_throughput= 0,000576 mb/s / 500 mb/s = 0,00000576 disks
    - Disks_for_iops = iops / disk_iops = 18 / 1000 = 0.018
    - Disks = 1
-------   

  - Precalculated Feed HDD
    - Disks_for_capacity = capacity / disk_capacity = 2 TB / 32 TB = 0,0625 disk
    - Disks_for_throughput = traffic / disk_throughput= 10 mb/s / 100 mb/s = 0,1 disks
    - Disks_for_iops = iops / disk_iops = 376 / 100 = 0.376
    - Disks = 1
    
  - Precalculated Feed SSD (SATA)
    - Disks_for_capacity = capacity / disk_capacity = 2 TB / 100 TB = 0,02 disk
    - Disks_for_throughput = traffic / disk_throughput= 10 mb/s / 500 mb/s = 0,02 disks
    - Disks_for_iops = iops / disk_iops = 376 / 1000 = 0.0376
    - Disks = 1
