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

# 1. BIND’in Derlenmesi ( derleyici ev sahibine )




