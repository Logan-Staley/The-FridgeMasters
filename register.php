<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    header("HTTP/1.1 200 OK");
    exit;
}

$host = 'localhost';
$db   = 'fridgemasters';
$user = 'admin';
$pass = '';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$pdo = new PDO($dsn, $user, $pass);

$data = json_decode(file_get_contents("php://input"));

if(isset($data->username) && isset($data->email) && isset($data->password)){
    // Check if any of the fields are empty
    if(empty($data->username) || empty($data->email) || empty($data->password)) {
        echo json_encode(["success" => false, "message" => "All fields are required"]);
        exit;
    }

    // Check if email already exists
    $stmt = $pdo->prepare('SELECT * FROM Users WHERE Email = ?');
    $stmt->execute([$data->email]);
    $user = $stmt->fetch();
    if ($user) {
        echo json_encode(["success" => false, "message" => "Account already exists"]);
        exit;
    }

    // Check if username already exists
    $stmt = $pdo->prepare('SELECT * FROM Users WHERE Username = ?');
    $stmt->execute([$data->username]);
    $user = $stmt->fetch();
    if ($user) {
        echo json_encode(["success" => false, "message" => "Username is already taken"]);
        exit;
    }

    // If neither email nor username exists, proceed with registration
    $hashedPassword = password_hash($data->password, PASSWORD_DEFAULT);
    $stmt = $pdo->prepare('INSERT INTO Users (Username, Email, Password) VALUES (?, ?, ?)');
    if($stmt->execute([$data->username, $data->email, $hashedPassword])) {
        echo json_encode(["success" => true, "message" => "User registered successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Registration failed"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid data provided"]);
}
?>
