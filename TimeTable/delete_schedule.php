<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/dbcon.php';

// Get POST data
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['schedule_id'])) {
    echo json_encode([
        'success' => false,
        'message' => 'Schedule ID is required'
    ]);
    exit;
}

$schedule_id = intval($data['schedule_id']);

try {
    $stmt = $conn->prepare("DELETE FROM schedules WHERE id = ?");
    $stmt->bind_param("i", $schedule_id);
    
    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            echo json_encode([
                'success' => true,
                'message' => 'Schedule deleted successfully'
            ]);
        } else {
            echo json_encode([
                'success' => false,
                'message' => 'Schedule not found'
            ]);
        }
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Failed to delete schedule'
        ]);
    }
    
    $stmt->close();
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}

$conn->close();
?>