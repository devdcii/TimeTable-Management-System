<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/dbcon.php';

// Get POST data
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['user_id'])) {
    echo json_encode([
        'success' => false,
        'message' => 'User ID is required'
    ]);
    exit;
}

$user_id = intval($data['user_id']);

try {
    $stmt = $conn->prepare("SELECT id, subject_name, day_of_week, start_time, end_time, room_number, teacher_name FROM schedules WHERE user_id = ? ORDER BY day_of_week, start_time");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $schedules = [];
    while ($row = $result->fetch_assoc()) {
        $schedules[] = $row;
    }
    
    echo json_encode([
        'success' => true,
        'schedules' => $schedules
    ]);
    
    $stmt->close();
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Failed to fetch schedules: ' . $e->getMessage()
    ]);
}

$conn->close();
?>