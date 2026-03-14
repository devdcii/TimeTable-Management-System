<?php
// add_task.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/dbcon.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!$data || empty($data['user_id']) || empty($data['task_name'])) {
        echo json_encode(['success' => false, 'message' => 'Missing required fields']);
        exit;
    }
	
    $user_id = $data['user_id'];
    $task_name = $data['task_name'];
    $subject_name = $data['subject_name'] ?? null;
    $description = $data['description'] ?? null;
    $due_date = $data['due_date'] ?? null;

    try {
        $sql = "INSERT INTO tasks (user_id, task_name, subject_name, description, due_date, is_completed, created_at) 
                VALUES (?, ?, ?, ?, ?, 0, NOW())";
        
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('issss', $user_id, $task_name, $subject_name, $description, $due_date);

        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Task added successfully']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to add task']);
        }
        $stmt->close();
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => $e->getMessage()]);
    }
    $conn->close();
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}
?>