<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
$host = 'localhost';
$db   = 'fridgemasters';
$user = 'admin';
$pass = '';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$pdo = new PDO($dsn, $user, $pass);

$data = json_decode(file_get_contents("php://input"));
if(isset($data->username) && isset($data->password)){
    // Check both Username and Email columns
    $stmt = $pdo->prepare('SELECT * FROM Users WHERE Username = ? OR Email = ?');
    $stmt->execute([$data->username, $data->username]);
    $user = $stmt->fetch();

    if($user && password_verify($data->password, $user["Password"])){
        echo json_encode(["success" => true, "message" => "Login successful"]);
    } else {
        echo json_encode(["success" => false, "message" => "Invalid credentials"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid request"]);
}
?>
