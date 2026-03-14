<?php
// toggle_task_complete.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/dbcon.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!$data || empty($data['task_id']) || !isset($data['is_completed'])) {
        echo json_encode(['success' => false, 'message' => 'Missing required fields']);
        exit;
    }

    $task_id = (int)$data['task_id'];
    $is_completed = $data['is_completed'] ? 1 : 0;

    try {
        $sql = "UPDATE tasks SET is_completed = ? WHERE id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('ii', $is_completed, $task_id);

        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Task status updated']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to update task status']);
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