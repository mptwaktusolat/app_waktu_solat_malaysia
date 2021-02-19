///Latest is coming from https://mpt.i906.my/code.html
///All location data get from https://api.azanpro.com/reference/zone/grouped based on JAKIM website
///Previosly, location data is fetch from JSON https://gist.github.com/fareezMaple/02648187370acb6db11e20ee143e471e also come from same API.
import 'package:waktusolatmalaysia/utils/location/location.dart';

class LocationDatabase {
  List<Location> _locationDatabase = [
    //JOHOR
    Location(
      jakimCode: 'JHR01',
      negeri: 'Johor',
      daerah: 'Pulau Air dan Pulau Pemanggil',
      mptLocationCode: 'jhr-7',
    ),
    Location(
      jakimCode: 'JHR02',
      negeri: 'Johor',
      daerah: 'Kota Tinggi, Mersing, Johor Bahru',
      mptLocationCode: 'jhr-2',
    ),
    Location(
      jakimCode: 'JHR03',
      negeri: 'Johor',
      daerah: 'Kluang, Pontian',
      mptLocationCode: 'jhr-3',
    ),
    Location(
      jakimCode: 'JHR04',
      negeri: 'Johor',
      daerah: 'Batu Pahat, Muar, Segamat, Gemas',
      mptLocationCode: 'jhr-0',
    ),

    //KEDAH
    Location(
      jakimCode: 'KDH01',
      negeri: 'Kedah',
      daerah: 'Kota Setar, Kubang Pasu, Pokok Sena (Daerah Kecil)',
      mptLocationCode: 'kdh-2',
    ),
    Location(
        jakimCode: 'KDH02',
        negeri: 'Kedah',
        daerah: 'Pendang, Kuala Muda, Yan',
        mptLocationCode: 'kdh-8'),
    Location(
      jakimCode: 'KDH03',
      negeri: 'Kedah',
      daerah: 'Padang Terap, Sik',
      mptLocationCode: 'kdh-11',
    ),
    Location(
      jakimCode: 'KDH04',
      negeri: 'Kedah',
      daerah: 'Baling',
      mptLocationCode: 'kdh-0',
    ),
    Location(
        jakimCode: 'KDH05',
        negeri: 'Kedah',
        daerah: 'Kulim, Bandar Bahru',
        mptLocationCode: 'kdh-1'),
    Location(
        jakimCode: 'KDH06',
        negeri: 'Kedah',
        daerah: 'Langkawi',
        mptLocationCode: 'kdh-6'),
    Location(
      jakimCode: 'KDH07',
      negeri: 'Kedah',
      daerah: 'Puncak Gunung Jerai',
      mptLocationCode: 'kdh-10',
    ),

    //KELANTAN
    Location(
      jakimCode: 'KTN01',
      negeri: 'Kelantan',
      daerah:
          'Kota Bahru, Bachok, Pasir Puteh, Tumpat, Pasir Mas, Tanah Merah, Machang, Kuala Krai, Mukim Chiku',
      mptLocationCode: 'ktn-5',
    ),
    Location(
      jakimCode: 'KTN03',
      negeri: 'Kelantan',
      daerah: 'Jeli, Gua Musang (Daerah Galas dan Bertam)',
      mptLocationCode: 'ktn-2',
    ),

    //MELAKA
    Location(
      jakimCode: 'MLK01',
      negeri: 'Melaka',
      daerah: 'SELURUH NEGERI MELAKA',
      mptLocationCode: 'mlk-0',
    ),

    //NEGERI SEMNBILAN
    Location(
      jakimCode: 'NGS01',
      negeri: 'Negeri Sembilan',
      daerah: 'Jempol, Tampin',
      mptLocationCode: 'ngs-1',
    ),
    Location(
      jakimCode: 'NGS02',
      negeri: 'Negeri Sembilan',
      daerah: 'Port Dickson, Seremban, Kuala Pilah, Jelebu, Rembau',
      mptLocationCode: 'ngs-4',
    ),

    //PAHANG
    Location(
      jakimCode: 'PHG01',
      negeri: 'Pahang',
      daerah: 'Pulau Tioman',
      mptLocationCode: 'phg-12',
    ),
    Location(
      jakimCode: 'PHG02',
      negeri: 'Pahang',
      daerah: 'Kuantan, Pekan, Rompin, Muadzam Shah',
      mptLocationCode: 'phg-10',
    ),
    Location(
      jakimCode: 'PHG03',
      negeri: 'Pahang',
      daerah: 'Maran, Chenor, Temerloh, Bera, Jerantut, Jengka',
      mptLocationCode: 'phg-9',
    ),
    Location(
      jakimCode: 'PHG04',
      negeri: 'Pahang',
      daerah: 'Bentong, Raub, Kuala Lipis',
      mptLocationCode: 'phg-7',
    ),
    Location(
        jakimCode: 'PHG05',
        negeri: 'Pahang',
        daerah: 'Genting Sempah, Janda Baik, Bukit Tinggi',
        mptLocationCode: 'phg-16'),
    Location(
        jakimCode: 'PHG06',
        negeri: 'Pahang',
        daerah: 'Bukit Fraser, Genting Highlands, Cameron Highlands',
        mptLocationCode: 'phg-2'),

    //PERAK
    Location(
      jakimCode: 'PRK01',
      negeri: 'Perak',
      daerah: 'Tapah, Slim River, Tanjung Malim',
      mptLocationCode: 'prk-24',
    ),
    Location(
      jakimCode: 'PRK02',
      negeri: 'Perak',
      daerah:
          'Ipoh, Batu Gajah, Kampar, Sungai Siput (Daerah Kecil), Kuala Kangsar',
      mptLocationCode: 'prk-7',
    ),
    Location(
      jakimCode: 'PRK03',
      negeri: 'Perak',
      daerah: 'Pengkalan Hulu, Grik, Lenggong',
      mptLocationCode: 'prk-11',
    ),
    Location(
      jakimCode: 'PRK04',
      negeri: 'Perak',
      daerah: 'Temengor, Belum',
      mptLocationCode: 'prk-3',
    ),
    Location(
      jakimCode: 'PRK05',
      negeri: 'Perak',
      daerah:
          'Teluk Intan, Bagan Datuk, Kg Gajah, Seri Iskandar, Beruas, Parit, Lumut, Sitiawan, Pulau Pangkor',
      mptLocationCode: 'prk-13',
    ),
    Location(
      jakimCode: 'PRK06',
      negeri: 'Perak',
      daerah: 'Selama, Taiping, Bagan Serai, Parit Buntar',
      mptLocationCode: 'prk-14',
    ),
    Location(
      jakimCode: 'PRK07',
      negeri: 'Perak',
      daerah: 'Bukit Larut',
      mptLocationCode: 'prk-5',
    ),

    //PERLIS
    Location(
      jakimCode: 'PLS01',
      negeri: 'Perlis',
      daerah: 'Kangar, Padang Besar, Arau',
      mptLocationCode: 'pls-0',
    ),

    //PULAU PINANG
    Location(
        jakimCode: 'PNG01',
        negeri: 'Pulau Pinang',
        daerah: 'SELURUH NEGERI PULAU PINANG',
        mptLocationCode: 'png-0'),

    //SABAH
    Location(
      jakimCode: "SBH01",
      negeri: "Sabah",
      daerah:
          "Sandakan Timur, Bdr Sandakan, Bukit Garam, Semawang, Temanggong, Tambisan, Sukau",
      mptLocationCode: 'sbh-28',
    ),
    Location(
      jakimCode: "SBH02",
      negeri: "Sabah",
      daerah: "Pinangah, Terusan, Beluran, Kuamut, Telupid, Sandakan Barat",
      mptLocationCode: 'sbh-38',
    ),
    Location(
      jakimCode: "SBH03",
      negeri: "Sabah",
      daerah:
          "Lahad Datu, Kunak, Silabukan, Tungku, Sahabat, Semporna, Tawau Timur",
      mptLocationCode: 'sbh-40',
    ),
    Location(
      jakimCode: "SBH04",
      negeri: "Sabah",
      daerah: "Bandar Tawau, Balong, Merotai, Kalabakan, Tawau Barat",
      mptLocationCode: 'sbh-5',
    ),
    Location(
      jakimCode: "SBH05",
      negeri: "Sabah",
      daerah: "Kudat, Kota Marudu, Pitas, Pulau Banggi",
      mptLocationCode: 'sbh-12',
    ),
    Location(
      jakimCode: "SBH06",
      negeri: "Sabah",
      daerah: "Gunung Kinabalu",
      mptLocationCode: 'sbh-4',
    ),
    Location(
      jakimCode: "SBH07",
      negeri: "Sabah",
      daerah:
          "Papar, Ranau, Kota Belud, Tuaran, Penampang, Kota Kinabalu, Putatan, Pantai Barat",
      mptLocationCode: 'sbh-19',
    ),
    Location(
      jakimCode: "SBH08",
      negeri: "Sabah",
      daerah:
          "Pensiangan, Keningau, Tambunan, Nabawan, Bahagian Pendalaman (Atas)",
      mptLocationCode: 'sbh-33',
    ),
    Location(
      jakimCode: "SBH09",
      negeri: "Sabah",
      daerah:
          "Sipitang, Membakut, Beaufort, Kuala Penyu, Weston, Tenom, Long Pa Sia, Pendalaman (Bawah)",
      mptLocationCode: 'sbh-41',
    ),

    //SARAWAK
    Location(
      jakimCode: 'SWK01',
      negeri: 'Sarawak',
      daerah: 'Limbang, Sundar, Terusan, Lawas',
      mptLocationCode: 'swk-18',
    ),
    Location(
      jakimCode: 'SWK02',
      negeri: 'Sarawak',
      daerah: 'Niah, Belaga, Sibuti, Miri, Bekenu, Marudi',
      mptLocationCode: 'swk-2',
    ),
    Location(
      jakimCode: 'SWK03',
      negeri: 'Sarawak',
      daerah: 'Song, Balingian, Sebauh, Bintulu, Tatau, Kapit',
      mptLocationCode: 'swk-16',
    ),
    Location(
      jakimCode: 'SWK04',
      negeri: 'Sarawak',
      daerah: 'Igan, Kanowit, Sibu, Dalat, Oya',
      mptLocationCode: 'swk-15',
    ),
    Location(
      jakimCode: 'SWK05',
      negeri: 'Sarawak',
      daerah: 'Belawai, Matu, Daro, Sarikei, Julau, Bitangor, Rajang',
      mptLocationCode: 'swk-7',
    ),
    Location(
      jakimCode: 'SWK06',
      negeri: 'Sarawak',
      daerah:
          'Kabong, Lingga, Sri Aman, Engkelili, Betong, Spaoh, Pusa, Saratok, Roban,Debak',
      mptLocationCode: 'swk-10',
    ),
    Location(
      jakimCode: 'SWK07',
      negeri: 'Sarawak',
      daerah: 'Samarahan, Simunjan, Serian, Sebuyau, Meludam',
      mptLocationCode: 'swk-24',
    ),
    Location(
      jakimCode: 'SWK08',
      negeri: 'Sarawak',
      daerah: 'Kuching, Bau, Lundu, Sematan',
      mptLocationCode: 'swk-0',
    ),
    Location(
      jakimCode: 'SWK09',
      negeri: 'Sarawak',
      daerah: 'Zon Khas',
      mptLocationCode: 'sbh-31',
    ), //can't find dedicated place for zon khas?
    //SELANGOR
    Location(
      jakimCode: 'SGR01',
      negeri: 'Selangor',
      daerah:
          'Gombak, Hulu Selangor, Rawang, Hulu Langat, Sepang, Petaling, Shah Alam',
      mptLocationCode: 'sgr-2',
    ),
    Location(
      jakimCode: 'SGR02',
      negeri: 'Selangor',
      daerah: 'Sabak Bernam, Kuala Selangor',
      mptLocationCode: 'sgr-5',
    ),
    Location(
      jakimCode: 'SGR03',
      negeri: 'Selangor',
      daerah: 'Klang, Kuala Langat',
      mptLocationCode: 'sgr-3',
    ),
    //TERENGGANU
    Location(
      jakimCode: 'TRG01',
      negeri: 'Terengganu',
      daerah: 'Kuala Terengganu, Marang, Kuala Nerus',
      mptLocationCode: 'trg-4',
    ),
    Location(
      jakimCode: 'TRG02',
      negeri: 'Terengganu',
      daerah: 'Besut, Setiu',
      mptLocationCode: 'trg-0',
    ),
    Location(
      jakimCode: 'TRG03',
      negeri: 'Terengganu',
      daerah: 'Hulu Terengganu',
      mptLocationCode: 'trg-1',
    ),
    Location(
      jakimCode: 'TRG04',
      negeri: 'Terengganu',
      daerah: 'Kemaman, Dungun',
      mptLocationCode: 'trg-2',
    ),
    //WILAYAH PERSEKUTUAN
    Location(
      jakimCode: 'WLY01',
      negeri: 'Wilayah Persekutuan',
      daerah: 'Kuala Lumpur, Putrajaya ',
      mptLocationCode: 'wlp-0',
    ),
    Location(
      jakimCode: 'WLY02',
      negeri: 'Wilayah Persekutuan',
      daerah: 'Labuan',
      mptLocationCode: 'wlp-1',
    )
  ];

  int indexOfLocation(String jakimCode) {
    var jakimCaps = jakimCode.toUpperCase();
    var index = _locationDatabase
        .indexWhere((element) => element.jakimCode == jakimCaps);
    print('index of $jakimCaps is at $index');
    return index;
  }

  /// Length of all location data
  int getLocationDatabaseLength() => _locationDatabase.length;

  String getJakimCode(int index) => _locationDatabase[index].jakimCode;

  String getNegeri(int index) => _locationDatabase[index].negeri;

  String getDaerah(int index) => _locationDatabase[index].daerah;

  String getMptLocationCode(int index) =>
      _locationDatabase[index].mptLocationCode;
}
