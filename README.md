# ScandTest

## В двух словах про решение

по условию не совсем понятно было, нужно ли реализовывать вообще админское мобильное приложение или нет, были длинные выходные и чтобы не беспокоить людей, я решил сделать и клиентское и админское приложение, однако чтобы не скакать между таргетами они представлены одним приложением с двумя вкладками, каждая из вкладок абсолютно независима  от другой.
в репозитории есть все что нужно чтобы собрать приложение и оно работало.

## Условия задания

Реализовать Proof of Concept e-сommerce решения.
Оно должно содержать:
<details>
<summary>1) Удаленная (remote, доступная для всех клиентов с любого устройства) база товаров с возможностью ее редактировать продавцом.</summary>
  
  [создана на основе FireBase Firestore](/ScandTest/Model/Networking/Implementations/FirestoreProductNetworkManager.swift). Выглядит в консоли следующим образом:
  
  ![image](https://github.com/vasilevsky007/ScandTest/assets/72131827/7b5aa460-786f-4e10-b583-62566dc0f2a5)

  функционал по редактированию представлен [кастомным TableViewController](/ScandTest/Controller/Tables/AdminProductDBTableViewController.swift)
  записи можно удалять с помощью жеста свайпа справа налево. добавление записи реализовано в первой ячейке, которая является пустой и по нажалии кнопки Add добавляет новый продукт в  базу данных. уже сужествующие продукты можно редактировать ниже, просто изменяя их поля, и нажав на кнопку save, что сохранит изменения в базе данных

![image](https://github.com/vasilevsky007/ScandTest/assets/72131827/8ba00029-0e7b-464a-9f0d-88fad6f08cca)


</details>
<details>
<summary>2) Объект товара содержит как минимум название, фото, описание и цену.</summary>
  
  [описан с помощью структуры](/ScandTest/Model/Entities/Product.swift)
  
</details>
<details>
<summary>3) Мобильный клиент загружает и показывает список товаров с фото и ценой.
  По нажатию на товар показывается его полное описание и кнопка "Купить".
  "Купить" открывает новый экран, где можно ввести контактные данные и отправить информацию о заказе в магазин менеджеру.</summary>

<details>
  <summary>a)Мобильный клиент загружает и показывает список товаров с фото и ценой.</summary>

  [отображается с помощью UICollectionView. Для обновления списка используется стандартный UIRefreshControl](/ScandTest/Controller/UserViewController.swift)

![image](https://github.com/vasilevsky007/ScandTest/assets/72131827/fbd5da31-a857-433a-8ae3-e6045215e59e)

</details>
<details>
  <summary>б)По нажатию на товар показывается его полное описание и кнопка "Купить"</summary>

  используется .sheetPresentationController для показа [данного модального окна.](/ScandTest/Controller/Modals/ProductSheet.swift) может быть показано как на пол экрана так и на весь экран

![image](https://github.com/vasilevsky007/ScandTest/assets/72131827/46ef93b8-fc4e-4f6c-86cc-f3a63f41e2dd)

</details>

<details>
  <summary>в)"Купить" открывает новый экран, где можно ввести контактные данные и отправить информацию о заказе в магазин менеджеру.</summary>

  используется NavigationController для навигации.
  открывается  [отдельное View для предоставления дополнительной информации о заказе.](/ScandTest/Controller/Modals/OrderViewController.swift)
  
  вся информация о пользователе сохраняется для повторного использования в Core Data с помошью [класса](/ScandTest/Model/Storage/Implementations/CoreDataUserCacher.swift) 
  
![image](https://github.com/vasilevsky007/ScandTest/assets/72131827/ba85855f-fcec-416a-9a13-d1342b06cc96)

для храниения заказов [изпользуется Firebase Realtime Database](/ScandTest/Model/Networking/Implementations/FirebaseRTDBOrderNetworkMananger.swift).
Вот как оно выглядит в консоли:

![image](https://github.com/vasilevsky007/ScandTest/assets/72131827/4a5a1966-7b12-4776-a5d7-039b030ef898)

За счет использования Realtime Database, нам не нужно вручную обновлять вью чтобы увидеть новые заказы. В этом можно убедится открыв админское приложение на одном устройстве, и отправив заказ с другогою. он сразу же отобразиться на первом устройстве. Заказы отображаются с помощью UITableView, отфильрованные по времени в админском приложении следующим образом:

![image](https://github.com/vasilevsky007/ScandTest/assets/72131827/c27908f0-f358-478d-a770-95083ab432d2)

</details>

</details>
<details>
<summary>4) В качестве бэкенд и удаленной БД использовать Firebase сервисы. </summary>

для базы данных товаров используется Fibrebase Firestore, для хранения заказов используется Firebase Realtime Database, для аутентификации администраторов используется Firebase Auth
  
</details>
<details>
<summary>5) Фото товаров кэшировать</summary>
  
  загрузка фото происходит при помощи [класса](/ScandTest/Model/Networking/Implementations/ImageFetcher.swift). при использовании хакэшированной версии изображения об этом выводится сообщение в консоль. изображения кэшируются как в озу с помошью словаря для более быстрой работы, так и в отдельную сущность в Core Data для хранения хэша между запусками. имплементирован метод для удаления всего кэша из Core Data для очистки памяти, но он не вызыввется, это можно было бы вызывать например из настроек приложения где оно бы чистило весь кэш.
  
</details>
<details>
<summary>6) Информацию о товаре (фото + краткое описание + цена) можно из приложения выслать (реализация на усмотрение кандидата) у на почту или мессенжеры</summary>
  
  использован стандартный UIActivityViewController, в который помещается строка содержащая имя товара, цену и описание, а также фото товара и условная ссылка на интернет магазин вида "https://www.your-website.com/productbyid/(product.id)" где product.id - это идентификатор товара в базе данных, так что сайт тоже естественно базирующийся на Firebase мог бы его легко найти. Пример использования ниже (проверял много где, везде работает, кроме телеграмма хд, у них видимо неправильно написан обработчик активити, в котором нескольтко айтемов) :

![image](https://github.com/vasilevsky007/ScandTest/assets/72131827/981e2344-c22e-481b-ac44-09b695d549f9)

![image](https://github.com/vasilevsky007/ScandTest/assets/72131827/a78fe6ca-df29-408f-82ce-880e8f8266c6)

![image](https://github.com/vasilevsky007/ScandTest/assets/72131827/c2722396-49bb-4e83-9f4e-2ce675aa423e)


</details>
