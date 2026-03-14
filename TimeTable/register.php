<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/dbcon.php';

// Get POST data
$data = json_decode(file_get_contents("php://input"), true);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = $data['name'] ?? '';
    $email = $data['email'] ?? '';
    $password = $data['password'] ?? '';
    
    // Validation
    if (empty($name) || empty($email) || empty($password)) {
        echo json_encode([
            'success' => false,
            'message' => 'All fields are required'
        ]);
        exit;
    }
    
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode([
            'success' => false,
            'message' => 'Invalid email format'
        ]);
        exit;
    }
    
    if (strlen($password) < 6) {
        echo json_encode([
            'success' => false,
            'message' => 'Password must be at least 6 characters'
        ]);
        exit;
    }
    
    // Check if email already exists
    $stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        echo json_encode([
            'success' => false,
            'message' => 'Email already exists'
        ]);
        exit;
    }
    
    // Hash password
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);
    
    // Insert user
    $stmt = $conn->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $name, $email, $hashed_password);
    
    if ($stmt->execute()) {
        $user_id = $conn->insert_id;
        echo json_encode([
            'success' => true,
            'message' => 'Registration successful',
            'user' => [
                'id' => $user_id,
                'name' => $name,
                'email' => $email
            ]
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Registration failed'
        ]);
    }
    
    $stmt->close();
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid request method'
    ]);
}

$conn->close();
?>