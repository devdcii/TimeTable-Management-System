<?php
// delete_task.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/dbcon.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!$data || empty($data['task_id'])) {
        echo json_encode(['success' => false, 'message' => 'Missing task_id']);
        exit;
    }

    $task_id = $data['task_id'];

    try {
        $sql = "DELETE FROM tasks WHERE id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('i', $task_id);

        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Task deleted successfully']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to delete task']);
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