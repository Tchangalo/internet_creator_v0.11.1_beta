# **Spezielle Probleme des INC on Gunicorn**

Obwohl sämtliche Skripte im wesentlichen korrekt ausgeführt werden - das System also fast
vollständig funktional zu sein scheint - gibt es im Backend regelmäßig folgende Fehlermeldungen,
die Verbindungsabbrüche anzeigen:
```
9 RLock(s) were not greened, to fix this error make sure you run
eventlet.monkey_patch() before importing any other
modules.
server=192.168.10.14:32100//socket.io/ client=192.168.10.3:44112 socket
shutdown error: [Errno 9] Bad file descriptorClient disconnected
Invalid session yZzWpCc_PuZOH4_QAAAA (further occurrences of this error will
be logged with level INFO)
```

Die Fehlermeldungen treten auf, obwohl der Standartfix dafür angewendet wurde, nämlich
```
import eventlet
eventlet.monkey_patch()
```

ganz an den Anfang des inc.py Skripts zu setzen und den Startbefehl:
```
gunicorn --worker-class eventlet -w 1 -b 0.0.0.0:32100 app:app
```
zu
```
EVENTLET_HUB=poll gunicorn --worker-class eventlet -w 2 -b 0.0.0.0:32100 --timeout 120 --graceful-timeout 30 app:app
```
zu erweitern. Auch andere Versuche, wie ```eventlet``` durch ```gevent``` zu ersetzen oder den ```proxy.py```
Server als Reverse Proxy zwischenzuschalten, haben die Fehlermeldungen nicht beseitigt.

Der Gunicorn-Server bzw. das Eventlet-Modul scheinen sich mit socketio von Flask nicht ganz zu
vertragen.
