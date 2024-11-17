<?php
include '../connect.php';

try {
    // Get the POST data
    $name = $_POST['name'];
    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $phone = $_POST['phone'];

    // Validate the input data
    if (!isset($_POST['email'])) {
        throw new Exception("All fields are required", 1);
    } else if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        throw new Exception("Invalid email address", 1);
    }

    // Check if email already exists
    $checkQuery = "SELECT * FROM tbl_patient WHERE email='$email'";
    $checkResult = $connect->query($checkQuery);

    if ($checkResult->num_rows > 0) {
        throw new Exception("Email already exists", 1);
    }

    // Hash the password
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // Insert new user into tbl_patient
    $insertQuery = "INSERT INTO tbl_patient (name, username, email, password, phone, terms_accepted, created_at, updated_at) 
                    VALUES (?, ?, ?, ?, ?, 1, NOW(), NOW())";

    if ($stmt = $connect->prepare($insertQuery)) {
        $stmt->bind_param("sssss", $name, $username, $email, $hashedPassword, $phone);
        if (!$stmt->execute()) {
            throw new Exception("Error: " . $connect->error, 1);
        }
        $userId = $stmt->insert_id;
        $stmt->close();

        // Fetch the newly created user's data
        $userQuery = "SELECT * FROM tbl_patient WHERE id=?";
        if ($stmt = $connect->prepare($userQuery)) {
            $stmt->bind_param("i", $userId);
            $stmt->execute();
            $userResult = $stmt->get_result();
            $stmt->close();

            if ($userResult->num_rows == 1) {
                $user = $userResult->fetch_assoc();
                $response = array(
                    "status" => "success",
                    "message" => "Signup successful",
                    "user" => array(
                        "id" => $user['id'],
                        "name" => $user['name'],
                        "username" => $user['username'],
                        "phone" => $user['phone'],
                        "email" => $user['email'],
                        "terms_accepted" => $user['terms_accepted'],
                        "created_at" => $user['created_at'],
                        "updated_at" => $user['updated_at'],
                    )
                );
                echo json_encode($response);
            } else {
                throw new Exception("Error fetching user data after signup", 1);
            }
        } else {
            throw new Exception("Error preparing query", 1);
        }
    } else {
        throw new Exception("Error: " . $connect->error, 1);
    }
} catch (Exception $e) {
    $response = array("status" => "error", "message" => $e->getMessage());
    echo json_encode($response);
}