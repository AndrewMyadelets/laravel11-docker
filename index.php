<?php
$host = 'mysql';
$db   = 'laravel_db';
$user = 'root';
$pass = 'password';

$ip = gethostbyname($host);

if ($ip === $host) {
    echo "<h1>Ошибка DNS!</h1>";
    echo "<p>Контейнер PHP не знает, кто такой '$host'. Попробуй перезапустить докер.</p>";
} else {
    echo "<p>DNS работает! Хост '$host' имеет IP: $ip</p>";

    $dsn = "mysql:host=$host;dbname=$db;charset=utf8mb4";
    try {
        $pdo = new PDO($dsn, $user, $pass);
        echo "<h1>Успех! Подключено.</h1>";
    } catch (\PDOException $e) {
        echo "<h1>Ошибка базы:</h1>" . $e->getMessage();
    }
}