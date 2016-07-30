# Bind-DNS-Sikilastirma-Klavuzu
# GİRİŞ
Alan Adı Hizmetiniz (DNS) sizin İnternetteki sisteminiz için yol götericinizdir. Ağınız ne kadar güçlü ve gevenli olursa olsun, posta ve diğer sunucular, risk altında olan ve yozlaşmış DNS sistemleri müşterilerin ve meşru kullanıcıların size ulaşmasını engelleye bilir.
BIND [1] en sık kullanılan DNS sunucusudur ve ISC tarafından sürdürülmektedir. Bekletici programın da isminin aynı olmasından dolayı "adlandırılan" olarakta bilinmektedir. Bir çok uygulamanın artan kötü niyetli İnternet ortamına maruz kalmasından dolayı, güvenlik zaafiyetleri  BIND tarafından keşfediliyor. Üç ana versiyon bulunmaktadır:
* 1.	v4 1998 yılına kadar bir çok UNIX sistemleri ile birlikte paketlenmiştir. Bir çok satıcılar bundan vazgeçmiştir. OpenBSD ekibi v4 ve sonrasında v9’da bazı düzeltmeler yaptı (v8 ekip tarafından fazla karmaşık olarak değerlendirildi).
* 2.	 v8 hala kullanımda olmasına rağmen eskiyor. Bu versiyonun sağlamlaştırılması bir başka makalede tartışılmıştır [13].
* 3.	 v9 tamamen yeniden yazılmıştır, ücretsiz ve aynı zamanda ticari desteklidir. Birçok yeni özellikleri mevcuttur (kullanışlı fakat güvenliği kuşkulu). v9 2000 yılı ekim ayında üretim status almıştır ve o gün itibarile düzenli olarak geliştiriliyor. 
BIND9’un yaratıcısı Nominum’daki mühendis ekibi DNS topluluğunun uzmanlarıdır. DNS ve DHCP için yazılım, donanım, eğitim,danışmanlık ve aynı zamanda DNS ev sahipliği hizmetlerini www.secondary.com üzerinden temin ediyorlar.
Bu makale  Bind 9. versiyonu güvenli kullanmayı anlatıyor.

# Neden Rahatsız Ediyor? Güvenliksiz Bir BIND Ne Gibi Riskler İçeriyor?

Gerçekten DNS  için endişe duymalı mıyız? Risk altındaki bir DNS sunucusu bazı enteresan riskler içerir:
* 1) **Eğer bölgesel geçitlere izin veriliyorsa saldırgan birçok bilgi elde edebilir:** ev sahibi ve yönlendiricilerin IP addresleri, isimleri ve bazı isim ve lokasyon içerikli yorumların tüm listesi gibi.
* 2) **Hizmet Tekzibi:** Eğer sizin İnternet DNS sunucularınız çökerse,
      * Siteniz artık görünür olamaz (diğer siteler IP adresinizi göremez).
      * E-postalarınız ulaştırılamaz (yakın zamanda bilgi alış-verişinde bulunduğunuz bazı diğer internet siteleri DNS girdilerinizi saklı tutmuş olabilir, ama bunlar da birkaç günden fazla dayanmaz).
      * Saldırgan sizin sunucunuz gibi görünen ve alanınız ile ilgili internete yanlış DNS  bilgisi yayan sahte bir DNS sunucusu yaratabilir. Bu bütünlük kaybı demektir, sonraki kesite bakınız.
      
* 3) **Bütünlük kaybı:** Eğer saldırgan DNS verilerini değişir ve ya yanlış bilgiye inanacak başka siteleri kandırırsa (bu DNS zehirlenmesi olarak bilinir), bu çok tehlikelidir:
      
      * Sahte siteler sizinmiş gibi görünür ve siteniz tarafından yönetilen kullanıcı girdilerini ele geçirebilir, bu girdiler kullanıcı PIN ve şifreleri de dahil birçok hesap bilgisi olabilir.
      * Bütün e-postalar onları sizin sitenize ulaşmadan önce değişen, kopyalayan ve silen bir röleye yönlendirilebilir.
      * Eğer güvenlik duvarınız veya herhangi bir internet ulaşımı mevcut ev sahibi kimlik doğrulamak için DNS ismini kullanıyor ya da partnerliğinize güveniyorsa, bunlar kesinlikle kötüye kullanılabilir, özellikle İnternet sunucuları ve İntranet zayıf bir filtre paketi ile korunuyorsa. Sadece *.mydomain.com’dan gelen vekil taleplerine izin vermek için ayarlanmış bir Ağ vekili hayal edin. Saldırgan kendi ev sahibini alana ekliyor ve bu zaman Ağ vekili saldırgan HTTP’ye  ondan gelen taleplere izin vererek internet ulaşımı sağlıyor. 
     SSH kullanan bir internet yöneticisi hayal edin, fakat güvenlik duvarı ev sahiplerinin "admin.mydomain.com"a inanan bir ".shosts"u var ve burada "admin" yöneticinin iş istasyonu demek. Eğer saldırgan DNS girdisini "admin.mydomain.com" ile değişebilirse bu onun güvenlik duvarı ev sahibine şifresiz ulaşımı olduğu demektir.
