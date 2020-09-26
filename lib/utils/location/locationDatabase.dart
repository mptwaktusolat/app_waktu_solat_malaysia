import 'package:waktusolatmalaysia/utils/location/location.dart';

class LocationDatabase {
  List<Location> _locationDatabase = [
    //JOHOR
    Location(
        jakimCode: 'JHR01',
        negeri: 'Johor',
        daerah: 'Pulau Air dan Pulau Pemanggil'),
    Location(
        jakimCode: 'JHR02',
        negeri: 'Johor',
        daerah: 'Kota Tinggi, Mersing, Johor Bahru'),
    Location(jakimCode: 'JHR03', negeri: 'Johor', daerah: 'Kluang, Pontian'),
    Location(
        jakimCode: 'JHR04',
        negeri: 'Johor',
        daerah: 'Batu Pahat, Muar, Segamat, Gemas'),

    //KEDAH
    Location(
        jakimCode: 'KDH01',
        negeri: 'Kedah',
        daerah: 'Kota Setar, Kubang Pasu, Pokok Sena (Daerah Kecil)'),
    Location(
        jakimCode: 'KDH02',
        negeri: 'Kedah',
        daerah: 'Pendang, Kuala Muda, Yan'),
    Location(jakimCode: 'KDH03', negeri: 'Kedah', daerah: 'Padang Terap, Sik'),
    Location(jakimCode: 'KDH04', negeri: 'Kedah', daerah: 'Baling'),
    Location(
        jakimCode: 'KDH05', negeri: 'Kedah', daerah: 'Kulim, Bandar Bahru'),
    Location(jakimCode: 'KDH06', negeri: 'Kedah', daerah: 'Langkawi'),
    Location(
        jakimCode: 'KDH07', negeri: 'Kedah', daerah: 'Puncak Gunung Jerai'),

    //KELANTAN
    Location(
        jakimCode: 'KTN01',
        negeri: 'Kelantan',
        daerah:
            'Kota Bahru, Bachok, Pasir Puteh, Tumpat, Pasir Mas, Tanah Merah, Machang, Kuala Krai, Mukim Chiku'),
    Location(
        jakimCode: 'KTN03',
        negeri: 'Kelantan',
        daerah: 'Jeli, Gua Musang (Daerah Galas dan Bertam)'),

    //MELAKA
    Location(
        jakimCode: 'MLK01', negeri: 'Melaka', daerah: 'SELURUH NEGERI MELAKA'),

    //NEGERI SEMNBILAN
    Location(
        jakimCode: 'NGS01',
        negeri: 'Negeri Sembilan',
        daerah: 'Jempol, Tampin'),
    Location(
        jakimCode: 'NGS02',
        negeri: 'Negeri Sembilan',
        daerah: 'Port Dickson, Seremban, Kuala Pilah, Jelebu, Rembau'),

    //PAHANG
    Location(jakimCode: 'PHG01', negeri: 'Pahang', daerah: 'Pulau Tioman'),
    Location(
        jakimCode: 'PHG02',
        negeri: 'Pahang',
        daerah: 'Kuantan, Pekan, Rompin, Muadzam Shah'),
    Location(
        jakimCode: 'PHG03',
        negeri: 'Pahang',
        daerah: 'Maran, Chenor, Temerloh, Bera, Jerantut, Jengka'),
    Location(
        jakimCode: 'PHG04',
        negeri: 'Pahang',
        daerah: 'Bentong, Raub, Kuala Lipis'),
    Location(
        jakimCode: 'PHG05',
        negeri: 'Pahang',
        daerah: 'Genting Sempah, Janda Baik, Bukit Tinggi'),
    Location(
        jakimCode: 'PHG06',
        negeri: 'Pahang',
        daerah: 'Bukit Fraser, Genting Highlands, Cameron Highlands'),

    //PERAK
    Location(
        jakimCode: 'PRK01',
        negeri: 'Perak',
        daerah: 'Tapah, Slim River, Tanjung Malim'),
    Location(
        jakimCode: 'PRK02',
        negeri: 'Perak',
        daerah:
            'Ipoh, Batu Gajah, Kampar, Sungai Siput (Daerah Kecil), Kuala Kangsar'),
    Location(
        jakimCode: 'PRK03',
        negeri: 'Perak',
        daerah: 'Pengkalan Hulu, Grik, Lenggong'),
    Location(jakimCode: 'PRK04', negeri: 'Perak', daerah: 'Temengor, Belum'),
    Location(
        jakimCode: 'PRK05',
        negeri: 'Perak',
        daerah:
            'Teluk Intan, Bagan Datuk, Kg Gajah, Seri Iskandar, Beruas, Parit, Lumut, Sitiawan, Pulau Pangkor'),
    Location(
        jakimCode: 'PRK06',
        negeri: 'Perak',
        daerah: 'Selama, Taiping, Bagan Serai, Parit Buntar'),
    Location(jakimCode: 'PRK07', negeri: 'Perak', daerah: 'Bukit Larut'),

    //PERLIS
    Location(
        jakimCode: 'PLS01',
        negeri: 'Perlis',
        daerah: 'Kangar, Padang Besar, Arau'),

    //PULAU PINANG
    Location(
        jakimCode: 'PNG01',
        negeri: 'Pulau Pinang',
        daerah: 'SELURUH NEGERI PULAU PINANG'),

    //SABAH
    Location(
        jakimCode: "SBH01",
        negeri: "Sabah",
        daerah:
            "Sandakan Timur, Bdr Sandakan, Bukit Garam, Semawang, Temanggong, Tambisan, Sukau"),
    Location(
        jakimCode: "SBH02",
        negeri: "Sabah",
        daerah: "Pinangah, Terusan, Beluran, Kuamut, Telupid, Sandakan Barat"),
    Location(
        jakimCode: "SBH03",
        negeri: "Sabah",
        daerah:
            "Lahad Datu, Kunak, Silabukan, Tungku, Sahabat, Semporna, Tawau Timur"),
    Location(
        jakimCode: "SBH04",
        negeri: "Sabah",
        daerah: "Bandar Tawau, Balong, Merotai, Kalabakan, Tawau Barat"),
    Location(
        jakimCode: "SBH05",
        negeri: "Sabah",
        daerah: "Kudat, Kota Marudu, Pitas, Pulau Banggi"),
    Location(jakimCode: "SBH06", negeri: "Sabah", daerah: "Gunung Kinabalu"),
    Location(
        jakimCode: "SBH07",
        negeri: "Sabah",
        daerah:
            "Papar, Ranau, Kota Belud, Tuaran, Penampang, Kota Kinabalu, Putatan, Pantai Barat"),
    Location(
        jakimCode: "SBH08",
        negeri: "Sabah",
        daerah:
            "Pensiangan, Keningau, Tambunan, Nabawan, Bahagian Pendalaman (Atas)"),
    Location(
        jakimCode: "SBH09",
        negeri: "Sabah",
        daerah:
            "Sipitang, Membakut, Beaufort, Kuala Penyu, Weston, Tenom, Long Pa Sia, Pendalaman (Bawah)"),

    //SARAWAK
    Location(
        jakimCode: 'SWK01',
        negeri: 'Sarawak',
        daerah: 'Limbang, Sundar, Terusan, Lawas'),
    Location(
        jakimCode: 'SWK02',
        negeri: 'Sarawak',
        daerah: 'Niah, Belaga, Sibuti, Miri, Bekenu, Marudi'),
    Location(
        jakimCode: 'SWK03',
        negeri: 'Sarawak',
        daerah: 'Song, Balingian, Sebauh, Bintulu, Tatau, Kapit'),
    Location(
        jakimCode: 'SWK04',
        negeri: 'Sarawak',
        daerah: 'Igan, Kanowit, Sibu, Dalat, Oya'),
    Location(
        jakimCode: 'SWK05',
        negeri: 'Sarawak',
        daerah: 'Belawai, Matu, Daro, Sarikei, Julau, Bitangor, Rajang'),
    Location(
        jakimCode: 'SWK06',
        negeri: 'Sarawak',
        daerah:
            'Kabong, Lingga, Sri Aman, Engkelili, Betong, Spaoh, Pusa, Saratok, Roban,Debak'),
    Location(
        jakimCode: 'SWK07',
        negeri: 'Sarawak',
        daerah: 'Samarahan, Simunjan, Serian, Sebuyau, Meludam'),
    Location(
        jakimCode: 'SWK08',
        negeri: 'Sarawak',
        daerah: 'Kuching, Bau, Lundu, Sematan'),
    Location(jakimCode: 'SWK09', negeri: 'Sarawak', daerah: 'Zon Khas'),
    //SELANGOR
    Location(
        jakimCode: 'SGR01',
        negeri: 'Selangor',
        daerah:
            'Gombak, Hulu Selangor, Rawang, Hulu Langat, Sepang, Petaling, Shah Alam'),
    Location(
        jakimCode: 'SGR02',
        negeri: 'Selangor',
        daerah: 'Sabak Bernam, Kuala Selangor'),
    Location(
        jakimCode: 'SGR03', negeri: 'Selangor', daerah: 'Klang, Kuala Langat'),
    //TERENGGANU
    Location(
        jakimCode: 'TRG01',
        negeri: 'Terengganu',
        daerah: 'Kuala Terengganu, Marang, Kuala Nerus'),
    Location(jakimCode: 'TRG02', negeri: 'Terengganu', daerah: 'Besut, Setiu'),
    Location(
        jakimCode: 'TRG03', negeri: 'Terengganu', daerah: 'Hulu Terengganu'),
    Location(
        jakimCode: 'TRG04', negeri: 'Terengganu', daerah: 'Kemaman, Dungun'),
    //WILAYAH PERSEKUTUAN
    Location(
        jakimCode: 'WLY01',
        negeri: 'Wilayah Persekutuan',
        daerah: 'Kuala Lumpur, Putrajaya '),
    Location(
        jakimCode: 'WLY02', negeri: 'Wilayah Persekutuan', daerah: 'Labuan')
  ];

  int indexOfLocation(String jakimCode) {
    var jakimCaps = jakimCode.toUpperCase();
    var index = _locationDatabase
        .indexWhere((element) => element.jakimCode == jakimCaps);
    print('index of $jakimCaps is at $index');
    return index;
  }

  int getLocationDatabaseLength() => _locationDatabase.length;

  String getJakimCode(int index) => _locationDatabase[index].jakimCode;

  String getNegeri(int index) => _locationDatabase[index].negeri;

  String getDaerah(int index) => _locationDatabase[index].daerah;
}
