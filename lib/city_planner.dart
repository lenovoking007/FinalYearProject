class CityPlanner {
  static Map<int, List<String>> getPlacesForCity(String city, int duration) {
    switch (city.toLowerCase()) {
      case 'lahore':
        return _getLahorePlaces(duration);
      case 'karachi':
        return _getKarachiPlaces(duration);
      case 'multan':
        return _getMultanPlaces(duration);
      case 'peshawar':
        return _getPeshawarPlaces(duration);
      case 'quetta':
        return _getQuettaPlaces(duration);
      case 'islamabad':
        return _getIslamabadPlaces(duration);
      case 'naran':
        return _getNaranPlaces(duration);
      case 'swat':
        return _getSwatPlaces(duration);
      case 'hunza':
        return _getHunzaPlaces(duration);
      case 'rawalpindi':
        return _getRawalpindiPlaces(duration);
      case 'hyderabad':
        return _getHyderabadPlaces(duration);
      case 'murree':
        return _getMurreePlaces(duration);
      case 'gawadar':
        return _getGawadarPlaces(duration);
      case 'sialkot':
        return _getSialkotPlaces(duration);
      case 'skardu':
        return _getSkarduPlaces(duration);
      case 'faisalabad':
        return _getFaisalabadPlaces(duration);
      case 'muzafarabad':
        return _getMuzafarabadPlaces(duration);
      default:
        return {};
    }
  }

  static Map<int, List<String>> _distributePlaces(List<String> places, int duration) {
    final Map<int, List<String>> dailyPlaces = {};

    if (duration <= 0) return {};
    if (duration > 15) duration = 15;

    if (duration == 1) {
      dailyPlaces[1] = places.take(5).toList();
    } else if (duration >= 2 && duration <= 5) {
      for (int day = 1; day <= duration; day++) {
        final start = (day - 1) * 4;
        final end = start + 4;
        dailyPlaces[day] = places.sublist(
            start,
            end > places.length ? places.length : end
        );
      }
    } else if (duration >= 6 && duration <= 9) {
      for (int day = 1; day <= duration; day++) {
        final start = (day - 1) * 3;
        final end = start + 3;
        dailyPlaces[day] = places.sublist(
            start,
            end > places.length ? places.length : end
        );
      }
    } else if (duration >= 10 && duration <= 13) {
      for (int day = 1; day <= duration; day++) {
        final start = (day - 1) * 2;
        final end = start + 2;
        dailyPlaces[day] = places.sublist(
            start,
            end > places.length ? places.length : end
        );
      }
    } else {
      for (int day = 1; day <= duration; day++) {
        final index = day - 1;
        if (index < places.length) {
          dailyPlaces[day] = [places[index]];
        }
      }
    }

    return dailyPlaces;
  }

  // Lahore (43 places)
  static Map<int, List<String>> _getLahorePlaces(int duration) {
    const List<String> places = [
      'Badshahi Mosque', 'Lahore Fort', 'Shalimar Gardens', 'Minar-e-Pakistan', 'Wagah Border',
      'Badshahi Mosque', 'Lahore Fort', 'Shalimar Gardens', 'Minar-e-Pakistan','Lahore Museum', 'Sheesh Mahal', 'Food Street', 'Anarkali Bazaar', 'Jahangir Tomb',
      'Noor Jahan Tomb', 'Lahore Zoo', 'Sozo Water Park', 'Packages Mall', 'Emporium Mall',
      'Liberty Market', 'Fortress Stadium', 'Gaddafi Stadium', 'Alhamra Arts Council', 'Greater Iqbal Park',
      'Hiran Minar', 'Chauburji', 'Wazir Khan Mosque', 'Data Darbar', 'Bagh-e-Jinnah',
      'Race Course Park', 'Changa Manga Forest', 'Lahore Canal', 'Safari Park', 'Lake City',
      'Model Town Park', 'Jallo Park', 'Gulshan-e-Iqbal Park', 'Shah Jamal Shrine', 'Bibi Pak Daman',
      'Samadhi of Ranjit Singh', 'Tomb of Allama Iqbal', 'Lahore Science Museum', 'Lahore Art Gallery',
      'Lahore Railway Station', 'Lahore High Court', 'University of the Punjab', 'Governor House'
    ];
    return _distributePlaces(places, duration);
  }

  // Karachi (43 places)
  static Map<int, List<String>> _getKarachiPlaces(int duration) {
    const List<String> places = [
      'Mazar-e-Quaid', 'Clifton Beach', 'Mohatta Palace', 'Frere Hall', 'Pakistan Maritime Museum',
      'Churna Island', 'Port Grand', 'Dolmen Mall', 'Empress Market', 'Pakistan Air Force Museum',
      'Karachi Zoo', 'Sindh High Court', 'Karachi Port Trust', 'Quaid-e-Azam House Museum', 'Karachi Expo Center',
      'Hill Park', 'Karachi Safari Park', 'Karachi Municipal Corporation', 'Karachi City Railway Station', 'Karachi Fish Harbour',
      'Karachi Golf Club', 'Karachi Race Club', 'Karachi Arts Council', 'Karachi University', 'Karachi Institute of Heart Diseases',
      'Karachi Cantonment Railway Station', 'Karachi Shipyard', 'Karachi Nuclear Power Plant', 'Karachi Port', 'Karachi International Container Terminal',
      'Karachi Stock Exchange', 'Karachi Press Club', 'Karachi Literature Festival', 'Karachi Food Street', 'Karachi Beach Park',
      'Karachi Water Park', 'Karachi Science Center', 'Karachi Planetarium', 'Karachi National Museum', 'Karachi War Museum',
      'Karachi Heritage Museum', 'Karachi Children Museum', 'Karachi Art Gallery'
    ];
    return _distributePlaces(places, duration);
  }

  // Multan (43 places)
  static Map<int, List<String>> _getMultanPlaces(int duration) {
    const List<String> places = [
      'Tomb of Shah Rukn-e-Alam', 'Multan Fort', 'Shrine of Bahauddin Zakariya', 'Shrine of Shah Shams Tabriz', 'Shrine of Musa Pak Shaheed',
      'Clock Tower', 'Ghanta Ghar', 'Haram Gate', 'Bohar Gate', 'Delhi Gate',
      'Pak Gate', 'Qasim Bagh Stadium', 'Multan Cricket Stadium', 'Multan Arts Council', 'Multan Museum',
      'Multan Zoo', 'Multan Public Park', 'Multan Children Library', 'Multan Railway Station', 'Multan Airport',
      'Multan Medical College', 'Multan University', 'Multan Technical College', 'Multan Law College', 'Multan Commerce College',
      'Multan Science College', 'Multan Agriculture College', 'Multan Engineering College', 'Multan Medical Hospital', 'Multan General Hospital',
      'Multan Children Hospital', 'Multan Heart Hospital', 'Multan Cancer Hospital', 'Multan Dental Hospital', 'Multan Eye Hospital',
      'Multan Skin Hospital', 'Multan Mental Hospital', 'Multan Veterinary Hospital', 'Multan Homeopathic Hospital', 'Multan Tibbi Hospital',
      'Multan Unani Hospital', 'Multan Ayurvedic Hospital', 'Multan Sports Complex'
    ];
    return _distributePlaces(places, duration);
  }

  // Peshawar (43 places)
  static Map<int, List<String>> _getPeshawarPlaces(int duration) {
    const List<String> places = [
      'Peshawar Museum', 'Bala Hisar Fort', 'Qissa Khwani Bazaar', 'Sethi Mohallah', 'Islamia College University',
      'University of Peshawar', 'Peshawar Zoo', 'Gor Khatri', 'Mahabat Khan Mosque', 'Cunningham Clock Tower',
      'Peshawar Press Club', 'Peshawar Club', 'Army Stadium', 'Peshawar Sports Complex', 'Hayatabad Sports Complex',
      'Peshawar Golf Club', 'Peshawar Railway Station', 'Peshawar Airport', 'Khyber Teaching Hospital', 'Lady Reading Hospital',
      'Peshawar High Court', 'Khyber Pakhtunkhwa Assembly', 'Governor House', 'Chief Minister House', 'Peshawar Cantonment',
      'Peshawar Board', 'Peshawar University of Engineering', 'Peshawar Agriculture University', 'Peshawar Medical College', 'Peshawar Dental College',
      'Peshawar Law College', 'Peshawar Commerce College', 'Peshawar Science College', 'Peshawar Arts Council', 'Peshawar Music Academy',
      'Peshawar Heritage Museum', 'Peshawar War Museum', 'Peshawar Children Museum', 'Peshawar Food Street', 'Peshawar Water Park',
      'Peshawar Safari Park', 'Peshawar Public Park', 'Peshawar Botanical Garden'
    ];
    return _distributePlaces(places, duration);
  }

  // Quetta (43 places)
  static Map<int, List<String>> _getQuettaPlaces(int duration) {
    const List<String> places = [
      'Hanna Lake', 'Quetta Geological Museum', 'Hazarganji Chiltan National Park', 'Pishin Valley', 'Ziarat Residency',
      'Quetta Fort', 'Askari Park', 'Quetta Railway Station', 'Quetta Airport', 'Command and Staff College',
      'University of Balochistan', 'Balochistan University of IT', 'Quetta Medical College', 'Quetta Dental College', 'Quetta Law College',
      'Quetta Commerce College', 'Quetta Science College', 'Quetta Agriculture College', 'Quetta Engineering University', 'Quetta Arts Council',
      'Quetta Press Club', 'Quetta Club', 'Quetta Golf Club', 'Quetta Sports Complex', 'Quetta Hockey Stadium',
      'Quetta Cricket Stadium', 'Quetta Football Stadium', 'Quetta Squash Complex', 'Quetta Swimming Pool', 'Quetta Gymkhana',
      'Quetta Serena Hotel', 'Quetta Pearl Continental', 'Quetta Marriott', 'Quetta Hilton', 'Quetta Food Street',
      'Quetta Water Park', 'Quetta Safari Park', 'Quetta Public Park', 'Quetta Botanical Garden', 'Quetta Zoo',
      'Quetta Children Park', 'Quetta Heritage Museum', 'Quetta War Museum'
    ];
    return _distributePlaces(places, duration);
  }

  // Islamabad (43 places)
  static Map<int, List<String>> _getIslamabadPlaces(int duration) {
    const List<String> places = [
      'Faisal Mosque', 'Pakistan Monument', 'Daman-e-Koh', 'Margalla Hills', 'Lok Virsa Museum',
      'Rawal Lake', 'Shakarparian Park', 'Centaurus Mall', 'Safa Gold Mall', 'Giga Mall',
      'Islamabad Zoo', 'Lake View Park', 'Fatima Jinnah Park', 'Rose and Jasmine Garden', 'Japanese Garden',
      'Islamabad Club', 'Islamabad Golf Club', 'Pakistan Sports Complex', 'Jinnah Sports Stadium', 'Liaquat Gymnasium',
      'Serena Hotel', 'Marriott Hotel', 'Pearl Continental', 'Islamabad Airport', 'Islamabad Railway Station',
      'Supreme Court', 'Parliament House', 'Prime Minister House', 'President House', 'Foreign Office',
      'Quaid-e-Azam University', 'COMSATS University', 'Air University', 'Bahria University', 'NUST',
      'Fatima Jinnah Women University', 'International Islamic University', 'Islamabad Medical College', 'Islamabad Dental College', 'Islamabad Law College',
      'Islamabad Commerce College', 'Islamabad Science College', 'Islamabad Arts Council'
    ];
    return _distributePlaces(places, duration);
  }

  // Naran (43 places)
  static Map<int, List<String>> _getNaranPlaces(int duration) {
    const List<String> places = [
      'Saif-ul-Malook Lake', 'Lulusar Lake', 'Dudipatsar Lake', 'Babusar Pass', 'Naran Bazaar',
      'Kaghan Valley', 'Shogran', 'Siri Paye', 'Ansoo Lake', 'Jalkad',
      'Batakundi', 'Lalazar', 'Noori Top', 'Malika Parbat', 'Makra Peak',
      'Musa ka Musalla', 'Sharan Forest', 'Kunhar River', 'Boat Rides', 'Fishing Spots',
      'Hiking Trails', 'Camping Sites', 'Naran Waterfall', 'Jhari Waterfall', 'Lulusar Waterfall',
      'Naran Restaurants', 'Naran Hotels', 'Naran Resorts', 'Naran Guest Houses', 'Naran Shopping',
      'Naran ATV Rides', 'Naran Horse Riding', 'Naran Jeep Safari', 'Naran Photography Spots', 'Naran Wildlife',
      'Naran Heritage', 'Naran Cultural Center', 'Naran Museum', 'Naran Adventure Club', 'Naran Ski Resort',
      'Naran Winter Sports', 'Naran Summer Festival', 'Naran Local Crafts'
    ];
    return _distributePlaces(places, duration);
  }

  // Swat (43 places)
  static Map<int, List<String>> _getSwatPlaces(int duration) {
    const List<String> places = [
      'Malam Jabba', 'Mingora', 'Saidu Sharif', 'White Palace', 'Swat Museum',
      'Mahodand Lake', 'Kalam Valley', 'Ushu Forest', 'Gabral Valley', 'Utror Valley',
      'Madyan', 'Bahrain', 'Fizagat Park', 'Swat River', 'Swat Waterfall',
      'Swat Valley Viewpoints', 'Swat Cable Car', 'Swat Ski Resort', 'Swat Golf Course', 'Swat Wildlife',
      'Swat Heritage Sites', 'Swat Buddhist Stupas', 'Swat Archaeological Sites', 'Swat Local Bazaars', 'Swat Handicrafts',
      'Swat Hotels', 'Swat Resorts', 'Swat Restaurants', 'Swat Guest Houses', 'Swat Camping Sites',
      'Swat Hiking Trails', 'Swat Trekking Routes', 'Swat Fishing Spots', 'Swat Boating', 'Swat Photography Spots',
      'Swat Cultural Center', 'Swat Museum of History', 'Swat Adventure Club', 'Swat ATV Rides', 'Swat Horse Riding',
      'Swat Jeep Safari', 'Swat Local Cuisine', 'Swat Summer Festival'
    ];
    return _distributePlaces(places, duration);
  }

  // Hunza (43 places)
  static Map<int, List<String>> _getHunzaPlaces(int duration) {
    const List<String> places = [
      'Baltit Fort', 'Altit Fort', 'Attabad Lake', 'Passu Cones', 'Hussaini Suspension Bridge',
      'Khunjerab Pass', 'Rakaposhi View Point', 'Eagle Nest', 'Duikar Village', 'Ganish Village',
      'Hunza Valley Viewpoints', 'Hunza Waterfall', 'Hunza Polo Ground', 'Hunza Local Bazaars', 'Hunza Handicrafts',
      'Hunza Apricot Gardens', 'Hunza Cherry Blossoms', 'Hunza Autumn Colors', 'Hunza Spring Festival', 'Hunza Cultural Show',
      'Hunza Traditional Food', 'Hunza Hotels', 'Hunza Guest Houses', 'Hunza Camping Sites', 'Hunza Hiking Trails',
      'Hunza Trekking Routes', 'Hunza Mountaineering', 'Hunza Photography Spots', 'Hunza Stargazing', 'Hunza Wildlife',
      'Hunza Heritage Museum', 'Hunza Cultural Center', 'Hunza Music Academy', 'Hunza Dance Performances', 'Hunza Local Crafts',
      'Hunza Adventure Club', 'Hunza Jeep Safari', 'Hunza Horse Riding', 'Hunza ATV Rides', 'Hunza Ski Resort',
      'Hunza Winter Sports', 'Hunza Summer Festival', 'Hunza Cherry Festival'
    ];
    return _distributePlaces(places, duration);
  }

  // Rawalpindi (43 places)
  static Map<int, List<String>> _getRawalpindiPlaces(int duration) {
    const List<String> places = [
      'Ayub National Park', 'Rawalpindi Cricket Stadium', 'Army Museum', 'Rawalpindi Golf Club', 'Liaquat Bagh',
      'Rawalpindi Railway Station', 'Raja Bazaar', 'Saddar Bazaar', 'Commercial Market', 'Jinnah Park',
      'Rawalpindi Arts Council', 'Rawalpindi Public Library', 'Rawalpindi Museum', 'Rawalpindi Heritage Sites', 'Rawalpindi Clock Tower',
      'Rawalpindi Food Street', 'Rawalpindi Restaurants', 'Rawalpindi Hotels', 'Rawalpindi Guest Houses', 'Rawalpindi Shopping Malls',
      'Rawalpindi Cinemas', 'Rawalpindi Theaters', 'Rawalpindi Sports Complex', 'Rawalpindi Hockey Stadium', 'Rawalpindi Football Stadium',
      'Rawalpindi Squash Complex', 'Rawalpindi Swimming Pool', 'Rawalpindi Gymkhana', 'Rawalpindi Club', 'Rawalpindi Press Club',
      'Rawalpindi University', 'Rawalpindi Medical College', 'Rawalpindi Dental College', 'Rawalpindi Law College', 'Rawalpindi Commerce College',
      'Rawalpindi Science College', 'Rawalpindi Engineering University', 'Rawalpindi Technical College', 'Rawalpindi Agriculture College', 'Rawalpindi Arts College',
      'Rawalpindi Heritage Museum', 'Rawalpindi War Museum', 'Rawalpindi Children Park'
    ];
    return _distributePlaces(places, duration);
  }

  // Hyderabad (43 places)
  static Map<int, List<String>> _getHyderabadPlaces(int duration) {
    const List<String> places = [
      'Rani Bagh', 'Hyderabad Fort', 'Pacco Qillo', 'Sindh Museum', 'Hyderabad Zoo',
      'Resham Gali Bazaar', 'Shahi Bazaar', 'Hyderabad Clock Tower', 'Hyderabad Railway Station', 'Hyderabad Airport',
      'Hyderabad University', 'Hyderabad Medical College', 'Hyderabad Dental College', 'Hyderabad Law College', 'Hyderabad Commerce College',
      'Hyderabad Science College', 'Hyderabad Engineering University', 'Hyderabad Technical College', 'Hyderabad Agriculture College', 'Hyderabad Arts College',
      'Hyderabad Arts Council', 'Hyderabad Press Club', 'Hyderabad Club', 'Hyderabad Golf Club', 'Hyderabad Sports Complex',
      'Hyderabad Cricket Stadium', 'Hyderabad Hockey Stadium', 'Hyderabad Football Stadium', 'Hyderabad Squash Complex', 'Hyderabad Swimming Pool',
      'Hyderabad Gymkhana', 'Hyderabad Serena Hotel', 'Hyderabad Marriott', 'Hyderabad Pearl Continental', 'Hyderabad Food Street',
      'Hyderabad Water Park', 'Hyderabad Safari Park', 'Hyderabad Public Park', 'Hyderabad Botanical Garden', 'Hyderabad Children Park',
      'Hyderabad Heritage Museum', 'Hyderabad War Museum', 'Hyderabad Cultural Center'
    ];
    return _distributePlaces(places, duration);
  }

  // Murree (43 places)
  static Map<int, List<String>> _getMurreePlaces(int duration) {
    const List<String> places = [
      'Mall Road', 'Pindi Point', 'Kashmir Point', 'Patriata Chairlift', 'Ayubia National Park',
      'Murree Hills', 'Murree Brewery', 'Murree Wildlife Park', 'Murree Church', 'Murree Viewpoints',
      'Murree Hotels', 'Murree Resorts', 'Murree Restaurants', 'Murree Guest Houses', 'Murree Shopping',
      'Murree Handicrafts', 'Murree Local Cuisine', 'Murree Hiking Trails', 'Murree Trekking Routes', 'Murree Photography Spots',
      'Murree Stargazing', 'Murree Wildlife', 'Murree Heritage Sites', 'Murree Museum', 'Murree Cultural Center',
      'Murree Music Academy', 'Murree Dance Performances', 'Murree Local Crafts', 'Murree Adventure Club', 'Murree Jeep Safari',
      'Murree Horse Riding', 'Murree ATV Rides', 'Murree Ski Resort', 'Murree Winter Sports', 'Murree Summer Festival',
      'Murree Spring Blossoms', 'Murree Autumn Colors', 'Murree Christmas Celebrations', 'Murree New Year Events', 'Murree Food Festival',
      'Murree Art Exhibition', 'Murree Craft Bazaar', 'Murree Heritage Walk'
    ];
    return _distributePlaces(places, duration);
  }

  // Gawadar (43 places)
  static Map<int, List<String>> _getGawadarPlaces(int duration) {
    const List<String> places = [
      'Gawadar Port', 'Gawadar Beach', 'Ormara Beach', 'Jiwani Beach', 'Pishukan Beach',
      'Kund Malir Beach', 'Princess of Hope', 'Buzi Pass', 'Hingol National Park', 'Gawadar Viewpoints',
      'Gawadar Hotels', 'Gawadar Resorts', 'Gawadar Restaurants', 'Gawadar Guest Houses', 'Gawadar Shopping',
      'Gawadar Handicrafts', 'Gawadar Local Cuisine', 'Gawadar Fishing Spots', 'Gawadar Boating', 'Gawadar Diving',
      'Gawadar Water Sports', 'Gawadar Photography Spots', 'Gawadar Wildlife', 'Gawadar Heritage Sites', 'Gawadar Museum',
      'Gawadar Cultural Center', 'Gawadar Music Academy', 'Gawadar Dance Performances', 'Gawadar Local Crafts', 'Gawadar Adventure Club',
      'Gawadar Jeep Safari', 'Gawadar Camel Riding', 'Gawadar ATV Rides', 'Gawadar Yacht Club', 'Gawadar Marina',
      'Gawadar Golf Course', 'Gawadar Sports Complex', 'Gawadar Cricket Stadium', 'Gawadar Football Stadium', 'Gawadar Squash Complex',
      'Gawadar Swimming Pool', 'Gawadar Gymkhana', 'Gawadar Club'
    ];
    return _distributePlaces(places, duration);
  }

  // Sialkot (43 places)
  static Map<int, List<String>> _getSialkotPlaces(int duration) {
    const List<String> places = [
      'Sialkot Fort', 'Iqbal Manzil', 'Sialkot Cricket Stadium', 'Jinnah Stadium', 'Sialkot Golf Club',
      'Sialkot Airport', 'Sialkot Railway Station', 'Sialkot Bus Terminal', 'Sialkot Clock Tower', 'Sialkot Food Street',
      'Sialkot Hotels', 'Sialkot Restaurants', 'Sialkot Guest Houses', 'Sialkot Shopping Malls', 'Sialkot Bazaars',
      'Sialkot Sports Goods Market', 'Sialkot Leather Market', 'Sialkot Surgical Instruments Market', 'Sialkot Gloves Market', 'Sialkot Musical Instruments Market',
      'Sialkot University', 'Sialkot Medical College', 'Sialkot Dental College', 'Sialkot Law College', 'Sialkot Commerce College',
      'Sialkot Science College', 'Sialkot Engineering University', 'Sialkot Technical College', 'Sialkot Agriculture College', 'Sialkot Arts College',
      'Sialkot Arts Council', 'Sialkot Press Club', 'Sialkot Club', 'Sialkot Gymkhana', 'Sialkot Swimming Pool',
      'Sialkot Squash Complex', 'Sialkot Hockey Stadium', 'Sialkot Football Stadium', 'Sialkot Basketball Court', 'Sialkot Tennis Courts',
      'Sialkot Heritage Museum', 'Sialkot War Museum', 'Sialkot Children Park'
    ];
    return _distributePlaces(places, duration);
  }

  // Skardu (43 places)
  static Map<int, List<String>> _getSkarduPlaces(int duration) {
    const List<String> places = [
      'Shangrila Resort', 'Upper Kachura Lake', 'Lower Kachura Lake', 'Skardu Fort', 'Kharpocho Fort',
      'Satpara Lake', 'Deosai Plains', 'Shigar Fort', 'Manthoka Waterfall', 'Basho Valley',
      'Skardu Bazaar', 'Skardu Viewpoints', 'Skardu Hotels', 'Skardu Resorts', 'Skardu Restaurants',
      'Skardu Guest Houses', 'Skardu Camping Sites', 'Skardu Hiking Trails', 'Skardu Trekking Routes', 'Skardu Mountaineering',
      'Skardu Photography Spots', 'Skardu Stargazing', 'Skardu Wildlife', 'Skardu Heritage Sites', 'Skardu Museum',
      'Skardu Cultural Center', 'Skardu Music Academy', 'Skardu Dance Performances', 'Skardu Local Crafts', 'Skardu Adventure Club',
      'Skardu Jeep Safari', 'Skardu Horse Riding', 'Skardu ATV Rides', 'Skardu Ski Resort', 'Skardu Winter Sports',
      'Skardu Summer Festival', 'Skardu Spring Blossoms', 'Skardu Autumn Colors', 'Skardu Local Cuisine', 'Skardu Handicrafts',
      'Skardu Polo Ground', 'Skardu Golf Course', 'Skardu Sports Complex'
    ];
    return _distributePlaces(places, duration);
  }

  // Faisalabad (43 places)
  static Map<int, List<String>> _getFaisalabadPlaces(int duration) {
    const List<String> places = [
      'Clock Tower', 'Gumti Fountain', 'Lyallpur Museum', 'Jinnah Garden', 'D-Ground',
      'Faisalabad Railway Station', 'Faisalabad Airport', 'Faisalabad Bus Terminal', 'Faisalabad Food Street', 'Faisalabad Clock Tower',
      'Faisalabad Hotels', 'Faisalabad Restaurants', 'Faisalabad Guest Houses', 'Faisalabad Shopping Malls', 'Faisalabad Bazaars',
      'Faisalabad Textile Market', 'Faisalabad Cloth Market', 'Faisalabad Grain Market', 'Faisalabad Fruit Market', 'Faisalabad Vegetable Market',
      'Faisalabad University', 'Faisalabad Medical College', 'Faisalabad Dental College', 'Faisalabad Law College', 'Faisalabad Commerce College',
      'Faisalabad Science College', 'Faisalabad Engineering University', 'Faisalabad Technical College', 'Faisalabad Agriculture College', 'Faisalabad Arts College',
      'Faisalabad Arts Council', 'Faisalabad Press Club', 'Faisalabad Club', 'Faisalabad Gymkhana', 'Faisalabad Swimming Pool',
      'Faisalabad Squash Complex', 'Faisalabad Hockey Stadium', 'Faisalabad Football Stadium', 'Faisalabad Basketball Court', 'Faisalabad Tennis Courts',
      'Faisalabad Heritage Museum', 'Faisalabad War Museum', 'Faisalabad Children Park'
    ];
    return _distributePlaces(places, duration);
  }

  // Muzafarabad (43 places)
  static Map<int, List<String>> _getMuzafarabadPlaces(int duration) {
    const List<String> places = [
      'Red Fort', 'Pir Chinasi', 'Subri Lake', 'Muzafarabad Viewpoints', 'Neelum Valley',
      'Jhelum Valley', 'Leepa Valley', 'Muzafarabad Bazaar', 'Muzafarabad Handicrafts', 'Muzafarabad Local Cuisine',
      'Muzafarabad Hotels', 'Muzafarabad Guest Houses', 'Muzafarabad Restaurants', 'Muzafarabad Camping Sites', 'Muzafarabad Hiking Trails',
      'Muzafarabad Trekking Routes', 'Muzafarabad Photography Spots', 'Muzafarabad Wildlife', 'Muzafarabad Heritage Sites', 'Muzafarabad Museum',
      'Muzafarabad Cultural Center', 'Muzafarabad Music Academy', 'Muzafarabad Dance Performances', 'Muzafarabad Local Crafts', 'Muzafarabad Adventure Club',
      'Muzafarabad Jeep Safari', 'Muzafarabad Horse Riding', 'Muzafarabad ATV Rides', 'Muzafarabad Ski Resort', 'Muzafarabad Winter Sports',
      'Muzafarabad Summer Festival', 'Muzafarabad Spring Blossoms', 'Muzafarabad Autumn Colors', 'Muzafarabad River Rafting', 'Muzafarabad Fishing Spots',
      'Muzafarabad Boating', 'Muzafarabad Water Sports', 'Muzafarabad Polo Ground', 'Muzafarabad Golf Course', 'Muzafarabad Sports Complex',
      'Muzafarabad Cricket Stadium', 'Muzafarabad Football Stadium', 'Muzafarabad Squash Complex'
    ];
    return _distributePlaces(places, duration);
  }
}