2001 kışı ve 2008 yazında ortaya çıkan DNS zaaflarını kullanan otomatik saldırı araçları ve solucanlarından yola çıkarak DNS’in internet hacker’larının favori hedefi olduğu kanaatine gelinmektedir.

# Peki Yapılması Gerekenler Neler?
BIND riskleri bazı koruma önlemleri ile azaltılabilir:
* 1) **İzolasyon Kaynakları:** İnternet DNS’i için adanmış, sağlamlaştırılmış sunucular kullanın ve diğer servisler ile paylaşmayın ve özellikle kullanıcı girişlerine izin vermeyin. Minimal sayıdaki kullanıcı çalışan programların ve akabinde internet saldırılarının azalması anlamına gelir. Ayrılma yerel zaafiyetleri kullanan diğer servislerin ve kullanıcıların BIND’e saldırmalarını önler.
* 2) **Fazlalık:** Başka bir internet bağlantısına ikincil bir yükleme yapın (şirketinizin yabancı bir şubesi, başka bir ISP v.b.). Eğer siteniz ölürse, en azından diğer siteler "varoluşu durdurduğunuzu" sanmaz; sadece sizin "müsait" olmadığınızı  ve böylece e-postaların bekletildiğini anlar (genellikle 4 günlük süre ile).
* 3) En son versiyonu kullanın.
* 4) **Giriş Kontrolü:** Ağınızda saldırıya açık olan veri miktarını azaltmak için alan değişimlerini kısıtlayın. İşlem imzası (TSIG) kullanmayı ve özyinelemeli sorguları kısıtlamayı düşünün.
* 5) **BIND’I en az ayrıcalık ile çalıştırın:** temel olmayan bir kullanıcı olarak, sıkı bir **umask** ile.
* 6) **Daha fazla izolasyon kaynakları:** BIND’i "chroot" kafesi ile çalıştırın, böylece bir BIND şeytanı için işletim sistemine zarar vermek ve diğer servisleri kötüye kullanmak daha da zor olur. 
* 7) BIND’i versiyon numarasını rapor etmemesi için ayarlayın. (aşağıda belirtilecek). Bazı insanlar bunun bir "gizlilik güvenliği" olduğu için versiyon numarasının gizlenmesine inanmayacak, ama bunun internette dolanıp açık hedef arayan çocuklara karşı işe yarayacağına eminim. Profesyonellere karşı korunma farklı bir konu.
* 8) **Keşif:** Monitör bütünlük denetleyicisi ile beklenmedik aktiviteler ve sistemdeki yetkisiz değişiklikler için keşif yapar.
* 9) Gözünüz uygun danışmalarda olsun, gelecek BIND problemlerinden güncel şekilde haberdar edildiğinizden emin olun.

# BIND8 ve BIND9’daki Farklılıklar
Çok işlemcili olma ve yeniden yazılmış kodların dolayısıyla daha stabil ve uzun dönem güvenlik vaad etmesi dışında başka farklılıkları da bulunuyor;
* Eğer named.conf’da bir yazım hatası olursa, BIND9 hatları bulur ve sunucuyu yenilemez. BIND hataları bulur ve şeytan ölür! 
* Ulaşım kontrolü için TSIG’in kapsamlı desteği (paylaşılan anahtarlar), mesela  "güncelleme poliçesi" dinamik güncellemelerde daha iyi öğütülmüş bir ulaşım kontrolü için kullanıla bilir.
* Başlama/durdurma/yeniden yükleme ve s. için olan araç, rndc ile v8 ndc arasında haberleşme, belgeleme ve diğer özelliklerde farklılıklar vardır.  Rndc kesitine bakınız.
* Bölge dosyalarındaki sentaks daha titizlikle denetlenir. (örneğin TTL satırı olmak zorunda)
* named.conf’ta:
  * v8’deki 'check-names' ve 'statistics-interval' seçenekleri v9’da henüz tamamlanmamıştır.
  * 'auth-nxdomain' için varsayılan seçenek şimdi 'no'dur. Eğer manüel olarak ayarlamazsanız, BIND 9 başlangıçta eş anlamlı bir mesaj keşfeder.
  * Kök sunucu listesi, BIND8’de named.root veya root.hints olarak ta bilinir, sunucunun içerisinde yer alsa bile BIND 9’da gerekli değildir.
  * [11]’e de bakın.
 
