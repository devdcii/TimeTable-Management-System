<?php
// get_tasks.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

require_once 'config/dbcon.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $user_id = $_GET['user_id'] ?? null;

    if (!$user_id) {
        echo json_encode(['success' => false, 'message' => 'Missing user_id']);
        exit;
    }

    try {
        $sql = "SELECT id, user_id, task_name, subject_name, description, due_date, is_completed, created_at 
                FROM tasks 
                WHERE user_id = ? 
                ORDER BY due_date ASC, created_at DESC";
        
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('i', $user_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $tasks = [];
        while ($row = $result->fetch_assoc()) {
            $tasks[] = $row;
        }

        echo json_encode(['success' => true, 'data' => $tasks]);
        $stmt->close();
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => $e->getMessage()]);
    }
    $conn->close();
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}
?>
