<?php
// update_task.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/dbcon.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!$data || empty($data['task_id']) || empty($data['task_name'])) {
        echo json_encode(['success' => false, 'message' => 'Missing required fields']);
        exit;
    }

    $task_id = $data['task_id'];
    $task_name = $data['task_name'];
    $subject_name = $data['subject_name'] ?? null;
    $description = $data['description'] ?? null;
    $due_date = $data['due_date'] ?? null;

    try {
        $sql = "UPDATE tasks 
                SET task_name = ?, subject_name = ?, description = ?, due_date = ? 
                WHERE id = ?";
        
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('ssssi', $task_name, $subject_name, $description, $due_date, $task_id);

        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Task updated successfully']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to update task']);
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