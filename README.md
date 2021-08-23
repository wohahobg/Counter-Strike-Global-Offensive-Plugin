# w-store-csgo-plugin
Това е официалният плъгин на W-STORE.ORG за играта CS:GO
# W-Store-Plugin
Тук се намират офицялните плъгини за W-Store CS 1.6 и Minecraft

<h4>Как работи този плъгин ?</h4>
<p>Нашият плъгин ще проверява за нови заявки на 1 от до 5 минути</p>
<hr>
<h4>Как да инсталираме правилно WStore плъгина.</h4>
<ol>
  <li>Генерирате <b>Server Key</b> от <a href="https://panel.w-store.org/servers/" target="_blank" rel="noopener">Управление &gt; Списък със сървъри</a></li>
  <li>Слагате плъгина всичко от zip файла във вашият cs:go сървър.</li>
  <li>Добавяне универслният Server Key в /csgo/cfg/server.cfg . Като трябва да създадете нов ред с sm_wstore_key "ВАШИЯТ УНИВЕРСАЛЕН СЪРВАР ТОКЕН"</li>
  <li>Добавяте запис в базата данни към /ddons/sourcemod/databases.cfg с името с името "adminbytime". Пример: 
   <br>
   <p>
      "adminbytime"
          {
              "driver"            "sqlite"
              "database"            "adminbytime"
          }
    </p>
   </li>
</ol>

<hr>
Желателно е да изпозлвате един Server Key единствено за един сървър. Ако желате да изпозлвате плъгина в няколко сървъра , препоръчваме ви да генерирате нов отделен Server Key за всеки сървър.
Ако имате допълнители въпроси моля свържете се с нас.