# BIND’in Kurulumu ve Yapılandırılması
Solarisin iyi çalıştığı ve yeteri kadar sağlamlaştırıldığı ve birlikte gelen BIND’in aktif olmadığı farzedilir. Eğer hala Solarisi sağlamlaştırmadıysanız, ilk once Jass’ı control edin [7]. Bu bölüm bunlarla çalışır:
* Sağlamlaştırılmış bir DNS sunucunuz olmadığı için BIND’i bir uzman ev sahibine derleyin.
* BIND’i bir DNS sunucusuna kurun.
* Ayarlayın ve BIND’i çalıştırın.

## 1. BIND’in Derlenmesi ( derleyici ev sahibine )
Dağılımı indirin [1], onu subdirectorye çıkarın ve derleyin. Bu işlem kök kullanıcı olmayarak ta yapıla bilir.
* Önkoşullar: 
İlk olarak 'GNU make'i kurun, böylece altdaki rehbere geçici kurlumunuz doğru bir şekilde çalışır.
Ayrıca aşağıda  /usr/local/bin/make’e başvuruyoruz, Solarisin standart /usr/ccs/bin/make’e değil. 
Standart Solaris yacc’ın yeterli olmasına rağmen GNU bison’a eski test sistemimde ihtiyaç vardı. 
**GNU grep v9.5.1’e yükseltme için gerekti** 
SSL kütüphanesinin son versiyonunun kurulması gerek. Eğer SSL kütüphaneleri eski olursa BIND bundan hoşnut olmaz (eski versiyonların güvenlik zaafları mevcut). 
Yukarıdakiler için paketler SunFreeware.com’dan kolayca kurulabilir, mesela: 

  ```    
  wget ftp://ftp.sunfreeware.com/pub/freeware/sparc/8/grep-2.5.1a-sol8-sparc-local.gz
  gunzip grep-2.5.1a-sol8-sparc-local.gz
  pkgadd -d grep-2.5.1a-sol8-sparc-local
  ```
  
Yeni grep-i kurduktan sonra  'make'in bulmasından emin olun:
    	```
    	export GREP=/usr/local/bin/grep
    	```
* BIND 9.1.0’in sürüm notunda çok işlemliliğin Solaris 2.6-da bazı problemler yaratacağı not edilmiştir, bu yüzden çok işlemci desteği olmadan derlemeyi gerçekleştiriyoruz:
     ```
      ./configure --disable-threads
     ```
  
* Solaris 7/8’de çok işlemciyi active ede biliriz:
```      
./configure
```
     Şimdi ise GNU make’i kullanarak derleye biliriz:
     
     ```
      /usr/local/bin/make
     
     ```
     
    Şimdi kök hesabı değişin, onu geçici rehbere kurun ve ‘tarball’ yaratın:
    
       ```
       su - root
       #allow group, but not world access
       umask 027
       /usr/local/bin/make install DESTDIR=/tmp
       cd /tmp/usr/local
       strip bin/* sbin/* lib/*
       \rm -rf include
       tar cf - * | compress > bind9_dist.tar.Z
       ```
  
Daha sonra, bind9_dist.tar.Z’i daha güvenli bir yere taşıyın, /tmp/usr-i kaldırın ve BIND’i derlediğiniz rehberi temizleyin.
**Belgeleme:**
Yönetici Rehberi(html formatında) dağılıma doc/arm/Bv9ARM.html’de dahil edilmiştir ve okumakta yarar vardır. İnsanlar için olan sayfalar da mevcut fakat onları Solaris’e kurmak hayli zordur. Bir sonraki sürüm olan v9.2’de insan sayfaları düzgün bir şekilde kurulmalıdır, bu sayfalar metin şeklinde mevcuttur [9].

## 2. Chroot’un ayarlanması ve BIND’in kurulumu (hedef sisteme)
Sonraki adımlar C-Shell kullanımını anlatıyor. Biz buna chroot ortam (kafes) lokasyonunu değişken olarak tanımlamakla başlıyoruz ve akabinde umask’i ayarlıyoruz ve böylece bütün kopyalanmış dosyalar hem gruplar hem de dünya tarafından okunabilir. Bu komutalar kopyalanmak ve yapıştırılmak üzere tasarlanmıştır.
* Chroot jail için hedef dizinlerini ayarlayın, herşey bu ağacın alt dizinlerie kurulacak.

```
      csh
      unset noclobber
      set jail='/home/dns';
      umask 022;
      ```
      
* Boş dizinleri ve bağlantıları chroot environment için ayarlayın:

     ```
     mkdir $jail;
     /dns-ten jail-e bir bağlantı yaratın, hayatı kolaylaştırmak için bu makalede "/dns" chroot ağacının en tepesi olarak kabul edilecektir.
     rm /dns
     ln -s $jail /dns
     cd /dns;
     mkdir -p {dev,opt,usr,var,etc};
     mkdir -p var/{run,log,named} usr/lib;
     mkdir -p usr/local/etc
     mkdir -p usr/share/lib/zoneinfo;
     ```
     
