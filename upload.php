<?php
require 'dbconnection.php';

if(isset($_POST["submit"])){
  // Retrieve form data
  $name = $_POST['name'];
  $description = $_POST['description'];
  $price = $_POST['price'];

  // Process image files
  $totalFiles = count($_FILES['fileImg']['name']);
  $filesArray = array();

  for($i = 0; $i < $totalFiles; $i++){
    $imageName = $_FILES["fileImg"]["name"][$i];
    $tmpName = $_FILES["fileImg"]["tmp_name"][$i];

    $imageExtension = explode('.', $imageName);
    $imageExtension = strtolower(end($imageExtension));

    $newImageName = uniqid() . '.' . $imageExtension;

    move_uploaded_file($tmpName, 'uploads/' . $newImageName);
    $filesArray[] = $newImageName;
  }

  // Encode image file names as JSON
  $filesArray = json_encode($filesArray);

  // Insert data into the database
  $query = "INSERT INTO room (name, description, price, image) VALUES ('$name', '$description', '$price', '$filesArray')";
  mysqli_query($conn, $query);

  // Redirect to index.php after successful insertion
  echo "<script>alert('Successfully Added'); document.location.href = 'index.php';</script>";
}
?>

<html>
  <head></head>
  <body>
    <form action="" method="post" enctype="multipart/form-data">
      Name: <input type="text" name="name" required> <br>
      Description: <input type="text" name="description" required> <br>
      Price: <input type="number" name="price" step="0.01" min="0" required> <br>
      Image: <input type="file" name="fileImg[]" accept=".jpg, .jpeg, .png" required multiple> <br>
      <button type="submit" name="submit">Submit</button>
    </form>
    <br>
    <a href="index.php">Index</a>
  </body>
</html>
