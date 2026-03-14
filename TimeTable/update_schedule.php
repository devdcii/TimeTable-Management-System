<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/dbcon.php';

// Get POST data
$data = json_decode(file_get_contents('php://input'), true);

// Validate required fields
if (!isset($data['schedule_id']) || !isset($data['user_id']) || 
    !isset($data['subject_name']) || !isset($data['day_of_week']) || 
    !isset($data['start_time']) || !isset($data['end_time'])) {
    echo json_encode([
        'success' => false,
        'message' => 'Missing required fields'
    ]);
    exit;
}

$schedule_id = intval($data['schedule_id']);
$user_id = intval($data['user_id']);
$subject_name = trim($data['subject_name']);
$day_of_week = trim($data['day_of_week']);
$start_time = trim($data['start_time']);
$end_time = trim($data['end_time']);
$room_number = isset($data['room_number']) ? trim($data['room_number']) : null;
$teacher_name = isset($data['teacher_name']) ? trim($data['teacher_name']) : null;

// Validate data
if (empty($subject_name)) {
    echo json_encode([
        'success' => false,
        'message' => 'Subject name cannot be empty'
    ]);
    exit;
}

$valid_days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
if (!in_array($day_of_week, $valid_days)) {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid day of week'
    ]);
    exit;
}

try {
    // Verify schedule belongs to user
    $verify_stmt = $conn->prepare("SELECT id FROM schedules WHERE id = ? AND user_id = ?");
    $verify_stmt->bind_param("ii", $schedule_id, $user_id);
    $verify_stmt->execute();
    $verify_result = $verify_stmt->get_result();
    
    if ($verify_result->num_rows === 0) {
        echo json_encode([
            'success' => false,
            'message' => 'Schedule not found or unauthorized'
        ]);
        $verify_stmt->close();
        $conn->close();
        exit;
    }
    $verify_stmt->close();
    
    // Check for time conflicts (excluding current schedule)
    $check_stmt = $conn->prepare("
        SELECT id FROM schedules 
        WHERE user_id = ? 
        AND day_of_week = ? 
        AND id != ?
        AND (
            (start_time <= ? AND end_time > ?) OR
            (start_time < ? AND end_time >= ?) OR
            (start_time >= ? AND end_time <= ?)
        )
    ");
    $check_stmt->bind_param("isissssss", $user_id, $day_of_week, $schedule_id, $start_time, $start_time, $end_time, $end_time, $start_time, $end_time);
    $check_stmt->execute();
    $check_result = $check_stmt->get_result();
    
    if ($check_result->num_rows > 0) {
        echo json_encode([
            'success' => false,
            'message' => 'Schedule conflicts with an existing class'
        ]);
        $check_stmt->close();
        $conn->close();
        exit;
    }
    $check_stmt->close();
    
    // Update schedule
    $stmt = $conn->prepare("UPDATE schedules SET subject_name = ?, day_of_week = ?, start_time = ?, end_time = ?, room_number = ?, teacher_name = ? WHERE id = ? AND user_id = ?");
    $stmt->bind_param("ssssssii", $subject_name, $day_of_week, $start_time, $end_time, $room_number, $teacher_name, $schedule_id, $user_id);
    
    if ($stmt->execute()) {
        echo json_encode([
            'success' => true,
            'message' => 'Schedule updated successfully'
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Failed to update schedule'
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