* Hesaplar:
BIND için bir kullanıcı ve grup hesabı yaratın,
```
groupadd named;
useradd -d /dns -s /bin/false -g named -c "BIND daemon" -m named
Chroot içinde aynı kullanıcı ve grup hesabı oluşturun:
grep named /etc/passwd >> /dns/etc/passwd
grep named /etc/shadow >> /dns/etc/shadow
grep named /etc/group >> /dns/etc/group
BIND hesabının ftp kullanmasına izin vermeyin:
echo "named" >> /etc/ftpusers
Add /dns/usr/local/bin to the root PATH in /root/.cshrc or /root/.profile.
```

* BIND dağılımını kurun – ilk önce dizini tarball-ın yerleşkesine değişin:

```
    cp bind9_dist.tar.Z /dns/usr/local;
    cd /dns/usr/local;
    zcat bind9_dist.tar.Z| tar xvf -
    ```
    
* chroot ortamı için gerekli system dosyalarını kopyalayın

```
   cp /etc/{syslog.conf,netconfig,nsswitch.conf,resolv.conf,TIMEZONE} /dns/etc
   ```
   
* Obje kütüphanelerinin ne paylaştığını görmek için ldd kullanın:
```
ldd /dns/usr/local/sbin/named
```

* ldd ile listelenen dosyaları kopyalayın, mesela Solaris 8’de:

```
cp -p /usr/lib/libnsl.so.1  \
/usr/lib/libsocket.so.1 /usr/lib/libc.so.1 \
/usr/lib/libthread.so.1 /usr/lib/libpthread.so.1 \
/usr/lib/libdl.so.1 /usr/lib/libmp.so.2 \
/usr/lib/ld.so.1 /usr/lib/nss_files.so.1 \
/usr/platform/SUNW,UltraAX-i2/lib/libc_psr.so.1 \
/dns/usr/lib
```

Solaris 2.6:

```
cp -p /usr/lib/libnsl.so.1 \
/usr/lib/libsocket.so.1 /usr/lib/libc.so.1 \
/usr/lib/libdl.so.1 /usr/lib/libmp.so.2 /dns/usr/lib
```

Solaris 2.6 UltraSPARC’da ldd aynı zamanda bunları da gerekli bilip listeler:

```
cp /usr/platform/SUNW,Ultra-250/lib/libc_psr.so.1  /dns/usr/lib
```

Deneyimler bunların da gerekli olduğunu göstermiştir:

```
cp /usr/lib/ld.so.1 /usr/lib/nss_files.so.1 /dns/usr/lib
```

("deneyim" ilk girişimlerin başarısız olduğu demektir, ama truss ile çalışan  BIND kütüphanenin neyi aradığını anlaya bilir.)
Timezone dosyalarını kopyalayın (mesela MET, burada Avrupa):

```
mkdir -p /dns/usr/share/lib/zoneinfo;
cp -p /usr/share/lib/zoneinfo/MET /dns/usr/share/lib/zoneinfo/MET
```

İletişim araçlarını kurun( konsol, syslog).
 
 ```
    cd /dns/dev
    mknod tcp c 11 42
    mknod udp c 11 41
    mknod log c 21 5
    mknod null c 13 2
    mknod zero c 13 12
    chgrp sys null zero
    chmod 666 null

    mknod conslog c 21 0
    mknod syscon c 0 0
    chmod 620 syscon
    chgrp tty syscon
    chgrp sys conslog
 ```
 
Bind v9.5.1 için /dev/poll oluşturun

```
   cd /dns/dev 
   mknod poll c 138 0 
   chgrp sys random
   chmod 644 random
```
Yerel syslog mesajları için opsiyoneldir: Syslog için bir döngü yaratın. Ben bunu gerekli bulmuyorum ama bir okuyucu bunu öneriyor:

```
mkdir /dns/etc/.syslog_door
mount -F lofs /etc/.syslog_door /dns/etc/.syslog_door
```

Solaris 8/9’da, /dev/random-a ulaşım /dns jail’a döngü oluşturarak temin edile bilir (ben bunu tarihi nedenlerden dolayı kullanıyorum...):

   ```
   mkdir /dns/dev/random
   mount -F lofs /dev/random /dns/dev/random
   veya DNS jail-in içinde bir cihaz yaratarak (önce cari minor/major cihaz numarasına bakılması gerek ls -al /devices/pseudo/random\@0\:random):
   cd /dns/dev
   mknod random c 240 0
   chgrp sys random
   chmod 644 random
   ```
 
DNS verisi için dizin oluşturun; bunun /var/named’de olduğunu varsayalım:

```
mkdir -p /dns/var/named;

```


